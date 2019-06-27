
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
  800062:	e8 d9 02 00 00       	call   800340 <_panic>
		panic("pipe: %e", i);
  800067:	50                   	push   %eax
  800068:	68 25 2d 80 00       	push   $0x802d25
  80006d:	6a 1b                	push   $0x1b
  80006f:	68 0f 2d 80 00       	push   $0x802d0f
  800074:	e8 c7 02 00 00       	call   800340 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  800079:	50                   	push   %eax
  80007a:	68 2e 2d 80 00       	push   $0x802d2e
  80007f:	6a 1d                	push   $0x1d
  800081:	68 0f 2d 80 00       	push   $0x802d0f
  800086:	e8 b5 02 00 00       	call   800340 <_panic>
	if (id == 0) {
		close(fd);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	53                   	push   %ebx
  80008f:	e8 80 18 00 00       	call   801914 <close>
		close(pfd[1]);
  800094:	83 c4 04             	add    $0x4,%esp
  800097:	ff 75 dc             	pushl  -0x24(%ebp)
  80009a:	e8 75 18 00 00       	call   801914 <close>
		fd = pfd[0];
  80009f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a2:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 04                	push   $0x4
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	e8 28 1a 00 00       	call   801ad9 <readn>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	83 f8 04             	cmp    $0x4,%eax
  8000b7:	75 8e                	jne    800047 <primeproc+0x14>
	cprintf("%d\n", p);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 21 2d 80 00       	push   $0x802d21
  8000c4:	e8 6d 03 00 00       	call   800436 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000c9:	89 3c 24             	mov    %edi,(%esp)
  8000cc:	e8 fc 24 00 00       	call   8025cd <pipe>
  8000d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	78 8c                	js     800067 <primeproc+0x34>
	if ((id = fork()) < 0)
  8000db:	e8 f1 13 00 00       	call   8014d1 <fork>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	78 95                	js     800079 <primeproc+0x46>
	if (id == 0) {
  8000e4:	74 a5                	je     80008b <primeproc+0x58>
	}

	close(pfd[0]);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ec:	e8 23 18 00 00       	call   801914 <close>
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
  800101:	e8 d3 19 00 00       	call   801ad9 <readn>
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
  800120:	e8 f9 19 00 00       	call   801b1e <write>
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
  80014b:	e8 f0 01 00 00       	call   800340 <_panic>
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
  80016f:	e8 cc 01 00 00       	call   800340 <_panic>

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
  800189:	e8 3f 24 00 00       	call   8025cd <pipe>
  80018e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800191:	83 c4 10             	add    $0x10,%esp
  800194:	85 c0                	test   %eax,%eax
  800196:	78 21                	js     8001b9 <umain+0x45>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800198:	e8 34 13 00 00       	call   8014d1 <fork>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 2a                	js     8001cb <umain+0x57>
		panic("fork: %e", id);

	if (id == 0) {
  8001a1:	75 3a                	jne    8001dd <umain+0x69>
		close(p[1]);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 66 17 00 00       	call   801914 <close>
		primeproc(p[0]);
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001b9:	50                   	push   %eax
  8001ba:	68 25 2d 80 00       	push   $0x802d25
  8001bf:	6a 3a                	push   $0x3a
  8001c1:	68 0f 2d 80 00       	push   $0x802d0f
  8001c6:	e8 75 01 00 00       	call   800340 <_panic>
		panic("fork: %e", id);
  8001cb:	50                   	push   %eax
  8001cc:	68 2e 2d 80 00       	push   $0x802d2e
  8001d1:	6a 3e                	push   $0x3e
  8001d3:	68 0f 2d 80 00       	push   $0x802d0f
  8001d8:	e8 63 01 00 00       	call   800340 <_panic>
	}

	close(p[0]);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e3:	e8 2c 17 00 00       	call   801914 <close>

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
  8001fe:	e8 1b 19 00 00       	call   801b1e <write>
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
  80022c:	e8 0f 01 00 00       	call   800340 <_panic>

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
  800244:	e8 00 0d 00 00       	call   800f49 <sys_getenvid>
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
  800269:	74 23                	je     80028e <libmain+0x5d>
		if(envs[i].env_id == find)
  80026b:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800271:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800277:	8b 49 48             	mov    0x48(%ecx),%ecx
  80027a:	39 c1                	cmp    %eax,%ecx
  80027c:	75 e2                	jne    800260 <libmain+0x2f>
  80027e:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800284:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80028a:	89 fe                	mov    %edi,%esi
  80028c:	eb d2                	jmp    800260 <libmain+0x2f>
  80028e:	89 f0                	mov    %esi,%eax
  800290:	84 c0                	test   %al,%al
  800292:	74 06                	je     80029a <libmain+0x69>
  800294:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x79>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8002aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8002af:	8b 40 48             	mov    0x48(%eax),%eax
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	50                   	push   %eax
  8002b6:	68 90 2d 80 00       	push   $0x802d90
  8002bb:	e8 76 01 00 00       	call   800436 <cprintf>
	cprintf("before umain\n");
  8002c0:	c7 04 24 ae 2d 80 00 	movl   $0x802dae,(%esp)
  8002c7:	e8 6a 01 00 00       	call   800436 <cprintf>
	// call user main routine
	umain(argc, argv);
  8002cc:	83 c4 08             	add    $0x8,%esp
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 9a fe ff ff       	call   800174 <umain>
	cprintf("after umain\n");
  8002da:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  8002e1:	e8 50 01 00 00       	call   800436 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8002e6:	a1 08 50 80 00       	mov    0x805008,%eax
  8002eb:	8b 40 48             	mov    0x48(%eax),%eax
  8002ee:	83 c4 08             	add    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 c9 2d 80 00       	push   $0x802dc9
  8002f7:	e8 3a 01 00 00       	call   800436 <cprintf>
	// exit gracefully
	exit();
  8002fc:	e8 0b 00 00 00       	call   80030c <exit>
}
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800307:	5b                   	pop    %ebx
  800308:	5e                   	pop    %esi
  800309:	5f                   	pop    %edi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800312:	a1 08 50 80 00       	mov    0x805008,%eax
  800317:	8b 40 48             	mov    0x48(%eax),%eax
  80031a:	68 f4 2d 80 00       	push   $0x802df4
  80031f:	50                   	push   %eax
  800320:	68 e8 2d 80 00       	push   $0x802de8
  800325:	e8 0c 01 00 00       	call   800436 <cprintf>
	close_all();
  80032a:	e8 12 16 00 00       	call   801941 <close_all>
	sys_env_destroy(0);
  80032f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800336:	e8 cd 0b 00 00       	call   800f08 <sys_env_destroy>
}
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800345:	a1 08 50 80 00       	mov    0x805008,%eax
  80034a:	8b 40 48             	mov    0x48(%eax),%eax
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 20 2e 80 00       	push   $0x802e20
  800355:	50                   	push   %eax
  800356:	68 e8 2d 80 00       	push   $0x802de8
  80035b:	e8 d6 00 00 00       	call   800436 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800360:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800363:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800369:	e8 db 0b 00 00       	call   800f49 <sys_getenvid>
  80036e:	83 c4 04             	add    $0x4,%esp
  800371:	ff 75 0c             	pushl  0xc(%ebp)
  800374:	ff 75 08             	pushl  0x8(%ebp)
  800377:	56                   	push   %esi
  800378:	50                   	push   %eax
  800379:	68 fc 2d 80 00       	push   $0x802dfc
  80037e:	e8 b3 00 00 00       	call   800436 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800383:	83 c4 18             	add    $0x18,%esp
  800386:	53                   	push   %ebx
  800387:	ff 75 10             	pushl  0x10(%ebp)
  80038a:	e8 56 00 00 00       	call   8003e5 <vcprintf>
	cprintf("\n");
  80038f:	c7 04 24 ac 2d 80 00 	movl   $0x802dac,(%esp)
  800396:	e8 9b 00 00 00       	call   800436 <cprintf>
  80039b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039e:	cc                   	int3   
  80039f:	eb fd                	jmp    80039e <_panic+0x5e>

008003a1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	53                   	push   %ebx
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ab:	8b 13                	mov    (%ebx),%edx
  8003ad:	8d 42 01             	lea    0x1(%edx),%eax
  8003b0:	89 03                	mov    %eax,(%ebx)
  8003b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003be:	74 09                	je     8003c9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003c0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c7:	c9                   	leave  
  8003c8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	68 ff 00 00 00       	push   $0xff
  8003d1:	8d 43 08             	lea    0x8(%ebx),%eax
  8003d4:	50                   	push   %eax
  8003d5:	e8 f1 0a 00 00       	call   800ecb <sys_cputs>
		b->idx = 0;
  8003da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	eb db                	jmp    8003c0 <putch+0x1f>

008003e5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f5:	00 00 00 
	b.cnt = 0;
  8003f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040e:	50                   	push   %eax
  80040f:	68 a1 03 80 00       	push   $0x8003a1
  800414:	e8 4a 01 00 00       	call   800563 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800419:	83 c4 08             	add    $0x8,%esp
  80041c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800422:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800428:	50                   	push   %eax
  800429:	e8 9d 0a 00 00       	call   800ecb <sys_cputs>

	return b.cnt;
}
  80042e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80043c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80043f:	50                   	push   %eax
  800440:	ff 75 08             	pushl  0x8(%ebp)
  800443:	e8 9d ff ff ff       	call   8003e5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800448:	c9                   	leave  
  800449:	c3                   	ret    

0080044a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	57                   	push   %edi
  80044e:	56                   	push   %esi
  80044f:	53                   	push   %ebx
  800450:	83 ec 1c             	sub    $0x1c,%esp
  800453:	89 c6                	mov    %eax,%esi
  800455:	89 d7                	mov    %edx,%edi
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800460:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800463:	8b 45 10             	mov    0x10(%ebp),%eax
  800466:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800469:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80046d:	74 2c                	je     80049b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80046f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800472:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800479:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800484:	73 43                	jae    8004c9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800486:	83 eb 01             	sub    $0x1,%ebx
  800489:	85 db                	test   %ebx,%ebx
  80048b:	7e 6c                	jle    8004f9 <printnum+0xaf>
				putch(padc, putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	57                   	push   %edi
  800491:	ff 75 18             	pushl  0x18(%ebp)
  800494:	ff d6                	call   *%esi
  800496:	83 c4 10             	add    $0x10,%esp
  800499:	eb eb                	jmp    800486 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	6a 20                	push   $0x20
  8004a0:	6a 00                	push   $0x0
  8004a2:	50                   	push   %eax
  8004a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a9:	89 fa                	mov    %edi,%edx
  8004ab:	89 f0                	mov    %esi,%eax
  8004ad:	e8 98 ff ff ff       	call   80044a <printnum>
		while (--width > 0)
  8004b2:	83 c4 20             	add    $0x20,%esp
  8004b5:	83 eb 01             	sub    $0x1,%ebx
  8004b8:	85 db                	test   %ebx,%ebx
  8004ba:	7e 65                	jle    800521 <printnum+0xd7>
			putch(padc, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	57                   	push   %edi
  8004c0:	6a 20                	push   $0x20
  8004c2:	ff d6                	call   *%esi
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	eb ec                	jmp    8004b5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c9:	83 ec 0c             	sub    $0xc,%esp
  8004cc:	ff 75 18             	pushl  0x18(%ebp)
  8004cf:	83 eb 01             	sub    $0x1,%ebx
  8004d2:	53                   	push   %ebx
  8004d3:	50                   	push   %eax
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8004da:	ff 75 d8             	pushl  -0x28(%ebp)
  8004dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e3:	e8 a8 25 00 00       	call   802a90 <__udivdi3>
  8004e8:	83 c4 18             	add    $0x18,%esp
  8004eb:	52                   	push   %edx
  8004ec:	50                   	push   %eax
  8004ed:	89 fa                	mov    %edi,%edx
  8004ef:	89 f0                	mov    %esi,%eax
  8004f1:	e8 54 ff ff ff       	call   80044a <printnum>
  8004f6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	57                   	push   %edi
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 dc             	pushl  -0x24(%ebp)
  800503:	ff 75 d8             	pushl  -0x28(%ebp)
  800506:	ff 75 e4             	pushl  -0x1c(%ebp)
  800509:	ff 75 e0             	pushl  -0x20(%ebp)
  80050c:	e8 8f 26 00 00       	call   802ba0 <__umoddi3>
  800511:	83 c4 14             	add    $0x14,%esp
  800514:	0f be 80 27 2e 80 00 	movsbl 0x802e27(%eax),%eax
  80051b:	50                   	push   %eax
  80051c:	ff d6                	call   *%esi
  80051e:	83 c4 10             	add    $0x10,%esp
	}
}
  800521:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800524:	5b                   	pop    %ebx
  800525:	5e                   	pop    %esi
  800526:	5f                   	pop    %edi
  800527:	5d                   	pop    %ebp
  800528:	c3                   	ret    

00800529 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80052f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800533:	8b 10                	mov    (%eax),%edx
  800535:	3b 50 04             	cmp    0x4(%eax),%edx
  800538:	73 0a                	jae    800544 <sprintputch+0x1b>
		*b->buf++ = ch;
  80053a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80053d:	89 08                	mov    %ecx,(%eax)
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	88 02                	mov    %al,(%edx)
}
  800544:	5d                   	pop    %ebp
  800545:	c3                   	ret    

00800546 <printfmt>:
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80054c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80054f:	50                   	push   %eax
  800550:	ff 75 10             	pushl  0x10(%ebp)
  800553:	ff 75 0c             	pushl  0xc(%ebp)
  800556:	ff 75 08             	pushl  0x8(%ebp)
  800559:	e8 05 00 00 00       	call   800563 <vprintfmt>
}
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <vprintfmt>:
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	57                   	push   %edi
  800567:	56                   	push   %esi
  800568:	53                   	push   %ebx
  800569:	83 ec 3c             	sub    $0x3c,%esp
  80056c:	8b 75 08             	mov    0x8(%ebp),%esi
  80056f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800572:	8b 7d 10             	mov    0x10(%ebp),%edi
  800575:	e9 32 04 00 00       	jmp    8009ac <vprintfmt+0x449>
		padc = ' ';
  80057a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80057e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800585:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80058c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800593:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005a1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005a6:	8d 47 01             	lea    0x1(%edi),%eax
  8005a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ac:	0f b6 17             	movzbl (%edi),%edx
  8005af:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005b2:	3c 55                	cmp    $0x55,%al
  8005b4:	0f 87 12 05 00 00    	ja     800acc <vprintfmt+0x569>
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	ff 24 85 00 30 80 00 	jmp    *0x803000(,%eax,4)
  8005c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005c7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005cb:	eb d9                	jmp    8005a6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005d0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005d4:	eb d0                	jmp    8005a6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005d6:	0f b6 d2             	movzbl %dl,%edx
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e4:	eb 03                	jmp    8005e9 <vprintfmt+0x86>
  8005e6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005e9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005ec:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005f0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005f3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005f6:	83 fe 09             	cmp    $0x9,%esi
  8005f9:	76 eb                	jbe    8005e6 <vprintfmt+0x83>
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800601:	eb 14                	jmp    800617 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800614:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800617:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80061b:	79 89                	jns    8005a6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80061d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800620:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800623:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80062a:	e9 77 ff ff ff       	jmp    8005a6 <vprintfmt+0x43>
  80062f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800632:	85 c0                	test   %eax,%eax
  800634:	0f 48 c1             	cmovs  %ecx,%eax
  800637:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80063d:	e9 64 ff ff ff       	jmp    8005a6 <vprintfmt+0x43>
  800642:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800645:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80064c:	e9 55 ff ff ff       	jmp    8005a6 <vprintfmt+0x43>
			lflag++;
  800651:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800658:	e9 49 ff ff ff       	jmp    8005a6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8d 78 04             	lea    0x4(%eax),%edi
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	ff 30                	pushl  (%eax)
  800669:	ff d6                	call   *%esi
			break;
  80066b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80066e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800671:	e9 33 03 00 00       	jmp    8009a9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8d 78 04             	lea    0x4(%eax),%edi
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	99                   	cltd   
  80067f:	31 d0                	xor    %edx,%eax
  800681:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800683:	83 f8 11             	cmp    $0x11,%eax
  800686:	7f 23                	jg     8006ab <vprintfmt+0x148>
  800688:	8b 14 85 60 31 80 00 	mov    0x803160(,%eax,4),%edx
  80068f:	85 d2                	test   %edx,%edx
  800691:	74 18                	je     8006ab <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800693:	52                   	push   %edx
  800694:	68 6d 33 80 00       	push   $0x80336d
  800699:	53                   	push   %ebx
  80069a:	56                   	push   %esi
  80069b:	e8 a6 fe ff ff       	call   800546 <printfmt>
  8006a0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006a6:	e9 fe 02 00 00       	jmp    8009a9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006ab:	50                   	push   %eax
  8006ac:	68 3f 2e 80 00       	push   $0x802e3f
  8006b1:	53                   	push   %ebx
  8006b2:	56                   	push   %esi
  8006b3:	e8 8e fe ff ff       	call   800546 <printfmt>
  8006b8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006bb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006be:	e9 e6 02 00 00       	jmp    8009a9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	83 c0 04             	add    $0x4,%eax
  8006c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006d1:	85 c9                	test   %ecx,%ecx
  8006d3:	b8 38 2e 80 00       	mov    $0x802e38,%eax
  8006d8:	0f 45 c1             	cmovne %ecx,%eax
  8006db:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e2:	7e 06                	jle    8006ea <vprintfmt+0x187>
  8006e4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006e8:	75 0d                	jne    8006f7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006ed:	89 c7                	mov    %eax,%edi
  8006ef:	03 45 e0             	add    -0x20(%ebp),%eax
  8006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f5:	eb 53                	jmp    80074a <vprintfmt+0x1e7>
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	e8 71 04 00 00       	call   800b74 <strnlen>
  800703:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800706:	29 c1                	sub    %eax,%ecx
  800708:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800710:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800714:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800717:	eb 0f                	jmp    800728 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	ff 75 e0             	pushl  -0x20(%ebp)
  800720:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800722:	83 ef 01             	sub    $0x1,%edi
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	85 ff                	test   %edi,%edi
  80072a:	7f ed                	jg     800719 <vprintfmt+0x1b6>
  80072c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80072f:	85 c9                	test   %ecx,%ecx
  800731:	b8 00 00 00 00       	mov    $0x0,%eax
  800736:	0f 49 c1             	cmovns %ecx,%eax
  800739:	29 c1                	sub    %eax,%ecx
  80073b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80073e:	eb aa                	jmp    8006ea <vprintfmt+0x187>
					putch(ch, putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	52                   	push   %edx
  800745:	ff d6                	call   *%esi
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80074d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074f:	83 c7 01             	add    $0x1,%edi
  800752:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800756:	0f be d0             	movsbl %al,%edx
  800759:	85 d2                	test   %edx,%edx
  80075b:	74 4b                	je     8007a8 <vprintfmt+0x245>
  80075d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800761:	78 06                	js     800769 <vprintfmt+0x206>
  800763:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800767:	78 1e                	js     800787 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800769:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80076d:	74 d1                	je     800740 <vprintfmt+0x1dd>
  80076f:	0f be c0             	movsbl %al,%eax
  800772:	83 e8 20             	sub    $0x20,%eax
  800775:	83 f8 5e             	cmp    $0x5e,%eax
  800778:	76 c6                	jbe    800740 <vprintfmt+0x1dd>
					putch('?', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	6a 3f                	push   $0x3f
  800780:	ff d6                	call   *%esi
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	eb c3                	jmp    80074a <vprintfmt+0x1e7>
  800787:	89 cf                	mov    %ecx,%edi
  800789:	eb 0e                	jmp    800799 <vprintfmt+0x236>
				putch(' ', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	6a 20                	push   $0x20
  800791:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800793:	83 ef 01             	sub    $0x1,%edi
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	85 ff                	test   %edi,%edi
  80079b:	7f ee                	jg     80078b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80079d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a3:	e9 01 02 00 00       	jmp    8009a9 <vprintfmt+0x446>
  8007a8:	89 cf                	mov    %ecx,%edi
  8007aa:	eb ed                	jmp    800799 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007af:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007b6:	e9 eb fd ff ff       	jmp    8005a6 <vprintfmt+0x43>
	if (lflag >= 2)
  8007bb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007bf:	7f 21                	jg     8007e2 <vprintfmt+0x27f>
	else if (lflag)
  8007c1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c5:	74 68                	je     80082f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007cf:	89 c1                	mov    %eax,%ecx
  8007d1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 40 04             	lea    0x4(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e0:	eb 17                	jmp    8007f9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 50 04             	mov    0x4(%eax),%edx
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8d 40 08             	lea    0x8(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800802:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800805:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800809:	78 3f                	js     80084a <vprintfmt+0x2e7>
			base = 10;
  80080b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800810:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800814:	0f 84 71 01 00 00    	je     80098b <vprintfmt+0x428>
				putch('+', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 2b                	push   $0x2b
  800820:	ff d6                	call   *%esi
  800822:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800825:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082a:	e9 5c 01 00 00       	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, int);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800837:	89 c1                	mov    %eax,%ecx
  800839:	c1 f9 1f             	sar    $0x1f,%ecx
  80083c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8d 40 04             	lea    0x4(%eax),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	eb af                	jmp    8007f9 <vprintfmt+0x296>
				putch('-', putdat);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	53                   	push   %ebx
  80084e:	6a 2d                	push   $0x2d
  800850:	ff d6                	call   *%esi
				num = -(long long) num;
  800852:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800855:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800858:	f7 d8                	neg    %eax
  80085a:	83 d2 00             	adc    $0x0,%edx
  80085d:	f7 da                	neg    %edx
  80085f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800862:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800865:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800868:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086d:	e9 19 01 00 00       	jmp    80098b <vprintfmt+0x428>
	if (lflag >= 2)
  800872:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800876:	7f 29                	jg     8008a1 <vprintfmt+0x33e>
	else if (lflag)
  800878:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80087c:	74 44                	je     8008c2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	ba 00 00 00 00       	mov    $0x0,%edx
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8d 40 04             	lea    0x4(%eax),%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800897:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089c:	e9 ea 00 00 00       	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 50 04             	mov    0x4(%eax),%edx
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8d 40 08             	lea    0x8(%eax),%eax
  8008b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bd:	e9 c9 00 00 00       	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 40 04             	lea    0x4(%eax),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e0:	e9 a6 00 00 00       	jmp    80098b <vprintfmt+0x428>
			putch('0', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	53                   	push   %ebx
  8008e9:	6a 30                	push   $0x30
  8008eb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008f4:	7f 26                	jg     80091c <vprintfmt+0x3b9>
	else if (lflag)
  8008f6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008fa:	74 3e                	je     80093a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
  800906:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800909:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8d 40 04             	lea    0x4(%eax),%eax
  800912:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800915:	b8 08 00 00 00       	mov    $0x8,%eax
  80091a:	eb 6f                	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8b 50 04             	mov    0x4(%eax),%edx
  800922:	8b 00                	mov    (%eax),%eax
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 08             	lea    0x8(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800933:	b8 08 00 00 00       	mov    $0x8,%eax
  800938:	eb 51                	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	ba 00 00 00 00       	mov    $0x0,%edx
  800944:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800947:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8d 40 04             	lea    0x4(%eax),%eax
  800950:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800953:	b8 08 00 00 00       	mov    $0x8,%eax
  800958:	eb 31                	jmp    80098b <vprintfmt+0x428>
			putch('0', putdat);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	53                   	push   %ebx
  80095e:	6a 30                	push   $0x30
  800960:	ff d6                	call   *%esi
			putch('x', putdat);
  800962:	83 c4 08             	add    $0x8,%esp
  800965:	53                   	push   %ebx
  800966:	6a 78                	push   $0x78
  800968:	ff d6                	call   *%esi
			num = (unsigned long long)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	ba 00 00 00 00       	mov    $0x0,%edx
  800974:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800977:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80097a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8d 40 04             	lea    0x4(%eax),%eax
  800983:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800986:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80098b:	83 ec 0c             	sub    $0xc,%esp
  80098e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800992:	52                   	push   %edx
  800993:	ff 75 e0             	pushl  -0x20(%ebp)
  800996:	50                   	push   %eax
  800997:	ff 75 dc             	pushl  -0x24(%ebp)
  80099a:	ff 75 d8             	pushl  -0x28(%ebp)
  80099d:	89 da                	mov    %ebx,%edx
  80099f:	89 f0                	mov    %esi,%eax
  8009a1:	e8 a4 fa ff ff       	call   80044a <printnum>
			break;
  8009a6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ac:	83 c7 01             	add    $0x1,%edi
  8009af:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009b3:	83 f8 25             	cmp    $0x25,%eax
  8009b6:	0f 84 be fb ff ff    	je     80057a <vprintfmt+0x17>
			if (ch == '\0')
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	0f 84 28 01 00 00    	je     800aec <vprintfmt+0x589>
			putch(ch, putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	53                   	push   %ebx
  8009c8:	50                   	push   %eax
  8009c9:	ff d6                	call   *%esi
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	eb dc                	jmp    8009ac <vprintfmt+0x449>
	if (lflag >= 2)
  8009d0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009d4:	7f 26                	jg     8009fc <vprintfmt+0x499>
	else if (lflag)
  8009d6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009da:	74 41                	je     800a1d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	8d 40 04             	lea    0x4(%eax),%eax
  8009f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8009fa:	eb 8f                	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8b 50 04             	mov    0x4(%eax),%edx
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a07:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8d 40 08             	lea    0x8(%eax),%eax
  800a10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a13:	b8 10 00 00 00       	mov    $0x10,%eax
  800a18:	e9 6e ff ff ff       	jmp    80098b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
  800a27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	8d 40 04             	lea    0x4(%eax),%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a36:	b8 10 00 00 00       	mov    $0x10,%eax
  800a3b:	e9 4b ff ff ff       	jmp    80098b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	83 c0 04             	add    $0x4,%eax
  800a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	8b 00                	mov    (%eax),%eax
  800a4e:	85 c0                	test   %eax,%eax
  800a50:	74 14                	je     800a66 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a52:	8b 13                	mov    (%ebx),%edx
  800a54:	83 fa 7f             	cmp    $0x7f,%edx
  800a57:	7f 37                	jg     800a90 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a59:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a61:	e9 43 ff ff ff       	jmp    8009a9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6b:	bf 5d 2f 80 00       	mov    $0x802f5d,%edi
							putch(ch, putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	53                   	push   %ebx
  800a74:	50                   	push   %eax
  800a75:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a77:	83 c7 01             	add    $0x1,%edi
  800a7a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a7e:	83 c4 10             	add    $0x10,%esp
  800a81:	85 c0                	test   %eax,%eax
  800a83:	75 eb                	jne    800a70 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a85:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	e9 19 ff ff ff       	jmp    8009a9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a90:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a92:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a97:	bf 95 2f 80 00       	mov    $0x802f95,%edi
							putch(ch, putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	53                   	push   %ebx
  800aa0:	50                   	push   %eax
  800aa1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800aa3:	83 c7 01             	add    $0x1,%edi
  800aa6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	75 eb                	jne    800a9c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ab1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab7:	e9 ed fe ff ff       	jmp    8009a9 <vprintfmt+0x446>
			putch(ch, putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	53                   	push   %ebx
  800ac0:	6a 25                	push   $0x25
  800ac2:	ff d6                	call   *%esi
			break;
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	e9 dd fe ff ff       	jmp    8009a9 <vprintfmt+0x446>
			putch('%', putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	53                   	push   %ebx
  800ad0:	6a 25                	push   $0x25
  800ad2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 f8                	mov    %edi,%eax
  800ad9:	eb 03                	jmp    800ade <vprintfmt+0x57b>
  800adb:	83 e8 01             	sub    $0x1,%eax
  800ade:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ae2:	75 f7                	jne    800adb <vprintfmt+0x578>
  800ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ae7:	e9 bd fe ff ff       	jmp    8009a9 <vprintfmt+0x446>
}
  800aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 18             	sub    $0x18,%esp
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b03:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b07:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b11:	85 c0                	test   %eax,%eax
  800b13:	74 26                	je     800b3b <vsnprintf+0x47>
  800b15:	85 d2                	test   %edx,%edx
  800b17:	7e 22                	jle    800b3b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b19:	ff 75 14             	pushl  0x14(%ebp)
  800b1c:	ff 75 10             	pushl  0x10(%ebp)
  800b1f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	68 29 05 80 00       	push   $0x800529
  800b28:	e8 36 fa ff ff       	call   800563 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b30:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b36:	83 c4 10             	add    $0x10,%esp
}
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    
		return -E_INVAL;
  800b3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b40:	eb f7                	jmp    800b39 <vsnprintf+0x45>

00800b42 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b48:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b4b:	50                   	push   %eax
  800b4c:	ff 75 10             	pushl  0x10(%ebp)
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	ff 75 08             	pushl  0x8(%ebp)
  800b55:	e8 9a ff ff ff       	call   800af4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b6b:	74 05                	je     800b72 <strlen+0x16>
		n++;
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f5                	jmp    800b67 <strlen+0xb>
	return n;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b82:	39 c2                	cmp    %eax,%edx
  800b84:	74 0d                	je     800b93 <strnlen+0x1f>
  800b86:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b8a:	74 05                	je     800b91 <strnlen+0x1d>
		n++;
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	eb f1                	jmp    800b82 <strnlen+0xe>
  800b91:	89 d0                	mov    %edx,%eax
	return n;
}
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	53                   	push   %ebx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ba8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bab:	83 c2 01             	add    $0x1,%edx
  800bae:	84 c9                	test   %cl,%cl
  800bb0:	75 f2                	jne    800ba4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bb2:	5b                   	pop    %ebx
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 10             	sub    $0x10,%esp
  800bbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bbf:	53                   	push   %ebx
  800bc0:	e8 97 ff ff ff       	call   800b5c <strlen>
  800bc5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	01 d8                	add    %ebx,%eax
  800bcd:	50                   	push   %eax
  800bce:	e8 c2 ff ff ff       	call   800b95 <strcpy>
	return dst;
}
  800bd3:	89 d8                	mov    %ebx,%eax
  800bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    

00800bda <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be5:	89 c6                	mov    %eax,%esi
  800be7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	39 f2                	cmp    %esi,%edx
  800bee:	74 11                	je     800c01 <strncpy+0x27>
		*dst++ = *src;
  800bf0:	83 c2 01             	add    $0x1,%edx
  800bf3:	0f b6 19             	movzbl (%ecx),%ebx
  800bf6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf9:	80 fb 01             	cmp    $0x1,%bl
  800bfc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bff:	eb eb                	jmp    800bec <strncpy+0x12>
	}
	return ret;
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
  800c0a:	8b 75 08             	mov    0x8(%ebp),%esi
  800c0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c10:	8b 55 10             	mov    0x10(%ebp),%edx
  800c13:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c15:	85 d2                	test   %edx,%edx
  800c17:	74 21                	je     800c3a <strlcpy+0x35>
  800c19:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c1d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c1f:	39 c2                	cmp    %eax,%edx
  800c21:	74 14                	je     800c37 <strlcpy+0x32>
  800c23:	0f b6 19             	movzbl (%ecx),%ebx
  800c26:	84 db                	test   %bl,%bl
  800c28:	74 0b                	je     800c35 <strlcpy+0x30>
			*dst++ = *src++;
  800c2a:	83 c1 01             	add    $0x1,%ecx
  800c2d:	83 c2 01             	add    $0x1,%edx
  800c30:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c33:	eb ea                	jmp    800c1f <strlcpy+0x1a>
  800c35:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c37:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c3a:	29 f0                	sub    %esi,%eax
}
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c46:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c49:	0f b6 01             	movzbl (%ecx),%eax
  800c4c:	84 c0                	test   %al,%al
  800c4e:	74 0c                	je     800c5c <strcmp+0x1c>
  800c50:	3a 02                	cmp    (%edx),%al
  800c52:	75 08                	jne    800c5c <strcmp+0x1c>
		p++, q++;
  800c54:	83 c1 01             	add    $0x1,%ecx
  800c57:	83 c2 01             	add    $0x1,%edx
  800c5a:	eb ed                	jmp    800c49 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5c:	0f b6 c0             	movzbl %al,%eax
  800c5f:	0f b6 12             	movzbl (%edx),%edx
  800c62:	29 d0                	sub    %edx,%eax
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	53                   	push   %ebx
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c70:	89 c3                	mov    %eax,%ebx
  800c72:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c75:	eb 06                	jmp    800c7d <strncmp+0x17>
		n--, p++, q++;
  800c77:	83 c0 01             	add    $0x1,%eax
  800c7a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c7d:	39 d8                	cmp    %ebx,%eax
  800c7f:	74 16                	je     800c97 <strncmp+0x31>
  800c81:	0f b6 08             	movzbl (%eax),%ecx
  800c84:	84 c9                	test   %cl,%cl
  800c86:	74 04                	je     800c8c <strncmp+0x26>
  800c88:	3a 0a                	cmp    (%edx),%cl
  800c8a:	74 eb                	je     800c77 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8c:	0f b6 00             	movzbl (%eax),%eax
  800c8f:	0f b6 12             	movzbl (%edx),%edx
  800c92:	29 d0                	sub    %edx,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    
		return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	eb f6                	jmp    800c94 <strncmp+0x2e>

00800c9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca8:	0f b6 10             	movzbl (%eax),%edx
  800cab:	84 d2                	test   %dl,%dl
  800cad:	74 09                	je     800cb8 <strchr+0x1a>
		if (*s == c)
  800caf:	38 ca                	cmp    %cl,%dl
  800cb1:	74 0a                	je     800cbd <strchr+0x1f>
	for (; *s; s++)
  800cb3:	83 c0 01             	add    $0x1,%eax
  800cb6:	eb f0                	jmp    800ca8 <strchr+0xa>
			return (char *) s;
	return 0;
  800cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ccc:	38 ca                	cmp    %cl,%dl
  800cce:	74 09                	je     800cd9 <strfind+0x1a>
  800cd0:	84 d2                	test   %dl,%dl
  800cd2:	74 05                	je     800cd9 <strfind+0x1a>
	for (; *s; s++)
  800cd4:	83 c0 01             	add    $0x1,%eax
  800cd7:	eb f0                	jmp    800cc9 <strfind+0xa>
			break;
	return (char *) s;
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce7:	85 c9                	test   %ecx,%ecx
  800ce9:	74 31                	je     800d1c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ceb:	89 f8                	mov    %edi,%eax
  800ced:	09 c8                	or     %ecx,%eax
  800cef:	a8 03                	test   $0x3,%al
  800cf1:	75 23                	jne    800d16 <memset+0x3b>
		c &= 0xFF;
  800cf3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf7:	89 d3                	mov    %edx,%ebx
  800cf9:	c1 e3 08             	shl    $0x8,%ebx
  800cfc:	89 d0                	mov    %edx,%eax
  800cfe:	c1 e0 18             	shl    $0x18,%eax
  800d01:	89 d6                	mov    %edx,%esi
  800d03:	c1 e6 10             	shl    $0x10,%esi
  800d06:	09 f0                	or     %esi,%eax
  800d08:	09 c2                	or     %eax,%edx
  800d0a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d0f:	89 d0                	mov    %edx,%eax
  800d11:	fc                   	cld    
  800d12:	f3 ab                	rep stos %eax,%es:(%edi)
  800d14:	eb 06                	jmp    800d1c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	fc                   	cld    
  800d1a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1c:	89 f8                	mov    %edi,%eax
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d31:	39 c6                	cmp    %eax,%esi
  800d33:	73 32                	jae    800d67 <memmove+0x44>
  800d35:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d38:	39 c2                	cmp    %eax,%edx
  800d3a:	76 2b                	jbe    800d67 <memmove+0x44>
		s += n;
		d += n;
  800d3c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d3f:	89 fe                	mov    %edi,%esi
  800d41:	09 ce                	or     %ecx,%esi
  800d43:	09 d6                	or     %edx,%esi
  800d45:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4b:	75 0e                	jne    800d5b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d4d:	83 ef 04             	sub    $0x4,%edi
  800d50:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d53:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d56:	fd                   	std    
  800d57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d59:	eb 09                	jmp    800d64 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5b:	83 ef 01             	sub    $0x1,%edi
  800d5e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d61:	fd                   	std    
  800d62:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d64:	fc                   	cld    
  800d65:	eb 1a                	jmp    800d81 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	09 ca                	or     %ecx,%edx
  800d6b:	09 f2                	or     %esi,%edx
  800d6d:	f6 c2 03             	test   $0x3,%dl
  800d70:	75 0a                	jne    800d7c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d72:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d75:	89 c7                	mov    %eax,%edi
  800d77:	fc                   	cld    
  800d78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d7a:	eb 05                	jmp    800d81 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d7c:	89 c7                	mov    %eax,%edi
  800d7e:	fc                   	cld    
  800d7f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d8b:	ff 75 10             	pushl  0x10(%ebp)
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	ff 75 08             	pushl  0x8(%ebp)
  800d94:	e8 8a ff ff ff       	call   800d23 <memmove>
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da6:	89 c6                	mov    %eax,%esi
  800da8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dab:	39 f0                	cmp    %esi,%eax
  800dad:	74 1c                	je     800dcb <memcmp+0x30>
		if (*s1 != *s2)
  800daf:	0f b6 08             	movzbl (%eax),%ecx
  800db2:	0f b6 1a             	movzbl (%edx),%ebx
  800db5:	38 d9                	cmp    %bl,%cl
  800db7:	75 08                	jne    800dc1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800db9:	83 c0 01             	add    $0x1,%eax
  800dbc:	83 c2 01             	add    $0x1,%edx
  800dbf:	eb ea                	jmp    800dab <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dc1:	0f b6 c1             	movzbl %cl,%eax
  800dc4:	0f b6 db             	movzbl %bl,%ebx
  800dc7:	29 d8                	sub    %ebx,%eax
  800dc9:	eb 05                	jmp    800dd0 <memcmp+0x35>
	}

	return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ddd:	89 c2                	mov    %eax,%edx
  800ddf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de2:	39 d0                	cmp    %edx,%eax
  800de4:	73 09                	jae    800def <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de6:	38 08                	cmp    %cl,(%eax)
  800de8:	74 05                	je     800def <memfind+0x1b>
	for (; s < ends; s++)
  800dea:	83 c0 01             	add    $0x1,%eax
  800ded:	eb f3                	jmp    800de2 <memfind+0xe>
			break;
	return (void *) s;
}
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dfd:	eb 03                	jmp    800e02 <strtol+0x11>
		s++;
  800dff:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e02:	0f b6 01             	movzbl (%ecx),%eax
  800e05:	3c 20                	cmp    $0x20,%al
  800e07:	74 f6                	je     800dff <strtol+0xe>
  800e09:	3c 09                	cmp    $0x9,%al
  800e0b:	74 f2                	je     800dff <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e0d:	3c 2b                	cmp    $0x2b,%al
  800e0f:	74 2a                	je     800e3b <strtol+0x4a>
	int neg = 0;
  800e11:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e16:	3c 2d                	cmp    $0x2d,%al
  800e18:	74 2b                	je     800e45 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e20:	75 0f                	jne    800e31 <strtol+0x40>
  800e22:	80 39 30             	cmpb   $0x30,(%ecx)
  800e25:	74 28                	je     800e4f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e27:	85 db                	test   %ebx,%ebx
  800e29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2e:	0f 44 d8             	cmove  %eax,%ebx
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e39:	eb 50                	jmp    800e8b <strtol+0x9a>
		s++;
  800e3b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e3e:	bf 00 00 00 00       	mov    $0x0,%edi
  800e43:	eb d5                	jmp    800e1a <strtol+0x29>
		s++, neg = 1;
  800e45:	83 c1 01             	add    $0x1,%ecx
  800e48:	bf 01 00 00 00       	mov    $0x1,%edi
  800e4d:	eb cb                	jmp    800e1a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e53:	74 0e                	je     800e63 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e55:	85 db                	test   %ebx,%ebx
  800e57:	75 d8                	jne    800e31 <strtol+0x40>
		s++, base = 8;
  800e59:	83 c1 01             	add    $0x1,%ecx
  800e5c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e61:	eb ce                	jmp    800e31 <strtol+0x40>
		s += 2, base = 16;
  800e63:	83 c1 02             	add    $0x2,%ecx
  800e66:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e6b:	eb c4                	jmp    800e31 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e6d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e70:	89 f3                	mov    %esi,%ebx
  800e72:	80 fb 19             	cmp    $0x19,%bl
  800e75:	77 29                	ja     800ea0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e77:	0f be d2             	movsbl %dl,%edx
  800e7a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e7d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e80:	7d 30                	jge    800eb2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e82:	83 c1 01             	add    $0x1,%ecx
  800e85:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e89:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e8b:	0f b6 11             	movzbl (%ecx),%edx
  800e8e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e91:	89 f3                	mov    %esi,%ebx
  800e93:	80 fb 09             	cmp    $0x9,%bl
  800e96:	77 d5                	ja     800e6d <strtol+0x7c>
			dig = *s - '0';
  800e98:	0f be d2             	movsbl %dl,%edx
  800e9b:	83 ea 30             	sub    $0x30,%edx
  800e9e:	eb dd                	jmp    800e7d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ea0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ea3:	89 f3                	mov    %esi,%ebx
  800ea5:	80 fb 19             	cmp    $0x19,%bl
  800ea8:	77 08                	ja     800eb2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eaa:	0f be d2             	movsbl %dl,%edx
  800ead:	83 ea 37             	sub    $0x37,%edx
  800eb0:	eb cb                	jmp    800e7d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb6:	74 05                	je     800ebd <strtol+0xcc>
		*endptr = (char *) s;
  800eb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ebd:	89 c2                	mov    %eax,%edx
  800ebf:	f7 da                	neg    %edx
  800ec1:	85 ff                	test   %edi,%edi
  800ec3:	0f 45 c2             	cmovne %edx,%eax
}
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	89 c3                	mov    %eax,%ebx
  800ede:	89 c7                	mov    %eax,%edi
  800ee0:	89 c6                	mov    %eax,%esi
  800ee2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef9:	89 d1                	mov    %edx,%ecx
  800efb:	89 d3                	mov    %edx,%ebx
  800efd:	89 d7                	mov    %edx,%edi
  800eff:	89 d6                	mov    %edx,%esi
  800f01:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	b8 03 00 00 00       	mov    $0x3,%eax
  800f1e:	89 cb                	mov    %ecx,%ebx
  800f20:	89 cf                	mov    %ecx,%edi
  800f22:	89 ce                	mov    %ecx,%esi
  800f24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7f 08                	jg     800f32 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	83 ec 0c             	sub    $0xc,%esp
  800f35:	50                   	push   %eax
  800f36:	6a 03                	push   $0x3
  800f38:	68 a8 31 80 00       	push   $0x8031a8
  800f3d:	6a 43                	push   $0x43
  800f3f:	68 c5 31 80 00       	push   $0x8031c5
  800f44:	e8 f7 f3 ff ff       	call   800340 <_panic>

00800f49 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f54:	b8 02 00 00 00       	mov    $0x2,%eax
  800f59:	89 d1                	mov    %edx,%ecx
  800f5b:	89 d3                	mov    %edx,%ebx
  800f5d:	89 d7                	mov    %edx,%edi
  800f5f:	89 d6                	mov    %edx,%esi
  800f61:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <sys_yield>:

void
sys_yield(void)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f73:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f78:	89 d1                	mov    %edx,%ecx
  800f7a:	89 d3                	mov    %edx,%ebx
  800f7c:	89 d7                	mov    %edx,%edi
  800f7e:	89 d6                	mov    %edx,%esi
  800f80:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f90:	be 00 00 00 00       	mov    $0x0,%esi
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	b8 04 00 00 00       	mov    $0x4,%eax
  800fa0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fa3:	89 f7                	mov    %esi,%edi
  800fa5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	7f 08                	jg     800fb3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	50                   	push   %eax
  800fb7:	6a 04                	push   $0x4
  800fb9:	68 a8 31 80 00       	push   $0x8031a8
  800fbe:	6a 43                	push   $0x43
  800fc0:	68 c5 31 80 00       	push   $0x8031c5
  800fc5:	e8 76 f3 ff ff       	call   800340 <_panic>

00800fca <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
  800fd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	b8 05 00 00 00       	mov    $0x5,%eax
  800fde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe4:	8b 75 18             	mov    0x18(%ebp),%esi
  800fe7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 05                	push   $0x5
  800ffb:	68 a8 31 80 00       	push   $0x8031a8
  801000:	6a 43                	push   $0x43
  801002:	68 c5 31 80 00       	push   $0x8031c5
  801007:	e8 34 f3 ff ff       	call   800340 <_panic>

0080100c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801015:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	b8 06 00 00 00       	mov    $0x6,%eax
  801025:	89 df                	mov    %ebx,%edi
  801027:	89 de                	mov    %ebx,%esi
  801029:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	7f 08                	jg     801037 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5f                   	pop    %edi
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	50                   	push   %eax
  80103b:	6a 06                	push   $0x6
  80103d:	68 a8 31 80 00       	push   $0x8031a8
  801042:	6a 43                	push   $0x43
  801044:	68 c5 31 80 00       	push   $0x8031c5
  801049:	e8 f2 f2 ff ff       	call   800340 <_panic>

0080104e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
  801054:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801057:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	b8 08 00 00 00       	mov    $0x8,%eax
  801067:	89 df                	mov    %ebx,%edi
  801069:	89 de                	mov    %ebx,%esi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 08                	push   $0x8
  80107f:	68 a8 31 80 00       	push   $0x8031a8
  801084:	6a 43                	push   $0x43
  801086:	68 c5 31 80 00       	push   $0x8031c5
  80108b:	e8 b0 f2 ff ff       	call   800340 <_panic>

00801090 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801099:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a4:	b8 09 00 00 00       	mov    $0x9,%eax
  8010a9:	89 df                	mov    %ebx,%edi
  8010ab:	89 de                	mov    %ebx,%esi
  8010ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	7f 08                	jg     8010bb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b6:	5b                   	pop    %ebx
  8010b7:	5e                   	pop    %esi
  8010b8:	5f                   	pop    %edi
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bb:	83 ec 0c             	sub    $0xc,%esp
  8010be:	50                   	push   %eax
  8010bf:	6a 09                	push   $0x9
  8010c1:	68 a8 31 80 00       	push   $0x8031a8
  8010c6:	6a 43                	push   $0x43
  8010c8:	68 c5 31 80 00       	push   $0x8031c5
  8010cd:	e8 6e f2 ff ff       	call   800340 <_panic>

008010d2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010eb:	89 df                	mov    %ebx,%edi
  8010ed:	89 de                	mov    %ebx,%esi
  8010ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7f 08                	jg     8010fd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5f                   	pop    %edi
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fd:	83 ec 0c             	sub    $0xc,%esp
  801100:	50                   	push   %eax
  801101:	6a 0a                	push   $0xa
  801103:	68 a8 31 80 00       	push   $0x8031a8
  801108:	6a 43                	push   $0x43
  80110a:	68 c5 31 80 00       	push   $0x8031c5
  80110f:	e8 2c f2 ff ff       	call   800340 <_panic>

00801114 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111a:	8b 55 08             	mov    0x8(%ebp),%edx
  80111d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801120:	b8 0c 00 00 00       	mov    $0xc,%eax
  801125:	be 00 00 00 00       	mov    $0x0,%esi
  80112a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80112d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801130:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801140:	b9 00 00 00 00       	mov    $0x0,%ecx
  801145:	8b 55 08             	mov    0x8(%ebp),%edx
  801148:	b8 0d 00 00 00       	mov    $0xd,%eax
  80114d:	89 cb                	mov    %ecx,%ebx
  80114f:	89 cf                	mov    %ecx,%edi
  801151:	89 ce                	mov    %ecx,%esi
  801153:	cd 30                	int    $0x30
	if(check && ret > 0)
  801155:	85 c0                	test   %eax,%eax
  801157:	7f 08                	jg     801161 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801159:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	50                   	push   %eax
  801165:	6a 0d                	push   $0xd
  801167:	68 a8 31 80 00       	push   $0x8031a8
  80116c:	6a 43                	push   $0x43
  80116e:	68 c5 31 80 00       	push   $0x8031c5
  801173:	e8 c8 f1 ff ff       	call   800340 <_panic>

00801178 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	57                   	push   %edi
  80117c:	56                   	push   %esi
  80117d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80117e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801189:	b8 0e 00 00 00       	mov    $0xe,%eax
  80118e:	89 df                	mov    %ebx,%edi
  801190:	89 de                	mov    %ebx,%esi
  801192:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	57                   	push   %edi
  80119d:	56                   	push   %esi
  80119e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80119f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011ac:	89 cb                	mov    %ecx,%ebx
  8011ae:	89 cf                	mov    %ecx,%edi
  8011b0:	89 ce                	mov    %ecx,%esi
  8011b2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5f                   	pop    %edi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	57                   	push   %edi
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c4:	b8 10 00 00 00       	mov    $0x10,%eax
  8011c9:	89 d1                	mov    %edx,%ecx
  8011cb:	89 d3                	mov    %edx,%ebx
  8011cd:	89 d7                	mov    %edx,%edi
  8011cf:	89 d6                	mov    %edx,%esi
  8011d1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5f                   	pop    %edi
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    

008011d8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	b8 11 00 00 00       	mov    $0x11,%eax
  8011ee:	89 df                	mov    %ebx,%edi
  8011f0:	89 de                	mov    %ebx,%esi
  8011f2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011f4:	5b                   	pop    %ebx
  8011f5:	5e                   	pop    %esi
  8011f6:	5f                   	pop    %edi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	57                   	push   %edi
  8011fd:	56                   	push   %esi
  8011fe:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
  801207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120a:	b8 12 00 00 00       	mov    $0x12,%eax
  80120f:	89 df                	mov    %ebx,%edi
  801211:	89 de                	mov    %ebx,%esi
  801213:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801215:	5b                   	pop    %ebx
  801216:	5e                   	pop    %esi
  801217:	5f                   	pop    %edi
  801218:	5d                   	pop    %ebp
  801219:	c3                   	ret    

0080121a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	57                   	push   %edi
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
  801220:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801223:	bb 00 00 00 00       	mov    $0x0,%ebx
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
  80122b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122e:	b8 13 00 00 00       	mov    $0x13,%eax
  801233:	89 df                	mov    %ebx,%edi
  801235:	89 de                	mov    %ebx,%esi
  801237:	cd 30                	int    $0x30
	if(check && ret > 0)
  801239:	85 c0                	test   %eax,%eax
  80123b:	7f 08                	jg     801245 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80123d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801240:	5b                   	pop    %ebx
  801241:	5e                   	pop    %esi
  801242:	5f                   	pop    %edi
  801243:	5d                   	pop    %ebp
  801244:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	50                   	push   %eax
  801249:	6a 13                	push   $0x13
  80124b:	68 a8 31 80 00       	push   $0x8031a8
  801250:	6a 43                	push   $0x43
  801252:	68 c5 31 80 00       	push   $0x8031c5
  801257:	e8 e4 f0 ff ff       	call   800340 <_panic>

0080125c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	57                   	push   %edi
  801260:	56                   	push   %esi
  801261:	53                   	push   %ebx
	asm volatile("int %1\n"
  801262:	b9 00 00 00 00       	mov    $0x0,%ecx
  801267:	8b 55 08             	mov    0x8(%ebp),%edx
  80126a:	b8 14 00 00 00       	mov    $0x14,%eax
  80126f:	89 cb                	mov    %ecx,%ebx
  801271:	89 cf                	mov    %ecx,%edi
  801273:	89 ce                	mov    %ecx,%esi
  801275:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	53                   	push   %ebx
  801280:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801283:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80128a:	f6 c5 04             	test   $0x4,%ch
  80128d:	75 45                	jne    8012d4 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80128f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801296:	83 e1 07             	and    $0x7,%ecx
  801299:	83 f9 07             	cmp    $0x7,%ecx
  80129c:	74 6f                	je     80130d <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80129e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012a5:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8012ab:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8012b1:	0f 84 b6 00 00 00    	je     80136d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012b7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012be:	83 e1 05             	and    $0x5,%ecx
  8012c1:	83 f9 05             	cmp    $0x5,%ecx
  8012c4:	0f 84 d7 00 00 00    	je     8013a1 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012d4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012db:	c1 e2 0c             	shl    $0xc,%edx
  8012de:	83 ec 0c             	sub    $0xc,%esp
  8012e1:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012e7:	51                   	push   %ecx
  8012e8:	52                   	push   %edx
  8012e9:	50                   	push   %eax
  8012ea:	52                   	push   %edx
  8012eb:	6a 00                	push   $0x0
  8012ed:	e8 d8 fc ff ff       	call   800fca <sys_page_map>
		if(r < 0)
  8012f2:	83 c4 20             	add    $0x20,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	79 d1                	jns    8012ca <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	68 d3 31 80 00       	push   $0x8031d3
  801301:	6a 54                	push   $0x54
  801303:	68 e9 31 80 00       	push   $0x8031e9
  801308:	e8 33 f0 ff ff       	call   800340 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80130d:	89 d3                	mov    %edx,%ebx
  80130f:	c1 e3 0c             	shl    $0xc,%ebx
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	68 05 08 00 00       	push   $0x805
  80131a:	53                   	push   %ebx
  80131b:	50                   	push   %eax
  80131c:	53                   	push   %ebx
  80131d:	6a 00                	push   $0x0
  80131f:	e8 a6 fc ff ff       	call   800fca <sys_page_map>
		if(r < 0)
  801324:	83 c4 20             	add    $0x20,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 2e                	js     801359 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80132b:	83 ec 0c             	sub    $0xc,%esp
  80132e:	68 05 08 00 00       	push   $0x805
  801333:	53                   	push   %ebx
  801334:	6a 00                	push   $0x0
  801336:	53                   	push   %ebx
  801337:	6a 00                	push   $0x0
  801339:	e8 8c fc ff ff       	call   800fca <sys_page_map>
		if(r < 0)
  80133e:	83 c4 20             	add    $0x20,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	79 85                	jns    8012ca <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	68 d3 31 80 00       	push   $0x8031d3
  80134d:	6a 5f                	push   $0x5f
  80134f:	68 e9 31 80 00       	push   $0x8031e9
  801354:	e8 e7 ef ff ff       	call   800340 <_panic>
			panic("sys_page_map() panic\n");
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	68 d3 31 80 00       	push   $0x8031d3
  801361:	6a 5b                	push   $0x5b
  801363:	68 e9 31 80 00       	push   $0x8031e9
  801368:	e8 d3 ef ff ff       	call   800340 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80136d:	c1 e2 0c             	shl    $0xc,%edx
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	68 05 08 00 00       	push   $0x805
  801378:	52                   	push   %edx
  801379:	50                   	push   %eax
  80137a:	52                   	push   %edx
  80137b:	6a 00                	push   $0x0
  80137d:	e8 48 fc ff ff       	call   800fca <sys_page_map>
		if(r < 0)
  801382:	83 c4 20             	add    $0x20,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	0f 89 3d ff ff ff    	jns    8012ca <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80138d:	83 ec 04             	sub    $0x4,%esp
  801390:	68 d3 31 80 00       	push   $0x8031d3
  801395:	6a 66                	push   $0x66
  801397:	68 e9 31 80 00       	push   $0x8031e9
  80139c:	e8 9f ef ff ff       	call   800340 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013a1:	c1 e2 0c             	shl    $0xc,%edx
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	6a 05                	push   $0x5
  8013a9:	52                   	push   %edx
  8013aa:	50                   	push   %eax
  8013ab:	52                   	push   %edx
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 17 fc ff ff       	call   800fca <sys_page_map>
		if(r < 0)
  8013b3:	83 c4 20             	add    $0x20,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	0f 89 0c ff ff ff    	jns    8012ca <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	68 d3 31 80 00       	push   $0x8031d3
  8013c6:	6a 6d                	push   $0x6d
  8013c8:	68 e9 31 80 00       	push   $0x8031e9
  8013cd:	e8 6e ef ff ff       	call   800340 <_panic>

008013d2 <pgfault>:
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	53                   	push   %ebx
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013dc:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013de:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013e2:	0f 84 99 00 00 00    	je     801481 <pgfault+0xaf>
  8013e8:	89 c2                	mov    %eax,%edx
  8013ea:	c1 ea 16             	shr    $0x16,%edx
  8013ed:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f4:	f6 c2 01             	test   $0x1,%dl
  8013f7:	0f 84 84 00 00 00    	je     801481 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013fd:	89 c2                	mov    %eax,%edx
  8013ff:	c1 ea 0c             	shr    $0xc,%edx
  801402:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801409:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80140f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801415:	75 6a                	jne    801481 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141c:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	6a 07                	push   $0x7
  801423:	68 00 f0 7f 00       	push   $0x7ff000
  801428:	6a 00                	push   $0x0
  80142a:	e8 58 fb ff ff       	call   800f87 <sys_page_alloc>
	if(ret < 0)
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	78 5f                	js     801495 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	68 00 10 00 00       	push   $0x1000
  80143e:	53                   	push   %ebx
  80143f:	68 00 f0 7f 00       	push   $0x7ff000
  801444:	e8 3c f9 ff ff       	call   800d85 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801449:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801450:	53                   	push   %ebx
  801451:	6a 00                	push   $0x0
  801453:	68 00 f0 7f 00       	push   $0x7ff000
  801458:	6a 00                	push   $0x0
  80145a:	e8 6b fb ff ff       	call   800fca <sys_page_map>
	if(ret < 0)
  80145f:	83 c4 20             	add    $0x20,%esp
  801462:	85 c0                	test   %eax,%eax
  801464:	78 43                	js     8014a9 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	68 00 f0 7f 00       	push   $0x7ff000
  80146e:	6a 00                	push   $0x0
  801470:	e8 97 fb ff ff       	call   80100c <sys_page_unmap>
	if(ret < 0)
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 41                	js     8014bd <pgfault+0xeb>
}
  80147c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147f:	c9                   	leave  
  801480:	c3                   	ret    
		panic("panic at pgfault()\n");
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	68 f4 31 80 00       	push   $0x8031f4
  801489:	6a 26                	push   $0x26
  80148b:	68 e9 31 80 00       	push   $0x8031e9
  801490:	e8 ab ee ff ff       	call   800340 <_panic>
		panic("panic in sys_page_alloc()\n");
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	68 08 32 80 00       	push   $0x803208
  80149d:	6a 31                	push   $0x31
  80149f:	68 e9 31 80 00       	push   $0x8031e9
  8014a4:	e8 97 ee ff ff       	call   800340 <_panic>
		panic("panic in sys_page_map()\n");
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	68 23 32 80 00       	push   $0x803223
  8014b1:	6a 36                	push   $0x36
  8014b3:	68 e9 31 80 00       	push   $0x8031e9
  8014b8:	e8 83 ee ff ff       	call   800340 <_panic>
		panic("panic in sys_page_unmap()\n");
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	68 3c 32 80 00       	push   $0x80323c
  8014c5:	6a 39                	push   $0x39
  8014c7:	68 e9 31 80 00       	push   $0x8031e9
  8014cc:	e8 6f ee ff ff       	call   800340 <_panic>

008014d1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	57                   	push   %edi
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014da:	68 d2 13 80 00       	push   $0x8013d2
  8014df:	e8 db 13 00 00       	call   8028bf <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014e4:	b8 07 00 00 00       	mov    $0x7,%eax
  8014e9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 2a                	js     80151c <fork+0x4b>
  8014f2:	89 c6                	mov    %eax,%esi
  8014f4:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014fb:	75 4b                	jne    801548 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014fd:	e8 47 fa ff ff       	call   800f49 <sys_getenvid>
  801502:	25 ff 03 00 00       	and    $0x3ff,%eax
  801507:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80150d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801512:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801517:	e9 90 00 00 00       	jmp    8015ac <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 58 32 80 00       	push   $0x803258
  801524:	68 8c 00 00 00       	push   $0x8c
  801529:	68 e9 31 80 00       	push   $0x8031e9
  80152e:	e8 0d ee ff ff       	call   800340 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801533:	89 f8                	mov    %edi,%eax
  801535:	e8 42 fd ff ff       	call   80127c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80153a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801540:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801546:	74 26                	je     80156e <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801548:	89 d8                	mov    %ebx,%eax
  80154a:	c1 e8 16             	shr    $0x16,%eax
  80154d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801554:	a8 01                	test   $0x1,%al
  801556:	74 e2                	je     80153a <fork+0x69>
  801558:	89 da                	mov    %ebx,%edx
  80155a:	c1 ea 0c             	shr    $0xc,%edx
  80155d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801564:	83 e0 05             	and    $0x5,%eax
  801567:	83 f8 05             	cmp    $0x5,%eax
  80156a:	75 ce                	jne    80153a <fork+0x69>
  80156c:	eb c5                	jmp    801533 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	6a 07                	push   $0x7
  801573:	68 00 f0 bf ee       	push   $0xeebff000
  801578:	56                   	push   %esi
  801579:	e8 09 fa ff ff       	call   800f87 <sys_page_alloc>
	if(ret < 0)
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 31                	js     8015b6 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	68 2e 29 80 00       	push   $0x80292e
  80158d:	56                   	push   %esi
  80158e:	e8 3f fb ff ff       	call   8010d2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 33                	js     8015cd <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	6a 02                	push   $0x2
  80159f:	56                   	push   %esi
  8015a0:	e8 a9 fa ff ff       	call   80104e <sys_env_set_status>
	if(ret < 0)
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 38                	js     8015e4 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8015ac:	89 f0                	mov    %esi,%eax
  8015ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	68 08 32 80 00       	push   $0x803208
  8015be:	68 98 00 00 00       	push   $0x98
  8015c3:	68 e9 31 80 00       	push   $0x8031e9
  8015c8:	e8 73 ed ff ff       	call   800340 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	68 7c 32 80 00       	push   $0x80327c
  8015d5:	68 9b 00 00 00       	push   $0x9b
  8015da:	68 e9 31 80 00       	push   $0x8031e9
  8015df:	e8 5c ed ff ff       	call   800340 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 a4 32 80 00       	push   $0x8032a4
  8015ec:	68 9e 00 00 00       	push   $0x9e
  8015f1:	68 e9 31 80 00       	push   $0x8031e9
  8015f6:	e8 45 ed ff ff       	call   800340 <_panic>

008015fb <sfork>:

// Challenge!
int
sfork(void)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	57                   	push   %edi
  8015ff:	56                   	push   %esi
  801600:	53                   	push   %ebx
  801601:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801604:	68 d2 13 80 00       	push   $0x8013d2
  801609:	e8 b1 12 00 00       	call   8028bf <set_pgfault_handler>
  80160e:	b8 07 00 00 00       	mov    $0x7,%eax
  801613:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 2a                	js     801646 <sfork+0x4b>
  80161c:	89 c7                	mov    %eax,%edi
  80161e:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801620:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801625:	75 58                	jne    80167f <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801627:	e8 1d f9 ff ff       	call   800f49 <sys_getenvid>
  80162c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801631:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801637:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80163c:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801641:	e9 d4 00 00 00       	jmp    80171a <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 58 32 80 00       	push   $0x803258
  80164e:	68 af 00 00 00       	push   $0xaf
  801653:	68 e9 31 80 00       	push   $0x8031e9
  801658:	e8 e3 ec ff ff       	call   800340 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80165d:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801662:	89 f0                	mov    %esi,%eax
  801664:	e8 13 fc ff ff       	call   80127c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80166f:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801675:	77 65                	ja     8016dc <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801677:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80167d:	74 de                	je     80165d <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80167f:	89 d8                	mov    %ebx,%eax
  801681:	c1 e8 16             	shr    $0x16,%eax
  801684:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80168b:	a8 01                	test   $0x1,%al
  80168d:	74 da                	je     801669 <sfork+0x6e>
  80168f:	89 da                	mov    %ebx,%edx
  801691:	c1 ea 0c             	shr    $0xc,%edx
  801694:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80169b:	83 e0 05             	and    $0x5,%eax
  80169e:	83 f8 05             	cmp    $0x5,%eax
  8016a1:	75 c6                	jne    801669 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8016a3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8016aa:	c1 e2 0c             	shl    $0xc,%edx
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	83 e0 07             	and    $0x7,%eax
  8016b3:	50                   	push   %eax
  8016b4:	52                   	push   %edx
  8016b5:	56                   	push   %esi
  8016b6:	52                   	push   %edx
  8016b7:	6a 00                	push   $0x0
  8016b9:	e8 0c f9 ff ff       	call   800fca <sys_page_map>
  8016be:	83 c4 20             	add    $0x20,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	74 a4                	je     801669 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	68 d3 31 80 00       	push   $0x8031d3
  8016cd:	68 ba 00 00 00       	push   $0xba
  8016d2:	68 e9 31 80 00       	push   $0x8031e9
  8016d7:	e8 64 ec ff ff       	call   800340 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	6a 07                	push   $0x7
  8016e1:	68 00 f0 bf ee       	push   $0xeebff000
  8016e6:	57                   	push   %edi
  8016e7:	e8 9b f8 ff ff       	call   800f87 <sys_page_alloc>
	if(ret < 0)
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 31                	js     801724 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	68 2e 29 80 00       	push   $0x80292e
  8016fb:	57                   	push   %edi
  8016fc:	e8 d1 f9 ff ff       	call   8010d2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	85 c0                	test   %eax,%eax
  801706:	78 33                	js     80173b <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	6a 02                	push   $0x2
  80170d:	57                   	push   %edi
  80170e:	e8 3b f9 ff ff       	call   80104e <sys_env_set_status>
	if(ret < 0)
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 38                	js     801752 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80171a:	89 f8                	mov    %edi,%eax
  80171c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5f                   	pop    %edi
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	68 08 32 80 00       	push   $0x803208
  80172c:	68 c0 00 00 00       	push   $0xc0
  801731:	68 e9 31 80 00       	push   $0x8031e9
  801736:	e8 05 ec ff ff       	call   800340 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	68 7c 32 80 00       	push   $0x80327c
  801743:	68 c3 00 00 00       	push   $0xc3
  801748:	68 e9 31 80 00       	push   $0x8031e9
  80174d:	e8 ee eb ff ff       	call   800340 <_panic>
		panic("panic in sys_env_set_status()\n");
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 a4 32 80 00       	push   $0x8032a4
  80175a:	68 c6 00 00 00       	push   $0xc6
  80175f:	68 e9 31 80 00       	push   $0x8031e9
  801764:	e8 d7 eb ff ff       	call   800340 <_panic>

00801769 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	05 00 00 00 30       	add    $0x30000000,%eax
  801774:	c1 e8 0c             	shr    $0xc,%eax
}
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801784:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801789:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801798:	89 c2                	mov    %eax,%edx
  80179a:	c1 ea 16             	shr    $0x16,%edx
  80179d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017a4:	f6 c2 01             	test   $0x1,%dl
  8017a7:	74 2d                	je     8017d6 <fd_alloc+0x46>
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	c1 ea 0c             	shr    $0xc,%edx
  8017ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017b5:	f6 c2 01             	test   $0x1,%dl
  8017b8:	74 1c                	je     8017d6 <fd_alloc+0x46>
  8017ba:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017bf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017c4:	75 d2                	jne    801798 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017d4:	eb 0a                	jmp    8017e0 <fd_alloc+0x50>
			*fd_store = fd;
  8017d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017e8:	83 f8 1f             	cmp    $0x1f,%eax
  8017eb:	77 30                	ja     80181d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017ed:	c1 e0 0c             	shl    $0xc,%eax
  8017f0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017f5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017fb:	f6 c2 01             	test   $0x1,%dl
  8017fe:	74 24                	je     801824 <fd_lookup+0x42>
  801800:	89 c2                	mov    %eax,%edx
  801802:	c1 ea 0c             	shr    $0xc,%edx
  801805:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80180c:	f6 c2 01             	test   $0x1,%dl
  80180f:	74 1a                	je     80182b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	89 02                	mov    %eax,(%edx)
	return 0;
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    
		return -E_INVAL;
  80181d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801822:	eb f7                	jmp    80181b <fd_lookup+0x39>
		return -E_INVAL;
  801824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801829:	eb f0                	jmp    80181b <fd_lookup+0x39>
  80182b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801830:	eb e9                	jmp    80181b <fd_lookup+0x39>

00801832 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
  801838:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80183b:	ba 00 00 00 00       	mov    $0x0,%edx
  801840:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801845:	39 08                	cmp    %ecx,(%eax)
  801847:	74 38                	je     801881 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801849:	83 c2 01             	add    $0x1,%edx
  80184c:	8b 04 95 40 33 80 00 	mov    0x803340(,%edx,4),%eax
  801853:	85 c0                	test   %eax,%eax
  801855:	75 ee                	jne    801845 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801857:	a1 08 50 80 00       	mov    0x805008,%eax
  80185c:	8b 40 48             	mov    0x48(%eax),%eax
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	51                   	push   %ecx
  801863:	50                   	push   %eax
  801864:	68 c4 32 80 00       	push   $0x8032c4
  801869:	e8 c8 eb ff ff       	call   800436 <cprintf>
	*dev = 0;
  80186e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    
			*dev = devtab[i];
  801881:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801884:	89 01                	mov    %eax,(%ecx)
			return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	eb f2                	jmp    80187f <dev_lookup+0x4d>

0080188d <fd_close>:
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	57                   	push   %edi
  801891:	56                   	push   %esi
  801892:	53                   	push   %ebx
  801893:	83 ec 24             	sub    $0x24,%esp
  801896:	8b 75 08             	mov    0x8(%ebp),%esi
  801899:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80189c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80189f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018a0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018a6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018a9:	50                   	push   %eax
  8018aa:	e8 33 ff ff ff       	call   8017e2 <fd_lookup>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 05                	js     8018bd <fd_close+0x30>
	    || fd != fd2)
  8018b8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018bb:	74 16                	je     8018d3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018bd:	89 f8                	mov    %edi,%eax
  8018bf:	84 c0                	test   %al,%al
  8018c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c6:	0f 44 d8             	cmove  %eax,%ebx
}
  8018c9:	89 d8                	mov    %ebx,%eax
  8018cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5e                   	pop    %esi
  8018d0:	5f                   	pop    %edi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018d9:	50                   	push   %eax
  8018da:	ff 36                	pushl  (%esi)
  8018dc:	e8 51 ff ff ff       	call   801832 <dev_lookup>
  8018e1:	89 c3                	mov    %eax,%ebx
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 1a                	js     801904 <fd_close+0x77>
		if (dev->dev_close)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	74 0b                	je     801904 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	56                   	push   %esi
  8018fd:	ff d0                	call   *%eax
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	56                   	push   %esi
  801908:	6a 00                	push   $0x0
  80190a:	e8 fd f6 ff ff       	call   80100c <sys_page_unmap>
	return r;
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	eb b5                	jmp    8018c9 <fd_close+0x3c>

00801914 <close>:

int
close(int fdnum)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191d:	50                   	push   %eax
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	e8 bc fe ff ff       	call   8017e2 <fd_lookup>
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	79 02                	jns    80192f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    
		return fd_close(fd, 1);
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	6a 01                	push   $0x1
  801934:	ff 75 f4             	pushl  -0xc(%ebp)
  801937:	e8 51 ff ff ff       	call   80188d <fd_close>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	eb ec                	jmp    80192d <close+0x19>

00801941 <close_all>:

void
close_all(void)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	53                   	push   %ebx
  801945:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801948:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	53                   	push   %ebx
  801951:	e8 be ff ff ff       	call   801914 <close>
	for (i = 0; i < MAXFD; i++)
  801956:	83 c3 01             	add    $0x1,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	83 fb 20             	cmp    $0x20,%ebx
  80195f:	75 ec                	jne    80194d <close_all+0xc>
}
  801961:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	57                   	push   %edi
  80196a:	56                   	push   %esi
  80196b:	53                   	push   %ebx
  80196c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80196f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801972:	50                   	push   %eax
  801973:	ff 75 08             	pushl  0x8(%ebp)
  801976:	e8 67 fe ff ff       	call   8017e2 <fd_lookup>
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	0f 88 81 00 00 00    	js     801a09 <dup+0xa3>
		return r;
	close(newfdnum);
  801988:	83 ec 0c             	sub    $0xc,%esp
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 81 ff ff ff       	call   801914 <close>

	newfd = INDEX2FD(newfdnum);
  801993:	8b 75 0c             	mov    0xc(%ebp),%esi
  801996:	c1 e6 0c             	shl    $0xc,%esi
  801999:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80199f:	83 c4 04             	add    $0x4,%esp
  8019a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019a5:	e8 cf fd ff ff       	call   801779 <fd2data>
  8019aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019ac:	89 34 24             	mov    %esi,(%esp)
  8019af:	e8 c5 fd ff ff       	call   801779 <fd2data>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019b9:	89 d8                	mov    %ebx,%eax
  8019bb:	c1 e8 16             	shr    $0x16,%eax
  8019be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019c5:	a8 01                	test   $0x1,%al
  8019c7:	74 11                	je     8019da <dup+0x74>
  8019c9:	89 d8                	mov    %ebx,%eax
  8019cb:	c1 e8 0c             	shr    $0xc,%eax
  8019ce:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019d5:	f6 c2 01             	test   $0x1,%dl
  8019d8:	75 39                	jne    801a13 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019dd:	89 d0                	mov    %edx,%eax
  8019df:	c1 e8 0c             	shr    $0xc,%eax
  8019e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8019f1:	50                   	push   %eax
  8019f2:	56                   	push   %esi
  8019f3:	6a 00                	push   $0x0
  8019f5:	52                   	push   %edx
  8019f6:	6a 00                	push   $0x0
  8019f8:	e8 cd f5 ff ff       	call   800fca <sys_page_map>
  8019fd:	89 c3                	mov    %eax,%ebx
  8019ff:	83 c4 20             	add    $0x20,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 31                	js     801a37 <dup+0xd1>
		goto err;

	return newfdnum;
  801a06:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a09:	89 d8                	mov    %ebx,%eax
  801a0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a0e:	5b                   	pop    %ebx
  801a0f:	5e                   	pop    %esi
  801a10:	5f                   	pop    %edi
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a13:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	25 07 0e 00 00       	and    $0xe07,%eax
  801a22:	50                   	push   %eax
  801a23:	57                   	push   %edi
  801a24:	6a 00                	push   $0x0
  801a26:	53                   	push   %ebx
  801a27:	6a 00                	push   $0x0
  801a29:	e8 9c f5 ff ff       	call   800fca <sys_page_map>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	83 c4 20             	add    $0x20,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	79 a3                	jns    8019da <dup+0x74>
	sys_page_unmap(0, newfd);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	56                   	push   %esi
  801a3b:	6a 00                	push   $0x0
  801a3d:	e8 ca f5 ff ff       	call   80100c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a42:	83 c4 08             	add    $0x8,%esp
  801a45:	57                   	push   %edi
  801a46:	6a 00                	push   $0x0
  801a48:	e8 bf f5 ff ff       	call   80100c <sys_page_unmap>
	return r;
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	eb b7                	jmp    801a09 <dup+0xa3>

00801a52 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  801a61:	e8 7c fd ff ff       	call   8017e2 <fd_lookup>
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 3f                	js     801aac <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a73:	50                   	push   %eax
  801a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a77:	ff 30                	pushl  (%eax)
  801a79:	e8 b4 fd ff ff       	call   801832 <dev_lookup>
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 27                	js     801aac <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a88:	8b 42 08             	mov    0x8(%edx),%eax
  801a8b:	83 e0 03             	and    $0x3,%eax
  801a8e:	83 f8 01             	cmp    $0x1,%eax
  801a91:	74 1e                	je     801ab1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a96:	8b 40 08             	mov    0x8(%eax),%eax
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	74 35                	je     801ad2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	52                   	push   %edx
  801aa7:	ff d0                	call   *%eax
  801aa9:	83 c4 10             	add    $0x10,%esp
}
  801aac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab1:	a1 08 50 80 00       	mov    0x805008,%eax
  801ab6:	8b 40 48             	mov    0x48(%eax),%eax
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	53                   	push   %ebx
  801abd:	50                   	push   %eax
  801abe:	68 05 33 80 00       	push   $0x803305
  801ac3:	e8 6e e9 ff ff       	call   800436 <cprintf>
		return -E_INVAL;
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad0:	eb da                	jmp    801aac <read+0x5a>
		return -E_NOT_SUPP;
  801ad2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad7:	eb d3                	jmp    801aac <read+0x5a>

00801ad9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	57                   	push   %edi
  801add:	56                   	push   %esi
  801ade:	53                   	push   %ebx
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ae5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801ae8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aed:	39 f3                	cmp    %esi,%ebx
  801aef:	73 23                	jae    801b14 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	89 f0                	mov    %esi,%eax
  801af6:	29 d8                	sub    %ebx,%eax
  801af8:	50                   	push   %eax
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	03 45 0c             	add    0xc(%ebp),%eax
  801afe:	50                   	push   %eax
  801aff:	57                   	push   %edi
  801b00:	e8 4d ff ff ff       	call   801a52 <read>
		if (m < 0)
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 06                	js     801b12 <readn+0x39>
			return m;
		if (m == 0)
  801b0c:	74 06                	je     801b14 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b0e:	01 c3                	add    %eax,%ebx
  801b10:	eb db                	jmp    801aed <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b12:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b14:	89 d8                	mov    %ebx,%eax
  801b16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b19:	5b                   	pop    %ebx
  801b1a:	5e                   	pop    %esi
  801b1b:	5f                   	pop    %edi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	53                   	push   %ebx
  801b22:	83 ec 1c             	sub    $0x1c,%esp
  801b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2b:	50                   	push   %eax
  801b2c:	53                   	push   %ebx
  801b2d:	e8 b0 fc ff ff       	call   8017e2 <fd_lookup>
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 3a                	js     801b73 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b39:	83 ec 08             	sub    $0x8,%esp
  801b3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3f:	50                   	push   %eax
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	ff 30                	pushl  (%eax)
  801b45:	e8 e8 fc ff ff       	call   801832 <dev_lookup>
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	78 22                	js     801b73 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b54:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b58:	74 1e                	je     801b78 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801b60:	85 d2                	test   %edx,%edx
  801b62:	74 35                	je     801b99 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	50                   	push   %eax
  801b6e:	ff d2                	call   *%edx
  801b70:	83 c4 10             	add    $0x10,%esp
}
  801b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b78:	a1 08 50 80 00       	mov    0x805008,%eax
  801b7d:	8b 40 48             	mov    0x48(%eax),%eax
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	53                   	push   %ebx
  801b84:	50                   	push   %eax
  801b85:	68 21 33 80 00       	push   $0x803321
  801b8a:	e8 a7 e8 ff ff       	call   800436 <cprintf>
		return -E_INVAL;
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b97:	eb da                	jmp    801b73 <write+0x55>
		return -E_NOT_SUPP;
  801b99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b9e:	eb d3                	jmp    801b73 <write+0x55>

00801ba0 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ba6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba9:	50                   	push   %eax
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	e8 30 fc ff ff       	call   8017e2 <fd_lookup>
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 0e                	js     801bc7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	53                   	push   %ebx
  801bcd:	83 ec 1c             	sub    $0x1c,%esp
  801bd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd6:	50                   	push   %eax
  801bd7:	53                   	push   %ebx
  801bd8:	e8 05 fc ff ff       	call   8017e2 <fd_lookup>
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	85 c0                	test   %eax,%eax
  801be2:	78 37                	js     801c1b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801be4:	83 ec 08             	sub    $0x8,%esp
  801be7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bea:	50                   	push   %eax
  801beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bee:	ff 30                	pushl  (%eax)
  801bf0:	e8 3d fc ff ff       	call   801832 <dev_lookup>
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 1f                	js     801c1b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bff:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c03:	74 1b                	je     801c20 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c08:	8b 52 18             	mov    0x18(%edx),%edx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	74 32                	je     801c41 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c0f:	83 ec 08             	sub    $0x8,%esp
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	50                   	push   %eax
  801c16:	ff d2                	call   *%edx
  801c18:	83 c4 10             	add    $0x10,%esp
}
  801c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c20:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c25:	8b 40 48             	mov    0x48(%eax),%eax
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	53                   	push   %ebx
  801c2c:	50                   	push   %eax
  801c2d:	68 e4 32 80 00       	push   $0x8032e4
  801c32:	e8 ff e7 ff ff       	call   800436 <cprintf>
		return -E_INVAL;
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c3f:	eb da                	jmp    801c1b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c46:	eb d3                	jmp    801c1b <ftruncate+0x52>

00801c48 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	53                   	push   %ebx
  801c4c:	83 ec 1c             	sub    $0x1c,%esp
  801c4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c52:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c55:	50                   	push   %eax
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	e8 84 fb ff ff       	call   8017e2 <fd_lookup>
  801c5e:	83 c4 10             	add    $0x10,%esp
  801c61:	85 c0                	test   %eax,%eax
  801c63:	78 4b                	js     801cb0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c65:	83 ec 08             	sub    $0x8,%esp
  801c68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6b:	50                   	push   %eax
  801c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6f:	ff 30                	pushl  (%eax)
  801c71:	e8 bc fb ff ff       	call   801832 <dev_lookup>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	78 33                	js     801cb0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c84:	74 2f                	je     801cb5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c86:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c89:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c90:	00 00 00 
	stat->st_isdir = 0;
  801c93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c9a:	00 00 00 
	stat->st_dev = dev;
  801c9d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ca3:	83 ec 08             	sub    $0x8,%esp
  801ca6:	53                   	push   %ebx
  801ca7:	ff 75 f0             	pushl  -0x10(%ebp)
  801caa:	ff 50 14             	call   *0x14(%eax)
  801cad:	83 c4 10             	add    $0x10,%esp
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    
		return -E_NOT_SUPP;
  801cb5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cba:	eb f4                	jmp    801cb0 <fstat+0x68>

00801cbc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 22 02 00 00       	call   801ef0 <open>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 1b                	js     801cf2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cd7:	83 ec 08             	sub    $0x8,%esp
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	50                   	push   %eax
  801cde:	e8 65 ff ff ff       	call   801c48 <fstat>
  801ce3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ce5:	89 1c 24             	mov    %ebx,(%esp)
  801ce8:	e8 27 fc ff ff       	call   801914 <close>
	return r;
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	89 f3                	mov    %esi,%ebx
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	56                   	push   %esi
  801cff:	53                   	push   %ebx
  801d00:	89 c6                	mov    %eax,%esi
  801d02:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d04:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d0b:	74 27                	je     801d34 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d0d:	6a 07                	push   $0x7
  801d0f:	68 00 60 80 00       	push   $0x806000
  801d14:	56                   	push   %esi
  801d15:	ff 35 00 50 80 00    	pushl  0x805000
  801d1b:	e8 9d 0c 00 00       	call   8029bd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d20:	83 c4 0c             	add    $0xc,%esp
  801d23:	6a 00                	push   $0x0
  801d25:	53                   	push   %ebx
  801d26:	6a 00                	push   $0x0
  801d28:	e8 27 0c 00 00       	call   802954 <ipc_recv>
}
  801d2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	6a 01                	push   $0x1
  801d39:	e8 d7 0c 00 00       	call   802a15 <ipc_find_env>
  801d3e:	a3 00 50 80 00       	mov    %eax,0x805000
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	eb c5                	jmp    801d0d <fsipc+0x12>

00801d48 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	8b 40 0c             	mov    0xc(%eax),%eax
  801d54:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d61:	ba 00 00 00 00       	mov    $0x0,%edx
  801d66:	b8 02 00 00 00       	mov    $0x2,%eax
  801d6b:	e8 8b ff ff ff       	call   801cfb <fsipc>
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <devfile_flush>:
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d83:	ba 00 00 00 00       	mov    $0x0,%edx
  801d88:	b8 06 00 00 00       	mov    $0x6,%eax
  801d8d:	e8 69 ff ff ff       	call   801cfb <fsipc>
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <devfile_stat>:
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	53                   	push   %ebx
  801d98:	83 ec 04             	sub    $0x4,%esp
  801d9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 40 0c             	mov    0xc(%eax),%eax
  801da4:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dae:	b8 05 00 00 00       	mov    $0x5,%eax
  801db3:	e8 43 ff ff ff       	call   801cfb <fsipc>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 2c                	js     801de8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	68 00 60 80 00       	push   $0x806000
  801dc4:	53                   	push   %ebx
  801dc5:	e8 cb ed ff ff       	call   800b95 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dca:	a1 80 60 80 00       	mov    0x806080,%eax
  801dcf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dd5:	a1 84 60 80 00       	mov    0x806084,%eax
  801dda:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <devfile_write>:
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	53                   	push   %ebx
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e02:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e08:	53                   	push   %ebx
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	68 08 60 80 00       	push   $0x806008
  801e11:	e8 6f ef ff ff       	call   800d85 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e16:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1b:	b8 04 00 00 00       	mov    $0x4,%eax
  801e20:	e8 d6 fe ff ff       	call   801cfb <fsipc>
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 0b                	js     801e37 <devfile_write+0x4a>
	assert(r <= n);
  801e2c:	39 d8                	cmp    %ebx,%eax
  801e2e:	77 0c                	ja     801e3c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e30:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e35:	7f 1e                	jg     801e55 <devfile_write+0x68>
}
  801e37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    
	assert(r <= n);
  801e3c:	68 54 33 80 00       	push   $0x803354
  801e41:	68 5b 33 80 00       	push   $0x80335b
  801e46:	68 98 00 00 00       	push   $0x98
  801e4b:	68 70 33 80 00       	push   $0x803370
  801e50:	e8 eb e4 ff ff       	call   800340 <_panic>
	assert(r <= PGSIZE);
  801e55:	68 7b 33 80 00       	push   $0x80337b
  801e5a:	68 5b 33 80 00       	push   $0x80335b
  801e5f:	68 99 00 00 00       	push   $0x99
  801e64:	68 70 33 80 00       	push   $0x803370
  801e69:	e8 d2 e4 ff ff       	call   800340 <_panic>

00801e6e <devfile_read>:
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	56                   	push   %esi
  801e72:	53                   	push   %ebx
  801e73:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e81:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e87:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801e91:	e8 65 fe ff ff       	call   801cfb <fsipc>
  801e96:	89 c3                	mov    %eax,%ebx
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	78 1f                	js     801ebb <devfile_read+0x4d>
	assert(r <= n);
  801e9c:	39 f0                	cmp    %esi,%eax
  801e9e:	77 24                	ja     801ec4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ea0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ea5:	7f 33                	jg     801eda <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	50                   	push   %eax
  801eab:	68 00 60 80 00       	push   $0x806000
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	e8 6b ee ff ff       	call   800d23 <memmove>
	return r;
  801eb8:	83 c4 10             	add    $0x10,%esp
}
  801ebb:	89 d8                	mov    %ebx,%eax
  801ebd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    
	assert(r <= n);
  801ec4:	68 54 33 80 00       	push   $0x803354
  801ec9:	68 5b 33 80 00       	push   $0x80335b
  801ece:	6a 7c                	push   $0x7c
  801ed0:	68 70 33 80 00       	push   $0x803370
  801ed5:	e8 66 e4 ff ff       	call   800340 <_panic>
	assert(r <= PGSIZE);
  801eda:	68 7b 33 80 00       	push   $0x80337b
  801edf:	68 5b 33 80 00       	push   $0x80335b
  801ee4:	6a 7d                	push   $0x7d
  801ee6:	68 70 33 80 00       	push   $0x803370
  801eeb:	e8 50 e4 ff ff       	call   800340 <_panic>

00801ef0 <open>:
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	56                   	push   %esi
  801ef4:	53                   	push   %ebx
  801ef5:	83 ec 1c             	sub    $0x1c,%esp
  801ef8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801efb:	56                   	push   %esi
  801efc:	e8 5b ec ff ff       	call   800b5c <strlen>
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f09:	7f 6c                	jg     801f77 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f11:	50                   	push   %eax
  801f12:	e8 79 f8 ff ff       	call   801790 <fd_alloc>
  801f17:	89 c3                	mov    %eax,%ebx
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 3c                	js     801f5c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f20:	83 ec 08             	sub    $0x8,%esp
  801f23:	56                   	push   %esi
  801f24:	68 00 60 80 00       	push   $0x806000
  801f29:	e8 67 ec ff ff       	call   800b95 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f31:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f39:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3e:	e8 b8 fd ff ff       	call   801cfb <fsipc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 19                	js     801f65 <open+0x75>
	return fd2num(fd);
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f52:	e8 12 f8 ff ff       	call   801769 <fd2num>
  801f57:	89 c3                	mov    %eax,%ebx
  801f59:	83 c4 10             	add    $0x10,%esp
}
  801f5c:	89 d8                	mov    %ebx,%eax
  801f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5d                   	pop    %ebp
  801f64:	c3                   	ret    
		fd_close(fd, 0);
  801f65:	83 ec 08             	sub    $0x8,%esp
  801f68:	6a 00                	push   $0x0
  801f6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6d:	e8 1b f9 ff ff       	call   80188d <fd_close>
		return r;
  801f72:	83 c4 10             	add    $0x10,%esp
  801f75:	eb e5                	jmp    801f5c <open+0x6c>
		return -E_BAD_PATH;
  801f77:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f7c:	eb de                	jmp    801f5c <open+0x6c>

00801f7e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f84:	ba 00 00 00 00       	mov    $0x0,%edx
  801f89:	b8 08 00 00 00       	mov    $0x8,%eax
  801f8e:	e8 68 fd ff ff       	call   801cfb <fsipc>
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f9b:	68 87 33 80 00       	push   $0x803387
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	e8 ed eb ff ff       	call   800b95 <strcpy>
	return 0;
}
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <devsock_close>:
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	53                   	push   %ebx
  801fb3:	83 ec 10             	sub    $0x10,%esp
  801fb6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fb9:	53                   	push   %ebx
  801fba:	e8 95 0a 00 00       	call   802a54 <pageref>
  801fbf:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fc2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fc7:	83 f8 01             	cmp    $0x1,%eax
  801fca:	74 07                	je     801fd3 <devsock_close+0x24>
}
  801fcc:	89 d0                	mov    %edx,%eax
  801fce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	ff 73 0c             	pushl  0xc(%ebx)
  801fd9:	e8 b9 02 00 00       	call   802297 <nsipc_close>
  801fde:	89 c2                	mov    %eax,%edx
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	eb e7                	jmp    801fcc <devsock_close+0x1d>

00801fe5 <devsock_write>:
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	ff 75 10             	pushl  0x10(%ebp)
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	ff 70 0c             	pushl  0xc(%eax)
  801ff9:	e8 76 03 00 00       	call   802374 <nsipc_send>
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <devsock_read>:
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802006:	6a 00                	push   $0x0
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	ff 70 0c             	pushl  0xc(%eax)
  802014:	e8 ef 02 00 00       	call   802308 <nsipc_recv>
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <fd2sockid>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802021:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802024:	52                   	push   %edx
  802025:	50                   	push   %eax
  802026:	e8 b7 f7 ff ff       	call   8017e2 <fd_lookup>
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	85 c0                	test   %eax,%eax
  802030:	78 10                	js     802042 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80203b:	39 08                	cmp    %ecx,(%eax)
  80203d:	75 05                	jne    802044 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80203f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    
		return -E_NOT_SUPP;
  802044:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802049:	eb f7                	jmp    802042 <fd2sockid+0x27>

0080204b <alloc_sockfd>:
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	56                   	push   %esi
  80204f:	53                   	push   %ebx
  802050:	83 ec 1c             	sub    $0x1c,%esp
  802053:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802055:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802058:	50                   	push   %eax
  802059:	e8 32 f7 ff ff       	call   801790 <fd_alloc>
  80205e:	89 c3                	mov    %eax,%ebx
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	85 c0                	test   %eax,%eax
  802065:	78 43                	js     8020aa <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	68 07 04 00 00       	push   $0x407
  80206f:	ff 75 f4             	pushl  -0xc(%ebp)
  802072:	6a 00                	push   $0x0
  802074:	e8 0e ef ff ff       	call   800f87 <sys_page_alloc>
  802079:	89 c3                	mov    %eax,%ebx
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 28                	js     8020aa <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80208b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802097:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	50                   	push   %eax
  80209e:	e8 c6 f6 ff ff       	call   801769 <fd2num>
  8020a3:	89 c3                	mov    %eax,%ebx
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	eb 0c                	jmp    8020b6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	56                   	push   %esi
  8020ae:	e8 e4 01 00 00       	call   802297 <nsipc_close>
		return r;
  8020b3:	83 c4 10             	add    $0x10,%esp
}
  8020b6:	89 d8                	mov    %ebx,%eax
  8020b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020bb:	5b                   	pop    %ebx
  8020bc:	5e                   	pop    %esi
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <accept>:
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	e8 4e ff ff ff       	call   80201b <fd2sockid>
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 1b                	js     8020ec <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	ff 75 10             	pushl  0x10(%ebp)
  8020d7:	ff 75 0c             	pushl  0xc(%ebp)
  8020da:	50                   	push   %eax
  8020db:	e8 0e 01 00 00       	call   8021ee <nsipc_accept>
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	78 05                	js     8020ec <accept+0x2d>
	return alloc_sockfd(r);
  8020e7:	e8 5f ff ff ff       	call   80204b <alloc_sockfd>
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <bind>:
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	e8 1f ff ff ff       	call   80201b <fd2sockid>
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 12                	js     802112 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	ff 75 10             	pushl  0x10(%ebp)
  802106:	ff 75 0c             	pushl  0xc(%ebp)
  802109:	50                   	push   %eax
  80210a:	e8 31 01 00 00       	call   802240 <nsipc_bind>
  80210f:	83 c4 10             	add    $0x10,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <shutdown>:
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	e8 f9 fe ff ff       	call   80201b <fd2sockid>
  802122:	85 c0                	test   %eax,%eax
  802124:	78 0f                	js     802135 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802126:	83 ec 08             	sub    $0x8,%esp
  802129:	ff 75 0c             	pushl  0xc(%ebp)
  80212c:	50                   	push   %eax
  80212d:	e8 43 01 00 00       	call   802275 <nsipc_shutdown>
  802132:	83 c4 10             	add    $0x10,%esp
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <connect>:
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	e8 d6 fe ff ff       	call   80201b <fd2sockid>
  802145:	85 c0                	test   %eax,%eax
  802147:	78 12                	js     80215b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	ff 75 10             	pushl  0x10(%ebp)
  80214f:	ff 75 0c             	pushl  0xc(%ebp)
  802152:	50                   	push   %eax
  802153:	e8 59 01 00 00       	call   8022b1 <nsipc_connect>
  802158:	83 c4 10             	add    $0x10,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <listen>:
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	e8 b0 fe ff ff       	call   80201b <fd2sockid>
  80216b:	85 c0                	test   %eax,%eax
  80216d:	78 0f                	js     80217e <listen+0x21>
	return nsipc_listen(r, backlog);
  80216f:	83 ec 08             	sub    $0x8,%esp
  802172:	ff 75 0c             	pushl  0xc(%ebp)
  802175:	50                   	push   %eax
  802176:	e8 6b 01 00 00       	call   8022e6 <nsipc_listen>
  80217b:	83 c4 10             	add    $0x10,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <socket>:

int
socket(int domain, int type, int protocol)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802186:	ff 75 10             	pushl  0x10(%ebp)
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	e8 3e 02 00 00       	call   8023d2 <nsipc_socket>
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	85 c0                	test   %eax,%eax
  802199:	78 05                	js     8021a0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80219b:	e8 ab fe ff ff       	call   80204b <alloc_sockfd>
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	53                   	push   %ebx
  8021a6:	83 ec 04             	sub    $0x4,%esp
  8021a9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021ab:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021b2:	74 26                	je     8021da <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021b4:	6a 07                	push   $0x7
  8021b6:	68 00 70 80 00       	push   $0x807000
  8021bb:	53                   	push   %ebx
  8021bc:	ff 35 04 50 80 00    	pushl  0x805004
  8021c2:	e8 f6 07 00 00       	call   8029bd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021c7:	83 c4 0c             	add    $0xc,%esp
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	e8 7f 07 00 00       	call   802954 <ipc_recv>
}
  8021d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021da:	83 ec 0c             	sub    $0xc,%esp
  8021dd:	6a 02                	push   $0x2
  8021df:	e8 31 08 00 00       	call   802a15 <ipc_find_env>
  8021e4:	a3 04 50 80 00       	mov    %eax,0x805004
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	eb c6                	jmp    8021b4 <nsipc+0x12>

008021ee <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021fe:	8b 06                	mov    (%esi),%eax
  802200:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802205:	b8 01 00 00 00       	mov    $0x1,%eax
  80220a:	e8 93 ff ff ff       	call   8021a2 <nsipc>
  80220f:	89 c3                	mov    %eax,%ebx
  802211:	85 c0                	test   %eax,%eax
  802213:	79 09                	jns    80221e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802215:	89 d8                	mov    %ebx,%eax
  802217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221a:	5b                   	pop    %ebx
  80221b:	5e                   	pop    %esi
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	ff 35 10 70 80 00    	pushl  0x807010
  802227:	68 00 70 80 00       	push   $0x807000
  80222c:	ff 75 0c             	pushl  0xc(%ebp)
  80222f:	e8 ef ea ff ff       	call   800d23 <memmove>
		*addrlen = ret->ret_addrlen;
  802234:	a1 10 70 80 00       	mov    0x807010,%eax
  802239:	89 06                	mov    %eax,(%esi)
  80223b:	83 c4 10             	add    $0x10,%esp
	return r;
  80223e:	eb d5                	jmp    802215 <nsipc_accept+0x27>

00802240 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	53                   	push   %ebx
  802244:	83 ec 08             	sub    $0x8,%esp
  802247:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802252:	53                   	push   %ebx
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	68 04 70 80 00       	push   $0x807004
  80225b:	e8 c3 ea ff ff       	call   800d23 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802260:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802266:	b8 02 00 00 00       	mov    $0x2,%eax
  80226b:	e8 32 ff ff ff       	call   8021a2 <nsipc>
}
  802270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802283:	8b 45 0c             	mov    0xc(%ebp),%eax
  802286:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80228b:	b8 03 00 00 00       	mov    $0x3,%eax
  802290:	e8 0d ff ff ff       	call   8021a2 <nsipc>
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <nsipc_close>:

int
nsipc_close(int s)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022a5:	b8 04 00 00 00       	mov    $0x4,%eax
  8022aa:	e8 f3 fe ff ff       	call   8021a2 <nsipc>
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 08             	sub    $0x8,%esp
  8022b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022c3:	53                   	push   %ebx
  8022c4:	ff 75 0c             	pushl  0xc(%ebp)
  8022c7:	68 04 70 80 00       	push   $0x807004
  8022cc:	e8 52 ea ff ff       	call   800d23 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022d1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8022dc:	e8 c1 fe ff ff       	call   8021a2 <nsipc>
}
  8022e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022fc:	b8 06 00 00 00       	mov    $0x6,%eax
  802301:	e8 9c fe ff ff       	call   8021a2 <nsipc>
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	56                   	push   %esi
  80230c:	53                   	push   %ebx
  80230d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802318:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80231e:	8b 45 14             	mov    0x14(%ebp),%eax
  802321:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802326:	b8 07 00 00 00       	mov    $0x7,%eax
  80232b:	e8 72 fe ff ff       	call   8021a2 <nsipc>
  802330:	89 c3                	mov    %eax,%ebx
  802332:	85 c0                	test   %eax,%eax
  802334:	78 1f                	js     802355 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802336:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80233b:	7f 21                	jg     80235e <nsipc_recv+0x56>
  80233d:	39 c6                	cmp    %eax,%esi
  80233f:	7c 1d                	jl     80235e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	50                   	push   %eax
  802345:	68 00 70 80 00       	push   $0x807000
  80234a:	ff 75 0c             	pushl  0xc(%ebp)
  80234d:	e8 d1 e9 ff ff       	call   800d23 <memmove>
  802352:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802355:	89 d8                	mov    %ebx,%eax
  802357:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235a:	5b                   	pop    %ebx
  80235b:	5e                   	pop    %esi
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80235e:	68 93 33 80 00       	push   $0x803393
  802363:	68 5b 33 80 00       	push   $0x80335b
  802368:	6a 62                	push   $0x62
  80236a:	68 a8 33 80 00       	push   $0x8033a8
  80236f:	e8 cc df ff ff       	call   800340 <_panic>

00802374 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	53                   	push   %ebx
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802386:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80238c:	7f 2e                	jg     8023bc <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	53                   	push   %ebx
  802392:	ff 75 0c             	pushl  0xc(%ebp)
  802395:	68 0c 70 80 00       	push   $0x80700c
  80239a:	e8 84 e9 ff ff       	call   800d23 <memmove>
	nsipcbuf.send.req_size = size;
  80239f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8023b2:	e8 eb fd ff ff       	call   8021a2 <nsipc>
}
  8023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    
	assert(size < 1600);
  8023bc:	68 b4 33 80 00       	push   $0x8033b4
  8023c1:	68 5b 33 80 00       	push   $0x80335b
  8023c6:	6a 6d                	push   $0x6d
  8023c8:	68 a8 33 80 00       	push   $0x8033a8
  8023cd:	e8 6e df ff ff       	call   800340 <_panic>

008023d2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023eb:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023f0:	b8 09 00 00 00       	mov    $0x9,%eax
  8023f5:	e8 a8 fd ff ff       	call   8021a2 <nsipc>
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
  802401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802404:	83 ec 0c             	sub    $0xc,%esp
  802407:	ff 75 08             	pushl  0x8(%ebp)
  80240a:	e8 6a f3 ff ff       	call   801779 <fd2data>
  80240f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802411:	83 c4 08             	add    $0x8,%esp
  802414:	68 c0 33 80 00       	push   $0x8033c0
  802419:	53                   	push   %ebx
  80241a:	e8 76 e7 ff ff       	call   800b95 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80241f:	8b 46 04             	mov    0x4(%esi),%eax
  802422:	2b 06                	sub    (%esi),%eax
  802424:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80242a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802431:	00 00 00 
	stat->st_dev = &devpipe;
  802434:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80243b:	40 80 00 
	return 0;
}
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802446:	5b                   	pop    %ebx
  802447:	5e                   	pop    %esi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    

0080244a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	53                   	push   %ebx
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802454:	53                   	push   %ebx
  802455:	6a 00                	push   $0x0
  802457:	e8 b0 eb ff ff       	call   80100c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80245c:	89 1c 24             	mov    %ebx,(%esp)
  80245f:	e8 15 f3 ff ff       	call   801779 <fd2data>
  802464:	83 c4 08             	add    $0x8,%esp
  802467:	50                   	push   %eax
  802468:	6a 00                	push   $0x0
  80246a:	e8 9d eb ff ff       	call   80100c <sys_page_unmap>
}
  80246f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <_pipeisclosed>:
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	57                   	push   %edi
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	83 ec 1c             	sub    $0x1c,%esp
  80247d:	89 c7                	mov    %eax,%edi
  80247f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802481:	a1 08 50 80 00       	mov    0x805008,%eax
  802486:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	57                   	push   %edi
  80248d:	e8 c2 05 00 00       	call   802a54 <pageref>
  802492:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802495:	89 34 24             	mov    %esi,(%esp)
  802498:	e8 b7 05 00 00       	call   802a54 <pageref>
		nn = thisenv->env_runs;
  80249d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024a3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	39 cb                	cmp    %ecx,%ebx
  8024ab:	74 1b                	je     8024c8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024ad:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024b0:	75 cf                	jne    802481 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024b2:	8b 42 58             	mov    0x58(%edx),%eax
  8024b5:	6a 01                	push   $0x1
  8024b7:	50                   	push   %eax
  8024b8:	53                   	push   %ebx
  8024b9:	68 c7 33 80 00       	push   $0x8033c7
  8024be:	e8 73 df ff ff       	call   800436 <cprintf>
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	eb b9                	jmp    802481 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024c8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024cb:	0f 94 c0             	sete   %al
  8024ce:	0f b6 c0             	movzbl %al,%eax
}
  8024d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d4:	5b                   	pop    %ebx
  8024d5:	5e                   	pop    %esi
  8024d6:	5f                   	pop    %edi
  8024d7:	5d                   	pop    %ebp
  8024d8:	c3                   	ret    

008024d9 <devpipe_write>:
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	57                   	push   %edi
  8024dd:	56                   	push   %esi
  8024de:	53                   	push   %ebx
  8024df:	83 ec 28             	sub    $0x28,%esp
  8024e2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024e5:	56                   	push   %esi
  8024e6:	e8 8e f2 ff ff       	call   801779 <fd2data>
  8024eb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024f8:	74 4f                	je     802549 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024fa:	8b 43 04             	mov    0x4(%ebx),%eax
  8024fd:	8b 0b                	mov    (%ebx),%ecx
  8024ff:	8d 51 20             	lea    0x20(%ecx),%edx
  802502:	39 d0                	cmp    %edx,%eax
  802504:	72 14                	jb     80251a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802506:	89 da                	mov    %ebx,%edx
  802508:	89 f0                	mov    %esi,%eax
  80250a:	e8 65 ff ff ff       	call   802474 <_pipeisclosed>
  80250f:	85 c0                	test   %eax,%eax
  802511:	75 3b                	jne    80254e <devpipe_write+0x75>
			sys_yield();
  802513:	e8 50 ea ff ff       	call   800f68 <sys_yield>
  802518:	eb e0                	jmp    8024fa <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80251a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80251d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802521:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802524:	89 c2                	mov    %eax,%edx
  802526:	c1 fa 1f             	sar    $0x1f,%edx
  802529:	89 d1                	mov    %edx,%ecx
  80252b:	c1 e9 1b             	shr    $0x1b,%ecx
  80252e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802531:	83 e2 1f             	and    $0x1f,%edx
  802534:	29 ca                	sub    %ecx,%edx
  802536:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80253a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80253e:	83 c0 01             	add    $0x1,%eax
  802541:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802544:	83 c7 01             	add    $0x1,%edi
  802547:	eb ac                	jmp    8024f5 <devpipe_write+0x1c>
	return i;
  802549:	8b 45 10             	mov    0x10(%ebp),%eax
  80254c:	eb 05                	jmp    802553 <devpipe_write+0x7a>
				return 0;
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802556:	5b                   	pop    %ebx
  802557:	5e                   	pop    %esi
  802558:	5f                   	pop    %edi
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    

0080255b <devpipe_read>:
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	57                   	push   %edi
  80255f:	56                   	push   %esi
  802560:	53                   	push   %ebx
  802561:	83 ec 18             	sub    $0x18,%esp
  802564:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802567:	57                   	push   %edi
  802568:	e8 0c f2 ff ff       	call   801779 <fd2data>
  80256d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80256f:	83 c4 10             	add    $0x10,%esp
  802572:	be 00 00 00 00       	mov    $0x0,%esi
  802577:	3b 75 10             	cmp    0x10(%ebp),%esi
  80257a:	75 14                	jne    802590 <devpipe_read+0x35>
	return i;
  80257c:	8b 45 10             	mov    0x10(%ebp),%eax
  80257f:	eb 02                	jmp    802583 <devpipe_read+0x28>
				return i;
  802581:	89 f0                	mov    %esi,%eax
}
  802583:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802586:	5b                   	pop    %ebx
  802587:	5e                   	pop    %esi
  802588:	5f                   	pop    %edi
  802589:	5d                   	pop    %ebp
  80258a:	c3                   	ret    
			sys_yield();
  80258b:	e8 d8 e9 ff ff       	call   800f68 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802590:	8b 03                	mov    (%ebx),%eax
  802592:	3b 43 04             	cmp    0x4(%ebx),%eax
  802595:	75 18                	jne    8025af <devpipe_read+0x54>
			if (i > 0)
  802597:	85 f6                	test   %esi,%esi
  802599:	75 e6                	jne    802581 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80259b:	89 da                	mov    %ebx,%edx
  80259d:	89 f8                	mov    %edi,%eax
  80259f:	e8 d0 fe ff ff       	call   802474 <_pipeisclosed>
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 e3                	je     80258b <devpipe_read+0x30>
				return 0;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	eb d4                	jmp    802583 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025af:	99                   	cltd   
  8025b0:	c1 ea 1b             	shr    $0x1b,%edx
  8025b3:	01 d0                	add    %edx,%eax
  8025b5:	83 e0 1f             	and    $0x1f,%eax
  8025b8:	29 d0                	sub    %edx,%eax
  8025ba:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025c2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025c5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025c8:	83 c6 01             	add    $0x1,%esi
  8025cb:	eb aa                	jmp    802577 <devpipe_read+0x1c>

008025cd <pipe>:
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	56                   	push   %esi
  8025d1:	53                   	push   %ebx
  8025d2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d8:	50                   	push   %eax
  8025d9:	e8 b2 f1 ff ff       	call   801790 <fd_alloc>
  8025de:	89 c3                	mov    %eax,%ebx
  8025e0:	83 c4 10             	add    $0x10,%esp
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	0f 88 23 01 00 00    	js     80270e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 07 04 00 00       	push   $0x407
  8025f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f6:	6a 00                	push   $0x0
  8025f8:	e8 8a e9 ff ff       	call   800f87 <sys_page_alloc>
  8025fd:	89 c3                	mov    %eax,%ebx
  8025ff:	83 c4 10             	add    $0x10,%esp
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 88 04 01 00 00    	js     80270e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80260a:	83 ec 0c             	sub    $0xc,%esp
  80260d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802610:	50                   	push   %eax
  802611:	e8 7a f1 ff ff       	call   801790 <fd_alloc>
  802616:	89 c3                	mov    %eax,%ebx
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	85 c0                	test   %eax,%eax
  80261d:	0f 88 db 00 00 00    	js     8026fe <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	68 07 04 00 00       	push   $0x407
  80262b:	ff 75 f0             	pushl  -0x10(%ebp)
  80262e:	6a 00                	push   $0x0
  802630:	e8 52 e9 ff ff       	call   800f87 <sys_page_alloc>
  802635:	89 c3                	mov    %eax,%ebx
  802637:	83 c4 10             	add    $0x10,%esp
  80263a:	85 c0                	test   %eax,%eax
  80263c:	0f 88 bc 00 00 00    	js     8026fe <pipe+0x131>
	va = fd2data(fd0);
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	ff 75 f4             	pushl  -0xc(%ebp)
  802648:	e8 2c f1 ff ff       	call   801779 <fd2data>
  80264d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264f:	83 c4 0c             	add    $0xc,%esp
  802652:	68 07 04 00 00       	push   $0x407
  802657:	50                   	push   %eax
  802658:	6a 00                	push   $0x0
  80265a:	e8 28 e9 ff ff       	call   800f87 <sys_page_alloc>
  80265f:	89 c3                	mov    %eax,%ebx
  802661:	83 c4 10             	add    $0x10,%esp
  802664:	85 c0                	test   %eax,%eax
  802666:	0f 88 82 00 00 00    	js     8026ee <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266c:	83 ec 0c             	sub    $0xc,%esp
  80266f:	ff 75 f0             	pushl  -0x10(%ebp)
  802672:	e8 02 f1 ff ff       	call   801779 <fd2data>
  802677:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80267e:	50                   	push   %eax
  80267f:	6a 00                	push   $0x0
  802681:	56                   	push   %esi
  802682:	6a 00                	push   $0x0
  802684:	e8 41 e9 ff ff       	call   800fca <sys_page_map>
  802689:	89 c3                	mov    %eax,%ebx
  80268b:	83 c4 20             	add    $0x20,%esp
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 4e                	js     8026e0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802692:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80269c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026b5:	83 ec 0c             	sub    $0xc,%esp
  8026b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bb:	e8 a9 f0 ff ff       	call   801769 <fd2num>
  8026c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026c5:	83 c4 04             	add    $0x4,%esp
  8026c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026cb:	e8 99 f0 ff ff       	call   801769 <fd2num>
  8026d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026d6:	83 c4 10             	add    $0x10,%esp
  8026d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026de:	eb 2e                	jmp    80270e <pipe+0x141>
	sys_page_unmap(0, va);
  8026e0:	83 ec 08             	sub    $0x8,%esp
  8026e3:	56                   	push   %esi
  8026e4:	6a 00                	push   $0x0
  8026e6:	e8 21 e9 ff ff       	call   80100c <sys_page_unmap>
  8026eb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026ee:	83 ec 08             	sub    $0x8,%esp
  8026f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8026f4:	6a 00                	push   $0x0
  8026f6:	e8 11 e9 ff ff       	call   80100c <sys_page_unmap>
  8026fb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026fe:	83 ec 08             	sub    $0x8,%esp
  802701:	ff 75 f4             	pushl  -0xc(%ebp)
  802704:	6a 00                	push   $0x0
  802706:	e8 01 e9 ff ff       	call   80100c <sys_page_unmap>
  80270b:	83 c4 10             	add    $0x10,%esp
}
  80270e:	89 d8                	mov    %ebx,%eax
  802710:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802713:	5b                   	pop    %ebx
  802714:	5e                   	pop    %esi
  802715:	5d                   	pop    %ebp
  802716:	c3                   	ret    

00802717 <pipeisclosed>:
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
  80271a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80271d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802720:	50                   	push   %eax
  802721:	ff 75 08             	pushl  0x8(%ebp)
  802724:	e8 b9 f0 ff ff       	call   8017e2 <fd_lookup>
  802729:	83 c4 10             	add    $0x10,%esp
  80272c:	85 c0                	test   %eax,%eax
  80272e:	78 18                	js     802748 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802730:	83 ec 0c             	sub    $0xc,%esp
  802733:	ff 75 f4             	pushl  -0xc(%ebp)
  802736:	e8 3e f0 ff ff       	call   801779 <fd2data>
	return _pipeisclosed(fd, p);
  80273b:	89 c2                	mov    %eax,%edx
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	e8 2f fd ff ff       	call   802474 <_pipeisclosed>
  802745:	83 c4 10             	add    $0x10,%esp
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80274a:	b8 00 00 00 00       	mov    $0x0,%eax
  80274f:	c3                   	ret    

00802750 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802756:	68 da 33 80 00       	push   $0x8033da
  80275b:	ff 75 0c             	pushl  0xc(%ebp)
  80275e:	e8 32 e4 ff ff       	call   800b95 <strcpy>
	return 0;
}
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <devcons_write>:
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	57                   	push   %edi
  80276e:	56                   	push   %esi
  80276f:	53                   	push   %ebx
  802770:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802776:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80277b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802781:	3b 75 10             	cmp    0x10(%ebp),%esi
  802784:	73 31                	jae    8027b7 <devcons_write+0x4d>
		m = n - tot;
  802786:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802789:	29 f3                	sub    %esi,%ebx
  80278b:	83 fb 7f             	cmp    $0x7f,%ebx
  80278e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802793:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	53                   	push   %ebx
  80279a:	89 f0                	mov    %esi,%eax
  80279c:	03 45 0c             	add    0xc(%ebp),%eax
  80279f:	50                   	push   %eax
  8027a0:	57                   	push   %edi
  8027a1:	e8 7d e5 ff ff       	call   800d23 <memmove>
		sys_cputs(buf, m);
  8027a6:	83 c4 08             	add    $0x8,%esp
  8027a9:	53                   	push   %ebx
  8027aa:	57                   	push   %edi
  8027ab:	e8 1b e7 ff ff       	call   800ecb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027b0:	01 de                	add    %ebx,%esi
  8027b2:	83 c4 10             	add    $0x10,%esp
  8027b5:	eb ca                	jmp    802781 <devcons_write+0x17>
}
  8027b7:	89 f0                	mov    %esi,%eax
  8027b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027bc:	5b                   	pop    %ebx
  8027bd:	5e                   	pop    %esi
  8027be:	5f                   	pop    %edi
  8027bf:	5d                   	pop    %ebp
  8027c0:	c3                   	ret    

008027c1 <devcons_read>:
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
  8027c4:	83 ec 08             	sub    $0x8,%esp
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027d0:	74 21                	je     8027f3 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027d2:	e8 12 e7 ff ff       	call   800ee9 <sys_cgetc>
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	75 07                	jne    8027e2 <devcons_read+0x21>
		sys_yield();
  8027db:	e8 88 e7 ff ff       	call   800f68 <sys_yield>
  8027e0:	eb f0                	jmp    8027d2 <devcons_read+0x11>
	if (c < 0)
  8027e2:	78 0f                	js     8027f3 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027e4:	83 f8 04             	cmp    $0x4,%eax
  8027e7:	74 0c                	je     8027f5 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ec:	88 02                	mov    %al,(%edx)
	return 1;
  8027ee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    
		return 0;
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	eb f7                	jmp    8027f3 <devcons_read+0x32>

008027fc <cputchar>:
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802808:	6a 01                	push   $0x1
  80280a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80280d:	50                   	push   %eax
  80280e:	e8 b8 e6 ff ff       	call   800ecb <sys_cputs>
}
  802813:	83 c4 10             	add    $0x10,%esp
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <getchar>:
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80281e:	6a 01                	push   $0x1
  802820:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802823:	50                   	push   %eax
  802824:	6a 00                	push   $0x0
  802826:	e8 27 f2 ff ff       	call   801a52 <read>
	if (r < 0)
  80282b:	83 c4 10             	add    $0x10,%esp
  80282e:	85 c0                	test   %eax,%eax
  802830:	78 06                	js     802838 <getchar+0x20>
	if (r < 1)
  802832:	74 06                	je     80283a <getchar+0x22>
	return c;
  802834:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802838:	c9                   	leave  
  802839:	c3                   	ret    
		return -E_EOF;
  80283a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80283f:	eb f7                	jmp    802838 <getchar+0x20>

00802841 <iscons>:
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284a:	50                   	push   %eax
  80284b:	ff 75 08             	pushl  0x8(%ebp)
  80284e:	e8 8f ef ff ff       	call   8017e2 <fd_lookup>
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	85 c0                	test   %eax,%eax
  802858:	78 11                	js     80286b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802863:	39 10                	cmp    %edx,(%eax)
  802865:	0f 94 c0             	sete   %al
  802868:	0f b6 c0             	movzbl %al,%eax
}
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <opencons>:
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
  802870:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802873:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802876:	50                   	push   %eax
  802877:	e8 14 ef ff ff       	call   801790 <fd_alloc>
  80287c:	83 c4 10             	add    $0x10,%esp
  80287f:	85 c0                	test   %eax,%eax
  802881:	78 3a                	js     8028bd <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	68 07 04 00 00       	push   $0x407
  80288b:	ff 75 f4             	pushl  -0xc(%ebp)
  80288e:	6a 00                	push   $0x0
  802890:	e8 f2 e6 ff ff       	call   800f87 <sys_page_alloc>
  802895:	83 c4 10             	add    $0x10,%esp
  802898:	85 c0                	test   %eax,%eax
  80289a:	78 21                	js     8028bd <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b1:	83 ec 0c             	sub    $0xc,%esp
  8028b4:	50                   	push   %eax
  8028b5:	e8 af ee ff ff       	call   801769 <fd2num>
  8028ba:	83 c4 10             	add    $0x10,%esp
}
  8028bd:	c9                   	leave  
  8028be:	c3                   	ret    

008028bf <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028c5:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028cc:	74 0a                	je     8028d8 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028d6:	c9                   	leave  
  8028d7:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	6a 07                	push   $0x7
  8028dd:	68 00 f0 bf ee       	push   $0xeebff000
  8028e2:	6a 00                	push   $0x0
  8028e4:	e8 9e e6 ff ff       	call   800f87 <sys_page_alloc>
		if(r < 0)
  8028e9:	83 c4 10             	add    $0x10,%esp
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	78 2a                	js     80291a <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028f0:	83 ec 08             	sub    $0x8,%esp
  8028f3:	68 2e 29 80 00       	push   $0x80292e
  8028f8:	6a 00                	push   $0x0
  8028fa:	e8 d3 e7 ff ff       	call   8010d2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028ff:	83 c4 10             	add    $0x10,%esp
  802902:	85 c0                	test   %eax,%eax
  802904:	79 c8                	jns    8028ce <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 18 34 80 00       	push   $0x803418
  80290e:	6a 25                	push   $0x25
  802910:	68 54 34 80 00       	push   $0x803454
  802915:	e8 26 da ff ff       	call   800340 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 e8 33 80 00       	push   $0x8033e8
  802922:	6a 22                	push   $0x22
  802924:	68 54 34 80 00       	push   $0x803454
  802929:	e8 12 da ff ff       	call   800340 <_panic>

0080292e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80292e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80292f:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802934:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802936:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802939:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80293d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802941:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802944:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802946:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80294a:	83 c4 08             	add    $0x8,%esp
	popal
  80294d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80294e:	83 c4 04             	add    $0x4,%esp
	popfl
  802951:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802952:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802953:	c3                   	ret    

00802954 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
  802957:	56                   	push   %esi
  802958:	53                   	push   %ebx
  802959:	8b 75 08             	mov    0x8(%ebp),%esi
  80295c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802962:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802964:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802969:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80296c:	83 ec 0c             	sub    $0xc,%esp
  80296f:	50                   	push   %eax
  802970:	e8 c2 e7 ff ff       	call   801137 <sys_ipc_recv>
	if(ret < 0){
  802975:	83 c4 10             	add    $0x10,%esp
  802978:	85 c0                	test   %eax,%eax
  80297a:	78 2b                	js     8029a7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80297c:	85 f6                	test   %esi,%esi
  80297e:	74 0a                	je     80298a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802980:	a1 08 50 80 00       	mov    0x805008,%eax
  802985:	8b 40 78             	mov    0x78(%eax),%eax
  802988:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80298a:	85 db                	test   %ebx,%ebx
  80298c:	74 0a                	je     802998 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80298e:	a1 08 50 80 00       	mov    0x805008,%eax
  802993:	8b 40 7c             	mov    0x7c(%eax),%eax
  802996:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802998:	a1 08 50 80 00       	mov    0x805008,%eax
  80299d:	8b 40 74             	mov    0x74(%eax),%eax
}
  8029a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029a3:	5b                   	pop    %ebx
  8029a4:	5e                   	pop    %esi
  8029a5:	5d                   	pop    %ebp
  8029a6:	c3                   	ret    
		if(from_env_store)
  8029a7:	85 f6                	test   %esi,%esi
  8029a9:	74 06                	je     8029b1 <ipc_recv+0x5d>
			*from_env_store = 0;
  8029ab:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8029b1:	85 db                	test   %ebx,%ebx
  8029b3:	74 eb                	je     8029a0 <ipc_recv+0x4c>
			*perm_store = 0;
  8029b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8029bb:	eb e3                	jmp    8029a0 <ipc_recv+0x4c>

008029bd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
  8029c0:	57                   	push   %edi
  8029c1:	56                   	push   %esi
  8029c2:	53                   	push   %ebx
  8029c3:	83 ec 0c             	sub    $0xc,%esp
  8029c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8029cf:	85 db                	test   %ebx,%ebx
  8029d1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8029d6:	0f 44 d8             	cmove  %eax,%ebx
  8029d9:	eb 05                	jmp    8029e0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8029db:	e8 88 e5 ff ff       	call   800f68 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8029e0:	ff 75 14             	pushl  0x14(%ebp)
  8029e3:	53                   	push   %ebx
  8029e4:	56                   	push   %esi
  8029e5:	57                   	push   %edi
  8029e6:	e8 29 e7 ff ff       	call   801114 <sys_ipc_try_send>
  8029eb:	83 c4 10             	add    $0x10,%esp
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 1b                	je     802a0d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029f2:	79 e7                	jns    8029db <ipc_send+0x1e>
  8029f4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029f7:	74 e2                	je     8029db <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029f9:	83 ec 04             	sub    $0x4,%esp
  8029fc:	68 62 34 80 00       	push   $0x803462
  802a01:	6a 46                	push   $0x46
  802a03:	68 77 34 80 00       	push   $0x803477
  802a08:	e8 33 d9 ff ff       	call   800340 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a10:	5b                   	pop    %ebx
  802a11:	5e                   	pop    %esi
  802a12:	5f                   	pop    %edi
  802a13:	5d                   	pop    %ebp
  802a14:	c3                   	ret    

00802a15 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a1b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a20:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802a26:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a2c:	8b 52 50             	mov    0x50(%edx),%edx
  802a2f:	39 ca                	cmp    %ecx,%edx
  802a31:	74 11                	je     802a44 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802a33:	83 c0 01             	add    $0x1,%eax
  802a36:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a3b:	75 e3                	jne    802a20 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a42:	eb 0e                	jmp    802a52 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802a44:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802a4a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a4f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a52:	5d                   	pop    %ebp
  802a53:	c3                   	ret    

00802a54 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a54:	55                   	push   %ebp
  802a55:	89 e5                	mov    %esp,%ebp
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a5a:	89 d0                	mov    %edx,%eax
  802a5c:	c1 e8 16             	shr    $0x16,%eax
  802a5f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a6b:	f6 c1 01             	test   $0x1,%cl
  802a6e:	74 1d                	je     802a8d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a70:	c1 ea 0c             	shr    $0xc,%edx
  802a73:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a7a:	f6 c2 01             	test   $0x1,%dl
  802a7d:	74 0e                	je     802a8d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a7f:	c1 ea 0c             	shr    $0xc,%edx
  802a82:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a89:	ef 
  802a8a:	0f b7 c0             	movzwl %ax,%eax
}
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    
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
