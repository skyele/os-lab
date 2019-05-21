
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 b2 01 00 00       	call   8001e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 60 26 80 00       	push   $0x802660
  800040:	e8 3b 03 00 00       	call   800380 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 33 20 00 00       	call   802083 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 66                	js     8000bd <umain+0x8a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 b3 12 00 00       	call   80130f <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 6d                	js     8000cf <umain+0x9c>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	74 7d                	je     8000e1 <umain+0xae>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800064:	83 ec 08             	sub    $0x8,%esp
  800067:	56                   	push   %esi
  800068:	68 ba 26 80 00       	push   $0x8026ba
  80006d:	e8 0e 03 00 00       	call   800380 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800072:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800078:	83 c4 08             	add    $0x8,%esp
  80007b:	56                   	push   %esi
  80007c:	68 c5 26 80 00       	push   $0x8026c5
  800081:	e8 fa 02 00 00       	call   800380 <cprintf>
	dup(p[0], 10);
  800086:	83 c4 08             	add    $0x8,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	ff 75 f0             	pushl  -0x10(%ebp)
  80008e:	e8 1c 18 00 00       	call   8018af <dup>
	while (kid->env_status == ENV_RUNNABLE)
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	c1 e6 07             	shl    $0x7,%esi
  800099:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80009f:	8b 46 54             	mov    0x54(%esi),%eax
  8000a2:	83 f8 02             	cmp    $0x2,%eax
  8000a5:	0f 85 94 00 00 00    	jne    80013f <umain+0x10c>
		dup(p[0], 10);
  8000ab:	83 ec 08             	sub    $0x8,%esp
  8000ae:	6a 0a                	push   $0xa
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	e8 f7 17 00 00       	call   8018af <dup>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb e2                	jmp    80009f <umain+0x6c>
		panic("pipe: %e", r);
  8000bd:	50                   	push   %eax
  8000be:	68 79 26 80 00       	push   $0x802679
  8000c3:	6a 0d                	push   $0xd
  8000c5:	68 82 26 80 00       	push   $0x802682
  8000ca:	e8 bb 01 00 00       	call   80028a <_panic>
		panic("fork: %e", r);
  8000cf:	50                   	push   %eax
  8000d0:	68 96 26 80 00       	push   $0x802696
  8000d5:	6a 10                	push   $0x10
  8000d7:	68 82 26 80 00       	push   $0x802682
  8000dc:	e8 a9 01 00 00       	call   80028a <_panic>
		close(p[1]);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e7:	e8 71 17 00 00       	call   80185d <close>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000f4:	eb 1f                	jmp    800115 <umain+0xe2>
				cprintf("RACE: pipe appears closed\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 9f 26 80 00       	push   $0x80269f
  8000fe:	e8 7d 02 00 00       	call   800380 <cprintf>
				exit();
  800103:	e8 70 01 00 00       	call   800278 <exit>
  800108:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  80010b:	e8 a2 0d 00 00       	call   800eb2 <sys_yield>
		for (i=0; i<max; i++) {
  800110:	83 eb 01             	sub    $0x1,%ebx
  800113:	74 14                	je     800129 <umain+0xf6>
			if(pipeisclosed(p[0])){
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	ff 75 f0             	pushl  -0x10(%ebp)
  80011b:	e8 ad 20 00 00       	call   8021cd <pipeisclosed>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	85 c0                	test   %eax,%eax
  800125:	74 e4                	je     80010b <umain+0xd8>
  800127:	eb cd                	jmp    8000f6 <umain+0xc3>
		ipc_recv(0,0,0);
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	6a 00                	push   $0x0
  80012e:	6a 00                	push   $0x0
  800130:	6a 00                	push   $0x0
  800132:	e8 84 14 00 00       	call   8015bb <ipc_recv>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	e9 25 ff ff ff       	jmp    800064 <umain+0x31>

	cprintf("child done with loop\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 d0 26 80 00       	push   $0x8026d0
  800147:	e8 34 02 00 00       	call   800380 <cprintf>
	if (pipeisclosed(p[0]))
  80014c:	83 c4 04             	add    $0x4,%esp
  80014f:	ff 75 f0             	pushl  -0x10(%ebp)
  800152:	e8 76 20 00 00       	call   8021cd <pipeisclosed>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	85 c0                	test   %eax,%eax
  80015c:	75 48                	jne    8001a6 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	ff 75 f0             	pushl  -0x10(%ebp)
  800168:	e8 c3 15 00 00       	call   801730 <fd_lookup>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	78 46                	js     8001ba <umain+0x187>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 ec             	pushl  -0x14(%ebp)
  80017a:	e8 48 15 00 00       	call   8016c7 <fd2data>
	if (pageref(va) != 3+1)
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 f0 1c 00 00       	call   801e77 <pageref>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	83 f8 04             	cmp    $0x4,%eax
  80018d:	74 3d                	je     8001cc <umain+0x199>
		cprintf("\nchild detected race\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 fe 26 80 00       	push   $0x8026fe
  800197:	e8 e4 01 00 00       	call   800380 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  80019f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001a2:	5b                   	pop    %ebx
  8001a3:	5e                   	pop    %esi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 2c 27 80 00       	push   $0x80272c
  8001ae:	6a 3a                	push   $0x3a
  8001b0:	68 82 26 80 00       	push   $0x802682
  8001b5:	e8 d0 00 00 00       	call   80028a <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ba:	50                   	push   %eax
  8001bb:	68 e6 26 80 00       	push   $0x8026e6
  8001c0:	6a 3c                	push   $0x3c
  8001c2:	68 82 26 80 00       	push   $0x802682
  8001c7:	e8 be 00 00 00       	call   80028a <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	68 c8 00 00 00       	push   $0xc8
  8001d4:	68 14 27 80 00       	push   $0x802714
  8001d9:	e8 a2 01 00 00       	call   800380 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
}
  8001e1:	eb bc                	jmp    80019f <umain+0x16c>

008001e3 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001ec:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8001f3:	00 00 00 
	envid_t find = sys_getenvid();
  8001f6:	e8 98 0c 00 00       	call   800e93 <sys_getenvid>
  8001fb:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  800201:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800206:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80020b:	bf 01 00 00 00       	mov    $0x1,%edi
  800210:	eb 0b                	jmp    80021d <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800212:	83 c2 01             	add    $0x1,%edx
  800215:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80021b:	74 21                	je     80023e <libmain+0x5b>
		if(envs[i].env_id == find)
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	c1 e1 07             	shl    $0x7,%ecx
  800222:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800228:	8b 49 48             	mov    0x48(%ecx),%ecx
  80022b:	39 c1                	cmp    %eax,%ecx
  80022d:	75 e3                	jne    800212 <libmain+0x2f>
  80022f:	89 d3                	mov    %edx,%ebx
  800231:	c1 e3 07             	shl    $0x7,%ebx
  800234:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80023a:	89 fe                	mov    %edi,%esi
  80023c:	eb d4                	jmp    800212 <libmain+0x2f>
  80023e:	89 f0                	mov    %esi,%eax
  800240:	84 c0                	test   %al,%al
  800242:	74 06                	je     80024a <libmain+0x67>
  800244:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024e:	7e 0a                	jle    80025a <libmain+0x77>
		binaryname = argv[0];
  800250:	8b 45 0c             	mov    0xc(%ebp),%eax
  800253:	8b 00                	mov    (%eax),%eax
  800255:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 0c             	pushl  0xc(%ebp)
  800260:	ff 75 08             	pushl  0x8(%ebp)
  800263:	e8 cb fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800268:	e8 0b 00 00 00       	call   800278 <exit>
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80027e:	6a 00                	push   $0x0
  800280:	e8 cd 0b 00 00       	call   800e52 <sys_env_destroy>
}
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80028f:	a1 04 40 80 00       	mov    0x804004,%eax
  800294:	8b 40 48             	mov    0x48(%eax),%eax
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 90 27 80 00       	push   $0x802790
  80029f:	50                   	push   %eax
  8002a0:	68 60 27 80 00       	push   $0x802760
  8002a5:	e8 d6 00 00 00       	call   800380 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ad:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002b3:	e8 db 0b 00 00       	call   800e93 <sys_getenvid>
  8002b8:	83 c4 04             	add    $0x4,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	56                   	push   %esi
  8002c2:	50                   	push   %eax
  8002c3:	68 6c 27 80 00       	push   $0x80276c
  8002c8:	e8 b3 00 00 00       	call   800380 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cd:	83 c4 18             	add    $0x18,%esp
  8002d0:	53                   	push   %ebx
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	e8 56 00 00 00       	call   80032f <vcprintf>
	cprintf("\n");
  8002d9:	c7 04 24 99 2b 80 00 	movl   $0x802b99,(%esp)
  8002e0:	e8 9b 00 00 00       	call   800380 <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e8:	cc                   	int3   
  8002e9:	eb fd                	jmp    8002e8 <_panic+0x5e>

008002eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	53                   	push   %ebx
  8002ef:	83 ec 04             	sub    $0x4,%esp
  8002f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f5:	8b 13                	mov    (%ebx),%edx
  8002f7:	8d 42 01             	lea    0x1(%edx),%eax
  8002fa:	89 03                	mov    %eax,(%ebx)
  8002fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800303:	3d ff 00 00 00       	cmp    $0xff,%eax
  800308:	74 09                	je     800313 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800311:	c9                   	leave  
  800312:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800313:	83 ec 08             	sub    $0x8,%esp
  800316:	68 ff 00 00 00       	push   $0xff
  80031b:	8d 43 08             	lea    0x8(%ebx),%eax
  80031e:	50                   	push   %eax
  80031f:	e8 f1 0a 00 00       	call   800e15 <sys_cputs>
		b->idx = 0;
  800324:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	eb db                	jmp    80030a <putch+0x1f>

0080032f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800338:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033f:	00 00 00 
	b.cnt = 0;
  800342:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800349:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800358:	50                   	push   %eax
  800359:	68 eb 02 80 00       	push   $0x8002eb
  80035e:	e8 4a 01 00 00       	call   8004ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800363:	83 c4 08             	add    $0x8,%esp
  800366:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80036c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800372:	50                   	push   %eax
  800373:	e8 9d 0a 00 00       	call   800e15 <sys_cputs>

	return b.cnt;
}
  800378:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800386:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800389:	50                   	push   %eax
  80038a:	ff 75 08             	pushl  0x8(%ebp)
  80038d:	e8 9d ff ff ff       	call   80032f <vcprintf>
	va_end(ap);

	return cnt;
}
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	57                   	push   %edi
  800398:	56                   	push   %esi
  800399:	53                   	push   %ebx
  80039a:	83 ec 1c             	sub    $0x1c,%esp
  80039d:	89 c6                	mov    %eax,%esi
  80039f:	89 d7                	mov    %edx,%edi
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003b3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003b7:	74 2c                	je     8003e5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003ce:	73 43                	jae    800413 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003d0:	83 eb 01             	sub    $0x1,%ebx
  8003d3:	85 db                	test   %ebx,%ebx
  8003d5:	7e 6c                	jle    800443 <printnum+0xaf>
				putch(padc, putdat);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	57                   	push   %edi
  8003db:	ff 75 18             	pushl  0x18(%ebp)
  8003de:	ff d6                	call   *%esi
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	eb eb                	jmp    8003d0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	6a 20                	push   $0x20
  8003ea:	6a 00                	push   $0x0
  8003ec:	50                   	push   %eax
  8003ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f3:	89 fa                	mov    %edi,%edx
  8003f5:	89 f0                	mov    %esi,%eax
  8003f7:	e8 98 ff ff ff       	call   800394 <printnum>
		while (--width > 0)
  8003fc:	83 c4 20             	add    $0x20,%esp
  8003ff:	83 eb 01             	sub    $0x1,%ebx
  800402:	85 db                	test   %ebx,%ebx
  800404:	7e 65                	jle    80046b <printnum+0xd7>
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	57                   	push   %edi
  80040a:	6a 20                	push   $0x20
  80040c:	ff d6                	call   *%esi
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	eb ec                	jmp    8003ff <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	ff 75 18             	pushl  0x18(%ebp)
  800419:	83 eb 01             	sub    $0x1,%ebx
  80041c:	53                   	push   %ebx
  80041d:	50                   	push   %eax
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	ff 75 dc             	pushl  -0x24(%ebp)
  800424:	ff 75 d8             	pushl  -0x28(%ebp)
  800427:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042a:	ff 75 e0             	pushl  -0x20(%ebp)
  80042d:	e8 de 1f 00 00       	call   802410 <__udivdi3>
  800432:	83 c4 18             	add    $0x18,%esp
  800435:	52                   	push   %edx
  800436:	50                   	push   %eax
  800437:	89 fa                	mov    %edi,%edx
  800439:	89 f0                	mov    %esi,%eax
  80043b:	e8 54 ff ff ff       	call   800394 <printnum>
  800440:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	57                   	push   %edi
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	ff 75 dc             	pushl  -0x24(%ebp)
  80044d:	ff 75 d8             	pushl  -0x28(%ebp)
  800450:	ff 75 e4             	pushl  -0x1c(%ebp)
  800453:	ff 75 e0             	pushl  -0x20(%ebp)
  800456:	e8 c5 20 00 00       	call   802520 <__umoddi3>
  80045b:	83 c4 14             	add    $0x14,%esp
  80045e:	0f be 80 97 27 80 00 	movsbl 0x802797(%eax),%eax
  800465:	50                   	push   %eax
  800466:	ff d6                	call   *%esi
  800468:	83 c4 10             	add    $0x10,%esp
	}
}
  80046b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046e:	5b                   	pop    %ebx
  80046f:	5e                   	pop    %esi
  800470:	5f                   	pop    %edi
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800479:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80047d:	8b 10                	mov    (%eax),%edx
  80047f:	3b 50 04             	cmp    0x4(%eax),%edx
  800482:	73 0a                	jae    80048e <sprintputch+0x1b>
		*b->buf++ = ch;
  800484:	8d 4a 01             	lea    0x1(%edx),%ecx
  800487:	89 08                	mov    %ecx,(%eax)
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	88 02                	mov    %al,(%edx)
}
  80048e:	5d                   	pop    %ebp
  80048f:	c3                   	ret    

00800490 <printfmt>:
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800496:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800499:	50                   	push   %eax
  80049a:	ff 75 10             	pushl  0x10(%ebp)
  80049d:	ff 75 0c             	pushl  0xc(%ebp)
  8004a0:	ff 75 08             	pushl  0x8(%ebp)
  8004a3:	e8 05 00 00 00       	call   8004ad <vprintfmt>
}
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <vprintfmt>:
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	57                   	push   %edi
  8004b1:	56                   	push   %esi
  8004b2:	53                   	push   %ebx
  8004b3:	83 ec 3c             	sub    $0x3c,%esp
  8004b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004bf:	e9 32 04 00 00       	jmp    8008f6 <vprintfmt+0x449>
		padc = ' ';
  8004c4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004c8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004cf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004eb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8d 47 01             	lea    0x1(%edi),%eax
  8004f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f6:	0f b6 17             	movzbl (%edi),%edx
  8004f9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004fc:	3c 55                	cmp    $0x55,%al
  8004fe:	0f 87 12 05 00 00    	ja     800a16 <vprintfmt+0x569>
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  80050e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800511:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800515:	eb d9                	jmp    8004f0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800517:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80051a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80051e:	eb d0                	jmp    8004f0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800520:	0f b6 d2             	movzbl %dl,%edx
  800523:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800526:	b8 00 00 00 00       	mov    $0x0,%eax
  80052b:	89 75 08             	mov    %esi,0x8(%ebp)
  80052e:	eb 03                	jmp    800533 <vprintfmt+0x86>
  800530:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800533:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800536:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80053a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80053d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800540:	83 fe 09             	cmp    $0x9,%esi
  800543:	76 eb                	jbe    800530 <vprintfmt+0x83>
  800545:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800548:	8b 75 08             	mov    0x8(%ebp),%esi
  80054b:	eb 14                	jmp    800561 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8d 40 04             	lea    0x4(%eax),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800565:	79 89                	jns    8004f0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800567:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80056a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800574:	e9 77 ff ff ff       	jmp    8004f0 <vprintfmt+0x43>
  800579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057c:	85 c0                	test   %eax,%eax
  80057e:	0f 48 c1             	cmovs  %ecx,%eax
  800581:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800584:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800587:	e9 64 ff ff ff       	jmp    8004f0 <vprintfmt+0x43>
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80058f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800596:	e9 55 ff ff ff       	jmp    8004f0 <vprintfmt+0x43>
			lflag++;
  80059b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005a2:	e9 49 ff ff ff       	jmp    8004f0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 78 04             	lea    0x4(%eax),%edi
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	53                   	push   %ebx
  8005b1:	ff 30                	pushl  (%eax)
  8005b3:	ff d6                	call   *%esi
			break;
  8005b5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005b8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005bb:	e9 33 03 00 00       	jmp    8008f3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8d 78 04             	lea    0x4(%eax),%edi
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	99                   	cltd   
  8005c9:	31 d0                	xor    %edx,%eax
  8005cb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005cd:	83 f8 0f             	cmp    $0xf,%eax
  8005d0:	7f 23                	jg     8005f5 <vprintfmt+0x148>
  8005d2:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  8005d9:	85 d2                	test   %edx,%edx
  8005db:	74 18                	je     8005f5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005dd:	52                   	push   %edx
  8005de:	68 32 2d 80 00       	push   $0x802d32
  8005e3:	53                   	push   %ebx
  8005e4:	56                   	push   %esi
  8005e5:	e8 a6 fe ff ff       	call   800490 <printfmt>
  8005ea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ed:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005f0:	e9 fe 02 00 00       	jmp    8008f3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f5:	50                   	push   %eax
  8005f6:	68 af 27 80 00       	push   $0x8027af
  8005fb:	53                   	push   %ebx
  8005fc:	56                   	push   %esi
  8005fd:	e8 8e fe ff ff       	call   800490 <printfmt>
  800602:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800605:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800608:	e9 e6 02 00 00       	jmp    8008f3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	83 c0 04             	add    $0x4,%eax
  800613:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80061b:	85 c9                	test   %ecx,%ecx
  80061d:	b8 a8 27 80 00       	mov    $0x8027a8,%eax
  800622:	0f 45 c1             	cmovne %ecx,%eax
  800625:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800628:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80062c:	7e 06                	jle    800634 <vprintfmt+0x187>
  80062e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800632:	75 0d                	jne    800641 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800637:	89 c7                	mov    %eax,%edi
  800639:	03 45 e0             	add    -0x20(%ebp),%eax
  80063c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063f:	eb 53                	jmp    800694 <vprintfmt+0x1e7>
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 d8             	pushl  -0x28(%ebp)
  800647:	50                   	push   %eax
  800648:	e8 71 04 00 00       	call   800abe <strnlen>
  80064d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800650:	29 c1                	sub    %eax,%ecx
  800652:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80065a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80065e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800661:	eb 0f                	jmp    800672 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	ff 75 e0             	pushl  -0x20(%ebp)
  80066a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80066c:	83 ef 01             	sub    $0x1,%edi
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	85 ff                	test   %edi,%edi
  800674:	7f ed                	jg     800663 <vprintfmt+0x1b6>
  800676:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	0f 49 c1             	cmovns %ecx,%eax
  800683:	29 c1                	sub    %eax,%ecx
  800685:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800688:	eb aa                	jmp    800634 <vprintfmt+0x187>
					putch(ch, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	52                   	push   %edx
  80068f:	ff d6                	call   *%esi
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800697:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800699:	83 c7 01             	add    $0x1,%edi
  80069c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a0:	0f be d0             	movsbl %al,%edx
  8006a3:	85 d2                	test   %edx,%edx
  8006a5:	74 4b                	je     8006f2 <vprintfmt+0x245>
  8006a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ab:	78 06                	js     8006b3 <vprintfmt+0x206>
  8006ad:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006b1:	78 1e                	js     8006d1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006b7:	74 d1                	je     80068a <vprintfmt+0x1dd>
  8006b9:	0f be c0             	movsbl %al,%eax
  8006bc:	83 e8 20             	sub    $0x20,%eax
  8006bf:	83 f8 5e             	cmp    $0x5e,%eax
  8006c2:	76 c6                	jbe    80068a <vprintfmt+0x1dd>
					putch('?', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 3f                	push   $0x3f
  8006ca:	ff d6                	call   *%esi
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	eb c3                	jmp    800694 <vprintfmt+0x1e7>
  8006d1:	89 cf                	mov    %ecx,%edi
  8006d3:	eb 0e                	jmp    8006e3 <vprintfmt+0x236>
				putch(' ', putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	6a 20                	push   $0x20
  8006db:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006dd:	83 ef 01             	sub    $0x1,%edi
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	85 ff                	test   %edi,%edi
  8006e5:	7f ee                	jg     8006d5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ed:	e9 01 02 00 00       	jmp    8008f3 <vprintfmt+0x446>
  8006f2:	89 cf                	mov    %ecx,%edi
  8006f4:	eb ed                	jmp    8006e3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006f9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800700:	e9 eb fd ff ff       	jmp    8004f0 <vprintfmt+0x43>
	if (lflag >= 2)
  800705:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800709:	7f 21                	jg     80072c <vprintfmt+0x27f>
	else if (lflag)
  80070b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80070f:	74 68                	je     800779 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800719:	89 c1                	mov    %eax,%ecx
  80071b:	c1 f9 1f             	sar    $0x1f,%ecx
  80071e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 04             	lea    0x4(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
  80072a:	eb 17                	jmp    800743 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 50 04             	mov    0x4(%eax),%edx
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800737:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 08             	lea    0x8(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800743:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800746:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80074f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800753:	78 3f                	js     800794 <vprintfmt+0x2e7>
			base = 10;
  800755:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80075a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80075e:	0f 84 71 01 00 00    	je     8008d5 <vprintfmt+0x428>
				putch('+', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 2b                	push   $0x2b
  80076a:	ff d6                	call   *%esi
  80076c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800774:	e9 5c 01 00 00       	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800781:	89 c1                	mov    %eax,%ecx
  800783:	c1 f9 1f             	sar    $0x1f,%ecx
  800786:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 04             	lea    0x4(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
  800792:	eb af                	jmp    800743 <vprintfmt+0x296>
				putch('-', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	6a 2d                	push   $0x2d
  80079a:	ff d6                	call   *%esi
				num = -(long long) num;
  80079c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a2:	f7 d8                	neg    %eax
  8007a4:	83 d2 00             	adc    $0x0,%edx
  8007a7:	f7 da                	neg    %edx
  8007a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007af:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b7:	e9 19 01 00 00       	jmp    8008d5 <vprintfmt+0x428>
	if (lflag >= 2)
  8007bc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c0:	7f 29                	jg     8007eb <vprintfmt+0x33e>
	else if (lflag)
  8007c2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c6:	74 44                	je     80080c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8d 40 04             	lea    0x4(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e6:	e9 ea 00 00 00       	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 08             	lea    0x8(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800802:	b8 0a 00 00 00       	mov    $0xa,%eax
  800807:	e9 c9 00 00 00       	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800819:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800825:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082a:	e9 a6 00 00 00       	jmp    8008d5 <vprintfmt+0x428>
			putch('0', putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	53                   	push   %ebx
  800833:	6a 30                	push   $0x30
  800835:	ff d6                	call   *%esi
	if (lflag >= 2)
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80083e:	7f 26                	jg     800866 <vprintfmt+0x3b9>
	else if (lflag)
  800840:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800844:	74 3e                	je     800884 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8d 40 04             	lea    0x4(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085f:	b8 08 00 00 00       	mov    $0x8,%eax
  800864:	eb 6f                	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 50 04             	mov    0x4(%eax),%edx
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800871:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 08             	lea    0x8(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087d:	b8 08 00 00 00       	mov    $0x8,%eax
  800882:	eb 51                	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	ba 00 00 00 00       	mov    $0x0,%edx
  80088e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800891:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	8d 40 04             	lea    0x4(%eax),%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80089d:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a2:	eb 31                	jmp    8008d5 <vprintfmt+0x428>
			putch('0', putdat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	6a 30                	push   $0x30
  8008aa:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	53                   	push   %ebx
  8008b0:	6a 78                	push   $0x78
  8008b2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008c4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8d 40 04             	lea    0x4(%eax),%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008dc:	52                   	push   %edx
  8008dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e0:	50                   	push   %eax
  8008e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8008e7:	89 da                	mov    %ebx,%edx
  8008e9:	89 f0                	mov    %esi,%eax
  8008eb:	e8 a4 fa ff ff       	call   800394 <printnum>
			break;
  8008f0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f6:	83 c7 01             	add    $0x1,%edi
  8008f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fd:	83 f8 25             	cmp    $0x25,%eax
  800900:	0f 84 be fb ff ff    	je     8004c4 <vprintfmt+0x17>
			if (ch == '\0')
  800906:	85 c0                	test   %eax,%eax
  800908:	0f 84 28 01 00 00    	je     800a36 <vprintfmt+0x589>
			putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	53                   	push   %ebx
  800912:	50                   	push   %eax
  800913:	ff d6                	call   *%esi
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	eb dc                	jmp    8008f6 <vprintfmt+0x449>
	if (lflag >= 2)
  80091a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80091e:	7f 26                	jg     800946 <vprintfmt+0x499>
	else if (lflag)
  800920:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800924:	74 41                	je     800967 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	ba 00 00 00 00       	mov    $0x0,%edx
  800930:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800933:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800936:	8b 45 14             	mov    0x14(%ebp),%eax
  800939:	8d 40 04             	lea    0x4(%eax),%eax
  80093c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093f:	b8 10 00 00 00       	mov    $0x10,%eax
  800944:	eb 8f                	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8b 50 04             	mov    0x4(%eax),%edx
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800951:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	8d 40 08             	lea    0x8(%eax),%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095d:	b8 10 00 00 00       	mov    $0x10,%eax
  800962:	e9 6e ff ff ff       	jmp    8008d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	ba 00 00 00 00       	mov    $0x0,%edx
  800971:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800974:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8d 40 04             	lea    0x4(%eax),%eax
  80097d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800980:	b8 10 00 00 00       	mov    $0x10,%eax
  800985:	e9 4b ff ff ff       	jmp    8008d5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 c0 04             	add    $0x4,%eax
  800990:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	85 c0                	test   %eax,%eax
  80099a:	74 14                	je     8009b0 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80099c:	8b 13                	mov    (%ebx),%edx
  80099e:	83 fa 7f             	cmp    $0x7f,%edx
  8009a1:	7f 37                	jg     8009da <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009a3:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	e9 43 ff ff ff       	jmp    8008f3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b5:	bf cd 28 80 00       	mov    $0x8028cd,%edi
							putch(ch, putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	53                   	push   %ebx
  8009be:	50                   	push   %eax
  8009bf:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009c1:	83 c7 01             	add    $0x1,%edi
  8009c4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 eb                	jne    8009ba <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	e9 19 ff ff ff       	jmp    8008f3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009da:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009e1:	bf 05 29 80 00       	mov    $0x802905,%edi
							putch(ch, putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	53                   	push   %ebx
  8009ea:	50                   	push   %eax
  8009eb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009ed:	83 c7 01             	add    $0x1,%edi
  8009f0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	85 c0                	test   %eax,%eax
  8009f9:	75 eb                	jne    8009e6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800a01:	e9 ed fe ff ff       	jmp    8008f3 <vprintfmt+0x446>
			putch(ch, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	53                   	push   %ebx
  800a0a:	6a 25                	push   $0x25
  800a0c:	ff d6                	call   *%esi
			break;
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	e9 dd fe ff ff       	jmp    8008f3 <vprintfmt+0x446>
			putch('%', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	53                   	push   %ebx
  800a1a:	6a 25                	push   $0x25
  800a1c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	89 f8                	mov    %edi,%eax
  800a23:	eb 03                	jmp    800a28 <vprintfmt+0x57b>
  800a25:	83 e8 01             	sub    $0x1,%eax
  800a28:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a2c:	75 f7                	jne    800a25 <vprintfmt+0x578>
  800a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a31:	e9 bd fe ff ff       	jmp    8008f3 <vprintfmt+0x446>
}
  800a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a39:	5b                   	pop    %ebx
  800a3a:	5e                   	pop    %esi
  800a3b:	5f                   	pop    %edi
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 18             	sub    $0x18,%esp
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a51:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	74 26                	je     800a85 <vsnprintf+0x47>
  800a5f:	85 d2                	test   %edx,%edx
  800a61:	7e 22                	jle    800a85 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a63:	ff 75 14             	pushl  0x14(%ebp)
  800a66:	ff 75 10             	pushl  0x10(%ebp)
  800a69:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6c:	50                   	push   %eax
  800a6d:	68 73 04 80 00       	push   $0x800473
  800a72:	e8 36 fa ff ff       	call   8004ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a80:	83 c4 10             	add    $0x10,%esp
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    
		return -E_INVAL;
  800a85:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a8a:	eb f7                	jmp    800a83 <vsnprintf+0x45>

00800a8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a92:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a95:	50                   	push   %eax
  800a96:	ff 75 10             	pushl  0x10(%ebp)
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	ff 75 08             	pushl  0x8(%ebp)
  800a9f:	e8 9a ff ff ff       	call   800a3e <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab5:	74 05                	je     800abc <strlen+0x16>
		n++;
  800ab7:	83 c0 01             	add    $0x1,%eax
  800aba:	eb f5                	jmp    800ab1 <strlen+0xb>
	return n;
}
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac7:	ba 00 00 00 00       	mov    $0x0,%edx
  800acc:	39 c2                	cmp    %eax,%edx
  800ace:	74 0d                	je     800add <strnlen+0x1f>
  800ad0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ad4:	74 05                	je     800adb <strnlen+0x1d>
		n++;
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	eb f1                	jmp    800acc <strnlen+0xe>
  800adb:	89 d0                	mov    %edx,%eax
	return n;
}
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	53                   	push   %ebx
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800af2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af5:	83 c2 01             	add    $0x1,%edx
  800af8:	84 c9                	test   %cl,%cl
  800afa:	75 f2                	jne    800aee <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800afc:	5b                   	pop    %ebx
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	53                   	push   %ebx
  800b03:	83 ec 10             	sub    $0x10,%esp
  800b06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b09:	53                   	push   %ebx
  800b0a:	e8 97 ff ff ff       	call   800aa6 <strlen>
  800b0f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b12:	ff 75 0c             	pushl  0xc(%ebp)
  800b15:	01 d8                	add    %ebx,%eax
  800b17:	50                   	push   %eax
  800b18:	e8 c2 ff ff ff       	call   800adf <strcpy>
	return dst;
}
  800b1d:	89 d8                	mov    %ebx,%eax
  800b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2f:	89 c6                	mov    %eax,%esi
  800b31:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b34:	89 c2                	mov    %eax,%edx
  800b36:	39 f2                	cmp    %esi,%edx
  800b38:	74 11                	je     800b4b <strncpy+0x27>
		*dst++ = *src;
  800b3a:	83 c2 01             	add    $0x1,%edx
  800b3d:	0f b6 19             	movzbl (%ecx),%ebx
  800b40:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b43:	80 fb 01             	cmp    $0x1,%bl
  800b46:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b49:	eb eb                	jmp    800b36 <strncpy+0x12>
	}
	return ret;
}
  800b4b:	5b                   	pop    %ebx
  800b4c:	5e                   	pop    %esi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 75 08             	mov    0x8(%ebp),%esi
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b5f:	85 d2                	test   %edx,%edx
  800b61:	74 21                	je     800b84 <strlcpy+0x35>
  800b63:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b67:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	74 14                	je     800b81 <strlcpy+0x32>
  800b6d:	0f b6 19             	movzbl (%ecx),%ebx
  800b70:	84 db                	test   %bl,%bl
  800b72:	74 0b                	je     800b7f <strlcpy+0x30>
			*dst++ = *src++;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	83 c2 01             	add    $0x1,%edx
  800b7a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b7d:	eb ea                	jmp    800b69 <strlcpy+0x1a>
  800b7f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b81:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b84:	29 f0                	sub    %esi,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b93:	0f b6 01             	movzbl (%ecx),%eax
  800b96:	84 c0                	test   %al,%al
  800b98:	74 0c                	je     800ba6 <strcmp+0x1c>
  800b9a:	3a 02                	cmp    (%edx),%al
  800b9c:	75 08                	jne    800ba6 <strcmp+0x1c>
		p++, q++;
  800b9e:	83 c1 01             	add    $0x1,%ecx
  800ba1:	83 c2 01             	add    $0x1,%edx
  800ba4:	eb ed                	jmp    800b93 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba6:	0f b6 c0             	movzbl %al,%eax
  800ba9:	0f b6 12             	movzbl (%edx),%edx
  800bac:	29 d0                	sub    %edx,%eax
}
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	53                   	push   %ebx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	89 c3                	mov    %eax,%ebx
  800bbc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bbf:	eb 06                	jmp    800bc7 <strncmp+0x17>
		n--, p++, q++;
  800bc1:	83 c0 01             	add    $0x1,%eax
  800bc4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bc7:	39 d8                	cmp    %ebx,%eax
  800bc9:	74 16                	je     800be1 <strncmp+0x31>
  800bcb:	0f b6 08             	movzbl (%eax),%ecx
  800bce:	84 c9                	test   %cl,%cl
  800bd0:	74 04                	je     800bd6 <strncmp+0x26>
  800bd2:	3a 0a                	cmp    (%edx),%cl
  800bd4:	74 eb                	je     800bc1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd6:	0f b6 00             	movzbl (%eax),%eax
  800bd9:	0f b6 12             	movzbl (%edx),%edx
  800bdc:	29 d0                	sub    %edx,%eax
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    
		return 0;
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	eb f6                	jmp    800bde <strncmp+0x2e>

00800be8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf2:	0f b6 10             	movzbl (%eax),%edx
  800bf5:	84 d2                	test   %dl,%dl
  800bf7:	74 09                	je     800c02 <strchr+0x1a>
		if (*s == c)
  800bf9:	38 ca                	cmp    %cl,%dl
  800bfb:	74 0a                	je     800c07 <strchr+0x1f>
	for (; *s; s++)
  800bfd:	83 c0 01             	add    $0x1,%eax
  800c00:	eb f0                	jmp    800bf2 <strchr+0xa>
			return (char *) s;
	return 0;
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c13:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c16:	38 ca                	cmp    %cl,%dl
  800c18:	74 09                	je     800c23 <strfind+0x1a>
  800c1a:	84 d2                	test   %dl,%dl
  800c1c:	74 05                	je     800c23 <strfind+0x1a>
	for (; *s; s++)
  800c1e:	83 c0 01             	add    $0x1,%eax
  800c21:	eb f0                	jmp    800c13 <strfind+0xa>
			break;
	return (char *) s;
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
  800c2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c31:	85 c9                	test   %ecx,%ecx
  800c33:	74 31                	je     800c66 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c35:	89 f8                	mov    %edi,%eax
  800c37:	09 c8                	or     %ecx,%eax
  800c39:	a8 03                	test   $0x3,%al
  800c3b:	75 23                	jne    800c60 <memset+0x3b>
		c &= 0xFF;
  800c3d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c41:	89 d3                	mov    %edx,%ebx
  800c43:	c1 e3 08             	shl    $0x8,%ebx
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	c1 e0 18             	shl    $0x18,%eax
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	c1 e6 10             	shl    $0x10,%esi
  800c50:	09 f0                	or     %esi,%eax
  800c52:	09 c2                	or     %eax,%edx
  800c54:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c56:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	fc                   	cld    
  800c5c:	f3 ab                	rep stos %eax,%es:(%edi)
  800c5e:	eb 06                	jmp    800c66 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	fc                   	cld    
  800c64:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c66:	89 f8                	mov    %edi,%eax
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c78:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7b:	39 c6                	cmp    %eax,%esi
  800c7d:	73 32                	jae    800cb1 <memmove+0x44>
  800c7f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c82:	39 c2                	cmp    %eax,%edx
  800c84:	76 2b                	jbe    800cb1 <memmove+0x44>
		s += n;
		d += n;
  800c86:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c89:	89 fe                	mov    %edi,%esi
  800c8b:	09 ce                	or     %ecx,%esi
  800c8d:	09 d6                	or     %edx,%esi
  800c8f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c95:	75 0e                	jne    800ca5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c97:	83 ef 04             	sub    $0x4,%edi
  800c9a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c9d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca0:	fd                   	std    
  800ca1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca3:	eb 09                	jmp    800cae <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca5:	83 ef 01             	sub    $0x1,%edi
  800ca8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cab:	fd                   	std    
  800cac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cae:	fc                   	cld    
  800caf:	eb 1a                	jmp    800ccb <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb1:	89 c2                	mov    %eax,%edx
  800cb3:	09 ca                	or     %ecx,%edx
  800cb5:	09 f2                	or     %esi,%edx
  800cb7:	f6 c2 03             	test   $0x3,%dl
  800cba:	75 0a                	jne    800cc6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cbc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cbf:	89 c7                	mov    %eax,%edi
  800cc1:	fc                   	cld    
  800cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc4:	eb 05                	jmp    800ccb <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cc6:	89 c7                	mov    %eax,%edi
  800cc8:	fc                   	cld    
  800cc9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd5:	ff 75 10             	pushl  0x10(%ebp)
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	ff 75 08             	pushl  0x8(%ebp)
  800cde:	e8 8a ff ff ff       	call   800c6d <memmove>
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf0:	89 c6                	mov    %eax,%esi
  800cf2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf5:	39 f0                	cmp    %esi,%eax
  800cf7:	74 1c                	je     800d15 <memcmp+0x30>
		if (*s1 != *s2)
  800cf9:	0f b6 08             	movzbl (%eax),%ecx
  800cfc:	0f b6 1a             	movzbl (%edx),%ebx
  800cff:	38 d9                	cmp    %bl,%cl
  800d01:	75 08                	jne    800d0b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d03:	83 c0 01             	add    $0x1,%eax
  800d06:	83 c2 01             	add    $0x1,%edx
  800d09:	eb ea                	jmp    800cf5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d0b:	0f b6 c1             	movzbl %cl,%eax
  800d0e:	0f b6 db             	movzbl %bl,%ebx
  800d11:	29 d8                	sub    %ebx,%eax
  800d13:	eb 05                	jmp    800d1a <memcmp+0x35>
	}

	return 0;
  800d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d27:	89 c2                	mov    %eax,%edx
  800d29:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d2c:	39 d0                	cmp    %edx,%eax
  800d2e:	73 09                	jae    800d39 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d30:	38 08                	cmp    %cl,(%eax)
  800d32:	74 05                	je     800d39 <memfind+0x1b>
	for (; s < ends; s++)
  800d34:	83 c0 01             	add    $0x1,%eax
  800d37:	eb f3                	jmp    800d2c <memfind+0xe>
			break;
	return (void *) s;
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d44:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d47:	eb 03                	jmp    800d4c <strtol+0x11>
		s++;
  800d49:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d4c:	0f b6 01             	movzbl (%ecx),%eax
  800d4f:	3c 20                	cmp    $0x20,%al
  800d51:	74 f6                	je     800d49 <strtol+0xe>
  800d53:	3c 09                	cmp    $0x9,%al
  800d55:	74 f2                	je     800d49 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d57:	3c 2b                	cmp    $0x2b,%al
  800d59:	74 2a                	je     800d85 <strtol+0x4a>
	int neg = 0;
  800d5b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d60:	3c 2d                	cmp    $0x2d,%al
  800d62:	74 2b                	je     800d8f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d64:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d6a:	75 0f                	jne    800d7b <strtol+0x40>
  800d6c:	80 39 30             	cmpb   $0x30,(%ecx)
  800d6f:	74 28                	je     800d99 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d71:	85 db                	test   %ebx,%ebx
  800d73:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d78:	0f 44 d8             	cmove  %eax,%ebx
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d80:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d83:	eb 50                	jmp    800dd5 <strtol+0x9a>
		s++;
  800d85:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d88:	bf 00 00 00 00       	mov    $0x0,%edi
  800d8d:	eb d5                	jmp    800d64 <strtol+0x29>
		s++, neg = 1;
  800d8f:	83 c1 01             	add    $0x1,%ecx
  800d92:	bf 01 00 00 00       	mov    $0x1,%edi
  800d97:	eb cb                	jmp    800d64 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d99:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d9d:	74 0e                	je     800dad <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d9f:	85 db                	test   %ebx,%ebx
  800da1:	75 d8                	jne    800d7b <strtol+0x40>
		s++, base = 8;
  800da3:	83 c1 01             	add    $0x1,%ecx
  800da6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dab:	eb ce                	jmp    800d7b <strtol+0x40>
		s += 2, base = 16;
  800dad:	83 c1 02             	add    $0x2,%ecx
  800db0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db5:	eb c4                	jmp    800d7b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800db7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dba:	89 f3                	mov    %esi,%ebx
  800dbc:	80 fb 19             	cmp    $0x19,%bl
  800dbf:	77 29                	ja     800dea <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dc1:	0f be d2             	movsbl %dl,%edx
  800dc4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dca:	7d 30                	jge    800dfc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dcc:	83 c1 01             	add    $0x1,%ecx
  800dcf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dd5:	0f b6 11             	movzbl (%ecx),%edx
  800dd8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ddb:	89 f3                	mov    %esi,%ebx
  800ddd:	80 fb 09             	cmp    $0x9,%bl
  800de0:	77 d5                	ja     800db7 <strtol+0x7c>
			dig = *s - '0';
  800de2:	0f be d2             	movsbl %dl,%edx
  800de5:	83 ea 30             	sub    $0x30,%edx
  800de8:	eb dd                	jmp    800dc7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dea:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ded:	89 f3                	mov    %esi,%ebx
  800def:	80 fb 19             	cmp    $0x19,%bl
  800df2:	77 08                	ja     800dfc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df4:	0f be d2             	movsbl %dl,%edx
  800df7:	83 ea 37             	sub    $0x37,%edx
  800dfa:	eb cb                	jmp    800dc7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e00:	74 05                	je     800e07 <strtol+0xcc>
		*endptr = (char *) s;
  800e02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e05:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e07:	89 c2                	mov    %eax,%edx
  800e09:	f7 da                	neg    %edx
  800e0b:	85 ff                	test   %edi,%edi
  800e0d:	0f 45 c2             	cmovne %edx,%eax
}
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e26:	89 c3                	mov    %eax,%ebx
  800e28:	89 c7                	mov    %eax,%edi
  800e2a:	89 c6                	mov    %eax,%esi
  800e2c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e39:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e43:	89 d1                	mov    %edx,%ecx
  800e45:	89 d3                	mov    %edx,%ebx
  800e47:	89 d7                	mov    %edx,%edi
  800e49:	89 d6                	mov    %edx,%esi
  800e4b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	b8 03 00 00 00       	mov    $0x3,%eax
  800e68:	89 cb                	mov    %ecx,%ebx
  800e6a:	89 cf                	mov    %ecx,%edi
  800e6c:	89 ce                	mov    %ecx,%esi
  800e6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 03                	push   $0x3
  800e82:	68 20 2b 80 00       	push   $0x802b20
  800e87:	6a 43                	push   $0x43
  800e89:	68 3d 2b 80 00       	push   $0x802b3d
  800e8e:	e8 f7 f3 ff ff       	call   80028a <_panic>

00800e93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e99:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9e:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea3:	89 d1                	mov    %edx,%ecx
  800ea5:	89 d3                	mov    %edx,%ebx
  800ea7:	89 d7                	mov    %edx,%edi
  800ea9:	89 d6                	mov    %edx,%esi
  800eab:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <sys_yield>:

void
sys_yield(void)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	89 d3                	mov    %edx,%ebx
  800ec6:	89 d7                	mov    %edx,%edi
  800ec8:	89 d6                	mov    %edx,%esi
  800eca:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eda:	be 00 00 00 00       	mov    $0x0,%esi
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee5:	b8 04 00 00 00       	mov    $0x4,%eax
  800eea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eed:	89 f7                	mov    %esi,%edi
  800eef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7f 08                	jg     800efd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	50                   	push   %eax
  800f01:	6a 04                	push   $0x4
  800f03:	68 20 2b 80 00       	push   $0x802b20
  800f08:	6a 43                	push   $0x43
  800f0a:	68 3d 2b 80 00       	push   $0x802b3d
  800f0f:	e8 76 f3 ff ff       	call   80028a <_panic>

00800f14 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
  800f1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 05 00 00 00       	mov    $0x5,%eax
  800f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2e:	8b 75 18             	mov    0x18(%ebp),%esi
  800f31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f33:	85 c0                	test   %eax,%eax
  800f35:	7f 08                	jg     800f3f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3f:	83 ec 0c             	sub    $0xc,%esp
  800f42:	50                   	push   %eax
  800f43:	6a 05                	push   $0x5
  800f45:	68 20 2b 80 00       	push   $0x802b20
  800f4a:	6a 43                	push   $0x43
  800f4c:	68 3d 2b 80 00       	push   $0x802b3d
  800f51:	e8 34 f3 ff ff       	call   80028a <_panic>

00800f56 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
  800f5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	b8 06 00 00 00       	mov    $0x6,%eax
  800f6f:	89 df                	mov    %ebx,%edi
  800f71:	89 de                	mov    %ebx,%esi
  800f73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	7f 08                	jg     800f81 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f81:	83 ec 0c             	sub    $0xc,%esp
  800f84:	50                   	push   %eax
  800f85:	6a 06                	push   $0x6
  800f87:	68 20 2b 80 00       	push   $0x802b20
  800f8c:	6a 43                	push   $0x43
  800f8e:	68 3d 2b 80 00       	push   $0x802b3d
  800f93:	e8 f2 f2 ff ff       	call   80028a <_panic>

00800f98 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
  800f9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	89 de                	mov    %ebx,%esi
  800fb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	7f 08                	jg     800fc3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	50                   	push   %eax
  800fc7:	6a 08                	push   $0x8
  800fc9:	68 20 2b 80 00       	push   $0x802b20
  800fce:	6a 43                	push   $0x43
  800fd0:	68 3d 2b 80 00       	push   $0x802b3d
  800fd5:	e8 b0 f2 ff ff       	call   80028a <_panic>

00800fda <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  800feb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fee:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff3:	89 df                	mov    %ebx,%edi
  800ff5:	89 de                	mov    %ebx,%esi
  800ff7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7f 08                	jg     801005 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801000:	5b                   	pop    %ebx
  801001:	5e                   	pop    %esi
  801002:	5f                   	pop    %edi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801005:	83 ec 0c             	sub    $0xc,%esp
  801008:	50                   	push   %eax
  801009:	6a 09                	push   $0x9
  80100b:	68 20 2b 80 00       	push   $0x802b20
  801010:	6a 43                	push   $0x43
  801012:	68 3d 2b 80 00       	push   $0x802b3d
  801017:	e8 6e f2 ff ff       	call   80028a <_panic>

0080101c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801025:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	b8 0a 00 00 00       	mov    $0xa,%eax
  801035:	89 df                	mov    %ebx,%edi
  801037:	89 de                	mov    %ebx,%esi
  801039:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103b:	85 c0                	test   %eax,%eax
  80103d:	7f 08                	jg     801047 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80103f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801042:	5b                   	pop    %ebx
  801043:	5e                   	pop    %esi
  801044:	5f                   	pop    %edi
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801047:	83 ec 0c             	sub    $0xc,%esp
  80104a:	50                   	push   %eax
  80104b:	6a 0a                	push   $0xa
  80104d:	68 20 2b 80 00       	push   $0x802b20
  801052:	6a 43                	push   $0x43
  801054:	68 3d 2b 80 00       	push   $0x802b3d
  801059:	e8 2c f2 ff ff       	call   80028a <_panic>

0080105e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
	asm volatile("int %1\n"
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80106f:	be 00 00 00 00       	mov    $0x0,%esi
  801074:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801077:	8b 7d 14             	mov    0x14(%ebp),%edi
  80107a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
  801087:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108f:	8b 55 08             	mov    0x8(%ebp),%edx
  801092:	b8 0d 00 00 00       	mov    $0xd,%eax
  801097:	89 cb                	mov    %ecx,%ebx
  801099:	89 cf                	mov    %ecx,%edi
  80109b:	89 ce                	mov    %ecx,%esi
  80109d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	7f 08                	jg     8010ab <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5f                   	pop    %edi
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	50                   	push   %eax
  8010af:	6a 0d                	push   $0xd
  8010b1:	68 20 2b 80 00       	push   $0x802b20
  8010b6:	6a 43                	push   $0x43
  8010b8:	68 3d 2b 80 00       	push   $0x802b3d
  8010bd:	e8 c8 f1 ff ff       	call   80028a <_panic>

008010c2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	57                   	push   %edi
  8010c6:	56                   	push   %esi
  8010c7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010d8:	89 df                	mov    %ebx,%edi
  8010da:	89 de                	mov    %ebx,%esi
  8010dc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5f                   	pop    %edi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010f6:	89 cb                	mov    %ecx,%ebx
  8010f8:	89 cf                	mov    %ecx,%edi
  8010fa:	89 ce                	mov    %ecx,%esi
  8010fc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010fe:	5b                   	pop    %ebx
  8010ff:	5e                   	pop    %esi
  801100:	5f                   	pop    %edi
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	53                   	push   %ebx
  801107:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80110a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801111:	83 e1 07             	and    $0x7,%ecx
  801114:	83 f9 07             	cmp    $0x7,%ecx
  801117:	74 32                	je     80114b <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801119:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801120:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801126:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80112c:	74 7d                	je     8011ab <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80112e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801135:	83 e1 05             	and    $0x5,%ecx
  801138:	83 f9 05             	cmp    $0x5,%ecx
  80113b:	0f 84 9e 00 00 00    	je     8011df <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
  801146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801149:	c9                   	leave  
  80114a:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80114b:	89 d3                	mov    %edx,%ebx
  80114d:	c1 e3 0c             	shl    $0xc,%ebx
  801150:	83 ec 0c             	sub    $0xc,%esp
  801153:	68 05 08 00 00       	push   $0x805
  801158:	53                   	push   %ebx
  801159:	50                   	push   %eax
  80115a:	53                   	push   %ebx
  80115b:	6a 00                	push   $0x0
  80115d:	e8 b2 fd ff ff       	call   800f14 <sys_page_map>
		if(r < 0)
  801162:	83 c4 20             	add    $0x20,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	78 2e                	js     801197 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801169:	83 ec 0c             	sub    $0xc,%esp
  80116c:	68 05 08 00 00       	push   $0x805
  801171:	53                   	push   %ebx
  801172:	6a 00                	push   $0x0
  801174:	53                   	push   %ebx
  801175:	6a 00                	push   $0x0
  801177:	e8 98 fd ff ff       	call   800f14 <sys_page_map>
		if(r < 0)
  80117c:	83 c4 20             	add    $0x20,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	79 be                	jns    801141 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	68 4b 2b 80 00       	push   $0x802b4b
  80118b:	6a 57                	push   $0x57
  80118d:	68 61 2b 80 00       	push   $0x802b61
  801192:	e8 f3 f0 ff ff       	call   80028a <_panic>
			panic("sys_page_map() panic\n");
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	68 4b 2b 80 00       	push   $0x802b4b
  80119f:	6a 53                	push   $0x53
  8011a1:	68 61 2b 80 00       	push   $0x802b61
  8011a6:	e8 df f0 ff ff       	call   80028a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ab:	c1 e2 0c             	shl    $0xc,%edx
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	68 05 08 00 00       	push   $0x805
  8011b6:	52                   	push   %edx
  8011b7:	50                   	push   %eax
  8011b8:	52                   	push   %edx
  8011b9:	6a 00                	push   $0x0
  8011bb:	e8 54 fd ff ff       	call   800f14 <sys_page_map>
		if(r < 0)
  8011c0:	83 c4 20             	add    $0x20,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	0f 89 76 ff ff ff    	jns    801141 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011cb:	83 ec 04             	sub    $0x4,%esp
  8011ce:	68 4b 2b 80 00       	push   $0x802b4b
  8011d3:	6a 5e                	push   $0x5e
  8011d5:	68 61 2b 80 00       	push   $0x802b61
  8011da:	e8 ab f0 ff ff       	call   80028a <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011df:	c1 e2 0c             	shl    $0xc,%edx
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	6a 05                	push   $0x5
  8011e7:	52                   	push   %edx
  8011e8:	50                   	push   %eax
  8011e9:	52                   	push   %edx
  8011ea:	6a 00                	push   $0x0
  8011ec:	e8 23 fd ff ff       	call   800f14 <sys_page_map>
		if(r < 0)
  8011f1:	83 c4 20             	add    $0x20,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	0f 89 45 ff ff ff    	jns    801141 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	68 4b 2b 80 00       	push   $0x802b4b
  801204:	6a 65                	push   $0x65
  801206:	68 61 2b 80 00       	push   $0x802b61
  80120b:	e8 7a f0 ff ff       	call   80028a <_panic>

00801210 <pgfault>:
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	53                   	push   %ebx
  801214:	83 ec 04             	sub    $0x4,%esp
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80121a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80121c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801220:	0f 84 99 00 00 00    	je     8012bf <pgfault+0xaf>
  801226:	89 c2                	mov    %eax,%edx
  801228:	c1 ea 16             	shr    $0x16,%edx
  80122b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801232:	f6 c2 01             	test   $0x1,%dl
  801235:	0f 84 84 00 00 00    	je     8012bf <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80123b:	89 c2                	mov    %eax,%edx
  80123d:	c1 ea 0c             	shr    $0xc,%edx
  801240:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801247:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80124d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801253:	75 6a                	jne    8012bf <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801255:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80125a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	6a 07                	push   $0x7
  801261:	68 00 f0 7f 00       	push   $0x7ff000
  801266:	6a 00                	push   $0x0
  801268:	e8 64 fc ff ff       	call   800ed1 <sys_page_alloc>
	if(ret < 0)
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 5f                	js     8012d3 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801274:	83 ec 04             	sub    $0x4,%esp
  801277:	68 00 10 00 00       	push   $0x1000
  80127c:	53                   	push   %ebx
  80127d:	68 00 f0 7f 00       	push   $0x7ff000
  801282:	e8 48 fa ff ff       	call   800ccf <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801287:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80128e:	53                   	push   %ebx
  80128f:	6a 00                	push   $0x0
  801291:	68 00 f0 7f 00       	push   $0x7ff000
  801296:	6a 00                	push   $0x0
  801298:	e8 77 fc ff ff       	call   800f14 <sys_page_map>
	if(ret < 0)
  80129d:	83 c4 20             	add    $0x20,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	78 43                	js     8012e7 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012a4:	83 ec 08             	sub    $0x8,%esp
  8012a7:	68 00 f0 7f 00       	push   $0x7ff000
  8012ac:	6a 00                	push   $0x0
  8012ae:	e8 a3 fc ff ff       	call   800f56 <sys_page_unmap>
	if(ret < 0)
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	78 41                	js     8012fb <pgfault+0xeb>
}
  8012ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012bf:	83 ec 04             	sub    $0x4,%esp
  8012c2:	68 6c 2b 80 00       	push   $0x802b6c
  8012c7:	6a 26                	push   $0x26
  8012c9:	68 61 2b 80 00       	push   $0x802b61
  8012ce:	e8 b7 ef ff ff       	call   80028a <_panic>
		panic("panic in sys_page_alloc()\n");
  8012d3:	83 ec 04             	sub    $0x4,%esp
  8012d6:	68 80 2b 80 00       	push   $0x802b80
  8012db:	6a 31                	push   $0x31
  8012dd:	68 61 2b 80 00       	push   $0x802b61
  8012e2:	e8 a3 ef ff ff       	call   80028a <_panic>
		panic("panic in sys_page_map()\n");
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	68 9b 2b 80 00       	push   $0x802b9b
  8012ef:	6a 36                	push   $0x36
  8012f1:	68 61 2b 80 00       	push   $0x802b61
  8012f6:	e8 8f ef ff ff       	call   80028a <_panic>
		panic("panic in sys_page_unmap()\n");
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	68 b4 2b 80 00       	push   $0x802bb4
  801303:	6a 39                	push   $0x39
  801305:	68 61 2b 80 00       	push   $0x802b61
  80130a:	e8 7b ef ff ff       	call   80028a <_panic>

0080130f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
  801315:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801318:	68 10 12 80 00       	push   $0x801210
  80131d:	e8 53 10 00 00       	call   802375 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801322:	b8 07 00 00 00       	mov    $0x7,%eax
  801327:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	78 27                	js     801357 <fork+0x48>
  801330:	89 c6                	mov    %eax,%esi
  801332:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801334:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801339:	75 48                	jne    801383 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80133b:	e8 53 fb ff ff       	call   800e93 <sys_getenvid>
  801340:	25 ff 03 00 00       	and    $0x3ff,%eax
  801345:	c1 e0 07             	shl    $0x7,%eax
  801348:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80134d:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801352:	e9 90 00 00 00       	jmp    8013e7 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 d0 2b 80 00       	push   $0x802bd0
  80135f:	68 85 00 00 00       	push   $0x85
  801364:	68 61 2b 80 00       	push   $0x802b61
  801369:	e8 1c ef ff ff       	call   80028a <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80136e:	89 f8                	mov    %edi,%eax
  801370:	e8 8e fd ff ff       	call   801103 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801375:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80137b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801381:	74 26                	je     8013a9 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801383:	89 d8                	mov    %ebx,%eax
  801385:	c1 e8 16             	shr    $0x16,%eax
  801388:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138f:	a8 01                	test   $0x1,%al
  801391:	74 e2                	je     801375 <fork+0x66>
  801393:	89 da                	mov    %ebx,%edx
  801395:	c1 ea 0c             	shr    $0xc,%edx
  801398:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80139f:	83 e0 05             	and    $0x5,%eax
  8013a2:	83 f8 05             	cmp    $0x5,%eax
  8013a5:	75 ce                	jne    801375 <fork+0x66>
  8013a7:	eb c5                	jmp    80136e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	6a 07                	push   $0x7
  8013ae:	68 00 f0 bf ee       	push   $0xeebff000
  8013b3:	56                   	push   %esi
  8013b4:	e8 18 fb ff ff       	call   800ed1 <sys_page_alloc>
	if(ret < 0)
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 31                	js     8013f1 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	68 e4 23 80 00       	push   $0x8023e4
  8013c8:	56                   	push   %esi
  8013c9:	e8 4e fc ff ff       	call   80101c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 33                	js     801408 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	6a 02                	push   $0x2
  8013da:	56                   	push   %esi
  8013db:	e8 b8 fb ff ff       	call   800f98 <sys_env_set_status>
	if(ret < 0)
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 38                	js     80141f <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013e7:	89 f0                	mov    %esi,%eax
  8013e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ec:	5b                   	pop    %ebx
  8013ed:	5e                   	pop    %esi
  8013ee:	5f                   	pop    %edi
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	68 80 2b 80 00       	push   $0x802b80
  8013f9:	68 91 00 00 00       	push   $0x91
  8013fe:	68 61 2b 80 00       	push   $0x802b61
  801403:	e8 82 ee ff ff       	call   80028a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	68 f4 2b 80 00       	push   $0x802bf4
  801410:	68 94 00 00 00       	push   $0x94
  801415:	68 61 2b 80 00       	push   $0x802b61
  80141a:	e8 6b ee ff ff       	call   80028a <_panic>
		panic("panic in sys_env_set_status()\n");
  80141f:	83 ec 04             	sub    $0x4,%esp
  801422:	68 1c 2c 80 00       	push   $0x802c1c
  801427:	68 97 00 00 00       	push   $0x97
  80142c:	68 61 2b 80 00       	push   $0x802b61
  801431:	e8 54 ee ff ff       	call   80028a <_panic>

00801436 <sfork>:

// Challenge!
int
sfork(void)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	57                   	push   %edi
  80143a:	56                   	push   %esi
  80143b:	53                   	push   %ebx
  80143c:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80143f:	a1 04 40 80 00       	mov    0x804004,%eax
  801444:	8b 40 48             	mov    0x48(%eax),%eax
  801447:	68 3c 2c 80 00       	push   $0x802c3c
  80144c:	50                   	push   %eax
  80144d:	68 60 27 80 00       	push   $0x802760
  801452:	e8 29 ef ff ff       	call   800380 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801457:	c7 04 24 10 12 80 00 	movl   $0x801210,(%esp)
  80145e:	e8 12 0f 00 00       	call   802375 <set_pgfault_handler>
  801463:	b8 07 00 00 00       	mov    $0x7,%eax
  801468:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 27                	js     801498 <sfork+0x62>
  801471:	89 c7                	mov    %eax,%edi
  801473:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801475:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80147a:	75 55                	jne    8014d1 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80147c:	e8 12 fa ff ff       	call   800e93 <sys_getenvid>
  801481:	25 ff 03 00 00       	and    $0x3ff,%eax
  801486:	c1 e0 07             	shl    $0x7,%eax
  801489:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80148e:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801493:	e9 d4 00 00 00       	jmp    80156c <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801498:	83 ec 04             	sub    $0x4,%esp
  80149b:	68 d0 2b 80 00       	push   $0x802bd0
  8014a0:	68 a9 00 00 00       	push   $0xa9
  8014a5:	68 61 2b 80 00       	push   $0x802b61
  8014aa:	e8 db ed ff ff       	call   80028a <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014af:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014b4:	89 f0                	mov    %esi,%eax
  8014b6:	e8 48 fc ff ff       	call   801103 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014c1:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014c7:	77 65                	ja     80152e <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8014c9:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014cf:	74 de                	je     8014af <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014d1:	89 d8                	mov    %ebx,%eax
  8014d3:	c1 e8 16             	shr    $0x16,%eax
  8014d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014dd:	a8 01                	test   $0x1,%al
  8014df:	74 da                	je     8014bb <sfork+0x85>
  8014e1:	89 da                	mov    %ebx,%edx
  8014e3:	c1 ea 0c             	shr    $0xc,%edx
  8014e6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014ed:	83 e0 05             	and    $0x5,%eax
  8014f0:	83 f8 05             	cmp    $0x5,%eax
  8014f3:	75 c6                	jne    8014bb <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014f5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014fc:	c1 e2 0c             	shl    $0xc,%edx
  8014ff:	83 ec 0c             	sub    $0xc,%esp
  801502:	83 e0 07             	and    $0x7,%eax
  801505:	50                   	push   %eax
  801506:	52                   	push   %edx
  801507:	56                   	push   %esi
  801508:	52                   	push   %edx
  801509:	6a 00                	push   $0x0
  80150b:	e8 04 fa ff ff       	call   800f14 <sys_page_map>
  801510:	83 c4 20             	add    $0x20,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	74 a4                	je     8014bb <sfork+0x85>
				panic("sys_page_map() panic\n");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 4b 2b 80 00       	push   $0x802b4b
  80151f:	68 b4 00 00 00       	push   $0xb4
  801524:	68 61 2b 80 00       	push   $0x802b61
  801529:	e8 5c ed ff ff       	call   80028a <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	6a 07                	push   $0x7
  801533:	68 00 f0 bf ee       	push   $0xeebff000
  801538:	57                   	push   %edi
  801539:	e8 93 f9 ff ff       	call   800ed1 <sys_page_alloc>
	if(ret < 0)
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 31                	js     801576 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	68 e4 23 80 00       	push   $0x8023e4
  80154d:	57                   	push   %edi
  80154e:	e8 c9 fa ff ff       	call   80101c <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 33                	js     80158d <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	6a 02                	push   $0x2
  80155f:	57                   	push   %edi
  801560:	e8 33 fa ff ff       	call   800f98 <sys_env_set_status>
	if(ret < 0)
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 38                	js     8015a4 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80156c:	89 f8                	mov    %edi,%eax
  80156e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801571:	5b                   	pop    %ebx
  801572:	5e                   	pop    %esi
  801573:	5f                   	pop    %edi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 80 2b 80 00       	push   $0x802b80
  80157e:	68 ba 00 00 00       	push   $0xba
  801583:	68 61 2b 80 00       	push   $0x802b61
  801588:	e8 fd ec ff ff       	call   80028a <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 f4 2b 80 00       	push   $0x802bf4
  801595:	68 bd 00 00 00       	push   $0xbd
  80159a:	68 61 2b 80 00       	push   $0x802b61
  80159f:	e8 e6 ec ff ff       	call   80028a <_panic>
		panic("panic in sys_env_set_status()\n");
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	68 1c 2c 80 00       	push   $0x802c1c
  8015ac:	68 c0 00 00 00       	push   $0xc0
  8015b1:	68 61 2b 80 00       	push   $0x802b61
  8015b6:	e8 cf ec ff ff       	call   80028a <_panic>

008015bb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	56                   	push   %esi
  8015bf:	53                   	push   %ebx
  8015c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8015c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8015c9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015cb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015d0:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	50                   	push   %eax
  8015d7:	e8 a5 fa ff ff       	call   801081 <sys_ipc_recv>
	if(ret < 0){
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 2b                	js     80160e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015e3:	85 f6                	test   %esi,%esi
  8015e5:	74 0a                	je     8015f1 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8015e7:	a1 04 40 80 00       	mov    0x804004,%eax
  8015ec:	8b 40 74             	mov    0x74(%eax),%eax
  8015ef:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015f1:	85 db                	test   %ebx,%ebx
  8015f3:	74 0a                	je     8015ff <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8015f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015fa:	8b 40 78             	mov    0x78(%eax),%eax
  8015fd:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8015ff:	a1 04 40 80 00       	mov    0x804004,%eax
  801604:	8b 40 70             	mov    0x70(%eax),%eax
}
  801607:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80160a:	5b                   	pop    %ebx
  80160b:	5e                   	pop    %esi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    
		if(from_env_store)
  80160e:	85 f6                	test   %esi,%esi
  801610:	74 06                	je     801618 <ipc_recv+0x5d>
			*from_env_store = 0;
  801612:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801618:	85 db                	test   %ebx,%ebx
  80161a:	74 eb                	je     801607 <ipc_recv+0x4c>
			*perm_store = 0;
  80161c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801622:	eb e3                	jmp    801607 <ipc_recv+0x4c>

00801624 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	57                   	push   %edi
  801628:	56                   	push   %esi
  801629:	53                   	push   %ebx
  80162a:	83 ec 0c             	sub    $0xc,%esp
  80162d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801630:	8b 75 0c             	mov    0xc(%ebp),%esi
  801633:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801636:	85 db                	test   %ebx,%ebx
  801638:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80163d:	0f 44 d8             	cmove  %eax,%ebx
  801640:	eb 05                	jmp    801647 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801642:	e8 6b f8 ff ff       	call   800eb2 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801647:	ff 75 14             	pushl  0x14(%ebp)
  80164a:	53                   	push   %ebx
  80164b:	56                   	push   %esi
  80164c:	57                   	push   %edi
  80164d:	e8 0c fa ff ff       	call   80105e <sys_ipc_try_send>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	74 1b                	je     801674 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801659:	79 e7                	jns    801642 <ipc_send+0x1e>
  80165b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80165e:	74 e2                	je     801642 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 42 2c 80 00       	push   $0x802c42
  801668:	6a 49                	push   $0x49
  80166a:	68 57 2c 80 00       	push   $0x802c57
  80166f:	e8 16 ec ff ff       	call   80028a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801677:	5b                   	pop    %ebx
  801678:	5e                   	pop    %esi
  801679:	5f                   	pop    %edi
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801687:	89 c2                	mov    %eax,%edx
  801689:	c1 e2 07             	shl    $0x7,%edx
  80168c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801692:	8b 52 50             	mov    0x50(%edx),%edx
  801695:	39 ca                	cmp    %ecx,%edx
  801697:	74 11                	je     8016aa <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801699:	83 c0 01             	add    $0x1,%eax
  80169c:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016a1:	75 e4                	jne    801687 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a8:	eb 0b                	jmp    8016b5 <ipc_find_env+0x39>
			return envs[i].env_id;
  8016aa:	c1 e0 07             	shl    $0x7,%eax
  8016ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016b2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	05 00 00 00 30       	add    $0x30000000,%eax
  8016c2:	c1 e8 0c             	shr    $0xc,%eax
}
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016e6:	89 c2                	mov    %eax,%edx
  8016e8:	c1 ea 16             	shr    $0x16,%edx
  8016eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016f2:	f6 c2 01             	test   $0x1,%dl
  8016f5:	74 2d                	je     801724 <fd_alloc+0x46>
  8016f7:	89 c2                	mov    %eax,%edx
  8016f9:	c1 ea 0c             	shr    $0xc,%edx
  8016fc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801703:	f6 c2 01             	test   $0x1,%dl
  801706:	74 1c                	je     801724 <fd_alloc+0x46>
  801708:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80170d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801712:	75 d2                	jne    8016e6 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80171d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801722:	eb 0a                	jmp    80172e <fd_alloc+0x50>
			*fd_store = fd;
  801724:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801727:	89 01                	mov    %eax,(%ecx)
			return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801736:	83 f8 1f             	cmp    $0x1f,%eax
  801739:	77 30                	ja     80176b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80173b:	c1 e0 0c             	shl    $0xc,%eax
  80173e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801743:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801749:	f6 c2 01             	test   $0x1,%dl
  80174c:	74 24                	je     801772 <fd_lookup+0x42>
  80174e:	89 c2                	mov    %eax,%edx
  801750:	c1 ea 0c             	shr    $0xc,%edx
  801753:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80175a:	f6 c2 01             	test   $0x1,%dl
  80175d:	74 1a                	je     801779 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80175f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801762:	89 02                	mov    %eax,(%edx)
	return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801769:	5d                   	pop    %ebp
  80176a:	c3                   	ret    
		return -E_INVAL;
  80176b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801770:	eb f7                	jmp    801769 <fd_lookup+0x39>
		return -E_INVAL;
  801772:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801777:	eb f0                	jmp    801769 <fd_lookup+0x39>
  801779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177e:	eb e9                	jmp    801769 <fd_lookup+0x39>

00801780 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801789:	ba e0 2c 80 00       	mov    $0x802ce0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80178e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801793:	39 08                	cmp    %ecx,(%eax)
  801795:	74 33                	je     8017ca <dev_lookup+0x4a>
  801797:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80179a:	8b 02                	mov    (%edx),%eax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 f3                	jne    801793 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8017a5:	8b 40 48             	mov    0x48(%eax),%eax
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	51                   	push   %ecx
  8017ac:	50                   	push   %eax
  8017ad:	68 64 2c 80 00       	push   $0x802c64
  8017b2:	e8 c9 eb ff ff       	call   800380 <cprintf>
	*dev = 0;
  8017b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    
			*dev = devtab[i];
  8017ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017cd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d4:	eb f2                	jmp    8017c8 <dev_lookup+0x48>

008017d6 <fd_close>:
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	57                   	push   %edi
  8017da:	56                   	push   %esi
  8017db:	53                   	push   %ebx
  8017dc:	83 ec 24             	sub    $0x24,%esp
  8017df:	8b 75 08             	mov    0x8(%ebp),%esi
  8017e2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017e8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017e9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017ef:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f2:	50                   	push   %eax
  8017f3:	e8 38 ff ff ff       	call   801730 <fd_lookup>
  8017f8:	89 c3                	mov    %eax,%ebx
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 05                	js     801806 <fd_close+0x30>
	    || fd != fd2)
  801801:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801804:	74 16                	je     80181c <fd_close+0x46>
		return (must_exist ? r : 0);
  801806:	89 f8                	mov    %edi,%eax
  801808:	84 c0                	test   %al,%al
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
  80180f:	0f 44 d8             	cmove  %eax,%ebx
}
  801812:	89 d8                	mov    %ebx,%eax
  801814:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80181c:	83 ec 08             	sub    $0x8,%esp
  80181f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801822:	50                   	push   %eax
  801823:	ff 36                	pushl  (%esi)
  801825:	e8 56 ff ff ff       	call   801780 <dev_lookup>
  80182a:	89 c3                	mov    %eax,%ebx
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 1a                	js     80184d <fd_close+0x77>
		if (dev->dev_close)
  801833:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801836:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801839:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 0b                	je     80184d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801842:	83 ec 0c             	sub    $0xc,%esp
  801845:	56                   	push   %esi
  801846:	ff d0                	call   *%eax
  801848:	89 c3                	mov    %eax,%ebx
  80184a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	56                   	push   %esi
  801851:	6a 00                	push   $0x0
  801853:	e8 fe f6 ff ff       	call   800f56 <sys_page_unmap>
	return r;
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	eb b5                	jmp    801812 <fd_close+0x3c>

0080185d <close>:

int
close(int fdnum)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801863:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801866:	50                   	push   %eax
  801867:	ff 75 08             	pushl  0x8(%ebp)
  80186a:	e8 c1 fe ff ff       	call   801730 <fd_lookup>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	79 02                	jns    801878 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    
		return fd_close(fd, 1);
  801878:	83 ec 08             	sub    $0x8,%esp
  80187b:	6a 01                	push   $0x1
  80187d:	ff 75 f4             	pushl  -0xc(%ebp)
  801880:	e8 51 ff ff ff       	call   8017d6 <fd_close>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	eb ec                	jmp    801876 <close+0x19>

0080188a <close_all>:

void
close_all(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	53                   	push   %ebx
  80188e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801891:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	53                   	push   %ebx
  80189a:	e8 be ff ff ff       	call   80185d <close>
	for (i = 0; i < MAXFD; i++)
  80189f:	83 c3 01             	add    $0x1,%ebx
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	83 fb 20             	cmp    $0x20,%ebx
  8018a8:	75 ec                	jne    801896 <close_all+0xc>
}
  8018aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	57                   	push   %edi
  8018b3:	56                   	push   %esi
  8018b4:	53                   	push   %ebx
  8018b5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018bb:	50                   	push   %eax
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	e8 6c fe ff ff       	call   801730 <fd_lookup>
  8018c4:	89 c3                	mov    %eax,%ebx
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	0f 88 81 00 00 00    	js     801952 <dup+0xa3>
		return r;
	close(newfdnum);
  8018d1:	83 ec 0c             	sub    $0xc,%esp
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	e8 81 ff ff ff       	call   80185d <close>

	newfd = INDEX2FD(newfdnum);
  8018dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018df:	c1 e6 0c             	shl    $0xc,%esi
  8018e2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018e8:	83 c4 04             	add    $0x4,%esp
  8018eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ee:	e8 d4 fd ff ff       	call   8016c7 <fd2data>
  8018f3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018f5:	89 34 24             	mov    %esi,(%esp)
  8018f8:	e8 ca fd ff ff       	call   8016c7 <fd2data>
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801902:	89 d8                	mov    %ebx,%eax
  801904:	c1 e8 16             	shr    $0x16,%eax
  801907:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80190e:	a8 01                	test   $0x1,%al
  801910:	74 11                	je     801923 <dup+0x74>
  801912:	89 d8                	mov    %ebx,%eax
  801914:	c1 e8 0c             	shr    $0xc,%eax
  801917:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80191e:	f6 c2 01             	test   $0x1,%dl
  801921:	75 39                	jne    80195c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801926:	89 d0                	mov    %edx,%eax
  801928:	c1 e8 0c             	shr    $0xc,%eax
  80192b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	25 07 0e 00 00       	and    $0xe07,%eax
  80193a:	50                   	push   %eax
  80193b:	56                   	push   %esi
  80193c:	6a 00                	push   $0x0
  80193e:	52                   	push   %edx
  80193f:	6a 00                	push   $0x0
  801941:	e8 ce f5 ff ff       	call   800f14 <sys_page_map>
  801946:	89 c3                	mov    %eax,%ebx
  801948:	83 c4 20             	add    $0x20,%esp
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 31                	js     801980 <dup+0xd1>
		goto err;

	return newfdnum;
  80194f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801952:	89 d8                	mov    %ebx,%eax
  801954:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5f                   	pop    %edi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80195c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	25 07 0e 00 00       	and    $0xe07,%eax
  80196b:	50                   	push   %eax
  80196c:	57                   	push   %edi
  80196d:	6a 00                	push   $0x0
  80196f:	53                   	push   %ebx
  801970:	6a 00                	push   $0x0
  801972:	e8 9d f5 ff ff       	call   800f14 <sys_page_map>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	83 c4 20             	add    $0x20,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	79 a3                	jns    801923 <dup+0x74>
	sys_page_unmap(0, newfd);
  801980:	83 ec 08             	sub    $0x8,%esp
  801983:	56                   	push   %esi
  801984:	6a 00                	push   $0x0
  801986:	e8 cb f5 ff ff       	call   800f56 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80198b:	83 c4 08             	add    $0x8,%esp
  80198e:	57                   	push   %edi
  80198f:	6a 00                	push   $0x0
  801991:	e8 c0 f5 ff ff       	call   800f56 <sys_page_unmap>
	return r;
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	eb b7                	jmp    801952 <dup+0xa3>

0080199b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	53                   	push   %ebx
  80199f:	83 ec 1c             	sub    $0x1c,%esp
  8019a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a8:	50                   	push   %eax
  8019a9:	53                   	push   %ebx
  8019aa:	e8 81 fd ff ff       	call   801730 <fd_lookup>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 3f                	js     8019f5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b6:	83 ec 08             	sub    $0x8,%esp
  8019b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bc:	50                   	push   %eax
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	ff 30                	pushl  (%eax)
  8019c2:	e8 b9 fd ff ff       	call   801780 <dev_lookup>
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 27                	js     8019f5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d1:	8b 42 08             	mov    0x8(%edx),%eax
  8019d4:	83 e0 03             	and    $0x3,%eax
  8019d7:	83 f8 01             	cmp    $0x1,%eax
  8019da:	74 1e                	je     8019fa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019df:	8b 40 08             	mov    0x8(%eax),%eax
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	74 35                	je     801a1b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	52                   	push   %edx
  8019f0:	ff d0                	call   *%eax
  8019f2:	83 c4 10             	add    $0x10,%esp
}
  8019f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8019ff:	8b 40 48             	mov    0x48(%eax),%eax
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	53                   	push   %ebx
  801a06:	50                   	push   %eax
  801a07:	68 a5 2c 80 00       	push   $0x802ca5
  801a0c:	e8 6f e9 ff ff       	call   800380 <cprintf>
		return -E_INVAL;
  801a11:	83 c4 10             	add    $0x10,%esp
  801a14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a19:	eb da                	jmp    8019f5 <read+0x5a>
		return -E_NOT_SUPP;
  801a1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a20:	eb d3                	jmp    8019f5 <read+0x5a>

00801a22 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	57                   	push   %edi
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 0c             	sub    $0xc,%esp
  801a2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a2e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a31:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a36:	39 f3                	cmp    %esi,%ebx
  801a38:	73 23                	jae    801a5d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	89 f0                	mov    %esi,%eax
  801a3f:	29 d8                	sub    %ebx,%eax
  801a41:	50                   	push   %eax
  801a42:	89 d8                	mov    %ebx,%eax
  801a44:	03 45 0c             	add    0xc(%ebp),%eax
  801a47:	50                   	push   %eax
  801a48:	57                   	push   %edi
  801a49:	e8 4d ff ff ff       	call   80199b <read>
		if (m < 0)
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 06                	js     801a5b <readn+0x39>
			return m;
		if (m == 0)
  801a55:	74 06                	je     801a5d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a57:	01 c3                	add    %eax,%ebx
  801a59:	eb db                	jmp    801a36 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a5b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5f                   	pop    %edi
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    

00801a67 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	53                   	push   %ebx
  801a6b:	83 ec 1c             	sub    $0x1c,%esp
  801a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a74:	50                   	push   %eax
  801a75:	53                   	push   %ebx
  801a76:	e8 b5 fc ff ff       	call   801730 <fd_lookup>
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 3a                	js     801abc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	ff 30                	pushl  (%eax)
  801a8e:	e8 ed fc ff ff       	call   801780 <dev_lookup>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 22                	js     801abc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aa1:	74 1e                	je     801ac1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa6:	8b 52 0c             	mov    0xc(%edx),%edx
  801aa9:	85 d2                	test   %edx,%edx
  801aab:	74 35                	je     801ae2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	ff 75 10             	pushl  0x10(%ebp)
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	50                   	push   %eax
  801ab7:	ff d2                	call   *%edx
  801ab9:	83 c4 10             	add    $0x10,%esp
}
  801abc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ac1:	a1 04 40 80 00       	mov    0x804004,%eax
  801ac6:	8b 40 48             	mov    0x48(%eax),%eax
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	53                   	push   %ebx
  801acd:	50                   	push   %eax
  801ace:	68 c1 2c 80 00       	push   $0x802cc1
  801ad3:	e8 a8 e8 ff ff       	call   800380 <cprintf>
		return -E_INVAL;
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ae0:	eb da                	jmp    801abc <write+0x55>
		return -E_NOT_SUPP;
  801ae2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae7:	eb d3                	jmp    801abc <write+0x55>

00801ae9 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af2:	50                   	push   %eax
  801af3:	ff 75 08             	pushl  0x8(%ebp)
  801af6:	e8 35 fc ff ff       	call   801730 <fd_lookup>
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	85 c0                	test   %eax,%eax
  801b00:	78 0e                	js     801b10 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b08:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	53                   	push   %ebx
  801b16:	83 ec 1c             	sub    $0x1c,%esp
  801b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1f:	50                   	push   %eax
  801b20:	53                   	push   %ebx
  801b21:	e8 0a fc ff ff       	call   801730 <fd_lookup>
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 37                	js     801b64 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b2d:	83 ec 08             	sub    $0x8,%esp
  801b30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b33:	50                   	push   %eax
  801b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b37:	ff 30                	pushl  (%eax)
  801b39:	e8 42 fc ff ff       	call   801780 <dev_lookup>
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	85 c0                	test   %eax,%eax
  801b43:	78 1f                	js     801b64 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b48:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b4c:	74 1b                	je     801b69 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b51:	8b 52 18             	mov    0x18(%edx),%edx
  801b54:	85 d2                	test   %edx,%edx
  801b56:	74 32                	je     801b8a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b58:	83 ec 08             	sub    $0x8,%esp
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	50                   	push   %eax
  801b5f:	ff d2                	call   *%edx
  801b61:	83 c4 10             	add    $0x10,%esp
}
  801b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b69:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b6e:	8b 40 48             	mov    0x48(%eax),%eax
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	53                   	push   %ebx
  801b75:	50                   	push   %eax
  801b76:	68 84 2c 80 00       	push   $0x802c84
  801b7b:	e8 00 e8 ff ff       	call   800380 <cprintf>
		return -E_INVAL;
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b88:	eb da                	jmp    801b64 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b8a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b8f:	eb d3                	jmp    801b64 <ftruncate+0x52>

00801b91 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	53                   	push   %ebx
  801b95:	83 ec 1c             	sub    $0x1c,%esp
  801b98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b9e:	50                   	push   %eax
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	e8 89 fb ff ff       	call   801730 <fd_lookup>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 4b                	js     801bf9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb4:	50                   	push   %eax
  801bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb8:	ff 30                	pushl  (%eax)
  801bba:	e8 c1 fb ff ff       	call   801780 <dev_lookup>
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	78 33                	js     801bf9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bcd:	74 2f                	je     801bfe <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bcf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bd2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bd9:	00 00 00 
	stat->st_isdir = 0;
  801bdc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801be3:	00 00 00 
	stat->st_dev = dev;
  801be6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	53                   	push   %ebx
  801bf0:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf3:	ff 50 14             	call   *0x14(%eax)
  801bf6:	83 c4 10             	add    $0x10,%esp
}
  801bf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    
		return -E_NOT_SUPP;
  801bfe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c03:	eb f4                	jmp    801bf9 <fstat+0x68>

00801c05 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	56                   	push   %esi
  801c09:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c0a:	83 ec 08             	sub    $0x8,%esp
  801c0d:	6a 00                	push   $0x0
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	e8 bb 01 00 00       	call   801dd2 <open>
  801c17:	89 c3                	mov    %eax,%ebx
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 1b                	js     801c3b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c20:	83 ec 08             	sub    $0x8,%esp
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	50                   	push   %eax
  801c27:	e8 65 ff ff ff       	call   801b91 <fstat>
  801c2c:	89 c6                	mov    %eax,%esi
	close(fd);
  801c2e:	89 1c 24             	mov    %ebx,(%esp)
  801c31:	e8 27 fc ff ff       	call   80185d <close>
	return r;
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	89 f3                	mov    %esi,%ebx
}
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    

00801c44 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	56                   	push   %esi
  801c48:	53                   	push   %ebx
  801c49:	89 c6                	mov    %eax,%esi
  801c4b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c4d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801c54:	74 27                	je     801c7d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c56:	6a 07                	push   $0x7
  801c58:	68 00 50 80 00       	push   $0x805000
  801c5d:	56                   	push   %esi
  801c5e:	ff 35 00 40 80 00    	pushl  0x804000
  801c64:	e8 bb f9 ff ff       	call   801624 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c69:	83 c4 0c             	add    $0xc,%esp
  801c6c:	6a 00                	push   $0x0
  801c6e:	53                   	push   %ebx
  801c6f:	6a 00                	push   $0x0
  801c71:	e8 45 f9 ff ff       	call   8015bb <ipc_recv>
}
  801c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c79:	5b                   	pop    %ebx
  801c7a:	5e                   	pop    %esi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	6a 01                	push   $0x1
  801c82:	e8 f5 f9 ff ff       	call   80167c <ipc_find_env>
  801c87:	a3 00 40 80 00       	mov    %eax,0x804000
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	eb c5                	jmp    801c56 <fsipc+0x12>

00801c91 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801caa:	ba 00 00 00 00       	mov    $0x0,%edx
  801caf:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb4:	e8 8b ff ff ff       	call   801c44 <fsipc>
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <devfile_flush>:
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd1:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd6:	e8 69 ff ff ff       	call   801c44 <fsipc>
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <devfile_stat>:
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ced:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf7:	b8 05 00 00 00       	mov    $0x5,%eax
  801cfc:	e8 43 ff ff ff       	call   801c44 <fsipc>
  801d01:	85 c0                	test   %eax,%eax
  801d03:	78 2c                	js     801d31 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d05:	83 ec 08             	sub    $0x8,%esp
  801d08:	68 00 50 80 00       	push   $0x805000
  801d0d:	53                   	push   %ebx
  801d0e:	e8 cc ed ff ff       	call   800adf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d13:	a1 80 50 80 00       	mov    0x805080,%eax
  801d18:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d1e:	a1 84 50 80 00       	mov    0x805084,%eax
  801d23:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <devfile_write>:
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801d3c:	68 f0 2c 80 00       	push   $0x802cf0
  801d41:	68 90 00 00 00       	push   $0x90
  801d46:	68 0e 2d 80 00       	push   $0x802d0e
  801d4b:	e8 3a e5 ff ff       	call   80028a <_panic>

00801d50 <devfile_read>:
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	56                   	push   %esi
  801d54:	53                   	push   %ebx
  801d55:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801d63:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d69:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6e:	b8 03 00 00 00       	mov    $0x3,%eax
  801d73:	e8 cc fe ff ff       	call   801c44 <fsipc>
  801d78:	89 c3                	mov    %eax,%ebx
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	78 1f                	js     801d9d <devfile_read+0x4d>
	assert(r <= n);
  801d7e:	39 f0                	cmp    %esi,%eax
  801d80:	77 24                	ja     801da6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d82:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d87:	7f 33                	jg     801dbc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	50                   	push   %eax
  801d8d:	68 00 50 80 00       	push   $0x805000
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	e8 d3 ee ff ff       	call   800c6d <memmove>
	return r;
  801d9a:	83 c4 10             	add    $0x10,%esp
}
  801d9d:	89 d8                	mov    %ebx,%eax
  801d9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da2:	5b                   	pop    %ebx
  801da3:	5e                   	pop    %esi
  801da4:	5d                   	pop    %ebp
  801da5:	c3                   	ret    
	assert(r <= n);
  801da6:	68 19 2d 80 00       	push   $0x802d19
  801dab:	68 20 2d 80 00       	push   $0x802d20
  801db0:	6a 7c                	push   $0x7c
  801db2:	68 0e 2d 80 00       	push   $0x802d0e
  801db7:	e8 ce e4 ff ff       	call   80028a <_panic>
	assert(r <= PGSIZE);
  801dbc:	68 35 2d 80 00       	push   $0x802d35
  801dc1:	68 20 2d 80 00       	push   $0x802d20
  801dc6:	6a 7d                	push   $0x7d
  801dc8:	68 0e 2d 80 00       	push   $0x802d0e
  801dcd:	e8 b8 e4 ff ff       	call   80028a <_panic>

00801dd2 <open>:
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	56                   	push   %esi
  801dd6:	53                   	push   %ebx
  801dd7:	83 ec 1c             	sub    $0x1c,%esp
  801dda:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ddd:	56                   	push   %esi
  801dde:	e8 c3 ec ff ff       	call   800aa6 <strlen>
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801deb:	7f 6c                	jg     801e59 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ded:	83 ec 0c             	sub    $0xc,%esp
  801df0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df3:	50                   	push   %eax
  801df4:	e8 e5 f8 ff ff       	call   8016de <fd_alloc>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 3c                	js     801e3e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e02:	83 ec 08             	sub    $0x8,%esp
  801e05:	56                   	push   %esi
  801e06:	68 00 50 80 00       	push   $0x805000
  801e0b:	e8 cf ec ff ff       	call   800adf <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e20:	e8 1f fe ff ff       	call   801c44 <fsipc>
  801e25:	89 c3                	mov    %eax,%ebx
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	78 19                	js     801e47 <open+0x75>
	return fd2num(fd);
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	ff 75 f4             	pushl  -0xc(%ebp)
  801e34:	e8 7e f8 ff ff       	call   8016b7 <fd2num>
  801e39:	89 c3                	mov    %eax,%ebx
  801e3b:	83 c4 10             	add    $0x10,%esp
}
  801e3e:	89 d8                	mov    %ebx,%eax
  801e40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5d                   	pop    %ebp
  801e46:	c3                   	ret    
		fd_close(fd, 0);
  801e47:	83 ec 08             	sub    $0x8,%esp
  801e4a:	6a 00                	push   $0x0
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	e8 82 f9 ff ff       	call   8017d6 <fd_close>
		return r;
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	eb e5                	jmp    801e3e <open+0x6c>
		return -E_BAD_PATH;
  801e59:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e5e:	eb de                	jmp    801e3e <open+0x6c>

00801e60 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e66:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6b:	b8 08 00 00 00       	mov    $0x8,%eax
  801e70:	e8 cf fd ff ff       	call   801c44 <fsipc>
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e7d:	89 d0                	mov    %edx,%eax
  801e7f:	c1 e8 16             	shr    $0x16,%eax
  801e82:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e8e:	f6 c1 01             	test   $0x1,%cl
  801e91:	74 1d                	je     801eb0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e93:	c1 ea 0c             	shr    $0xc,%edx
  801e96:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e9d:	f6 c2 01             	test   $0x1,%dl
  801ea0:	74 0e                	je     801eb0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ea2:	c1 ea 0c             	shr    $0xc,%edx
  801ea5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801eac:	ef 
  801ead:	0f b7 c0             	movzwl %ax,%eax
}
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    

00801eb2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	56                   	push   %esi
  801eb6:	53                   	push   %ebx
  801eb7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eba:	83 ec 0c             	sub    $0xc,%esp
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	e8 02 f8 ff ff       	call   8016c7 <fd2data>
  801ec5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ec7:	83 c4 08             	add    $0x8,%esp
  801eca:	68 41 2d 80 00       	push   $0x802d41
  801ecf:	53                   	push   %ebx
  801ed0:	e8 0a ec ff ff       	call   800adf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ed5:	8b 46 04             	mov    0x4(%esi),%eax
  801ed8:	2b 06                	sub    (%esi),%eax
  801eda:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ee0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ee7:	00 00 00 
	stat->st_dev = &devpipe;
  801eea:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ef1:	30 80 00 
	return 0;
}
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    

00801f00 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	53                   	push   %ebx
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f0a:	53                   	push   %ebx
  801f0b:	6a 00                	push   $0x0
  801f0d:	e8 44 f0 ff ff       	call   800f56 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f12:	89 1c 24             	mov    %ebx,(%esp)
  801f15:	e8 ad f7 ff ff       	call   8016c7 <fd2data>
  801f1a:	83 c4 08             	add    $0x8,%esp
  801f1d:	50                   	push   %eax
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 31 f0 ff ff       	call   800f56 <sys_page_unmap>
}
  801f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <_pipeisclosed>:
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	57                   	push   %edi
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	83 ec 1c             	sub    $0x1c,%esp
  801f33:	89 c7                	mov    %eax,%edi
  801f35:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f37:	a1 04 40 80 00       	mov    0x804004,%eax
  801f3c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	57                   	push   %edi
  801f43:	e8 2f ff ff ff       	call   801e77 <pageref>
  801f48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f4b:	89 34 24             	mov    %esi,(%esp)
  801f4e:	e8 24 ff ff ff       	call   801e77 <pageref>
		nn = thisenv->env_runs;
  801f53:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f59:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	39 cb                	cmp    %ecx,%ebx
  801f61:	74 1b                	je     801f7e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f63:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f66:	75 cf                	jne    801f37 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f68:	8b 42 58             	mov    0x58(%edx),%eax
  801f6b:	6a 01                	push   $0x1
  801f6d:	50                   	push   %eax
  801f6e:	53                   	push   %ebx
  801f6f:	68 48 2d 80 00       	push   $0x802d48
  801f74:	e8 07 e4 ff ff       	call   800380 <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	eb b9                	jmp    801f37 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f81:	0f 94 c0             	sete   %al
  801f84:	0f b6 c0             	movzbl %al,%eax
}
  801f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8a:	5b                   	pop    %ebx
  801f8b:	5e                   	pop    %esi
  801f8c:	5f                   	pop    %edi
  801f8d:	5d                   	pop    %ebp
  801f8e:	c3                   	ret    

00801f8f <devpipe_write>:
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	57                   	push   %edi
  801f93:	56                   	push   %esi
  801f94:	53                   	push   %ebx
  801f95:	83 ec 28             	sub    $0x28,%esp
  801f98:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f9b:	56                   	push   %esi
  801f9c:	e8 26 f7 ff ff       	call   8016c7 <fd2data>
  801fa1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	bf 00 00 00 00       	mov    $0x0,%edi
  801fab:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fae:	74 4f                	je     801fff <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fb0:	8b 43 04             	mov    0x4(%ebx),%eax
  801fb3:	8b 0b                	mov    (%ebx),%ecx
  801fb5:	8d 51 20             	lea    0x20(%ecx),%edx
  801fb8:	39 d0                	cmp    %edx,%eax
  801fba:	72 14                	jb     801fd0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801fbc:	89 da                	mov    %ebx,%edx
  801fbe:	89 f0                	mov    %esi,%eax
  801fc0:	e8 65 ff ff ff       	call   801f2a <_pipeisclosed>
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	75 3b                	jne    802004 <devpipe_write+0x75>
			sys_yield();
  801fc9:	e8 e4 ee ff ff       	call   800eb2 <sys_yield>
  801fce:	eb e0                	jmp    801fb0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fd3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fd7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fda:	89 c2                	mov    %eax,%edx
  801fdc:	c1 fa 1f             	sar    $0x1f,%edx
  801fdf:	89 d1                	mov    %edx,%ecx
  801fe1:	c1 e9 1b             	shr    $0x1b,%ecx
  801fe4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fe7:	83 e2 1f             	and    $0x1f,%edx
  801fea:	29 ca                	sub    %ecx,%edx
  801fec:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ff0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ff4:	83 c0 01             	add    $0x1,%eax
  801ff7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ffa:	83 c7 01             	add    $0x1,%edi
  801ffd:	eb ac                	jmp    801fab <devpipe_write+0x1c>
	return i;
  801fff:	8b 45 10             	mov    0x10(%ebp),%eax
  802002:	eb 05                	jmp    802009 <devpipe_write+0x7a>
				return 0;
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802009:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5f                   	pop    %edi
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <devpipe_read>:
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	57                   	push   %edi
  802015:	56                   	push   %esi
  802016:	53                   	push   %ebx
  802017:	83 ec 18             	sub    $0x18,%esp
  80201a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80201d:	57                   	push   %edi
  80201e:	e8 a4 f6 ff ff       	call   8016c7 <fd2data>
  802023:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	be 00 00 00 00       	mov    $0x0,%esi
  80202d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802030:	75 14                	jne    802046 <devpipe_read+0x35>
	return i;
  802032:	8b 45 10             	mov    0x10(%ebp),%eax
  802035:	eb 02                	jmp    802039 <devpipe_read+0x28>
				return i;
  802037:	89 f0                	mov    %esi,%eax
}
  802039:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203c:	5b                   	pop    %ebx
  80203d:	5e                   	pop    %esi
  80203e:	5f                   	pop    %edi
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    
			sys_yield();
  802041:	e8 6c ee ff ff       	call   800eb2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802046:	8b 03                	mov    (%ebx),%eax
  802048:	3b 43 04             	cmp    0x4(%ebx),%eax
  80204b:	75 18                	jne    802065 <devpipe_read+0x54>
			if (i > 0)
  80204d:	85 f6                	test   %esi,%esi
  80204f:	75 e6                	jne    802037 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802051:	89 da                	mov    %ebx,%edx
  802053:	89 f8                	mov    %edi,%eax
  802055:	e8 d0 fe ff ff       	call   801f2a <_pipeisclosed>
  80205a:	85 c0                	test   %eax,%eax
  80205c:	74 e3                	je     802041 <devpipe_read+0x30>
				return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	eb d4                	jmp    802039 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802065:	99                   	cltd   
  802066:	c1 ea 1b             	shr    $0x1b,%edx
  802069:	01 d0                	add    %edx,%eax
  80206b:	83 e0 1f             	and    $0x1f,%eax
  80206e:	29 d0                	sub    %edx,%eax
  802070:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802078:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80207b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80207e:	83 c6 01             	add    $0x1,%esi
  802081:	eb aa                	jmp    80202d <devpipe_read+0x1c>

00802083 <pipe>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	56                   	push   %esi
  802087:	53                   	push   %ebx
  802088:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80208b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208e:	50                   	push   %eax
  80208f:	e8 4a f6 ff ff       	call   8016de <fd_alloc>
  802094:	89 c3                	mov    %eax,%ebx
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	85 c0                	test   %eax,%eax
  80209b:	0f 88 23 01 00 00    	js     8021c4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	68 07 04 00 00       	push   $0x407
  8020a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ac:	6a 00                	push   $0x0
  8020ae:	e8 1e ee ff ff       	call   800ed1 <sys_page_alloc>
  8020b3:	89 c3                	mov    %eax,%ebx
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 04 01 00 00    	js     8021c4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c6:	50                   	push   %eax
  8020c7:	e8 12 f6 ff ff       	call   8016de <fd_alloc>
  8020cc:	89 c3                	mov    %eax,%ebx
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	0f 88 db 00 00 00    	js     8021b4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	68 07 04 00 00       	push   $0x407
  8020e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e4:	6a 00                	push   $0x0
  8020e6:	e8 e6 ed ff ff       	call   800ed1 <sys_page_alloc>
  8020eb:	89 c3                	mov    %eax,%ebx
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	0f 88 bc 00 00 00    	js     8021b4 <pipe+0x131>
	va = fd2data(fd0);
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fe:	e8 c4 f5 ff ff       	call   8016c7 <fd2data>
  802103:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802105:	83 c4 0c             	add    $0xc,%esp
  802108:	68 07 04 00 00       	push   $0x407
  80210d:	50                   	push   %eax
  80210e:	6a 00                	push   $0x0
  802110:	e8 bc ed ff ff       	call   800ed1 <sys_page_alloc>
  802115:	89 c3                	mov    %eax,%ebx
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	85 c0                	test   %eax,%eax
  80211c:	0f 88 82 00 00 00    	js     8021a4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	ff 75 f0             	pushl  -0x10(%ebp)
  802128:	e8 9a f5 ff ff       	call   8016c7 <fd2data>
  80212d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802134:	50                   	push   %eax
  802135:	6a 00                	push   $0x0
  802137:	56                   	push   %esi
  802138:	6a 00                	push   $0x0
  80213a:	e8 d5 ed ff ff       	call   800f14 <sys_page_map>
  80213f:	89 c3                	mov    %eax,%ebx
  802141:	83 c4 20             	add    $0x20,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	78 4e                	js     802196 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802148:	a1 20 30 80 00       	mov    0x803020,%eax
  80214d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802150:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802155:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80215c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80215f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80216b:	83 ec 0c             	sub    $0xc,%esp
  80216e:	ff 75 f4             	pushl  -0xc(%ebp)
  802171:	e8 41 f5 ff ff       	call   8016b7 <fd2num>
  802176:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802179:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80217b:	83 c4 04             	add    $0x4,%esp
  80217e:	ff 75 f0             	pushl  -0x10(%ebp)
  802181:	e8 31 f5 ff ff       	call   8016b7 <fd2num>
  802186:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802189:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80218c:	83 c4 10             	add    $0x10,%esp
  80218f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802194:	eb 2e                	jmp    8021c4 <pipe+0x141>
	sys_page_unmap(0, va);
  802196:	83 ec 08             	sub    $0x8,%esp
  802199:	56                   	push   %esi
  80219a:	6a 00                	push   $0x0
  80219c:	e8 b5 ed ff ff       	call   800f56 <sys_page_unmap>
  8021a1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021a4:	83 ec 08             	sub    $0x8,%esp
  8021a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8021aa:	6a 00                	push   $0x0
  8021ac:	e8 a5 ed ff ff       	call   800f56 <sys_page_unmap>
  8021b1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021b4:	83 ec 08             	sub    $0x8,%esp
  8021b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ba:	6a 00                	push   $0x0
  8021bc:	e8 95 ed ff ff       	call   800f56 <sys_page_unmap>
  8021c1:	83 c4 10             	add    $0x10,%esp
}
  8021c4:	89 d8                	mov    %ebx,%eax
  8021c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c9:	5b                   	pop    %ebx
  8021ca:	5e                   	pop    %esi
  8021cb:	5d                   	pop    %ebp
  8021cc:	c3                   	ret    

008021cd <pipeisclosed>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d6:	50                   	push   %eax
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	e8 51 f5 ff ff       	call   801730 <fd_lookup>
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	78 18                	js     8021fe <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ec:	e8 d6 f4 ff ff       	call   8016c7 <fd2data>
	return _pipeisclosed(fd, p);
  8021f1:	89 c2                	mov    %eax,%edx
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	e8 2f fd ff ff       	call   801f2a <_pipeisclosed>
  8021fb:	83 c4 10             	add    $0x10,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	c3                   	ret    

00802206 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80220c:	68 60 2d 80 00       	push   $0x802d60
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	e8 c6 e8 ff ff       	call   800adf <strcpy>
	return 0;
}
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <devcons_write>:
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	57                   	push   %edi
  802224:	56                   	push   %esi
  802225:	53                   	push   %ebx
  802226:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80222c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802231:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802237:	3b 75 10             	cmp    0x10(%ebp),%esi
  80223a:	73 31                	jae    80226d <devcons_write+0x4d>
		m = n - tot;
  80223c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80223f:	29 f3                	sub    %esi,%ebx
  802241:	83 fb 7f             	cmp    $0x7f,%ebx
  802244:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802249:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	53                   	push   %ebx
  802250:	89 f0                	mov    %esi,%eax
  802252:	03 45 0c             	add    0xc(%ebp),%eax
  802255:	50                   	push   %eax
  802256:	57                   	push   %edi
  802257:	e8 11 ea ff ff       	call   800c6d <memmove>
		sys_cputs(buf, m);
  80225c:	83 c4 08             	add    $0x8,%esp
  80225f:	53                   	push   %ebx
  802260:	57                   	push   %edi
  802261:	e8 af eb ff ff       	call   800e15 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802266:	01 de                	add    %ebx,%esi
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	eb ca                	jmp    802237 <devcons_write+0x17>
}
  80226d:	89 f0                	mov    %esi,%eax
  80226f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802272:	5b                   	pop    %ebx
  802273:	5e                   	pop    %esi
  802274:	5f                   	pop    %edi
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    

00802277 <devcons_read>:
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 08             	sub    $0x8,%esp
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802286:	74 21                	je     8022a9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802288:	e8 a6 eb ff ff       	call   800e33 <sys_cgetc>
  80228d:	85 c0                	test   %eax,%eax
  80228f:	75 07                	jne    802298 <devcons_read+0x21>
		sys_yield();
  802291:	e8 1c ec ff ff       	call   800eb2 <sys_yield>
  802296:	eb f0                	jmp    802288 <devcons_read+0x11>
	if (c < 0)
  802298:	78 0f                	js     8022a9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80229a:	83 f8 04             	cmp    $0x4,%eax
  80229d:	74 0c                	je     8022ab <devcons_read+0x34>
	*(char*)vbuf = c;
  80229f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a2:	88 02                	mov    %al,(%edx)
	return 1;
  8022a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    
		return 0;
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b0:	eb f7                	jmp    8022a9 <devcons_read+0x32>

008022b2 <cputchar>:
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022be:	6a 01                	push   $0x1
  8022c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022c3:	50                   	push   %eax
  8022c4:	e8 4c eb ff ff       	call   800e15 <sys_cputs>
}
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <getchar>:
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022d4:	6a 01                	push   $0x1
  8022d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022d9:	50                   	push   %eax
  8022da:	6a 00                	push   $0x0
  8022dc:	e8 ba f6 ff ff       	call   80199b <read>
	if (r < 0)
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	78 06                	js     8022ee <getchar+0x20>
	if (r < 1)
  8022e8:	74 06                	je     8022f0 <getchar+0x22>
	return c;
  8022ea:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    
		return -E_EOF;
  8022f0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022f5:	eb f7                	jmp    8022ee <getchar+0x20>

008022f7 <iscons>:
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802300:	50                   	push   %eax
  802301:	ff 75 08             	pushl  0x8(%ebp)
  802304:	e8 27 f4 ff ff       	call   801730 <fd_lookup>
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	85 c0                	test   %eax,%eax
  80230e:	78 11                	js     802321 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802319:	39 10                	cmp    %edx,(%eax)
  80231b:	0f 94 c0             	sete   %al
  80231e:	0f b6 c0             	movzbl %al,%eax
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <opencons>:
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802329:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232c:	50                   	push   %eax
  80232d:	e8 ac f3 ff ff       	call   8016de <fd_alloc>
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	85 c0                	test   %eax,%eax
  802337:	78 3a                	js     802373 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 07 04 00 00       	push   $0x407
  802341:	ff 75 f4             	pushl  -0xc(%ebp)
  802344:	6a 00                	push   $0x0
  802346:	e8 86 eb ff ff       	call   800ed1 <sys_page_alloc>
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 21                	js     802373 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80235b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802367:	83 ec 0c             	sub    $0xc,%esp
  80236a:	50                   	push   %eax
  80236b:	e8 47 f3 ff ff       	call   8016b7 <fd2num>
  802370:	83 c4 10             	add    $0x10,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80237b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802382:	74 0a                	je     80238e <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	6a 07                	push   $0x7
  802393:	68 00 f0 bf ee       	push   $0xeebff000
  802398:	6a 00                	push   $0x0
  80239a:	e8 32 eb ff ff       	call   800ed1 <sys_page_alloc>
		if(r < 0)
  80239f:	83 c4 10             	add    $0x10,%esp
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 2a                	js     8023d0 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8023a6:	83 ec 08             	sub    $0x8,%esp
  8023a9:	68 e4 23 80 00       	push   $0x8023e4
  8023ae:	6a 00                	push   $0x0
  8023b0:	e8 67 ec ff ff       	call   80101c <sys_env_set_pgfault_upcall>
		if(r < 0)
  8023b5:	83 c4 10             	add    $0x10,%esp
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	79 c8                	jns    802384 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	68 9c 2d 80 00       	push   $0x802d9c
  8023c4:	6a 25                	push   $0x25
  8023c6:	68 d8 2d 80 00       	push   $0x802dd8
  8023cb:	e8 ba de ff ff       	call   80028a <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	68 6c 2d 80 00       	push   $0x802d6c
  8023d8:	6a 22                	push   $0x22
  8023da:	68 d8 2d 80 00       	push   $0x802dd8
  8023df:	e8 a6 de ff ff       	call   80028a <_panic>

008023e4 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023e4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023e5:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023ea:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023ec:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8023ef:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8023f3:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8023f7:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8023fa:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8023fc:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802400:	83 c4 08             	add    $0x8,%esp
	popal
  802403:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802404:	83 c4 04             	add    $0x4,%esp
	popfl
  802407:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802408:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802409:	c3                   	ret    
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__udivdi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80241b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80241f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802423:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802427:	85 d2                	test   %edx,%edx
  802429:	75 4d                	jne    802478 <__udivdi3+0x68>
  80242b:	39 f3                	cmp    %esi,%ebx
  80242d:	76 19                	jbe    802448 <__udivdi3+0x38>
  80242f:	31 ff                	xor    %edi,%edi
  802431:	89 e8                	mov    %ebp,%eax
  802433:	89 f2                	mov    %esi,%edx
  802435:	f7 f3                	div    %ebx
  802437:	89 fa                	mov    %edi,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 d9                	mov    %ebx,%ecx
  80244a:	85 db                	test   %ebx,%ebx
  80244c:	75 0b                	jne    802459 <__udivdi3+0x49>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f3                	div    %ebx
  802457:	89 c1                	mov    %eax,%ecx
  802459:	31 d2                	xor    %edx,%edx
  80245b:	89 f0                	mov    %esi,%eax
  80245d:	f7 f1                	div    %ecx
  80245f:	89 c6                	mov    %eax,%esi
  802461:	89 e8                	mov    %ebp,%eax
  802463:	89 f7                	mov    %esi,%edi
  802465:	f7 f1                	div    %ecx
  802467:	89 fa                	mov    %edi,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	39 f2                	cmp    %esi,%edx
  80247a:	77 1c                	ja     802498 <__udivdi3+0x88>
  80247c:	0f bd fa             	bsr    %edx,%edi
  80247f:	83 f7 1f             	xor    $0x1f,%edi
  802482:	75 2c                	jne    8024b0 <__udivdi3+0xa0>
  802484:	39 f2                	cmp    %esi,%edx
  802486:	72 06                	jb     80248e <__udivdi3+0x7e>
  802488:	31 c0                	xor    %eax,%eax
  80248a:	39 eb                	cmp    %ebp,%ebx
  80248c:	77 a9                	ja     802437 <__udivdi3+0x27>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	eb a2                	jmp    802437 <__udivdi3+0x27>
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	31 ff                	xor    %edi,%edi
  80249a:	31 c0                	xor    %eax,%eax
  80249c:	89 fa                	mov    %edi,%edx
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	89 f9                	mov    %edi,%ecx
  8024b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024b7:	29 f8                	sub    %edi,%eax
  8024b9:	d3 e2                	shl    %cl,%edx
  8024bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024bf:	89 c1                	mov    %eax,%ecx
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	d3 ea                	shr    %cl,%edx
  8024c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c9:	09 d1                	or     %edx,%ecx
  8024cb:	89 f2                	mov    %esi,%edx
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 f9                	mov    %edi,%ecx
  8024d3:	d3 e3                	shl    %cl,%ebx
  8024d5:	89 c1                	mov    %eax,%ecx
  8024d7:	d3 ea                	shr    %cl,%edx
  8024d9:	89 f9                	mov    %edi,%ecx
  8024db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024df:	89 eb                	mov    %ebp,%ebx
  8024e1:	d3 e6                	shl    %cl,%esi
  8024e3:	89 c1                	mov    %eax,%ecx
  8024e5:	d3 eb                	shr    %cl,%ebx
  8024e7:	09 de                	or     %ebx,%esi
  8024e9:	89 f0                	mov    %esi,%eax
  8024eb:	f7 74 24 08          	divl   0x8(%esp)
  8024ef:	89 d6                	mov    %edx,%esi
  8024f1:	89 c3                	mov    %eax,%ebx
  8024f3:	f7 64 24 0c          	mull   0xc(%esp)
  8024f7:	39 d6                	cmp    %edx,%esi
  8024f9:	72 15                	jb     802510 <__udivdi3+0x100>
  8024fb:	89 f9                	mov    %edi,%ecx
  8024fd:	d3 e5                	shl    %cl,%ebp
  8024ff:	39 c5                	cmp    %eax,%ebp
  802501:	73 04                	jae    802507 <__udivdi3+0xf7>
  802503:	39 d6                	cmp    %edx,%esi
  802505:	74 09                	je     802510 <__udivdi3+0x100>
  802507:	89 d8                	mov    %ebx,%eax
  802509:	31 ff                	xor    %edi,%edi
  80250b:	e9 27 ff ff ff       	jmp    802437 <__udivdi3+0x27>
  802510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802513:	31 ff                	xor    %edi,%edi
  802515:	e9 1d ff ff ff       	jmp    802437 <__udivdi3+0x27>
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__umoddi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80252b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80252f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802537:	89 da                	mov    %ebx,%edx
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 43                	jne    802580 <__umoddi3+0x60>
  80253d:	39 df                	cmp    %ebx,%edi
  80253f:	76 17                	jbe    802558 <__umoddi3+0x38>
  802541:	89 f0                	mov    %esi,%eax
  802543:	f7 f7                	div    %edi
  802545:	89 d0                	mov    %edx,%eax
  802547:	31 d2                	xor    %edx,%edx
  802549:	83 c4 1c             	add    $0x1c,%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5f                   	pop    %edi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 fd                	mov    %edi,%ebp
  80255a:	85 ff                	test   %edi,%edi
  80255c:	75 0b                	jne    802569 <__umoddi3+0x49>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f7                	div    %edi
  802567:	89 c5                	mov    %eax,%ebp
  802569:	89 d8                	mov    %ebx,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	f7 f5                	div    %ebp
  80256f:	89 f0                	mov    %esi,%eax
  802571:	f7 f5                	div    %ebp
  802573:	89 d0                	mov    %edx,%eax
  802575:	eb d0                	jmp    802547 <__umoddi3+0x27>
  802577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257e:	66 90                	xchg   %ax,%ax
  802580:	89 f1                	mov    %esi,%ecx
  802582:	39 d8                	cmp    %ebx,%eax
  802584:	76 0a                	jbe    802590 <__umoddi3+0x70>
  802586:	89 f0                	mov    %esi,%eax
  802588:	83 c4 1c             	add    $0x1c,%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5e                   	pop    %esi
  80258d:	5f                   	pop    %edi
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    
  802590:	0f bd e8             	bsr    %eax,%ebp
  802593:	83 f5 1f             	xor    $0x1f,%ebp
  802596:	75 20                	jne    8025b8 <__umoddi3+0x98>
  802598:	39 d8                	cmp    %ebx,%eax
  80259a:	0f 82 b0 00 00 00    	jb     802650 <__umoddi3+0x130>
  8025a0:	39 f7                	cmp    %esi,%edi
  8025a2:	0f 86 a8 00 00 00    	jbe    802650 <__umoddi3+0x130>
  8025a8:	89 c8                	mov    %ecx,%eax
  8025aa:	83 c4 1c             	add    $0x1c,%esp
  8025ad:	5b                   	pop    %ebx
  8025ae:	5e                   	pop    %esi
  8025af:	5f                   	pop    %edi
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    
  8025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8025bf:	29 ea                	sub    %ebp,%edx
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c7:	89 d1                	mov    %edx,%ecx
  8025c9:	89 f8                	mov    %edi,%eax
  8025cb:	d3 e8                	shr    %cl,%eax
  8025cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025d9:	09 c1                	or     %eax,%ecx
  8025db:	89 d8                	mov    %ebx,%eax
  8025dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e1:	89 e9                	mov    %ebp,%ecx
  8025e3:	d3 e7                	shl    %cl,%edi
  8025e5:	89 d1                	mov    %edx,%ecx
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	d3 e3                	shl    %cl,%ebx
  8025f1:	89 c7                	mov    %eax,%edi
  8025f3:	89 d1                	mov    %edx,%ecx
  8025f5:	89 f0                	mov    %esi,%eax
  8025f7:	d3 e8                	shr    %cl,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	89 fa                	mov    %edi,%edx
  8025fd:	d3 e6                	shl    %cl,%esi
  8025ff:	09 d8                	or     %ebx,%eax
  802601:	f7 74 24 08          	divl   0x8(%esp)
  802605:	89 d1                	mov    %edx,%ecx
  802607:	89 f3                	mov    %esi,%ebx
  802609:	f7 64 24 0c          	mull   0xc(%esp)
  80260d:	89 c6                	mov    %eax,%esi
  80260f:	89 d7                	mov    %edx,%edi
  802611:	39 d1                	cmp    %edx,%ecx
  802613:	72 06                	jb     80261b <__umoddi3+0xfb>
  802615:	75 10                	jne    802627 <__umoddi3+0x107>
  802617:	39 c3                	cmp    %eax,%ebx
  802619:	73 0c                	jae    802627 <__umoddi3+0x107>
  80261b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80261f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802623:	89 d7                	mov    %edx,%edi
  802625:	89 c6                	mov    %eax,%esi
  802627:	89 ca                	mov    %ecx,%edx
  802629:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80262e:	29 f3                	sub    %esi,%ebx
  802630:	19 fa                	sbb    %edi,%edx
  802632:	89 d0                	mov    %edx,%eax
  802634:	d3 e0                	shl    %cl,%eax
  802636:	89 e9                	mov    %ebp,%ecx
  802638:	d3 eb                	shr    %cl,%ebx
  80263a:	d3 ea                	shr    %cl,%edx
  80263c:	09 d8                	or     %ebx,%eax
  80263e:	83 c4 1c             	add    $0x1c,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80264d:	8d 76 00             	lea    0x0(%esi),%esi
  802650:	89 da                	mov    %ebx,%edx
  802652:	29 fe                	sub    %edi,%esi
  802654:	19 c2                	sbb    %eax,%edx
  802656:	89 f1                	mov    %esi,%ecx
  802658:	89 c8                	mov    %ecx,%eax
  80265a:	e9 4b ff ff ff       	jmp    8025aa <__umoddi3+0x8a>
