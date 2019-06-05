
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
  80003b:	68 20 2c 80 00       	push   $0x802c20
  800040:	e8 50 03 00 00       	call   800395 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 ed 25 00 00       	call   80263d <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 66                	js     8000bd <umain+0x8a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 b4 13 00 00       	call   801410 <fork>
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
  800068:	68 7a 2c 80 00       	push   $0x802c7a
  80006d:	e8 23 03 00 00       	call   800395 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800072:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800078:	83 c4 08             	add    $0x8,%esp
  80007b:	56                   	push   %esi
  80007c:	68 85 2c 80 00       	push   $0x802c85
  800081:	e8 0f 03 00 00       	call   800395 <cprintf>
	dup(p[0], 10);
  800086:	83 c4 08             	add    $0x8,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	ff 75 f0             	pushl  -0x10(%ebp)
  80008e:	e8 08 19 00 00       	call   80199b <dup>
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
  8000b3:	e8 e3 18 00 00       	call   80199b <dup>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb e2                	jmp    80009f <umain+0x6c>
		panic("pipe: %e", r);
  8000bd:	50                   	push   %eax
  8000be:	68 39 2c 80 00       	push   $0x802c39
  8000c3:	6a 0d                	push   $0xd
  8000c5:	68 42 2c 80 00       	push   $0x802c42
  8000ca:	e8 d0 01 00 00       	call   80029f <_panic>
		panic("fork: %e", r);
  8000cf:	50                   	push   %eax
  8000d0:	68 56 2c 80 00       	push   $0x802c56
  8000d5:	6a 10                	push   $0x10
  8000d7:	68 42 2c 80 00       	push   $0x802c42
  8000dc:	e8 be 01 00 00       	call   80029f <_panic>
		close(p[1]);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e7:	e8 5d 18 00 00       	call   801949 <close>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000f4:	eb 1f                	jmp    800115 <umain+0xe2>
				cprintf("RACE: pipe appears closed\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 5f 2c 80 00       	push   $0x802c5f
  8000fe:	e8 92 02 00 00       	call   800395 <cprintf>
				exit();
  800103:	e8 7d 01 00 00       	call   800285 <exit>
  800108:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  80010b:	e8 b7 0d 00 00       	call   800ec7 <sys_yield>
		for (i=0; i<max; i++) {
  800110:	83 eb 01             	sub    $0x1,%ebx
  800113:	74 14                	je     800129 <umain+0xf6>
			if(pipeisclosed(p[0])){
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	ff 75 f0             	pushl  -0x10(%ebp)
  80011b:	e8 67 26 00 00       	call   802787 <pipeisclosed>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	85 c0                	test   %eax,%eax
  800125:	74 e4                	je     80010b <umain+0xd8>
  800127:	eb cd                	jmp    8000f6 <umain+0xc3>
		ipc_recv(0,0,0);
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	6a 00                	push   $0x0
  80012e:	6a 00                	push   $0x0
  800130:	6a 00                	push   $0x0
  800132:	e8 6b 15 00 00       	call   8016a2 <ipc_recv>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	e9 25 ff ff ff       	jmp    800064 <umain+0x31>

	cprintf("child done with loop\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 90 2c 80 00       	push   $0x802c90
  800147:	e8 49 02 00 00       	call   800395 <cprintf>
	if (pipeisclosed(p[0]))
  80014c:	83 c4 04             	add    $0x4,%esp
  80014f:	ff 75 f0             	pushl  -0x10(%ebp)
  800152:	e8 30 26 00 00       	call   802787 <pipeisclosed>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	85 c0                	test   %eax,%eax
  80015c:	75 48                	jne    8001a6 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	ff 75 f0             	pushl  -0x10(%ebp)
  800168:	e8 aa 16 00 00       	call   801817 <fd_lookup>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	78 46                	js     8001ba <umain+0x187>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 ec             	pushl  -0x14(%ebp)
  80017a:	e8 2f 16 00 00       	call   8017ae <fd2data>
	if (pageref(va) != 3+1)
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 43 1e 00 00       	call   801fca <pageref>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	83 f8 04             	cmp    $0x4,%eax
  80018d:	74 3d                	je     8001cc <umain+0x199>
		cprintf("\nchild detected race\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 be 2c 80 00       	push   $0x802cbe
  800197:	e8 f9 01 00 00       	call   800395 <cprintf>
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
  8001a9:	68 ec 2c 80 00       	push   $0x802cec
  8001ae:	6a 3a                	push   $0x3a
  8001b0:	68 42 2c 80 00       	push   $0x802c42
  8001b5:	e8 e5 00 00 00       	call   80029f <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ba:	50                   	push   %eax
  8001bb:	68 a6 2c 80 00       	push   $0x802ca6
  8001c0:	6a 3c                	push   $0x3c
  8001c2:	68 42 2c 80 00       	push   $0x802c42
  8001c7:	e8 d3 00 00 00       	call   80029f <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	68 c8 00 00 00       	push   $0xc8
  8001d4:	68 d4 2c 80 00       	push   $0x802cd4
  8001d9:	e8 b7 01 00 00       	call   800395 <cprintf>
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
  8001ec:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001f3:	00 00 00 
	envid_t find = sys_getenvid();
  8001f6:	e8 ad 0c 00 00       	call   800ea8 <sys_getenvid>
  8001fb:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
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
  800244:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024e:	7e 0a                	jle    80025a <libmain+0x77>
		binaryname = argv[0];
  800250:	8b 45 0c             	mov    0xc(%ebp),%eax
  800253:	8b 00                	mov    (%eax),%eax
  800255:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	68 16 2d 80 00       	push   $0x802d16
  800262:	e8 2e 01 00 00       	call   800395 <cprintf>
	// call user main routine
	umain(argc, argv);
  800267:	83 c4 08             	add    $0x8,%esp
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 be fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800275:	e8 0b 00 00 00       	call   800285 <exit>
}
  80027a:	83 c4 10             	add    $0x10,%esp
  80027d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80028b:	e8 e6 16 00 00       	call   801976 <close_all>
	sys_env_destroy(0);
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 00                	push   $0x0
  800295:	e8 cd 0b 00 00       	call   800e67 <sys_env_destroy>
}
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	56                   	push   %esi
  8002a3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8002a9:	8b 40 48             	mov    0x48(%eax),%eax
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 6c 2d 80 00       	push   $0x802d6c
  8002b4:	50                   	push   %eax
  8002b5:	68 3a 2d 80 00       	push   $0x802d3a
  8002ba:	e8 d6 00 00 00       	call   800395 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002bf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c2:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002c8:	e8 db 0b 00 00       	call   800ea8 <sys_getenvid>
  8002cd:	83 c4 04             	add    $0x4,%esp
  8002d0:	ff 75 0c             	pushl  0xc(%ebp)
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	56                   	push   %esi
  8002d7:	50                   	push   %eax
  8002d8:	68 48 2d 80 00       	push   $0x802d48
  8002dd:	e8 b3 00 00 00       	call   800395 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e2:	83 c4 18             	add    $0x18,%esp
  8002e5:	53                   	push   %ebx
  8002e6:	ff 75 10             	pushl  0x10(%ebp)
  8002e9:	e8 56 00 00 00       	call   800344 <vcprintf>
	cprintf("\n");
  8002ee:	c7 04 24 2e 2d 80 00 	movl   $0x802d2e,(%esp)
  8002f5:	e8 9b 00 00 00       	call   800395 <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002fd:	cc                   	int3   
  8002fe:	eb fd                	jmp    8002fd <_panic+0x5e>

00800300 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	53                   	push   %ebx
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030a:	8b 13                	mov    (%ebx),%edx
  80030c:	8d 42 01             	lea    0x1(%edx),%eax
  80030f:	89 03                	mov    %eax,(%ebx)
  800311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800314:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800318:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031d:	74 09                	je     800328 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80031f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800326:	c9                   	leave  
  800327:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	68 ff 00 00 00       	push   $0xff
  800330:	8d 43 08             	lea    0x8(%ebx),%eax
  800333:	50                   	push   %eax
  800334:	e8 f1 0a 00 00       	call   800e2a <sys_cputs>
		b->idx = 0;
  800339:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	eb db                	jmp    80031f <putch+0x1f>

00800344 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80034d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800354:	00 00 00 
	b.cnt = 0;
  800357:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80035e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800361:	ff 75 0c             	pushl  0xc(%ebp)
  800364:	ff 75 08             	pushl  0x8(%ebp)
  800367:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036d:	50                   	push   %eax
  80036e:	68 00 03 80 00       	push   $0x800300
  800373:	e8 4a 01 00 00       	call   8004c2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800378:	83 c4 08             	add    $0x8,%esp
  80037b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800381:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	e8 9d 0a 00 00       	call   800e2a <sys_cputs>

	return b.cnt;
}
  80038d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80039e:	50                   	push   %eax
  80039f:	ff 75 08             	pushl  0x8(%ebp)
  8003a2:	e8 9d ff ff ff       	call   800344 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 1c             	sub    $0x1c,%esp
  8003b2:	89 c6                	mov    %eax,%esi
  8003b4:	89 d7                	mov    %edx,%edi
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003c8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003cc:	74 2c                	je     8003fa <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003db:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003de:	39 c2                	cmp    %eax,%edx
  8003e0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003e3:	73 43                	jae    800428 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003e5:	83 eb 01             	sub    $0x1,%ebx
  8003e8:	85 db                	test   %ebx,%ebx
  8003ea:	7e 6c                	jle    800458 <printnum+0xaf>
				putch(padc, putdat);
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	57                   	push   %edi
  8003f0:	ff 75 18             	pushl  0x18(%ebp)
  8003f3:	ff d6                	call   *%esi
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	eb eb                	jmp    8003e5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	6a 20                	push   $0x20
  8003ff:	6a 00                	push   $0x0
  800401:	50                   	push   %eax
  800402:	ff 75 e4             	pushl  -0x1c(%ebp)
  800405:	ff 75 e0             	pushl  -0x20(%ebp)
  800408:	89 fa                	mov    %edi,%edx
  80040a:	89 f0                	mov    %esi,%eax
  80040c:	e8 98 ff ff ff       	call   8003a9 <printnum>
		while (--width > 0)
  800411:	83 c4 20             	add    $0x20,%esp
  800414:	83 eb 01             	sub    $0x1,%ebx
  800417:	85 db                	test   %ebx,%ebx
  800419:	7e 65                	jle    800480 <printnum+0xd7>
			putch(padc, putdat);
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	57                   	push   %edi
  80041f:	6a 20                	push   $0x20
  800421:	ff d6                	call   *%esi
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	eb ec                	jmp    800414 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	ff 75 18             	pushl  0x18(%ebp)
  80042e:	83 eb 01             	sub    $0x1,%ebx
  800431:	53                   	push   %ebx
  800432:	50                   	push   %eax
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	ff 75 dc             	pushl  -0x24(%ebp)
  800439:	ff 75 d8             	pushl  -0x28(%ebp)
  80043c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043f:	ff 75 e0             	pushl  -0x20(%ebp)
  800442:	e8 89 25 00 00       	call   8029d0 <__udivdi3>
  800447:	83 c4 18             	add    $0x18,%esp
  80044a:	52                   	push   %edx
  80044b:	50                   	push   %eax
  80044c:	89 fa                	mov    %edi,%edx
  80044e:	89 f0                	mov    %esi,%eax
  800450:	e8 54 ff ff ff       	call   8003a9 <printnum>
  800455:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	57                   	push   %edi
  80045c:	83 ec 04             	sub    $0x4,%esp
  80045f:	ff 75 dc             	pushl  -0x24(%ebp)
  800462:	ff 75 d8             	pushl  -0x28(%ebp)
  800465:	ff 75 e4             	pushl  -0x1c(%ebp)
  800468:	ff 75 e0             	pushl  -0x20(%ebp)
  80046b:	e8 70 26 00 00       	call   802ae0 <__umoddi3>
  800470:	83 c4 14             	add    $0x14,%esp
  800473:	0f be 80 73 2d 80 00 	movsbl 0x802d73(%eax),%eax
  80047a:	50                   	push   %eax
  80047b:	ff d6                	call   *%esi
  80047d:	83 c4 10             	add    $0x10,%esp
	}
}
  800480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800483:	5b                   	pop    %ebx
  800484:	5e                   	pop    %esi
  800485:	5f                   	pop    %edi
  800486:	5d                   	pop    %ebp
  800487:	c3                   	ret    

00800488 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80048e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800492:	8b 10                	mov    (%eax),%edx
  800494:	3b 50 04             	cmp    0x4(%eax),%edx
  800497:	73 0a                	jae    8004a3 <sprintputch+0x1b>
		*b->buf++ = ch;
  800499:	8d 4a 01             	lea    0x1(%edx),%ecx
  80049c:	89 08                	mov    %ecx,(%eax)
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	88 02                	mov    %al,(%edx)
}
  8004a3:	5d                   	pop    %ebp
  8004a4:	c3                   	ret    

008004a5 <printfmt>:
{
  8004a5:	55                   	push   %ebp
  8004a6:	89 e5                	mov    %esp,%ebp
  8004a8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ab:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ae:	50                   	push   %eax
  8004af:	ff 75 10             	pushl  0x10(%ebp)
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	ff 75 08             	pushl  0x8(%ebp)
  8004b8:	e8 05 00 00 00       	call   8004c2 <vprintfmt>
}
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <vprintfmt>:
{
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	57                   	push   %edi
  8004c6:	56                   	push   %esi
  8004c7:	53                   	push   %ebx
  8004c8:	83 ec 3c             	sub    $0x3c,%esp
  8004cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004d4:	e9 32 04 00 00       	jmp    80090b <vprintfmt+0x449>
		padc = ' ';
  8004d9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004dd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004e4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800500:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800505:	8d 47 01             	lea    0x1(%edi),%eax
  800508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050b:	0f b6 17             	movzbl (%edi),%edx
  80050e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800511:	3c 55                	cmp    $0x55,%al
  800513:	0f 87 12 05 00 00    	ja     800a2b <vprintfmt+0x569>
  800519:	0f b6 c0             	movzbl %al,%eax
  80051c:	ff 24 85 60 2f 80 00 	jmp    *0x802f60(,%eax,4)
  800523:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800526:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80052a:	eb d9                	jmp    800505 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80052f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800533:	eb d0                	jmp    800505 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800535:	0f b6 d2             	movzbl %dl,%edx
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80053b:	b8 00 00 00 00       	mov    $0x0,%eax
  800540:	89 75 08             	mov    %esi,0x8(%ebp)
  800543:	eb 03                	jmp    800548 <vprintfmt+0x86>
  800545:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800548:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800552:	8d 72 d0             	lea    -0x30(%edx),%esi
  800555:	83 fe 09             	cmp    $0x9,%esi
  800558:	76 eb                	jbe    800545 <vprintfmt+0x83>
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	8b 75 08             	mov    0x8(%ebp),%esi
  800560:	eb 14                	jmp    800576 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8d 40 04             	lea    0x4(%eax),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800576:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057a:	79 89                	jns    800505 <vprintfmt+0x43>
				width = precision, precision = -1;
  80057c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80057f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800582:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800589:	e9 77 ff ff ff       	jmp    800505 <vprintfmt+0x43>
  80058e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800591:	85 c0                	test   %eax,%eax
  800593:	0f 48 c1             	cmovs  %ecx,%eax
  800596:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800599:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059c:	e9 64 ff ff ff       	jmp    800505 <vprintfmt+0x43>
  8005a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005ab:	e9 55 ff ff ff       	jmp    800505 <vprintfmt+0x43>
			lflag++;
  8005b0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005b7:	e9 49 ff ff ff       	jmp    800505 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 78 04             	lea    0x4(%eax),%edi
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	ff 30                	pushl  (%eax)
  8005c8:	ff d6                	call   *%esi
			break;
  8005ca:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005cd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d0:	e9 33 03 00 00       	jmp    800908 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 78 04             	lea    0x4(%eax),%edi
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	99                   	cltd   
  8005de:	31 d0                	xor    %edx,%eax
  8005e0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e2:	83 f8 10             	cmp    $0x10,%eax
  8005e5:	7f 23                	jg     80060a <vprintfmt+0x148>
  8005e7:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  8005ee:	85 d2                	test   %edx,%edx
  8005f0:	74 18                	je     80060a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005f2:	52                   	push   %edx
  8005f3:	68 e9 32 80 00       	push   $0x8032e9
  8005f8:	53                   	push   %ebx
  8005f9:	56                   	push   %esi
  8005fa:	e8 a6 fe ff ff       	call   8004a5 <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800602:	89 7d 14             	mov    %edi,0x14(%ebp)
  800605:	e9 fe 02 00 00       	jmp    800908 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80060a:	50                   	push   %eax
  80060b:	68 8b 2d 80 00       	push   $0x802d8b
  800610:	53                   	push   %ebx
  800611:	56                   	push   %esi
  800612:	e8 8e fe ff ff       	call   8004a5 <printfmt>
  800617:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80061a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80061d:	e9 e6 02 00 00       	jmp    800908 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	83 c0 04             	add    $0x4,%eax
  800628:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800630:	85 c9                	test   %ecx,%ecx
  800632:	b8 84 2d 80 00       	mov    $0x802d84,%eax
  800637:	0f 45 c1             	cmovne %ecx,%eax
  80063a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80063d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800641:	7e 06                	jle    800649 <vprintfmt+0x187>
  800643:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800647:	75 0d                	jne    800656 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800649:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80064c:	89 c7                	mov    %eax,%edi
  80064e:	03 45 e0             	add    -0x20(%ebp),%eax
  800651:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800654:	eb 53                	jmp    8006a9 <vprintfmt+0x1e7>
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	ff 75 d8             	pushl  -0x28(%ebp)
  80065c:	50                   	push   %eax
  80065d:	e8 71 04 00 00       	call   800ad3 <strnlen>
  800662:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800665:	29 c1                	sub    %eax,%ecx
  800667:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80066f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800676:	eb 0f                	jmp    800687 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	ff 75 e0             	pushl  -0x20(%ebp)
  80067f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	83 ef 01             	sub    $0x1,%edi
  800684:	83 c4 10             	add    $0x10,%esp
  800687:	85 ff                	test   %edi,%edi
  800689:	7f ed                	jg     800678 <vprintfmt+0x1b6>
  80068b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80068e:	85 c9                	test   %ecx,%ecx
  800690:	b8 00 00 00 00       	mov    $0x0,%eax
  800695:	0f 49 c1             	cmovns %ecx,%eax
  800698:	29 c1                	sub    %eax,%ecx
  80069a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80069d:	eb aa                	jmp    800649 <vprintfmt+0x187>
					putch(ch, putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	53                   	push   %ebx
  8006a3:	52                   	push   %edx
  8006a4:	ff d6                	call   *%esi
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ac:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ae:	83 c7 01             	add    $0x1,%edi
  8006b1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b5:	0f be d0             	movsbl %al,%edx
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	74 4b                	je     800707 <vprintfmt+0x245>
  8006bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c0:	78 06                	js     8006c8 <vprintfmt+0x206>
  8006c2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006c6:	78 1e                	js     8006e6 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006cc:	74 d1                	je     80069f <vprintfmt+0x1dd>
  8006ce:	0f be c0             	movsbl %al,%eax
  8006d1:	83 e8 20             	sub    $0x20,%eax
  8006d4:	83 f8 5e             	cmp    $0x5e,%eax
  8006d7:	76 c6                	jbe    80069f <vprintfmt+0x1dd>
					putch('?', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 3f                	push   $0x3f
  8006df:	ff d6                	call   *%esi
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	eb c3                	jmp    8006a9 <vprintfmt+0x1e7>
  8006e6:	89 cf                	mov    %ecx,%edi
  8006e8:	eb 0e                	jmp    8006f8 <vprintfmt+0x236>
				putch(' ', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 20                	push   $0x20
  8006f0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006f2:	83 ef 01             	sub    $0x1,%edi
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	85 ff                	test   %edi,%edi
  8006fa:	7f ee                	jg     8006ea <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800702:	e9 01 02 00 00       	jmp    800908 <vprintfmt+0x446>
  800707:	89 cf                	mov    %ecx,%edi
  800709:	eb ed                	jmp    8006f8 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80070b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80070e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800715:	e9 eb fd ff ff       	jmp    800505 <vprintfmt+0x43>
	if (lflag >= 2)
  80071a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80071e:	7f 21                	jg     800741 <vprintfmt+0x27f>
	else if (lflag)
  800720:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800724:	74 68                	je     80078e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80072e:	89 c1                	mov    %eax,%ecx
  800730:	c1 f9 1f             	sar    $0x1f,%ecx
  800733:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8d 40 04             	lea    0x4(%eax),%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
  80073f:	eb 17                	jmp    800758 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 50 04             	mov    0x4(%eax),%edx
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80074c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 08             	lea    0x8(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800758:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80075b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800764:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800768:	78 3f                	js     8007a9 <vprintfmt+0x2e7>
			base = 10;
  80076a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80076f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800773:	0f 84 71 01 00 00    	je     8008ea <vprintfmt+0x428>
				putch('+', putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 2b                	push   $0x2b
  80077f:	ff d6                	call   *%esi
  800781:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800784:	b8 0a 00 00 00       	mov    $0xa,%eax
  800789:	e9 5c 01 00 00       	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, int);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800796:	89 c1                	mov    %eax,%ecx
  800798:	c1 f9 1f             	sar    $0x1f,%ecx
  80079b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	eb af                	jmp    800758 <vprintfmt+0x296>
				putch('-', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	53                   	push   %ebx
  8007ad:	6a 2d                	push   $0x2d
  8007af:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b7:	f7 d8                	neg    %eax
  8007b9:	83 d2 00             	adc    $0x0,%edx
  8007bc:	f7 da                	neg    %edx
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cc:	e9 19 01 00 00       	jmp    8008ea <vprintfmt+0x428>
	if (lflag >= 2)
  8007d1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007d5:	7f 29                	jg     800800 <vprintfmt+0x33e>
	else if (lflag)
  8007d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007db:	74 44                	je     800821 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8d 40 04             	lea    0x4(%eax),%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fb:	e9 ea 00 00 00       	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 50 04             	mov    0x4(%eax),%edx
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8d 40 08             	lea    0x8(%eax),%eax
  800814:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800817:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081c:	e9 c9 00 00 00       	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	ba 00 00 00 00       	mov    $0x0,%edx
  80082b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8d 40 04             	lea    0x4(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083f:	e9 a6 00 00 00       	jmp    8008ea <vprintfmt+0x428>
			putch('0', putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	53                   	push   %ebx
  800848:	6a 30                	push   $0x30
  80084a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800853:	7f 26                	jg     80087b <vprintfmt+0x3b9>
	else if (lflag)
  800855:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800859:	74 3e                	je     800899 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	ba 00 00 00 00       	mov    $0x0,%edx
  800865:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800868:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800874:	b8 08 00 00 00       	mov    $0x8,%eax
  800879:	eb 6f                	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8b 50 04             	mov    0x4(%eax),%edx
  800881:	8b 00                	mov    (%eax),%eax
  800883:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800886:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 08             	lea    0x8(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800892:	b8 08 00 00 00       	mov    $0x8,%eax
  800897:	eb 51                	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8d 40 04             	lea    0x4(%eax),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b7:	eb 31                	jmp    8008ea <vprintfmt+0x428>
			putch('0', putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	6a 30                	push   $0x30
  8008bf:	ff d6                	call   *%esi
			putch('x', putdat);
  8008c1:	83 c4 08             	add    $0x8,%esp
  8008c4:	53                   	push   %ebx
  8008c5:	6a 78                	push   $0x78
  8008c7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008d9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 40 04             	lea    0x4(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008ea:	83 ec 0c             	sub    $0xc,%esp
  8008ed:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008f1:	52                   	push   %edx
  8008f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	ff 75 dc             	pushl  -0x24(%ebp)
  8008f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8008fc:	89 da                	mov    %ebx,%edx
  8008fe:	89 f0                	mov    %esi,%eax
  800900:	e8 a4 fa ff ff       	call   8003a9 <printnum>
			break;
  800905:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800908:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090b:	83 c7 01             	add    $0x1,%edi
  80090e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800912:	83 f8 25             	cmp    $0x25,%eax
  800915:	0f 84 be fb ff ff    	je     8004d9 <vprintfmt+0x17>
			if (ch == '\0')
  80091b:	85 c0                	test   %eax,%eax
  80091d:	0f 84 28 01 00 00    	je     800a4b <vprintfmt+0x589>
			putch(ch, putdat);
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	53                   	push   %ebx
  800927:	50                   	push   %eax
  800928:	ff d6                	call   *%esi
  80092a:	83 c4 10             	add    $0x10,%esp
  80092d:	eb dc                	jmp    80090b <vprintfmt+0x449>
	if (lflag >= 2)
  80092f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800933:	7f 26                	jg     80095b <vprintfmt+0x499>
	else if (lflag)
  800935:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800939:	74 41                	je     80097c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	ba 00 00 00 00       	mov    $0x0,%edx
  800945:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800948:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8d 40 04             	lea    0x4(%eax),%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800954:	b8 10 00 00 00       	mov    $0x10,%eax
  800959:	eb 8f                	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 50 04             	mov    0x4(%eax),%edx
  800961:	8b 00                	mov    (%eax),%eax
  800963:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800966:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8d 40 08             	lea    0x8(%eax),%eax
  80096f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800972:	b8 10 00 00 00       	mov    $0x10,%eax
  800977:	e9 6e ff ff ff       	jmp    8008ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	ba 00 00 00 00       	mov    $0x0,%edx
  800986:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800989:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8d 40 04             	lea    0x4(%eax),%eax
  800992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800995:	b8 10 00 00 00       	mov    $0x10,%eax
  80099a:	e9 4b ff ff ff       	jmp    8008ea <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 c0 04             	add    $0x4,%eax
  8009a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	85 c0                	test   %eax,%eax
  8009af:	74 14                	je     8009c5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009b1:	8b 13                	mov    (%ebx),%edx
  8009b3:	83 fa 7f             	cmp    $0x7f,%edx
  8009b6:	7f 37                	jg     8009ef <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009b8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	e9 43 ff ff ff       	jmp    800908 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ca:	bf a9 2e 80 00       	mov    $0x802ea9,%edi
							putch(ch, putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	53                   	push   %ebx
  8009d3:	50                   	push   %eax
  8009d4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009d6:	83 c7 01             	add    $0x1,%edi
  8009d9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	75 eb                	jne    8009cf <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ea:	e9 19 ff ff ff       	jmp    800908 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009ef:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f6:	bf e1 2e 80 00       	mov    $0x802ee1,%edi
							putch(ch, putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	53                   	push   %ebx
  8009ff:	50                   	push   %eax
  800a00:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a02:	83 c7 01             	add    $0x1,%edi
  800a05:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	85 c0                	test   %eax,%eax
  800a0e:	75 eb                	jne    8009fb <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a13:	89 45 14             	mov    %eax,0x14(%ebp)
  800a16:	e9 ed fe ff ff       	jmp    800908 <vprintfmt+0x446>
			putch(ch, putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	53                   	push   %ebx
  800a1f:	6a 25                	push   $0x25
  800a21:	ff d6                	call   *%esi
			break;
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	e9 dd fe ff ff       	jmp    800908 <vprintfmt+0x446>
			putch('%', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	53                   	push   %ebx
  800a2f:	6a 25                	push   $0x25
  800a31:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 f8                	mov    %edi,%eax
  800a38:	eb 03                	jmp    800a3d <vprintfmt+0x57b>
  800a3a:	83 e8 01             	sub    $0x1,%eax
  800a3d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a41:	75 f7                	jne    800a3a <vprintfmt+0x578>
  800a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a46:	e9 bd fe ff ff       	jmp    800908 <vprintfmt+0x446>
}
  800a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5f                   	pop    %edi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	83 ec 18             	sub    $0x18,%esp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a62:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a66:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a70:	85 c0                	test   %eax,%eax
  800a72:	74 26                	je     800a9a <vsnprintf+0x47>
  800a74:	85 d2                	test   %edx,%edx
  800a76:	7e 22                	jle    800a9a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a78:	ff 75 14             	pushl  0x14(%ebp)
  800a7b:	ff 75 10             	pushl  0x10(%ebp)
  800a7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a81:	50                   	push   %eax
  800a82:	68 88 04 80 00       	push   $0x800488
  800a87:	e8 36 fa ff ff       	call   8004c2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a95:	83 c4 10             	add    $0x10,%esp
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    
		return -E_INVAL;
  800a9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a9f:	eb f7                	jmp    800a98 <vsnprintf+0x45>

00800aa1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aaa:	50                   	push   %eax
  800aab:	ff 75 10             	pushl  0x10(%ebp)
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 9a ff ff ff       	call   800a53 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aca:	74 05                	je     800ad1 <strlen+0x16>
		n++;
  800acc:	83 c0 01             	add    $0x1,%eax
  800acf:	eb f5                	jmp    800ac6 <strlen+0xb>
	return n;
}
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae1:	39 c2                	cmp    %eax,%edx
  800ae3:	74 0d                	je     800af2 <strnlen+0x1f>
  800ae5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ae9:	74 05                	je     800af0 <strnlen+0x1d>
		n++;
  800aeb:	83 c2 01             	add    $0x1,%edx
  800aee:	eb f1                	jmp    800ae1 <strnlen+0xe>
  800af0:	89 d0                	mov    %edx,%eax
	return n;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	53                   	push   %ebx
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800afe:	ba 00 00 00 00       	mov    $0x0,%edx
  800b03:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b07:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b0a:	83 c2 01             	add    $0x1,%edx
  800b0d:	84 c9                	test   %cl,%cl
  800b0f:	75 f2                	jne    800b03 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b11:	5b                   	pop    %ebx
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	53                   	push   %ebx
  800b18:	83 ec 10             	sub    $0x10,%esp
  800b1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b1e:	53                   	push   %ebx
  800b1f:	e8 97 ff ff ff       	call   800abb <strlen>
  800b24:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	01 d8                	add    %ebx,%eax
  800b2c:	50                   	push   %eax
  800b2d:	e8 c2 ff ff ff       	call   800af4 <strcpy>
	return dst;
}
  800b32:	89 d8                	mov    %ebx,%eax
  800b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b44:	89 c6                	mov    %eax,%esi
  800b46:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	39 f2                	cmp    %esi,%edx
  800b4d:	74 11                	je     800b60 <strncpy+0x27>
		*dst++ = *src;
  800b4f:	83 c2 01             	add    $0x1,%edx
  800b52:	0f b6 19             	movzbl (%ecx),%ebx
  800b55:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b58:	80 fb 01             	cmp    $0x1,%bl
  800b5b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b5e:	eb eb                	jmp    800b4b <strncpy+0x12>
	}
	return ret;
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 75 08             	mov    0x8(%ebp),%esi
  800b6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6f:	8b 55 10             	mov    0x10(%ebp),%edx
  800b72:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b74:	85 d2                	test   %edx,%edx
  800b76:	74 21                	je     800b99 <strlcpy+0x35>
  800b78:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b7c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b7e:	39 c2                	cmp    %eax,%edx
  800b80:	74 14                	je     800b96 <strlcpy+0x32>
  800b82:	0f b6 19             	movzbl (%ecx),%ebx
  800b85:	84 db                	test   %bl,%bl
  800b87:	74 0b                	je     800b94 <strlcpy+0x30>
			*dst++ = *src++;
  800b89:	83 c1 01             	add    $0x1,%ecx
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b92:	eb ea                	jmp    800b7e <strlcpy+0x1a>
  800b94:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b96:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b99:	29 f0                	sub    %esi,%eax
}
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba8:	0f b6 01             	movzbl (%ecx),%eax
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0c                	je     800bbb <strcmp+0x1c>
  800baf:	3a 02                	cmp    (%edx),%al
  800bb1:	75 08                	jne    800bbb <strcmp+0x1c>
		p++, q++;
  800bb3:	83 c1 01             	add    $0x1,%ecx
  800bb6:	83 c2 01             	add    $0x1,%edx
  800bb9:	eb ed                	jmp    800ba8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbb:	0f b6 c0             	movzbl %al,%eax
  800bbe:	0f b6 12             	movzbl (%edx),%edx
  800bc1:	29 d0                	sub    %edx,%eax
}
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	53                   	push   %ebx
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcf:	89 c3                	mov    %eax,%ebx
  800bd1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd4:	eb 06                	jmp    800bdc <strncmp+0x17>
		n--, p++, q++;
  800bd6:	83 c0 01             	add    $0x1,%eax
  800bd9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bdc:	39 d8                	cmp    %ebx,%eax
  800bde:	74 16                	je     800bf6 <strncmp+0x31>
  800be0:	0f b6 08             	movzbl (%eax),%ecx
  800be3:	84 c9                	test   %cl,%cl
  800be5:	74 04                	je     800beb <strncmp+0x26>
  800be7:	3a 0a                	cmp    (%edx),%cl
  800be9:	74 eb                	je     800bd6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800beb:	0f b6 00             	movzbl (%eax),%eax
  800bee:	0f b6 12             	movzbl (%edx),%edx
  800bf1:	29 d0                	sub    %edx,%eax
}
  800bf3:	5b                   	pop    %ebx
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    
		return 0;
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	eb f6                	jmp    800bf3 <strncmp+0x2e>

00800bfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c07:	0f b6 10             	movzbl (%eax),%edx
  800c0a:	84 d2                	test   %dl,%dl
  800c0c:	74 09                	je     800c17 <strchr+0x1a>
		if (*s == c)
  800c0e:	38 ca                	cmp    %cl,%dl
  800c10:	74 0a                	je     800c1c <strchr+0x1f>
	for (; *s; s++)
  800c12:	83 c0 01             	add    $0x1,%eax
  800c15:	eb f0                	jmp    800c07 <strchr+0xa>
			return (char *) s;
	return 0;
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c28:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c2b:	38 ca                	cmp    %cl,%dl
  800c2d:	74 09                	je     800c38 <strfind+0x1a>
  800c2f:	84 d2                	test   %dl,%dl
  800c31:	74 05                	je     800c38 <strfind+0x1a>
	for (; *s; s++)
  800c33:	83 c0 01             	add    $0x1,%eax
  800c36:	eb f0                	jmp    800c28 <strfind+0xa>
			break;
	return (char *) s;
}
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
  800c40:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c46:	85 c9                	test   %ecx,%ecx
  800c48:	74 31                	je     800c7b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4a:	89 f8                	mov    %edi,%eax
  800c4c:	09 c8                	or     %ecx,%eax
  800c4e:	a8 03                	test   $0x3,%al
  800c50:	75 23                	jne    800c75 <memset+0x3b>
		c &= 0xFF;
  800c52:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	c1 e3 08             	shl    $0x8,%ebx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	c1 e0 18             	shl    $0x18,%eax
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	c1 e6 10             	shl    $0x10,%esi
  800c65:	09 f0                	or     %esi,%eax
  800c67:	09 c2                	or     %eax,%edx
  800c69:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c6e:	89 d0                	mov    %edx,%eax
  800c70:	fc                   	cld    
  800c71:	f3 ab                	rep stos %eax,%es:(%edi)
  800c73:	eb 06                	jmp    800c7b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	fc                   	cld    
  800c79:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7b:	89 f8                	mov    %edi,%eax
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c90:	39 c6                	cmp    %eax,%esi
  800c92:	73 32                	jae    800cc6 <memmove+0x44>
  800c94:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	76 2b                	jbe    800cc6 <memmove+0x44>
		s += n;
		d += n;
  800c9b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9e:	89 fe                	mov    %edi,%esi
  800ca0:	09 ce                	or     %ecx,%esi
  800ca2:	09 d6                	or     %edx,%esi
  800ca4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800caa:	75 0e                	jne    800cba <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cac:	83 ef 04             	sub    $0x4,%edi
  800caf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb5:	fd                   	std    
  800cb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb8:	eb 09                	jmp    800cc3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cba:	83 ef 01             	sub    $0x1,%edi
  800cbd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc0:	fd                   	std    
  800cc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc3:	fc                   	cld    
  800cc4:	eb 1a                	jmp    800ce0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	09 ca                	or     %ecx,%edx
  800cca:	09 f2                	or     %esi,%edx
  800ccc:	f6 c2 03             	test   $0x3,%dl
  800ccf:	75 0a                	jne    800cdb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	fc                   	cld    
  800cd7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cd9:	eb 05                	jmp    800ce0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cdb:	89 c7                	mov    %eax,%edi
  800cdd:	fc                   	cld    
  800cde:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cea:	ff 75 10             	pushl  0x10(%ebp)
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	ff 75 08             	pushl  0x8(%ebp)
  800cf3:	e8 8a ff ff ff       	call   800c82 <memmove>
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	89 c6                	mov    %eax,%esi
  800d07:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0a:	39 f0                	cmp    %esi,%eax
  800d0c:	74 1c                	je     800d2a <memcmp+0x30>
		if (*s1 != *s2)
  800d0e:	0f b6 08             	movzbl (%eax),%ecx
  800d11:	0f b6 1a             	movzbl (%edx),%ebx
  800d14:	38 d9                	cmp    %bl,%cl
  800d16:	75 08                	jne    800d20 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d18:	83 c0 01             	add    $0x1,%eax
  800d1b:	83 c2 01             	add    $0x1,%edx
  800d1e:	eb ea                	jmp    800d0a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d20:	0f b6 c1             	movzbl %cl,%eax
  800d23:	0f b6 db             	movzbl %bl,%ebx
  800d26:	29 d8                	sub    %ebx,%eax
  800d28:	eb 05                	jmp    800d2f <memcmp+0x35>
	}

	return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d3c:	89 c2                	mov    %eax,%edx
  800d3e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d41:	39 d0                	cmp    %edx,%eax
  800d43:	73 09                	jae    800d4e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d45:	38 08                	cmp    %cl,(%eax)
  800d47:	74 05                	je     800d4e <memfind+0x1b>
	for (; s < ends; s++)
  800d49:	83 c0 01             	add    $0x1,%eax
  800d4c:	eb f3                	jmp    800d41 <memfind+0xe>
			break;
	return (void *) s;
}
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5c:	eb 03                	jmp    800d61 <strtol+0x11>
		s++;
  800d5e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d61:	0f b6 01             	movzbl (%ecx),%eax
  800d64:	3c 20                	cmp    $0x20,%al
  800d66:	74 f6                	je     800d5e <strtol+0xe>
  800d68:	3c 09                	cmp    $0x9,%al
  800d6a:	74 f2                	je     800d5e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d6c:	3c 2b                	cmp    $0x2b,%al
  800d6e:	74 2a                	je     800d9a <strtol+0x4a>
	int neg = 0;
  800d70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d75:	3c 2d                	cmp    $0x2d,%al
  800d77:	74 2b                	je     800da4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d79:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d7f:	75 0f                	jne    800d90 <strtol+0x40>
  800d81:	80 39 30             	cmpb   $0x30,(%ecx)
  800d84:	74 28                	je     800dae <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d86:	85 db                	test   %ebx,%ebx
  800d88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d8d:	0f 44 d8             	cmove  %eax,%ebx
  800d90:	b8 00 00 00 00       	mov    $0x0,%eax
  800d95:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d98:	eb 50                	jmp    800dea <strtol+0x9a>
		s++;
  800d9a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  800da2:	eb d5                	jmp    800d79 <strtol+0x29>
		s++, neg = 1;
  800da4:	83 c1 01             	add    $0x1,%ecx
  800da7:	bf 01 00 00 00       	mov    $0x1,%edi
  800dac:	eb cb                	jmp    800d79 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dae:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800db2:	74 0e                	je     800dc2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800db4:	85 db                	test   %ebx,%ebx
  800db6:	75 d8                	jne    800d90 <strtol+0x40>
		s++, base = 8;
  800db8:	83 c1 01             	add    $0x1,%ecx
  800dbb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc0:	eb ce                	jmp    800d90 <strtol+0x40>
		s += 2, base = 16;
  800dc2:	83 c1 02             	add    $0x2,%ecx
  800dc5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dca:	eb c4                	jmp    800d90 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dcc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dcf:	89 f3                	mov    %esi,%ebx
  800dd1:	80 fb 19             	cmp    $0x19,%bl
  800dd4:	77 29                	ja     800dff <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dd6:	0f be d2             	movsbl %dl,%edx
  800dd9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ddc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ddf:	7d 30                	jge    800e11 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800de1:	83 c1 01             	add    $0x1,%ecx
  800de4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800de8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dea:	0f b6 11             	movzbl (%ecx),%edx
  800ded:	8d 72 d0             	lea    -0x30(%edx),%esi
  800df0:	89 f3                	mov    %esi,%ebx
  800df2:	80 fb 09             	cmp    $0x9,%bl
  800df5:	77 d5                	ja     800dcc <strtol+0x7c>
			dig = *s - '0';
  800df7:	0f be d2             	movsbl %dl,%edx
  800dfa:	83 ea 30             	sub    $0x30,%edx
  800dfd:	eb dd                	jmp    800ddc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dff:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e02:	89 f3                	mov    %esi,%ebx
  800e04:	80 fb 19             	cmp    $0x19,%bl
  800e07:	77 08                	ja     800e11 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e09:	0f be d2             	movsbl %dl,%edx
  800e0c:	83 ea 37             	sub    $0x37,%edx
  800e0f:	eb cb                	jmp    800ddc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e15:	74 05                	je     800e1c <strtol+0xcc>
		*endptr = (char *) s;
  800e17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e1a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e1c:	89 c2                	mov    %eax,%edx
  800e1e:	f7 da                	neg    %edx
  800e20:	85 ff                	test   %edi,%edi
  800e22:	0f 45 c2             	cmovne %edx,%eax
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e30:	b8 00 00 00 00       	mov    $0x0,%eax
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3b:	89 c3                	mov    %eax,%ebx
  800e3d:	89 c7                	mov    %eax,%edi
  800e3f:	89 c6                	mov    %eax,%esi
  800e41:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e53:	b8 01 00 00 00       	mov    $0x1,%eax
  800e58:	89 d1                	mov    %edx,%ecx
  800e5a:	89 d3                	mov    %edx,%ebx
  800e5c:	89 d7                	mov    %edx,%edi
  800e5e:	89 d6                	mov    %edx,%esi
  800e60:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	b8 03 00 00 00       	mov    $0x3,%eax
  800e7d:	89 cb                	mov    %ecx,%ebx
  800e7f:	89 cf                	mov    %ecx,%edi
  800e81:	89 ce                	mov    %ecx,%esi
  800e83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7f 08                	jg     800e91 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	50                   	push   %eax
  800e95:	6a 03                	push   $0x3
  800e97:	68 04 31 80 00       	push   $0x803104
  800e9c:	6a 43                	push   $0x43
  800e9e:	68 21 31 80 00       	push   $0x803121
  800ea3:	e8 f7 f3 ff ff       	call   80029f <_panic>

00800ea8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eae:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb3:	b8 02 00 00 00       	mov    $0x2,%eax
  800eb8:	89 d1                	mov    %edx,%ecx
  800eba:	89 d3                	mov    %edx,%ebx
  800ebc:	89 d7                	mov    %edx,%edi
  800ebe:	89 d6                	mov    %edx,%esi
  800ec0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <sys_yield>:

void
sys_yield(void)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ed7:	89 d1                	mov    %edx,%ecx
  800ed9:	89 d3                	mov    %edx,%ebx
  800edb:	89 d7                	mov    %edx,%edi
  800edd:	89 d6                	mov    %edx,%esi
  800edf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	53                   	push   %ebx
  800eec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eef:	be 00 00 00 00       	mov    $0x0,%esi
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efa:	b8 04 00 00 00       	mov    $0x4,%eax
  800eff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f02:	89 f7                	mov    %esi,%edi
  800f04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	7f 08                	jg     800f12 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f12:	83 ec 0c             	sub    $0xc,%esp
  800f15:	50                   	push   %eax
  800f16:	6a 04                	push   $0x4
  800f18:	68 04 31 80 00       	push   $0x803104
  800f1d:	6a 43                	push   $0x43
  800f1f:	68 21 31 80 00       	push   $0x803121
  800f24:	e8 76 f3 ff ff       	call   80029f <_panic>

00800f29 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 05 00 00 00       	mov    $0x5,%eax
  800f3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f40:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f43:	8b 75 18             	mov    0x18(%ebp),%esi
  800f46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7f 08                	jg     800f54 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f54:	83 ec 0c             	sub    $0xc,%esp
  800f57:	50                   	push   %eax
  800f58:	6a 05                	push   $0x5
  800f5a:	68 04 31 80 00       	push   $0x803104
  800f5f:	6a 43                	push   $0x43
  800f61:	68 21 31 80 00       	push   $0x803121
  800f66:	e8 34 f3 ff ff       	call   80029f <_panic>

00800f6b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	b8 06 00 00 00       	mov    $0x6,%eax
  800f84:	89 df                	mov    %ebx,%edi
  800f86:	89 de                	mov    %ebx,%esi
  800f88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7f 08                	jg     800f96 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f96:	83 ec 0c             	sub    $0xc,%esp
  800f99:	50                   	push   %eax
  800f9a:	6a 06                	push   $0x6
  800f9c:	68 04 31 80 00       	push   $0x803104
  800fa1:	6a 43                	push   $0x43
  800fa3:	68 21 31 80 00       	push   $0x803121
  800fa8:	e8 f2 f2 ff ff       	call   80029f <_panic>

00800fad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc1:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc6:	89 df                	mov    %ebx,%edi
  800fc8:	89 de                	mov    %ebx,%esi
  800fca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	7f 08                	jg     800fd8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	50                   	push   %eax
  800fdc:	6a 08                	push   $0x8
  800fde:	68 04 31 80 00       	push   $0x803104
  800fe3:	6a 43                	push   $0x43
  800fe5:	68 21 31 80 00       	push   $0x803121
  800fea:	e8 b0 f2 ff ff       	call   80029f <_panic>

00800fef <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	57                   	push   %edi
  800ff3:	56                   	push   %esi
  800ff4:	53                   	push   %ebx
  800ff5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  801000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801003:	b8 09 00 00 00       	mov    $0x9,%eax
  801008:	89 df                	mov    %ebx,%edi
  80100a:	89 de                	mov    %ebx,%esi
  80100c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100e:	85 c0                	test   %eax,%eax
  801010:	7f 08                	jg     80101a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801012:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	50                   	push   %eax
  80101e:	6a 09                	push   $0x9
  801020:	68 04 31 80 00       	push   $0x803104
  801025:	6a 43                	push   $0x43
  801027:	68 21 31 80 00       	push   $0x803121
  80102c:	e8 6e f2 ff ff       	call   80029f <_panic>

00801031 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	57                   	push   %edi
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
  801037:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801045:	b8 0a 00 00 00       	mov    $0xa,%eax
  80104a:	89 df                	mov    %ebx,%edi
  80104c:	89 de                	mov    %ebx,%esi
  80104e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801050:	85 c0                	test   %eax,%eax
  801052:	7f 08                	jg     80105c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801054:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801057:	5b                   	pop    %ebx
  801058:	5e                   	pop    %esi
  801059:	5f                   	pop    %edi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	50                   	push   %eax
  801060:	6a 0a                	push   $0xa
  801062:	68 04 31 80 00       	push   $0x803104
  801067:	6a 43                	push   $0x43
  801069:	68 21 31 80 00       	push   $0x803121
  80106e:	e8 2c f2 ff ff       	call   80029f <_panic>

00801073 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
	asm volatile("int %1\n"
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801084:	be 00 00 00 00       	mov    $0x0,%esi
  801089:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80108c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80108f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	57                   	push   %edi
  80109a:	56                   	push   %esi
  80109b:	53                   	push   %ebx
  80109c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ac:	89 cb                	mov    %ecx,%ebx
  8010ae:	89 cf                	mov    %ecx,%edi
  8010b0:	89 ce                	mov    %ecx,%esi
  8010b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	7f 08                	jg     8010c0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bb:	5b                   	pop    %ebx
  8010bc:	5e                   	pop    %esi
  8010bd:	5f                   	pop    %edi
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	50                   	push   %eax
  8010c4:	6a 0d                	push   $0xd
  8010c6:	68 04 31 80 00       	push   $0x803104
  8010cb:	6a 43                	push   $0x43
  8010cd:	68 21 31 80 00       	push   $0x803121
  8010d2:	e8 c8 f1 ff ff       	call   80029f <_panic>

008010d7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010ed:	89 df                	mov    %ebx,%edi
  8010ef:	89 de                	mov    %ebx,%esi
  8010f1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5f                   	pop    %edi
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	57                   	push   %edi
  8010fc:	56                   	push   %esi
  8010fd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	b8 0f 00 00 00       	mov    $0xf,%eax
  80110b:	89 cb                	mov    %ecx,%ebx
  80110d:	89 cf                	mov    %ecx,%edi
  80110f:	89 ce                	mov    %ecx,%esi
  801111:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	57                   	push   %edi
  80111c:	56                   	push   %esi
  80111d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111e:	ba 00 00 00 00       	mov    $0x0,%edx
  801123:	b8 10 00 00 00       	mov    $0x10,%eax
  801128:	89 d1                	mov    %edx,%ecx
  80112a:	89 d3                	mov    %edx,%ebx
  80112c:	89 d7                	mov    %edx,%edi
  80112e:	89 d6                	mov    %edx,%esi
  801130:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801142:	8b 55 08             	mov    0x8(%ebp),%edx
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	b8 11 00 00 00       	mov    $0x11,%eax
  80114d:	89 df                	mov    %ebx,%edi
  80114f:	89 de                	mov    %ebx,%esi
  801151:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801169:	b8 12 00 00 00       	mov    $0x12,%eax
  80116e:	89 df                	mov    %ebx,%edi
  801170:	89 de                	mov    %ebx,%esi
  801172:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
  80117f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801182:	bb 00 00 00 00       	mov    $0x0,%ebx
  801187:	8b 55 08             	mov    0x8(%ebp),%edx
  80118a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118d:	b8 13 00 00 00       	mov    $0x13,%eax
  801192:	89 df                	mov    %ebx,%edi
  801194:	89 de                	mov    %ebx,%esi
  801196:	cd 30                	int    $0x30
	if(check && ret > 0)
  801198:	85 c0                	test   %eax,%eax
  80119a:	7f 08                	jg     8011a4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	50                   	push   %eax
  8011a8:	6a 13                	push   $0x13
  8011aa:	68 04 31 80 00       	push   $0x803104
  8011af:	6a 43                	push   $0x43
  8011b1:	68 21 31 80 00       	push   $0x803121
  8011b6:	e8 e4 f0 ff ff       	call   80029f <_panic>

008011bb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011c2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011c9:	f6 c5 04             	test   $0x4,%ch
  8011cc:	75 45                	jne    801213 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011ce:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011d5:	83 e1 07             	and    $0x7,%ecx
  8011d8:	83 f9 07             	cmp    $0x7,%ecx
  8011db:	74 6f                	je     80124c <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011dd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011e4:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011ea:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011f0:	0f 84 b6 00 00 00    	je     8012ac <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011f6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011fd:	83 e1 05             	and    $0x5,%ecx
  801200:	83 f9 05             	cmp    $0x5,%ecx
  801203:	0f 84 d7 00 00 00    	je     8012e0 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801209:	b8 00 00 00 00       	mov    $0x0,%eax
  80120e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801211:	c9                   	leave  
  801212:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801213:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80121a:	c1 e2 0c             	shl    $0xc,%edx
  80121d:	83 ec 0c             	sub    $0xc,%esp
  801220:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801226:	51                   	push   %ecx
  801227:	52                   	push   %edx
  801228:	50                   	push   %eax
  801229:	52                   	push   %edx
  80122a:	6a 00                	push   $0x0
  80122c:	e8 f8 fc ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  801231:	83 c4 20             	add    $0x20,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	79 d1                	jns    801209 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	68 2f 31 80 00       	push   $0x80312f
  801240:	6a 54                	push   $0x54
  801242:	68 45 31 80 00       	push   $0x803145
  801247:	e8 53 f0 ff ff       	call   80029f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80124c:	89 d3                	mov    %edx,%ebx
  80124e:	c1 e3 0c             	shl    $0xc,%ebx
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	68 05 08 00 00       	push   $0x805
  801259:	53                   	push   %ebx
  80125a:	50                   	push   %eax
  80125b:	53                   	push   %ebx
  80125c:	6a 00                	push   $0x0
  80125e:	e8 c6 fc ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  801263:	83 c4 20             	add    $0x20,%esp
  801266:	85 c0                	test   %eax,%eax
  801268:	78 2e                	js     801298 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80126a:	83 ec 0c             	sub    $0xc,%esp
  80126d:	68 05 08 00 00       	push   $0x805
  801272:	53                   	push   %ebx
  801273:	6a 00                	push   $0x0
  801275:	53                   	push   %ebx
  801276:	6a 00                	push   $0x0
  801278:	e8 ac fc ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  80127d:	83 c4 20             	add    $0x20,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	79 85                	jns    801209 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	68 2f 31 80 00       	push   $0x80312f
  80128c:	6a 5f                	push   $0x5f
  80128e:	68 45 31 80 00       	push   $0x803145
  801293:	e8 07 f0 ff ff       	call   80029f <_panic>
			panic("sys_page_map() panic\n");
  801298:	83 ec 04             	sub    $0x4,%esp
  80129b:	68 2f 31 80 00       	push   $0x80312f
  8012a0:	6a 5b                	push   $0x5b
  8012a2:	68 45 31 80 00       	push   $0x803145
  8012a7:	e8 f3 ef ff ff       	call   80029f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ac:	c1 e2 0c             	shl    $0xc,%edx
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	68 05 08 00 00       	push   $0x805
  8012b7:	52                   	push   %edx
  8012b8:	50                   	push   %eax
  8012b9:	52                   	push   %edx
  8012ba:	6a 00                	push   $0x0
  8012bc:	e8 68 fc ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  8012c1:	83 c4 20             	add    $0x20,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	0f 89 3d ff ff ff    	jns    801209 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012cc:	83 ec 04             	sub    $0x4,%esp
  8012cf:	68 2f 31 80 00       	push   $0x80312f
  8012d4:	6a 66                	push   $0x66
  8012d6:	68 45 31 80 00       	push   $0x803145
  8012db:	e8 bf ef ff ff       	call   80029f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012e0:	c1 e2 0c             	shl    $0xc,%edx
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	6a 05                	push   $0x5
  8012e8:	52                   	push   %edx
  8012e9:	50                   	push   %eax
  8012ea:	52                   	push   %edx
  8012eb:	6a 00                	push   $0x0
  8012ed:	e8 37 fc ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  8012f2:	83 c4 20             	add    $0x20,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	0f 89 0c ff ff ff    	jns    801209 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	68 2f 31 80 00       	push   $0x80312f
  801305:	6a 6d                	push   $0x6d
  801307:	68 45 31 80 00       	push   $0x803145
  80130c:	e8 8e ef ff ff       	call   80029f <_panic>

00801311 <pgfault>:
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	53                   	push   %ebx
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80131b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80131d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801321:	0f 84 99 00 00 00    	je     8013c0 <pgfault+0xaf>
  801327:	89 c2                	mov    %eax,%edx
  801329:	c1 ea 16             	shr    $0x16,%edx
  80132c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801333:	f6 c2 01             	test   $0x1,%dl
  801336:	0f 84 84 00 00 00    	je     8013c0 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80133c:	89 c2                	mov    %eax,%edx
  80133e:	c1 ea 0c             	shr    $0xc,%edx
  801341:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801348:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80134e:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801354:	75 6a                	jne    8013c0 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801356:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	6a 07                	push   $0x7
  801362:	68 00 f0 7f 00       	push   $0x7ff000
  801367:	6a 00                	push   $0x0
  801369:	e8 78 fb ff ff       	call   800ee6 <sys_page_alloc>
	if(ret < 0)
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	78 5f                	js     8013d4 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	68 00 10 00 00       	push   $0x1000
  80137d:	53                   	push   %ebx
  80137e:	68 00 f0 7f 00       	push   $0x7ff000
  801383:	e8 5c f9 ff ff       	call   800ce4 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801388:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80138f:	53                   	push   %ebx
  801390:	6a 00                	push   $0x0
  801392:	68 00 f0 7f 00       	push   $0x7ff000
  801397:	6a 00                	push   $0x0
  801399:	e8 8b fb ff ff       	call   800f29 <sys_page_map>
	if(ret < 0)
  80139e:	83 c4 20             	add    $0x20,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	78 43                	js     8013e8 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	68 00 f0 7f 00       	push   $0x7ff000
  8013ad:	6a 00                	push   $0x0
  8013af:	e8 b7 fb ff ff       	call   800f6b <sys_page_unmap>
	if(ret < 0)
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 41                	js     8013fc <pgfault+0xeb>
}
  8013bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	68 50 31 80 00       	push   $0x803150
  8013c8:	6a 26                	push   $0x26
  8013ca:	68 45 31 80 00       	push   $0x803145
  8013cf:	e8 cb ee ff ff       	call   80029f <_panic>
		panic("panic in sys_page_alloc()\n");
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	68 64 31 80 00       	push   $0x803164
  8013dc:	6a 31                	push   $0x31
  8013de:	68 45 31 80 00       	push   $0x803145
  8013e3:	e8 b7 ee ff ff       	call   80029f <_panic>
		panic("panic in sys_page_map()\n");
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	68 7f 31 80 00       	push   $0x80317f
  8013f0:	6a 36                	push   $0x36
  8013f2:	68 45 31 80 00       	push   $0x803145
  8013f7:	e8 a3 ee ff ff       	call   80029f <_panic>
		panic("panic in sys_page_unmap()\n");
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	68 98 31 80 00       	push   $0x803198
  801404:	6a 39                	push   $0x39
  801406:	68 45 31 80 00       	push   $0x803145
  80140b:	e8 8f ee ff ff       	call   80029f <_panic>

00801410 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	57                   	push   %edi
  801414:	56                   	push   %esi
  801415:	53                   	push   %ebx
  801416:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801419:	68 11 13 80 00       	push   $0x801311
  80141e:	e8 0c 15 00 00       	call   80292f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801423:	b8 07 00 00 00       	mov    $0x7,%eax
  801428:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 27                	js     801458 <fork+0x48>
  801431:	89 c6                	mov    %eax,%esi
  801433:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801435:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80143a:	75 48                	jne    801484 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80143c:	e8 67 fa ff ff       	call   800ea8 <sys_getenvid>
  801441:	25 ff 03 00 00       	and    $0x3ff,%eax
  801446:	c1 e0 07             	shl    $0x7,%eax
  801449:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80144e:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801453:	e9 90 00 00 00       	jmp    8014e8 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801458:	83 ec 04             	sub    $0x4,%esp
  80145b:	68 b4 31 80 00       	push   $0x8031b4
  801460:	68 8c 00 00 00       	push   $0x8c
  801465:	68 45 31 80 00       	push   $0x803145
  80146a:	e8 30 ee ff ff       	call   80029f <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80146f:	89 f8                	mov    %edi,%eax
  801471:	e8 45 fd ff ff       	call   8011bb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801476:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80147c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801482:	74 26                	je     8014aa <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801484:	89 d8                	mov    %ebx,%eax
  801486:	c1 e8 16             	shr    $0x16,%eax
  801489:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801490:	a8 01                	test   $0x1,%al
  801492:	74 e2                	je     801476 <fork+0x66>
  801494:	89 da                	mov    %ebx,%edx
  801496:	c1 ea 0c             	shr    $0xc,%edx
  801499:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014a0:	83 e0 05             	and    $0x5,%eax
  8014a3:	83 f8 05             	cmp    $0x5,%eax
  8014a6:	75 ce                	jne    801476 <fork+0x66>
  8014a8:	eb c5                	jmp    80146f <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	6a 07                	push   $0x7
  8014af:	68 00 f0 bf ee       	push   $0xeebff000
  8014b4:	56                   	push   %esi
  8014b5:	e8 2c fa ff ff       	call   800ee6 <sys_page_alloc>
	if(ret < 0)
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 31                	js     8014f2 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014c1:	83 ec 08             	sub    $0x8,%esp
  8014c4:	68 9e 29 80 00       	push   $0x80299e
  8014c9:	56                   	push   %esi
  8014ca:	e8 62 fb ff ff       	call   801031 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 33                	js     801509 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	6a 02                	push   $0x2
  8014db:	56                   	push   %esi
  8014dc:	e8 cc fa ff ff       	call   800fad <sys_env_set_status>
	if(ret < 0)
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 38                	js     801520 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014e8:	89 f0                	mov    %esi,%eax
  8014ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5e                   	pop    %esi
  8014ef:	5f                   	pop    %edi
  8014f0:	5d                   	pop    %ebp
  8014f1:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	68 64 31 80 00       	push   $0x803164
  8014fa:	68 98 00 00 00       	push   $0x98
  8014ff:	68 45 31 80 00       	push   $0x803145
  801504:	e8 96 ed ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	68 d8 31 80 00       	push   $0x8031d8
  801511:	68 9b 00 00 00       	push   $0x9b
  801516:	68 45 31 80 00       	push   $0x803145
  80151b:	e8 7f ed ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_status()\n");
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	68 00 32 80 00       	push   $0x803200
  801528:	68 9e 00 00 00       	push   $0x9e
  80152d:	68 45 31 80 00       	push   $0x803145
  801532:	e8 68 ed ff ff       	call   80029f <_panic>

00801537 <sfork>:

// Challenge!
int
sfork(void)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	57                   	push   %edi
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801540:	68 11 13 80 00       	push   $0x801311
  801545:	e8 e5 13 00 00       	call   80292f <set_pgfault_handler>
  80154a:	b8 07 00 00 00       	mov    $0x7,%eax
  80154f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 27                	js     80157f <sfork+0x48>
  801558:	89 c7                	mov    %eax,%edi
  80155a:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80155c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801561:	75 55                	jne    8015b8 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801563:	e8 40 f9 ff ff       	call   800ea8 <sys_getenvid>
  801568:	25 ff 03 00 00       	and    $0x3ff,%eax
  80156d:	c1 e0 07             	shl    $0x7,%eax
  801570:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801575:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80157a:	e9 d4 00 00 00       	jmp    801653 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	68 b4 31 80 00       	push   $0x8031b4
  801587:	68 af 00 00 00       	push   $0xaf
  80158c:	68 45 31 80 00       	push   $0x803145
  801591:	e8 09 ed ff ff       	call   80029f <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801596:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80159b:	89 f0                	mov    %esi,%eax
  80159d:	e8 19 fc ff ff       	call   8011bb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015a8:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015ae:	77 65                	ja     801615 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015b0:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015b6:	74 de                	je     801596 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015b8:	89 d8                	mov    %ebx,%eax
  8015ba:	c1 e8 16             	shr    $0x16,%eax
  8015bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c4:	a8 01                	test   $0x1,%al
  8015c6:	74 da                	je     8015a2 <sfork+0x6b>
  8015c8:	89 da                	mov    %ebx,%edx
  8015ca:	c1 ea 0c             	shr    $0xc,%edx
  8015cd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015d4:	83 e0 05             	and    $0x5,%eax
  8015d7:	83 f8 05             	cmp    $0x5,%eax
  8015da:	75 c6                	jne    8015a2 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015dc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015e3:	c1 e2 0c             	shl    $0xc,%edx
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	83 e0 07             	and    $0x7,%eax
  8015ec:	50                   	push   %eax
  8015ed:	52                   	push   %edx
  8015ee:	56                   	push   %esi
  8015ef:	52                   	push   %edx
  8015f0:	6a 00                	push   $0x0
  8015f2:	e8 32 f9 ff ff       	call   800f29 <sys_page_map>
  8015f7:	83 c4 20             	add    $0x20,%esp
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	74 a4                	je     8015a2 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 2f 31 80 00       	push   $0x80312f
  801606:	68 ba 00 00 00       	push   $0xba
  80160b:	68 45 31 80 00       	push   $0x803145
  801610:	e8 8a ec ff ff       	call   80029f <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	6a 07                	push   $0x7
  80161a:	68 00 f0 bf ee       	push   $0xeebff000
  80161f:	57                   	push   %edi
  801620:	e8 c1 f8 ff ff       	call   800ee6 <sys_page_alloc>
	if(ret < 0)
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 31                	js     80165d <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	68 9e 29 80 00       	push   $0x80299e
  801634:	57                   	push   %edi
  801635:	e8 f7 f9 ff ff       	call   801031 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 33                	js     801674 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	6a 02                	push   $0x2
  801646:	57                   	push   %edi
  801647:	e8 61 f9 ff ff       	call   800fad <sys_env_set_status>
	if(ret < 0)
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 38                	js     80168b <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801653:	89 f8                	mov    %edi,%eax
  801655:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801658:	5b                   	pop    %ebx
  801659:	5e                   	pop    %esi
  80165a:	5f                   	pop    %edi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 64 31 80 00       	push   $0x803164
  801665:	68 c0 00 00 00       	push   $0xc0
  80166a:	68 45 31 80 00       	push   $0x803145
  80166f:	e8 2b ec ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	68 d8 31 80 00       	push   $0x8031d8
  80167c:	68 c3 00 00 00       	push   $0xc3
  801681:	68 45 31 80 00       	push   $0x803145
  801686:	e8 14 ec ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_status()\n");
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	68 00 32 80 00       	push   $0x803200
  801693:	68 c6 00 00 00       	push   $0xc6
  801698:	68 45 31 80 00       	push   $0x803145
  80169d:	e8 fd eb ff ff       	call   80029f <_panic>

008016a2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	56                   	push   %esi
  8016a6:	53                   	push   %ebx
  8016a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8016b0:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8016b2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016b7:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	50                   	push   %eax
  8016be:	e8 d3 f9 ff ff       	call   801096 <sys_ipc_recv>
	if(ret < 0){
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	78 2b                	js     8016f5 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016ca:	85 f6                	test   %esi,%esi
  8016cc:	74 0a                	je     8016d8 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8016ce:	a1 08 50 80 00       	mov    0x805008,%eax
  8016d3:	8b 40 74             	mov    0x74(%eax),%eax
  8016d6:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016d8:	85 db                	test   %ebx,%ebx
  8016da:	74 0a                	je     8016e6 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8016dc:	a1 08 50 80 00       	mov    0x805008,%eax
  8016e1:	8b 40 78             	mov    0x78(%eax),%eax
  8016e4:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8016e6:	a1 08 50 80 00       	mov    0x805008,%eax
  8016eb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    
		if(from_env_store)
  8016f5:	85 f6                	test   %esi,%esi
  8016f7:	74 06                	je     8016ff <ipc_recv+0x5d>
			*from_env_store = 0;
  8016f9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8016ff:	85 db                	test   %ebx,%ebx
  801701:	74 eb                	je     8016ee <ipc_recv+0x4c>
			*perm_store = 0;
  801703:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801709:	eb e3                	jmp    8016ee <ipc_recv+0x4c>

0080170b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	57                   	push   %edi
  80170f:	56                   	push   %esi
  801710:	53                   	push   %ebx
  801711:	83 ec 0c             	sub    $0xc,%esp
  801714:	8b 7d 08             	mov    0x8(%ebp),%edi
  801717:	8b 75 0c             	mov    0xc(%ebp),%esi
  80171a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80171d:	85 db                	test   %ebx,%ebx
  80171f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801724:	0f 44 d8             	cmove  %eax,%ebx
  801727:	eb 05                	jmp    80172e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801729:	e8 99 f7 ff ff       	call   800ec7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80172e:	ff 75 14             	pushl  0x14(%ebp)
  801731:	53                   	push   %ebx
  801732:	56                   	push   %esi
  801733:	57                   	push   %edi
  801734:	e8 3a f9 ff ff       	call   801073 <sys_ipc_try_send>
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	74 1b                	je     80175b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801740:	79 e7                	jns    801729 <ipc_send+0x1e>
  801742:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801745:	74 e2                	je     801729 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	68 1f 32 80 00       	push   $0x80321f
  80174f:	6a 48                	push   $0x48
  801751:	68 34 32 80 00       	push   $0x803234
  801756:	e8 44 eb ff ff       	call   80029f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80175b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175e:	5b                   	pop    %ebx
  80175f:	5e                   	pop    %esi
  801760:	5f                   	pop    %edi
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    

00801763 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80176e:	89 c2                	mov    %eax,%edx
  801770:	c1 e2 07             	shl    $0x7,%edx
  801773:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801779:	8b 52 50             	mov    0x50(%edx),%edx
  80177c:	39 ca                	cmp    %ecx,%edx
  80177e:	74 11                	je     801791 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801780:	83 c0 01             	add    $0x1,%eax
  801783:	3d 00 04 00 00       	cmp    $0x400,%eax
  801788:	75 e4                	jne    80176e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
  80178f:	eb 0b                	jmp    80179c <ipc_find_env+0x39>
			return envs[i].env_id;
  801791:	c1 e0 07             	shl    $0x7,%eax
  801794:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801799:	8b 40 48             	mov    0x48(%eax),%eax
}
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	05 00 00 00 30       	add    $0x30000000,%eax
  8017a9:	c1 e8 0c             	shr    $0xc,%eax
}
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017be:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017cd:	89 c2                	mov    %eax,%edx
  8017cf:	c1 ea 16             	shr    $0x16,%edx
  8017d2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017d9:	f6 c2 01             	test   $0x1,%dl
  8017dc:	74 2d                	je     80180b <fd_alloc+0x46>
  8017de:	89 c2                	mov    %eax,%edx
  8017e0:	c1 ea 0c             	shr    $0xc,%edx
  8017e3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017ea:	f6 c2 01             	test   $0x1,%dl
  8017ed:	74 1c                	je     80180b <fd_alloc+0x46>
  8017ef:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017f4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017f9:	75 d2                	jne    8017cd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801804:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801809:	eb 0a                	jmp    801815 <fd_alloc+0x50>
			*fd_store = fd;
  80180b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80181d:	83 f8 1f             	cmp    $0x1f,%eax
  801820:	77 30                	ja     801852 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801822:	c1 e0 0c             	shl    $0xc,%eax
  801825:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80182a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801830:	f6 c2 01             	test   $0x1,%dl
  801833:	74 24                	je     801859 <fd_lookup+0x42>
  801835:	89 c2                	mov    %eax,%edx
  801837:	c1 ea 0c             	shr    $0xc,%edx
  80183a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801841:	f6 c2 01             	test   $0x1,%dl
  801844:	74 1a                	je     801860 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801846:	8b 55 0c             	mov    0xc(%ebp),%edx
  801849:	89 02                	mov    %eax,(%edx)
	return 0;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    
		return -E_INVAL;
  801852:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801857:	eb f7                	jmp    801850 <fd_lookup+0x39>
		return -E_INVAL;
  801859:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185e:	eb f0                	jmp    801850 <fd_lookup+0x39>
  801860:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801865:	eb e9                	jmp    801850 <fd_lookup+0x39>

00801867 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801870:	ba 00 00 00 00       	mov    $0x0,%edx
  801875:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80187a:	39 08                	cmp    %ecx,(%eax)
  80187c:	74 38                	je     8018b6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80187e:	83 c2 01             	add    $0x1,%edx
  801881:	8b 04 95 bc 32 80 00 	mov    0x8032bc(,%edx,4),%eax
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 ee                	jne    80187a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80188c:	a1 08 50 80 00       	mov    0x805008,%eax
  801891:	8b 40 48             	mov    0x48(%eax),%eax
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	51                   	push   %ecx
  801898:	50                   	push   %eax
  801899:	68 40 32 80 00       	push   $0x803240
  80189e:	e8 f2 ea ff ff       	call   800395 <cprintf>
	*dev = 0;
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    
			*dev = devtab[i];
  8018b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c0:	eb f2                	jmp    8018b4 <dev_lookup+0x4d>

008018c2 <fd_close>:
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 24             	sub    $0x24,%esp
  8018cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018d4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018d5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018db:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018de:	50                   	push   %eax
  8018df:	e8 33 ff ff ff       	call   801817 <fd_lookup>
  8018e4:	89 c3                	mov    %eax,%ebx
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 05                	js     8018f2 <fd_close+0x30>
	    || fd != fd2)
  8018ed:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018f0:	74 16                	je     801908 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018f2:	89 f8                	mov    %edi,%eax
  8018f4:	84 c0                	test   %al,%al
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	0f 44 d8             	cmove  %eax,%ebx
}
  8018fe:	89 d8                	mov    %ebx,%eax
  801900:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801903:	5b                   	pop    %ebx
  801904:	5e                   	pop    %esi
  801905:	5f                   	pop    %edi
  801906:	5d                   	pop    %ebp
  801907:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80190e:	50                   	push   %eax
  80190f:	ff 36                	pushl  (%esi)
  801911:	e8 51 ff ff ff       	call   801867 <dev_lookup>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 1a                	js     801939 <fd_close+0x77>
		if (dev->dev_close)
  80191f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801922:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801925:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80192a:	85 c0                	test   %eax,%eax
  80192c:	74 0b                	je     801939 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	56                   	push   %esi
  801932:	ff d0                	call   *%eax
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	56                   	push   %esi
  80193d:	6a 00                	push   $0x0
  80193f:	e8 27 f6 ff ff       	call   800f6b <sys_page_unmap>
	return r;
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	eb b5                	jmp    8018fe <fd_close+0x3c>

00801949 <close>:

int
close(int fdnum)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	e8 bc fe ff ff       	call   801817 <fd_lookup>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	79 02                	jns    801964 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    
		return fd_close(fd, 1);
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	6a 01                	push   $0x1
  801969:	ff 75 f4             	pushl  -0xc(%ebp)
  80196c:	e8 51 ff ff ff       	call   8018c2 <fd_close>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	eb ec                	jmp    801962 <close+0x19>

00801976 <close_all>:

void
close_all(void)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	53                   	push   %ebx
  80197a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80197d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801982:	83 ec 0c             	sub    $0xc,%esp
  801985:	53                   	push   %ebx
  801986:	e8 be ff ff ff       	call   801949 <close>
	for (i = 0; i < MAXFD; i++)
  80198b:	83 c3 01             	add    $0x1,%ebx
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	83 fb 20             	cmp    $0x20,%ebx
  801994:	75 ec                	jne    801982 <close_all+0xc>
}
  801996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	57                   	push   %edi
  80199f:	56                   	push   %esi
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	ff 75 08             	pushl  0x8(%ebp)
  8019ab:	e8 67 fe ff ff       	call   801817 <fd_lookup>
  8019b0:	89 c3                	mov    %eax,%ebx
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	0f 88 81 00 00 00    	js     801a3e <dup+0xa3>
		return r;
	close(newfdnum);
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	e8 81 ff ff ff       	call   801949 <close>

	newfd = INDEX2FD(newfdnum);
  8019c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019cb:	c1 e6 0c             	shl    $0xc,%esi
  8019ce:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019d4:	83 c4 04             	add    $0x4,%esp
  8019d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019da:	e8 cf fd ff ff       	call   8017ae <fd2data>
  8019df:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019e1:	89 34 24             	mov    %esi,(%esp)
  8019e4:	e8 c5 fd ff ff       	call   8017ae <fd2data>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	c1 e8 16             	shr    $0x16,%eax
  8019f3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019fa:	a8 01                	test   $0x1,%al
  8019fc:	74 11                	je     801a0f <dup+0x74>
  8019fe:	89 d8                	mov    %ebx,%eax
  801a00:	c1 e8 0c             	shr    $0xc,%eax
  801a03:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a0a:	f6 c2 01             	test   $0x1,%dl
  801a0d:	75 39                	jne    801a48 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a12:	89 d0                	mov    %edx,%eax
  801a14:	c1 e8 0c             	shr    $0xc,%eax
  801a17:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	25 07 0e 00 00       	and    $0xe07,%eax
  801a26:	50                   	push   %eax
  801a27:	56                   	push   %esi
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	6a 00                	push   $0x0
  801a2d:	e8 f7 f4 ff ff       	call   800f29 <sys_page_map>
  801a32:	89 c3                	mov    %eax,%ebx
  801a34:	83 c4 20             	add    $0x20,%esp
  801a37:	85 c0                	test   %eax,%eax
  801a39:	78 31                	js     801a6c <dup+0xd1>
		goto err;

	return newfdnum;
  801a3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a3e:	89 d8                	mov    %ebx,%eax
  801a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5f                   	pop    %edi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a48:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	25 07 0e 00 00       	and    $0xe07,%eax
  801a57:	50                   	push   %eax
  801a58:	57                   	push   %edi
  801a59:	6a 00                	push   $0x0
  801a5b:	53                   	push   %ebx
  801a5c:	6a 00                	push   $0x0
  801a5e:	e8 c6 f4 ff ff       	call   800f29 <sys_page_map>
  801a63:	89 c3                	mov    %eax,%ebx
  801a65:	83 c4 20             	add    $0x20,%esp
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	79 a3                	jns    801a0f <dup+0x74>
	sys_page_unmap(0, newfd);
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	56                   	push   %esi
  801a70:	6a 00                	push   $0x0
  801a72:	e8 f4 f4 ff ff       	call   800f6b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a77:	83 c4 08             	add    $0x8,%esp
  801a7a:	57                   	push   %edi
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 e9 f4 ff ff       	call   800f6b <sys_page_unmap>
	return r;
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	eb b7                	jmp    801a3e <dup+0xa3>

00801a87 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	53                   	push   %ebx
  801a8b:	83 ec 1c             	sub    $0x1c,%esp
  801a8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a94:	50                   	push   %eax
  801a95:	53                   	push   %ebx
  801a96:	e8 7c fd ff ff       	call   801817 <fd_lookup>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 3f                	js     801ae1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa2:	83 ec 08             	sub    $0x8,%esp
  801aa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa8:	50                   	push   %eax
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	ff 30                	pushl  (%eax)
  801aae:	e8 b4 fd ff ff       	call   801867 <dev_lookup>
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 27                	js     801ae1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801abd:	8b 42 08             	mov    0x8(%edx),%eax
  801ac0:	83 e0 03             	and    $0x3,%eax
  801ac3:	83 f8 01             	cmp    $0x1,%eax
  801ac6:	74 1e                	je     801ae6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acb:	8b 40 08             	mov    0x8(%eax),%eax
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	74 35                	je     801b07 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	52                   	push   %edx
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ae6:	a1 08 50 80 00       	mov    0x805008,%eax
  801aeb:	8b 40 48             	mov    0x48(%eax),%eax
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	53                   	push   %ebx
  801af2:	50                   	push   %eax
  801af3:	68 81 32 80 00       	push   $0x803281
  801af8:	e8 98 e8 ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b05:	eb da                	jmp    801ae1 <read+0x5a>
		return -E_NOT_SUPP;
  801b07:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b0c:	eb d3                	jmp    801ae1 <read+0x5a>

00801b0e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	57                   	push   %edi
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	83 ec 0c             	sub    $0xc,%esp
  801b17:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b1a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b22:	39 f3                	cmp    %esi,%ebx
  801b24:	73 23                	jae    801b49 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	89 f0                	mov    %esi,%eax
  801b2b:	29 d8                	sub    %ebx,%eax
  801b2d:	50                   	push   %eax
  801b2e:	89 d8                	mov    %ebx,%eax
  801b30:	03 45 0c             	add    0xc(%ebp),%eax
  801b33:	50                   	push   %eax
  801b34:	57                   	push   %edi
  801b35:	e8 4d ff ff ff       	call   801a87 <read>
		if (m < 0)
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 06                	js     801b47 <readn+0x39>
			return m;
		if (m == 0)
  801b41:	74 06                	je     801b49 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b43:	01 c3                	add    %eax,%ebx
  801b45:	eb db                	jmp    801b22 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b47:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b49:	89 d8                	mov    %ebx,%eax
  801b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5f                   	pop    %edi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	53                   	push   %ebx
  801b57:	83 ec 1c             	sub    $0x1c,%esp
  801b5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b60:	50                   	push   %eax
  801b61:	53                   	push   %ebx
  801b62:	e8 b0 fc ff ff       	call   801817 <fd_lookup>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 3a                	js     801ba8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6e:	83 ec 08             	sub    $0x8,%esp
  801b71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b74:	50                   	push   %eax
  801b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b78:	ff 30                	pushl  (%eax)
  801b7a:	e8 e8 fc ff ff       	call   801867 <dev_lookup>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 22                	js     801ba8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b89:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b8d:	74 1e                	je     801bad <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b92:	8b 52 0c             	mov    0xc(%edx),%edx
  801b95:	85 d2                	test   %edx,%edx
  801b97:	74 35                	je     801bce <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	ff 75 10             	pushl  0x10(%ebp)
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	ff d2                	call   *%edx
  801ba5:	83 c4 10             	add    $0x10,%esp
}
  801ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bad:	a1 08 50 80 00       	mov    0x805008,%eax
  801bb2:	8b 40 48             	mov    0x48(%eax),%eax
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	53                   	push   %ebx
  801bb9:	50                   	push   %eax
  801bba:	68 9d 32 80 00       	push   $0x80329d
  801bbf:	e8 d1 e7 ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bcc:	eb da                	jmp    801ba8 <write+0x55>
		return -E_NOT_SUPP;
  801bce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd3:	eb d3                	jmp    801ba8 <write+0x55>

00801bd5 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bde:	50                   	push   %eax
  801bdf:	ff 75 08             	pushl  0x8(%ebp)
  801be2:	e8 30 fc ff ff       	call   801817 <fd_lookup>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 0e                	js     801bfc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
  801c02:	83 ec 1c             	sub    $0x1c,%esp
  801c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c0b:	50                   	push   %eax
  801c0c:	53                   	push   %ebx
  801c0d:	e8 05 fc ff ff       	call   801817 <fd_lookup>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 37                	js     801c50 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c19:	83 ec 08             	sub    $0x8,%esp
  801c1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1f:	50                   	push   %eax
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c23:	ff 30                	pushl  (%eax)
  801c25:	e8 3d fc ff ff       	call   801867 <dev_lookup>
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	78 1f                	js     801c50 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c34:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c38:	74 1b                	je     801c55 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c3d:	8b 52 18             	mov    0x18(%edx),%edx
  801c40:	85 d2                	test   %edx,%edx
  801c42:	74 32                	je     801c76 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c44:	83 ec 08             	sub    $0x8,%esp
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	50                   	push   %eax
  801c4b:	ff d2                	call   *%edx
  801c4d:	83 c4 10             	add    $0x10,%esp
}
  801c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c55:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c5a:	8b 40 48             	mov    0x48(%eax),%eax
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	53                   	push   %ebx
  801c61:	50                   	push   %eax
  801c62:	68 60 32 80 00       	push   $0x803260
  801c67:	e8 29 e7 ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c74:	eb da                	jmp    801c50 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c7b:	eb d3                	jmp    801c50 <ftruncate+0x52>

00801c7d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	53                   	push   %ebx
  801c81:	83 ec 1c             	sub    $0x1c,%esp
  801c84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8a:	50                   	push   %eax
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	e8 84 fb ff ff       	call   801817 <fd_lookup>
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 4b                	js     801ce5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c9a:	83 ec 08             	sub    $0x8,%esp
  801c9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca0:	50                   	push   %eax
  801ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca4:	ff 30                	pushl  (%eax)
  801ca6:	e8 bc fb ff ff       	call   801867 <dev_lookup>
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	78 33                	js     801ce5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cb9:	74 2f                	je     801cea <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cbb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cbe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cc5:	00 00 00 
	stat->st_isdir = 0;
  801cc8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ccf:	00 00 00 
	stat->st_dev = dev;
  801cd2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cd8:	83 ec 08             	sub    $0x8,%esp
  801cdb:	53                   	push   %ebx
  801cdc:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdf:	ff 50 14             	call   *0x14(%eax)
  801ce2:	83 c4 10             	add    $0x10,%esp
}
  801ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    
		return -E_NOT_SUPP;
  801cea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cef:	eb f4                	jmp    801ce5 <fstat+0x68>

00801cf1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	56                   	push   %esi
  801cf5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	e8 22 02 00 00       	call   801f25 <open>
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 1b                	js     801d27 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d0c:	83 ec 08             	sub    $0x8,%esp
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	50                   	push   %eax
  801d13:	e8 65 ff ff ff       	call   801c7d <fstat>
  801d18:	89 c6                	mov    %eax,%esi
	close(fd);
  801d1a:	89 1c 24             	mov    %ebx,(%esp)
  801d1d:	e8 27 fc ff ff       	call   801949 <close>
	return r;
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	89 f3                	mov    %esi,%ebx
}
  801d27:	89 d8                	mov    %ebx,%eax
  801d29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	89 c6                	mov    %eax,%esi
  801d37:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d39:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d40:	74 27                	je     801d69 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d42:	6a 07                	push   $0x7
  801d44:	68 00 60 80 00       	push   $0x806000
  801d49:	56                   	push   %esi
  801d4a:	ff 35 00 50 80 00    	pushl  0x805000
  801d50:	e8 b6 f9 ff ff       	call   80170b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d55:	83 c4 0c             	add    $0xc,%esp
  801d58:	6a 00                	push   $0x0
  801d5a:	53                   	push   %ebx
  801d5b:	6a 00                	push   $0x0
  801d5d:	e8 40 f9 ff ff       	call   8016a2 <ipc_recv>
}
  801d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	6a 01                	push   $0x1
  801d6e:	e8 f0 f9 ff ff       	call   801763 <ipc_find_env>
  801d73:	a3 00 50 80 00       	mov    %eax,0x805000
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	eb c5                	jmp    801d42 <fsipc+0x12>

00801d7d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	8b 40 0c             	mov    0xc(%eax),%eax
  801d89:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d91:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d96:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9b:	b8 02 00 00 00       	mov    $0x2,%eax
  801da0:	e8 8b ff ff ff       	call   801d30 <fsipc>
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <devfile_flush>:
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	8b 40 0c             	mov    0xc(%eax),%eax
  801db3:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801db8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbd:	b8 06 00 00 00       	mov    $0x6,%eax
  801dc2:	e8 69 ff ff ff       	call   801d30 <fsipc>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <devfile_stat>:
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	53                   	push   %ebx
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd9:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dde:	ba 00 00 00 00       	mov    $0x0,%edx
  801de3:	b8 05 00 00 00       	mov    $0x5,%eax
  801de8:	e8 43 ff ff ff       	call   801d30 <fsipc>
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 2c                	js     801e1d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	68 00 60 80 00       	push   $0x806000
  801df9:	53                   	push   %ebx
  801dfa:	e8 f5 ec ff ff       	call   800af4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dff:	a1 80 60 80 00       	mov    0x806080,%eax
  801e04:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e0a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e0f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <devfile_write>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	53                   	push   %ebx
  801e26:	83 ec 08             	sub    $0x8,%esp
  801e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e32:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e37:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e3d:	53                   	push   %ebx
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	68 08 60 80 00       	push   $0x806008
  801e46:	e8 99 ee ff ff       	call   800ce4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e50:	b8 04 00 00 00       	mov    $0x4,%eax
  801e55:	e8 d6 fe ff ff       	call   801d30 <fsipc>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	78 0b                	js     801e6c <devfile_write+0x4a>
	assert(r <= n);
  801e61:	39 d8                	cmp    %ebx,%eax
  801e63:	77 0c                	ja     801e71 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e65:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e6a:	7f 1e                	jg     801e8a <devfile_write+0x68>
}
  801e6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    
	assert(r <= n);
  801e71:	68 d0 32 80 00       	push   $0x8032d0
  801e76:	68 d7 32 80 00       	push   $0x8032d7
  801e7b:	68 98 00 00 00       	push   $0x98
  801e80:	68 ec 32 80 00       	push   $0x8032ec
  801e85:	e8 15 e4 ff ff       	call   80029f <_panic>
	assert(r <= PGSIZE);
  801e8a:	68 f7 32 80 00       	push   $0x8032f7
  801e8f:	68 d7 32 80 00       	push   $0x8032d7
  801e94:	68 99 00 00 00       	push   $0x99
  801e99:	68 ec 32 80 00       	push   $0x8032ec
  801e9e:	e8 fc e3 ff ff       	call   80029f <_panic>

00801ea3 <devfile_read>:
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801eb6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec1:	b8 03 00 00 00       	mov    $0x3,%eax
  801ec6:	e8 65 fe ff ff       	call   801d30 <fsipc>
  801ecb:	89 c3                	mov    %eax,%ebx
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 1f                	js     801ef0 <devfile_read+0x4d>
	assert(r <= n);
  801ed1:	39 f0                	cmp    %esi,%eax
  801ed3:	77 24                	ja     801ef9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ed5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eda:	7f 33                	jg     801f0f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	50                   	push   %eax
  801ee0:	68 00 60 80 00       	push   $0x806000
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	e8 95 ed ff ff       	call   800c82 <memmove>
	return r;
  801eed:	83 c4 10             	add    $0x10,%esp
}
  801ef0:	89 d8                	mov    %ebx,%eax
  801ef2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    
	assert(r <= n);
  801ef9:	68 d0 32 80 00       	push   $0x8032d0
  801efe:	68 d7 32 80 00       	push   $0x8032d7
  801f03:	6a 7c                	push   $0x7c
  801f05:	68 ec 32 80 00       	push   $0x8032ec
  801f0a:	e8 90 e3 ff ff       	call   80029f <_panic>
	assert(r <= PGSIZE);
  801f0f:	68 f7 32 80 00       	push   $0x8032f7
  801f14:	68 d7 32 80 00       	push   $0x8032d7
  801f19:	6a 7d                	push   $0x7d
  801f1b:	68 ec 32 80 00       	push   $0x8032ec
  801f20:	e8 7a e3 ff ff       	call   80029f <_panic>

00801f25 <open>:
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	56                   	push   %esi
  801f29:	53                   	push   %ebx
  801f2a:	83 ec 1c             	sub    $0x1c,%esp
  801f2d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f30:	56                   	push   %esi
  801f31:	e8 85 eb ff ff       	call   800abb <strlen>
  801f36:	83 c4 10             	add    $0x10,%esp
  801f39:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f3e:	7f 6c                	jg     801fac <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f46:	50                   	push   %eax
  801f47:	e8 79 f8 ff ff       	call   8017c5 <fd_alloc>
  801f4c:	89 c3                	mov    %eax,%ebx
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	85 c0                	test   %eax,%eax
  801f53:	78 3c                	js     801f91 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	56                   	push   %esi
  801f59:	68 00 60 80 00       	push   $0x806000
  801f5e:	e8 91 eb ff ff       	call   800af4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f66:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	e8 b8 fd ff ff       	call   801d30 <fsipc>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 19                	js     801f9a <open+0x75>
	return fd2num(fd);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	ff 75 f4             	pushl  -0xc(%ebp)
  801f87:	e8 12 f8 ff ff       	call   80179e <fd2num>
  801f8c:	89 c3                	mov    %eax,%ebx
  801f8e:	83 c4 10             	add    $0x10,%esp
}
  801f91:	89 d8                	mov    %ebx,%eax
  801f93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f96:	5b                   	pop    %ebx
  801f97:	5e                   	pop    %esi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    
		fd_close(fd, 0);
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	6a 00                	push   $0x0
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	e8 1b f9 ff ff       	call   8018c2 <fd_close>
		return r;
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	eb e5                	jmp    801f91 <open+0x6c>
		return -E_BAD_PATH;
  801fac:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fb1:	eb de                	jmp    801f91 <open+0x6c>

00801fb3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbe:	b8 08 00 00 00       	mov    $0x8,%eax
  801fc3:	e8 68 fd ff ff       	call   801d30 <fsipc>
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fd0:	89 d0                	mov    %edx,%eax
  801fd2:	c1 e8 16             	shr    $0x16,%eax
  801fd5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fe1:	f6 c1 01             	test   $0x1,%cl
  801fe4:	74 1d                	je     802003 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fe6:	c1 ea 0c             	shr    $0xc,%edx
  801fe9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ff0:	f6 c2 01             	test   $0x1,%dl
  801ff3:	74 0e                	je     802003 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff5:	c1 ea 0c             	shr    $0xc,%edx
  801ff8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801fff:	ef 
  802000:	0f b7 c0             	movzwl %ax,%eax
}
  802003:	5d                   	pop    %ebp
  802004:	c3                   	ret    

00802005 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80200b:	68 03 33 80 00       	push   $0x803303
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	e8 dc ea ff ff       	call   800af4 <strcpy>
	return 0;
}
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <devsock_close>:
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	53                   	push   %ebx
  802023:	83 ec 10             	sub    $0x10,%esp
  802026:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802029:	53                   	push   %ebx
  80202a:	e8 9b ff ff ff       	call   801fca <pageref>
  80202f:	83 c4 10             	add    $0x10,%esp
		return 0;
  802032:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802037:	83 f8 01             	cmp    $0x1,%eax
  80203a:	74 07                	je     802043 <devsock_close+0x24>
}
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802041:	c9                   	leave  
  802042:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	ff 73 0c             	pushl  0xc(%ebx)
  802049:	e8 b9 02 00 00       	call   802307 <nsipc_close>
  80204e:	89 c2                	mov    %eax,%edx
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	eb e7                	jmp    80203c <devsock_close+0x1d>

00802055 <devsock_write>:
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	ff 75 10             	pushl  0x10(%ebp)
  802060:	ff 75 0c             	pushl  0xc(%ebp)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	ff 70 0c             	pushl  0xc(%eax)
  802069:	e8 76 03 00 00       	call   8023e4 <nsipc_send>
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <devsock_read>:
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802076:	6a 00                	push   $0x0
  802078:	ff 75 10             	pushl  0x10(%ebp)
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	ff 70 0c             	pushl  0xc(%eax)
  802084:	e8 ef 02 00 00       	call   802378 <nsipc_recv>
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <fd2sockid>:
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802091:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802094:	52                   	push   %edx
  802095:	50                   	push   %eax
  802096:	e8 7c f7 ff ff       	call   801817 <fd_lookup>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 10                	js     8020b2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020ab:	39 08                	cmp    %ecx,(%eax)
  8020ad:	75 05                	jne    8020b4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020af:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    
		return -E_NOT_SUPP;
  8020b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020b9:	eb f7                	jmp    8020b2 <fd2sockid+0x27>

008020bb <alloc_sockfd>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
  8020c0:	83 ec 1c             	sub    $0x1c,%esp
  8020c3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c8:	50                   	push   %eax
  8020c9:	e8 f7 f6 ff ff       	call   8017c5 <fd_alloc>
  8020ce:	89 c3                	mov    %eax,%ebx
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 43                	js     80211a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 07 04 00 00       	push   $0x407
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	6a 00                	push   $0x0
  8020e4:	e8 fd ed ff ff       	call   800ee6 <sys_page_alloc>
  8020e9:	89 c3                	mov    %eax,%ebx
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 28                	js     80211a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020fb:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802107:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	50                   	push   %eax
  80210e:	e8 8b f6 ff ff       	call   80179e <fd2num>
  802113:	89 c3                	mov    %eax,%ebx
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	eb 0c                	jmp    802126 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	56                   	push   %esi
  80211e:	e8 e4 01 00 00       	call   802307 <nsipc_close>
		return r;
  802123:	83 c4 10             	add    $0x10,%esp
}
  802126:	89 d8                	mov    %ebx,%eax
  802128:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5d                   	pop    %ebp
  80212e:	c3                   	ret    

0080212f <accept>:
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	e8 4e ff ff ff       	call   80208b <fd2sockid>
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 1b                	js     80215c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	ff 75 10             	pushl  0x10(%ebp)
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	50                   	push   %eax
  80214b:	e8 0e 01 00 00       	call   80225e <nsipc_accept>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	85 c0                	test   %eax,%eax
  802155:	78 05                	js     80215c <accept+0x2d>
	return alloc_sockfd(r);
  802157:	e8 5f ff ff ff       	call   8020bb <alloc_sockfd>
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <bind>:
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	e8 1f ff ff ff       	call   80208b <fd2sockid>
  80216c:	85 c0                	test   %eax,%eax
  80216e:	78 12                	js     802182 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802170:	83 ec 04             	sub    $0x4,%esp
  802173:	ff 75 10             	pushl  0x10(%ebp)
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	50                   	push   %eax
  80217a:	e8 31 01 00 00       	call   8022b0 <nsipc_bind>
  80217f:	83 c4 10             	add    $0x10,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <shutdown>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	e8 f9 fe ff ff       	call   80208b <fd2sockid>
  802192:	85 c0                	test   %eax,%eax
  802194:	78 0f                	js     8021a5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802196:	83 ec 08             	sub    $0x8,%esp
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	50                   	push   %eax
  80219d:	e8 43 01 00 00       	call   8022e5 <nsipc_shutdown>
  8021a2:	83 c4 10             	add    $0x10,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <connect>:
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	e8 d6 fe ff ff       	call   80208b <fd2sockid>
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	78 12                	js     8021cb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	ff 75 10             	pushl  0x10(%ebp)
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	50                   	push   %eax
  8021c3:	e8 59 01 00 00       	call   802321 <nsipc_connect>
  8021c8:	83 c4 10             	add    $0x10,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <listen>:
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	e8 b0 fe ff ff       	call   80208b <fd2sockid>
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 0f                	js     8021ee <listen+0x21>
	return nsipc_listen(r, backlog);
  8021df:	83 ec 08             	sub    $0x8,%esp
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	50                   	push   %eax
  8021e6:	e8 6b 01 00 00       	call   802356 <nsipc_listen>
  8021eb:	83 c4 10             	add    $0x10,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021f6:	ff 75 10             	pushl  0x10(%ebp)
  8021f9:	ff 75 0c             	pushl  0xc(%ebp)
  8021fc:	ff 75 08             	pushl  0x8(%ebp)
  8021ff:	e8 3e 02 00 00       	call   802442 <nsipc_socket>
  802204:	83 c4 10             	add    $0x10,%esp
  802207:	85 c0                	test   %eax,%eax
  802209:	78 05                	js     802210 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80220b:	e8 ab fe ff ff       	call   8020bb <alloc_sockfd>
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	53                   	push   %ebx
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80221b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802222:	74 26                	je     80224a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802224:	6a 07                	push   $0x7
  802226:	68 00 70 80 00       	push   $0x807000
  80222b:	53                   	push   %ebx
  80222c:	ff 35 04 50 80 00    	pushl  0x805004
  802232:	e8 d4 f4 ff ff       	call   80170b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802237:	83 c4 0c             	add    $0xc,%esp
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	e8 5d f4 ff ff       	call   8016a2 <ipc_recv>
}
  802245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802248:	c9                   	leave  
  802249:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80224a:	83 ec 0c             	sub    $0xc,%esp
  80224d:	6a 02                	push   $0x2
  80224f:	e8 0f f5 ff ff       	call   801763 <ipc_find_env>
  802254:	a3 04 50 80 00       	mov    %eax,0x805004
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	eb c6                	jmp    802224 <nsipc+0x12>

0080225e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	56                   	push   %esi
  802262:	53                   	push   %ebx
  802263:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80226e:	8b 06                	mov    (%esi),%eax
  802270:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802275:	b8 01 00 00 00       	mov    $0x1,%eax
  80227a:	e8 93 ff ff ff       	call   802212 <nsipc>
  80227f:	89 c3                	mov    %eax,%ebx
  802281:	85 c0                	test   %eax,%eax
  802283:	79 09                	jns    80228e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802285:	89 d8                	mov    %ebx,%eax
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	ff 35 10 70 80 00    	pushl  0x807010
  802297:	68 00 70 80 00       	push   $0x807000
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	e8 de e9 ff ff       	call   800c82 <memmove>
		*addrlen = ret->ret_addrlen;
  8022a4:	a1 10 70 80 00       	mov    0x807010,%eax
  8022a9:	89 06                	mov    %eax,(%esi)
  8022ab:	83 c4 10             	add    $0x10,%esp
	return r;
  8022ae:	eb d5                	jmp    802285 <nsipc_accept+0x27>

008022b0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 08             	sub    $0x8,%esp
  8022b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022c2:	53                   	push   %ebx
  8022c3:	ff 75 0c             	pushl  0xc(%ebp)
  8022c6:	68 04 70 80 00       	push   $0x807004
  8022cb:	e8 b2 e9 ff ff       	call   800c82 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022d0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022d6:	b8 02 00 00 00       	mov    $0x2,%eax
  8022db:	e8 32 ff ff ff       	call   802212 <nsipc>
}
  8022e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022fb:	b8 03 00 00 00       	mov    $0x3,%eax
  802300:	e8 0d ff ff ff       	call   802212 <nsipc>
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <nsipc_close>:

int
nsipc_close(int s)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802315:	b8 04 00 00 00       	mov    $0x4,%eax
  80231a:	e8 f3 fe ff ff       	call   802212 <nsipc>
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	53                   	push   %ebx
  802325:	83 ec 08             	sub    $0x8,%esp
  802328:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802333:	53                   	push   %ebx
  802334:	ff 75 0c             	pushl  0xc(%ebp)
  802337:	68 04 70 80 00       	push   $0x807004
  80233c:	e8 41 e9 ff ff       	call   800c82 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802341:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802347:	b8 05 00 00 00       	mov    $0x5,%eax
  80234c:	e8 c1 fe ff ff       	call   802212 <nsipc>
}
  802351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80236c:	b8 06 00 00 00       	mov    $0x6,%eax
  802371:	e8 9c fe ff ff       	call   802212 <nsipc>
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	56                   	push   %esi
  80237c:	53                   	push   %ebx
  80237d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802388:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80238e:	8b 45 14             	mov    0x14(%ebp),%eax
  802391:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802396:	b8 07 00 00 00       	mov    $0x7,%eax
  80239b:	e8 72 fe ff ff       	call   802212 <nsipc>
  8023a0:	89 c3                	mov    %eax,%ebx
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 1f                	js     8023c5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023a6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023ab:	7f 21                	jg     8023ce <nsipc_recv+0x56>
  8023ad:	39 c6                	cmp    %eax,%esi
  8023af:	7c 1d                	jl     8023ce <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	50                   	push   %eax
  8023b5:	68 00 70 80 00       	push   $0x807000
  8023ba:	ff 75 0c             	pushl  0xc(%ebp)
  8023bd:	e8 c0 e8 ff ff       	call   800c82 <memmove>
  8023c2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023c5:	89 d8                	mov    %ebx,%eax
  8023c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023ce:	68 0f 33 80 00       	push   $0x80330f
  8023d3:	68 d7 32 80 00       	push   $0x8032d7
  8023d8:	6a 62                	push   $0x62
  8023da:	68 24 33 80 00       	push   $0x803324
  8023df:	e8 bb de ff ff       	call   80029f <_panic>

008023e4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	53                   	push   %ebx
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023f6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023fc:	7f 2e                	jg     80242c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	53                   	push   %ebx
  802402:	ff 75 0c             	pushl  0xc(%ebp)
  802405:	68 0c 70 80 00       	push   $0x80700c
  80240a:	e8 73 e8 ff ff       	call   800c82 <memmove>
	nsipcbuf.send.req_size = size;
  80240f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802415:	8b 45 14             	mov    0x14(%ebp),%eax
  802418:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80241d:	b8 08 00 00 00       	mov    $0x8,%eax
  802422:	e8 eb fd ff ff       	call   802212 <nsipc>
}
  802427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    
	assert(size < 1600);
  80242c:	68 30 33 80 00       	push   $0x803330
  802431:	68 d7 32 80 00       	push   $0x8032d7
  802436:	6a 6d                	push   $0x6d
  802438:	68 24 33 80 00       	push   $0x803324
  80243d:	e8 5d de ff ff       	call   80029f <_panic>

00802442 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802450:	8b 45 0c             	mov    0xc(%ebp),%eax
  802453:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802458:	8b 45 10             	mov    0x10(%ebp),%eax
  80245b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802460:	b8 09 00 00 00       	mov    $0x9,%eax
  802465:	e8 a8 fd ff ff       	call   802212 <nsipc>
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	56                   	push   %esi
  802470:	53                   	push   %ebx
  802471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802474:	83 ec 0c             	sub    $0xc,%esp
  802477:	ff 75 08             	pushl  0x8(%ebp)
  80247a:	e8 2f f3 ff ff       	call   8017ae <fd2data>
  80247f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802481:	83 c4 08             	add    $0x8,%esp
  802484:	68 3c 33 80 00       	push   $0x80333c
  802489:	53                   	push   %ebx
  80248a:	e8 65 e6 ff ff       	call   800af4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80248f:	8b 46 04             	mov    0x4(%esi),%eax
  802492:	2b 06                	sub    (%esi),%eax
  802494:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80249a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024a1:	00 00 00 
	stat->st_dev = &devpipe;
  8024a4:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024ab:	40 80 00 
	return 0;
}
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024b6:	5b                   	pop    %ebx
  8024b7:	5e                   	pop    %esi
  8024b8:	5d                   	pop    %ebp
  8024b9:	c3                   	ret    

008024ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	53                   	push   %ebx
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024c4:	53                   	push   %ebx
  8024c5:	6a 00                	push   $0x0
  8024c7:	e8 9f ea ff ff       	call   800f6b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024cc:	89 1c 24             	mov    %ebx,(%esp)
  8024cf:	e8 da f2 ff ff       	call   8017ae <fd2data>
  8024d4:	83 c4 08             	add    $0x8,%esp
  8024d7:	50                   	push   %eax
  8024d8:	6a 00                	push   $0x0
  8024da:	e8 8c ea ff ff       	call   800f6b <sys_page_unmap>
}
  8024df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <_pipeisclosed>:
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	57                   	push   %edi
  8024e8:	56                   	push   %esi
  8024e9:	53                   	push   %ebx
  8024ea:	83 ec 1c             	sub    $0x1c,%esp
  8024ed:	89 c7                	mov    %eax,%edi
  8024ef:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8024f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	57                   	push   %edi
  8024fd:	e8 c8 fa ff ff       	call   801fca <pageref>
  802502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802505:	89 34 24             	mov    %esi,(%esp)
  802508:	e8 bd fa ff ff       	call   801fca <pageref>
		nn = thisenv->env_runs;
  80250d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802513:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	39 cb                	cmp    %ecx,%ebx
  80251b:	74 1b                	je     802538 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80251d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802520:	75 cf                	jne    8024f1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802522:	8b 42 58             	mov    0x58(%edx),%eax
  802525:	6a 01                	push   $0x1
  802527:	50                   	push   %eax
  802528:	53                   	push   %ebx
  802529:	68 43 33 80 00       	push   $0x803343
  80252e:	e8 62 de ff ff       	call   800395 <cprintf>
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	eb b9                	jmp    8024f1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802538:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80253b:	0f 94 c0             	sete   %al
  80253e:	0f b6 c0             	movzbl %al,%eax
}
  802541:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802544:	5b                   	pop    %ebx
  802545:	5e                   	pop    %esi
  802546:	5f                   	pop    %edi
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <devpipe_write>:
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	57                   	push   %edi
  80254d:	56                   	push   %esi
  80254e:	53                   	push   %ebx
  80254f:	83 ec 28             	sub    $0x28,%esp
  802552:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802555:	56                   	push   %esi
  802556:	e8 53 f2 ff ff       	call   8017ae <fd2data>
  80255b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	bf 00 00 00 00       	mov    $0x0,%edi
  802565:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802568:	74 4f                	je     8025b9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80256a:	8b 43 04             	mov    0x4(%ebx),%eax
  80256d:	8b 0b                	mov    (%ebx),%ecx
  80256f:	8d 51 20             	lea    0x20(%ecx),%edx
  802572:	39 d0                	cmp    %edx,%eax
  802574:	72 14                	jb     80258a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802576:	89 da                	mov    %ebx,%edx
  802578:	89 f0                	mov    %esi,%eax
  80257a:	e8 65 ff ff ff       	call   8024e4 <_pipeisclosed>
  80257f:	85 c0                	test   %eax,%eax
  802581:	75 3b                	jne    8025be <devpipe_write+0x75>
			sys_yield();
  802583:	e8 3f e9 ff ff       	call   800ec7 <sys_yield>
  802588:	eb e0                	jmp    80256a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80258a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80258d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802591:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802594:	89 c2                	mov    %eax,%edx
  802596:	c1 fa 1f             	sar    $0x1f,%edx
  802599:	89 d1                	mov    %edx,%ecx
  80259b:	c1 e9 1b             	shr    $0x1b,%ecx
  80259e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025a1:	83 e2 1f             	and    $0x1f,%edx
  8025a4:	29 ca                	sub    %ecx,%edx
  8025a6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025ae:	83 c0 01             	add    $0x1,%eax
  8025b1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025b4:	83 c7 01             	add    $0x1,%edi
  8025b7:	eb ac                	jmp    802565 <devpipe_write+0x1c>
	return i;
  8025b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bc:	eb 05                	jmp    8025c3 <devpipe_write+0x7a>
				return 0;
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c6:	5b                   	pop    %ebx
  8025c7:	5e                   	pop    %esi
  8025c8:	5f                   	pop    %edi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <devpipe_read>:
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	57                   	push   %edi
  8025cf:	56                   	push   %esi
  8025d0:	53                   	push   %ebx
  8025d1:	83 ec 18             	sub    $0x18,%esp
  8025d4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025d7:	57                   	push   %edi
  8025d8:	e8 d1 f1 ff ff       	call   8017ae <fd2data>
  8025dd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	be 00 00 00 00       	mov    $0x0,%esi
  8025e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ea:	75 14                	jne    802600 <devpipe_read+0x35>
	return i;
  8025ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ef:	eb 02                	jmp    8025f3 <devpipe_read+0x28>
				return i;
  8025f1:	89 f0                	mov    %esi,%eax
}
  8025f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f6:	5b                   	pop    %ebx
  8025f7:	5e                   	pop    %esi
  8025f8:	5f                   	pop    %edi
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
			sys_yield();
  8025fb:	e8 c7 e8 ff ff       	call   800ec7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802600:	8b 03                	mov    (%ebx),%eax
  802602:	3b 43 04             	cmp    0x4(%ebx),%eax
  802605:	75 18                	jne    80261f <devpipe_read+0x54>
			if (i > 0)
  802607:	85 f6                	test   %esi,%esi
  802609:	75 e6                	jne    8025f1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80260b:	89 da                	mov    %ebx,%edx
  80260d:	89 f8                	mov    %edi,%eax
  80260f:	e8 d0 fe ff ff       	call   8024e4 <_pipeisclosed>
  802614:	85 c0                	test   %eax,%eax
  802616:	74 e3                	je     8025fb <devpipe_read+0x30>
				return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	eb d4                	jmp    8025f3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80261f:	99                   	cltd   
  802620:	c1 ea 1b             	shr    $0x1b,%edx
  802623:	01 d0                	add    %edx,%eax
  802625:	83 e0 1f             	and    $0x1f,%eax
  802628:	29 d0                	sub    %edx,%eax
  80262a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80262f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802632:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802635:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802638:	83 c6 01             	add    $0x1,%esi
  80263b:	eb aa                	jmp    8025e7 <devpipe_read+0x1c>

0080263d <pipe>:
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	56                   	push   %esi
  802641:	53                   	push   %ebx
  802642:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802645:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802648:	50                   	push   %eax
  802649:	e8 77 f1 ff ff       	call   8017c5 <fd_alloc>
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	85 c0                	test   %eax,%eax
  802655:	0f 88 23 01 00 00    	js     80277e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 07 04 00 00       	push   $0x407
  802663:	ff 75 f4             	pushl  -0xc(%ebp)
  802666:	6a 00                	push   $0x0
  802668:	e8 79 e8 ff ff       	call   800ee6 <sys_page_alloc>
  80266d:	89 c3                	mov    %eax,%ebx
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	85 c0                	test   %eax,%eax
  802674:	0f 88 04 01 00 00    	js     80277e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802680:	50                   	push   %eax
  802681:	e8 3f f1 ff ff       	call   8017c5 <fd_alloc>
  802686:	89 c3                	mov    %eax,%ebx
  802688:	83 c4 10             	add    $0x10,%esp
  80268b:	85 c0                	test   %eax,%eax
  80268d:	0f 88 db 00 00 00    	js     80276e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802693:	83 ec 04             	sub    $0x4,%esp
  802696:	68 07 04 00 00       	push   $0x407
  80269b:	ff 75 f0             	pushl  -0x10(%ebp)
  80269e:	6a 00                	push   $0x0
  8026a0:	e8 41 e8 ff ff       	call   800ee6 <sys_page_alloc>
  8026a5:	89 c3                	mov    %eax,%ebx
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	0f 88 bc 00 00 00    	js     80276e <pipe+0x131>
	va = fd2data(fd0);
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b8:	e8 f1 f0 ff ff       	call   8017ae <fd2data>
  8026bd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026bf:	83 c4 0c             	add    $0xc,%esp
  8026c2:	68 07 04 00 00       	push   $0x407
  8026c7:	50                   	push   %eax
  8026c8:	6a 00                	push   $0x0
  8026ca:	e8 17 e8 ff ff       	call   800ee6 <sys_page_alloc>
  8026cf:	89 c3                	mov    %eax,%ebx
  8026d1:	83 c4 10             	add    $0x10,%esp
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	0f 88 82 00 00 00    	js     80275e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	ff 75 f0             	pushl  -0x10(%ebp)
  8026e2:	e8 c7 f0 ff ff       	call   8017ae <fd2data>
  8026e7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026ee:	50                   	push   %eax
  8026ef:	6a 00                	push   $0x0
  8026f1:	56                   	push   %esi
  8026f2:	6a 00                	push   $0x0
  8026f4:	e8 30 e8 ff ff       	call   800f29 <sys_page_map>
  8026f9:	89 c3                	mov    %eax,%ebx
  8026fb:	83 c4 20             	add    $0x20,%esp
  8026fe:	85 c0                	test   %eax,%eax
  802700:	78 4e                	js     802750 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802702:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80270c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802719:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802725:	83 ec 0c             	sub    $0xc,%esp
  802728:	ff 75 f4             	pushl  -0xc(%ebp)
  80272b:	e8 6e f0 ff ff       	call   80179e <fd2num>
  802730:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802733:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802735:	83 c4 04             	add    $0x4,%esp
  802738:	ff 75 f0             	pushl  -0x10(%ebp)
  80273b:	e8 5e f0 ff ff       	call   80179e <fd2num>
  802740:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802743:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	bb 00 00 00 00       	mov    $0x0,%ebx
  80274e:	eb 2e                	jmp    80277e <pipe+0x141>
	sys_page_unmap(0, va);
  802750:	83 ec 08             	sub    $0x8,%esp
  802753:	56                   	push   %esi
  802754:	6a 00                	push   $0x0
  802756:	e8 10 e8 ff ff       	call   800f6b <sys_page_unmap>
  80275b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80275e:	83 ec 08             	sub    $0x8,%esp
  802761:	ff 75 f0             	pushl  -0x10(%ebp)
  802764:	6a 00                	push   $0x0
  802766:	e8 00 e8 ff ff       	call   800f6b <sys_page_unmap>
  80276b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80276e:	83 ec 08             	sub    $0x8,%esp
  802771:	ff 75 f4             	pushl  -0xc(%ebp)
  802774:	6a 00                	push   $0x0
  802776:	e8 f0 e7 ff ff       	call   800f6b <sys_page_unmap>
  80277b:	83 c4 10             	add    $0x10,%esp
}
  80277e:	89 d8                	mov    %ebx,%eax
  802780:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802783:	5b                   	pop    %ebx
  802784:	5e                   	pop    %esi
  802785:	5d                   	pop    %ebp
  802786:	c3                   	ret    

00802787 <pipeisclosed>:
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802790:	50                   	push   %eax
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	e8 7e f0 ff ff       	call   801817 <fd_lookup>
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	85 c0                	test   %eax,%eax
  80279e:	78 18                	js     8027b8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027a0:	83 ec 0c             	sub    $0xc,%esp
  8027a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a6:	e8 03 f0 ff ff       	call   8017ae <fd2data>
	return _pipeisclosed(fd, p);
  8027ab:	89 c2                	mov    %eax,%edx
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	e8 2f fd ff ff       	call   8024e4 <_pipeisclosed>
  8027b5:	83 c4 10             	add    $0x10,%esp
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	c3                   	ret    

008027c0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027c6:	68 5b 33 80 00       	push   $0x80335b
  8027cb:	ff 75 0c             	pushl  0xc(%ebp)
  8027ce:	e8 21 e3 ff ff       	call   800af4 <strcpy>
	return 0;
}
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <devcons_write>:
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	57                   	push   %edi
  8027de:	56                   	push   %esi
  8027df:	53                   	push   %ebx
  8027e0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027e6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027f1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027f4:	73 31                	jae    802827 <devcons_write+0x4d>
		m = n - tot;
  8027f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027f9:	29 f3                	sub    %esi,%ebx
  8027fb:	83 fb 7f             	cmp    $0x7f,%ebx
  8027fe:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802803:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	53                   	push   %ebx
  80280a:	89 f0                	mov    %esi,%eax
  80280c:	03 45 0c             	add    0xc(%ebp),%eax
  80280f:	50                   	push   %eax
  802810:	57                   	push   %edi
  802811:	e8 6c e4 ff ff       	call   800c82 <memmove>
		sys_cputs(buf, m);
  802816:	83 c4 08             	add    $0x8,%esp
  802819:	53                   	push   %ebx
  80281a:	57                   	push   %edi
  80281b:	e8 0a e6 ff ff       	call   800e2a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802820:	01 de                	add    %ebx,%esi
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	eb ca                	jmp    8027f1 <devcons_write+0x17>
}
  802827:	89 f0                	mov    %esi,%eax
  802829:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80282c:	5b                   	pop    %ebx
  80282d:	5e                   	pop    %esi
  80282e:	5f                   	pop    %edi
  80282f:	5d                   	pop    %ebp
  802830:	c3                   	ret    

00802831 <devcons_read>:
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
  802834:	83 ec 08             	sub    $0x8,%esp
  802837:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80283c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802840:	74 21                	je     802863 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802842:	e8 01 e6 ff ff       	call   800e48 <sys_cgetc>
  802847:	85 c0                	test   %eax,%eax
  802849:	75 07                	jne    802852 <devcons_read+0x21>
		sys_yield();
  80284b:	e8 77 e6 ff ff       	call   800ec7 <sys_yield>
  802850:	eb f0                	jmp    802842 <devcons_read+0x11>
	if (c < 0)
  802852:	78 0f                	js     802863 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802854:	83 f8 04             	cmp    $0x4,%eax
  802857:	74 0c                	je     802865 <devcons_read+0x34>
	*(char*)vbuf = c;
  802859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285c:	88 02                	mov    %al,(%edx)
	return 1;
  80285e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    
		return 0;
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	eb f7                	jmp    802863 <devcons_read+0x32>

0080286c <cputchar>:
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802878:	6a 01                	push   $0x1
  80287a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80287d:	50                   	push   %eax
  80287e:	e8 a7 e5 ff ff       	call   800e2a <sys_cputs>
}
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <getchar>:
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
  80288b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80288e:	6a 01                	push   $0x1
  802890:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802893:	50                   	push   %eax
  802894:	6a 00                	push   $0x0
  802896:	e8 ec f1 ff ff       	call   801a87 <read>
	if (r < 0)
  80289b:	83 c4 10             	add    $0x10,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 06                	js     8028a8 <getchar+0x20>
	if (r < 1)
  8028a2:	74 06                	je     8028aa <getchar+0x22>
	return c;
  8028a4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    
		return -E_EOF;
  8028aa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028af:	eb f7                	jmp    8028a8 <getchar+0x20>

008028b1 <iscons>:
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ba:	50                   	push   %eax
  8028bb:	ff 75 08             	pushl  0x8(%ebp)
  8028be:	e8 54 ef ff ff       	call   801817 <fd_lookup>
  8028c3:	83 c4 10             	add    $0x10,%esp
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	78 11                	js     8028db <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d3:	39 10                	cmp    %edx,(%eax)
  8028d5:	0f 94 c0             	sete   %al
  8028d8:	0f b6 c0             	movzbl %al,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <opencons>:
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e6:	50                   	push   %eax
  8028e7:	e8 d9 ee ff ff       	call   8017c5 <fd_alloc>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 3a                	js     80292d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 07 04 00 00       	push   $0x407
  8028fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8028fe:	6a 00                	push   $0x0
  802900:	e8 e1 e5 ff ff       	call   800ee6 <sys_page_alloc>
  802905:	83 c4 10             	add    $0x10,%esp
  802908:	85 c0                	test   %eax,%eax
  80290a:	78 21                	js     80292d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802915:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802921:	83 ec 0c             	sub    $0xc,%esp
  802924:	50                   	push   %eax
  802925:	e8 74 ee ff ff       	call   80179e <fd2num>
  80292a:	83 c4 10             	add    $0x10,%esp
}
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802935:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80293c:	74 0a                	je     802948 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	6a 07                	push   $0x7
  80294d:	68 00 f0 bf ee       	push   $0xeebff000
  802952:	6a 00                	push   $0x0
  802954:	e8 8d e5 ff ff       	call   800ee6 <sys_page_alloc>
		if(r < 0)
  802959:	83 c4 10             	add    $0x10,%esp
  80295c:	85 c0                	test   %eax,%eax
  80295e:	78 2a                	js     80298a <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802960:	83 ec 08             	sub    $0x8,%esp
  802963:	68 9e 29 80 00       	push   $0x80299e
  802968:	6a 00                	push   $0x0
  80296a:	e8 c2 e6 ff ff       	call   801031 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	85 c0                	test   %eax,%eax
  802974:	79 c8                	jns    80293e <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802976:	83 ec 04             	sub    $0x4,%esp
  802979:	68 98 33 80 00       	push   $0x803398
  80297e:	6a 25                	push   $0x25
  802980:	68 d4 33 80 00       	push   $0x8033d4
  802985:	e8 15 d9 ff ff       	call   80029f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80298a:	83 ec 04             	sub    $0x4,%esp
  80298d:	68 68 33 80 00       	push   $0x803368
  802992:	6a 22                	push   $0x22
  802994:	68 d4 33 80 00       	push   $0x8033d4
  802999:	e8 01 d9 ff ff       	call   80029f <_panic>

0080299e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80299e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80299f:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029a4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029a6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029a9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029ad:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029b1:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029b4:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029b6:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029ba:	83 c4 08             	add    $0x8,%esp
	popal
  8029bd:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029be:	83 c4 04             	add    $0x4,%esp
	popfl
  8029c1:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029c2:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029c3:	c3                   	ret    
  8029c4:	66 90                	xchg   %ax,%ax
  8029c6:	66 90                	xchg   %ax,%ax
  8029c8:	66 90                	xchg   %ax,%ax
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__udivdi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	53                   	push   %ebx
  8029d4:	83 ec 1c             	sub    $0x1c,%esp
  8029d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029e7:	85 d2                	test   %edx,%edx
  8029e9:	75 4d                	jne    802a38 <__udivdi3+0x68>
  8029eb:	39 f3                	cmp    %esi,%ebx
  8029ed:	76 19                	jbe    802a08 <__udivdi3+0x38>
  8029ef:	31 ff                	xor    %edi,%edi
  8029f1:	89 e8                	mov    %ebp,%eax
  8029f3:	89 f2                	mov    %esi,%edx
  8029f5:	f7 f3                	div    %ebx
  8029f7:	89 fa                	mov    %edi,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 d9                	mov    %ebx,%ecx
  802a0a:	85 db                	test   %ebx,%ebx
  802a0c:	75 0b                	jne    802a19 <__udivdi3+0x49>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	f7 f3                	div    %ebx
  802a17:	89 c1                	mov    %eax,%ecx
  802a19:	31 d2                	xor    %edx,%edx
  802a1b:	89 f0                	mov    %esi,%eax
  802a1d:	f7 f1                	div    %ecx
  802a1f:	89 c6                	mov    %eax,%esi
  802a21:	89 e8                	mov    %ebp,%eax
  802a23:	89 f7                	mov    %esi,%edi
  802a25:	f7 f1                	div    %ecx
  802a27:	89 fa                	mov    %edi,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	39 f2                	cmp    %esi,%edx
  802a3a:	77 1c                	ja     802a58 <__udivdi3+0x88>
  802a3c:	0f bd fa             	bsr    %edx,%edi
  802a3f:	83 f7 1f             	xor    $0x1f,%edi
  802a42:	75 2c                	jne    802a70 <__udivdi3+0xa0>
  802a44:	39 f2                	cmp    %esi,%edx
  802a46:	72 06                	jb     802a4e <__udivdi3+0x7e>
  802a48:	31 c0                	xor    %eax,%eax
  802a4a:	39 eb                	cmp    %ebp,%ebx
  802a4c:	77 a9                	ja     8029f7 <__udivdi3+0x27>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	eb a2                	jmp    8029f7 <__udivdi3+0x27>
  802a55:	8d 76 00             	lea    0x0(%esi),%esi
  802a58:	31 ff                	xor    %edi,%edi
  802a5a:	31 c0                	xor    %eax,%eax
  802a5c:	89 fa                	mov    %edi,%edx
  802a5e:	83 c4 1c             	add    $0x1c,%esp
  802a61:	5b                   	pop    %ebx
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	b8 20 00 00 00       	mov    $0x20,%eax
  802a77:	29 f8                	sub    %edi,%eax
  802a79:	d3 e2                	shl    %cl,%edx
  802a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a7f:	89 c1                	mov    %eax,%ecx
  802a81:	89 da                	mov    %ebx,%edx
  802a83:	d3 ea                	shr    %cl,%edx
  802a85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a89:	09 d1                	or     %edx,%ecx
  802a8b:	89 f2                	mov    %esi,%edx
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 f9                	mov    %edi,%ecx
  802a93:	d3 e3                	shl    %cl,%ebx
  802a95:	89 c1                	mov    %eax,%ecx
  802a97:	d3 ea                	shr    %cl,%edx
  802a99:	89 f9                	mov    %edi,%ecx
  802a9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a9f:	89 eb                	mov    %ebp,%ebx
  802aa1:	d3 e6                	shl    %cl,%esi
  802aa3:	89 c1                	mov    %eax,%ecx
  802aa5:	d3 eb                	shr    %cl,%ebx
  802aa7:	09 de                	or     %ebx,%esi
  802aa9:	89 f0                	mov    %esi,%eax
  802aab:	f7 74 24 08          	divl   0x8(%esp)
  802aaf:	89 d6                	mov    %edx,%esi
  802ab1:	89 c3                	mov    %eax,%ebx
  802ab3:	f7 64 24 0c          	mull   0xc(%esp)
  802ab7:	39 d6                	cmp    %edx,%esi
  802ab9:	72 15                	jb     802ad0 <__udivdi3+0x100>
  802abb:	89 f9                	mov    %edi,%ecx
  802abd:	d3 e5                	shl    %cl,%ebp
  802abf:	39 c5                	cmp    %eax,%ebp
  802ac1:	73 04                	jae    802ac7 <__udivdi3+0xf7>
  802ac3:	39 d6                	cmp    %edx,%esi
  802ac5:	74 09                	je     802ad0 <__udivdi3+0x100>
  802ac7:	89 d8                	mov    %ebx,%eax
  802ac9:	31 ff                	xor    %edi,%edi
  802acb:	e9 27 ff ff ff       	jmp    8029f7 <__udivdi3+0x27>
  802ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ad3:	31 ff                	xor    %edi,%edi
  802ad5:	e9 1d ff ff ff       	jmp    8029f7 <__udivdi3+0x27>
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	53                   	push   %ebx
  802ae4:	83 ec 1c             	sub    $0x1c,%esp
  802ae7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aef:	8b 74 24 30          	mov    0x30(%esp),%esi
  802af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802af7:	89 da                	mov    %ebx,%edx
  802af9:	85 c0                	test   %eax,%eax
  802afb:	75 43                	jne    802b40 <__umoddi3+0x60>
  802afd:	39 df                	cmp    %ebx,%edi
  802aff:	76 17                	jbe    802b18 <__umoddi3+0x38>
  802b01:	89 f0                	mov    %esi,%eax
  802b03:	f7 f7                	div    %edi
  802b05:	89 d0                	mov    %edx,%eax
  802b07:	31 d2                	xor    %edx,%edx
  802b09:	83 c4 1c             	add    $0x1c,%esp
  802b0c:	5b                   	pop    %ebx
  802b0d:	5e                   	pop    %esi
  802b0e:	5f                   	pop    %edi
  802b0f:	5d                   	pop    %ebp
  802b10:	c3                   	ret    
  802b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 fd                	mov    %edi,%ebp
  802b1a:	85 ff                	test   %edi,%edi
  802b1c:	75 0b                	jne    802b29 <__umoddi3+0x49>
  802b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b23:	31 d2                	xor    %edx,%edx
  802b25:	f7 f7                	div    %edi
  802b27:	89 c5                	mov    %eax,%ebp
  802b29:	89 d8                	mov    %ebx,%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	f7 f5                	div    %ebp
  802b2f:	89 f0                	mov    %esi,%eax
  802b31:	f7 f5                	div    %ebp
  802b33:	89 d0                	mov    %edx,%eax
  802b35:	eb d0                	jmp    802b07 <__umoddi3+0x27>
  802b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3e:	66 90                	xchg   %ax,%ax
  802b40:	89 f1                	mov    %esi,%ecx
  802b42:	39 d8                	cmp    %ebx,%eax
  802b44:	76 0a                	jbe    802b50 <__umoddi3+0x70>
  802b46:	89 f0                	mov    %esi,%eax
  802b48:	83 c4 1c             	add    $0x1c,%esp
  802b4b:	5b                   	pop    %ebx
  802b4c:	5e                   	pop    %esi
  802b4d:	5f                   	pop    %edi
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    
  802b50:	0f bd e8             	bsr    %eax,%ebp
  802b53:	83 f5 1f             	xor    $0x1f,%ebp
  802b56:	75 20                	jne    802b78 <__umoddi3+0x98>
  802b58:	39 d8                	cmp    %ebx,%eax
  802b5a:	0f 82 b0 00 00 00    	jb     802c10 <__umoddi3+0x130>
  802b60:	39 f7                	cmp    %esi,%edi
  802b62:	0f 86 a8 00 00 00    	jbe    802c10 <__umoddi3+0x130>
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	83 c4 1c             	add    $0x1c,%esp
  802b6d:	5b                   	pop    %ebx
  802b6e:	5e                   	pop    %esi
  802b6f:	5f                   	pop    %edi
  802b70:	5d                   	pop    %ebp
  802b71:	c3                   	ret    
  802b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b7f:	29 ea                	sub    %ebp,%edx
  802b81:	d3 e0                	shl    %cl,%eax
  802b83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b87:	89 d1                	mov    %edx,%ecx
  802b89:	89 f8                	mov    %edi,%eax
  802b8b:	d3 e8                	shr    %cl,%eax
  802b8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b99:	09 c1                	or     %eax,%ecx
  802b9b:	89 d8                	mov    %ebx,%eax
  802b9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ba1:	89 e9                	mov    %ebp,%ecx
  802ba3:	d3 e7                	shl    %cl,%edi
  802ba5:	89 d1                	mov    %edx,%ecx
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802baf:	d3 e3                	shl    %cl,%ebx
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	89 d1                	mov    %edx,%ecx
  802bb5:	89 f0                	mov    %esi,%eax
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 fa                	mov    %edi,%edx
  802bbd:	d3 e6                	shl    %cl,%esi
  802bbf:	09 d8                	or     %ebx,%eax
  802bc1:	f7 74 24 08          	divl   0x8(%esp)
  802bc5:	89 d1                	mov    %edx,%ecx
  802bc7:	89 f3                	mov    %esi,%ebx
  802bc9:	f7 64 24 0c          	mull   0xc(%esp)
  802bcd:	89 c6                	mov    %eax,%esi
  802bcf:	89 d7                	mov    %edx,%edi
  802bd1:	39 d1                	cmp    %edx,%ecx
  802bd3:	72 06                	jb     802bdb <__umoddi3+0xfb>
  802bd5:	75 10                	jne    802be7 <__umoddi3+0x107>
  802bd7:	39 c3                	cmp    %eax,%ebx
  802bd9:	73 0c                	jae    802be7 <__umoddi3+0x107>
  802bdb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bdf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802be3:	89 d7                	mov    %edx,%edi
  802be5:	89 c6                	mov    %eax,%esi
  802be7:	89 ca                	mov    %ecx,%edx
  802be9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bee:	29 f3                	sub    %esi,%ebx
  802bf0:	19 fa                	sbb    %edi,%edx
  802bf2:	89 d0                	mov    %edx,%eax
  802bf4:	d3 e0                	shl    %cl,%eax
  802bf6:	89 e9                	mov    %ebp,%ecx
  802bf8:	d3 eb                	shr    %cl,%ebx
  802bfa:	d3 ea                	shr    %cl,%edx
  802bfc:	09 d8                	or     %ebx,%eax
  802bfe:	83 c4 1c             	add    $0x1c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c0d:	8d 76 00             	lea    0x0(%esi),%esi
  802c10:	89 da                	mov    %ebx,%edx
  802c12:	29 fe                	sub    %edi,%esi
  802c14:	19 c2                	sbb    %eax,%edx
  802c16:	89 f1                	mov    %esi,%ecx
  802c18:	89 c8                	mov    %ecx,%eax
  802c1a:	e9 4b ff ff ff       	jmp    802b6a <__umoddi3+0x8a>
