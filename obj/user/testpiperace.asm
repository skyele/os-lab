
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
  80003b:	68 40 2c 80 00       	push   $0x802c40
  800040:	e8 50 03 00 00       	call   800395 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 01 26 00 00       	call   802651 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 66                	js     8000bd <umain+0x8a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 c8 13 00 00       	call   801424 <fork>
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
  800068:	68 9a 2c 80 00       	push   $0x802c9a
  80006d:	e8 23 03 00 00       	call   800395 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800072:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800078:	83 c4 08             	add    $0x8,%esp
  80007b:	56                   	push   %esi
  80007c:	68 a5 2c 80 00       	push   $0x802ca5
  800081:	e8 0f 03 00 00       	call   800395 <cprintf>
	dup(p[0], 10);
  800086:	83 c4 08             	add    $0x8,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	ff 75 f0             	pushl  -0x10(%ebp)
  80008e:	e8 1c 19 00 00       	call   8019af <dup>
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
  8000b3:	e8 f7 18 00 00       	call   8019af <dup>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb e2                	jmp    80009f <umain+0x6c>
		panic("pipe: %e", r);
  8000bd:	50                   	push   %eax
  8000be:	68 59 2c 80 00       	push   $0x802c59
  8000c3:	6a 0d                	push   $0xd
  8000c5:	68 62 2c 80 00       	push   $0x802c62
  8000ca:	e8 d0 01 00 00       	call   80029f <_panic>
		panic("fork: %e", r);
  8000cf:	50                   	push   %eax
  8000d0:	68 76 2c 80 00       	push   $0x802c76
  8000d5:	6a 10                	push   $0x10
  8000d7:	68 62 2c 80 00       	push   $0x802c62
  8000dc:	e8 be 01 00 00       	call   80029f <_panic>
		close(p[1]);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e7:	e8 71 18 00 00       	call   80195d <close>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000f4:	eb 1f                	jmp    800115 <umain+0xe2>
				cprintf("RACE: pipe appears closed\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 7f 2c 80 00       	push   $0x802c7f
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
  80011b:	e8 7b 26 00 00       	call   80279b <pipeisclosed>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	85 c0                	test   %eax,%eax
  800125:	74 e4                	je     80010b <umain+0xd8>
  800127:	eb cd                	jmp    8000f6 <umain+0xc3>
		ipc_recv(0,0,0);
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	6a 00                	push   $0x0
  80012e:	6a 00                	push   $0x0
  800130:	6a 00                	push   $0x0
  800132:	e8 7f 15 00 00       	call   8016b6 <ipc_recv>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	e9 25 ff ff ff       	jmp    800064 <umain+0x31>

	cprintf("child done with loop\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 b0 2c 80 00       	push   $0x802cb0
  800147:	e8 49 02 00 00       	call   800395 <cprintf>
	if (pipeisclosed(p[0]))
  80014c:	83 c4 04             	add    $0x4,%esp
  80014f:	ff 75 f0             	pushl  -0x10(%ebp)
  800152:	e8 44 26 00 00       	call   80279b <pipeisclosed>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	85 c0                	test   %eax,%eax
  80015c:	75 48                	jne    8001a6 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	ff 75 f0             	pushl  -0x10(%ebp)
  800168:	e8 be 16 00 00       	call   80182b <fd_lookup>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	78 46                	js     8001ba <umain+0x187>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 ec             	pushl  -0x14(%ebp)
  80017a:	e8 43 16 00 00       	call   8017c2 <fd2data>
	if (pageref(va) != 3+1)
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 57 1e 00 00       	call   801fde <pageref>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	83 f8 04             	cmp    $0x4,%eax
  80018d:	74 3d                	je     8001cc <umain+0x199>
		cprintf("\nchild detected race\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 de 2c 80 00       	push   $0x802cde
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
  8001a9:	68 0c 2d 80 00       	push   $0x802d0c
  8001ae:	6a 3a                	push   $0x3a
  8001b0:	68 62 2c 80 00       	push   $0x802c62
  8001b5:	e8 e5 00 00 00       	call   80029f <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ba:	50                   	push   %eax
  8001bb:	68 c6 2c 80 00       	push   $0x802cc6
  8001c0:	6a 3c                	push   $0x3c
  8001c2:	68 62 2c 80 00       	push   $0x802c62
  8001c7:	e8 d3 00 00 00       	call   80029f <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	68 c8 00 00 00       	push   $0xc8
  8001d4:	68 f4 2c 80 00       	push   $0x802cf4
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

	cprintf("call umain!\n");
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	68 36 2d 80 00       	push   $0x802d36
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
  80028b:	e8 fa 16 00 00       	call   80198a <close_all>
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
  8002af:	68 7c 2d 80 00       	push   $0x802d7c
  8002b4:	50                   	push   %eax
  8002b5:	68 4d 2d 80 00       	push   $0x802d4d
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
  8002d8:	68 58 2d 80 00       	push   $0x802d58
  8002dd:	e8 b3 00 00 00       	call   800395 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e2:	83 c4 18             	add    $0x18,%esp
  8002e5:	53                   	push   %ebx
  8002e6:	ff 75 10             	pushl  0x10(%ebp)
  8002e9:	e8 56 00 00 00       	call   800344 <vcprintf>
	cprintf("\n");
  8002ee:	c7 04 24 41 2d 80 00 	movl   $0x802d41,(%esp)
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
  800442:	e8 99 25 00 00       	call   8029e0 <__udivdi3>
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
  80046b:	e8 80 26 00 00       	call   802af0 <__umoddi3>
  800470:	83 c4 14             	add    $0x14,%esp
  800473:	0f be 80 83 2d 80 00 	movsbl 0x802d83(%eax),%eax
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
  8005f3:	68 f1 32 80 00       	push   $0x8032f1
  8005f8:	53                   	push   %ebx
  8005f9:	56                   	push   %esi
  8005fa:	e8 a6 fe ff ff       	call   8004a5 <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800602:	89 7d 14             	mov    %edi,0x14(%ebp)
  800605:	e9 fe 02 00 00       	jmp    800908 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80060a:	50                   	push   %eax
  80060b:	68 9b 2d 80 00       	push   $0x802d9b
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
  800632:	b8 94 2d 80 00       	mov    $0x802d94,%eax
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
  8009ca:	bf b9 2e 80 00       	mov    $0x802eb9,%edi
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
  8009f6:	bf f1 2e 80 00       	mov    $0x802ef1,%edi
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

008011bb <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 04             	sub    $0x4,%esp
  8011c2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011c5:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011c7:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011cb:	0f 84 99 00 00 00    	je     80126a <pgfault+0xaf>
  8011d1:	89 c2                	mov    %eax,%edx
  8011d3:	c1 ea 16             	shr    $0x16,%edx
  8011d6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011dd:	f6 c2 01             	test   $0x1,%dl
  8011e0:	0f 84 84 00 00 00    	je     80126a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011e6:	89 c2                	mov    %eax,%edx
  8011e8:	c1 ea 0c             	shr    $0xc,%edx
  8011eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f2:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011f8:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011fe:	75 6a                	jne    80126a <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801200:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801205:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	6a 07                	push   $0x7
  80120c:	68 00 f0 7f 00       	push   $0x7ff000
  801211:	6a 00                	push   $0x0
  801213:	e8 ce fc ff ff       	call   800ee6 <sys_page_alloc>
	if(ret < 0)
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	78 5f                	js     80127e <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	68 00 10 00 00       	push   $0x1000
  801227:	53                   	push   %ebx
  801228:	68 00 f0 7f 00       	push   $0x7ff000
  80122d:	e8 b2 fa ff ff       	call   800ce4 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801232:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801239:	53                   	push   %ebx
  80123a:	6a 00                	push   $0x0
  80123c:	68 00 f0 7f 00       	push   $0x7ff000
  801241:	6a 00                	push   $0x0
  801243:	e8 e1 fc ff ff       	call   800f29 <sys_page_map>
	if(ret < 0)
  801248:	83 c4 20             	add    $0x20,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	78 43                	js     801292 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80124f:	83 ec 08             	sub    $0x8,%esp
  801252:	68 00 f0 7f 00       	push   $0x7ff000
  801257:	6a 00                	push   $0x0
  801259:	e8 0d fd ff ff       	call   800f6b <sys_page_unmap>
	if(ret < 0)
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	78 41                	js     8012a6 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801268:	c9                   	leave  
  801269:	c3                   	ret    
		panic("panic at pgfault()\n");
  80126a:	83 ec 04             	sub    $0x4,%esp
  80126d:	68 2f 31 80 00       	push   $0x80312f
  801272:	6a 26                	push   $0x26
  801274:	68 43 31 80 00       	push   $0x803143
  801279:	e8 21 f0 ff ff       	call   80029f <_panic>
		panic("panic in sys_page_alloc()\n");
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	68 4e 31 80 00       	push   $0x80314e
  801286:	6a 31                	push   $0x31
  801288:	68 43 31 80 00       	push   $0x803143
  80128d:	e8 0d f0 ff ff       	call   80029f <_panic>
		panic("panic in sys_page_map()\n");
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	68 69 31 80 00       	push   $0x803169
  80129a:	6a 36                	push   $0x36
  80129c:	68 43 31 80 00       	push   $0x803143
  8012a1:	e8 f9 ef ff ff       	call   80029f <_panic>
		panic("panic in sys_page_unmap()\n");
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	68 82 31 80 00       	push   $0x803182
  8012ae:	6a 39                	push   $0x39
  8012b0:	68 43 31 80 00       	push   $0x803143
  8012b5:	e8 e5 ef ff ff       	call   80029f <_panic>

008012ba <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	89 c6                	mov    %eax,%esi
  8012c1:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	68 20 32 80 00       	push   $0x803220
  8012cb:	68 51 2d 80 00       	push   $0x802d51
  8012d0:	e8 c0 f0 ff ff       	call   800395 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8012d5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	f6 c4 04             	test   $0x4,%ah
  8012e2:	75 45                	jne    801329 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8012e4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012eb:	83 e0 07             	and    $0x7,%eax
  8012ee:	83 f8 07             	cmp    $0x7,%eax
  8012f1:	74 6e                	je     801361 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012f3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012fa:	25 05 08 00 00       	and    $0x805,%eax
  8012ff:	3d 05 08 00 00       	cmp    $0x805,%eax
  801304:	0f 84 b5 00 00 00    	je     8013bf <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80130a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801311:	83 e0 05             	and    $0x5,%eax
  801314:	83 f8 05             	cmp    $0x5,%eax
  801317:	0f 84 d6 00 00 00    	je     8013f3 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
  801322:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801325:	5b                   	pop    %ebx
  801326:	5e                   	pop    %esi
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801329:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801330:	c1 e3 0c             	shl    $0xc,%ebx
  801333:	83 ec 0c             	sub    $0xc,%esp
  801336:	25 07 0e 00 00       	and    $0xe07,%eax
  80133b:	50                   	push   %eax
  80133c:	53                   	push   %ebx
  80133d:	56                   	push   %esi
  80133e:	53                   	push   %ebx
  80133f:	6a 00                	push   $0x0
  801341:	e8 e3 fb ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  801346:	83 c4 20             	add    $0x20,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	79 d0                	jns    80131d <duppage+0x63>
			panic("sys_page_map() panic\n");
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 9d 31 80 00       	push   $0x80319d
  801355:	6a 55                	push   $0x55
  801357:	68 43 31 80 00       	push   $0x803143
  80135c:	e8 3e ef ff ff       	call   80029f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801361:	c1 e3 0c             	shl    $0xc,%ebx
  801364:	83 ec 0c             	sub    $0xc,%esp
  801367:	68 05 08 00 00       	push   $0x805
  80136c:	53                   	push   %ebx
  80136d:	56                   	push   %esi
  80136e:	53                   	push   %ebx
  80136f:	6a 00                	push   $0x0
  801371:	e8 b3 fb ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  801376:	83 c4 20             	add    $0x20,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 2e                	js     8013ab <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80137d:	83 ec 0c             	sub    $0xc,%esp
  801380:	68 05 08 00 00       	push   $0x805
  801385:	53                   	push   %ebx
  801386:	6a 00                	push   $0x0
  801388:	53                   	push   %ebx
  801389:	6a 00                	push   $0x0
  80138b:	e8 99 fb ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  801390:	83 c4 20             	add    $0x20,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	79 86                	jns    80131d <duppage+0x63>
			panic("sys_page_map() panic\n");
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	68 9d 31 80 00       	push   $0x80319d
  80139f:	6a 60                	push   $0x60
  8013a1:	68 43 31 80 00       	push   $0x803143
  8013a6:	e8 f4 ee ff ff       	call   80029f <_panic>
			panic("sys_page_map() panic\n");
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	68 9d 31 80 00       	push   $0x80319d
  8013b3:	6a 5c                	push   $0x5c
  8013b5:	68 43 31 80 00       	push   $0x803143
  8013ba:	e8 e0 ee ff ff       	call   80029f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013bf:	c1 e3 0c             	shl    $0xc,%ebx
  8013c2:	83 ec 0c             	sub    $0xc,%esp
  8013c5:	68 05 08 00 00       	push   $0x805
  8013ca:	53                   	push   %ebx
  8013cb:	56                   	push   %esi
  8013cc:	53                   	push   %ebx
  8013cd:	6a 00                	push   $0x0
  8013cf:	e8 55 fb ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  8013d4:	83 c4 20             	add    $0x20,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 89 3e ff ff ff    	jns    80131d <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	68 9d 31 80 00       	push   $0x80319d
  8013e7:	6a 67                	push   $0x67
  8013e9:	68 43 31 80 00       	push   $0x803143
  8013ee:	e8 ac ee ff ff       	call   80029f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013f3:	c1 e3 0c             	shl    $0xc,%ebx
  8013f6:	83 ec 0c             	sub    $0xc,%esp
  8013f9:	6a 05                	push   $0x5
  8013fb:	53                   	push   %ebx
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	6a 00                	push   $0x0
  801400:	e8 24 fb ff ff       	call   800f29 <sys_page_map>
		if(r < 0)
  801405:	83 c4 20             	add    $0x20,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	0f 89 0d ff ff ff    	jns    80131d <duppage+0x63>
			panic("sys_page_map() panic\n");
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	68 9d 31 80 00       	push   $0x80319d
  801418:	6a 6e                	push   $0x6e
  80141a:	68 43 31 80 00       	push   $0x803143
  80141f:	e8 7b ee ff ff       	call   80029f <_panic>

00801424 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80142d:	68 bb 11 80 00       	push   $0x8011bb
  801432:	e8 0c 15 00 00       	call   802943 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801437:	b8 07 00 00 00       	mov    $0x7,%eax
  80143c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 27                	js     80146c <fork+0x48>
  801445:	89 c6                	mov    %eax,%esi
  801447:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801449:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80144e:	75 48                	jne    801498 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801450:	e8 53 fa ff ff       	call   800ea8 <sys_getenvid>
  801455:	25 ff 03 00 00       	and    $0x3ff,%eax
  80145a:	c1 e0 07             	shl    $0x7,%eax
  80145d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801462:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801467:	e9 90 00 00 00       	jmp    8014fc <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	68 b4 31 80 00       	push   $0x8031b4
  801474:	68 8d 00 00 00       	push   $0x8d
  801479:	68 43 31 80 00       	push   $0x803143
  80147e:	e8 1c ee ff ff       	call   80029f <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801483:	89 f8                	mov    %edi,%eax
  801485:	e8 30 fe ff ff       	call   8012ba <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80148a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801490:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801496:	74 26                	je     8014be <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801498:	89 d8                	mov    %ebx,%eax
  80149a:	c1 e8 16             	shr    $0x16,%eax
  80149d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014a4:	a8 01                	test   $0x1,%al
  8014a6:	74 e2                	je     80148a <fork+0x66>
  8014a8:	89 da                	mov    %ebx,%edx
  8014aa:	c1 ea 0c             	shr    $0xc,%edx
  8014ad:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014b4:	83 e0 05             	and    $0x5,%eax
  8014b7:	83 f8 05             	cmp    $0x5,%eax
  8014ba:	75 ce                	jne    80148a <fork+0x66>
  8014bc:	eb c5                	jmp    801483 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014be:	83 ec 04             	sub    $0x4,%esp
  8014c1:	6a 07                	push   $0x7
  8014c3:	68 00 f0 bf ee       	push   $0xeebff000
  8014c8:	56                   	push   %esi
  8014c9:	e8 18 fa ff ff       	call   800ee6 <sys_page_alloc>
	if(ret < 0)
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 31                	js     801506 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014d5:	83 ec 08             	sub    $0x8,%esp
  8014d8:	68 b2 29 80 00       	push   $0x8029b2
  8014dd:	56                   	push   %esi
  8014de:	e8 4e fb ff ff       	call   801031 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 33                	js     80151d <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	6a 02                	push   $0x2
  8014ef:	56                   	push   %esi
  8014f0:	e8 b8 fa ff ff       	call   800fad <sys_env_set_status>
	if(ret < 0)
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 38                	js     801534 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014fc:	89 f0                	mov    %esi,%eax
  8014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801501:	5b                   	pop    %ebx
  801502:	5e                   	pop    %esi
  801503:	5f                   	pop    %edi
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801506:	83 ec 04             	sub    $0x4,%esp
  801509:	68 4e 31 80 00       	push   $0x80314e
  80150e:	68 99 00 00 00       	push   $0x99
  801513:	68 43 31 80 00       	push   $0x803143
  801518:	e8 82 ed ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	68 d8 31 80 00       	push   $0x8031d8
  801525:	68 9c 00 00 00       	push   $0x9c
  80152a:	68 43 31 80 00       	push   $0x803143
  80152f:	e8 6b ed ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_status()\n");
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	68 00 32 80 00       	push   $0x803200
  80153c:	68 9f 00 00 00       	push   $0x9f
  801541:	68 43 31 80 00       	push   $0x803143
  801546:	e8 54 ed ff ff       	call   80029f <_panic>

0080154b <sfork>:

// Challenge!
int
sfork(void)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	57                   	push   %edi
  80154f:	56                   	push   %esi
  801550:	53                   	push   %ebx
  801551:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801554:	68 bb 11 80 00       	push   $0x8011bb
  801559:	e8 e5 13 00 00       	call   802943 <set_pgfault_handler>
  80155e:	b8 07 00 00 00       	mov    $0x7,%eax
  801563:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 27                	js     801593 <sfork+0x48>
  80156c:	89 c7                	mov    %eax,%edi
  80156e:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801570:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801575:	75 55                	jne    8015cc <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801577:	e8 2c f9 ff ff       	call   800ea8 <sys_getenvid>
  80157c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801581:	c1 e0 07             	shl    $0x7,%eax
  801584:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801589:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80158e:	e9 d4 00 00 00       	jmp    801667 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	68 b4 31 80 00       	push   $0x8031b4
  80159b:	68 b0 00 00 00       	push   $0xb0
  8015a0:	68 43 31 80 00       	push   $0x803143
  8015a5:	e8 f5 ec ff ff       	call   80029f <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015aa:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	e8 04 fd ff ff       	call   8012ba <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015bc:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015c2:	77 65                	ja     801629 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015c4:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015ca:	74 de                	je     8015aa <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015cc:	89 d8                	mov    %ebx,%eax
  8015ce:	c1 e8 16             	shr    $0x16,%eax
  8015d1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015d8:	a8 01                	test   $0x1,%al
  8015da:	74 da                	je     8015b6 <sfork+0x6b>
  8015dc:	89 da                	mov    %ebx,%edx
  8015de:	c1 ea 0c             	shr    $0xc,%edx
  8015e1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015e8:	83 e0 05             	and    $0x5,%eax
  8015eb:	83 f8 05             	cmp    $0x5,%eax
  8015ee:	75 c6                	jne    8015b6 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015f0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015f7:	c1 e2 0c             	shl    $0xc,%edx
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	83 e0 07             	and    $0x7,%eax
  801600:	50                   	push   %eax
  801601:	52                   	push   %edx
  801602:	56                   	push   %esi
  801603:	52                   	push   %edx
  801604:	6a 00                	push   $0x0
  801606:	e8 1e f9 ff ff       	call   800f29 <sys_page_map>
  80160b:	83 c4 20             	add    $0x20,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	74 a4                	je     8015b6 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 9d 31 80 00       	push   $0x80319d
  80161a:	68 bb 00 00 00       	push   $0xbb
  80161f:	68 43 31 80 00       	push   $0x803143
  801624:	e8 76 ec ff ff       	call   80029f <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	6a 07                	push   $0x7
  80162e:	68 00 f0 bf ee       	push   $0xeebff000
  801633:	57                   	push   %edi
  801634:	e8 ad f8 ff ff       	call   800ee6 <sys_page_alloc>
	if(ret < 0)
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 31                	js     801671 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801640:	83 ec 08             	sub    $0x8,%esp
  801643:	68 b2 29 80 00       	push   $0x8029b2
  801648:	57                   	push   %edi
  801649:	e8 e3 f9 ff ff       	call   801031 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 33                	js     801688 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	6a 02                	push   $0x2
  80165a:	57                   	push   %edi
  80165b:	e8 4d f9 ff ff       	call   800fad <sys_env_set_status>
	if(ret < 0)
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	78 38                	js     80169f <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801667:	89 f8                	mov    %edi,%eax
  801669:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5f                   	pop    %edi
  80166f:	5d                   	pop    %ebp
  801670:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 4e 31 80 00       	push   $0x80314e
  801679:	68 c1 00 00 00       	push   $0xc1
  80167e:	68 43 31 80 00       	push   $0x803143
  801683:	e8 17 ec ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 d8 31 80 00       	push   $0x8031d8
  801690:	68 c4 00 00 00       	push   $0xc4
  801695:	68 43 31 80 00       	push   $0x803143
  80169a:	e8 00 ec ff ff       	call   80029f <_panic>
		panic("panic in sys_env_set_status()\n");
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	68 00 32 80 00       	push   $0x803200
  8016a7:	68 c7 00 00 00       	push   $0xc7
  8016ac:	68 43 31 80 00       	push   $0x803143
  8016b1:	e8 e9 eb ff ff       	call   80029f <_panic>

008016b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
  8016bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8016be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8016c4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8016c6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016cb:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016ce:	83 ec 0c             	sub    $0xc,%esp
  8016d1:	50                   	push   %eax
  8016d2:	e8 bf f9 ff ff       	call   801096 <sys_ipc_recv>
	if(ret < 0){
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 2b                	js     801709 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016de:	85 f6                	test   %esi,%esi
  8016e0:	74 0a                	je     8016ec <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8016e2:	a1 08 50 80 00       	mov    0x805008,%eax
  8016e7:	8b 40 74             	mov    0x74(%eax),%eax
  8016ea:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016ec:	85 db                	test   %ebx,%ebx
  8016ee:	74 0a                	je     8016fa <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8016f0:	a1 08 50 80 00       	mov    0x805008,%eax
  8016f5:	8b 40 78             	mov    0x78(%eax),%eax
  8016f8:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8016fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ff:	8b 40 70             	mov    0x70(%eax),%eax
}
  801702:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5d                   	pop    %ebp
  801708:	c3                   	ret    
		if(from_env_store)
  801709:	85 f6                	test   %esi,%esi
  80170b:	74 06                	je     801713 <ipc_recv+0x5d>
			*from_env_store = 0;
  80170d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801713:	85 db                	test   %ebx,%ebx
  801715:	74 eb                	je     801702 <ipc_recv+0x4c>
			*perm_store = 0;
  801717:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80171d:	eb e3                	jmp    801702 <ipc_recv+0x4c>

0080171f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	57                   	push   %edi
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	8b 7d 08             	mov    0x8(%ebp),%edi
  80172b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80172e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801731:	85 db                	test   %ebx,%ebx
  801733:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801738:	0f 44 d8             	cmove  %eax,%ebx
  80173b:	eb 05                	jmp    801742 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80173d:	e8 85 f7 ff ff       	call   800ec7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801742:	ff 75 14             	pushl  0x14(%ebp)
  801745:	53                   	push   %ebx
  801746:	56                   	push   %esi
  801747:	57                   	push   %edi
  801748:	e8 26 f9 ff ff       	call   801073 <sys_ipc_try_send>
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	74 1b                	je     80176f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801754:	79 e7                	jns    80173d <ipc_send+0x1e>
  801756:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801759:	74 e2                	je     80173d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 28 32 80 00       	push   $0x803228
  801763:	6a 48                	push   $0x48
  801765:	68 3d 32 80 00       	push   $0x80323d
  80176a:	e8 30 eb ff ff       	call   80029f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80176f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801772:	5b                   	pop    %ebx
  801773:	5e                   	pop    %esi
  801774:	5f                   	pop    %edi
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801782:	89 c2                	mov    %eax,%edx
  801784:	c1 e2 07             	shl    $0x7,%edx
  801787:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80178d:	8b 52 50             	mov    0x50(%edx),%edx
  801790:	39 ca                	cmp    %ecx,%edx
  801792:	74 11                	je     8017a5 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801794:	83 c0 01             	add    $0x1,%eax
  801797:	3d 00 04 00 00       	cmp    $0x400,%eax
  80179c:	75 e4                	jne    801782 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	eb 0b                	jmp    8017b0 <ipc_find_env+0x39>
			return envs[i].env_id;
  8017a5:	c1 e0 07             	shl    $0x7,%eax
  8017a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017ad:	8b 40 48             	mov    0x48(%eax),%eax
}
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    

008017b2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	05 00 00 00 30       	add    $0x30000000,%eax
  8017bd:	c1 e8 0c             	shr    $0xc,%eax
}
  8017c0:	5d                   	pop    %ebp
  8017c1:	c3                   	ret    

008017c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017d7:	5d                   	pop    %ebp
  8017d8:	c3                   	ret    

008017d9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017e1:	89 c2                	mov    %eax,%edx
  8017e3:	c1 ea 16             	shr    $0x16,%edx
  8017e6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ed:	f6 c2 01             	test   $0x1,%dl
  8017f0:	74 2d                	je     80181f <fd_alloc+0x46>
  8017f2:	89 c2                	mov    %eax,%edx
  8017f4:	c1 ea 0c             	shr    $0xc,%edx
  8017f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017fe:	f6 c2 01             	test   $0x1,%dl
  801801:	74 1c                	je     80181f <fd_alloc+0x46>
  801803:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801808:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80180d:	75 d2                	jne    8017e1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801818:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80181d:	eb 0a                	jmp    801829 <fd_alloc+0x50>
			*fd_store = fd;
  80181f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801822:	89 01                	mov    %eax,(%ecx)
			return 0;
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    

0080182b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801831:	83 f8 1f             	cmp    $0x1f,%eax
  801834:	77 30                	ja     801866 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801836:	c1 e0 0c             	shl    $0xc,%eax
  801839:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80183e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801844:	f6 c2 01             	test   $0x1,%dl
  801847:	74 24                	je     80186d <fd_lookup+0x42>
  801849:	89 c2                	mov    %eax,%edx
  80184b:	c1 ea 0c             	shr    $0xc,%edx
  80184e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801855:	f6 c2 01             	test   $0x1,%dl
  801858:	74 1a                	je     801874 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	89 02                	mov    %eax,(%edx)
	return 0;
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    
		return -E_INVAL;
  801866:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186b:	eb f7                	jmp    801864 <fd_lookup+0x39>
		return -E_INVAL;
  80186d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801872:	eb f0                	jmp    801864 <fd_lookup+0x39>
  801874:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801879:	eb e9                	jmp    801864 <fd_lookup+0x39>

0080187b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801884:	ba 00 00 00 00       	mov    $0x0,%edx
  801889:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80188e:	39 08                	cmp    %ecx,(%eax)
  801890:	74 38                	je     8018ca <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801892:	83 c2 01             	add    $0x1,%edx
  801895:	8b 04 95 c4 32 80 00 	mov    0x8032c4(,%edx,4),%eax
  80189c:	85 c0                	test   %eax,%eax
  80189e:	75 ee                	jne    80188e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018a0:	a1 08 50 80 00       	mov    0x805008,%eax
  8018a5:	8b 40 48             	mov    0x48(%eax),%eax
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	51                   	push   %ecx
  8018ac:	50                   	push   %eax
  8018ad:	68 48 32 80 00       	push   $0x803248
  8018b2:	e8 de ea ff ff       	call   800395 <cprintf>
	*dev = 0;
  8018b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    
			*dev = devtab[i];
  8018ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018cd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	eb f2                	jmp    8018c8 <dev_lookup+0x4d>

008018d6 <fd_close>:
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	57                   	push   %edi
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	83 ec 24             	sub    $0x24,%esp
  8018df:	8b 75 08             	mov    0x8(%ebp),%esi
  8018e2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018e8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018e9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018ef:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018f2:	50                   	push   %eax
  8018f3:	e8 33 ff ff ff       	call   80182b <fd_lookup>
  8018f8:	89 c3                	mov    %eax,%ebx
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	78 05                	js     801906 <fd_close+0x30>
	    || fd != fd2)
  801901:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801904:	74 16                	je     80191c <fd_close+0x46>
		return (must_exist ? r : 0);
  801906:	89 f8                	mov    %edi,%eax
  801908:	84 c0                	test   %al,%al
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
  80190f:	0f 44 d8             	cmove  %eax,%ebx
}
  801912:	89 d8                	mov    %ebx,%eax
  801914:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801922:	50                   	push   %eax
  801923:	ff 36                	pushl  (%esi)
  801925:	e8 51 ff ff ff       	call   80187b <dev_lookup>
  80192a:	89 c3                	mov    %eax,%ebx
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 1a                	js     80194d <fd_close+0x77>
		if (dev->dev_close)
  801933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801936:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801939:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80193e:	85 c0                	test   %eax,%eax
  801940:	74 0b                	je     80194d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801942:	83 ec 0c             	sub    $0xc,%esp
  801945:	56                   	push   %esi
  801946:	ff d0                	call   *%eax
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	56                   	push   %esi
  801951:	6a 00                	push   $0x0
  801953:	e8 13 f6 ff ff       	call   800f6b <sys_page_unmap>
	return r;
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	eb b5                	jmp    801912 <fd_close+0x3c>

0080195d <close>:

int
close(int fdnum)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801963:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801966:	50                   	push   %eax
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	e8 bc fe ff ff       	call   80182b <fd_lookup>
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	85 c0                	test   %eax,%eax
  801974:	79 02                	jns    801978 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    
		return fd_close(fd, 1);
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	6a 01                	push   $0x1
  80197d:	ff 75 f4             	pushl  -0xc(%ebp)
  801980:	e8 51 ff ff ff       	call   8018d6 <fd_close>
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	eb ec                	jmp    801976 <close+0x19>

0080198a <close_all>:

void
close_all(void)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	53                   	push   %ebx
  80198e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801991:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	53                   	push   %ebx
  80199a:	e8 be ff ff ff       	call   80195d <close>
	for (i = 0; i < MAXFD; i++)
  80199f:	83 c3 01             	add    $0x1,%ebx
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	83 fb 20             	cmp    $0x20,%ebx
  8019a8:	75 ec                	jne    801996 <close_all+0xc>
}
  8019aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	57                   	push   %edi
  8019b3:	56                   	push   %esi
  8019b4:	53                   	push   %ebx
  8019b5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019bb:	50                   	push   %eax
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	e8 67 fe ff ff       	call   80182b <fd_lookup>
  8019c4:	89 c3                	mov    %eax,%ebx
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	0f 88 81 00 00 00    	js     801a52 <dup+0xa3>
		return r;
	close(newfdnum);
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 81 ff ff ff       	call   80195d <close>

	newfd = INDEX2FD(newfdnum);
  8019dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019df:	c1 e6 0c             	shl    $0xc,%esi
  8019e2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019e8:	83 c4 04             	add    $0x4,%esp
  8019eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ee:	e8 cf fd ff ff       	call   8017c2 <fd2data>
  8019f3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019f5:	89 34 24             	mov    %esi,(%esp)
  8019f8:	e8 c5 fd ff ff       	call   8017c2 <fd2data>
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a02:	89 d8                	mov    %ebx,%eax
  801a04:	c1 e8 16             	shr    $0x16,%eax
  801a07:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a0e:	a8 01                	test   $0x1,%al
  801a10:	74 11                	je     801a23 <dup+0x74>
  801a12:	89 d8                	mov    %ebx,%eax
  801a14:	c1 e8 0c             	shr    $0xc,%eax
  801a17:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a1e:	f6 c2 01             	test   $0x1,%dl
  801a21:	75 39                	jne    801a5c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a26:	89 d0                	mov    %edx,%eax
  801a28:	c1 e8 0c             	shr    $0xc,%eax
  801a2b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	25 07 0e 00 00       	and    $0xe07,%eax
  801a3a:	50                   	push   %eax
  801a3b:	56                   	push   %esi
  801a3c:	6a 00                	push   $0x0
  801a3e:	52                   	push   %edx
  801a3f:	6a 00                	push   $0x0
  801a41:	e8 e3 f4 ff ff       	call   800f29 <sys_page_map>
  801a46:	89 c3                	mov    %eax,%ebx
  801a48:	83 c4 20             	add    $0x20,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 31                	js     801a80 <dup+0xd1>
		goto err;

	return newfdnum;
  801a4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a52:	89 d8                	mov    %ebx,%eax
  801a54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a5c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	25 07 0e 00 00       	and    $0xe07,%eax
  801a6b:	50                   	push   %eax
  801a6c:	57                   	push   %edi
  801a6d:	6a 00                	push   $0x0
  801a6f:	53                   	push   %ebx
  801a70:	6a 00                	push   $0x0
  801a72:	e8 b2 f4 ff ff       	call   800f29 <sys_page_map>
  801a77:	89 c3                	mov    %eax,%ebx
  801a79:	83 c4 20             	add    $0x20,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	79 a3                	jns    801a23 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	56                   	push   %esi
  801a84:	6a 00                	push   $0x0
  801a86:	e8 e0 f4 ff ff       	call   800f6b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a8b:	83 c4 08             	add    $0x8,%esp
  801a8e:	57                   	push   %edi
  801a8f:	6a 00                	push   $0x0
  801a91:	e8 d5 f4 ff ff       	call   800f6b <sys_page_unmap>
	return r;
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	eb b7                	jmp    801a52 <dup+0xa3>

00801a9b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	53                   	push   %ebx
  801a9f:	83 ec 1c             	sub    $0x1c,%esp
  801aa2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa8:	50                   	push   %eax
  801aa9:	53                   	push   %ebx
  801aaa:	e8 7c fd ff ff       	call   80182b <fd_lookup>
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 3f                	js     801af5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abc:	50                   	push   %eax
  801abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac0:	ff 30                	pushl  (%eax)
  801ac2:	e8 b4 fd ff ff       	call   80187b <dev_lookup>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 27                	js     801af5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad1:	8b 42 08             	mov    0x8(%edx),%eax
  801ad4:	83 e0 03             	and    $0x3,%eax
  801ad7:	83 f8 01             	cmp    $0x1,%eax
  801ada:	74 1e                	je     801afa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adf:	8b 40 08             	mov    0x8(%eax),%eax
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	74 35                	je     801b1b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	ff 75 10             	pushl  0x10(%ebp)
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	52                   	push   %edx
  801af0:	ff d0                	call   *%eax
  801af2:	83 c4 10             	add    $0x10,%esp
}
  801af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801afa:	a1 08 50 80 00       	mov    0x805008,%eax
  801aff:	8b 40 48             	mov    0x48(%eax),%eax
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	53                   	push   %ebx
  801b06:	50                   	push   %eax
  801b07:	68 89 32 80 00       	push   $0x803289
  801b0c:	e8 84 e8 ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b19:	eb da                	jmp    801af5 <read+0x5a>
		return -E_NOT_SUPP;
  801b1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b20:	eb d3                	jmp    801af5 <read+0x5a>

00801b22 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	57                   	push   %edi
  801b26:	56                   	push   %esi
  801b27:	53                   	push   %ebx
  801b28:	83 ec 0c             	sub    $0xc,%esp
  801b2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b2e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b31:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b36:	39 f3                	cmp    %esi,%ebx
  801b38:	73 23                	jae    801b5d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	89 f0                	mov    %esi,%eax
  801b3f:	29 d8                	sub    %ebx,%eax
  801b41:	50                   	push   %eax
  801b42:	89 d8                	mov    %ebx,%eax
  801b44:	03 45 0c             	add    0xc(%ebp),%eax
  801b47:	50                   	push   %eax
  801b48:	57                   	push   %edi
  801b49:	e8 4d ff ff ff       	call   801a9b <read>
		if (m < 0)
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 06                	js     801b5b <readn+0x39>
			return m;
		if (m == 0)
  801b55:	74 06                	je     801b5d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b57:	01 c3                	add    %eax,%ebx
  801b59:	eb db                	jmp    801b36 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b5b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b5d:	89 d8                	mov    %ebx,%eax
  801b5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    

00801b67 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 1c             	sub    $0x1c,%esp
  801b6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b74:	50                   	push   %eax
  801b75:	53                   	push   %ebx
  801b76:	e8 b0 fc ff ff       	call   80182b <fd_lookup>
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 3a                	js     801bbc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b88:	50                   	push   %eax
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	ff 30                	pushl  (%eax)
  801b8e:	e8 e8 fc ff ff       	call   80187b <dev_lookup>
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	85 c0                	test   %eax,%eax
  801b98:	78 22                	js     801bbc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ba1:	74 1e                	je     801bc1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba6:	8b 52 0c             	mov    0xc(%edx),%edx
  801ba9:	85 d2                	test   %edx,%edx
  801bab:	74 35                	je     801be2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	ff 75 10             	pushl  0x10(%ebp)
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	ff d2                	call   *%edx
  801bb9:	83 c4 10             	add    $0x10,%esp
}
  801bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bc1:	a1 08 50 80 00       	mov    0x805008,%eax
  801bc6:	8b 40 48             	mov    0x48(%eax),%eax
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	53                   	push   %ebx
  801bcd:	50                   	push   %eax
  801bce:	68 a5 32 80 00       	push   $0x8032a5
  801bd3:	e8 bd e7 ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be0:	eb da                	jmp    801bbc <write+0x55>
		return -E_NOT_SUPP;
  801be2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be7:	eb d3                	jmp    801bbc <write+0x55>

00801be9 <seek>:

int
seek(int fdnum, off_t offset)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf2:	50                   	push   %eax
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	e8 30 fc ff ff       	call   80182b <fd_lookup>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 0e                	js     801c10 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c08:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	53                   	push   %ebx
  801c16:	83 ec 1c             	sub    $0x1c,%esp
  801c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c1f:	50                   	push   %eax
  801c20:	53                   	push   %ebx
  801c21:	e8 05 fc ff ff       	call   80182b <fd_lookup>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 37                	js     801c64 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c33:	50                   	push   %eax
  801c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c37:	ff 30                	pushl  (%eax)
  801c39:	e8 3d fc ff ff       	call   80187b <dev_lookup>
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 1f                	js     801c64 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c48:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c4c:	74 1b                	je     801c69 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c51:	8b 52 18             	mov    0x18(%edx),%edx
  801c54:	85 d2                	test   %edx,%edx
  801c56:	74 32                	je     801c8a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	50                   	push   %eax
  801c5f:	ff d2                	call   *%edx
  801c61:	83 c4 10             	add    $0x10,%esp
}
  801c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c69:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c6e:	8b 40 48             	mov    0x48(%eax),%eax
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	53                   	push   %ebx
  801c75:	50                   	push   %eax
  801c76:	68 68 32 80 00       	push   $0x803268
  801c7b:	e8 15 e7 ff ff       	call   800395 <cprintf>
		return -E_INVAL;
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c88:	eb da                	jmp    801c64 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c8a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c8f:	eb d3                	jmp    801c64 <ftruncate+0x52>

00801c91 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	53                   	push   %ebx
  801c95:	83 ec 1c             	sub    $0x1c,%esp
  801c98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c9e:	50                   	push   %eax
  801c9f:	ff 75 08             	pushl  0x8(%ebp)
  801ca2:	e8 84 fb ff ff       	call   80182b <fd_lookup>
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 4b                	js     801cf9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cae:	83 ec 08             	sub    $0x8,%esp
  801cb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb4:	50                   	push   %eax
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb8:	ff 30                	pushl  (%eax)
  801cba:	e8 bc fb ff ff       	call   80187b <dev_lookup>
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	78 33                	js     801cf9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ccd:	74 2f                	je     801cfe <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ccf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cd2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cd9:	00 00 00 
	stat->st_isdir = 0;
  801cdc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ce3:	00 00 00 
	stat->st_dev = dev;
  801ce6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	53                   	push   %ebx
  801cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf3:	ff 50 14             	call   *0x14(%eax)
  801cf6:	83 c4 10             	add    $0x10,%esp
}
  801cf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    
		return -E_NOT_SUPP;
  801cfe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d03:	eb f4                	jmp    801cf9 <fstat+0x68>

00801d05 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	56                   	push   %esi
  801d09:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d0a:	83 ec 08             	sub    $0x8,%esp
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 08             	pushl  0x8(%ebp)
  801d12:	e8 22 02 00 00       	call   801f39 <open>
  801d17:	89 c3                	mov    %eax,%ebx
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 1b                	js     801d3b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d20:	83 ec 08             	sub    $0x8,%esp
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	50                   	push   %eax
  801d27:	e8 65 ff ff ff       	call   801c91 <fstat>
  801d2c:	89 c6                	mov    %eax,%esi
	close(fd);
  801d2e:	89 1c 24             	mov    %ebx,(%esp)
  801d31:	e8 27 fc ff ff       	call   80195d <close>
	return r;
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	89 f3                	mov    %esi,%ebx
}
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    

00801d44 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	56                   	push   %esi
  801d48:	53                   	push   %ebx
  801d49:	89 c6                	mov    %eax,%esi
  801d4b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d4d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d54:	74 27                	je     801d7d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d56:	6a 07                	push   $0x7
  801d58:	68 00 60 80 00       	push   $0x806000
  801d5d:	56                   	push   %esi
  801d5e:	ff 35 00 50 80 00    	pushl  0x805000
  801d64:	e8 b6 f9 ff ff       	call   80171f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d69:	83 c4 0c             	add    $0xc,%esp
  801d6c:	6a 00                	push   $0x0
  801d6e:	53                   	push   %ebx
  801d6f:	6a 00                	push   $0x0
  801d71:	e8 40 f9 ff ff       	call   8016b6 <ipc_recv>
}
  801d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d79:	5b                   	pop    %ebx
  801d7a:	5e                   	pop    %esi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	6a 01                	push   $0x1
  801d82:	e8 f0 f9 ff ff       	call   801777 <ipc_find_env>
  801d87:	a3 00 50 80 00       	mov    %eax,0x805000
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	eb c5                	jmp    801d56 <fsipc+0x12>

00801d91 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801daa:	ba 00 00 00 00       	mov    $0x0,%edx
  801daf:	b8 02 00 00 00       	mov    $0x2,%eax
  801db4:	e8 8b ff ff ff       	call   801d44 <fsipc>
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <devfile_flush>:
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc7:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd1:	b8 06 00 00 00       	mov    $0x6,%eax
  801dd6:	e8 69 ff ff ff       	call   801d44 <fsipc>
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <devfile_stat>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	53                   	push   %ebx
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801df2:	ba 00 00 00 00       	mov    $0x0,%edx
  801df7:	b8 05 00 00 00       	mov    $0x5,%eax
  801dfc:	e8 43 ff ff ff       	call   801d44 <fsipc>
  801e01:	85 c0                	test   %eax,%eax
  801e03:	78 2c                	js     801e31 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	68 00 60 80 00       	push   $0x806000
  801e0d:	53                   	push   %ebx
  801e0e:	e8 e1 ec ff ff       	call   800af4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e13:	a1 80 60 80 00       	mov    0x806080,%eax
  801e18:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e1e:	a1 84 60 80 00       	mov    0x806084,%eax
  801e23:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <devfile_write>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 08             	sub    $0x8,%esp
  801e3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	8b 40 0c             	mov    0xc(%eax),%eax
  801e46:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e4b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e51:	53                   	push   %ebx
  801e52:	ff 75 0c             	pushl  0xc(%ebp)
  801e55:	68 08 60 80 00       	push   $0x806008
  801e5a:	e8 85 ee ff ff       	call   800ce4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e64:	b8 04 00 00 00       	mov    $0x4,%eax
  801e69:	e8 d6 fe ff ff       	call   801d44 <fsipc>
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	85 c0                	test   %eax,%eax
  801e73:	78 0b                	js     801e80 <devfile_write+0x4a>
	assert(r <= n);
  801e75:	39 d8                	cmp    %ebx,%eax
  801e77:	77 0c                	ja     801e85 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e79:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e7e:	7f 1e                	jg     801e9e <devfile_write+0x68>
}
  801e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    
	assert(r <= n);
  801e85:	68 d8 32 80 00       	push   $0x8032d8
  801e8a:	68 df 32 80 00       	push   $0x8032df
  801e8f:	68 98 00 00 00       	push   $0x98
  801e94:	68 f4 32 80 00       	push   $0x8032f4
  801e99:	e8 01 e4 ff ff       	call   80029f <_panic>
	assert(r <= PGSIZE);
  801e9e:	68 ff 32 80 00       	push   $0x8032ff
  801ea3:	68 df 32 80 00       	push   $0x8032df
  801ea8:	68 99 00 00 00       	push   $0x99
  801ead:	68 f4 32 80 00       	push   $0x8032f4
  801eb2:	e8 e8 e3 ff ff       	call   80029f <_panic>

00801eb7 <devfile_read>:
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	56                   	push   %esi
  801ebb:	53                   	push   %ebx
  801ebc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801eca:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ed0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed5:	b8 03 00 00 00       	mov    $0x3,%eax
  801eda:	e8 65 fe ff ff       	call   801d44 <fsipc>
  801edf:	89 c3                	mov    %eax,%ebx
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	78 1f                	js     801f04 <devfile_read+0x4d>
	assert(r <= n);
  801ee5:	39 f0                	cmp    %esi,%eax
  801ee7:	77 24                	ja     801f0d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ee9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eee:	7f 33                	jg     801f23 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	50                   	push   %eax
  801ef4:	68 00 60 80 00       	push   $0x806000
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	e8 81 ed ff ff       	call   800c82 <memmove>
	return r;
  801f01:	83 c4 10             	add    $0x10,%esp
}
  801f04:	89 d8                	mov    %ebx,%eax
  801f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f09:	5b                   	pop    %ebx
  801f0a:	5e                   	pop    %esi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    
	assert(r <= n);
  801f0d:	68 d8 32 80 00       	push   $0x8032d8
  801f12:	68 df 32 80 00       	push   $0x8032df
  801f17:	6a 7c                	push   $0x7c
  801f19:	68 f4 32 80 00       	push   $0x8032f4
  801f1e:	e8 7c e3 ff ff       	call   80029f <_panic>
	assert(r <= PGSIZE);
  801f23:	68 ff 32 80 00       	push   $0x8032ff
  801f28:	68 df 32 80 00       	push   $0x8032df
  801f2d:	6a 7d                	push   $0x7d
  801f2f:	68 f4 32 80 00       	push   $0x8032f4
  801f34:	e8 66 e3 ff ff       	call   80029f <_panic>

00801f39 <open>:
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	56                   	push   %esi
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 1c             	sub    $0x1c,%esp
  801f41:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f44:	56                   	push   %esi
  801f45:	e8 71 eb ff ff       	call   800abb <strlen>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f52:	7f 6c                	jg     801fc0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5a:	50                   	push   %eax
  801f5b:	e8 79 f8 ff ff       	call   8017d9 <fd_alloc>
  801f60:	89 c3                	mov    %eax,%ebx
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 3c                	js     801fa5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f69:	83 ec 08             	sub    $0x8,%esp
  801f6c:	56                   	push   %esi
  801f6d:	68 00 60 80 00       	push   $0x806000
  801f72:	e8 7d eb ff ff       	call   800af4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f82:	b8 01 00 00 00       	mov    $0x1,%eax
  801f87:	e8 b8 fd ff ff       	call   801d44 <fsipc>
  801f8c:	89 c3                	mov    %eax,%ebx
  801f8e:	83 c4 10             	add    $0x10,%esp
  801f91:	85 c0                	test   %eax,%eax
  801f93:	78 19                	js     801fae <open+0x75>
	return fd2num(fd);
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9b:	e8 12 f8 ff ff       	call   8017b2 <fd2num>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	83 c4 10             	add    $0x10,%esp
}
  801fa5:	89 d8                	mov    %ebx,%eax
  801fa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    
		fd_close(fd, 0);
  801fae:	83 ec 08             	sub    $0x8,%esp
  801fb1:	6a 00                	push   $0x0
  801fb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb6:	e8 1b f9 ff ff       	call   8018d6 <fd_close>
		return r;
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	eb e5                	jmp    801fa5 <open+0x6c>
		return -E_BAD_PATH;
  801fc0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fc5:	eb de                	jmp    801fa5 <open+0x6c>

00801fc7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801fd7:	e8 68 fd ff ff       	call   801d44 <fsipc>
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe4:	89 d0                	mov    %edx,%eax
  801fe6:	c1 e8 16             	shr    $0x16,%eax
  801fe9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ff5:	f6 c1 01             	test   $0x1,%cl
  801ff8:	74 1d                	je     802017 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ffa:	c1 ea 0c             	shr    $0xc,%edx
  801ffd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802004:	f6 c2 01             	test   $0x1,%dl
  802007:	74 0e                	je     802017 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802009:	c1 ea 0c             	shr    $0xc,%edx
  80200c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802013:	ef 
  802014:	0f b7 c0             	movzwl %ax,%eax
}
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80201f:	68 0b 33 80 00       	push   $0x80330b
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	e8 c8 ea ff ff       	call   800af4 <strcpy>
	return 0;
}
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <devsock_close>:
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	53                   	push   %ebx
  802037:	83 ec 10             	sub    $0x10,%esp
  80203a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80203d:	53                   	push   %ebx
  80203e:	e8 9b ff ff ff       	call   801fde <pageref>
  802043:	83 c4 10             	add    $0x10,%esp
		return 0;
  802046:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80204b:	83 f8 01             	cmp    $0x1,%eax
  80204e:	74 07                	je     802057 <devsock_close+0x24>
}
  802050:	89 d0                	mov    %edx,%eax
  802052:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802055:	c9                   	leave  
  802056:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	ff 73 0c             	pushl  0xc(%ebx)
  80205d:	e8 b9 02 00 00       	call   80231b <nsipc_close>
  802062:	89 c2                	mov    %eax,%edx
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	eb e7                	jmp    802050 <devsock_close+0x1d>

00802069 <devsock_write>:
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80206f:	6a 00                	push   $0x0
  802071:	ff 75 10             	pushl  0x10(%ebp)
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	ff 70 0c             	pushl  0xc(%eax)
  80207d:	e8 76 03 00 00       	call   8023f8 <nsipc_send>
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <devsock_read>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	ff 75 10             	pushl  0x10(%ebp)
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	ff 70 0c             	pushl  0xc(%eax)
  802098:	e8 ef 02 00 00       	call   80238c <nsipc_recv>
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <fd2sockid>:
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	e8 7c f7 ff ff       	call   80182b <fd_lookup>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 10                	js     8020c6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020bf:	39 08                	cmp    %ecx,(%eax)
  8020c1:	75 05                	jne    8020c8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020c3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    
		return -E_NOT_SUPP;
  8020c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020cd:	eb f7                	jmp    8020c6 <fd2sockid+0x27>

008020cf <alloc_sockfd>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	56                   	push   %esi
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 1c             	sub    $0x1c,%esp
  8020d7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	e8 f7 f6 ff ff       	call   8017d9 <fd_alloc>
  8020e2:	89 c3                	mov    %eax,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 43                	js     80212e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	68 07 04 00 00       	push   $0x407
  8020f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f6:	6a 00                	push   $0x0
  8020f8:	e8 e9 ed ff ff       	call   800ee6 <sys_page_alloc>
  8020fd:	89 c3                	mov    %eax,%ebx
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	85 c0                	test   %eax,%eax
  802104:	78 28                	js     80212e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80210f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80211b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80211e:	83 ec 0c             	sub    $0xc,%esp
  802121:	50                   	push   %eax
  802122:	e8 8b f6 ff ff       	call   8017b2 <fd2num>
  802127:	89 c3                	mov    %eax,%ebx
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	eb 0c                	jmp    80213a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	56                   	push   %esi
  802132:	e8 e4 01 00 00       	call   80231b <nsipc_close>
		return r;
  802137:	83 c4 10             	add    $0x10,%esp
}
  80213a:	89 d8                	mov    %ebx,%eax
  80213c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5d                   	pop    %ebp
  802142:	c3                   	ret    

00802143 <accept>:
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	e8 4e ff ff ff       	call   80209f <fd2sockid>
  802151:	85 c0                	test   %eax,%eax
  802153:	78 1b                	js     802170 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	ff 75 10             	pushl  0x10(%ebp)
  80215b:	ff 75 0c             	pushl  0xc(%ebp)
  80215e:	50                   	push   %eax
  80215f:	e8 0e 01 00 00       	call   802272 <nsipc_accept>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	78 05                	js     802170 <accept+0x2d>
	return alloc_sockfd(r);
  80216b:	e8 5f ff ff ff       	call   8020cf <alloc_sockfd>
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <bind>:
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	e8 1f ff ff ff       	call   80209f <fd2sockid>
  802180:	85 c0                	test   %eax,%eax
  802182:	78 12                	js     802196 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	ff 75 10             	pushl  0x10(%ebp)
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	50                   	push   %eax
  80218e:	e8 31 01 00 00       	call   8022c4 <nsipc_bind>
  802193:	83 c4 10             	add    $0x10,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <shutdown>:
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	e8 f9 fe ff ff       	call   80209f <fd2sockid>
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 0f                	js     8021b9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021aa:	83 ec 08             	sub    $0x8,%esp
  8021ad:	ff 75 0c             	pushl  0xc(%ebp)
  8021b0:	50                   	push   %eax
  8021b1:	e8 43 01 00 00       	call   8022f9 <nsipc_shutdown>
  8021b6:	83 c4 10             	add    $0x10,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <connect>:
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	e8 d6 fe ff ff       	call   80209f <fd2sockid>
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	78 12                	js     8021df <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	ff 75 10             	pushl  0x10(%ebp)
  8021d3:	ff 75 0c             	pushl  0xc(%ebp)
  8021d6:	50                   	push   %eax
  8021d7:	e8 59 01 00 00       	call   802335 <nsipc_connect>
  8021dc:	83 c4 10             	add    $0x10,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <listen>:
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	e8 b0 fe ff ff       	call   80209f <fd2sockid>
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 0f                	js     802202 <listen+0x21>
	return nsipc_listen(r, backlog);
  8021f3:	83 ec 08             	sub    $0x8,%esp
  8021f6:	ff 75 0c             	pushl  0xc(%ebp)
  8021f9:	50                   	push   %eax
  8021fa:	e8 6b 01 00 00       	call   80236a <nsipc_listen>
  8021ff:	83 c4 10             	add    $0x10,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <socket>:

int
socket(int domain, int type, int protocol)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80220a:	ff 75 10             	pushl  0x10(%ebp)
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	ff 75 08             	pushl  0x8(%ebp)
  802213:	e8 3e 02 00 00       	call   802456 <nsipc_socket>
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	85 c0                	test   %eax,%eax
  80221d:	78 05                	js     802224 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80221f:	e8 ab fe ff ff       	call   8020cf <alloc_sockfd>
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	53                   	push   %ebx
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80222f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802236:	74 26                	je     80225e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802238:	6a 07                	push   $0x7
  80223a:	68 00 70 80 00       	push   $0x807000
  80223f:	53                   	push   %ebx
  802240:	ff 35 04 50 80 00    	pushl  0x805004
  802246:	e8 d4 f4 ff ff       	call   80171f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80224b:	83 c4 0c             	add    $0xc,%esp
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	e8 5d f4 ff ff       	call   8016b6 <ipc_recv>
}
  802259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	6a 02                	push   $0x2
  802263:	e8 0f f5 ff ff       	call   801777 <ipc_find_env>
  802268:	a3 04 50 80 00       	mov    %eax,0x805004
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	eb c6                	jmp    802238 <nsipc+0x12>

00802272 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	56                   	push   %esi
  802276:	53                   	push   %ebx
  802277:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802282:	8b 06                	mov    (%esi),%eax
  802284:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802289:	b8 01 00 00 00       	mov    $0x1,%eax
  80228e:	e8 93 ff ff ff       	call   802226 <nsipc>
  802293:	89 c3                	mov    %eax,%ebx
  802295:	85 c0                	test   %eax,%eax
  802297:	79 09                	jns    8022a2 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802299:	89 d8                	mov    %ebx,%eax
  80229b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229e:	5b                   	pop    %ebx
  80229f:	5e                   	pop    %esi
  8022a0:	5d                   	pop    %ebp
  8022a1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	ff 35 10 70 80 00    	pushl  0x807010
  8022ab:	68 00 70 80 00       	push   $0x807000
  8022b0:	ff 75 0c             	pushl  0xc(%ebp)
  8022b3:	e8 ca e9 ff ff       	call   800c82 <memmove>
		*addrlen = ret->ret_addrlen;
  8022b8:	a1 10 70 80 00       	mov    0x807010,%eax
  8022bd:	89 06                	mov    %eax,(%esi)
  8022bf:	83 c4 10             	add    $0x10,%esp
	return r;
  8022c2:	eb d5                	jmp    802299 <nsipc_accept+0x27>

008022c4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	53                   	push   %ebx
  8022c8:	83 ec 08             	sub    $0x8,%esp
  8022cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022d6:	53                   	push   %ebx
  8022d7:	ff 75 0c             	pushl  0xc(%ebp)
  8022da:	68 04 70 80 00       	push   $0x807004
  8022df:	e8 9e e9 ff ff       	call   800c82 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022e4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8022ef:	e8 32 ff ff ff       	call   802226 <nsipc>
}
  8022f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80230f:	b8 03 00 00 00       	mov    $0x3,%eax
  802314:	e8 0d ff ff ff       	call   802226 <nsipc>
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <nsipc_close>:

int
nsipc_close(int s)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802329:	b8 04 00 00 00       	mov    $0x4,%eax
  80232e:	e8 f3 fe ff ff       	call   802226 <nsipc>
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	53                   	push   %ebx
  802339:	83 ec 08             	sub    $0x8,%esp
  80233c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802347:	53                   	push   %ebx
  802348:	ff 75 0c             	pushl  0xc(%ebp)
  80234b:	68 04 70 80 00       	push   $0x807004
  802350:	e8 2d e9 ff ff       	call   800c82 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802355:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80235b:	b8 05 00 00 00       	mov    $0x5,%eax
  802360:	e8 c1 fe ff ff       	call   802226 <nsipc>
}
  802365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802380:	b8 06 00 00 00       	mov    $0x6,%eax
  802385:	e8 9c fe ff ff       	call   802226 <nsipc>
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	56                   	push   %esi
  802390:	53                   	push   %ebx
  802391:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80239c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a5:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8023af:	e8 72 fe ff ff       	call   802226 <nsipc>
  8023b4:	89 c3                	mov    %eax,%ebx
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	78 1f                	js     8023d9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023ba:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023bf:	7f 21                	jg     8023e2 <nsipc_recv+0x56>
  8023c1:	39 c6                	cmp    %eax,%esi
  8023c3:	7c 1d                	jl     8023e2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	50                   	push   %eax
  8023c9:	68 00 70 80 00       	push   $0x807000
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	e8 ac e8 ff ff       	call   800c82 <memmove>
  8023d6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023de:	5b                   	pop    %ebx
  8023df:	5e                   	pop    %esi
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023e2:	68 17 33 80 00       	push   $0x803317
  8023e7:	68 df 32 80 00       	push   $0x8032df
  8023ec:	6a 62                	push   $0x62
  8023ee:	68 2c 33 80 00       	push   $0x80332c
  8023f3:	e8 a7 de ff ff       	call   80029f <_panic>

008023f8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	53                   	push   %ebx
  8023fc:	83 ec 04             	sub    $0x4,%esp
  8023ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80240a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802410:	7f 2e                	jg     802440 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	53                   	push   %ebx
  802416:	ff 75 0c             	pushl  0xc(%ebp)
  802419:	68 0c 70 80 00       	push   $0x80700c
  80241e:	e8 5f e8 ff ff       	call   800c82 <memmove>
	nsipcbuf.send.req_size = size;
  802423:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802429:	8b 45 14             	mov    0x14(%ebp),%eax
  80242c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802431:	b8 08 00 00 00       	mov    $0x8,%eax
  802436:	e8 eb fd ff ff       	call   802226 <nsipc>
}
  80243b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    
	assert(size < 1600);
  802440:	68 38 33 80 00       	push   $0x803338
  802445:	68 df 32 80 00       	push   $0x8032df
  80244a:	6a 6d                	push   $0x6d
  80244c:	68 2c 33 80 00       	push   $0x80332c
  802451:	e8 49 de ff ff       	call   80029f <_panic>

00802456 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802464:	8b 45 0c             	mov    0xc(%ebp),%eax
  802467:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80246c:	8b 45 10             	mov    0x10(%ebp),%eax
  80246f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802474:	b8 09 00 00 00       	mov    $0x9,%eax
  802479:	e8 a8 fd ff ff       	call   802226 <nsipc>
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	56                   	push   %esi
  802484:	53                   	push   %ebx
  802485:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802488:	83 ec 0c             	sub    $0xc,%esp
  80248b:	ff 75 08             	pushl  0x8(%ebp)
  80248e:	e8 2f f3 ff ff       	call   8017c2 <fd2data>
  802493:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802495:	83 c4 08             	add    $0x8,%esp
  802498:	68 44 33 80 00       	push   $0x803344
  80249d:	53                   	push   %ebx
  80249e:	e8 51 e6 ff ff       	call   800af4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024a3:	8b 46 04             	mov    0x4(%esi),%eax
  8024a6:	2b 06                	sub    (%esi),%eax
  8024a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024b5:	00 00 00 
	stat->st_dev = &devpipe;
  8024b8:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024bf:	40 80 00 
	return 0;
}
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ca:	5b                   	pop    %ebx
  8024cb:	5e                   	pop    %esi
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    

008024ce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	53                   	push   %ebx
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024d8:	53                   	push   %ebx
  8024d9:	6a 00                	push   $0x0
  8024db:	e8 8b ea ff ff       	call   800f6b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024e0:	89 1c 24             	mov    %ebx,(%esp)
  8024e3:	e8 da f2 ff ff       	call   8017c2 <fd2data>
  8024e8:	83 c4 08             	add    $0x8,%esp
  8024eb:	50                   	push   %eax
  8024ec:	6a 00                	push   $0x0
  8024ee:	e8 78 ea ff ff       	call   800f6b <sys_page_unmap>
}
  8024f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <_pipeisclosed>:
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	57                   	push   %edi
  8024fc:	56                   	push   %esi
  8024fd:	53                   	push   %ebx
  8024fe:	83 ec 1c             	sub    $0x1c,%esp
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802505:	a1 08 50 80 00       	mov    0x805008,%eax
  80250a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80250d:	83 ec 0c             	sub    $0xc,%esp
  802510:	57                   	push   %edi
  802511:	e8 c8 fa ff ff       	call   801fde <pageref>
  802516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802519:	89 34 24             	mov    %esi,(%esp)
  80251c:	e8 bd fa ff ff       	call   801fde <pageref>
		nn = thisenv->env_runs;
  802521:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802527:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80252a:	83 c4 10             	add    $0x10,%esp
  80252d:	39 cb                	cmp    %ecx,%ebx
  80252f:	74 1b                	je     80254c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802531:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802534:	75 cf                	jne    802505 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802536:	8b 42 58             	mov    0x58(%edx),%eax
  802539:	6a 01                	push   $0x1
  80253b:	50                   	push   %eax
  80253c:	53                   	push   %ebx
  80253d:	68 4b 33 80 00       	push   $0x80334b
  802542:	e8 4e de ff ff       	call   800395 <cprintf>
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	eb b9                	jmp    802505 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80254c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80254f:	0f 94 c0             	sete   %al
  802552:	0f b6 c0             	movzbl %al,%eax
}
  802555:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802558:	5b                   	pop    %ebx
  802559:	5e                   	pop    %esi
  80255a:	5f                   	pop    %edi
  80255b:	5d                   	pop    %ebp
  80255c:	c3                   	ret    

0080255d <devpipe_write>:
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	57                   	push   %edi
  802561:	56                   	push   %esi
  802562:	53                   	push   %ebx
  802563:	83 ec 28             	sub    $0x28,%esp
  802566:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802569:	56                   	push   %esi
  80256a:	e8 53 f2 ff ff       	call   8017c2 <fd2data>
  80256f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	bf 00 00 00 00       	mov    $0x0,%edi
  802579:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80257c:	74 4f                	je     8025cd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80257e:	8b 43 04             	mov    0x4(%ebx),%eax
  802581:	8b 0b                	mov    (%ebx),%ecx
  802583:	8d 51 20             	lea    0x20(%ecx),%edx
  802586:	39 d0                	cmp    %edx,%eax
  802588:	72 14                	jb     80259e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80258a:	89 da                	mov    %ebx,%edx
  80258c:	89 f0                	mov    %esi,%eax
  80258e:	e8 65 ff ff ff       	call   8024f8 <_pipeisclosed>
  802593:	85 c0                	test   %eax,%eax
  802595:	75 3b                	jne    8025d2 <devpipe_write+0x75>
			sys_yield();
  802597:	e8 2b e9 ff ff       	call   800ec7 <sys_yield>
  80259c:	eb e0                	jmp    80257e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80259e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025a1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025a5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025a8:	89 c2                	mov    %eax,%edx
  8025aa:	c1 fa 1f             	sar    $0x1f,%edx
  8025ad:	89 d1                	mov    %edx,%ecx
  8025af:	c1 e9 1b             	shr    $0x1b,%ecx
  8025b2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025b5:	83 e2 1f             	and    $0x1f,%edx
  8025b8:	29 ca                	sub    %ecx,%edx
  8025ba:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025be:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025c2:	83 c0 01             	add    $0x1,%eax
  8025c5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025c8:	83 c7 01             	add    $0x1,%edi
  8025cb:	eb ac                	jmp    802579 <devpipe_write+0x1c>
	return i;
  8025cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d0:	eb 05                	jmp    8025d7 <devpipe_write+0x7a>
				return 0;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025da:	5b                   	pop    %ebx
  8025db:	5e                   	pop    %esi
  8025dc:	5f                   	pop    %edi
  8025dd:	5d                   	pop    %ebp
  8025de:	c3                   	ret    

008025df <devpipe_read>:
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	57                   	push   %edi
  8025e3:	56                   	push   %esi
  8025e4:	53                   	push   %ebx
  8025e5:	83 ec 18             	sub    $0x18,%esp
  8025e8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025eb:	57                   	push   %edi
  8025ec:	e8 d1 f1 ff ff       	call   8017c2 <fd2data>
  8025f1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025f3:	83 c4 10             	add    $0x10,%esp
  8025f6:	be 00 00 00 00       	mov    $0x0,%esi
  8025fb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025fe:	75 14                	jne    802614 <devpipe_read+0x35>
	return i;
  802600:	8b 45 10             	mov    0x10(%ebp),%eax
  802603:	eb 02                	jmp    802607 <devpipe_read+0x28>
				return i;
  802605:	89 f0                	mov    %esi,%eax
}
  802607:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80260a:	5b                   	pop    %ebx
  80260b:	5e                   	pop    %esi
  80260c:	5f                   	pop    %edi
  80260d:	5d                   	pop    %ebp
  80260e:	c3                   	ret    
			sys_yield();
  80260f:	e8 b3 e8 ff ff       	call   800ec7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802614:	8b 03                	mov    (%ebx),%eax
  802616:	3b 43 04             	cmp    0x4(%ebx),%eax
  802619:	75 18                	jne    802633 <devpipe_read+0x54>
			if (i > 0)
  80261b:	85 f6                	test   %esi,%esi
  80261d:	75 e6                	jne    802605 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80261f:	89 da                	mov    %ebx,%edx
  802621:	89 f8                	mov    %edi,%eax
  802623:	e8 d0 fe ff ff       	call   8024f8 <_pipeisclosed>
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 e3                	je     80260f <devpipe_read+0x30>
				return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	eb d4                	jmp    802607 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802633:	99                   	cltd   
  802634:	c1 ea 1b             	shr    $0x1b,%edx
  802637:	01 d0                	add    %edx,%eax
  802639:	83 e0 1f             	and    $0x1f,%eax
  80263c:	29 d0                	sub    %edx,%eax
  80263e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802643:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802646:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802649:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80264c:	83 c6 01             	add    $0x1,%esi
  80264f:	eb aa                	jmp    8025fb <devpipe_read+0x1c>

00802651 <pipe>:
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	56                   	push   %esi
  802655:	53                   	push   %ebx
  802656:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802659:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80265c:	50                   	push   %eax
  80265d:	e8 77 f1 ff ff       	call   8017d9 <fd_alloc>
  802662:	89 c3                	mov    %eax,%ebx
  802664:	83 c4 10             	add    $0x10,%esp
  802667:	85 c0                	test   %eax,%eax
  802669:	0f 88 23 01 00 00    	js     802792 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 07 04 00 00       	push   $0x407
  802677:	ff 75 f4             	pushl  -0xc(%ebp)
  80267a:	6a 00                	push   $0x0
  80267c:	e8 65 e8 ff ff       	call   800ee6 <sys_page_alloc>
  802681:	89 c3                	mov    %eax,%ebx
  802683:	83 c4 10             	add    $0x10,%esp
  802686:	85 c0                	test   %eax,%eax
  802688:	0f 88 04 01 00 00    	js     802792 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80268e:	83 ec 0c             	sub    $0xc,%esp
  802691:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802694:	50                   	push   %eax
  802695:	e8 3f f1 ff ff       	call   8017d9 <fd_alloc>
  80269a:	89 c3                	mov    %eax,%ebx
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	0f 88 db 00 00 00    	js     802782 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	68 07 04 00 00       	push   $0x407
  8026af:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b2:	6a 00                	push   $0x0
  8026b4:	e8 2d e8 ff ff       	call   800ee6 <sys_page_alloc>
  8026b9:	89 c3                	mov    %eax,%ebx
  8026bb:	83 c4 10             	add    $0x10,%esp
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	0f 88 bc 00 00 00    	js     802782 <pipe+0x131>
	va = fd2data(fd0);
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cc:	e8 f1 f0 ff ff       	call   8017c2 <fd2data>
  8026d1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d3:	83 c4 0c             	add    $0xc,%esp
  8026d6:	68 07 04 00 00       	push   $0x407
  8026db:	50                   	push   %eax
  8026dc:	6a 00                	push   $0x0
  8026de:	e8 03 e8 ff ff       	call   800ee6 <sys_page_alloc>
  8026e3:	89 c3                	mov    %eax,%ebx
  8026e5:	83 c4 10             	add    $0x10,%esp
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	0f 88 82 00 00 00    	js     802772 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026f0:	83 ec 0c             	sub    $0xc,%esp
  8026f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8026f6:	e8 c7 f0 ff ff       	call   8017c2 <fd2data>
  8026fb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802702:	50                   	push   %eax
  802703:	6a 00                	push   $0x0
  802705:	56                   	push   %esi
  802706:	6a 00                	push   $0x0
  802708:	e8 1c e8 ff ff       	call   800f29 <sys_page_map>
  80270d:	89 c3                	mov    %eax,%ebx
  80270f:	83 c4 20             	add    $0x20,%esp
  802712:	85 c0                	test   %eax,%eax
  802714:	78 4e                	js     802764 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802716:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80271b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802720:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802723:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80272a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802739:	83 ec 0c             	sub    $0xc,%esp
  80273c:	ff 75 f4             	pushl  -0xc(%ebp)
  80273f:	e8 6e f0 ff ff       	call   8017b2 <fd2num>
  802744:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802747:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802749:	83 c4 04             	add    $0x4,%esp
  80274c:	ff 75 f0             	pushl  -0x10(%ebp)
  80274f:	e8 5e f0 ff ff       	call   8017b2 <fd2num>
  802754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802757:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80275a:	83 c4 10             	add    $0x10,%esp
  80275d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802762:	eb 2e                	jmp    802792 <pipe+0x141>
	sys_page_unmap(0, va);
  802764:	83 ec 08             	sub    $0x8,%esp
  802767:	56                   	push   %esi
  802768:	6a 00                	push   $0x0
  80276a:	e8 fc e7 ff ff       	call   800f6b <sys_page_unmap>
  80276f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802772:	83 ec 08             	sub    $0x8,%esp
  802775:	ff 75 f0             	pushl  -0x10(%ebp)
  802778:	6a 00                	push   $0x0
  80277a:	e8 ec e7 ff ff       	call   800f6b <sys_page_unmap>
  80277f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802782:	83 ec 08             	sub    $0x8,%esp
  802785:	ff 75 f4             	pushl  -0xc(%ebp)
  802788:	6a 00                	push   $0x0
  80278a:	e8 dc e7 ff ff       	call   800f6b <sys_page_unmap>
  80278f:	83 c4 10             	add    $0x10,%esp
}
  802792:	89 d8                	mov    %ebx,%eax
  802794:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802797:	5b                   	pop    %ebx
  802798:	5e                   	pop    %esi
  802799:	5d                   	pop    %ebp
  80279a:	c3                   	ret    

0080279b <pipeisclosed>:
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a4:	50                   	push   %eax
  8027a5:	ff 75 08             	pushl  0x8(%ebp)
  8027a8:	e8 7e f0 ff ff       	call   80182b <fd_lookup>
  8027ad:	83 c4 10             	add    $0x10,%esp
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	78 18                	js     8027cc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027b4:	83 ec 0c             	sub    $0xc,%esp
  8027b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ba:	e8 03 f0 ff ff       	call   8017c2 <fd2data>
	return _pipeisclosed(fd, p);
  8027bf:	89 c2                	mov    %eax,%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	e8 2f fd ff ff       	call   8024f8 <_pipeisclosed>
  8027c9:	83 c4 10             	add    $0x10,%esp
}
  8027cc:	c9                   	leave  
  8027cd:	c3                   	ret    

008027ce <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d3:	c3                   	ret    

008027d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027da:	68 63 33 80 00       	push   $0x803363
  8027df:	ff 75 0c             	pushl  0xc(%ebp)
  8027e2:	e8 0d e3 ff ff       	call   800af4 <strcpy>
	return 0;
}
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <devcons_write>:
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	57                   	push   %edi
  8027f2:	56                   	push   %esi
  8027f3:	53                   	push   %ebx
  8027f4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027fa:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027ff:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802805:	3b 75 10             	cmp    0x10(%ebp),%esi
  802808:	73 31                	jae    80283b <devcons_write+0x4d>
		m = n - tot;
  80280a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80280d:	29 f3                	sub    %esi,%ebx
  80280f:	83 fb 7f             	cmp    $0x7f,%ebx
  802812:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802817:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80281a:	83 ec 04             	sub    $0x4,%esp
  80281d:	53                   	push   %ebx
  80281e:	89 f0                	mov    %esi,%eax
  802820:	03 45 0c             	add    0xc(%ebp),%eax
  802823:	50                   	push   %eax
  802824:	57                   	push   %edi
  802825:	e8 58 e4 ff ff       	call   800c82 <memmove>
		sys_cputs(buf, m);
  80282a:	83 c4 08             	add    $0x8,%esp
  80282d:	53                   	push   %ebx
  80282e:	57                   	push   %edi
  80282f:	e8 f6 e5 ff ff       	call   800e2a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802834:	01 de                	add    %ebx,%esi
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	eb ca                	jmp    802805 <devcons_write+0x17>
}
  80283b:	89 f0                	mov    %esi,%eax
  80283d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802840:	5b                   	pop    %ebx
  802841:	5e                   	pop    %esi
  802842:	5f                   	pop    %edi
  802843:	5d                   	pop    %ebp
  802844:	c3                   	ret    

00802845 <devcons_read>:
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 08             	sub    $0x8,%esp
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802850:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802854:	74 21                	je     802877 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802856:	e8 ed e5 ff ff       	call   800e48 <sys_cgetc>
  80285b:	85 c0                	test   %eax,%eax
  80285d:	75 07                	jne    802866 <devcons_read+0x21>
		sys_yield();
  80285f:	e8 63 e6 ff ff       	call   800ec7 <sys_yield>
  802864:	eb f0                	jmp    802856 <devcons_read+0x11>
	if (c < 0)
  802866:	78 0f                	js     802877 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802868:	83 f8 04             	cmp    $0x4,%eax
  80286b:	74 0c                	je     802879 <devcons_read+0x34>
	*(char*)vbuf = c;
  80286d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802870:	88 02                	mov    %al,(%edx)
	return 1;
  802872:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802877:	c9                   	leave  
  802878:	c3                   	ret    
		return 0;
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
  80287e:	eb f7                	jmp    802877 <devcons_read+0x32>

00802880 <cputchar>:
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80288c:	6a 01                	push   $0x1
  80288e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802891:	50                   	push   %eax
  802892:	e8 93 e5 ff ff       	call   800e2a <sys_cputs>
}
  802897:	83 c4 10             	add    $0x10,%esp
  80289a:	c9                   	leave  
  80289b:	c3                   	ret    

0080289c <getchar>:
{
  80289c:	55                   	push   %ebp
  80289d:	89 e5                	mov    %esp,%ebp
  80289f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028a2:	6a 01                	push   $0x1
  8028a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028a7:	50                   	push   %eax
  8028a8:	6a 00                	push   $0x0
  8028aa:	e8 ec f1 ff ff       	call   801a9b <read>
	if (r < 0)
  8028af:	83 c4 10             	add    $0x10,%esp
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	78 06                	js     8028bc <getchar+0x20>
	if (r < 1)
  8028b6:	74 06                	je     8028be <getchar+0x22>
	return c;
  8028b8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    
		return -E_EOF;
  8028be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028c3:	eb f7                	jmp    8028bc <getchar+0x20>

008028c5 <iscons>:
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ce:	50                   	push   %eax
  8028cf:	ff 75 08             	pushl  0x8(%ebp)
  8028d2:	e8 54 ef ff ff       	call   80182b <fd_lookup>
  8028d7:	83 c4 10             	add    $0x10,%esp
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	78 11                	js     8028ef <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028e7:	39 10                	cmp    %edx,(%eax)
  8028e9:	0f 94 c0             	sete   %al
  8028ec:	0f b6 c0             	movzbl %al,%eax
}
  8028ef:	c9                   	leave  
  8028f0:	c3                   	ret    

008028f1 <opencons>:
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
  8028f4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028fa:	50                   	push   %eax
  8028fb:	e8 d9 ee ff ff       	call   8017d9 <fd_alloc>
  802900:	83 c4 10             	add    $0x10,%esp
  802903:	85 c0                	test   %eax,%eax
  802905:	78 3a                	js     802941 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	68 07 04 00 00       	push   $0x407
  80290f:	ff 75 f4             	pushl  -0xc(%ebp)
  802912:	6a 00                	push   $0x0
  802914:	e8 cd e5 ff ff       	call   800ee6 <sys_page_alloc>
  802919:	83 c4 10             	add    $0x10,%esp
  80291c:	85 c0                	test   %eax,%eax
  80291e:	78 21                	js     802941 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802929:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802935:	83 ec 0c             	sub    $0xc,%esp
  802938:	50                   	push   %eax
  802939:	e8 74 ee ff ff       	call   8017b2 <fd2num>
  80293e:	83 c4 10             	add    $0x10,%esp
}
  802941:	c9                   	leave  
  802942:	c3                   	ret    

00802943 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
  802946:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802949:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802950:	74 0a                	je     80295c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80295c:	83 ec 04             	sub    $0x4,%esp
  80295f:	6a 07                	push   $0x7
  802961:	68 00 f0 bf ee       	push   $0xeebff000
  802966:	6a 00                	push   $0x0
  802968:	e8 79 e5 ff ff       	call   800ee6 <sys_page_alloc>
		if(r < 0)
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	85 c0                	test   %eax,%eax
  802972:	78 2a                	js     80299e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802974:	83 ec 08             	sub    $0x8,%esp
  802977:	68 b2 29 80 00       	push   $0x8029b2
  80297c:	6a 00                	push   $0x0
  80297e:	e8 ae e6 ff ff       	call   801031 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802983:	83 c4 10             	add    $0x10,%esp
  802986:	85 c0                	test   %eax,%eax
  802988:	79 c8                	jns    802952 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80298a:	83 ec 04             	sub    $0x4,%esp
  80298d:	68 a0 33 80 00       	push   $0x8033a0
  802992:	6a 25                	push   $0x25
  802994:	68 dc 33 80 00       	push   $0x8033dc
  802999:	e8 01 d9 ff ff       	call   80029f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	68 70 33 80 00       	push   $0x803370
  8029a6:	6a 22                	push   $0x22
  8029a8:	68 dc 33 80 00       	push   $0x8033dc
  8029ad:	e8 ed d8 ff ff       	call   80029f <_panic>

008029b2 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029b2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029b3:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029b8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029ba:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029bd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029c1:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029c5:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029c8:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029ca:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029ce:	83 c4 08             	add    $0x8,%esp
	popal
  8029d1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029d2:	83 c4 04             	add    $0x4,%esp
	popfl
  8029d5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029d6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029d7:	c3                   	ret    
  8029d8:	66 90                	xchg   %ax,%ax
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__udivdi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	83 ec 1c             	sub    $0x1c,%esp
  8029e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029f7:	85 d2                	test   %edx,%edx
  8029f9:	75 4d                	jne    802a48 <__udivdi3+0x68>
  8029fb:	39 f3                	cmp    %esi,%ebx
  8029fd:	76 19                	jbe    802a18 <__udivdi3+0x38>
  8029ff:	31 ff                	xor    %edi,%edi
  802a01:	89 e8                	mov    %ebp,%eax
  802a03:	89 f2                	mov    %esi,%edx
  802a05:	f7 f3                	div    %ebx
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 d9                	mov    %ebx,%ecx
  802a1a:	85 db                	test   %ebx,%ebx
  802a1c:	75 0b                	jne    802a29 <__udivdi3+0x49>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f3                	div    %ebx
  802a27:	89 c1                	mov    %eax,%ecx
  802a29:	31 d2                	xor    %edx,%edx
  802a2b:	89 f0                	mov    %esi,%eax
  802a2d:	f7 f1                	div    %ecx
  802a2f:	89 c6                	mov    %eax,%esi
  802a31:	89 e8                	mov    %ebp,%eax
  802a33:	89 f7                	mov    %esi,%edi
  802a35:	f7 f1                	div    %ecx
  802a37:	89 fa                	mov    %edi,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	39 f2                	cmp    %esi,%edx
  802a4a:	77 1c                	ja     802a68 <__udivdi3+0x88>
  802a4c:	0f bd fa             	bsr    %edx,%edi
  802a4f:	83 f7 1f             	xor    $0x1f,%edi
  802a52:	75 2c                	jne    802a80 <__udivdi3+0xa0>
  802a54:	39 f2                	cmp    %esi,%edx
  802a56:	72 06                	jb     802a5e <__udivdi3+0x7e>
  802a58:	31 c0                	xor    %eax,%eax
  802a5a:	39 eb                	cmp    %ebp,%ebx
  802a5c:	77 a9                	ja     802a07 <__udivdi3+0x27>
  802a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a63:	eb a2                	jmp    802a07 <__udivdi3+0x27>
  802a65:	8d 76 00             	lea    0x0(%esi),%esi
  802a68:	31 ff                	xor    %edi,%edi
  802a6a:	31 c0                	xor    %eax,%eax
  802a6c:	89 fa                	mov    %edi,%edx
  802a6e:	83 c4 1c             	add    $0x1c,%esp
  802a71:	5b                   	pop    %ebx
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    
  802a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a7d:	8d 76 00             	lea    0x0(%esi),%esi
  802a80:	89 f9                	mov    %edi,%ecx
  802a82:	b8 20 00 00 00       	mov    $0x20,%eax
  802a87:	29 f8                	sub    %edi,%eax
  802a89:	d3 e2                	shl    %cl,%edx
  802a8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a8f:	89 c1                	mov    %eax,%ecx
  802a91:	89 da                	mov    %ebx,%edx
  802a93:	d3 ea                	shr    %cl,%edx
  802a95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a99:	09 d1                	or     %edx,%ecx
  802a9b:	89 f2                	mov    %esi,%edx
  802a9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aa1:	89 f9                	mov    %edi,%ecx
  802aa3:	d3 e3                	shl    %cl,%ebx
  802aa5:	89 c1                	mov    %eax,%ecx
  802aa7:	d3 ea                	shr    %cl,%edx
  802aa9:	89 f9                	mov    %edi,%ecx
  802aab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802aaf:	89 eb                	mov    %ebp,%ebx
  802ab1:	d3 e6                	shl    %cl,%esi
  802ab3:	89 c1                	mov    %eax,%ecx
  802ab5:	d3 eb                	shr    %cl,%ebx
  802ab7:	09 de                	or     %ebx,%esi
  802ab9:	89 f0                	mov    %esi,%eax
  802abb:	f7 74 24 08          	divl   0x8(%esp)
  802abf:	89 d6                	mov    %edx,%esi
  802ac1:	89 c3                	mov    %eax,%ebx
  802ac3:	f7 64 24 0c          	mull   0xc(%esp)
  802ac7:	39 d6                	cmp    %edx,%esi
  802ac9:	72 15                	jb     802ae0 <__udivdi3+0x100>
  802acb:	89 f9                	mov    %edi,%ecx
  802acd:	d3 e5                	shl    %cl,%ebp
  802acf:	39 c5                	cmp    %eax,%ebp
  802ad1:	73 04                	jae    802ad7 <__udivdi3+0xf7>
  802ad3:	39 d6                	cmp    %edx,%esi
  802ad5:	74 09                	je     802ae0 <__udivdi3+0x100>
  802ad7:	89 d8                	mov    %ebx,%eax
  802ad9:	31 ff                	xor    %edi,%edi
  802adb:	e9 27 ff ff ff       	jmp    802a07 <__udivdi3+0x27>
  802ae0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ae3:	31 ff                	xor    %edi,%edi
  802ae5:	e9 1d ff ff ff       	jmp    802a07 <__udivdi3+0x27>
  802aea:	66 90                	xchg   %ax,%ax
  802aec:	66 90                	xchg   %ax,%ax
  802aee:	66 90                	xchg   %ax,%ax

00802af0 <__umoddi3>:
  802af0:	55                   	push   %ebp
  802af1:	57                   	push   %edi
  802af2:	56                   	push   %esi
  802af3:	53                   	push   %ebx
  802af4:	83 ec 1c             	sub    $0x1c,%esp
  802af7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b07:	89 da                	mov    %ebx,%edx
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	75 43                	jne    802b50 <__umoddi3+0x60>
  802b0d:	39 df                	cmp    %ebx,%edi
  802b0f:	76 17                	jbe    802b28 <__umoddi3+0x38>
  802b11:	89 f0                	mov    %esi,%eax
  802b13:	f7 f7                	div    %edi
  802b15:	89 d0                	mov    %edx,%eax
  802b17:	31 d2                	xor    %edx,%edx
  802b19:	83 c4 1c             	add    $0x1c,%esp
  802b1c:	5b                   	pop    %ebx
  802b1d:	5e                   	pop    %esi
  802b1e:	5f                   	pop    %edi
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    
  802b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b28:	89 fd                	mov    %edi,%ebp
  802b2a:	85 ff                	test   %edi,%edi
  802b2c:	75 0b                	jne    802b39 <__umoddi3+0x49>
  802b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b33:	31 d2                	xor    %edx,%edx
  802b35:	f7 f7                	div    %edi
  802b37:	89 c5                	mov    %eax,%ebp
  802b39:	89 d8                	mov    %ebx,%eax
  802b3b:	31 d2                	xor    %edx,%edx
  802b3d:	f7 f5                	div    %ebp
  802b3f:	89 f0                	mov    %esi,%eax
  802b41:	f7 f5                	div    %ebp
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	eb d0                	jmp    802b17 <__umoddi3+0x27>
  802b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b4e:	66 90                	xchg   %ax,%ax
  802b50:	89 f1                	mov    %esi,%ecx
  802b52:	39 d8                	cmp    %ebx,%eax
  802b54:	76 0a                	jbe    802b60 <__umoddi3+0x70>
  802b56:	89 f0                	mov    %esi,%eax
  802b58:	83 c4 1c             	add    $0x1c,%esp
  802b5b:	5b                   	pop    %ebx
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
  802b60:	0f bd e8             	bsr    %eax,%ebp
  802b63:	83 f5 1f             	xor    $0x1f,%ebp
  802b66:	75 20                	jne    802b88 <__umoddi3+0x98>
  802b68:	39 d8                	cmp    %ebx,%eax
  802b6a:	0f 82 b0 00 00 00    	jb     802c20 <__umoddi3+0x130>
  802b70:	39 f7                	cmp    %esi,%edi
  802b72:	0f 86 a8 00 00 00    	jbe    802c20 <__umoddi3+0x130>
  802b78:	89 c8                	mov    %ecx,%eax
  802b7a:	83 c4 1c             	add    $0x1c,%esp
  802b7d:	5b                   	pop    %ebx
  802b7e:	5e                   	pop    %esi
  802b7f:	5f                   	pop    %edi
  802b80:	5d                   	pop    %ebp
  802b81:	c3                   	ret    
  802b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b88:	89 e9                	mov    %ebp,%ecx
  802b8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b8f:	29 ea                	sub    %ebp,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b97:	89 d1                	mov    %edx,%ecx
  802b99:	89 f8                	mov    %edi,%eax
  802b9b:	d3 e8                	shr    %cl,%eax
  802b9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ba5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ba9:	09 c1                	or     %eax,%ecx
  802bab:	89 d8                	mov    %ebx,%eax
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 e9                	mov    %ebp,%ecx
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bbf:	d3 e3                	shl    %cl,%ebx
  802bc1:	89 c7                	mov    %eax,%edi
  802bc3:	89 d1                	mov    %edx,%ecx
  802bc5:	89 f0                	mov    %esi,%eax
  802bc7:	d3 e8                	shr    %cl,%eax
  802bc9:	89 e9                	mov    %ebp,%ecx
  802bcb:	89 fa                	mov    %edi,%edx
  802bcd:	d3 e6                	shl    %cl,%esi
  802bcf:	09 d8                	or     %ebx,%eax
  802bd1:	f7 74 24 08          	divl   0x8(%esp)
  802bd5:	89 d1                	mov    %edx,%ecx
  802bd7:	89 f3                	mov    %esi,%ebx
  802bd9:	f7 64 24 0c          	mull   0xc(%esp)
  802bdd:	89 c6                	mov    %eax,%esi
  802bdf:	89 d7                	mov    %edx,%edi
  802be1:	39 d1                	cmp    %edx,%ecx
  802be3:	72 06                	jb     802beb <__umoddi3+0xfb>
  802be5:	75 10                	jne    802bf7 <__umoddi3+0x107>
  802be7:	39 c3                	cmp    %eax,%ebx
  802be9:	73 0c                	jae    802bf7 <__umoddi3+0x107>
  802beb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bf3:	89 d7                	mov    %edx,%edi
  802bf5:	89 c6                	mov    %eax,%esi
  802bf7:	89 ca                	mov    %ecx,%edx
  802bf9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bfe:	29 f3                	sub    %esi,%ebx
  802c00:	19 fa                	sbb    %edi,%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	d3 e0                	shl    %cl,%eax
  802c06:	89 e9                	mov    %ebp,%ecx
  802c08:	d3 eb                	shr    %cl,%ebx
  802c0a:	d3 ea                	shr    %cl,%edx
  802c0c:	09 d8                	or     %ebx,%eax
  802c0e:	83 c4 1c             	add    $0x1c,%esp
  802c11:	5b                   	pop    %ebx
  802c12:	5e                   	pop    %esi
  802c13:	5f                   	pop    %edi
  802c14:	5d                   	pop    %ebp
  802c15:	c3                   	ret    
  802c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c1d:	8d 76 00             	lea    0x0(%esi),%esi
  802c20:	89 da                	mov    %ebx,%edx
  802c22:	29 fe                	sub    %edi,%esi
  802c24:	19 c2                	sbb    %eax,%edx
  802c26:	89 f1                	mov    %esi,%ecx
  802c28:	89 c8                	mov    %ecx,%eax
  802c2a:	e9 4b ff ff ff       	jmp    802b7a <__umoddi3+0x8a>
