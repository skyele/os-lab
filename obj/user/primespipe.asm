
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
  800056:	68 e0 2c 80 00       	push   $0x802ce0
  80005b:	6a 15                	push   $0x15
  80005d:	68 0f 2d 80 00       	push   $0x802d0f
  800062:	e8 d7 02 00 00       	call   80033e <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 25 2d 80 00       	push   $0x802d25
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 0f 2d 80 00       	push   $0x802d0f
  800074:	e8 c5 02 00 00       	call   80033e <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 2e 2d 80 00       	push   $0x802d2e
  80007f:	6a 1d                	push   $0x1d
  800081:	68 0f 2d 80 00       	push   $0x802d0f
  800086:	e8 b3 02 00 00       	call   80033e <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 78 18 00 00       	call   80190c <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 6d 18 00 00       	call   80190c <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 20 1a 00 00       	call   801ad1 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 21 2d 80 00       	push   $0x802d21
  8000c4:	e8 6b 03 00 00       	call   800434 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 f4 24 00 00       	call   8025c5 <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 ef 13 00 00       	call   8014cf <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 1b 18 00 00       	call   80190c <close>
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
  800101:	e8 cb 19 00 00       	call   801ad1 <readn>
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
  800120:	e8 f1 19 00 00       	call   801b16 <write>
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
  80013f:	68 53 2d 80 00       	push   $0x802d53
  800144:	6a 2e                	push   $0x2e
  800146:	68 0f 2d 80 00       	push   $0x802d0f
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
  800163:	68 37 2d 80 00       	push   $0x802d37
  800168:	6a 2b                	push   $0x2b
  80016a:	68 0f 2d 80 00       	push   $0x802d0f
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
  80017b:	c7 05 00 40 80 00 6d 	movl   $0x802d6d,0x804000
  800182:	2d 80 00 

	if ((i=pipe(p)) < 0)
  800185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 37 24 00 00       	call   8025c5 <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 32 13 00 00       	call   8014cf <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 5e 17 00 00       	call   80190c <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 25 2d 80 00       	push   $0x802d25
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 0f 2d 80 00       	push   $0x802d0f
  8001c6:	e8 73 01 00 00       	call   80033e <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 2e 2d 80 00       	push   $0x802d2e
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 0f 2d 80 00       	push   $0x802d0f
  8001d8:	e8 61 01 00 00       	call   80033e <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 24 17 00 00       	call   80190c <close>

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
  8001fe:	e8 13 19 00 00       	call   801b16 <write>
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
  800220:	68 78 2d 80 00       	push   $0x802d78
  800225:	6a 4a                	push   $0x4a
  800227:	68 0f 2d 80 00       	push   $0x802d0f
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
  8002b4:	68 90 2d 80 00       	push   $0x802d90
  8002b9:	e8 76 01 00 00       	call   800434 <cprintf>
	cprintf("before umain\n");
  8002be:	c7 04 24 ae 2d 80 00 	movl   $0x802dae,(%esp)
  8002c5:	e8 6a 01 00 00       	call   800434 <cprintf>
	// call user main routine
	umain(argc, argv);
  8002ca:	83 c4 08             	add    $0x8,%esp
  8002cd:	ff 75 0c             	pushl  0xc(%ebp)
  8002d0:	ff 75 08             	pushl  0x8(%ebp)
  8002d3:	e8 9c fe ff ff       	call   800174 <umain>
	cprintf("after umain\n");
  8002d8:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  8002df:	e8 50 01 00 00       	call   800434 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8002e4:	a1 08 50 80 00       	mov    0x805008,%eax
  8002e9:	8b 40 48             	mov    0x48(%eax),%eax
  8002ec:	83 c4 08             	add    $0x8,%esp
  8002ef:	50                   	push   %eax
  8002f0:	68 c9 2d 80 00       	push   $0x802dc9
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
  800318:	68 f4 2d 80 00       	push   $0x802df4
  80031d:	50                   	push   %eax
  80031e:	68 e8 2d 80 00       	push   $0x802de8
  800323:	e8 0c 01 00 00       	call   800434 <cprintf>
	close_all();
  800328:	e8 0c 16 00 00       	call   801939 <close_all>
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
  80034e:	68 20 2e 80 00       	push   $0x802e20
  800353:	50                   	push   %eax
  800354:	68 e8 2d 80 00       	push   $0x802de8
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
  800377:	68 fc 2d 80 00       	push   $0x802dfc
  80037c:	e8 b3 00 00 00       	call   800434 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800381:	83 c4 18             	add    $0x18,%esp
  800384:	53                   	push   %ebx
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	e8 56 00 00 00       	call   8003e3 <vcprintf>
	cprintf("\n");
  80038d:	c7 04 24 ac 2d 80 00 	movl   $0x802dac,(%esp)
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
  8004e1:	e8 aa 25 00 00       	call   802a90 <__udivdi3>
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
  80050a:	e8 91 26 00 00       	call   802ba0 <__umoddi3>
  80050f:	83 c4 14             	add    $0x14,%esp
  800512:	0f be 80 27 2e 80 00 	movsbl 0x802e27(%eax),%eax
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
  8005bb:	ff 24 85 00 30 80 00 	jmp    *0x803000(,%eax,4)
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
  800686:	8b 14 85 60 31 80 00 	mov    0x803160(,%eax,4),%edx
  80068d:	85 d2                	test   %edx,%edx
  80068f:	74 18                	je     8006a9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800691:	52                   	push   %edx
  800692:	68 6d 33 80 00       	push   $0x80336d
  800697:	53                   	push   %ebx
  800698:	56                   	push   %esi
  800699:	e8 a6 fe ff ff       	call   800544 <printfmt>
  80069e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006a4:	e9 fe 02 00 00       	jmp    8009a7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006a9:	50                   	push   %eax
  8006aa:	68 3f 2e 80 00       	push   $0x802e3f
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
  8006d1:	b8 38 2e 80 00       	mov    $0x802e38,%eax
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
  800a69:	bf 5d 2f 80 00       	mov    $0x802f5d,%edi
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
  800a95:	bf 95 2f 80 00       	mov    $0x802f95,%edi
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
  800f36:	68 a8 31 80 00       	push   $0x8031a8
  800f3b:	6a 43                	push   $0x43
  800f3d:	68 c5 31 80 00       	push   $0x8031c5
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
  800fb7:	68 a8 31 80 00       	push   $0x8031a8
  800fbc:	6a 43                	push   $0x43
  800fbe:	68 c5 31 80 00       	push   $0x8031c5
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
  800ff9:	68 a8 31 80 00       	push   $0x8031a8
  800ffe:	6a 43                	push   $0x43
  801000:	68 c5 31 80 00       	push   $0x8031c5
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
  80103b:	68 a8 31 80 00       	push   $0x8031a8
  801040:	6a 43                	push   $0x43
  801042:	68 c5 31 80 00       	push   $0x8031c5
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
  80107d:	68 a8 31 80 00       	push   $0x8031a8
  801082:	6a 43                	push   $0x43
  801084:	68 c5 31 80 00       	push   $0x8031c5
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
  8010bf:	68 a8 31 80 00       	push   $0x8031a8
  8010c4:	6a 43                	push   $0x43
  8010c6:	68 c5 31 80 00       	push   $0x8031c5
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
  801101:	68 a8 31 80 00       	push   $0x8031a8
  801106:	6a 43                	push   $0x43
  801108:	68 c5 31 80 00       	push   $0x8031c5
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
  801165:	68 a8 31 80 00       	push   $0x8031a8
  80116a:	6a 43                	push   $0x43
  80116c:	68 c5 31 80 00       	push   $0x8031c5
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
  801249:	68 a8 31 80 00       	push   $0x8031a8
  80124e:	6a 43                	push   $0x43
  801250:	68 c5 31 80 00       	push   $0x8031c5
  801255:	e8 e4 f0 ff ff       	call   80033e <_panic>

0080125a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801260:	b9 00 00 00 00       	mov    $0x0,%ecx
  801265:	8b 55 08             	mov    0x8(%ebp),%edx
  801268:	b8 14 00 00 00       	mov    $0x14,%eax
  80126d:	89 cb                	mov    %ecx,%ebx
  80126f:	89 cf                	mov    %ecx,%edi
  801271:	89 ce                	mov    %ecx,%esi
  801273:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    

0080127a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801281:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801288:	f6 c5 04             	test   $0x4,%ch
  80128b:	75 45                	jne    8012d2 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80128d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801294:	83 e1 07             	and    $0x7,%ecx
  801297:	83 f9 07             	cmp    $0x7,%ecx
  80129a:	74 6f                	je     80130b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80129c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012a3:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8012a9:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8012af:	0f 84 b6 00 00 00    	je     80136b <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012b5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012bc:	83 e1 05             	and    $0x5,%ecx
  8012bf:	83 f9 05             	cmp    $0x5,%ecx
  8012c2:	0f 84 d7 00 00 00    	je     80139f <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012d2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012d9:	c1 e2 0c             	shl    $0xc,%edx
  8012dc:	83 ec 0c             	sub    $0xc,%esp
  8012df:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012e5:	51                   	push   %ecx
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	52                   	push   %edx
  8012e9:	6a 00                	push   $0x0
  8012eb:	e8 d8 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  8012f0:	83 c4 20             	add    $0x20,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	79 d1                	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 d3 31 80 00       	push   $0x8031d3
  8012ff:	6a 54                	push   $0x54
  801301:	68 e9 31 80 00       	push   $0x8031e9
  801306:	e8 33 f0 ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80130b:	89 d3                	mov    %edx,%ebx
  80130d:	c1 e3 0c             	shl    $0xc,%ebx
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	68 05 08 00 00       	push   $0x805
  801318:	53                   	push   %ebx
  801319:	50                   	push   %eax
  80131a:	53                   	push   %ebx
  80131b:	6a 00                	push   $0x0
  80131d:	e8 a6 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801322:	83 c4 20             	add    $0x20,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 2e                	js     801357 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801329:	83 ec 0c             	sub    $0xc,%esp
  80132c:	68 05 08 00 00       	push   $0x805
  801331:	53                   	push   %ebx
  801332:	6a 00                	push   $0x0
  801334:	53                   	push   %ebx
  801335:	6a 00                	push   $0x0
  801337:	e8 8c fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  80133c:	83 c4 20             	add    $0x20,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	79 85                	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801343:	83 ec 04             	sub    $0x4,%esp
  801346:	68 d3 31 80 00       	push   $0x8031d3
  80134b:	6a 5f                	push   $0x5f
  80134d:	68 e9 31 80 00       	push   $0x8031e9
  801352:	e8 e7 ef ff ff       	call   80033e <_panic>
			panic("sys_page_map() panic\n");
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 d3 31 80 00       	push   $0x8031d3
  80135f:	6a 5b                	push   $0x5b
  801361:	68 e9 31 80 00       	push   $0x8031e9
  801366:	e8 d3 ef ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80136b:	c1 e2 0c             	shl    $0xc,%edx
  80136e:	83 ec 0c             	sub    $0xc,%esp
  801371:	68 05 08 00 00       	push   $0x805
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	52                   	push   %edx
  801379:	6a 00                	push   $0x0
  80137b:	e8 48 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  801380:	83 c4 20             	add    $0x20,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	0f 89 3d ff ff ff    	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	68 d3 31 80 00       	push   $0x8031d3
  801393:	6a 66                	push   $0x66
  801395:	68 e9 31 80 00       	push   $0x8031e9
  80139a:	e8 9f ef ff ff       	call   80033e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80139f:	c1 e2 0c             	shl    $0xc,%edx
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	6a 05                	push   $0x5
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	52                   	push   %edx
  8013aa:	6a 00                	push   $0x0
  8013ac:	e8 17 fc ff ff       	call   800fc8 <sys_page_map>
		if(r < 0)
  8013b1:	83 c4 20             	add    $0x20,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	0f 89 0c ff ff ff    	jns    8012c8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 d3 31 80 00       	push   $0x8031d3
  8013c4:	6a 6d                	push   $0x6d
  8013c6:	68 e9 31 80 00       	push   $0x8031e9
  8013cb:	e8 6e ef ff ff       	call   80033e <_panic>

008013d0 <pgfault>:
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013da:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013dc:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013e0:	0f 84 99 00 00 00    	je     80147f <pgfault+0xaf>
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	c1 ea 16             	shr    $0x16,%edx
  8013eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f2:	f6 c2 01             	test   $0x1,%dl
  8013f5:	0f 84 84 00 00 00    	je     80147f <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013fb:	89 c2                	mov    %eax,%edx
  8013fd:	c1 ea 0c             	shr    $0xc,%edx
  801400:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801407:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80140d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801413:	75 6a                	jne    80147f <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801415:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	6a 07                	push   $0x7
  801421:	68 00 f0 7f 00       	push   $0x7ff000
  801426:	6a 00                	push   $0x0
  801428:	e8 58 fb ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 5f                	js     801493 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	68 00 10 00 00       	push   $0x1000
  80143c:	53                   	push   %ebx
  80143d:	68 00 f0 7f 00       	push   $0x7ff000
  801442:	e8 3c f9 ff ff       	call   800d83 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801447:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80144e:	53                   	push   %ebx
  80144f:	6a 00                	push   $0x0
  801451:	68 00 f0 7f 00       	push   $0x7ff000
  801456:	6a 00                	push   $0x0
  801458:	e8 6b fb ff ff       	call   800fc8 <sys_page_map>
	if(ret < 0)
  80145d:	83 c4 20             	add    $0x20,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 43                	js     8014a7 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	68 00 f0 7f 00       	push   $0x7ff000
  80146c:	6a 00                	push   $0x0
  80146e:	e8 97 fb ff ff       	call   80100a <sys_page_unmap>
	if(ret < 0)
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	78 41                	js     8014bb <pgfault+0xeb>
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
		panic("panic at pgfault()\n");
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	68 f4 31 80 00       	push   $0x8031f4
  801487:	6a 26                	push   $0x26
  801489:	68 e9 31 80 00       	push   $0x8031e9
  80148e:	e8 ab ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_alloc()\n");
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	68 08 32 80 00       	push   $0x803208
  80149b:	6a 31                	push   $0x31
  80149d:	68 e9 31 80 00       	push   $0x8031e9
  8014a2:	e8 97 ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_map()\n");
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	68 23 32 80 00       	push   $0x803223
  8014af:	6a 36                	push   $0x36
  8014b1:	68 e9 31 80 00       	push   $0x8031e9
  8014b6:	e8 83 ee ff ff       	call   80033e <_panic>
		panic("panic in sys_page_unmap()\n");
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	68 3c 32 80 00       	push   $0x80323c
  8014c3:	6a 39                	push   $0x39
  8014c5:	68 e9 31 80 00       	push   $0x8031e9
  8014ca:	e8 6f ee ff ff       	call   80033e <_panic>

008014cf <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	57                   	push   %edi
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014d8:	68 d0 13 80 00       	push   $0x8013d0
  8014dd:	e8 d5 13 00 00       	call   8028b7 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8014e7:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 27                	js     801517 <fork+0x48>
  8014f0:	89 c6                	mov    %eax,%esi
  8014f2:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f4:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014f9:	75 48                	jne    801543 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014fb:	e8 47 fa ff ff       	call   800f47 <sys_getenvid>
  801500:	25 ff 03 00 00       	and    $0x3ff,%eax
  801505:	c1 e0 07             	shl    $0x7,%eax
  801508:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80150d:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801512:	e9 90 00 00 00       	jmp    8015a7 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 58 32 80 00       	push   $0x803258
  80151f:	68 8c 00 00 00       	push   $0x8c
  801524:	68 e9 31 80 00       	push   $0x8031e9
  801529:	e8 10 ee ff ff       	call   80033e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80152e:	89 f8                	mov    %edi,%eax
  801530:	e8 45 fd ff ff       	call   80127a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801535:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80153b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801541:	74 26                	je     801569 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801543:	89 d8                	mov    %ebx,%eax
  801545:	c1 e8 16             	shr    $0x16,%eax
  801548:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80154f:	a8 01                	test   $0x1,%al
  801551:	74 e2                	je     801535 <fork+0x66>
  801553:	89 da                	mov    %ebx,%edx
  801555:	c1 ea 0c             	shr    $0xc,%edx
  801558:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80155f:	83 e0 05             	and    $0x5,%eax
  801562:	83 f8 05             	cmp    $0x5,%eax
  801565:	75 ce                	jne    801535 <fork+0x66>
  801567:	eb c5                	jmp    80152e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	6a 07                	push   $0x7
  80156e:	68 00 f0 bf ee       	push   $0xeebff000
  801573:	56                   	push   %esi
  801574:	e8 0c fa ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 31                	js     8015b1 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	68 26 29 80 00       	push   $0x802926
  801588:	56                   	push   %esi
  801589:	e8 42 fb ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	85 c0                	test   %eax,%eax
  801593:	78 33                	js     8015c8 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	6a 02                	push   $0x2
  80159a:	56                   	push   %esi
  80159b:	e8 ac fa ff ff       	call   80104c <sys_env_set_status>
	if(ret < 0)
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 38                	js     8015df <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8015a7:	89 f0                	mov    %esi,%eax
  8015a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5f                   	pop    %edi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	68 08 32 80 00       	push   $0x803208
  8015b9:	68 98 00 00 00       	push   $0x98
  8015be:	68 e9 31 80 00       	push   $0x8031e9
  8015c3:	e8 76 ed ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	68 7c 32 80 00       	push   $0x80327c
  8015d0:	68 9b 00 00 00       	push   $0x9b
  8015d5:	68 e9 31 80 00       	push   $0x8031e9
  8015da:	e8 5f ed ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_status()\n");
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	68 a4 32 80 00       	push   $0x8032a4
  8015e7:	68 9e 00 00 00       	push   $0x9e
  8015ec:	68 e9 31 80 00       	push   $0x8031e9
  8015f1:	e8 48 ed ff ff       	call   80033e <_panic>

008015f6 <sfork>:

// Challenge!
int
sfork(void)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	57                   	push   %edi
  8015fa:	56                   	push   %esi
  8015fb:	53                   	push   %ebx
  8015fc:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8015ff:	68 d0 13 80 00       	push   $0x8013d0
  801604:	e8 ae 12 00 00       	call   8028b7 <set_pgfault_handler>
  801609:	b8 07 00 00 00       	mov    $0x7,%eax
  80160e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	85 c0                	test   %eax,%eax
  801615:	78 27                	js     80163e <sfork+0x48>
  801617:	89 c7                	mov    %eax,%edi
  801619:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80161b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801620:	75 55                	jne    801677 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801622:	e8 20 f9 ff ff       	call   800f47 <sys_getenvid>
  801627:	25 ff 03 00 00       	and    $0x3ff,%eax
  80162c:	c1 e0 07             	shl    $0x7,%eax
  80162f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801634:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801639:	e9 d4 00 00 00       	jmp    801712 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	68 58 32 80 00       	push   $0x803258
  801646:	68 af 00 00 00       	push   $0xaf
  80164b:	68 e9 31 80 00       	push   $0x8031e9
  801650:	e8 e9 ec ff ff       	call   80033e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801655:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80165a:	89 f0                	mov    %esi,%eax
  80165c:	e8 19 fc ff ff       	call   80127a <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801667:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80166d:	77 65                	ja     8016d4 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80166f:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801675:	74 de                	je     801655 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801677:	89 d8                	mov    %ebx,%eax
  801679:	c1 e8 16             	shr    $0x16,%eax
  80167c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801683:	a8 01                	test   $0x1,%al
  801685:	74 da                	je     801661 <sfork+0x6b>
  801687:	89 da                	mov    %ebx,%edx
  801689:	c1 ea 0c             	shr    $0xc,%edx
  80168c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801693:	83 e0 05             	and    $0x5,%eax
  801696:	83 f8 05             	cmp    $0x5,%eax
  801699:	75 c6                	jne    801661 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80169b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8016a2:	c1 e2 0c             	shl    $0xc,%edx
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	83 e0 07             	and    $0x7,%eax
  8016ab:	50                   	push   %eax
  8016ac:	52                   	push   %edx
  8016ad:	56                   	push   %esi
  8016ae:	52                   	push   %edx
  8016af:	6a 00                	push   $0x0
  8016b1:	e8 12 f9 ff ff       	call   800fc8 <sys_page_map>
  8016b6:	83 c4 20             	add    $0x20,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	74 a4                	je     801661 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	68 d3 31 80 00       	push   $0x8031d3
  8016c5:	68 ba 00 00 00       	push   $0xba
  8016ca:	68 e9 31 80 00       	push   $0x8031e9
  8016cf:	e8 6a ec ff ff       	call   80033e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	6a 07                	push   $0x7
  8016d9:	68 00 f0 bf ee       	push   $0xeebff000
  8016de:	57                   	push   %edi
  8016df:	e8 a1 f8 ff ff       	call   800f85 <sys_page_alloc>
	if(ret < 0)
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 31                	js     80171c <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	68 26 29 80 00       	push   $0x802926
  8016f3:	57                   	push   %edi
  8016f4:	e8 d7 f9 ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	78 33                	js     801733 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801700:	83 ec 08             	sub    $0x8,%esp
  801703:	6a 02                	push   $0x2
  801705:	57                   	push   %edi
  801706:	e8 41 f9 ff ff       	call   80104c <sys_env_set_status>
	if(ret < 0)
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 38                	js     80174a <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801712:	89 f8                	mov    %edi,%eax
  801714:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801717:	5b                   	pop    %ebx
  801718:	5e                   	pop    %esi
  801719:	5f                   	pop    %edi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	68 08 32 80 00       	push   $0x803208
  801724:	68 c0 00 00 00       	push   $0xc0
  801729:	68 e9 31 80 00       	push   $0x8031e9
  80172e:	e8 0b ec ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 7c 32 80 00       	push   $0x80327c
  80173b:	68 c3 00 00 00       	push   $0xc3
  801740:	68 e9 31 80 00       	push   $0x8031e9
  801745:	e8 f4 eb ff ff       	call   80033e <_panic>
		panic("panic in sys_env_set_status()\n");
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	68 a4 32 80 00       	push   $0x8032a4
  801752:	68 c6 00 00 00       	push   $0xc6
  801757:	68 e9 31 80 00       	push   $0x8031e9
  80175c:	e8 dd eb ff ff       	call   80033e <_panic>

00801761 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	05 00 00 00 30       	add    $0x30000000,%eax
  80176c:	c1 e8 0c             	shr    $0xc,%eax
}
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    

00801771 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80177c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801781:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801790:	89 c2                	mov    %eax,%edx
  801792:	c1 ea 16             	shr    $0x16,%edx
  801795:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80179c:	f6 c2 01             	test   $0x1,%dl
  80179f:	74 2d                	je     8017ce <fd_alloc+0x46>
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	c1 ea 0c             	shr    $0xc,%edx
  8017a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017ad:	f6 c2 01             	test   $0x1,%dl
  8017b0:	74 1c                	je     8017ce <fd_alloc+0x46>
  8017b2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017b7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017bc:	75 d2                	jne    801790 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017c7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017cc:	eb 0a                	jmp    8017d8 <fd_alloc+0x50>
			*fd_store = fd;
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017e0:	83 f8 1f             	cmp    $0x1f,%eax
  8017e3:	77 30                	ja     801815 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017e5:	c1 e0 0c             	shl    $0xc,%eax
  8017e8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017ed:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017f3:	f6 c2 01             	test   $0x1,%dl
  8017f6:	74 24                	je     80181c <fd_lookup+0x42>
  8017f8:	89 c2                	mov    %eax,%edx
  8017fa:	c1 ea 0c             	shr    $0xc,%edx
  8017fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801804:	f6 c2 01             	test   $0x1,%dl
  801807:	74 1a                	je     801823 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	89 02                	mov    %eax,(%edx)
	return 0;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    
		return -E_INVAL;
  801815:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181a:	eb f7                	jmp    801813 <fd_lookup+0x39>
		return -E_INVAL;
  80181c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801821:	eb f0                	jmp    801813 <fd_lookup+0x39>
  801823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801828:	eb e9                	jmp    801813 <fd_lookup+0x39>

0080182a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80183d:	39 08                	cmp    %ecx,(%eax)
  80183f:	74 38                	je     801879 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801841:	83 c2 01             	add    $0x1,%edx
  801844:	8b 04 95 40 33 80 00 	mov    0x803340(,%edx,4),%eax
  80184b:	85 c0                	test   %eax,%eax
  80184d:	75 ee                	jne    80183d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80184f:	a1 08 50 80 00       	mov    0x805008,%eax
  801854:	8b 40 48             	mov    0x48(%eax),%eax
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	51                   	push   %ecx
  80185b:	50                   	push   %eax
  80185c:	68 c4 32 80 00       	push   $0x8032c4
  801861:	e8 ce eb ff ff       	call   800434 <cprintf>
	*dev = 0;
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    
			*dev = devtab[i];
  801879:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	eb f2                	jmp    801877 <dev_lookup+0x4d>

00801885 <fd_close>:
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	57                   	push   %edi
  801889:	56                   	push   %esi
  80188a:	53                   	push   %ebx
  80188b:	83 ec 24             	sub    $0x24,%esp
  80188e:	8b 75 08             	mov    0x8(%ebp),%esi
  801891:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801894:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801897:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801898:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80189e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018a1:	50                   	push   %eax
  8018a2:	e8 33 ff ff ff       	call   8017da <fd_lookup>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 05                	js     8018b5 <fd_close+0x30>
	    || fd != fd2)
  8018b0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018b3:	74 16                	je     8018cb <fd_close+0x46>
		return (must_exist ? r : 0);
  8018b5:	89 f8                	mov    %edi,%eax
  8018b7:	84 c0                	test   %al,%al
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	0f 44 d8             	cmove  %eax,%ebx
}
  8018c1:	89 d8                	mov    %ebx,%eax
  8018c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c6:	5b                   	pop    %ebx
  8018c7:	5e                   	pop    %esi
  8018c8:	5f                   	pop    %edi
  8018c9:	5d                   	pop    %ebp
  8018ca:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	ff 36                	pushl  (%esi)
  8018d4:	e8 51 ff ff ff       	call   80182a <dev_lookup>
  8018d9:	89 c3                	mov    %eax,%ebx
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	78 1a                	js     8018fc <fd_close+0x77>
		if (dev->dev_close)
  8018e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	74 0b                	je     8018fc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018f1:	83 ec 0c             	sub    $0xc,%esp
  8018f4:	56                   	push   %esi
  8018f5:	ff d0                	call   *%eax
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	56                   	push   %esi
  801900:	6a 00                	push   $0x0
  801902:	e8 03 f7 ff ff       	call   80100a <sys_page_unmap>
	return r;
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	eb b5                	jmp    8018c1 <fd_close+0x3c>

0080190c <close>:

int
close(int fdnum)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801912:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801915:	50                   	push   %eax
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	e8 bc fe ff ff       	call   8017da <fd_lookup>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	79 02                	jns    801927 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    
		return fd_close(fd, 1);
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	6a 01                	push   $0x1
  80192c:	ff 75 f4             	pushl  -0xc(%ebp)
  80192f:	e8 51 ff ff ff       	call   801885 <fd_close>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	eb ec                	jmp    801925 <close+0x19>

00801939 <close_all>:

void
close_all(void)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	53                   	push   %ebx
  80193d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801940:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	53                   	push   %ebx
  801949:	e8 be ff ff ff       	call   80190c <close>
	for (i = 0; i < MAXFD; i++)
  80194e:	83 c3 01             	add    $0x1,%ebx
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	83 fb 20             	cmp    $0x20,%ebx
  801957:	75 ec                	jne    801945 <close_all+0xc>
}
  801959:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801967:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80196a:	50                   	push   %eax
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	e8 67 fe ff ff       	call   8017da <fd_lookup>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	0f 88 81 00 00 00    	js     801a01 <dup+0xa3>
		return r;
	close(newfdnum);
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	e8 81 ff ff ff       	call   80190c <close>

	newfd = INDEX2FD(newfdnum);
  80198b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80198e:	c1 e6 0c             	shl    $0xc,%esi
  801991:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80199d:	e8 cf fd ff ff       	call   801771 <fd2data>
  8019a2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019a4:	89 34 24             	mov    %esi,(%esp)
  8019a7:	e8 c5 fd ff ff       	call   801771 <fd2data>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019b1:	89 d8                	mov    %ebx,%eax
  8019b3:	c1 e8 16             	shr    $0x16,%eax
  8019b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019bd:	a8 01                	test   $0x1,%al
  8019bf:	74 11                	je     8019d2 <dup+0x74>
  8019c1:	89 d8                	mov    %ebx,%eax
  8019c3:	c1 e8 0c             	shr    $0xc,%eax
  8019c6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019cd:	f6 c2 01             	test   $0x1,%dl
  8019d0:	75 39                	jne    801a0b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019d5:	89 d0                	mov    %edx,%eax
  8019d7:	c1 e8 0c             	shr    $0xc,%eax
  8019da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8019e9:	50                   	push   %eax
  8019ea:	56                   	push   %esi
  8019eb:	6a 00                	push   $0x0
  8019ed:	52                   	push   %edx
  8019ee:	6a 00                	push   $0x0
  8019f0:	e8 d3 f5 ff ff       	call   800fc8 <sys_page_map>
  8019f5:	89 c3                	mov    %eax,%ebx
  8019f7:	83 c4 20             	add    $0x20,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 31                	js     801a2f <dup+0xd1>
		goto err;

	return newfdnum;
  8019fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a01:	89 d8                	mov    %ebx,%eax
  801a03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5e                   	pop    %esi
  801a08:	5f                   	pop    %edi
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a0b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a12:	83 ec 0c             	sub    $0xc,%esp
  801a15:	25 07 0e 00 00       	and    $0xe07,%eax
  801a1a:	50                   	push   %eax
  801a1b:	57                   	push   %edi
  801a1c:	6a 00                	push   $0x0
  801a1e:	53                   	push   %ebx
  801a1f:	6a 00                	push   $0x0
  801a21:	e8 a2 f5 ff ff       	call   800fc8 <sys_page_map>
  801a26:	89 c3                	mov    %eax,%ebx
  801a28:	83 c4 20             	add    $0x20,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	79 a3                	jns    8019d2 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	56                   	push   %esi
  801a33:	6a 00                	push   $0x0
  801a35:	e8 d0 f5 ff ff       	call   80100a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	57                   	push   %edi
  801a3e:	6a 00                	push   $0x0
  801a40:	e8 c5 f5 ff ff       	call   80100a <sys_page_unmap>
	return r;
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	eb b7                	jmp    801a01 <dup+0xa3>

00801a4a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	53                   	push   %ebx
  801a4e:	83 ec 1c             	sub    $0x1c,%esp
  801a51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a57:	50                   	push   %eax
  801a58:	53                   	push   %ebx
  801a59:	e8 7c fd ff ff       	call   8017da <fd_lookup>
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 3f                	js     801aa4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a65:	83 ec 08             	sub    $0x8,%esp
  801a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6b:	50                   	push   %eax
  801a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6f:	ff 30                	pushl  (%eax)
  801a71:	e8 b4 fd ff ff       	call   80182a <dev_lookup>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 27                	js     801aa4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a80:	8b 42 08             	mov    0x8(%edx),%eax
  801a83:	83 e0 03             	and    $0x3,%eax
  801a86:	83 f8 01             	cmp    $0x1,%eax
  801a89:	74 1e                	je     801aa9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	8b 40 08             	mov    0x8(%eax),%eax
  801a91:	85 c0                	test   %eax,%eax
  801a93:	74 35                	je     801aca <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	ff 75 10             	pushl  0x10(%ebp)
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	52                   	push   %edx
  801a9f:	ff d0                	call   *%eax
  801aa1:	83 c4 10             	add    $0x10,%esp
}
  801aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801aa9:	a1 08 50 80 00       	mov    0x805008,%eax
  801aae:	8b 40 48             	mov    0x48(%eax),%eax
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	53                   	push   %ebx
  801ab5:	50                   	push   %eax
  801ab6:	68 05 33 80 00       	push   $0x803305
  801abb:	e8 74 e9 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac8:	eb da                	jmp    801aa4 <read+0x5a>
		return -E_NOT_SUPP;
  801aca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801acf:	eb d3                	jmp    801aa4 <read+0x5a>

00801ad1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	57                   	push   %edi
  801ad5:	56                   	push   %esi
  801ad6:	53                   	push   %ebx
  801ad7:	83 ec 0c             	sub    $0xc,%esp
  801ada:	8b 7d 08             	mov    0x8(%ebp),%edi
  801add:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ae0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae5:	39 f3                	cmp    %esi,%ebx
  801ae7:	73 23                	jae    801b0c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	89 f0                	mov    %esi,%eax
  801aee:	29 d8                	sub    %ebx,%eax
  801af0:	50                   	push   %eax
  801af1:	89 d8                	mov    %ebx,%eax
  801af3:	03 45 0c             	add    0xc(%ebp),%eax
  801af6:	50                   	push   %eax
  801af7:	57                   	push   %edi
  801af8:	e8 4d ff ff ff       	call   801a4a <read>
		if (m < 0)
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 06                	js     801b0a <readn+0x39>
			return m;
		if (m == 0)
  801b04:	74 06                	je     801b0c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b06:	01 c3                	add    %eax,%ebx
  801b08:	eb db                	jmp    801ae5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b0a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    

00801b16 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 1c             	sub    $0x1c,%esp
  801b1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b23:	50                   	push   %eax
  801b24:	53                   	push   %ebx
  801b25:	e8 b0 fc ff ff       	call   8017da <fd_lookup>
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 3a                	js     801b6b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b31:	83 ec 08             	sub    $0x8,%esp
  801b34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b37:	50                   	push   %eax
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3b:	ff 30                	pushl  (%eax)
  801b3d:	e8 e8 fc ff ff       	call   80182a <dev_lookup>
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 22                	js     801b6b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b50:	74 1e                	je     801b70 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b55:	8b 52 0c             	mov    0xc(%edx),%edx
  801b58:	85 d2                	test   %edx,%edx
  801b5a:	74 35                	je     801b91 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	ff 75 10             	pushl  0x10(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	50                   	push   %eax
  801b66:	ff d2                	call   *%edx
  801b68:	83 c4 10             	add    $0x10,%esp
}
  801b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b70:	a1 08 50 80 00       	mov    0x805008,%eax
  801b75:	8b 40 48             	mov    0x48(%eax),%eax
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	53                   	push   %ebx
  801b7c:	50                   	push   %eax
  801b7d:	68 21 33 80 00       	push   $0x803321
  801b82:	e8 ad e8 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801b87:	83 c4 10             	add    $0x10,%esp
  801b8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b8f:	eb da                	jmp    801b6b <write+0x55>
		return -E_NOT_SUPP;
  801b91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b96:	eb d3                	jmp    801b6b <write+0x55>

00801b98 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba1:	50                   	push   %eax
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	e8 30 fc ff ff       	call   8017da <fd_lookup>
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	85 c0                	test   %eax,%eax
  801baf:	78 0e                	js     801bbf <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 1c             	sub    $0x1c,%esp
  801bc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bce:	50                   	push   %eax
  801bcf:	53                   	push   %ebx
  801bd0:	e8 05 fc ff ff       	call   8017da <fd_lookup>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 37                	js     801c13 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bdc:	83 ec 08             	sub    $0x8,%esp
  801bdf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be2:	50                   	push   %eax
  801be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be6:	ff 30                	pushl  (%eax)
  801be8:	e8 3d fc ff ff       	call   80182a <dev_lookup>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 1f                	js     801c13 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bfb:	74 1b                	je     801c18 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c00:	8b 52 18             	mov    0x18(%edx),%edx
  801c03:	85 d2                	test   %edx,%edx
  801c05:	74 32                	je     801c39 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c07:	83 ec 08             	sub    $0x8,%esp
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	50                   	push   %eax
  801c0e:	ff d2                	call   *%edx
  801c10:	83 c4 10             	add    $0x10,%esp
}
  801c13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c18:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c1d:	8b 40 48             	mov    0x48(%eax),%eax
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	53                   	push   %ebx
  801c24:	50                   	push   %eax
  801c25:	68 e4 32 80 00       	push   $0x8032e4
  801c2a:	e8 05 e8 ff ff       	call   800434 <cprintf>
		return -E_INVAL;
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c37:	eb da                	jmp    801c13 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c39:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3e:	eb d3                	jmp    801c13 <ftruncate+0x52>

00801c40 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	e8 84 fb ff ff       	call   8017da <fd_lookup>
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	78 4b                	js     801ca8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c63:	50                   	push   %eax
  801c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c67:	ff 30                	pushl  (%eax)
  801c69:	e8 bc fb ff ff       	call   80182a <dev_lookup>
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 33                	js     801ca8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c7c:	74 2f                	je     801cad <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c7e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c81:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c88:	00 00 00 
	stat->st_isdir = 0;
  801c8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c92:	00 00 00 
	stat->st_dev = dev;
  801c95:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c9b:	83 ec 08             	sub    $0x8,%esp
  801c9e:	53                   	push   %ebx
  801c9f:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca2:	ff 50 14             	call   *0x14(%eax)
  801ca5:	83 c4 10             	add    $0x10,%esp
}
  801ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    
		return -E_NOT_SUPP;
  801cad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cb2:	eb f4                	jmp    801ca8 <fstat+0x68>

00801cb4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	56                   	push   %esi
  801cb8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	e8 22 02 00 00       	call   801ee8 <open>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	85 c0                	test   %eax,%eax
  801ccd:	78 1b                	js     801cea <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ccf:	83 ec 08             	sub    $0x8,%esp
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	50                   	push   %eax
  801cd6:	e8 65 ff ff ff       	call   801c40 <fstat>
  801cdb:	89 c6                	mov    %eax,%esi
	close(fd);
  801cdd:	89 1c 24             	mov    %ebx,(%esp)
  801ce0:	e8 27 fc ff ff       	call   80190c <close>
	return r;
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	89 f3                	mov    %esi,%ebx
}
  801cea:	89 d8                	mov    %ebx,%eax
  801cec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	89 c6                	mov    %eax,%esi
  801cfa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cfc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d03:	74 27                	je     801d2c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d05:	6a 07                	push   $0x7
  801d07:	68 00 60 80 00       	push   $0x806000
  801d0c:	56                   	push   %esi
  801d0d:	ff 35 00 50 80 00    	pushl  0x805000
  801d13:	e8 9d 0c 00 00       	call   8029b5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d18:	83 c4 0c             	add    $0xc,%esp
  801d1b:	6a 00                	push   $0x0
  801d1d:	53                   	push   %ebx
  801d1e:	6a 00                	push   $0x0
  801d20:	e8 27 0c 00 00       	call   80294c <ipc_recv>
}
  801d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	6a 01                	push   $0x1
  801d31:	e8 d7 0c 00 00       	call   802a0d <ipc_find_env>
  801d36:	a3 00 50 80 00       	mov    %eax,0x805000
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	eb c5                	jmp    801d05 <fsipc+0x12>

00801d40 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d59:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d63:	e8 8b ff ff ff       	call   801cf3 <fsipc>
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <devfile_flush>:
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	8b 40 0c             	mov    0xc(%eax),%eax
  801d76:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d80:	b8 06 00 00 00       	mov    $0x6,%eax
  801d85:	e8 69 ff ff ff       	call   801cf3 <fsipc>
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <devfile_stat>:
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 04             	sub    $0x4,%esp
  801d93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801da1:	ba 00 00 00 00       	mov    $0x0,%edx
  801da6:	b8 05 00 00 00       	mov    $0x5,%eax
  801dab:	e8 43 ff ff ff       	call   801cf3 <fsipc>
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 2c                	js     801de0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	68 00 60 80 00       	push   $0x806000
  801dbc:	53                   	push   %ebx
  801dbd:	e8 d1 ed ff ff       	call   800b93 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dc2:	a1 80 60 80 00       	mov    0x806080,%eax
  801dc7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dcd:	a1 84 60 80 00       	mov    0x806084,%eax
  801dd2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <devfile_write>:
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	53                   	push   %ebx
  801de9:	83 ec 08             	sub    $0x8,%esp
  801dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dfa:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e00:	53                   	push   %ebx
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	68 08 60 80 00       	push   $0x806008
  801e09:	e8 75 ef ff ff       	call   800d83 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	b8 04 00 00 00       	mov    $0x4,%eax
  801e18:	e8 d6 fe ff ff       	call   801cf3 <fsipc>
  801e1d:	83 c4 10             	add    $0x10,%esp
  801e20:	85 c0                	test   %eax,%eax
  801e22:	78 0b                	js     801e2f <devfile_write+0x4a>
	assert(r <= n);
  801e24:	39 d8                	cmp    %ebx,%eax
  801e26:	77 0c                	ja     801e34 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e28:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e2d:	7f 1e                	jg     801e4d <devfile_write+0x68>
}
  801e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    
	assert(r <= n);
  801e34:	68 54 33 80 00       	push   $0x803354
  801e39:	68 5b 33 80 00       	push   $0x80335b
  801e3e:	68 98 00 00 00       	push   $0x98
  801e43:	68 70 33 80 00       	push   $0x803370
  801e48:	e8 f1 e4 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801e4d:	68 7b 33 80 00       	push   $0x80337b
  801e52:	68 5b 33 80 00       	push   $0x80335b
  801e57:	68 99 00 00 00       	push   $0x99
  801e5c:	68 70 33 80 00       	push   $0x803370
  801e61:	e8 d8 e4 ff ff       	call   80033e <_panic>

00801e66 <devfile_read>:
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	56                   	push   %esi
  801e6a:	53                   	push   %ebx
  801e6b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	8b 40 0c             	mov    0xc(%eax),%eax
  801e74:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e79:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e84:	b8 03 00 00 00       	mov    $0x3,%eax
  801e89:	e8 65 fe ff ff       	call   801cf3 <fsipc>
  801e8e:	89 c3                	mov    %eax,%ebx
  801e90:	85 c0                	test   %eax,%eax
  801e92:	78 1f                	js     801eb3 <devfile_read+0x4d>
	assert(r <= n);
  801e94:	39 f0                	cmp    %esi,%eax
  801e96:	77 24                	ja     801ebc <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e98:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e9d:	7f 33                	jg     801ed2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e9f:	83 ec 04             	sub    $0x4,%esp
  801ea2:	50                   	push   %eax
  801ea3:	68 00 60 80 00       	push   $0x806000
  801ea8:	ff 75 0c             	pushl  0xc(%ebp)
  801eab:	e8 71 ee ff ff       	call   800d21 <memmove>
	return r;
  801eb0:	83 c4 10             	add    $0x10,%esp
}
  801eb3:	89 d8                	mov    %ebx,%eax
  801eb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb8:	5b                   	pop    %ebx
  801eb9:	5e                   	pop    %esi
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    
	assert(r <= n);
  801ebc:	68 54 33 80 00       	push   $0x803354
  801ec1:	68 5b 33 80 00       	push   $0x80335b
  801ec6:	6a 7c                	push   $0x7c
  801ec8:	68 70 33 80 00       	push   $0x803370
  801ecd:	e8 6c e4 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801ed2:	68 7b 33 80 00       	push   $0x80337b
  801ed7:	68 5b 33 80 00       	push   $0x80335b
  801edc:	6a 7d                	push   $0x7d
  801ede:	68 70 33 80 00       	push   $0x803370
  801ee3:	e8 56 e4 ff ff       	call   80033e <_panic>

00801ee8 <open>:
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	83 ec 1c             	sub    $0x1c,%esp
  801ef0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ef3:	56                   	push   %esi
  801ef4:	e8 61 ec ff ff       	call   800b5a <strlen>
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f01:	7f 6c                	jg     801f6f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f09:	50                   	push   %eax
  801f0a:	e8 79 f8 ff ff       	call   801788 <fd_alloc>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	78 3c                	js     801f54 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f18:	83 ec 08             	sub    $0x8,%esp
  801f1b:	56                   	push   %esi
  801f1c:	68 00 60 80 00       	push   $0x806000
  801f21:	e8 6d ec ff ff       	call   800b93 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f31:	b8 01 00 00 00       	mov    $0x1,%eax
  801f36:	e8 b8 fd ff ff       	call   801cf3 <fsipc>
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 19                	js     801f5d <open+0x75>
	return fd2num(fd);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4a:	e8 12 f8 ff ff       	call   801761 <fd2num>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	83 c4 10             	add    $0x10,%esp
}
  801f54:	89 d8                	mov    %ebx,%eax
  801f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f59:	5b                   	pop    %ebx
  801f5a:	5e                   	pop    %esi
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    
		fd_close(fd, 0);
  801f5d:	83 ec 08             	sub    $0x8,%esp
  801f60:	6a 00                	push   $0x0
  801f62:	ff 75 f4             	pushl  -0xc(%ebp)
  801f65:	e8 1b f9 ff ff       	call   801885 <fd_close>
		return r;
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	eb e5                	jmp    801f54 <open+0x6c>
		return -E_BAD_PATH;
  801f6f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f74:	eb de                	jmp    801f54 <open+0x6c>

00801f76 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f81:	b8 08 00 00 00       	mov    $0x8,%eax
  801f86:	e8 68 fd ff ff       	call   801cf3 <fsipc>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f93:	68 87 33 80 00       	push   $0x803387
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	e8 f3 eb ff ff       	call   800b93 <strcpy>
	return 0;
}
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <devsock_close>:
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	53                   	push   %ebx
  801fab:	83 ec 10             	sub    $0x10,%esp
  801fae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fb1:	53                   	push   %ebx
  801fb2:	e8 91 0a 00 00       	call   802a48 <pageref>
  801fb7:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fba:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fbf:	83 f8 01             	cmp    $0x1,%eax
  801fc2:	74 07                	je     801fcb <devsock_close+0x24>
}
  801fc4:	89 d0                	mov    %edx,%eax
  801fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	ff 73 0c             	pushl  0xc(%ebx)
  801fd1:	e8 b9 02 00 00       	call   80228f <nsipc_close>
  801fd6:	89 c2                	mov    %eax,%edx
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	eb e7                	jmp    801fc4 <devsock_close+0x1d>

00801fdd <devsock_write>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fe3:	6a 00                	push   $0x0
  801fe5:	ff 75 10             	pushl  0x10(%ebp)
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	ff 70 0c             	pushl  0xc(%eax)
  801ff1:	e8 76 03 00 00       	call   80236c <nsipc_send>
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <devsock_read>:
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	ff 75 10             	pushl  0x10(%ebp)
  802003:	ff 75 0c             	pushl  0xc(%ebp)
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	ff 70 0c             	pushl  0xc(%eax)
  80200c:	e8 ef 02 00 00       	call   802300 <nsipc_recv>
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <fd2sockid>:
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802019:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80201c:	52                   	push   %edx
  80201d:	50                   	push   %eax
  80201e:	e8 b7 f7 ff ff       	call   8017da <fd_lookup>
  802023:	83 c4 10             	add    $0x10,%esp
  802026:	85 c0                	test   %eax,%eax
  802028:	78 10                	js     80203a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802033:	39 08                	cmp    %ecx,(%eax)
  802035:	75 05                	jne    80203c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802037:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    
		return -E_NOT_SUPP;
  80203c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802041:	eb f7                	jmp    80203a <fd2sockid+0x27>

00802043 <alloc_sockfd>:
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	56                   	push   %esi
  802047:	53                   	push   %ebx
  802048:	83 ec 1c             	sub    $0x1c,%esp
  80204b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80204d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	e8 32 f7 ff ff       	call   801788 <fd_alloc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 43                	js     8020a2 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	68 07 04 00 00       	push   $0x407
  802067:	ff 75 f4             	pushl  -0xc(%ebp)
  80206a:	6a 00                	push   $0x0
  80206c:	e8 14 ef ff ff       	call   800f85 <sys_page_alloc>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	78 28                	js     8020a2 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802083:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802088:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80208f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	50                   	push   %eax
  802096:	e8 c6 f6 ff ff       	call   801761 <fd2num>
  80209b:	89 c3                	mov    %eax,%ebx
  80209d:	83 c4 10             	add    $0x10,%esp
  8020a0:	eb 0c                	jmp    8020ae <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	56                   	push   %esi
  8020a6:	e8 e4 01 00 00       	call   80228f <nsipc_close>
		return r;
  8020ab:	83 c4 10             	add    $0x10,%esp
}
  8020ae:	89 d8                	mov    %ebx,%eax
  8020b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b3:	5b                   	pop    %ebx
  8020b4:	5e                   	pop    %esi
  8020b5:	5d                   	pop    %ebp
  8020b6:	c3                   	ret    

008020b7 <accept>:
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	e8 4e ff ff ff       	call   802013 <fd2sockid>
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 1b                	js     8020e4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	ff 75 10             	pushl  0x10(%ebp)
  8020cf:	ff 75 0c             	pushl  0xc(%ebp)
  8020d2:	50                   	push   %eax
  8020d3:	e8 0e 01 00 00       	call   8021e6 <nsipc_accept>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 05                	js     8020e4 <accept+0x2d>
	return alloc_sockfd(r);
  8020df:	e8 5f ff ff ff       	call   802043 <alloc_sockfd>
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <bind>:
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	e8 1f ff ff ff       	call   802013 <fd2sockid>
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 12                	js     80210a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	ff 75 10             	pushl  0x10(%ebp)
  8020fe:	ff 75 0c             	pushl  0xc(%ebp)
  802101:	50                   	push   %eax
  802102:	e8 31 01 00 00       	call   802238 <nsipc_bind>
  802107:	83 c4 10             	add    $0x10,%esp
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <shutdown>:
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	e8 f9 fe ff ff       	call   802013 <fd2sockid>
  80211a:	85 c0                	test   %eax,%eax
  80211c:	78 0f                	js     80212d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80211e:	83 ec 08             	sub    $0x8,%esp
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	50                   	push   %eax
  802125:	e8 43 01 00 00       	call   80226d <nsipc_shutdown>
  80212a:	83 c4 10             	add    $0x10,%esp
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <connect>:
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	e8 d6 fe ff ff       	call   802013 <fd2sockid>
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 12                	js     802153 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	ff 75 10             	pushl  0x10(%ebp)
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	50                   	push   %eax
  80214b:	e8 59 01 00 00       	call   8022a9 <nsipc_connect>
  802150:	83 c4 10             	add    $0x10,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <listen>:
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	e8 b0 fe ff ff       	call   802013 <fd2sockid>
  802163:	85 c0                	test   %eax,%eax
  802165:	78 0f                	js     802176 <listen+0x21>
	return nsipc_listen(r, backlog);
  802167:	83 ec 08             	sub    $0x8,%esp
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	50                   	push   %eax
  80216e:	e8 6b 01 00 00       	call   8022de <nsipc_listen>
  802173:	83 c4 10             	add    $0x10,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <socket>:

int
socket(int domain, int type, int protocol)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 3e 02 00 00       	call   8023ca <nsipc_socket>
  80218c:	83 c4 10             	add    $0x10,%esp
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 05                	js     802198 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802193:	e8 ab fe ff ff       	call   802043 <alloc_sockfd>
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	53                   	push   %ebx
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021a3:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021aa:	74 26                	je     8021d2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021ac:	6a 07                	push   $0x7
  8021ae:	68 00 70 80 00       	push   $0x807000
  8021b3:	53                   	push   %ebx
  8021b4:	ff 35 04 50 80 00    	pushl  0x805004
  8021ba:	e8 f6 07 00 00       	call   8029b5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021bf:	83 c4 0c             	add    $0xc,%esp
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	e8 7f 07 00 00       	call   80294c <ipc_recv>
}
  8021cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	6a 02                	push   $0x2
  8021d7:	e8 31 08 00 00       	call   802a0d <ipc_find_env>
  8021dc:	a3 04 50 80 00       	mov    %eax,0x805004
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	eb c6                	jmp    8021ac <nsipc+0x12>

008021e6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	56                   	push   %esi
  8021ea:	53                   	push   %ebx
  8021eb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021f6:	8b 06                	mov    (%esi),%eax
  8021f8:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802202:	e8 93 ff ff ff       	call   80219a <nsipc>
  802207:	89 c3                	mov    %eax,%ebx
  802209:	85 c0                	test   %eax,%eax
  80220b:	79 09                	jns    802216 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80220d:	89 d8                	mov    %ebx,%eax
  80220f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802212:	5b                   	pop    %ebx
  802213:	5e                   	pop    %esi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	ff 35 10 70 80 00    	pushl  0x807010
  80221f:	68 00 70 80 00       	push   $0x807000
  802224:	ff 75 0c             	pushl  0xc(%ebp)
  802227:	e8 f5 ea ff ff       	call   800d21 <memmove>
		*addrlen = ret->ret_addrlen;
  80222c:	a1 10 70 80 00       	mov    0x807010,%eax
  802231:	89 06                	mov    %eax,(%esi)
  802233:	83 c4 10             	add    $0x10,%esp
	return r;
  802236:	eb d5                	jmp    80220d <nsipc_accept+0x27>

00802238 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	53                   	push   %ebx
  80223c:	83 ec 08             	sub    $0x8,%esp
  80223f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80224a:	53                   	push   %ebx
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	68 04 70 80 00       	push   $0x807004
  802253:	e8 c9 ea ff ff       	call   800d21 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802258:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80225e:	b8 02 00 00 00       	mov    $0x2,%eax
  802263:	e8 32 ff ff ff       	call   80219a <nsipc>
}
  802268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80227b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802283:	b8 03 00 00 00       	mov    $0x3,%eax
  802288:	e8 0d ff ff ff       	call   80219a <nsipc>
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <nsipc_close>:

int
nsipc_close(int s)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80229d:	b8 04 00 00 00       	mov    $0x4,%eax
  8022a2:	e8 f3 fe ff ff       	call   80219a <nsipc>
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	53                   	push   %ebx
  8022ad:	83 ec 08             	sub    $0x8,%esp
  8022b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022bb:	53                   	push   %ebx
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	68 04 70 80 00       	push   $0x807004
  8022c4:	e8 58 ea ff ff       	call   800d21 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022c9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8022d4:	e8 c1 fe ff ff       	call   80219a <nsipc>
}
  8022d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8022f9:	e8 9c fe ff ff       	call   80219a <nsipc>
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802310:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802316:	8b 45 14             	mov    0x14(%ebp),%eax
  802319:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80231e:	b8 07 00 00 00       	mov    $0x7,%eax
  802323:	e8 72 fe ff ff       	call   80219a <nsipc>
  802328:	89 c3                	mov    %eax,%ebx
  80232a:	85 c0                	test   %eax,%eax
  80232c:	78 1f                	js     80234d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80232e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802333:	7f 21                	jg     802356 <nsipc_recv+0x56>
  802335:	39 c6                	cmp    %eax,%esi
  802337:	7c 1d                	jl     802356 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	50                   	push   %eax
  80233d:	68 00 70 80 00       	push   $0x807000
  802342:	ff 75 0c             	pushl  0xc(%ebp)
  802345:	e8 d7 e9 ff ff       	call   800d21 <memmove>
  80234a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80234d:	89 d8                	mov    %ebx,%eax
  80234f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802352:	5b                   	pop    %ebx
  802353:	5e                   	pop    %esi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802356:	68 93 33 80 00       	push   $0x803393
  80235b:	68 5b 33 80 00       	push   $0x80335b
  802360:	6a 62                	push   $0x62
  802362:	68 a8 33 80 00       	push   $0x8033a8
  802367:	e8 d2 df ff ff       	call   80033e <_panic>

0080236c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	53                   	push   %ebx
  802370:	83 ec 04             	sub    $0x4,%esp
  802373:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80237e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802384:	7f 2e                	jg     8023b4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	53                   	push   %ebx
  80238a:	ff 75 0c             	pushl  0xc(%ebp)
  80238d:	68 0c 70 80 00       	push   $0x80700c
  802392:	e8 8a e9 ff ff       	call   800d21 <memmove>
	nsipcbuf.send.req_size = size;
  802397:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80239d:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8023aa:	e8 eb fd ff ff       	call   80219a <nsipc>
}
  8023af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    
	assert(size < 1600);
  8023b4:	68 b4 33 80 00       	push   $0x8033b4
  8023b9:	68 5b 33 80 00       	push   $0x80335b
  8023be:	6a 6d                	push   $0x6d
  8023c0:	68 a8 33 80 00       	push   $0x8033a8
  8023c5:	e8 74 df ff ff       	call   80033e <_panic>

008023ca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023db:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023e8:	b8 09 00 00 00       	mov    $0x9,%eax
  8023ed:	e8 a8 fd ff ff       	call   80219a <nsipc>
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	56                   	push   %esi
  8023f8:	53                   	push   %ebx
  8023f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023fc:	83 ec 0c             	sub    $0xc,%esp
  8023ff:	ff 75 08             	pushl  0x8(%ebp)
  802402:	e8 6a f3 ff ff       	call   801771 <fd2data>
  802407:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802409:	83 c4 08             	add    $0x8,%esp
  80240c:	68 c0 33 80 00       	push   $0x8033c0
  802411:	53                   	push   %ebx
  802412:	e8 7c e7 ff ff       	call   800b93 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802417:	8b 46 04             	mov    0x4(%esi),%eax
  80241a:	2b 06                	sub    (%esi),%eax
  80241c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802422:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802429:	00 00 00 
	stat->st_dev = &devpipe;
  80242c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802433:	40 80 00 
	return 0;
}
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
  80243b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243e:	5b                   	pop    %ebx
  80243f:	5e                   	pop    %esi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    

00802442 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	53                   	push   %ebx
  802446:	83 ec 0c             	sub    $0xc,%esp
  802449:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80244c:	53                   	push   %ebx
  80244d:	6a 00                	push   $0x0
  80244f:	e8 b6 eb ff ff       	call   80100a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802454:	89 1c 24             	mov    %ebx,(%esp)
  802457:	e8 15 f3 ff ff       	call   801771 <fd2data>
  80245c:	83 c4 08             	add    $0x8,%esp
  80245f:	50                   	push   %eax
  802460:	6a 00                	push   $0x0
  802462:	e8 a3 eb ff ff       	call   80100a <sys_page_unmap>
}
  802467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <_pipeisclosed>:
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	57                   	push   %edi
  802470:	56                   	push   %esi
  802471:	53                   	push   %ebx
  802472:	83 ec 1c             	sub    $0x1c,%esp
  802475:	89 c7                	mov    %eax,%edi
  802477:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802479:	a1 08 50 80 00       	mov    0x805008,%eax
  80247e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802481:	83 ec 0c             	sub    $0xc,%esp
  802484:	57                   	push   %edi
  802485:	e8 be 05 00 00       	call   802a48 <pageref>
  80248a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80248d:	89 34 24             	mov    %esi,(%esp)
  802490:	e8 b3 05 00 00       	call   802a48 <pageref>
		nn = thisenv->env_runs;
  802495:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80249b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80249e:	83 c4 10             	add    $0x10,%esp
  8024a1:	39 cb                	cmp    %ecx,%ebx
  8024a3:	74 1b                	je     8024c0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024a8:	75 cf                	jne    802479 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024aa:	8b 42 58             	mov    0x58(%edx),%eax
  8024ad:	6a 01                	push   $0x1
  8024af:	50                   	push   %eax
  8024b0:	53                   	push   %ebx
  8024b1:	68 c7 33 80 00       	push   $0x8033c7
  8024b6:	e8 79 df ff ff       	call   800434 <cprintf>
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	eb b9                	jmp    802479 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024c0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024c3:	0f 94 c0             	sete   %al
  8024c6:	0f b6 c0             	movzbl %al,%eax
}
  8024c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024cc:	5b                   	pop    %ebx
  8024cd:	5e                   	pop    %esi
  8024ce:	5f                   	pop    %edi
  8024cf:	5d                   	pop    %ebp
  8024d0:	c3                   	ret    

008024d1 <devpipe_write>:
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	57                   	push   %edi
  8024d5:	56                   	push   %esi
  8024d6:	53                   	push   %ebx
  8024d7:	83 ec 28             	sub    $0x28,%esp
  8024da:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024dd:	56                   	push   %esi
  8024de:	e8 8e f2 ff ff       	call   801771 <fd2data>
  8024e3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024e5:	83 c4 10             	add    $0x10,%esp
  8024e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ed:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024f0:	74 4f                	je     802541 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024f2:	8b 43 04             	mov    0x4(%ebx),%eax
  8024f5:	8b 0b                	mov    (%ebx),%ecx
  8024f7:	8d 51 20             	lea    0x20(%ecx),%edx
  8024fa:	39 d0                	cmp    %edx,%eax
  8024fc:	72 14                	jb     802512 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024fe:	89 da                	mov    %ebx,%edx
  802500:	89 f0                	mov    %esi,%eax
  802502:	e8 65 ff ff ff       	call   80246c <_pipeisclosed>
  802507:	85 c0                	test   %eax,%eax
  802509:	75 3b                	jne    802546 <devpipe_write+0x75>
			sys_yield();
  80250b:	e8 56 ea ff ff       	call   800f66 <sys_yield>
  802510:	eb e0                	jmp    8024f2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802512:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802515:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802519:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80251c:	89 c2                	mov    %eax,%edx
  80251e:	c1 fa 1f             	sar    $0x1f,%edx
  802521:	89 d1                	mov    %edx,%ecx
  802523:	c1 e9 1b             	shr    $0x1b,%ecx
  802526:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802529:	83 e2 1f             	and    $0x1f,%edx
  80252c:	29 ca                	sub    %ecx,%edx
  80252e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802532:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802536:	83 c0 01             	add    $0x1,%eax
  802539:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80253c:	83 c7 01             	add    $0x1,%edi
  80253f:	eb ac                	jmp    8024ed <devpipe_write+0x1c>
	return i;
  802541:	8b 45 10             	mov    0x10(%ebp),%eax
  802544:	eb 05                	jmp    80254b <devpipe_write+0x7a>
				return 0;
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80254e:	5b                   	pop    %ebx
  80254f:	5e                   	pop    %esi
  802550:	5f                   	pop    %edi
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    

00802553 <devpipe_read>:
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	57                   	push   %edi
  802557:	56                   	push   %esi
  802558:	53                   	push   %ebx
  802559:	83 ec 18             	sub    $0x18,%esp
  80255c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80255f:	57                   	push   %edi
  802560:	e8 0c f2 ff ff       	call   801771 <fd2data>
  802565:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	be 00 00 00 00       	mov    $0x0,%esi
  80256f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802572:	75 14                	jne    802588 <devpipe_read+0x35>
	return i;
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	eb 02                	jmp    80257b <devpipe_read+0x28>
				return i;
  802579:	89 f0                	mov    %esi,%eax
}
  80257b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5f                   	pop    %edi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    
			sys_yield();
  802583:	e8 de e9 ff ff       	call   800f66 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802588:	8b 03                	mov    (%ebx),%eax
  80258a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80258d:	75 18                	jne    8025a7 <devpipe_read+0x54>
			if (i > 0)
  80258f:	85 f6                	test   %esi,%esi
  802591:	75 e6                	jne    802579 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802593:	89 da                	mov    %ebx,%edx
  802595:	89 f8                	mov    %edi,%eax
  802597:	e8 d0 fe ff ff       	call   80246c <_pipeisclosed>
  80259c:	85 c0                	test   %eax,%eax
  80259e:	74 e3                	je     802583 <devpipe_read+0x30>
				return 0;
  8025a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a5:	eb d4                	jmp    80257b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025a7:	99                   	cltd   
  8025a8:	c1 ea 1b             	shr    $0x1b,%edx
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	83 e0 1f             	and    $0x1f,%eax
  8025b0:	29 d0                	sub    %edx,%eax
  8025b2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ba:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025bd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025c0:	83 c6 01             	add    $0x1,%esi
  8025c3:	eb aa                	jmp    80256f <devpipe_read+0x1c>

008025c5 <pipe>:
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	56                   	push   %esi
  8025c9:	53                   	push   %ebx
  8025ca:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d0:	50                   	push   %eax
  8025d1:	e8 b2 f1 ff ff       	call   801788 <fd_alloc>
  8025d6:	89 c3                	mov    %eax,%ebx
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 88 23 01 00 00    	js     802706 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 07 04 00 00       	push   $0x407
  8025eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ee:	6a 00                	push   $0x0
  8025f0:	e8 90 e9 ff ff       	call   800f85 <sys_page_alloc>
  8025f5:	89 c3                	mov    %eax,%ebx
  8025f7:	83 c4 10             	add    $0x10,%esp
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	0f 88 04 01 00 00    	js     802706 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802602:	83 ec 0c             	sub    $0xc,%esp
  802605:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802608:	50                   	push   %eax
  802609:	e8 7a f1 ff ff       	call   801788 <fd_alloc>
  80260e:	89 c3                	mov    %eax,%ebx
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	85 c0                	test   %eax,%eax
  802615:	0f 88 db 00 00 00    	js     8026f6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261b:	83 ec 04             	sub    $0x4,%esp
  80261e:	68 07 04 00 00       	push   $0x407
  802623:	ff 75 f0             	pushl  -0x10(%ebp)
  802626:	6a 00                	push   $0x0
  802628:	e8 58 e9 ff ff       	call   800f85 <sys_page_alloc>
  80262d:	89 c3                	mov    %eax,%ebx
  80262f:	83 c4 10             	add    $0x10,%esp
  802632:	85 c0                	test   %eax,%eax
  802634:	0f 88 bc 00 00 00    	js     8026f6 <pipe+0x131>
	va = fd2data(fd0);
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	ff 75 f4             	pushl  -0xc(%ebp)
  802640:	e8 2c f1 ff ff       	call   801771 <fd2data>
  802645:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802647:	83 c4 0c             	add    $0xc,%esp
  80264a:	68 07 04 00 00       	push   $0x407
  80264f:	50                   	push   %eax
  802650:	6a 00                	push   $0x0
  802652:	e8 2e e9 ff ff       	call   800f85 <sys_page_alloc>
  802657:	89 c3                	mov    %eax,%ebx
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	85 c0                	test   %eax,%eax
  80265e:	0f 88 82 00 00 00    	js     8026e6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802664:	83 ec 0c             	sub    $0xc,%esp
  802667:	ff 75 f0             	pushl  -0x10(%ebp)
  80266a:	e8 02 f1 ff ff       	call   801771 <fd2data>
  80266f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802676:	50                   	push   %eax
  802677:	6a 00                	push   $0x0
  802679:	56                   	push   %esi
  80267a:	6a 00                	push   $0x0
  80267c:	e8 47 e9 ff ff       	call   800fc8 <sys_page_map>
  802681:	89 c3                	mov    %eax,%ebx
  802683:	83 c4 20             	add    $0x20,%esp
  802686:	85 c0                	test   %eax,%eax
  802688:	78 4e                	js     8026d8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80268a:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802697:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80269e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026ad:	83 ec 0c             	sub    $0xc,%esp
  8026b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b3:	e8 a9 f0 ff ff       	call   801761 <fd2num>
  8026b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026bb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026bd:	83 c4 04             	add    $0x4,%esp
  8026c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026c3:	e8 99 f0 ff ff       	call   801761 <fd2num>
  8026c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026cb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ce:	83 c4 10             	add    $0x10,%esp
  8026d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026d6:	eb 2e                	jmp    802706 <pipe+0x141>
	sys_page_unmap(0, va);
  8026d8:	83 ec 08             	sub    $0x8,%esp
  8026db:	56                   	push   %esi
  8026dc:	6a 00                	push   $0x0
  8026de:	e8 27 e9 ff ff       	call   80100a <sys_page_unmap>
  8026e3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026e6:	83 ec 08             	sub    $0x8,%esp
  8026e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ec:	6a 00                	push   $0x0
  8026ee:	e8 17 e9 ff ff       	call   80100a <sys_page_unmap>
  8026f3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026f6:	83 ec 08             	sub    $0x8,%esp
  8026f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026fc:	6a 00                	push   $0x0
  8026fe:	e8 07 e9 ff ff       	call   80100a <sys_page_unmap>
  802703:	83 c4 10             	add    $0x10,%esp
}
  802706:	89 d8                	mov    %ebx,%eax
  802708:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80270b:	5b                   	pop    %ebx
  80270c:	5e                   	pop    %esi
  80270d:	5d                   	pop    %ebp
  80270e:	c3                   	ret    

0080270f <pipeisclosed>:
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802715:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802718:	50                   	push   %eax
  802719:	ff 75 08             	pushl  0x8(%ebp)
  80271c:	e8 b9 f0 ff ff       	call   8017da <fd_lookup>
  802721:	83 c4 10             	add    $0x10,%esp
  802724:	85 c0                	test   %eax,%eax
  802726:	78 18                	js     802740 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802728:	83 ec 0c             	sub    $0xc,%esp
  80272b:	ff 75 f4             	pushl  -0xc(%ebp)
  80272e:	e8 3e f0 ff ff       	call   801771 <fd2data>
	return _pipeisclosed(fd, p);
  802733:	89 c2                	mov    %eax,%edx
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	e8 2f fd ff ff       	call   80246c <_pipeisclosed>
  80273d:	83 c4 10             	add    $0x10,%esp
}
  802740:	c9                   	leave  
  802741:	c3                   	ret    

00802742 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
  802747:	c3                   	ret    

00802748 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
  80274b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80274e:	68 da 33 80 00       	push   $0x8033da
  802753:	ff 75 0c             	pushl  0xc(%ebp)
  802756:	e8 38 e4 ff ff       	call   800b93 <strcpy>
	return 0;
}
  80275b:	b8 00 00 00 00       	mov    $0x0,%eax
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <devcons_write>:
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	57                   	push   %edi
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80276e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802773:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802779:	3b 75 10             	cmp    0x10(%ebp),%esi
  80277c:	73 31                	jae    8027af <devcons_write+0x4d>
		m = n - tot;
  80277e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802781:	29 f3                	sub    %esi,%ebx
  802783:	83 fb 7f             	cmp    $0x7f,%ebx
  802786:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80278b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80278e:	83 ec 04             	sub    $0x4,%esp
  802791:	53                   	push   %ebx
  802792:	89 f0                	mov    %esi,%eax
  802794:	03 45 0c             	add    0xc(%ebp),%eax
  802797:	50                   	push   %eax
  802798:	57                   	push   %edi
  802799:	e8 83 e5 ff ff       	call   800d21 <memmove>
		sys_cputs(buf, m);
  80279e:	83 c4 08             	add    $0x8,%esp
  8027a1:	53                   	push   %ebx
  8027a2:	57                   	push   %edi
  8027a3:	e8 21 e7 ff ff       	call   800ec9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027a8:	01 de                	add    %ebx,%esi
  8027aa:	83 c4 10             	add    $0x10,%esp
  8027ad:	eb ca                	jmp    802779 <devcons_write+0x17>
}
  8027af:	89 f0                	mov    %esi,%eax
  8027b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027b4:	5b                   	pop    %ebx
  8027b5:	5e                   	pop    %esi
  8027b6:	5f                   	pop    %edi
  8027b7:	5d                   	pop    %ebp
  8027b8:	c3                   	ret    

008027b9 <devcons_read>:
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
  8027bc:	83 ec 08             	sub    $0x8,%esp
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027c8:	74 21                	je     8027eb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027ca:	e8 18 e7 ff ff       	call   800ee7 <sys_cgetc>
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	75 07                	jne    8027da <devcons_read+0x21>
		sys_yield();
  8027d3:	e8 8e e7 ff ff       	call   800f66 <sys_yield>
  8027d8:	eb f0                	jmp    8027ca <devcons_read+0x11>
	if (c < 0)
  8027da:	78 0f                	js     8027eb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027dc:	83 f8 04             	cmp    $0x4,%eax
  8027df:	74 0c                	je     8027ed <devcons_read+0x34>
	*(char*)vbuf = c;
  8027e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e4:	88 02                	mov    %al,(%edx)
	return 1;
  8027e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    
		return 0;
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	eb f7                	jmp    8027eb <devcons_read+0x32>

008027f4 <cputchar>:
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802800:	6a 01                	push   $0x1
  802802:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802805:	50                   	push   %eax
  802806:	e8 be e6 ff ff       	call   800ec9 <sys_cputs>
}
  80280b:	83 c4 10             	add    $0x10,%esp
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <getchar>:
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802816:	6a 01                	push   $0x1
  802818:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80281b:	50                   	push   %eax
  80281c:	6a 00                	push   $0x0
  80281e:	e8 27 f2 ff ff       	call   801a4a <read>
	if (r < 0)
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	85 c0                	test   %eax,%eax
  802828:	78 06                	js     802830 <getchar+0x20>
	if (r < 1)
  80282a:	74 06                	je     802832 <getchar+0x22>
	return c;
  80282c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802830:	c9                   	leave  
  802831:	c3                   	ret    
		return -E_EOF;
  802832:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802837:	eb f7                	jmp    802830 <getchar+0x20>

00802839 <iscons>:
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80283f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802842:	50                   	push   %eax
  802843:	ff 75 08             	pushl  0x8(%ebp)
  802846:	e8 8f ef ff ff       	call   8017da <fd_lookup>
  80284b:	83 c4 10             	add    $0x10,%esp
  80284e:	85 c0                	test   %eax,%eax
  802850:	78 11                	js     802863 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80285b:	39 10                	cmp    %edx,(%eax)
  80285d:	0f 94 c0             	sete   %al
  802860:	0f b6 c0             	movzbl %al,%eax
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <opencons>:
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80286b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80286e:	50                   	push   %eax
  80286f:	e8 14 ef ff ff       	call   801788 <fd_alloc>
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	85 c0                	test   %eax,%eax
  802879:	78 3a                	js     8028b5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 07 04 00 00       	push   $0x407
  802883:	ff 75 f4             	pushl  -0xc(%ebp)
  802886:	6a 00                	push   $0x0
  802888:	e8 f8 e6 ff ff       	call   800f85 <sys_page_alloc>
  80288d:	83 c4 10             	add    $0x10,%esp
  802890:	85 c0                	test   %eax,%eax
  802892:	78 21                	js     8028b5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80289d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028a9:	83 ec 0c             	sub    $0xc,%esp
  8028ac:	50                   	push   %eax
  8028ad:	e8 af ee ff ff       	call   801761 <fd2num>
  8028b2:	83 c4 10             	add    $0x10,%esp
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028bd:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028c4:	74 0a                	je     8028d0 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	6a 07                	push   $0x7
  8028d5:	68 00 f0 bf ee       	push   $0xeebff000
  8028da:	6a 00                	push   $0x0
  8028dc:	e8 a4 e6 ff ff       	call   800f85 <sys_page_alloc>
		if(r < 0)
  8028e1:	83 c4 10             	add    $0x10,%esp
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	78 2a                	js     802912 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028e8:	83 ec 08             	sub    $0x8,%esp
  8028eb:	68 26 29 80 00       	push   $0x802926
  8028f0:	6a 00                	push   $0x0
  8028f2:	e8 d9 e7 ff ff       	call   8010d0 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	79 c8                	jns    8028c6 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	68 18 34 80 00       	push   $0x803418
  802906:	6a 25                	push   $0x25
  802908:	68 54 34 80 00       	push   $0x803454
  80290d:	e8 2c da ff ff       	call   80033e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	68 e8 33 80 00       	push   $0x8033e8
  80291a:	6a 22                	push   $0x22
  80291c:	68 54 34 80 00       	push   $0x803454
  802921:	e8 18 da ff ff       	call   80033e <_panic>

00802926 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802926:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802927:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80292c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80292e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802931:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802935:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802939:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80293c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80293e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802942:	83 c4 08             	add    $0x8,%esp
	popal
  802945:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802946:	83 c4 04             	add    $0x4,%esp
	popfl
  802949:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80294a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80294b:	c3                   	ret    

0080294c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	56                   	push   %esi
  802950:	53                   	push   %ebx
  802951:	8b 75 08             	mov    0x8(%ebp),%esi
  802954:	8b 45 0c             	mov    0xc(%ebp),%eax
  802957:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80295a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80295c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802961:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	50                   	push   %eax
  802968:	e8 c8 e7 ff ff       	call   801135 <sys_ipc_recv>
	if(ret < 0){
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	85 c0                	test   %eax,%eax
  802972:	78 2b                	js     80299f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802974:	85 f6                	test   %esi,%esi
  802976:	74 0a                	je     802982 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802978:	a1 08 50 80 00       	mov    0x805008,%eax
  80297d:	8b 40 74             	mov    0x74(%eax),%eax
  802980:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802982:	85 db                	test   %ebx,%ebx
  802984:	74 0a                	je     802990 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802986:	a1 08 50 80 00       	mov    0x805008,%eax
  80298b:	8b 40 78             	mov    0x78(%eax),%eax
  80298e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802990:	a1 08 50 80 00       	mov    0x805008,%eax
  802995:	8b 40 70             	mov    0x70(%eax),%eax
}
  802998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80299b:	5b                   	pop    %ebx
  80299c:	5e                   	pop    %esi
  80299d:	5d                   	pop    %ebp
  80299e:	c3                   	ret    
		if(from_env_store)
  80299f:	85 f6                	test   %esi,%esi
  8029a1:	74 06                	je     8029a9 <ipc_recv+0x5d>
			*from_env_store = 0;
  8029a3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8029a9:	85 db                	test   %ebx,%ebx
  8029ab:	74 eb                	je     802998 <ipc_recv+0x4c>
			*perm_store = 0;
  8029ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8029b3:	eb e3                	jmp    802998 <ipc_recv+0x4c>

008029b5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	57                   	push   %edi
  8029b9:	56                   	push   %esi
  8029ba:	53                   	push   %ebx
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8029c7:	85 db                	test   %ebx,%ebx
  8029c9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029ce:	0f 44 d8             	cmove  %eax,%ebx
  8029d1:	eb 05                	jmp    8029d8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8029d3:	e8 8e e5 ff ff       	call   800f66 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029d8:	ff 75 14             	pushl  0x14(%ebp)
  8029db:	53                   	push   %ebx
  8029dc:	56                   	push   %esi
  8029dd:	57                   	push   %edi
  8029de:	e8 2f e7 ff ff       	call   801112 <sys_ipc_try_send>
  8029e3:	83 c4 10             	add    $0x10,%esp
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 1b                	je     802a05 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029ea:	79 e7                	jns    8029d3 <ipc_send+0x1e>
  8029ec:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029ef:	74 e2                	je     8029d3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029f1:	83 ec 04             	sub    $0x4,%esp
  8029f4:	68 62 34 80 00       	push   $0x803462
  8029f9:	6a 46                	push   $0x46
  8029fb:	68 77 34 80 00       	push   $0x803477
  802a00:	e8 39 d9 ff ff       	call   80033e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a08:	5b                   	pop    %ebx
  802a09:	5e                   	pop    %esi
  802a0a:	5f                   	pop    %edi
  802a0b:	5d                   	pop    %ebp
  802a0c:	c3                   	ret    

00802a0d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a0d:	55                   	push   %ebp
  802a0e:	89 e5                	mov    %esp,%ebp
  802a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a18:	89 c2                	mov    %eax,%edx
  802a1a:	c1 e2 07             	shl    $0x7,%edx
  802a1d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a23:	8b 52 50             	mov    0x50(%edx),%edx
  802a26:	39 ca                	cmp    %ecx,%edx
  802a28:	74 11                	je     802a3b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802a2a:	83 c0 01             	add    $0x1,%eax
  802a2d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a32:	75 e4                	jne    802a18 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a34:	b8 00 00 00 00       	mov    $0x0,%eax
  802a39:	eb 0b                	jmp    802a46 <ipc_find_env+0x39>
			return envs[i].env_id;
  802a3b:	c1 e0 07             	shl    $0x7,%eax
  802a3e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a43:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a46:	5d                   	pop    %ebp
  802a47:	c3                   	ret    

00802a48 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a4e:	89 d0                	mov    %edx,%eax
  802a50:	c1 e8 16             	shr    $0x16,%eax
  802a53:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a5a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a5f:	f6 c1 01             	test   $0x1,%cl
  802a62:	74 1d                	je     802a81 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a64:	c1 ea 0c             	shr    $0xc,%edx
  802a67:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a6e:	f6 c2 01             	test   $0x1,%dl
  802a71:	74 0e                	je     802a81 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a73:	c1 ea 0c             	shr    $0xc,%edx
  802a76:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a7d:	ef 
  802a7e:	0f b7 c0             	movzwl %ax,%eax
}
  802a81:	5d                   	pop    %ebp
  802a82:	c3                   	ret    
  802a83:	66 90                	xchg   %ax,%ax
  802a85:	66 90                	xchg   %ax,%ax
  802a87:	66 90                	xchg   %ax,%ax
  802a89:	66 90                	xchg   %ax,%ax
  802a8b:	66 90                	xchg   %ax,%ax
  802a8d:	66 90                	xchg   %ax,%ax
  802a8f:	90                   	nop

00802a90 <__udivdi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	53                   	push   %ebx
  802a94:	83 ec 1c             	sub    $0x1c,%esp
  802a97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802aa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802aa7:	85 d2                	test   %edx,%edx
  802aa9:	75 4d                	jne    802af8 <__udivdi3+0x68>
  802aab:	39 f3                	cmp    %esi,%ebx
  802aad:	76 19                	jbe    802ac8 <__udivdi3+0x38>
  802aaf:	31 ff                	xor    %edi,%edi
  802ab1:	89 e8                	mov    %ebp,%eax
  802ab3:	89 f2                	mov    %esi,%edx
  802ab5:	f7 f3                	div    %ebx
  802ab7:	89 fa                	mov    %edi,%edx
  802ab9:	83 c4 1c             	add    $0x1c,%esp
  802abc:	5b                   	pop    %ebx
  802abd:	5e                   	pop    %esi
  802abe:	5f                   	pop    %edi
  802abf:	5d                   	pop    %ebp
  802ac0:	c3                   	ret    
  802ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	89 d9                	mov    %ebx,%ecx
  802aca:	85 db                	test   %ebx,%ebx
  802acc:	75 0b                	jne    802ad9 <__udivdi3+0x49>
  802ace:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad3:	31 d2                	xor    %edx,%edx
  802ad5:	f7 f3                	div    %ebx
  802ad7:	89 c1                	mov    %eax,%ecx
  802ad9:	31 d2                	xor    %edx,%edx
  802adb:	89 f0                	mov    %esi,%eax
  802add:	f7 f1                	div    %ecx
  802adf:	89 c6                	mov    %eax,%esi
  802ae1:	89 e8                	mov    %ebp,%eax
  802ae3:	89 f7                	mov    %esi,%edi
  802ae5:	f7 f1                	div    %ecx
  802ae7:	89 fa                	mov    %edi,%edx
  802ae9:	83 c4 1c             	add    $0x1c,%esp
  802aec:	5b                   	pop    %ebx
  802aed:	5e                   	pop    %esi
  802aee:	5f                   	pop    %edi
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802af8:	39 f2                	cmp    %esi,%edx
  802afa:	77 1c                	ja     802b18 <__udivdi3+0x88>
  802afc:	0f bd fa             	bsr    %edx,%edi
  802aff:	83 f7 1f             	xor    $0x1f,%edi
  802b02:	75 2c                	jne    802b30 <__udivdi3+0xa0>
  802b04:	39 f2                	cmp    %esi,%edx
  802b06:	72 06                	jb     802b0e <__udivdi3+0x7e>
  802b08:	31 c0                	xor    %eax,%eax
  802b0a:	39 eb                	cmp    %ebp,%ebx
  802b0c:	77 a9                	ja     802ab7 <__udivdi3+0x27>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	eb a2                	jmp    802ab7 <__udivdi3+0x27>
  802b15:	8d 76 00             	lea    0x0(%esi),%esi
  802b18:	31 ff                	xor    %edi,%edi
  802b1a:	31 c0                	xor    %eax,%eax
  802b1c:	89 fa                	mov    %edi,%edx
  802b1e:	83 c4 1c             	add    $0x1c,%esp
  802b21:	5b                   	pop    %ebx
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2d:	8d 76 00             	lea    0x0(%esi),%esi
  802b30:	89 f9                	mov    %edi,%ecx
  802b32:	b8 20 00 00 00       	mov    $0x20,%eax
  802b37:	29 f8                	sub    %edi,%eax
  802b39:	d3 e2                	shl    %cl,%edx
  802b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b3f:	89 c1                	mov    %eax,%ecx
  802b41:	89 da                	mov    %ebx,%edx
  802b43:	d3 ea                	shr    %cl,%edx
  802b45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b49:	09 d1                	or     %edx,%ecx
  802b4b:	89 f2                	mov    %esi,%edx
  802b4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b51:	89 f9                	mov    %edi,%ecx
  802b53:	d3 e3                	shl    %cl,%ebx
  802b55:	89 c1                	mov    %eax,%ecx
  802b57:	d3 ea                	shr    %cl,%edx
  802b59:	89 f9                	mov    %edi,%ecx
  802b5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b5f:	89 eb                	mov    %ebp,%ebx
  802b61:	d3 e6                	shl    %cl,%esi
  802b63:	89 c1                	mov    %eax,%ecx
  802b65:	d3 eb                	shr    %cl,%ebx
  802b67:	09 de                	or     %ebx,%esi
  802b69:	89 f0                	mov    %esi,%eax
  802b6b:	f7 74 24 08          	divl   0x8(%esp)
  802b6f:	89 d6                	mov    %edx,%esi
  802b71:	89 c3                	mov    %eax,%ebx
  802b73:	f7 64 24 0c          	mull   0xc(%esp)
  802b77:	39 d6                	cmp    %edx,%esi
  802b79:	72 15                	jb     802b90 <__udivdi3+0x100>
  802b7b:	89 f9                	mov    %edi,%ecx
  802b7d:	d3 e5                	shl    %cl,%ebp
  802b7f:	39 c5                	cmp    %eax,%ebp
  802b81:	73 04                	jae    802b87 <__udivdi3+0xf7>
  802b83:	39 d6                	cmp    %edx,%esi
  802b85:	74 09                	je     802b90 <__udivdi3+0x100>
  802b87:	89 d8                	mov    %ebx,%eax
  802b89:	31 ff                	xor    %edi,%edi
  802b8b:	e9 27 ff ff ff       	jmp    802ab7 <__udivdi3+0x27>
  802b90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b93:	31 ff                	xor    %edi,%edi
  802b95:	e9 1d ff ff ff       	jmp    802ab7 <__udivdi3+0x27>
  802b9a:	66 90                	xchg   %ax,%ax
  802b9c:	66 90                	xchg   %ax,%ax
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <__umoddi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	53                   	push   %ebx
  802ba4:	83 ec 1c             	sub    $0x1c,%esp
  802ba7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802bab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802baf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bb7:	89 da                	mov    %ebx,%edx
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	75 43                	jne    802c00 <__umoddi3+0x60>
  802bbd:	39 df                	cmp    %ebx,%edi
  802bbf:	76 17                	jbe    802bd8 <__umoddi3+0x38>
  802bc1:	89 f0                	mov    %esi,%eax
  802bc3:	f7 f7                	div    %edi
  802bc5:	89 d0                	mov    %edx,%eax
  802bc7:	31 d2                	xor    %edx,%edx
  802bc9:	83 c4 1c             	add    $0x1c,%esp
  802bcc:	5b                   	pop    %ebx
  802bcd:	5e                   	pop    %esi
  802bce:	5f                   	pop    %edi
  802bcf:	5d                   	pop    %ebp
  802bd0:	c3                   	ret    
  802bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	89 fd                	mov    %edi,%ebp
  802bda:	85 ff                	test   %edi,%edi
  802bdc:	75 0b                	jne    802be9 <__umoddi3+0x49>
  802bde:	b8 01 00 00 00       	mov    $0x1,%eax
  802be3:	31 d2                	xor    %edx,%edx
  802be5:	f7 f7                	div    %edi
  802be7:	89 c5                	mov    %eax,%ebp
  802be9:	89 d8                	mov    %ebx,%eax
  802beb:	31 d2                	xor    %edx,%edx
  802bed:	f7 f5                	div    %ebp
  802bef:	89 f0                	mov    %esi,%eax
  802bf1:	f7 f5                	div    %ebp
  802bf3:	89 d0                	mov    %edx,%eax
  802bf5:	eb d0                	jmp    802bc7 <__umoddi3+0x27>
  802bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfe:	66 90                	xchg   %ax,%ax
  802c00:	89 f1                	mov    %esi,%ecx
  802c02:	39 d8                	cmp    %ebx,%eax
  802c04:	76 0a                	jbe    802c10 <__umoddi3+0x70>
  802c06:	89 f0                	mov    %esi,%eax
  802c08:	83 c4 1c             	add    $0x1c,%esp
  802c0b:	5b                   	pop    %ebx
  802c0c:	5e                   	pop    %esi
  802c0d:	5f                   	pop    %edi
  802c0e:	5d                   	pop    %ebp
  802c0f:	c3                   	ret    
  802c10:	0f bd e8             	bsr    %eax,%ebp
  802c13:	83 f5 1f             	xor    $0x1f,%ebp
  802c16:	75 20                	jne    802c38 <__umoddi3+0x98>
  802c18:	39 d8                	cmp    %ebx,%eax
  802c1a:	0f 82 b0 00 00 00    	jb     802cd0 <__umoddi3+0x130>
  802c20:	39 f7                	cmp    %esi,%edi
  802c22:	0f 86 a8 00 00 00    	jbe    802cd0 <__umoddi3+0x130>
  802c28:	89 c8                	mov    %ecx,%eax
  802c2a:	83 c4 1c             	add    $0x1c,%esp
  802c2d:	5b                   	pop    %ebx
  802c2e:	5e                   	pop    %esi
  802c2f:	5f                   	pop    %edi
  802c30:	5d                   	pop    %ebp
  802c31:	c3                   	ret    
  802c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c3f:	29 ea                	sub    %ebp,%edx
  802c41:	d3 e0                	shl    %cl,%eax
  802c43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c47:	89 d1                	mov    %edx,%ecx
  802c49:	89 f8                	mov    %edi,%eax
  802c4b:	d3 e8                	shr    %cl,%eax
  802c4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c59:	09 c1                	or     %eax,%ecx
  802c5b:	89 d8                	mov    %ebx,%eax
  802c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c61:	89 e9                	mov    %ebp,%ecx
  802c63:	d3 e7                	shl    %cl,%edi
  802c65:	89 d1                	mov    %edx,%ecx
  802c67:	d3 e8                	shr    %cl,%eax
  802c69:	89 e9                	mov    %ebp,%ecx
  802c6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c6f:	d3 e3                	shl    %cl,%ebx
  802c71:	89 c7                	mov    %eax,%edi
  802c73:	89 d1                	mov    %edx,%ecx
  802c75:	89 f0                	mov    %esi,%eax
  802c77:	d3 e8                	shr    %cl,%eax
  802c79:	89 e9                	mov    %ebp,%ecx
  802c7b:	89 fa                	mov    %edi,%edx
  802c7d:	d3 e6                	shl    %cl,%esi
  802c7f:	09 d8                	or     %ebx,%eax
  802c81:	f7 74 24 08          	divl   0x8(%esp)
  802c85:	89 d1                	mov    %edx,%ecx
  802c87:	89 f3                	mov    %esi,%ebx
  802c89:	f7 64 24 0c          	mull   0xc(%esp)
  802c8d:	89 c6                	mov    %eax,%esi
  802c8f:	89 d7                	mov    %edx,%edi
  802c91:	39 d1                	cmp    %edx,%ecx
  802c93:	72 06                	jb     802c9b <__umoddi3+0xfb>
  802c95:	75 10                	jne    802ca7 <__umoddi3+0x107>
  802c97:	39 c3                	cmp    %eax,%ebx
  802c99:	73 0c                	jae    802ca7 <__umoddi3+0x107>
  802c9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ca3:	89 d7                	mov    %edx,%edi
  802ca5:	89 c6                	mov    %eax,%esi
  802ca7:	89 ca                	mov    %ecx,%edx
  802ca9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802cae:	29 f3                	sub    %esi,%ebx
  802cb0:	19 fa                	sbb    %edi,%edx
  802cb2:	89 d0                	mov    %edx,%eax
  802cb4:	d3 e0                	shl    %cl,%eax
  802cb6:	89 e9                	mov    %ebp,%ecx
  802cb8:	d3 eb                	shr    %cl,%ebx
  802cba:	d3 ea                	shr    %cl,%edx
  802cbc:	09 d8                	or     %ebx,%eax
  802cbe:	83 c4 1c             	add    $0x1c,%esp
  802cc1:	5b                   	pop    %ebx
  802cc2:	5e                   	pop    %esi
  802cc3:	5f                   	pop    %edi
  802cc4:	5d                   	pop    %ebp
  802cc5:	c3                   	ret    
  802cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ccd:	8d 76 00             	lea    0x0(%esi),%esi
  802cd0:	89 da                	mov    %ebx,%edx
  802cd2:	29 fe                	sub    %edi,%esi
  802cd4:	19 c2                	sbb    %eax,%edx
  802cd6:	89 f1                	mov    %esi,%ecx
  802cd8:	89 c8                	mov    %ecx,%eax
  802cda:	e9 4b ff ff ff       	jmp    802c2a <__umoddi3+0x8a>
