
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
  80003b:	68 a0 2c 80 00       	push   $0x802ca0
  800040:	e8 a1 03 00 00       	call   8003e6 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 5e 26 00 00       	call   8026ae <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 66                	js     8000bd <umain+0x8a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 25 14 00 00       	call   801481 <fork>
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
  800068:	68 fa 2c 80 00       	push   $0x802cfa
  80006d:	e8 74 03 00 00       	call   8003e6 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800072:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800078:	83 c4 08             	add    $0x8,%esp
  80007b:	56                   	push   %esi
  80007c:	68 05 2d 80 00       	push   $0x802d05
  800081:	e8 60 03 00 00       	call   8003e6 <cprintf>
	dup(p[0], 10);
  800086:	83 c4 08             	add    $0x8,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	ff 75 f0             	pushl  -0x10(%ebp)
  80008e:	e8 79 19 00 00       	call   801a0c <dup>
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
  8000b3:	e8 54 19 00 00       	call   801a0c <dup>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb e2                	jmp    80009f <umain+0x6c>
		panic("pipe: %e", r);
  8000bd:	50                   	push   %eax
  8000be:	68 b9 2c 80 00       	push   $0x802cb9
  8000c3:	6a 0d                	push   $0xd
  8000c5:	68 c2 2c 80 00       	push   $0x802cc2
  8000ca:	e8 21 02 00 00       	call   8002f0 <_panic>
		panic("fork: %e", r);
  8000cf:	50                   	push   %eax
  8000d0:	68 d6 2c 80 00       	push   $0x802cd6
  8000d5:	6a 10                	push   $0x10
  8000d7:	68 c2 2c 80 00       	push   $0x802cc2
  8000dc:	e8 0f 02 00 00       	call   8002f0 <_panic>
		close(p[1]);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e7:	e8 ce 18 00 00       	call   8019ba <close>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000f4:	eb 1f                	jmp    800115 <umain+0xe2>
				cprintf("RACE: pipe appears closed\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 df 2c 80 00       	push   $0x802cdf
  8000fe:	e8 e3 02 00 00       	call   8003e6 <cprintf>
				exit();
  800103:	e8 b4 01 00 00       	call   8002bc <exit>
  800108:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  80010b:	e8 08 0e 00 00       	call   800f18 <sys_yield>
		for (i=0; i<max; i++) {
  800110:	83 eb 01             	sub    $0x1,%ebx
  800113:	74 14                	je     800129 <umain+0xf6>
			if(pipeisclosed(p[0])){
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	ff 75 f0             	pushl  -0x10(%ebp)
  80011b:	e8 d8 26 00 00       	call   8027f8 <pipeisclosed>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	85 c0                	test   %eax,%eax
  800125:	74 e4                	je     80010b <umain+0xd8>
  800127:	eb cd                	jmp    8000f6 <umain+0xc3>
		ipc_recv(0,0,0);
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	6a 00                	push   $0x0
  80012e:	6a 00                	push   $0x0
  800130:	6a 00                	push   $0x0
  800132:	e8 dc 15 00 00       	call   801713 <ipc_recv>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	e9 25 ff ff ff       	jmp    800064 <umain+0x31>

	cprintf("child done with loop\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 10 2d 80 00       	push   $0x802d10
  800147:	e8 9a 02 00 00       	call   8003e6 <cprintf>
	if (pipeisclosed(p[0]))
  80014c:	83 c4 04             	add    $0x4,%esp
  80014f:	ff 75 f0             	pushl  -0x10(%ebp)
  800152:	e8 a1 26 00 00       	call   8027f8 <pipeisclosed>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	85 c0                	test   %eax,%eax
  80015c:	75 48                	jne    8001a6 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	ff 75 f0             	pushl  -0x10(%ebp)
  800168:	e8 1b 17 00 00       	call   801888 <fd_lookup>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	78 46                	js     8001ba <umain+0x187>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 ec             	pushl  -0x14(%ebp)
  80017a:	e8 a0 16 00 00       	call   80181f <fd2data>
	if (pageref(va) != 3+1)
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 b4 1e 00 00       	call   80203b <pageref>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	83 f8 04             	cmp    $0x4,%eax
  80018d:	74 3d                	je     8001cc <umain+0x199>
		cprintf("\nchild detected race\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 3e 2d 80 00       	push   $0x802d3e
  800197:	e8 4a 02 00 00       	call   8003e6 <cprintf>
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
  8001a9:	68 6c 2d 80 00       	push   $0x802d6c
  8001ae:	6a 3a                	push   $0x3a
  8001b0:	68 c2 2c 80 00       	push   $0x802cc2
  8001b5:	e8 36 01 00 00       	call   8002f0 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ba:	50                   	push   %eax
  8001bb:	68 26 2d 80 00       	push   $0x802d26
  8001c0:	6a 3c                	push   $0x3c
  8001c2:	68 c2 2c 80 00       	push   $0x802cc2
  8001c7:	e8 24 01 00 00       	call   8002f0 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	68 c8 00 00 00       	push   $0xc8
  8001d4:	68 54 2d 80 00       	push   $0x802d54
  8001d9:	e8 08 02 00 00       	call   8003e6 <cprintf>
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
  8001f6:	e8 fe 0c 00 00       	call   800ef9 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80025a:	a1 08 50 80 00       	mov    0x805008,%eax
  80025f:	8b 40 48             	mov    0x48(%eax),%eax
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	50                   	push   %eax
  800266:	68 96 2d 80 00       	push   $0x802d96
  80026b:	e8 76 01 00 00       	call   8003e6 <cprintf>
	cprintf("before umain\n");
  800270:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  800277:	e8 6a 01 00 00       	call   8003e6 <cprintf>
	// call user main routine
	umain(argc, argv);
  80027c:	83 c4 08             	add    $0x8,%esp
  80027f:	ff 75 0c             	pushl  0xc(%ebp)
  800282:	ff 75 08             	pushl  0x8(%ebp)
  800285:	e8 a9 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80028a:	c7 04 24 c2 2d 80 00 	movl   $0x802dc2,(%esp)
  800291:	e8 50 01 00 00       	call   8003e6 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800296:	a1 08 50 80 00       	mov    0x805008,%eax
  80029b:	8b 40 48             	mov    0x48(%eax),%eax
  80029e:	83 c4 08             	add    $0x8,%esp
  8002a1:	50                   	push   %eax
  8002a2:	68 cf 2d 80 00       	push   $0x802dcf
  8002a7:	e8 3a 01 00 00       	call   8003e6 <cprintf>
	// exit gracefully
	exit();
  8002ac:	e8 0b 00 00 00       	call   8002bc <exit>
}
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b7:	5b                   	pop    %ebx
  8002b8:	5e                   	pop    %esi
  8002b9:	5f                   	pop    %edi
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8002c7:	8b 40 48             	mov    0x48(%eax),%eax
  8002ca:	68 fc 2d 80 00       	push   $0x802dfc
  8002cf:	50                   	push   %eax
  8002d0:	68 ee 2d 80 00       	push   $0x802dee
  8002d5:	e8 0c 01 00 00       	call   8003e6 <cprintf>
	close_all();
  8002da:	e8 08 17 00 00       	call   8019e7 <close_all>
	sys_env_destroy(0);
  8002df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002e6:	e8 cd 0b 00 00       	call   800eb8 <sys_env_destroy>
}
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	56                   	push   %esi
  8002f4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002f5:	a1 08 50 80 00       	mov    0x805008,%eax
  8002fa:	8b 40 48             	mov    0x48(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 28 2e 80 00       	push   $0x802e28
  800305:	50                   	push   %eax
  800306:	68 ee 2d 80 00       	push   $0x802dee
  80030b:	e8 d6 00 00 00       	call   8003e6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800310:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800313:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800319:	e8 db 0b 00 00       	call   800ef9 <sys_getenvid>
  80031e:	83 c4 04             	add    $0x4,%esp
  800321:	ff 75 0c             	pushl  0xc(%ebp)
  800324:	ff 75 08             	pushl  0x8(%ebp)
  800327:	56                   	push   %esi
  800328:	50                   	push   %eax
  800329:	68 04 2e 80 00       	push   $0x802e04
  80032e:	e8 b3 00 00 00       	call   8003e6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800333:	83 c4 18             	add    $0x18,%esp
  800336:	53                   	push   %ebx
  800337:	ff 75 10             	pushl  0x10(%ebp)
  80033a:	e8 56 00 00 00       	call   800395 <vcprintf>
	cprintf("\n");
  80033f:	c7 04 24 b2 2d 80 00 	movl   $0x802db2,(%esp)
  800346:	e8 9b 00 00 00       	call   8003e6 <cprintf>
  80034b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80034e:	cc                   	int3   
  80034f:	eb fd                	jmp    80034e <_panic+0x5e>

00800351 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	53                   	push   %ebx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80035b:	8b 13                	mov    (%ebx),%edx
  80035d:	8d 42 01             	lea    0x1(%edx),%eax
  800360:	89 03                	mov    %eax,(%ebx)
  800362:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800365:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800369:	3d ff 00 00 00       	cmp    $0xff,%eax
  80036e:	74 09                	je     800379 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800370:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800374:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800377:	c9                   	leave  
  800378:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	68 ff 00 00 00       	push   $0xff
  800381:	8d 43 08             	lea    0x8(%ebx),%eax
  800384:	50                   	push   %eax
  800385:	e8 f1 0a 00 00       	call   800e7b <sys_cputs>
		b->idx = 0;
  80038a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	eb db                	jmp    800370 <putch+0x1f>

00800395 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80039e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a5:	00 00 00 
	b.cnt = 0;
  8003a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003af:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b2:	ff 75 0c             	pushl  0xc(%ebp)
  8003b5:	ff 75 08             	pushl  0x8(%ebp)
  8003b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	68 51 03 80 00       	push   $0x800351
  8003c4:	e8 4a 01 00 00       	call   800513 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003c9:	83 c4 08             	add    $0x8,%esp
  8003cc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003d2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003d8:	50                   	push   %eax
  8003d9:	e8 9d 0a 00 00       	call   800e7b <sys_cputs>

	return b.cnt;
}
  8003de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ef:	50                   	push   %eax
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	e8 9d ff ff ff       	call   800395 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	57                   	push   %edi
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	83 ec 1c             	sub    $0x1c,%esp
  800403:	89 c6                	mov    %eax,%esi
  800405:	89 d7                	mov    %edx,%edi
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800410:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800413:	8b 45 10             	mov    0x10(%ebp),%eax
  800416:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800419:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80041d:	74 2c                	je     80044b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80041f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800422:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800429:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80042f:	39 c2                	cmp    %eax,%edx
  800431:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800434:	73 43                	jae    800479 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800436:	83 eb 01             	sub    $0x1,%ebx
  800439:	85 db                	test   %ebx,%ebx
  80043b:	7e 6c                	jle    8004a9 <printnum+0xaf>
				putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	57                   	push   %edi
  800441:	ff 75 18             	pushl  0x18(%ebp)
  800444:	ff d6                	call   *%esi
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	eb eb                	jmp    800436 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80044b:	83 ec 0c             	sub    $0xc,%esp
  80044e:	6a 20                	push   $0x20
  800450:	6a 00                	push   $0x0
  800452:	50                   	push   %eax
  800453:	ff 75 e4             	pushl  -0x1c(%ebp)
  800456:	ff 75 e0             	pushl  -0x20(%ebp)
  800459:	89 fa                	mov    %edi,%edx
  80045b:	89 f0                	mov    %esi,%eax
  80045d:	e8 98 ff ff ff       	call   8003fa <printnum>
		while (--width > 0)
  800462:	83 c4 20             	add    $0x20,%esp
  800465:	83 eb 01             	sub    $0x1,%ebx
  800468:	85 db                	test   %ebx,%ebx
  80046a:	7e 65                	jle    8004d1 <printnum+0xd7>
			putch(padc, putdat);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	57                   	push   %edi
  800470:	6a 20                	push   $0x20
  800472:	ff d6                	call   *%esi
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	eb ec                	jmp    800465 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	ff 75 18             	pushl  0x18(%ebp)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	53                   	push   %ebx
  800483:	50                   	push   %eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 dc             	pushl  -0x24(%ebp)
  80048a:	ff 75 d8             	pushl  -0x28(%ebp)
  80048d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800490:	ff 75 e0             	pushl  -0x20(%ebp)
  800493:	e8 a8 25 00 00       	call   802a40 <__udivdi3>
  800498:	83 c4 18             	add    $0x18,%esp
  80049b:	52                   	push   %edx
  80049c:	50                   	push   %eax
  80049d:	89 fa                	mov    %edi,%edx
  80049f:	89 f0                	mov    %esi,%eax
  8004a1:	e8 54 ff ff ff       	call   8003fa <printnum>
  8004a6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	57                   	push   %edi
  8004ad:	83 ec 04             	sub    $0x4,%esp
  8004b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bc:	e8 8f 26 00 00       	call   802b50 <__umoddi3>
  8004c1:	83 c4 14             	add    $0x14,%esp
  8004c4:	0f be 80 2f 2e 80 00 	movsbl 0x802e2f(%eax),%eax
  8004cb:	50                   	push   %eax
  8004cc:	ff d6                	call   *%esi
  8004ce:	83 c4 10             	add    $0x10,%esp
	}
}
  8004d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d4:	5b                   	pop    %ebx
  8004d5:	5e                   	pop    %esi
  8004d6:	5f                   	pop    %edi
  8004d7:	5d                   	pop    %ebp
  8004d8:	c3                   	ret    

008004d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e3:	8b 10                	mov    (%eax),%edx
  8004e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e8:	73 0a                	jae    8004f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ed:	89 08                	mov    %ecx,(%eax)
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	88 02                	mov    %al,(%edx)
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <printfmt>:
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ff:	50                   	push   %eax
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 05 00 00 00       	call   800513 <vprintfmt>
}
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	c9                   	leave  
  800512:	c3                   	ret    

00800513 <vprintfmt>:
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	57                   	push   %edi
  800517:	56                   	push   %esi
  800518:	53                   	push   %ebx
  800519:	83 ec 3c             	sub    $0x3c,%esp
  80051c:	8b 75 08             	mov    0x8(%ebp),%esi
  80051f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800522:	8b 7d 10             	mov    0x10(%ebp),%edi
  800525:	e9 32 04 00 00       	jmp    80095c <vprintfmt+0x449>
		padc = ' ';
  80052a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80052e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800535:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80053c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800543:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80054a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800551:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800556:	8d 47 01             	lea    0x1(%edi),%eax
  800559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055c:	0f b6 17             	movzbl (%edi),%edx
  80055f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800562:	3c 55                	cmp    $0x55,%al
  800564:	0f 87 12 05 00 00    	ja     800a7c <vprintfmt+0x569>
  80056a:	0f b6 c0             	movzbl %al,%eax
  80056d:	ff 24 85 00 30 80 00 	jmp    *0x803000(,%eax,4)
  800574:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800577:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80057b:	eb d9                	jmp    800556 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800580:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800584:	eb d0                	jmp    800556 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800586:	0f b6 d2             	movzbl %dl,%edx
  800589:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80058c:	b8 00 00 00 00       	mov    $0x0,%eax
  800591:	89 75 08             	mov    %esi,0x8(%ebp)
  800594:	eb 03                	jmp    800599 <vprintfmt+0x86>
  800596:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800599:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005a6:	83 fe 09             	cmp    $0x9,%esi
  8005a9:	76 eb                	jbe    800596 <vprintfmt+0x83>
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b1:	eb 14                	jmp    8005c7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 40 04             	lea    0x4(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cb:	79 89                	jns    800556 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005da:	e9 77 ff ff ff       	jmp    800556 <vprintfmt+0x43>
  8005df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e2:	85 c0                	test   %eax,%eax
  8005e4:	0f 48 c1             	cmovs  %ecx,%eax
  8005e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ed:	e9 64 ff ff ff       	jmp    800556 <vprintfmt+0x43>
  8005f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005fc:	e9 55 ff ff ff       	jmp    800556 <vprintfmt+0x43>
			lflag++;
  800601:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800605:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800608:	e9 49 ff ff ff       	jmp    800556 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 78 04             	lea    0x4(%eax),%edi
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	ff 30                	pushl  (%eax)
  800619:	ff d6                	call   *%esi
			break;
  80061b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80061e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800621:	e9 33 03 00 00       	jmp    800959 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 78 04             	lea    0x4(%eax),%edi
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	99                   	cltd   
  80062f:	31 d0                	xor    %edx,%eax
  800631:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800633:	83 f8 11             	cmp    $0x11,%eax
  800636:	7f 23                	jg     80065b <vprintfmt+0x148>
  800638:	8b 14 85 60 31 80 00 	mov    0x803160(,%eax,4),%edx
  80063f:	85 d2                	test   %edx,%edx
  800641:	74 18                	je     80065b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800643:	52                   	push   %edx
  800644:	68 8d 33 80 00       	push   $0x80338d
  800649:	53                   	push   %ebx
  80064a:	56                   	push   %esi
  80064b:	e8 a6 fe ff ff       	call   8004f6 <printfmt>
  800650:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800653:	89 7d 14             	mov    %edi,0x14(%ebp)
  800656:	e9 fe 02 00 00       	jmp    800959 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80065b:	50                   	push   %eax
  80065c:	68 47 2e 80 00       	push   $0x802e47
  800661:	53                   	push   %ebx
  800662:	56                   	push   %esi
  800663:	e8 8e fe ff ff       	call   8004f6 <printfmt>
  800668:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80066e:	e9 e6 02 00 00       	jmp    800959 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 c0 04             	add    $0x4,%eax
  800679:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800681:	85 c9                	test   %ecx,%ecx
  800683:	b8 40 2e 80 00       	mov    $0x802e40,%eax
  800688:	0f 45 c1             	cmovne %ecx,%eax
  80068b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80068e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800692:	7e 06                	jle    80069a <vprintfmt+0x187>
  800694:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800698:	75 0d                	jne    8006a7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80069d:	89 c7                	mov    %eax,%edi
  80069f:	03 45 e0             	add    -0x20(%ebp),%eax
  8006a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a5:	eb 53                	jmp    8006fa <vprintfmt+0x1e7>
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ad:	50                   	push   %eax
  8006ae:	e8 71 04 00 00       	call   800b24 <strnlen>
  8006b3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b6:	29 c1                	sub    %eax,%ecx
  8006b8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006c0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c7:	eb 0f                	jmp    8006d8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d2:	83 ef 01             	sub    $0x1,%edi
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	85 ff                	test   %edi,%edi
  8006da:	7f ed                	jg     8006c9 <vprintfmt+0x1b6>
  8006dc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006df:	85 c9                	test   %ecx,%ecx
  8006e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e6:	0f 49 c1             	cmovns %ecx,%eax
  8006e9:	29 c1                	sub    %eax,%ecx
  8006eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006ee:	eb aa                	jmp    80069a <vprintfmt+0x187>
					putch(ch, putdat);
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	53                   	push   %ebx
  8006f4:	52                   	push   %edx
  8006f5:	ff d6                	call   *%esi
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006fd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ff:	83 c7 01             	add    $0x1,%edi
  800702:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800706:	0f be d0             	movsbl %al,%edx
  800709:	85 d2                	test   %edx,%edx
  80070b:	74 4b                	je     800758 <vprintfmt+0x245>
  80070d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800711:	78 06                	js     800719 <vprintfmt+0x206>
  800713:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800717:	78 1e                	js     800737 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800719:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80071d:	74 d1                	je     8006f0 <vprintfmt+0x1dd>
  80071f:	0f be c0             	movsbl %al,%eax
  800722:	83 e8 20             	sub    $0x20,%eax
  800725:	83 f8 5e             	cmp    $0x5e,%eax
  800728:	76 c6                	jbe    8006f0 <vprintfmt+0x1dd>
					putch('?', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 3f                	push   $0x3f
  800730:	ff d6                	call   *%esi
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	eb c3                	jmp    8006fa <vprintfmt+0x1e7>
  800737:	89 cf                	mov    %ecx,%edi
  800739:	eb 0e                	jmp    800749 <vprintfmt+0x236>
				putch(' ', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 20                	push   $0x20
  800741:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800743:	83 ef 01             	sub    $0x1,%edi
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	85 ff                	test   %edi,%edi
  80074b:	7f ee                	jg     80073b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80074d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
  800753:	e9 01 02 00 00       	jmp    800959 <vprintfmt+0x446>
  800758:	89 cf                	mov    %ecx,%edi
  80075a:	eb ed                	jmp    800749 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80075c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80075f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800766:	e9 eb fd ff ff       	jmp    800556 <vprintfmt+0x43>
	if (lflag >= 2)
  80076b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80076f:	7f 21                	jg     800792 <vprintfmt+0x27f>
	else if (lflag)
  800771:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800775:	74 68                	je     8007df <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80077f:	89 c1                	mov    %eax,%ecx
  800781:	c1 f9 1f             	sar    $0x1f,%ecx
  800784:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 40 04             	lea    0x4(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
  800790:	eb 17                	jmp    8007a9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 50 04             	mov    0x4(%eax),%edx
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80079d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 08             	lea    0x8(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007b9:	78 3f                	js     8007fa <vprintfmt+0x2e7>
			base = 10;
  8007bb:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007c0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007c4:	0f 84 71 01 00 00    	je     80093b <vprintfmt+0x428>
				putch('+', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	6a 2b                	push   $0x2b
  8007d0:	ff d6                	call   *%esi
  8007d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	e9 5c 01 00 00       	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007e7:	89 c1                	mov    %eax,%ecx
  8007e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f8:	eb af                	jmp    8007a9 <vprintfmt+0x296>
				putch('-', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	53                   	push   %ebx
  8007fe:	6a 2d                	push   $0x2d
  800800:	ff d6                	call   *%esi
				num = -(long long) num;
  800802:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800805:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800808:	f7 d8                	neg    %eax
  80080a:	83 d2 00             	adc    $0x0,%edx
  80080d:	f7 da                	neg    %edx
  80080f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800812:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800815:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800818:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081d:	e9 19 01 00 00       	jmp    80093b <vprintfmt+0x428>
	if (lflag >= 2)
  800822:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800826:	7f 29                	jg     800851 <vprintfmt+0x33e>
	else if (lflag)
  800828:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082c:	74 44                	je     800872 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
  800838:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8d 40 04             	lea    0x4(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800847:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084c:	e9 ea 00 00 00       	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 50 04             	mov    0x4(%eax),%edx
  800857:	8b 00                	mov    (%eax),%eax
  800859:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 40 08             	lea    0x8(%eax),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800868:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086d:	e9 c9 00 00 00       	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	ba 00 00 00 00       	mov    $0x0,%edx
  80087c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	8d 40 04             	lea    0x4(%eax),%eax
  800888:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80088b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800890:	e9 a6 00 00 00       	jmp    80093b <vprintfmt+0x428>
			putch('0', putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	53                   	push   %ebx
  800899:	6a 30                	push   $0x30
  80089b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a4:	7f 26                	jg     8008cc <vprintfmt+0x3b9>
	else if (lflag)
  8008a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008aa:	74 3e                	je     8008ea <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 40 04             	lea    0x4(%eax),%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ca:	eb 6f                	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8b 50 04             	mov    0x4(%eax),%edx
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	8d 40 08             	lea    0x8(%eax),%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8008e8:	eb 51                	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8d 40 04             	lea    0x4(%eax),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800903:	b8 08 00 00 00       	mov    $0x8,%eax
  800908:	eb 31                	jmp    80093b <vprintfmt+0x428>
			putch('0', putdat);
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	6a 30                	push   $0x30
  800910:	ff d6                	call   *%esi
			putch('x', putdat);
  800912:	83 c4 08             	add    $0x8,%esp
  800915:	53                   	push   %ebx
  800916:	6a 78                	push   $0x78
  800918:	ff d6                	call   *%esi
			num = (unsigned long long)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80092a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 40 04             	lea    0x4(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800936:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80093b:	83 ec 0c             	sub    $0xc,%esp
  80093e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800942:	52                   	push   %edx
  800943:	ff 75 e0             	pushl  -0x20(%ebp)
  800946:	50                   	push   %eax
  800947:	ff 75 dc             	pushl  -0x24(%ebp)
  80094a:	ff 75 d8             	pushl  -0x28(%ebp)
  80094d:	89 da                	mov    %ebx,%edx
  80094f:	89 f0                	mov    %esi,%eax
  800951:	e8 a4 fa ff ff       	call   8003fa <printnum>
			break;
  800956:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800959:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095c:	83 c7 01             	add    $0x1,%edi
  80095f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800963:	83 f8 25             	cmp    $0x25,%eax
  800966:	0f 84 be fb ff ff    	je     80052a <vprintfmt+0x17>
			if (ch == '\0')
  80096c:	85 c0                	test   %eax,%eax
  80096e:	0f 84 28 01 00 00    	je     800a9c <vprintfmt+0x589>
			putch(ch, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	53                   	push   %ebx
  800978:	50                   	push   %eax
  800979:	ff d6                	call   *%esi
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	eb dc                	jmp    80095c <vprintfmt+0x449>
	if (lflag >= 2)
  800980:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800984:	7f 26                	jg     8009ac <vprintfmt+0x499>
	else if (lflag)
  800986:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098a:	74 41                	je     8009cd <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	ba 00 00 00 00       	mov    $0x0,%edx
  800996:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800999:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	8d 40 04             	lea    0x4(%eax),%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009a5:	b8 10 00 00 00       	mov    $0x10,%eax
  8009aa:	eb 8f                	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8b 50 04             	mov    0x4(%eax),%edx
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8d 40 08             	lea    0x8(%eax),%eax
  8009c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8009c8:	e9 6e ff ff ff       	jmp    80093b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	8d 40 04             	lea    0x4(%eax),%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8009eb:	e9 4b ff ff ff       	jmp    80093b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	83 c0 04             	add    $0x4,%eax
  8009f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	74 14                	je     800a16 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a02:	8b 13                	mov    (%ebx),%edx
  800a04:	83 fa 7f             	cmp    $0x7f,%edx
  800a07:	7f 37                	jg     800a40 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a09:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a11:	e9 43 ff ff ff       	jmp    800959 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a16:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a1b:	bf 65 2f 80 00       	mov    $0x802f65,%edi
							putch(ch, putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	53                   	push   %ebx
  800a24:	50                   	push   %eax
  800a25:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a27:	83 c7 01             	add    $0x1,%edi
  800a2a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	85 c0                	test   %eax,%eax
  800a33:	75 eb                	jne    800a20 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a38:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3b:	e9 19 ff ff ff       	jmp    800959 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a40:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a42:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a47:	bf 9d 2f 80 00       	mov    $0x802f9d,%edi
							putch(ch, putdat);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	53                   	push   %ebx
  800a50:	50                   	push   %eax
  800a51:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a53:	83 c7 01             	add    $0x1,%edi
  800a56:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	75 eb                	jne    800a4c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
  800a67:	e9 ed fe ff ff       	jmp    800959 <vprintfmt+0x446>
			putch(ch, putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	53                   	push   %ebx
  800a70:	6a 25                	push   $0x25
  800a72:	ff d6                	call   *%esi
			break;
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	e9 dd fe ff ff       	jmp    800959 <vprintfmt+0x446>
			putch('%', putdat);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	53                   	push   %ebx
  800a80:	6a 25                	push   $0x25
  800a82:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	89 f8                	mov    %edi,%eax
  800a89:	eb 03                	jmp    800a8e <vprintfmt+0x57b>
  800a8b:	83 e8 01             	sub    $0x1,%eax
  800a8e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a92:	75 f7                	jne    800a8b <vprintfmt+0x578>
  800a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a97:	e9 bd fe ff ff       	jmp    800959 <vprintfmt+0x446>
}
  800a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5f                   	pop    %edi
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	83 ec 18             	sub    $0x18,%esp
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ab7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 26                	je     800aeb <vsnprintf+0x47>
  800ac5:	85 d2                	test   %edx,%edx
  800ac7:	7e 22                	jle    800aeb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ac9:	ff 75 14             	pushl  0x14(%ebp)
  800acc:	ff 75 10             	pushl  0x10(%ebp)
  800acf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad2:	50                   	push   %eax
  800ad3:	68 d9 04 80 00       	push   $0x8004d9
  800ad8:	e8 36 fa ff ff       	call   800513 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    
		return -E_INVAL;
  800aeb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800af0:	eb f7                	jmp    800ae9 <vsnprintf+0x45>

00800af2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800afb:	50                   	push   %eax
  800afc:	ff 75 10             	pushl  0x10(%ebp)
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	ff 75 08             	pushl  0x8(%ebp)
  800b05:	e8 9a ff ff ff       	call   800aa4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b12:	b8 00 00 00 00       	mov    $0x0,%eax
  800b17:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b1b:	74 05                	je     800b22 <strlen+0x16>
		n++;
  800b1d:	83 c0 01             	add    $0x1,%eax
  800b20:	eb f5                	jmp    800b17 <strlen+0xb>
	return n;
}
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	39 c2                	cmp    %eax,%edx
  800b34:	74 0d                	je     800b43 <strnlen+0x1f>
  800b36:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b3a:	74 05                	je     800b41 <strnlen+0x1d>
		n++;
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	eb f1                	jmp    800b32 <strnlen+0xe>
  800b41:	89 d0                	mov    %edx,%eax
	return n;
}
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	53                   	push   %ebx
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b54:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b58:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b5b:	83 c2 01             	add    $0x1,%edx
  800b5e:	84 c9                	test   %cl,%cl
  800b60:	75 f2                	jne    800b54 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b62:	5b                   	pop    %ebx
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	83 ec 10             	sub    $0x10,%esp
  800b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b6f:	53                   	push   %ebx
  800b70:	e8 97 ff ff ff       	call   800b0c <strlen>
  800b75:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	01 d8                	add    %ebx,%eax
  800b7d:	50                   	push   %eax
  800b7e:	e8 c2 ff ff ff       	call   800b45 <strcpy>
	return dst;
}
  800b83:	89 d8                	mov    %ebx,%eax
  800b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b95:	89 c6                	mov    %eax,%esi
  800b97:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9a:	89 c2                	mov    %eax,%edx
  800b9c:	39 f2                	cmp    %esi,%edx
  800b9e:	74 11                	je     800bb1 <strncpy+0x27>
		*dst++ = *src;
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	0f b6 19             	movzbl (%ecx),%ebx
  800ba6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ba9:	80 fb 01             	cmp    $0x1,%bl
  800bac:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800baf:	eb eb                	jmp    800b9c <strncpy+0x12>
	}
	return ret;
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	8b 75 08             	mov    0x8(%ebp),%esi
  800bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc0:	8b 55 10             	mov    0x10(%ebp),%edx
  800bc3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bc5:	85 d2                	test   %edx,%edx
  800bc7:	74 21                	je     800bea <strlcpy+0x35>
  800bc9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bcd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 14                	je     800be7 <strlcpy+0x32>
  800bd3:	0f b6 19             	movzbl (%ecx),%ebx
  800bd6:	84 db                	test   %bl,%bl
  800bd8:	74 0b                	je     800be5 <strlcpy+0x30>
			*dst++ = *src++;
  800bda:	83 c1 01             	add    $0x1,%ecx
  800bdd:	83 c2 01             	add    $0x1,%edx
  800be0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800be3:	eb ea                	jmp    800bcf <strlcpy+0x1a>
  800be5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800be7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bea:	29 f0                	sub    %esi,%eax
}
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bf9:	0f b6 01             	movzbl (%ecx),%eax
  800bfc:	84 c0                	test   %al,%al
  800bfe:	74 0c                	je     800c0c <strcmp+0x1c>
  800c00:	3a 02                	cmp    (%edx),%al
  800c02:	75 08                	jne    800c0c <strcmp+0x1c>
		p++, q++;
  800c04:	83 c1 01             	add    $0x1,%ecx
  800c07:	83 c2 01             	add    $0x1,%edx
  800c0a:	eb ed                	jmp    800bf9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0c:	0f b6 c0             	movzbl %al,%eax
  800c0f:	0f b6 12             	movzbl (%edx),%edx
  800c12:	29 d0                	sub    %edx,%eax
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	53                   	push   %ebx
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	89 c3                	mov    %eax,%ebx
  800c22:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c25:	eb 06                	jmp    800c2d <strncmp+0x17>
		n--, p++, q++;
  800c27:	83 c0 01             	add    $0x1,%eax
  800c2a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c2d:	39 d8                	cmp    %ebx,%eax
  800c2f:	74 16                	je     800c47 <strncmp+0x31>
  800c31:	0f b6 08             	movzbl (%eax),%ecx
  800c34:	84 c9                	test   %cl,%cl
  800c36:	74 04                	je     800c3c <strncmp+0x26>
  800c38:	3a 0a                	cmp    (%edx),%cl
  800c3a:	74 eb                	je     800c27 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3c:	0f b6 00             	movzbl (%eax),%eax
  800c3f:	0f b6 12             	movzbl (%edx),%edx
  800c42:	29 d0                	sub    %edx,%eax
}
  800c44:	5b                   	pop    %ebx
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    
		return 0;
  800c47:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4c:	eb f6                	jmp    800c44 <strncmp+0x2e>

00800c4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c58:	0f b6 10             	movzbl (%eax),%edx
  800c5b:	84 d2                	test   %dl,%dl
  800c5d:	74 09                	je     800c68 <strchr+0x1a>
		if (*s == c)
  800c5f:	38 ca                	cmp    %cl,%dl
  800c61:	74 0a                	je     800c6d <strchr+0x1f>
	for (; *s; s++)
  800c63:	83 c0 01             	add    $0x1,%eax
  800c66:	eb f0                	jmp    800c58 <strchr+0xa>
			return (char *) s;
	return 0;
  800c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c79:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c7c:	38 ca                	cmp    %cl,%dl
  800c7e:	74 09                	je     800c89 <strfind+0x1a>
  800c80:	84 d2                	test   %dl,%dl
  800c82:	74 05                	je     800c89 <strfind+0x1a>
	for (; *s; s++)
  800c84:	83 c0 01             	add    $0x1,%eax
  800c87:	eb f0                	jmp    800c79 <strfind+0xa>
			break;
	return (char *) s;
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c97:	85 c9                	test   %ecx,%ecx
  800c99:	74 31                	je     800ccc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c9b:	89 f8                	mov    %edi,%eax
  800c9d:	09 c8                	or     %ecx,%eax
  800c9f:	a8 03                	test   $0x3,%al
  800ca1:	75 23                	jne    800cc6 <memset+0x3b>
		c &= 0xFF;
  800ca3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	c1 e3 08             	shl    $0x8,%ebx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 18             	shl    $0x18,%eax
  800cb1:	89 d6                	mov    %edx,%esi
  800cb3:	c1 e6 10             	shl    $0x10,%esi
  800cb6:	09 f0                	or     %esi,%eax
  800cb8:	09 c2                	or     %eax,%edx
  800cba:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cbc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cbf:	89 d0                	mov    %edx,%eax
  800cc1:	fc                   	cld    
  800cc2:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc4:	eb 06                	jmp    800ccc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc9:	fc                   	cld    
  800cca:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ccc:	89 f8                	mov    %edi,%eax
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce1:	39 c6                	cmp    %eax,%esi
  800ce3:	73 32                	jae    800d17 <memmove+0x44>
  800ce5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce8:	39 c2                	cmp    %eax,%edx
  800cea:	76 2b                	jbe    800d17 <memmove+0x44>
		s += n;
		d += n;
  800cec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cef:	89 fe                	mov    %edi,%esi
  800cf1:	09 ce                	or     %ecx,%esi
  800cf3:	09 d6                	or     %edx,%esi
  800cf5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cfb:	75 0e                	jne    800d0b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cfd:	83 ef 04             	sub    $0x4,%edi
  800d00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d06:	fd                   	std    
  800d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d09:	eb 09                	jmp    800d14 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0b:	83 ef 01             	sub    $0x1,%edi
  800d0e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d11:	fd                   	std    
  800d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d14:	fc                   	cld    
  800d15:	eb 1a                	jmp    800d31 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d17:	89 c2                	mov    %eax,%edx
  800d19:	09 ca                	or     %ecx,%edx
  800d1b:	09 f2                	or     %esi,%edx
  800d1d:	f6 c2 03             	test   $0x3,%dl
  800d20:	75 0a                	jne    800d2c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d25:	89 c7                	mov    %eax,%edi
  800d27:	fc                   	cld    
  800d28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2a:	eb 05                	jmp    800d31 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d2c:	89 c7                	mov    %eax,%edi
  800d2e:	fc                   	cld    
  800d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d3b:	ff 75 10             	pushl  0x10(%ebp)
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	ff 75 08             	pushl  0x8(%ebp)
  800d44:	e8 8a ff ff ff       	call   800cd3 <memmove>
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d56:	89 c6                	mov    %eax,%esi
  800d58:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d5b:	39 f0                	cmp    %esi,%eax
  800d5d:	74 1c                	je     800d7b <memcmp+0x30>
		if (*s1 != *s2)
  800d5f:	0f b6 08             	movzbl (%eax),%ecx
  800d62:	0f b6 1a             	movzbl (%edx),%ebx
  800d65:	38 d9                	cmp    %bl,%cl
  800d67:	75 08                	jne    800d71 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d69:	83 c0 01             	add    $0x1,%eax
  800d6c:	83 c2 01             	add    $0x1,%edx
  800d6f:	eb ea                	jmp    800d5b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d71:	0f b6 c1             	movzbl %cl,%eax
  800d74:	0f b6 db             	movzbl %bl,%ebx
  800d77:	29 d8                	sub    %ebx,%eax
  800d79:	eb 05                	jmp    800d80 <memcmp+0x35>
	}

	return 0;
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d8d:	89 c2                	mov    %eax,%edx
  800d8f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d92:	39 d0                	cmp    %edx,%eax
  800d94:	73 09                	jae    800d9f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d96:	38 08                	cmp    %cl,(%eax)
  800d98:	74 05                	je     800d9f <memfind+0x1b>
	for (; s < ends; s++)
  800d9a:	83 c0 01             	add    $0x1,%eax
  800d9d:	eb f3                	jmp    800d92 <memfind+0xe>
			break;
	return (void *) s;
}
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800daa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dad:	eb 03                	jmp    800db2 <strtol+0x11>
		s++;
  800daf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800db2:	0f b6 01             	movzbl (%ecx),%eax
  800db5:	3c 20                	cmp    $0x20,%al
  800db7:	74 f6                	je     800daf <strtol+0xe>
  800db9:	3c 09                	cmp    $0x9,%al
  800dbb:	74 f2                	je     800daf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dbd:	3c 2b                	cmp    $0x2b,%al
  800dbf:	74 2a                	je     800deb <strtol+0x4a>
	int neg = 0;
  800dc1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dc6:	3c 2d                	cmp    $0x2d,%al
  800dc8:	74 2b                	je     800df5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dca:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dd0:	75 0f                	jne    800de1 <strtol+0x40>
  800dd2:	80 39 30             	cmpb   $0x30,(%ecx)
  800dd5:	74 28                	je     800dff <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dde:	0f 44 d8             	cmove  %eax,%ebx
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
  800de6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800de9:	eb 50                	jmp    800e3b <strtol+0x9a>
		s++;
  800deb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dee:	bf 00 00 00 00       	mov    $0x0,%edi
  800df3:	eb d5                	jmp    800dca <strtol+0x29>
		s++, neg = 1;
  800df5:	83 c1 01             	add    $0x1,%ecx
  800df8:	bf 01 00 00 00       	mov    $0x1,%edi
  800dfd:	eb cb                	jmp    800dca <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dff:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e03:	74 0e                	je     800e13 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e05:	85 db                	test   %ebx,%ebx
  800e07:	75 d8                	jne    800de1 <strtol+0x40>
		s++, base = 8;
  800e09:	83 c1 01             	add    $0x1,%ecx
  800e0c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e11:	eb ce                	jmp    800de1 <strtol+0x40>
		s += 2, base = 16;
  800e13:	83 c1 02             	add    $0x2,%ecx
  800e16:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e1b:	eb c4                	jmp    800de1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e1d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e20:	89 f3                	mov    %esi,%ebx
  800e22:	80 fb 19             	cmp    $0x19,%bl
  800e25:	77 29                	ja     800e50 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e27:	0f be d2             	movsbl %dl,%edx
  800e2a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e2d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e30:	7d 30                	jge    800e62 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e32:	83 c1 01             	add    $0x1,%ecx
  800e35:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e39:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e3b:	0f b6 11             	movzbl (%ecx),%edx
  800e3e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e41:	89 f3                	mov    %esi,%ebx
  800e43:	80 fb 09             	cmp    $0x9,%bl
  800e46:	77 d5                	ja     800e1d <strtol+0x7c>
			dig = *s - '0';
  800e48:	0f be d2             	movsbl %dl,%edx
  800e4b:	83 ea 30             	sub    $0x30,%edx
  800e4e:	eb dd                	jmp    800e2d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e50:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e53:	89 f3                	mov    %esi,%ebx
  800e55:	80 fb 19             	cmp    $0x19,%bl
  800e58:	77 08                	ja     800e62 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e5a:	0f be d2             	movsbl %dl,%edx
  800e5d:	83 ea 37             	sub    $0x37,%edx
  800e60:	eb cb                	jmp    800e2d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e66:	74 05                	je     800e6d <strtol+0xcc>
		*endptr = (char *) s;
  800e68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e6b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e6d:	89 c2                	mov    %eax,%edx
  800e6f:	f7 da                	neg    %edx
  800e71:	85 ff                	test   %edi,%edi
  800e73:	0f 45 c2             	cmovne %edx,%eax
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8c:	89 c3                	mov    %eax,%ebx
  800e8e:	89 c7                	mov    %eax,%edi
  800e90:	89 c6                	mov    %eax,%esi
  800e92:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea9:	89 d1                	mov    %edx,%ecx
  800eab:	89 d3                	mov    %edx,%ebx
  800ead:	89 d7                	mov    %edx,%edi
  800eaf:	89 d6                	mov    %edx,%esi
  800eb1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ece:	89 cb                	mov    %ecx,%ebx
  800ed0:	89 cf                	mov    %ecx,%edi
  800ed2:	89 ce                	mov    %ecx,%esi
  800ed4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7f 08                	jg     800ee2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edd:	5b                   	pop    %ebx
  800ede:	5e                   	pop    %esi
  800edf:	5f                   	pop    %edi
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	50                   	push   %eax
  800ee6:	6a 03                	push   $0x3
  800ee8:	68 a8 31 80 00       	push   $0x8031a8
  800eed:	6a 43                	push   $0x43
  800eef:	68 c5 31 80 00       	push   $0x8031c5
  800ef4:	e8 f7 f3 ff ff       	call   8002f0 <_panic>

00800ef9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eff:	ba 00 00 00 00       	mov    $0x0,%edx
  800f04:	b8 02 00 00 00       	mov    $0x2,%eax
  800f09:	89 d1                	mov    %edx,%ecx
  800f0b:	89 d3                	mov    %edx,%ebx
  800f0d:	89 d7                	mov    %edx,%edi
  800f0f:	89 d6                	mov    %edx,%esi
  800f11:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f13:	5b                   	pop    %ebx
  800f14:	5e                   	pop    %esi
  800f15:	5f                   	pop    %edi
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <sys_yield>:

void
sys_yield(void)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f28:	89 d1                	mov    %edx,%ecx
  800f2a:	89 d3                	mov    %edx,%ebx
  800f2c:	89 d7                	mov    %edx,%edi
  800f2e:	89 d6                	mov    %edx,%esi
  800f30:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f40:	be 00 00 00 00       	mov    $0x0,%esi
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	b8 04 00 00 00       	mov    $0x4,%eax
  800f50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f53:	89 f7                	mov    %esi,%edi
  800f55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7f 08                	jg     800f63 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800f67:	6a 04                	push   $0x4
  800f69:	68 a8 31 80 00       	push   $0x8031a8
  800f6e:	6a 43                	push   $0x43
  800f70:	68 c5 31 80 00       	push   $0x8031c5
  800f75:	e8 76 f3 ff ff       	call   8002f0 <_panic>

00800f7a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	b8 05 00 00 00       	mov    $0x5,%eax
  800f8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f94:	8b 75 18             	mov    0x18(%ebp),%esi
  800f97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7f 08                	jg     800fa5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800fa9:	6a 05                	push   $0x5
  800fab:	68 a8 31 80 00       	push   $0x8031a8
  800fb0:	6a 43                	push   $0x43
  800fb2:	68 c5 31 80 00       	push   $0x8031c5
  800fb7:	e8 34 f3 ff ff       	call   8002f0 <_panic>

00800fbc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800fd0:	b8 06 00 00 00       	mov    $0x6,%eax
  800fd5:	89 df                	mov    %ebx,%edi
  800fd7:	89 de                	mov    %ebx,%esi
  800fd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	7f 08                	jg     800fe7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800feb:	6a 06                	push   $0x6
  800fed:	68 a8 31 80 00       	push   $0x8031a8
  800ff2:	6a 43                	push   $0x43
  800ff4:	68 c5 31 80 00       	push   $0x8031c5
  800ff9:	e8 f2 f2 ff ff       	call   8002f0 <_panic>

00800ffe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  801012:	b8 08 00 00 00       	mov    $0x8,%eax
  801017:	89 df                	mov    %ebx,%edi
  801019:	89 de                	mov    %ebx,%esi
  80101b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	7f 08                	jg     801029 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  80102d:	6a 08                	push   $0x8
  80102f:	68 a8 31 80 00       	push   $0x8031a8
  801034:	6a 43                	push   $0x43
  801036:	68 c5 31 80 00       	push   $0x8031c5
  80103b:	e8 b0 f2 ff ff       	call   8002f0 <_panic>

00801040 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  801054:	b8 09 00 00 00       	mov    $0x9,%eax
  801059:	89 df                	mov    %ebx,%edi
  80105b:	89 de                	mov    %ebx,%esi
  80105d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7f 08                	jg     80106b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  80106f:	6a 09                	push   $0x9
  801071:	68 a8 31 80 00       	push   $0x8031a8
  801076:	6a 43                	push   $0x43
  801078:	68 c5 31 80 00       	push   $0x8031c5
  80107d:	e8 6e f2 ff ff       	call   8002f0 <_panic>

00801082 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801090:	8b 55 08             	mov    0x8(%ebp),%edx
  801093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801096:	b8 0a 00 00 00       	mov    $0xa,%eax
  80109b:	89 df                	mov    %ebx,%edi
  80109d:	89 de                	mov    %ebx,%esi
  80109f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	7f 08                	jg     8010ad <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	50                   	push   %eax
  8010b1:	6a 0a                	push   $0xa
  8010b3:	68 a8 31 80 00       	push   $0x8031a8
  8010b8:	6a 43                	push   $0x43
  8010ba:	68 c5 31 80 00       	push   $0x8031c5
  8010bf:	e8 2c f2 ff ff       	call   8002f0 <_panic>

008010c4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010d5:	be 00 00 00 00       	mov    $0x0,%esi
  8010da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010dd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010fd:	89 cb                	mov    %ecx,%ebx
  8010ff:	89 cf                	mov    %ecx,%edi
  801101:	89 ce                	mov    %ecx,%esi
  801103:	cd 30                	int    $0x30
	if(check && ret > 0)
  801105:	85 c0                	test   %eax,%eax
  801107:	7f 08                	jg     801111 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	50                   	push   %eax
  801115:	6a 0d                	push   $0xd
  801117:	68 a8 31 80 00       	push   $0x8031a8
  80111c:	6a 43                	push   $0x43
  80111e:	68 c5 31 80 00       	push   $0x8031c5
  801123:	e8 c8 f1 ff ff       	call   8002f0 <_panic>

00801128 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801139:	b8 0e 00 00 00       	mov    $0xe,%eax
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	57                   	push   %edi
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	b8 0f 00 00 00       	mov    $0xf,%eax
  80115c:	89 cb                	mov    %ecx,%ebx
  80115e:	89 cf                	mov    %ecx,%edi
  801160:	89 ce                	mov    %ecx,%esi
  801162:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116f:	ba 00 00 00 00       	mov    $0x0,%edx
  801174:	b8 10 00 00 00       	mov    $0x10,%eax
  801179:	89 d1                	mov    %edx,%ecx
  80117b:	89 d3                	mov    %edx,%ebx
  80117d:	89 d7                	mov    %edx,%edi
  80117f:	89 d6                	mov    %edx,%esi
  801181:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801199:	b8 11 00 00 00       	mov    $0x11,%eax
  80119e:	89 df                	mov    %ebx,%edi
  8011a0:	89 de                	mov    %ebx,%esi
  8011a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011a4:	5b                   	pop    %ebx
  8011a5:	5e                   	pop    %esi
  8011a6:	5f                   	pop    %edi
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	57                   	push   %edi
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ba:	b8 12 00 00 00       	mov    $0x12,%eax
  8011bf:	89 df                	mov    %ebx,%edi
  8011c1:	89 de                	mov    %ebx,%esi
  8011c3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	57                   	push   %edi
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
  8011d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011de:	b8 13 00 00 00       	mov    $0x13,%eax
  8011e3:	89 df                	mov    %ebx,%edi
  8011e5:	89 de                	mov    %ebx,%esi
  8011e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	7f 08                	jg     8011f5 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f0:	5b                   	pop    %ebx
  8011f1:	5e                   	pop    %esi
  8011f2:	5f                   	pop    %edi
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	50                   	push   %eax
  8011f9:	6a 13                	push   $0x13
  8011fb:	68 a8 31 80 00       	push   $0x8031a8
  801200:	6a 43                	push   $0x43
  801202:	68 c5 31 80 00       	push   $0x8031c5
  801207:	e8 e4 f0 ff ff       	call   8002f0 <_panic>

0080120c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	57                   	push   %edi
  801210:	56                   	push   %esi
  801211:	53                   	push   %ebx
	asm volatile("int %1\n"
  801212:	b9 00 00 00 00       	mov    $0x0,%ecx
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	b8 14 00 00 00       	mov    $0x14,%eax
  80121f:	89 cb                	mov    %ecx,%ebx
  801221:	89 cf                	mov    %ecx,%edi
  801223:	89 ce                	mov    %ecx,%esi
  801225:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5f                   	pop    %edi
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	53                   	push   %ebx
  801230:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801233:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80123a:	f6 c5 04             	test   $0x4,%ch
  80123d:	75 45                	jne    801284 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80123f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801246:	83 e1 07             	and    $0x7,%ecx
  801249:	83 f9 07             	cmp    $0x7,%ecx
  80124c:	74 6f                	je     8012bd <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80124e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801255:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80125b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801261:	0f 84 b6 00 00 00    	je     80131d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801267:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80126e:	83 e1 05             	and    $0x5,%ecx
  801271:	83 f9 05             	cmp    $0x5,%ecx
  801274:	0f 84 d7 00 00 00    	je     801351 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
  80127f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801282:	c9                   	leave  
  801283:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801284:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80128b:	c1 e2 0c             	shl    $0xc,%edx
  80128e:	83 ec 0c             	sub    $0xc,%esp
  801291:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801297:	51                   	push   %ecx
  801298:	52                   	push   %edx
  801299:	50                   	push   %eax
  80129a:	52                   	push   %edx
  80129b:	6a 00                	push   $0x0
  80129d:	e8 d8 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  8012a2:	83 c4 20             	add    $0x20,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	79 d1                	jns    80127a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	68 d3 31 80 00       	push   $0x8031d3
  8012b1:	6a 54                	push   $0x54
  8012b3:	68 e9 31 80 00       	push   $0x8031e9
  8012b8:	e8 33 f0 ff ff       	call   8002f0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012bd:	89 d3                	mov    %edx,%ebx
  8012bf:	c1 e3 0c             	shl    $0xc,%ebx
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	68 05 08 00 00       	push   $0x805
  8012ca:	53                   	push   %ebx
  8012cb:	50                   	push   %eax
  8012cc:	53                   	push   %ebx
  8012cd:	6a 00                	push   $0x0
  8012cf:	e8 a6 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  8012d4:	83 c4 20             	add    $0x20,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	78 2e                	js     801309 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012db:	83 ec 0c             	sub    $0xc,%esp
  8012de:	68 05 08 00 00       	push   $0x805
  8012e3:	53                   	push   %ebx
  8012e4:	6a 00                	push   $0x0
  8012e6:	53                   	push   %ebx
  8012e7:	6a 00                	push   $0x0
  8012e9:	e8 8c fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  8012ee:	83 c4 20             	add    $0x20,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	79 85                	jns    80127a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	68 d3 31 80 00       	push   $0x8031d3
  8012fd:	6a 5f                	push   $0x5f
  8012ff:	68 e9 31 80 00       	push   $0x8031e9
  801304:	e8 e7 ef ff ff       	call   8002f0 <_panic>
			panic("sys_page_map() panic\n");
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	68 d3 31 80 00       	push   $0x8031d3
  801311:	6a 5b                	push   $0x5b
  801313:	68 e9 31 80 00       	push   $0x8031e9
  801318:	e8 d3 ef ff ff       	call   8002f0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80131d:	c1 e2 0c             	shl    $0xc,%edx
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 05 08 00 00       	push   $0x805
  801328:	52                   	push   %edx
  801329:	50                   	push   %eax
  80132a:	52                   	push   %edx
  80132b:	6a 00                	push   $0x0
  80132d:	e8 48 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  801332:	83 c4 20             	add    $0x20,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	0f 89 3d ff ff ff    	jns    80127a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	68 d3 31 80 00       	push   $0x8031d3
  801345:	6a 66                	push   $0x66
  801347:	68 e9 31 80 00       	push   $0x8031e9
  80134c:	e8 9f ef ff ff       	call   8002f0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801351:	c1 e2 0c             	shl    $0xc,%edx
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	6a 05                	push   $0x5
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	52                   	push   %edx
  80135c:	6a 00                	push   $0x0
  80135e:	e8 17 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  801363:	83 c4 20             	add    $0x20,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	0f 89 0c ff ff ff    	jns    80127a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 d3 31 80 00       	push   $0x8031d3
  801376:	6a 6d                	push   $0x6d
  801378:	68 e9 31 80 00       	push   $0x8031e9
  80137d:	e8 6e ef ff ff       	call   8002f0 <_panic>

00801382 <pgfault>:
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	53                   	push   %ebx
  801386:	83 ec 04             	sub    $0x4,%esp
  801389:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80138c:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80138e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801392:	0f 84 99 00 00 00    	je     801431 <pgfault+0xaf>
  801398:	89 c2                	mov    %eax,%edx
  80139a:	c1 ea 16             	shr    $0x16,%edx
  80139d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013a4:	f6 c2 01             	test   $0x1,%dl
  8013a7:	0f 84 84 00 00 00    	je     801431 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013ad:	89 c2                	mov    %eax,%edx
  8013af:	c1 ea 0c             	shr    $0xc,%edx
  8013b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013b9:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013bf:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013c5:	75 6a                	jne    801431 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cc:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	6a 07                	push   $0x7
  8013d3:	68 00 f0 7f 00       	push   $0x7ff000
  8013d8:	6a 00                	push   $0x0
  8013da:	e8 58 fb ff ff       	call   800f37 <sys_page_alloc>
	if(ret < 0)
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 5f                	js     801445 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	68 00 10 00 00       	push   $0x1000
  8013ee:	53                   	push   %ebx
  8013ef:	68 00 f0 7f 00       	push   $0x7ff000
  8013f4:	e8 3c f9 ff ff       	call   800d35 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013f9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801400:	53                   	push   %ebx
  801401:	6a 00                	push   $0x0
  801403:	68 00 f0 7f 00       	push   $0x7ff000
  801408:	6a 00                	push   $0x0
  80140a:	e8 6b fb ff ff       	call   800f7a <sys_page_map>
	if(ret < 0)
  80140f:	83 c4 20             	add    $0x20,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	78 43                	js     801459 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	68 00 f0 7f 00       	push   $0x7ff000
  80141e:	6a 00                	push   $0x0
  801420:	e8 97 fb ff ff       	call   800fbc <sys_page_unmap>
	if(ret < 0)
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 41                	js     80146d <pgfault+0xeb>
}
  80142c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142f:	c9                   	leave  
  801430:	c3                   	ret    
		panic("panic at pgfault()\n");
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	68 f4 31 80 00       	push   $0x8031f4
  801439:	6a 26                	push   $0x26
  80143b:	68 e9 31 80 00       	push   $0x8031e9
  801440:	e8 ab ee ff ff       	call   8002f0 <_panic>
		panic("panic in sys_page_alloc()\n");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 08 32 80 00       	push   $0x803208
  80144d:	6a 31                	push   $0x31
  80144f:	68 e9 31 80 00       	push   $0x8031e9
  801454:	e8 97 ee ff ff       	call   8002f0 <_panic>
		panic("panic in sys_page_map()\n");
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	68 23 32 80 00       	push   $0x803223
  801461:	6a 36                	push   $0x36
  801463:	68 e9 31 80 00       	push   $0x8031e9
  801468:	e8 83 ee ff ff       	call   8002f0 <_panic>
		panic("panic in sys_page_unmap()\n");
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	68 3c 32 80 00       	push   $0x80323c
  801475:	6a 39                	push   $0x39
  801477:	68 e9 31 80 00       	push   $0x8031e9
  80147c:	e8 6f ee ff ff       	call   8002f0 <_panic>

00801481 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	57                   	push   %edi
  801485:	56                   	push   %esi
  801486:	53                   	push   %ebx
  801487:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80148a:	68 82 13 80 00       	push   $0x801382
  80148f:	e8 0c 15 00 00       	call   8029a0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801494:	b8 07 00 00 00       	mov    $0x7,%eax
  801499:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 27                	js     8014c9 <fork+0x48>
  8014a2:	89 c6                	mov    %eax,%esi
  8014a4:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014a6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014ab:	75 48                	jne    8014f5 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014ad:	e8 47 fa ff ff       	call   800ef9 <sys_getenvid>
  8014b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014b7:	c1 e0 07             	shl    $0x7,%eax
  8014ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014bf:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014c4:	e9 90 00 00 00       	jmp    801559 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	68 58 32 80 00       	push   $0x803258
  8014d1:	68 8c 00 00 00       	push   $0x8c
  8014d6:	68 e9 31 80 00       	push   $0x8031e9
  8014db:	e8 10 ee ff ff       	call   8002f0 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014e0:	89 f8                	mov    %edi,%eax
  8014e2:	e8 45 fd ff ff       	call   80122c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ed:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014f3:	74 26                	je     80151b <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014f5:	89 d8                	mov    %ebx,%eax
  8014f7:	c1 e8 16             	shr    $0x16,%eax
  8014fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801501:	a8 01                	test   $0x1,%al
  801503:	74 e2                	je     8014e7 <fork+0x66>
  801505:	89 da                	mov    %ebx,%edx
  801507:	c1 ea 0c             	shr    $0xc,%edx
  80150a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801511:	83 e0 05             	and    $0x5,%eax
  801514:	83 f8 05             	cmp    $0x5,%eax
  801517:	75 ce                	jne    8014e7 <fork+0x66>
  801519:	eb c5                	jmp    8014e0 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	6a 07                	push   $0x7
  801520:	68 00 f0 bf ee       	push   $0xeebff000
  801525:	56                   	push   %esi
  801526:	e8 0c fa ff ff       	call   800f37 <sys_page_alloc>
	if(ret < 0)
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 31                	js     801563 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	68 0f 2a 80 00       	push   $0x802a0f
  80153a:	56                   	push   %esi
  80153b:	e8 42 fb ff ff       	call   801082 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 33                	js     80157a <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	6a 02                	push   $0x2
  80154c:	56                   	push   %esi
  80154d:	e8 ac fa ff ff       	call   800ffe <sys_env_set_status>
	if(ret < 0)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 38                	js     801591 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801559:	89 f0                	mov    %esi,%eax
  80155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	68 08 32 80 00       	push   $0x803208
  80156b:	68 98 00 00 00       	push   $0x98
  801570:	68 e9 31 80 00       	push   $0x8031e9
  801575:	e8 76 ed ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 7c 32 80 00       	push   $0x80327c
  801582:	68 9b 00 00 00       	push   $0x9b
  801587:	68 e9 31 80 00       	push   $0x8031e9
  80158c:	e8 5f ed ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_status()\n");
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 a4 32 80 00       	push   $0x8032a4
  801599:	68 9e 00 00 00       	push   $0x9e
  80159e:	68 e9 31 80 00       	push   $0x8031e9
  8015a3:	e8 48 ed ff ff       	call   8002f0 <_panic>

008015a8 <sfork>:

// Challenge!
int
sfork(void)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	57                   	push   %edi
  8015ac:	56                   	push   %esi
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8015b1:	68 82 13 80 00       	push   $0x801382
  8015b6:	e8 e5 13 00 00       	call   8029a0 <set_pgfault_handler>
  8015bb:	b8 07 00 00 00       	mov    $0x7,%eax
  8015c0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 27                	js     8015f0 <sfork+0x48>
  8015c9:	89 c7                	mov    %eax,%edi
  8015cb:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015cd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015d2:	75 55                	jne    801629 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015d4:	e8 20 f9 ff ff       	call   800ef9 <sys_getenvid>
  8015d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015de:	c1 e0 07             	shl    $0x7,%eax
  8015e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015e6:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015eb:	e9 d4 00 00 00       	jmp    8016c4 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	68 58 32 80 00       	push   $0x803258
  8015f8:	68 af 00 00 00       	push   $0xaf
  8015fd:	68 e9 31 80 00       	push   $0x8031e9
  801602:	e8 e9 ec ff ff       	call   8002f0 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801607:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80160c:	89 f0                	mov    %esi,%eax
  80160e:	e8 19 fc ff ff       	call   80122c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801613:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801619:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80161f:	77 65                	ja     801686 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801621:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801627:	74 de                	je     801607 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801629:	89 d8                	mov    %ebx,%eax
  80162b:	c1 e8 16             	shr    $0x16,%eax
  80162e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801635:	a8 01                	test   $0x1,%al
  801637:	74 da                	je     801613 <sfork+0x6b>
  801639:	89 da                	mov    %ebx,%edx
  80163b:	c1 ea 0c             	shr    $0xc,%edx
  80163e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801645:	83 e0 05             	and    $0x5,%eax
  801648:	83 f8 05             	cmp    $0x5,%eax
  80164b:	75 c6                	jne    801613 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80164d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801654:	c1 e2 0c             	shl    $0xc,%edx
  801657:	83 ec 0c             	sub    $0xc,%esp
  80165a:	83 e0 07             	and    $0x7,%eax
  80165d:	50                   	push   %eax
  80165e:	52                   	push   %edx
  80165f:	56                   	push   %esi
  801660:	52                   	push   %edx
  801661:	6a 00                	push   $0x0
  801663:	e8 12 f9 ff ff       	call   800f7a <sys_page_map>
  801668:	83 c4 20             	add    $0x20,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	74 a4                	je     801613 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	68 d3 31 80 00       	push   $0x8031d3
  801677:	68 ba 00 00 00       	push   $0xba
  80167c:	68 e9 31 80 00       	push   $0x8031e9
  801681:	e8 6a ec ff ff       	call   8002f0 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	6a 07                	push   $0x7
  80168b:	68 00 f0 bf ee       	push   $0xeebff000
  801690:	57                   	push   %edi
  801691:	e8 a1 f8 ff ff       	call   800f37 <sys_page_alloc>
	if(ret < 0)
  801696:	83 c4 10             	add    $0x10,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	78 31                	js     8016ce <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	68 0f 2a 80 00       	push   $0x802a0f
  8016a5:	57                   	push   %edi
  8016a6:	e8 d7 f9 ff ff       	call   801082 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 33                	js     8016e5 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	6a 02                	push   $0x2
  8016b7:	57                   	push   %edi
  8016b8:	e8 41 f9 ff ff       	call   800ffe <sys_env_set_status>
	if(ret < 0)
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 38                	js     8016fc <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016c4:	89 f8                	mov    %edi,%eax
  8016c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5f                   	pop    %edi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	68 08 32 80 00       	push   $0x803208
  8016d6:	68 c0 00 00 00       	push   $0xc0
  8016db:	68 e9 31 80 00       	push   $0x8031e9
  8016e0:	e8 0b ec ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	68 7c 32 80 00       	push   $0x80327c
  8016ed:	68 c3 00 00 00       	push   $0xc3
  8016f2:	68 e9 31 80 00       	push   $0x8031e9
  8016f7:	e8 f4 eb ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 a4 32 80 00       	push   $0x8032a4
  801704:	68 c6 00 00 00       	push   $0xc6
  801709:	68 e9 31 80 00       	push   $0x8031e9
  80170e:	e8 dd eb ff ff       	call   8002f0 <_panic>

00801713 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	8b 75 08             	mov    0x8(%ebp),%esi
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801721:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801723:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801728:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	50                   	push   %eax
  80172f:	e8 b3 f9 ff ff       	call   8010e7 <sys_ipc_recv>
	if(ret < 0){
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	85 c0                	test   %eax,%eax
  801739:	78 2b                	js     801766 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80173b:	85 f6                	test   %esi,%esi
  80173d:	74 0a                	je     801749 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80173f:	a1 08 50 80 00       	mov    0x805008,%eax
  801744:	8b 40 74             	mov    0x74(%eax),%eax
  801747:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801749:	85 db                	test   %ebx,%ebx
  80174b:	74 0a                	je     801757 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80174d:	a1 08 50 80 00       	mov    0x805008,%eax
  801752:	8b 40 78             	mov    0x78(%eax),%eax
  801755:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801757:	a1 08 50 80 00       	mov    0x805008,%eax
  80175c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80175f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801762:	5b                   	pop    %ebx
  801763:	5e                   	pop    %esi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    
		if(from_env_store)
  801766:	85 f6                	test   %esi,%esi
  801768:	74 06                	je     801770 <ipc_recv+0x5d>
			*from_env_store = 0;
  80176a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801770:	85 db                	test   %ebx,%ebx
  801772:	74 eb                	je     80175f <ipc_recv+0x4c>
			*perm_store = 0;
  801774:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80177a:	eb e3                	jmp    80175f <ipc_recv+0x4c>

0080177c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	57                   	push   %edi
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
  801782:	83 ec 0c             	sub    $0xc,%esp
  801785:	8b 7d 08             	mov    0x8(%ebp),%edi
  801788:	8b 75 0c             	mov    0xc(%ebp),%esi
  80178b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80178e:	85 db                	test   %ebx,%ebx
  801790:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801795:	0f 44 d8             	cmove  %eax,%ebx
  801798:	eb 05                	jmp    80179f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80179a:	e8 79 f7 ff ff       	call   800f18 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80179f:	ff 75 14             	pushl  0x14(%ebp)
  8017a2:	53                   	push   %ebx
  8017a3:	56                   	push   %esi
  8017a4:	57                   	push   %edi
  8017a5:	e8 1a f9 ff ff       	call   8010c4 <sys_ipc_try_send>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	74 1b                	je     8017cc <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8017b1:	79 e7                	jns    80179a <ipc_send+0x1e>
  8017b3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017b6:	74 e2                	je     80179a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 c3 32 80 00       	push   $0x8032c3
  8017c0:	6a 46                	push   $0x46
  8017c2:	68 d8 32 80 00       	push   $0x8032d8
  8017c7:	e8 24 eb ff ff       	call   8002f0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8017cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5f                   	pop    %edi
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017df:	89 c2                	mov    %eax,%edx
  8017e1:	c1 e2 07             	shl    $0x7,%edx
  8017e4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8017ea:	8b 52 50             	mov    0x50(%edx),%edx
  8017ed:	39 ca                	cmp    %ecx,%edx
  8017ef:	74 11                	je     801802 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8017f1:	83 c0 01             	add    $0x1,%eax
  8017f4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017f9:	75 e4                	jne    8017df <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	eb 0b                	jmp    80180d <ipc_find_env+0x39>
			return envs[i].env_id;
  801802:	c1 e0 07             	shl    $0x7,%eax
  801805:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80180a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	05 00 00 00 30       	add    $0x30000000,%eax
  80181a:	c1 e8 0c             	shr    $0xc,%eax
}
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80182a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80182f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80183e:	89 c2                	mov    %eax,%edx
  801840:	c1 ea 16             	shr    $0x16,%edx
  801843:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80184a:	f6 c2 01             	test   $0x1,%dl
  80184d:	74 2d                	je     80187c <fd_alloc+0x46>
  80184f:	89 c2                	mov    %eax,%edx
  801851:	c1 ea 0c             	shr    $0xc,%edx
  801854:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80185b:	f6 c2 01             	test   $0x1,%dl
  80185e:	74 1c                	je     80187c <fd_alloc+0x46>
  801860:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801865:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80186a:	75 d2                	jne    80183e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801875:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80187a:	eb 0a                	jmp    801886 <fd_alloc+0x50>
			*fd_store = fd;
  80187c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801881:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80188e:	83 f8 1f             	cmp    $0x1f,%eax
  801891:	77 30                	ja     8018c3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801893:	c1 e0 0c             	shl    $0xc,%eax
  801896:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80189b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018a1:	f6 c2 01             	test   $0x1,%dl
  8018a4:	74 24                	je     8018ca <fd_lookup+0x42>
  8018a6:	89 c2                	mov    %eax,%edx
  8018a8:	c1 ea 0c             	shr    $0xc,%edx
  8018ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b2:	f6 c2 01             	test   $0x1,%dl
  8018b5:	74 1a                	je     8018d1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	89 02                	mov    %eax,(%edx)
	return 0;
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    
		return -E_INVAL;
  8018c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c8:	eb f7                	jmp    8018c1 <fd_lookup+0x39>
		return -E_INVAL;
  8018ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cf:	eb f0                	jmp    8018c1 <fd_lookup+0x39>
  8018d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d6:	eb e9                	jmp    8018c1 <fd_lookup+0x39>

008018d8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e6:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018eb:	39 08                	cmp    %ecx,(%eax)
  8018ed:	74 38                	je     801927 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018ef:	83 c2 01             	add    $0x1,%edx
  8018f2:	8b 04 95 60 33 80 00 	mov    0x803360(,%edx,4),%eax
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	75 ee                	jne    8018eb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018fd:	a1 08 50 80 00       	mov    0x805008,%eax
  801902:	8b 40 48             	mov    0x48(%eax),%eax
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	51                   	push   %ecx
  801909:	50                   	push   %eax
  80190a:	68 e4 32 80 00       	push   $0x8032e4
  80190f:	e8 d2 ea ff ff       	call   8003e6 <cprintf>
	*dev = 0;
  801914:	8b 45 0c             	mov    0xc(%ebp),%eax
  801917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    
			*dev = devtab[i];
  801927:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
  801931:	eb f2                	jmp    801925 <dev_lookup+0x4d>

00801933 <fd_close>:
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	57                   	push   %edi
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	83 ec 24             	sub    $0x24,%esp
  80193c:	8b 75 08             	mov    0x8(%ebp),%esi
  80193f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801942:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801945:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801946:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80194c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80194f:	50                   	push   %eax
  801950:	e8 33 ff ff ff       	call   801888 <fd_lookup>
  801955:	89 c3                	mov    %eax,%ebx
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 05                	js     801963 <fd_close+0x30>
	    || fd != fd2)
  80195e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801961:	74 16                	je     801979 <fd_close+0x46>
		return (must_exist ? r : 0);
  801963:	89 f8                	mov    %edi,%eax
  801965:	84 c0                	test   %al,%al
  801967:	b8 00 00 00 00       	mov    $0x0,%eax
  80196c:	0f 44 d8             	cmove  %eax,%ebx
}
  80196f:	89 d8                	mov    %ebx,%eax
  801971:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	5f                   	pop    %edi
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80197f:	50                   	push   %eax
  801980:	ff 36                	pushl  (%esi)
  801982:	e8 51 ff ff ff       	call   8018d8 <dev_lookup>
  801987:	89 c3                	mov    %eax,%ebx
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 1a                	js     8019aa <fd_close+0x77>
		if (dev->dev_close)
  801990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801993:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801996:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80199b:	85 c0                	test   %eax,%eax
  80199d:	74 0b                	je     8019aa <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80199f:	83 ec 0c             	sub    $0xc,%esp
  8019a2:	56                   	push   %esi
  8019a3:	ff d0                	call   *%eax
  8019a5:	89 c3                	mov    %eax,%ebx
  8019a7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	56                   	push   %esi
  8019ae:	6a 00                	push   $0x0
  8019b0:	e8 07 f6 ff ff       	call   800fbc <sys_page_unmap>
	return r;
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	eb b5                	jmp    80196f <fd_close+0x3c>

008019ba <close>:

int
close(int fdnum)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	e8 bc fe ff ff       	call   801888 <fd_lookup>
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	79 02                	jns    8019d5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    
		return fd_close(fd, 1);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	6a 01                	push   $0x1
  8019da:	ff 75 f4             	pushl  -0xc(%ebp)
  8019dd:	e8 51 ff ff ff       	call   801933 <fd_close>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	eb ec                	jmp    8019d3 <close+0x19>

008019e7 <close_all>:

void
close_all(void)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	53                   	push   %ebx
  8019eb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	53                   	push   %ebx
  8019f7:	e8 be ff ff ff       	call   8019ba <close>
	for (i = 0; i < MAXFD; i++)
  8019fc:	83 c3 01             	add    $0x1,%ebx
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	83 fb 20             	cmp    $0x20,%ebx
  801a05:	75 ec                	jne    8019f3 <close_all+0xc>
}
  801a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a18:	50                   	push   %eax
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	e8 67 fe ff ff       	call   801888 <fd_lookup>
  801a21:	89 c3                	mov    %eax,%ebx
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	85 c0                	test   %eax,%eax
  801a28:	0f 88 81 00 00 00    	js     801aaf <dup+0xa3>
		return r;
	close(newfdnum);
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	e8 81 ff ff ff       	call   8019ba <close>

	newfd = INDEX2FD(newfdnum);
  801a39:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a3c:	c1 e6 0c             	shl    $0xc,%esi
  801a3f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a45:	83 c4 04             	add    $0x4,%esp
  801a48:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a4b:	e8 cf fd ff ff       	call   80181f <fd2data>
  801a50:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a52:	89 34 24             	mov    %esi,(%esp)
  801a55:	e8 c5 fd ff ff       	call   80181f <fd2data>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a5f:	89 d8                	mov    %ebx,%eax
  801a61:	c1 e8 16             	shr    $0x16,%eax
  801a64:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a6b:	a8 01                	test   $0x1,%al
  801a6d:	74 11                	je     801a80 <dup+0x74>
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	c1 e8 0c             	shr    $0xc,%eax
  801a74:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a7b:	f6 c2 01             	test   $0x1,%dl
  801a7e:	75 39                	jne    801ab9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a83:	89 d0                	mov    %edx,%eax
  801a85:	c1 e8 0c             	shr    $0xc,%eax
  801a88:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	25 07 0e 00 00       	and    $0xe07,%eax
  801a97:	50                   	push   %eax
  801a98:	56                   	push   %esi
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	6a 00                	push   $0x0
  801a9e:	e8 d7 f4 ff ff       	call   800f7a <sys_page_map>
  801aa3:	89 c3                	mov    %eax,%ebx
  801aa5:	83 c4 20             	add    $0x20,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 31                	js     801add <dup+0xd1>
		goto err;

	return newfdnum;
  801aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801aaf:	89 d8                	mov    %ebx,%eax
  801ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ab9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	25 07 0e 00 00       	and    $0xe07,%eax
  801ac8:	50                   	push   %eax
  801ac9:	57                   	push   %edi
  801aca:	6a 00                	push   $0x0
  801acc:	53                   	push   %ebx
  801acd:	6a 00                	push   $0x0
  801acf:	e8 a6 f4 ff ff       	call   800f7a <sys_page_map>
  801ad4:	89 c3                	mov    %eax,%ebx
  801ad6:	83 c4 20             	add    $0x20,%esp
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	79 a3                	jns    801a80 <dup+0x74>
	sys_page_unmap(0, newfd);
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	56                   	push   %esi
  801ae1:	6a 00                	push   $0x0
  801ae3:	e8 d4 f4 ff ff       	call   800fbc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ae8:	83 c4 08             	add    $0x8,%esp
  801aeb:	57                   	push   %edi
  801aec:	6a 00                	push   $0x0
  801aee:	e8 c9 f4 ff ff       	call   800fbc <sys_page_unmap>
	return r;
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	eb b7                	jmp    801aaf <dup+0xa3>

00801af8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b02:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b05:	50                   	push   %eax
  801b06:	53                   	push   %ebx
  801b07:	e8 7c fd ff ff       	call   801888 <fd_lookup>
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 3f                	js     801b52 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b13:	83 ec 08             	sub    $0x8,%esp
  801b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b19:	50                   	push   %eax
  801b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1d:	ff 30                	pushl  (%eax)
  801b1f:	e8 b4 fd ff ff       	call   8018d8 <dev_lookup>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 27                	js     801b52 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2e:	8b 42 08             	mov    0x8(%edx),%eax
  801b31:	83 e0 03             	and    $0x3,%eax
  801b34:	83 f8 01             	cmp    $0x1,%eax
  801b37:	74 1e                	je     801b57 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3c:	8b 40 08             	mov    0x8(%eax),%eax
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	74 35                	je     801b78 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	52                   	push   %edx
  801b4d:	ff d0                	call   *%eax
  801b4f:	83 c4 10             	add    $0x10,%esp
}
  801b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b57:	a1 08 50 80 00       	mov    0x805008,%eax
  801b5c:	8b 40 48             	mov    0x48(%eax),%eax
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	53                   	push   %ebx
  801b63:	50                   	push   %eax
  801b64:	68 25 33 80 00       	push   $0x803325
  801b69:	e8 78 e8 ff ff       	call   8003e6 <cprintf>
		return -E_INVAL;
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b76:	eb da                	jmp    801b52 <read+0x5a>
		return -E_NOT_SUPP;
  801b78:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b7d:	eb d3                	jmp    801b52 <read+0x5a>

00801b7f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	57                   	push   %edi
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b8b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b93:	39 f3                	cmp    %esi,%ebx
  801b95:	73 23                	jae    801bba <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	89 f0                	mov    %esi,%eax
  801b9c:	29 d8                	sub    %ebx,%eax
  801b9e:	50                   	push   %eax
  801b9f:	89 d8                	mov    %ebx,%eax
  801ba1:	03 45 0c             	add    0xc(%ebp),%eax
  801ba4:	50                   	push   %eax
  801ba5:	57                   	push   %edi
  801ba6:	e8 4d ff ff ff       	call   801af8 <read>
		if (m < 0)
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 06                	js     801bb8 <readn+0x39>
			return m;
		if (m == 0)
  801bb2:	74 06                	je     801bba <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801bb4:	01 c3                	add    %eax,%ebx
  801bb6:	eb db                	jmp    801b93 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bb8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    

00801bc4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 1c             	sub    $0x1c,%esp
  801bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd1:	50                   	push   %eax
  801bd2:	53                   	push   %ebx
  801bd3:	e8 b0 fc ff ff       	call   801888 <fd_lookup>
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 3a                	js     801c19 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be5:	50                   	push   %eax
  801be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be9:	ff 30                	pushl  (%eax)
  801beb:	e8 e8 fc ff ff       	call   8018d8 <dev_lookup>
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 22                	js     801c19 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bfe:	74 1e                	je     801c1e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c03:	8b 52 0c             	mov    0xc(%edx),%edx
  801c06:	85 d2                	test   %edx,%edx
  801c08:	74 35                	je     801c3f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	ff 75 10             	pushl  0x10(%ebp)
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	50                   	push   %eax
  801c14:	ff d2                	call   *%edx
  801c16:	83 c4 10             	add    $0x10,%esp
}
  801c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c1e:	a1 08 50 80 00       	mov    0x805008,%eax
  801c23:	8b 40 48             	mov    0x48(%eax),%eax
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	53                   	push   %ebx
  801c2a:	50                   	push   %eax
  801c2b:	68 41 33 80 00       	push   $0x803341
  801c30:	e8 b1 e7 ff ff       	call   8003e6 <cprintf>
		return -E_INVAL;
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c3d:	eb da                	jmp    801c19 <write+0x55>
		return -E_NOT_SUPP;
  801c3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c44:	eb d3                	jmp    801c19 <write+0x55>

00801c46 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4f:	50                   	push   %eax
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	e8 30 fc ff ff       	call   801888 <fd_lookup>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 0e                	js     801c6d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 1c             	sub    $0x1c,%esp
  801c76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c79:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c7c:	50                   	push   %eax
  801c7d:	53                   	push   %ebx
  801c7e:	e8 05 fc ff ff       	call   801888 <fd_lookup>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	85 c0                	test   %eax,%eax
  801c88:	78 37                	js     801cc1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c90:	50                   	push   %eax
  801c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c94:	ff 30                	pushl  (%eax)
  801c96:	e8 3d fc ff ff       	call   8018d8 <dev_lookup>
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 1f                	js     801cc1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ca9:	74 1b                	je     801cc6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cae:	8b 52 18             	mov    0x18(%edx),%edx
  801cb1:	85 d2                	test   %edx,%edx
  801cb3:	74 32                	je     801ce7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cb5:	83 ec 08             	sub    $0x8,%esp
  801cb8:	ff 75 0c             	pushl  0xc(%ebp)
  801cbb:	50                   	push   %eax
  801cbc:	ff d2                	call   *%edx
  801cbe:	83 c4 10             	add    $0x10,%esp
}
  801cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    
			thisenv->env_id, fdnum);
  801cc6:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ccb:	8b 40 48             	mov    0x48(%eax),%eax
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	53                   	push   %ebx
  801cd2:	50                   	push   %eax
  801cd3:	68 04 33 80 00       	push   $0x803304
  801cd8:	e8 09 e7 ff ff       	call   8003e6 <cprintf>
		return -E_INVAL;
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ce5:	eb da                	jmp    801cc1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801ce7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cec:	eb d3                	jmp    801cc1 <ftruncate+0x52>

00801cee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	53                   	push   %ebx
  801cf2:	83 ec 1c             	sub    $0x1c,%esp
  801cf5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cfb:	50                   	push   %eax
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	e8 84 fb ff ff       	call   801888 <fd_lookup>
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	85 c0                	test   %eax,%eax
  801d09:	78 4b                	js     801d56 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d0b:	83 ec 08             	sub    $0x8,%esp
  801d0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d11:	50                   	push   %eax
  801d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d15:	ff 30                	pushl  (%eax)
  801d17:	e8 bc fb ff ff       	call   8018d8 <dev_lookup>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 33                	js     801d56 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d2a:	74 2f                	je     801d5b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d2c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d2f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d36:	00 00 00 
	stat->st_isdir = 0;
  801d39:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d40:	00 00 00 
	stat->st_dev = dev;
  801d43:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d49:	83 ec 08             	sub    $0x8,%esp
  801d4c:	53                   	push   %ebx
  801d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d50:	ff 50 14             	call   *0x14(%eax)
  801d53:	83 c4 10             	add    $0x10,%esp
}
  801d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    
		return -E_NOT_SUPP;
  801d5b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d60:	eb f4                	jmp    801d56 <fstat+0x68>

00801d62 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d67:	83 ec 08             	sub    $0x8,%esp
  801d6a:	6a 00                	push   $0x0
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	e8 22 02 00 00       	call   801f96 <open>
  801d74:	89 c3                	mov    %eax,%ebx
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 1b                	js     801d98 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d7d:	83 ec 08             	sub    $0x8,%esp
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	50                   	push   %eax
  801d84:	e8 65 ff ff ff       	call   801cee <fstat>
  801d89:	89 c6                	mov    %eax,%esi
	close(fd);
  801d8b:	89 1c 24             	mov    %ebx,(%esp)
  801d8e:	e8 27 fc ff ff       	call   8019ba <close>
	return r;
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	89 f3                	mov    %esi,%ebx
}
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5e                   	pop    %esi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	56                   	push   %esi
  801da5:	53                   	push   %ebx
  801da6:	89 c6                	mov    %eax,%esi
  801da8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801daa:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801db1:	74 27                	je     801dda <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801db3:	6a 07                	push   $0x7
  801db5:	68 00 60 80 00       	push   $0x806000
  801dba:	56                   	push   %esi
  801dbb:	ff 35 00 50 80 00    	pushl  0x805000
  801dc1:	e8 b6 f9 ff ff       	call   80177c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dc6:	83 c4 0c             	add    $0xc,%esp
  801dc9:	6a 00                	push   $0x0
  801dcb:	53                   	push   %ebx
  801dcc:	6a 00                	push   $0x0
  801dce:	e8 40 f9 ff ff       	call   801713 <ipc_recv>
}
  801dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5e                   	pop    %esi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	6a 01                	push   $0x1
  801ddf:	e8 f0 f9 ff ff       	call   8017d4 <ipc_find_env>
  801de4:	a3 00 50 80 00       	mov    %eax,0x805000
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	eb c5                	jmp    801db3 <fsipc+0x12>

00801dee <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfa:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e07:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0c:	b8 02 00 00 00       	mov    $0x2,%eax
  801e11:	e8 8b ff ff ff       	call   801da1 <fsipc>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <devfile_flush>:
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	8b 40 0c             	mov    0xc(%eax),%eax
  801e24:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e29:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2e:	b8 06 00 00 00       	mov    $0x6,%eax
  801e33:	e8 69 ff ff ff       	call   801da1 <fsipc>
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <devfile_stat>:
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e54:	b8 05 00 00 00       	mov    $0x5,%eax
  801e59:	e8 43 ff ff ff       	call   801da1 <fsipc>
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 2c                	js     801e8e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e62:	83 ec 08             	sub    $0x8,%esp
  801e65:	68 00 60 80 00       	push   $0x806000
  801e6a:	53                   	push   %ebx
  801e6b:	e8 d5 ec ff ff       	call   800b45 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e70:	a1 80 60 80 00       	mov    0x806080,%eax
  801e75:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e7b:	a1 84 60 80 00       	mov    0x806084,%eax
  801e80:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <devfile_write>:
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	53                   	push   %ebx
  801e97:	83 ec 08             	sub    $0x8,%esp
  801e9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ea8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801eae:	53                   	push   %ebx
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	68 08 60 80 00       	push   $0x806008
  801eb7:	e8 79 ee ff ff       	call   800d35 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec1:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec6:	e8 d6 fe ff ff       	call   801da1 <fsipc>
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 0b                	js     801edd <devfile_write+0x4a>
	assert(r <= n);
  801ed2:	39 d8                	cmp    %ebx,%eax
  801ed4:	77 0c                	ja     801ee2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ed6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801edb:	7f 1e                	jg     801efb <devfile_write+0x68>
}
  801edd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    
	assert(r <= n);
  801ee2:	68 74 33 80 00       	push   $0x803374
  801ee7:	68 7b 33 80 00       	push   $0x80337b
  801eec:	68 98 00 00 00       	push   $0x98
  801ef1:	68 90 33 80 00       	push   $0x803390
  801ef6:	e8 f5 e3 ff ff       	call   8002f0 <_panic>
	assert(r <= PGSIZE);
  801efb:	68 9b 33 80 00       	push   $0x80339b
  801f00:	68 7b 33 80 00       	push   $0x80337b
  801f05:	68 99 00 00 00       	push   $0x99
  801f0a:	68 90 33 80 00       	push   $0x803390
  801f0f:	e8 dc e3 ff ff       	call   8002f0 <_panic>

00801f14 <devfile_read>:
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f22:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f27:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f32:	b8 03 00 00 00       	mov    $0x3,%eax
  801f37:	e8 65 fe ff ff       	call   801da1 <fsipc>
  801f3c:	89 c3                	mov    %eax,%ebx
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 1f                	js     801f61 <devfile_read+0x4d>
	assert(r <= n);
  801f42:	39 f0                	cmp    %esi,%eax
  801f44:	77 24                	ja     801f6a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f46:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f4b:	7f 33                	jg     801f80 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f4d:	83 ec 04             	sub    $0x4,%esp
  801f50:	50                   	push   %eax
  801f51:	68 00 60 80 00       	push   $0x806000
  801f56:	ff 75 0c             	pushl  0xc(%ebp)
  801f59:	e8 75 ed ff ff       	call   800cd3 <memmove>
	return r;
  801f5e:	83 c4 10             	add    $0x10,%esp
}
  801f61:	89 d8                	mov    %ebx,%eax
  801f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f66:	5b                   	pop    %ebx
  801f67:	5e                   	pop    %esi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    
	assert(r <= n);
  801f6a:	68 74 33 80 00       	push   $0x803374
  801f6f:	68 7b 33 80 00       	push   $0x80337b
  801f74:	6a 7c                	push   $0x7c
  801f76:	68 90 33 80 00       	push   $0x803390
  801f7b:	e8 70 e3 ff ff       	call   8002f0 <_panic>
	assert(r <= PGSIZE);
  801f80:	68 9b 33 80 00       	push   $0x80339b
  801f85:	68 7b 33 80 00       	push   $0x80337b
  801f8a:	6a 7d                	push   $0x7d
  801f8c:	68 90 33 80 00       	push   $0x803390
  801f91:	e8 5a e3 ff ff       	call   8002f0 <_panic>

00801f96 <open>:
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	56                   	push   %esi
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 1c             	sub    $0x1c,%esp
  801f9e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801fa1:	56                   	push   %esi
  801fa2:	e8 65 eb ff ff       	call   800b0c <strlen>
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801faf:	7f 6c                	jg     80201d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb7:	50                   	push   %eax
  801fb8:	e8 79 f8 ff ff       	call   801836 <fd_alloc>
  801fbd:	89 c3                	mov    %eax,%ebx
  801fbf:	83 c4 10             	add    $0x10,%esp
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 3c                	js     802002 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	56                   	push   %esi
  801fca:	68 00 60 80 00       	push   $0x806000
  801fcf:	e8 71 eb ff ff       	call   800b45 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd7:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe4:	e8 b8 fd ff ff       	call   801da1 <fsipc>
  801fe9:	89 c3                	mov    %eax,%ebx
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	78 19                	js     80200b <open+0x75>
	return fd2num(fd);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff8:	e8 12 f8 ff ff       	call   80180f <fd2num>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	83 c4 10             	add    $0x10,%esp
}
  802002:	89 d8                	mov    %ebx,%eax
  802004:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802007:	5b                   	pop    %ebx
  802008:	5e                   	pop    %esi
  802009:	5d                   	pop    %ebp
  80200a:	c3                   	ret    
		fd_close(fd, 0);
  80200b:	83 ec 08             	sub    $0x8,%esp
  80200e:	6a 00                	push   $0x0
  802010:	ff 75 f4             	pushl  -0xc(%ebp)
  802013:	e8 1b f9 ff ff       	call   801933 <fd_close>
		return r;
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	eb e5                	jmp    802002 <open+0x6c>
		return -E_BAD_PATH;
  80201d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802022:	eb de                	jmp    802002 <open+0x6c>

00802024 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80202a:	ba 00 00 00 00       	mov    $0x0,%edx
  80202f:	b8 08 00 00 00       	mov    $0x8,%eax
  802034:	e8 68 fd ff ff       	call   801da1 <fsipc>
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802041:	89 d0                	mov    %edx,%eax
  802043:	c1 e8 16             	shr    $0x16,%eax
  802046:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80204d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802052:	f6 c1 01             	test   $0x1,%cl
  802055:	74 1d                	je     802074 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802057:	c1 ea 0c             	shr    $0xc,%edx
  80205a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802061:	f6 c2 01             	test   $0x1,%dl
  802064:	74 0e                	je     802074 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802066:	c1 ea 0c             	shr    $0xc,%edx
  802069:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802070:	ef 
  802071:	0f b7 c0             	movzwl %ax,%eax
}
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    

00802076 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80207c:	68 a7 33 80 00       	push   $0x8033a7
  802081:	ff 75 0c             	pushl  0xc(%ebp)
  802084:	e8 bc ea ff ff       	call   800b45 <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	53                   	push   %ebx
  802094:	83 ec 10             	sub    $0x10,%esp
  802097:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80209a:	53                   	push   %ebx
  80209b:	e8 9b ff ff ff       	call   80203b <pageref>
  8020a0:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020a3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020a8:	83 f8 01             	cmp    $0x1,%eax
  8020ab:	74 07                	je     8020b4 <devsock_close+0x24>
}
  8020ad:	89 d0                	mov    %edx,%eax
  8020af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	ff 73 0c             	pushl  0xc(%ebx)
  8020ba:	e8 b9 02 00 00       	call   802378 <nsipc_close>
  8020bf:	89 c2                	mov    %eax,%edx
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	eb e7                	jmp    8020ad <devsock_close+0x1d>

008020c6 <devsock_write>:
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020cc:	6a 00                	push   $0x0
  8020ce:	ff 75 10             	pushl  0x10(%ebp)
  8020d1:	ff 75 0c             	pushl  0xc(%ebp)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	ff 70 0c             	pushl  0xc(%eax)
  8020da:	e8 76 03 00 00       	call   802455 <nsipc_send>
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <devsock_read>:
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	ff 75 10             	pushl  0x10(%ebp)
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	ff 70 0c             	pushl  0xc(%eax)
  8020f5:	e8 ef 02 00 00       	call   8023e9 <nsipc_recv>
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <fd2sockid>:
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802102:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802105:	52                   	push   %edx
  802106:	50                   	push   %eax
  802107:	e8 7c f7 ff ff       	call   801888 <fd_lookup>
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 10                	js     802123 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80211c:	39 08                	cmp    %ecx,(%eax)
  80211e:	75 05                	jne    802125 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802120:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    
		return -E_NOT_SUPP;
  802125:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80212a:	eb f7                	jmp    802123 <fd2sockid+0x27>

0080212c <alloc_sockfd>:
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	56                   	push   %esi
  802130:	53                   	push   %ebx
  802131:	83 ec 1c             	sub    $0x1c,%esp
  802134:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802136:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802139:	50                   	push   %eax
  80213a:	e8 f7 f6 ff ff       	call   801836 <fd_alloc>
  80213f:	89 c3                	mov    %eax,%ebx
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	78 43                	js     80218b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	68 07 04 00 00       	push   $0x407
  802150:	ff 75 f4             	pushl  -0xc(%ebp)
  802153:	6a 00                	push   $0x0
  802155:	e8 dd ed ff ff       	call   800f37 <sys_page_alloc>
  80215a:	89 c3                	mov    %eax,%ebx
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	85 c0                	test   %eax,%eax
  802161:	78 28                	js     80218b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80216c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802178:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80217b:	83 ec 0c             	sub    $0xc,%esp
  80217e:	50                   	push   %eax
  80217f:	e8 8b f6 ff ff       	call   80180f <fd2num>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	eb 0c                	jmp    802197 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	56                   	push   %esi
  80218f:	e8 e4 01 00 00       	call   802378 <nsipc_close>
		return r;
  802194:	83 c4 10             	add    $0x10,%esp
}
  802197:	89 d8                	mov    %ebx,%eax
  802199:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219c:	5b                   	pop    %ebx
  80219d:	5e                   	pop    %esi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    

008021a0 <accept>:
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	e8 4e ff ff ff       	call   8020fc <fd2sockid>
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	78 1b                	js     8021cd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021b2:	83 ec 04             	sub    $0x4,%esp
  8021b5:	ff 75 10             	pushl  0x10(%ebp)
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	50                   	push   %eax
  8021bc:	e8 0e 01 00 00       	call   8022cf <nsipc_accept>
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	78 05                	js     8021cd <accept+0x2d>
	return alloc_sockfd(r);
  8021c8:	e8 5f ff ff ff       	call   80212c <alloc_sockfd>
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <bind>:
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	e8 1f ff ff ff       	call   8020fc <fd2sockid>
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 12                	js     8021f3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021e1:	83 ec 04             	sub    $0x4,%esp
  8021e4:	ff 75 10             	pushl  0x10(%ebp)
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	50                   	push   %eax
  8021eb:	e8 31 01 00 00       	call   802321 <nsipc_bind>
  8021f0:	83 c4 10             	add    $0x10,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <shutdown>:
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	e8 f9 fe ff ff       	call   8020fc <fd2sockid>
  802203:	85 c0                	test   %eax,%eax
  802205:	78 0f                	js     802216 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802207:	83 ec 08             	sub    $0x8,%esp
  80220a:	ff 75 0c             	pushl  0xc(%ebp)
  80220d:	50                   	push   %eax
  80220e:	e8 43 01 00 00       	call   802356 <nsipc_shutdown>
  802213:	83 c4 10             	add    $0x10,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <connect>:
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	e8 d6 fe ff ff       	call   8020fc <fd2sockid>
  802226:	85 c0                	test   %eax,%eax
  802228:	78 12                	js     80223c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	ff 75 10             	pushl  0x10(%ebp)
  802230:	ff 75 0c             	pushl  0xc(%ebp)
  802233:	50                   	push   %eax
  802234:	e8 59 01 00 00       	call   802392 <nsipc_connect>
  802239:	83 c4 10             	add    $0x10,%esp
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <listen>:
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	e8 b0 fe ff ff       	call   8020fc <fd2sockid>
  80224c:	85 c0                	test   %eax,%eax
  80224e:	78 0f                	js     80225f <listen+0x21>
	return nsipc_listen(r, backlog);
  802250:	83 ec 08             	sub    $0x8,%esp
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	50                   	push   %eax
  802257:	e8 6b 01 00 00       	call   8023c7 <nsipc_listen>
  80225c:	83 c4 10             	add    $0x10,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <socket>:

int
socket(int domain, int type, int protocol)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802267:	ff 75 10             	pushl  0x10(%ebp)
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	ff 75 08             	pushl  0x8(%ebp)
  802270:	e8 3e 02 00 00       	call   8024b3 <nsipc_socket>
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	85 c0                	test   %eax,%eax
  80227a:	78 05                	js     802281 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80227c:	e8 ab fe ff ff       	call   80212c <alloc_sockfd>
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	53                   	push   %ebx
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80228c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802293:	74 26                	je     8022bb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802295:	6a 07                	push   $0x7
  802297:	68 00 70 80 00       	push   $0x807000
  80229c:	53                   	push   %ebx
  80229d:	ff 35 04 50 80 00    	pushl  0x805004
  8022a3:	e8 d4 f4 ff ff       	call   80177c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022a8:	83 c4 0c             	add    $0xc,%esp
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	e8 5d f4 ff ff       	call   801713 <ipc_recv>
}
  8022b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	6a 02                	push   $0x2
  8022c0:	e8 0f f5 ff ff       	call   8017d4 <ipc_find_env>
  8022c5:	a3 04 50 80 00       	mov    %eax,0x805004
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	eb c6                	jmp    802295 <nsipc+0x12>

008022cf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022df:	8b 06                	mov    (%esi),%eax
  8022e1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022eb:	e8 93 ff ff ff       	call   802283 <nsipc>
  8022f0:	89 c3                	mov    %eax,%ebx
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	79 09                	jns    8022ff <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022f6:	89 d8                	mov    %ebx,%eax
  8022f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	ff 35 10 70 80 00    	pushl  0x807010
  802308:	68 00 70 80 00       	push   $0x807000
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	e8 be e9 ff ff       	call   800cd3 <memmove>
		*addrlen = ret->ret_addrlen;
  802315:	a1 10 70 80 00       	mov    0x807010,%eax
  80231a:	89 06                	mov    %eax,(%esi)
  80231c:	83 c4 10             	add    $0x10,%esp
	return r;
  80231f:	eb d5                	jmp    8022f6 <nsipc_accept+0x27>

00802321 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	53                   	push   %ebx
  802325:	83 ec 08             	sub    $0x8,%esp
  802328:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802333:	53                   	push   %ebx
  802334:	ff 75 0c             	pushl  0xc(%ebp)
  802337:	68 04 70 80 00       	push   $0x807004
  80233c:	e8 92 e9 ff ff       	call   800cd3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802341:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802347:	b8 02 00 00 00       	mov    $0x2,%eax
  80234c:	e8 32 ff ff ff       	call   802283 <nsipc>
}
  802351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80236c:	b8 03 00 00 00       	mov    $0x3,%eax
  802371:	e8 0d ff ff ff       	call   802283 <nsipc>
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <nsipc_close>:

int
nsipc_close(int s)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802386:	b8 04 00 00 00       	mov    $0x4,%eax
  80238b:	e8 f3 fe ff ff       	call   802283 <nsipc>
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	53                   	push   %ebx
  802396:	83 ec 08             	sub    $0x8,%esp
  802399:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023a4:	53                   	push   %ebx
  8023a5:	ff 75 0c             	pushl  0xc(%ebp)
  8023a8:	68 04 70 80 00       	push   $0x807004
  8023ad:	e8 21 e9 ff ff       	call   800cd3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023b2:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8023bd:	e8 c1 fe ff ff       	call   802283 <nsipc>
}
  8023c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8023e2:	e8 9c fe ff ff       	call   802283 <nsipc>
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	56                   	push   %esi
  8023ed:	53                   	push   %ebx
  8023ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023f9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802407:	b8 07 00 00 00       	mov    $0x7,%eax
  80240c:	e8 72 fe ff ff       	call   802283 <nsipc>
  802411:	89 c3                	mov    %eax,%ebx
  802413:	85 c0                	test   %eax,%eax
  802415:	78 1f                	js     802436 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802417:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80241c:	7f 21                	jg     80243f <nsipc_recv+0x56>
  80241e:	39 c6                	cmp    %eax,%esi
  802420:	7c 1d                	jl     80243f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802422:	83 ec 04             	sub    $0x4,%esp
  802425:	50                   	push   %eax
  802426:	68 00 70 80 00       	push   $0x807000
  80242b:	ff 75 0c             	pushl  0xc(%ebp)
  80242e:	e8 a0 e8 ff ff       	call   800cd3 <memmove>
  802433:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802436:	89 d8                	mov    %ebx,%eax
  802438:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5d                   	pop    %ebp
  80243e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80243f:	68 b3 33 80 00       	push   $0x8033b3
  802444:	68 7b 33 80 00       	push   $0x80337b
  802449:	6a 62                	push   $0x62
  80244b:	68 c8 33 80 00       	push   $0x8033c8
  802450:	e8 9b de ff ff       	call   8002f0 <_panic>

00802455 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	53                   	push   %ebx
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802467:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80246d:	7f 2e                	jg     80249d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	53                   	push   %ebx
  802473:	ff 75 0c             	pushl  0xc(%ebp)
  802476:	68 0c 70 80 00       	push   $0x80700c
  80247b:	e8 53 e8 ff ff       	call   800cd3 <memmove>
	nsipcbuf.send.req_size = size;
  802480:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802486:	8b 45 14             	mov    0x14(%ebp),%eax
  802489:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80248e:	b8 08 00 00 00       	mov    $0x8,%eax
  802493:	e8 eb fd ff ff       	call   802283 <nsipc>
}
  802498:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    
	assert(size < 1600);
  80249d:	68 d4 33 80 00       	push   $0x8033d4
  8024a2:	68 7b 33 80 00       	push   $0x80337b
  8024a7:	6a 6d                	push   $0x6d
  8024a9:	68 c8 33 80 00       	push   $0x8033c8
  8024ae:	e8 3d de ff ff       	call   8002f0 <_panic>

008024b3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c4:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024d1:	b8 09 00 00 00       	mov    $0x9,%eax
  8024d6:	e8 a8 fd ff ff       	call   802283 <nsipc>
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	56                   	push   %esi
  8024e1:	53                   	push   %ebx
  8024e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024e5:	83 ec 0c             	sub    $0xc,%esp
  8024e8:	ff 75 08             	pushl  0x8(%ebp)
  8024eb:	e8 2f f3 ff ff       	call   80181f <fd2data>
  8024f0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024f2:	83 c4 08             	add    $0x8,%esp
  8024f5:	68 e0 33 80 00       	push   $0x8033e0
  8024fa:	53                   	push   %ebx
  8024fb:	e8 45 e6 ff ff       	call   800b45 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802500:	8b 46 04             	mov    0x4(%esi),%eax
  802503:	2b 06                	sub    (%esi),%eax
  802505:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80250b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802512:	00 00 00 
	stat->st_dev = &devpipe;
  802515:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80251c:	40 80 00 
	return 0;
}
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802527:	5b                   	pop    %ebx
  802528:	5e                   	pop    %esi
  802529:	5d                   	pop    %ebp
  80252a:	c3                   	ret    

0080252b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	53                   	push   %ebx
  80252f:	83 ec 0c             	sub    $0xc,%esp
  802532:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802535:	53                   	push   %ebx
  802536:	6a 00                	push   $0x0
  802538:	e8 7f ea ff ff       	call   800fbc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80253d:	89 1c 24             	mov    %ebx,(%esp)
  802540:	e8 da f2 ff ff       	call   80181f <fd2data>
  802545:	83 c4 08             	add    $0x8,%esp
  802548:	50                   	push   %eax
  802549:	6a 00                	push   $0x0
  80254b:	e8 6c ea ff ff       	call   800fbc <sys_page_unmap>
}
  802550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <_pipeisclosed>:
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	57                   	push   %edi
  802559:	56                   	push   %esi
  80255a:	53                   	push   %ebx
  80255b:	83 ec 1c             	sub    $0x1c,%esp
  80255e:	89 c7                	mov    %eax,%edi
  802560:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802562:	a1 08 50 80 00       	mov    0x805008,%eax
  802567:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	57                   	push   %edi
  80256e:	e8 c8 fa ff ff       	call   80203b <pageref>
  802573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802576:	89 34 24             	mov    %esi,(%esp)
  802579:	e8 bd fa ff ff       	call   80203b <pageref>
		nn = thisenv->env_runs;
  80257e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802584:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	39 cb                	cmp    %ecx,%ebx
  80258c:	74 1b                	je     8025a9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80258e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802591:	75 cf                	jne    802562 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802593:	8b 42 58             	mov    0x58(%edx),%eax
  802596:	6a 01                	push   $0x1
  802598:	50                   	push   %eax
  802599:	53                   	push   %ebx
  80259a:	68 e7 33 80 00       	push   $0x8033e7
  80259f:	e8 42 de ff ff       	call   8003e6 <cprintf>
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	eb b9                	jmp    802562 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8025a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025ac:	0f 94 c0             	sete   %al
  8025af:	0f b6 c0             	movzbl %al,%eax
}
  8025b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b5:	5b                   	pop    %ebx
  8025b6:	5e                   	pop    %esi
  8025b7:	5f                   	pop    %edi
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    

008025ba <devpipe_write>:
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	57                   	push   %edi
  8025be:	56                   	push   %esi
  8025bf:	53                   	push   %ebx
  8025c0:	83 ec 28             	sub    $0x28,%esp
  8025c3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025c6:	56                   	push   %esi
  8025c7:	e8 53 f2 ff ff       	call   80181f <fd2data>
  8025cc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025d9:	74 4f                	je     80262a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025db:	8b 43 04             	mov    0x4(%ebx),%eax
  8025de:	8b 0b                	mov    (%ebx),%ecx
  8025e0:	8d 51 20             	lea    0x20(%ecx),%edx
  8025e3:	39 d0                	cmp    %edx,%eax
  8025e5:	72 14                	jb     8025fb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8025e7:	89 da                	mov    %ebx,%edx
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	e8 65 ff ff ff       	call   802555 <_pipeisclosed>
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	75 3b                	jne    80262f <devpipe_write+0x75>
			sys_yield();
  8025f4:	e8 1f e9 ff ff       	call   800f18 <sys_yield>
  8025f9:	eb e0                	jmp    8025db <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025fe:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802602:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802605:	89 c2                	mov    %eax,%edx
  802607:	c1 fa 1f             	sar    $0x1f,%edx
  80260a:	89 d1                	mov    %edx,%ecx
  80260c:	c1 e9 1b             	shr    $0x1b,%ecx
  80260f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802612:	83 e2 1f             	and    $0x1f,%edx
  802615:	29 ca                	sub    %ecx,%edx
  802617:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80261b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80261f:	83 c0 01             	add    $0x1,%eax
  802622:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802625:	83 c7 01             	add    $0x1,%edi
  802628:	eb ac                	jmp    8025d6 <devpipe_write+0x1c>
	return i;
  80262a:	8b 45 10             	mov    0x10(%ebp),%eax
  80262d:	eb 05                	jmp    802634 <devpipe_write+0x7a>
				return 0;
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802634:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802637:	5b                   	pop    %ebx
  802638:	5e                   	pop    %esi
  802639:	5f                   	pop    %edi
  80263a:	5d                   	pop    %ebp
  80263b:	c3                   	ret    

0080263c <devpipe_read>:
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	57                   	push   %edi
  802640:	56                   	push   %esi
  802641:	53                   	push   %ebx
  802642:	83 ec 18             	sub    $0x18,%esp
  802645:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802648:	57                   	push   %edi
  802649:	e8 d1 f1 ff ff       	call   80181f <fd2data>
  80264e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	be 00 00 00 00       	mov    $0x0,%esi
  802658:	3b 75 10             	cmp    0x10(%ebp),%esi
  80265b:	75 14                	jne    802671 <devpipe_read+0x35>
	return i;
  80265d:	8b 45 10             	mov    0x10(%ebp),%eax
  802660:	eb 02                	jmp    802664 <devpipe_read+0x28>
				return i;
  802662:	89 f0                	mov    %esi,%eax
}
  802664:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
			sys_yield();
  80266c:	e8 a7 e8 ff ff       	call   800f18 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802671:	8b 03                	mov    (%ebx),%eax
  802673:	3b 43 04             	cmp    0x4(%ebx),%eax
  802676:	75 18                	jne    802690 <devpipe_read+0x54>
			if (i > 0)
  802678:	85 f6                	test   %esi,%esi
  80267a:	75 e6                	jne    802662 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80267c:	89 da                	mov    %ebx,%edx
  80267e:	89 f8                	mov    %edi,%eax
  802680:	e8 d0 fe ff ff       	call   802555 <_pipeisclosed>
  802685:	85 c0                	test   %eax,%eax
  802687:	74 e3                	je     80266c <devpipe_read+0x30>
				return 0;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	eb d4                	jmp    802664 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802690:	99                   	cltd   
  802691:	c1 ea 1b             	shr    $0x1b,%edx
  802694:	01 d0                	add    %edx,%eax
  802696:	83 e0 1f             	and    $0x1f,%eax
  802699:	29 d0                	sub    %edx,%eax
  80269b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026a6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8026a9:	83 c6 01             	add    $0x1,%esi
  8026ac:	eb aa                	jmp    802658 <devpipe_read+0x1c>

008026ae <pipe>:
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	56                   	push   %esi
  8026b2:	53                   	push   %ebx
  8026b3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8026b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b9:	50                   	push   %eax
  8026ba:	e8 77 f1 ff ff       	call   801836 <fd_alloc>
  8026bf:	89 c3                	mov    %eax,%ebx
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	0f 88 23 01 00 00    	js     8027ef <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 07 04 00 00       	push   $0x407
  8026d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d7:	6a 00                	push   $0x0
  8026d9:	e8 59 e8 ff ff       	call   800f37 <sys_page_alloc>
  8026de:	89 c3                	mov    %eax,%ebx
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	0f 88 04 01 00 00    	js     8027ef <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026eb:	83 ec 0c             	sub    $0xc,%esp
  8026ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026f1:	50                   	push   %eax
  8026f2:	e8 3f f1 ff ff       	call   801836 <fd_alloc>
  8026f7:	89 c3                	mov    %eax,%ebx
  8026f9:	83 c4 10             	add    $0x10,%esp
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	0f 88 db 00 00 00    	js     8027df <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	68 07 04 00 00       	push   $0x407
  80270c:	ff 75 f0             	pushl  -0x10(%ebp)
  80270f:	6a 00                	push   $0x0
  802711:	e8 21 e8 ff ff       	call   800f37 <sys_page_alloc>
  802716:	89 c3                	mov    %eax,%ebx
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	85 c0                	test   %eax,%eax
  80271d:	0f 88 bc 00 00 00    	js     8027df <pipe+0x131>
	va = fd2data(fd0);
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	ff 75 f4             	pushl  -0xc(%ebp)
  802729:	e8 f1 f0 ff ff       	call   80181f <fd2data>
  80272e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802730:	83 c4 0c             	add    $0xc,%esp
  802733:	68 07 04 00 00       	push   $0x407
  802738:	50                   	push   %eax
  802739:	6a 00                	push   $0x0
  80273b:	e8 f7 e7 ff ff       	call   800f37 <sys_page_alloc>
  802740:	89 c3                	mov    %eax,%ebx
  802742:	83 c4 10             	add    $0x10,%esp
  802745:	85 c0                	test   %eax,%eax
  802747:	0f 88 82 00 00 00    	js     8027cf <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	ff 75 f0             	pushl  -0x10(%ebp)
  802753:	e8 c7 f0 ff ff       	call   80181f <fd2data>
  802758:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80275f:	50                   	push   %eax
  802760:	6a 00                	push   $0x0
  802762:	56                   	push   %esi
  802763:	6a 00                	push   $0x0
  802765:	e8 10 e8 ff ff       	call   800f7a <sys_page_map>
  80276a:	89 c3                	mov    %eax,%ebx
  80276c:	83 c4 20             	add    $0x20,%esp
  80276f:	85 c0                	test   %eax,%eax
  802771:	78 4e                	js     8027c1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802773:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802778:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80277d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802780:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	ff 75 f4             	pushl  -0xc(%ebp)
  80279c:	e8 6e f0 ff ff       	call   80180f <fd2num>
  8027a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027a4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027a6:	83 c4 04             	add    $0x4,%esp
  8027a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ac:	e8 5e f0 ff ff       	call   80180f <fd2num>
  8027b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027b4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027b7:	83 c4 10             	add    $0x10,%esp
  8027ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027bf:	eb 2e                	jmp    8027ef <pipe+0x141>
	sys_page_unmap(0, va);
  8027c1:	83 ec 08             	sub    $0x8,%esp
  8027c4:	56                   	push   %esi
  8027c5:	6a 00                	push   $0x0
  8027c7:	e8 f0 e7 ff ff       	call   800fbc <sys_page_unmap>
  8027cc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027cf:	83 ec 08             	sub    $0x8,%esp
  8027d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8027d5:	6a 00                	push   $0x0
  8027d7:	e8 e0 e7 ff ff       	call   800fbc <sys_page_unmap>
  8027dc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8027df:	83 ec 08             	sub    $0x8,%esp
  8027e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e5:	6a 00                	push   $0x0
  8027e7:	e8 d0 e7 ff ff       	call   800fbc <sys_page_unmap>
  8027ec:	83 c4 10             	add    $0x10,%esp
}
  8027ef:	89 d8                	mov    %ebx,%eax
  8027f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f4:	5b                   	pop    %ebx
  8027f5:	5e                   	pop    %esi
  8027f6:	5d                   	pop    %ebp
  8027f7:	c3                   	ret    

008027f8 <pipeisclosed>:
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802801:	50                   	push   %eax
  802802:	ff 75 08             	pushl  0x8(%ebp)
  802805:	e8 7e f0 ff ff       	call   801888 <fd_lookup>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	85 c0                	test   %eax,%eax
  80280f:	78 18                	js     802829 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802811:	83 ec 0c             	sub    $0xc,%esp
  802814:	ff 75 f4             	pushl  -0xc(%ebp)
  802817:	e8 03 f0 ff ff       	call   80181f <fd2data>
	return _pipeisclosed(fd, p);
  80281c:	89 c2                	mov    %eax,%edx
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	e8 2f fd ff ff       	call   802555 <_pipeisclosed>
  802826:	83 c4 10             	add    $0x10,%esp
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	c3                   	ret    

00802831 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
  802834:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802837:	68 ff 33 80 00       	push   $0x8033ff
  80283c:	ff 75 0c             	pushl  0xc(%ebp)
  80283f:	e8 01 e3 ff ff       	call   800b45 <strcpy>
	return 0;
}
  802844:	b8 00 00 00 00       	mov    $0x0,%eax
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <devcons_write>:
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
  80284e:	57                   	push   %edi
  80284f:	56                   	push   %esi
  802850:	53                   	push   %ebx
  802851:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802857:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80285c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802862:	3b 75 10             	cmp    0x10(%ebp),%esi
  802865:	73 31                	jae    802898 <devcons_write+0x4d>
		m = n - tot;
  802867:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80286a:	29 f3                	sub    %esi,%ebx
  80286c:	83 fb 7f             	cmp    $0x7f,%ebx
  80286f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802874:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	53                   	push   %ebx
  80287b:	89 f0                	mov    %esi,%eax
  80287d:	03 45 0c             	add    0xc(%ebp),%eax
  802880:	50                   	push   %eax
  802881:	57                   	push   %edi
  802882:	e8 4c e4 ff ff       	call   800cd3 <memmove>
		sys_cputs(buf, m);
  802887:	83 c4 08             	add    $0x8,%esp
  80288a:	53                   	push   %ebx
  80288b:	57                   	push   %edi
  80288c:	e8 ea e5 ff ff       	call   800e7b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802891:	01 de                	add    %ebx,%esi
  802893:	83 c4 10             	add    $0x10,%esp
  802896:	eb ca                	jmp    802862 <devcons_write+0x17>
}
  802898:	89 f0                	mov    %esi,%eax
  80289a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80289d:	5b                   	pop    %ebx
  80289e:	5e                   	pop    %esi
  80289f:	5f                   	pop    %edi
  8028a0:	5d                   	pop    %ebp
  8028a1:	c3                   	ret    

008028a2 <devcons_read>:
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 08             	sub    $0x8,%esp
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028b1:	74 21                	je     8028d4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028b3:	e8 e1 e5 ff ff       	call   800e99 <sys_cgetc>
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	75 07                	jne    8028c3 <devcons_read+0x21>
		sys_yield();
  8028bc:	e8 57 e6 ff ff       	call   800f18 <sys_yield>
  8028c1:	eb f0                	jmp    8028b3 <devcons_read+0x11>
	if (c < 0)
  8028c3:	78 0f                	js     8028d4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028c5:	83 f8 04             	cmp    $0x4,%eax
  8028c8:	74 0c                	je     8028d6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8028ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cd:	88 02                	mov    %al,(%edx)
	return 1;
  8028cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    
		return 0;
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028db:	eb f7                	jmp    8028d4 <devcons_read+0x32>

008028dd <cputchar>:
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028e9:	6a 01                	push   $0x1
  8028eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028ee:	50                   	push   %eax
  8028ef:	e8 87 e5 ff ff       	call   800e7b <sys_cputs>
}
  8028f4:	83 c4 10             	add    $0x10,%esp
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <getchar>:
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028ff:	6a 01                	push   $0x1
  802901:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802904:	50                   	push   %eax
  802905:	6a 00                	push   $0x0
  802907:	e8 ec f1 ff ff       	call   801af8 <read>
	if (r < 0)
  80290c:	83 c4 10             	add    $0x10,%esp
  80290f:	85 c0                	test   %eax,%eax
  802911:	78 06                	js     802919 <getchar+0x20>
	if (r < 1)
  802913:	74 06                	je     80291b <getchar+0x22>
	return c;
  802915:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    
		return -E_EOF;
  80291b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802920:	eb f7                	jmp    802919 <getchar+0x20>

00802922 <iscons>:
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802928:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80292b:	50                   	push   %eax
  80292c:	ff 75 08             	pushl  0x8(%ebp)
  80292f:	e8 54 ef ff ff       	call   801888 <fd_lookup>
  802934:	83 c4 10             	add    $0x10,%esp
  802937:	85 c0                	test   %eax,%eax
  802939:	78 11                	js     80294c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802944:	39 10                	cmp    %edx,(%eax)
  802946:	0f 94 c0             	sete   %al
  802949:	0f b6 c0             	movzbl %al,%eax
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <opencons>:
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802954:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802957:	50                   	push   %eax
  802958:	e8 d9 ee ff ff       	call   801836 <fd_alloc>
  80295d:	83 c4 10             	add    $0x10,%esp
  802960:	85 c0                	test   %eax,%eax
  802962:	78 3a                	js     80299e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 07 04 00 00       	push   $0x407
  80296c:	ff 75 f4             	pushl  -0xc(%ebp)
  80296f:	6a 00                	push   $0x0
  802971:	e8 c1 e5 ff ff       	call   800f37 <sys_page_alloc>
  802976:	83 c4 10             	add    $0x10,%esp
  802979:	85 c0                	test   %eax,%eax
  80297b:	78 21                	js     80299e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802986:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802992:	83 ec 0c             	sub    $0xc,%esp
  802995:	50                   	push   %eax
  802996:	e8 74 ee ff ff       	call   80180f <fd2num>
  80299b:	83 c4 10             	add    $0x10,%esp
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029a6:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029ad:	74 0a                	je     8029b9 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029b7:	c9                   	leave  
  8029b8:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	6a 07                	push   $0x7
  8029be:	68 00 f0 bf ee       	push   $0xeebff000
  8029c3:	6a 00                	push   $0x0
  8029c5:	e8 6d e5 ff ff       	call   800f37 <sys_page_alloc>
		if(r < 0)
  8029ca:	83 c4 10             	add    $0x10,%esp
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	78 2a                	js     8029fb <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029d1:	83 ec 08             	sub    $0x8,%esp
  8029d4:	68 0f 2a 80 00       	push   $0x802a0f
  8029d9:	6a 00                	push   $0x0
  8029db:	e8 a2 e6 ff ff       	call   801082 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029e0:	83 c4 10             	add    $0x10,%esp
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	79 c8                	jns    8029af <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8029e7:	83 ec 04             	sub    $0x4,%esp
  8029ea:	68 3c 34 80 00       	push   $0x80343c
  8029ef:	6a 25                	push   $0x25
  8029f1:	68 78 34 80 00       	push   $0x803478
  8029f6:	e8 f5 d8 ff ff       	call   8002f0 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8029fb:	83 ec 04             	sub    $0x4,%esp
  8029fe:	68 0c 34 80 00       	push   $0x80340c
  802a03:	6a 22                	push   $0x22
  802a05:	68 78 34 80 00       	push   $0x803478
  802a0a:	e8 e1 d8 ff ff       	call   8002f0 <_panic>

00802a0f <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a0f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a10:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a15:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a17:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a1a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a1e:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a22:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a25:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a27:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a2b:	83 c4 08             	add    $0x8,%esp
	popal
  802a2e:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a2f:	83 c4 04             	add    $0x4,%esp
	popfl
  802a32:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a33:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a34:	c3                   	ret    
  802a35:	66 90                	xchg   %ax,%ax
  802a37:	66 90                	xchg   %ax,%ax
  802a39:	66 90                	xchg   %ax,%ax
  802a3b:	66 90                	xchg   %ax,%ax
  802a3d:	66 90                	xchg   %ax,%ax
  802a3f:	90                   	nop

00802a40 <__udivdi3>:
  802a40:	55                   	push   %ebp
  802a41:	57                   	push   %edi
  802a42:	56                   	push   %esi
  802a43:	53                   	push   %ebx
  802a44:	83 ec 1c             	sub    $0x1c,%esp
  802a47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a57:	85 d2                	test   %edx,%edx
  802a59:	75 4d                	jne    802aa8 <__udivdi3+0x68>
  802a5b:	39 f3                	cmp    %esi,%ebx
  802a5d:	76 19                	jbe    802a78 <__udivdi3+0x38>
  802a5f:	31 ff                	xor    %edi,%edi
  802a61:	89 e8                	mov    %ebp,%eax
  802a63:	89 f2                	mov    %esi,%edx
  802a65:	f7 f3                	div    %ebx
  802a67:	89 fa                	mov    %edi,%edx
  802a69:	83 c4 1c             	add    $0x1c,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	89 d9                	mov    %ebx,%ecx
  802a7a:	85 db                	test   %ebx,%ebx
  802a7c:	75 0b                	jne    802a89 <__udivdi3+0x49>
  802a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a83:	31 d2                	xor    %edx,%edx
  802a85:	f7 f3                	div    %ebx
  802a87:	89 c1                	mov    %eax,%ecx
  802a89:	31 d2                	xor    %edx,%edx
  802a8b:	89 f0                	mov    %esi,%eax
  802a8d:	f7 f1                	div    %ecx
  802a8f:	89 c6                	mov    %eax,%esi
  802a91:	89 e8                	mov    %ebp,%eax
  802a93:	89 f7                	mov    %esi,%edi
  802a95:	f7 f1                	div    %ecx
  802a97:	89 fa                	mov    %edi,%edx
  802a99:	83 c4 1c             	add    $0x1c,%esp
  802a9c:	5b                   	pop    %ebx
  802a9d:	5e                   	pop    %esi
  802a9e:	5f                   	pop    %edi
  802a9f:	5d                   	pop    %ebp
  802aa0:	c3                   	ret    
  802aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	39 f2                	cmp    %esi,%edx
  802aaa:	77 1c                	ja     802ac8 <__udivdi3+0x88>
  802aac:	0f bd fa             	bsr    %edx,%edi
  802aaf:	83 f7 1f             	xor    $0x1f,%edi
  802ab2:	75 2c                	jne    802ae0 <__udivdi3+0xa0>
  802ab4:	39 f2                	cmp    %esi,%edx
  802ab6:	72 06                	jb     802abe <__udivdi3+0x7e>
  802ab8:	31 c0                	xor    %eax,%eax
  802aba:	39 eb                	cmp    %ebp,%ebx
  802abc:	77 a9                	ja     802a67 <__udivdi3+0x27>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	eb a2                	jmp    802a67 <__udivdi3+0x27>
  802ac5:	8d 76 00             	lea    0x0(%esi),%esi
  802ac8:	31 ff                	xor    %edi,%edi
  802aca:	31 c0                	xor    %eax,%eax
  802acc:	89 fa                	mov    %edi,%edx
  802ace:	83 c4 1c             	add    $0x1c,%esp
  802ad1:	5b                   	pop    %ebx
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    
  802ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802add:	8d 76 00             	lea    0x0(%esi),%esi
  802ae0:	89 f9                	mov    %edi,%ecx
  802ae2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ae7:	29 f8                	sub    %edi,%eax
  802ae9:	d3 e2                	shl    %cl,%edx
  802aeb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802aef:	89 c1                	mov    %eax,%ecx
  802af1:	89 da                	mov    %ebx,%edx
  802af3:	d3 ea                	shr    %cl,%edx
  802af5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802af9:	09 d1                	or     %edx,%ecx
  802afb:	89 f2                	mov    %esi,%edx
  802afd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b01:	89 f9                	mov    %edi,%ecx
  802b03:	d3 e3                	shl    %cl,%ebx
  802b05:	89 c1                	mov    %eax,%ecx
  802b07:	d3 ea                	shr    %cl,%edx
  802b09:	89 f9                	mov    %edi,%ecx
  802b0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b0f:	89 eb                	mov    %ebp,%ebx
  802b11:	d3 e6                	shl    %cl,%esi
  802b13:	89 c1                	mov    %eax,%ecx
  802b15:	d3 eb                	shr    %cl,%ebx
  802b17:	09 de                	or     %ebx,%esi
  802b19:	89 f0                	mov    %esi,%eax
  802b1b:	f7 74 24 08          	divl   0x8(%esp)
  802b1f:	89 d6                	mov    %edx,%esi
  802b21:	89 c3                	mov    %eax,%ebx
  802b23:	f7 64 24 0c          	mull   0xc(%esp)
  802b27:	39 d6                	cmp    %edx,%esi
  802b29:	72 15                	jb     802b40 <__udivdi3+0x100>
  802b2b:	89 f9                	mov    %edi,%ecx
  802b2d:	d3 e5                	shl    %cl,%ebp
  802b2f:	39 c5                	cmp    %eax,%ebp
  802b31:	73 04                	jae    802b37 <__udivdi3+0xf7>
  802b33:	39 d6                	cmp    %edx,%esi
  802b35:	74 09                	je     802b40 <__udivdi3+0x100>
  802b37:	89 d8                	mov    %ebx,%eax
  802b39:	31 ff                	xor    %edi,%edi
  802b3b:	e9 27 ff ff ff       	jmp    802a67 <__udivdi3+0x27>
  802b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b43:	31 ff                	xor    %edi,%edi
  802b45:	e9 1d ff ff ff       	jmp    802a67 <__udivdi3+0x27>
  802b4a:	66 90                	xchg   %ax,%ax
  802b4c:	66 90                	xchg   %ax,%ax
  802b4e:	66 90                	xchg   %ax,%ax

00802b50 <__umoddi3>:
  802b50:	55                   	push   %ebp
  802b51:	57                   	push   %edi
  802b52:	56                   	push   %esi
  802b53:	53                   	push   %ebx
  802b54:	83 ec 1c             	sub    $0x1c,%esp
  802b57:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b67:	89 da                	mov    %ebx,%edx
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	75 43                	jne    802bb0 <__umoddi3+0x60>
  802b6d:	39 df                	cmp    %ebx,%edi
  802b6f:	76 17                	jbe    802b88 <__umoddi3+0x38>
  802b71:	89 f0                	mov    %esi,%eax
  802b73:	f7 f7                	div    %edi
  802b75:	89 d0                	mov    %edx,%eax
  802b77:	31 d2                	xor    %edx,%edx
  802b79:	83 c4 1c             	add    $0x1c,%esp
  802b7c:	5b                   	pop    %ebx
  802b7d:	5e                   	pop    %esi
  802b7e:	5f                   	pop    %edi
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    
  802b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b88:	89 fd                	mov    %edi,%ebp
  802b8a:	85 ff                	test   %edi,%edi
  802b8c:	75 0b                	jne    802b99 <__umoddi3+0x49>
  802b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b93:	31 d2                	xor    %edx,%edx
  802b95:	f7 f7                	div    %edi
  802b97:	89 c5                	mov    %eax,%ebp
  802b99:	89 d8                	mov    %ebx,%eax
  802b9b:	31 d2                	xor    %edx,%edx
  802b9d:	f7 f5                	div    %ebp
  802b9f:	89 f0                	mov    %esi,%eax
  802ba1:	f7 f5                	div    %ebp
  802ba3:	89 d0                	mov    %edx,%eax
  802ba5:	eb d0                	jmp    802b77 <__umoddi3+0x27>
  802ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bae:	66 90                	xchg   %ax,%ax
  802bb0:	89 f1                	mov    %esi,%ecx
  802bb2:	39 d8                	cmp    %ebx,%eax
  802bb4:	76 0a                	jbe    802bc0 <__umoddi3+0x70>
  802bb6:	89 f0                	mov    %esi,%eax
  802bb8:	83 c4 1c             	add    $0x1c,%esp
  802bbb:	5b                   	pop    %ebx
  802bbc:	5e                   	pop    %esi
  802bbd:	5f                   	pop    %edi
  802bbe:	5d                   	pop    %ebp
  802bbf:	c3                   	ret    
  802bc0:	0f bd e8             	bsr    %eax,%ebp
  802bc3:	83 f5 1f             	xor    $0x1f,%ebp
  802bc6:	75 20                	jne    802be8 <__umoddi3+0x98>
  802bc8:	39 d8                	cmp    %ebx,%eax
  802bca:	0f 82 b0 00 00 00    	jb     802c80 <__umoddi3+0x130>
  802bd0:	39 f7                	cmp    %esi,%edi
  802bd2:	0f 86 a8 00 00 00    	jbe    802c80 <__umoddi3+0x130>
  802bd8:	89 c8                	mov    %ecx,%eax
  802bda:	83 c4 1c             	add    $0x1c,%esp
  802bdd:	5b                   	pop    %ebx
  802bde:	5e                   	pop    %esi
  802bdf:	5f                   	pop    %edi
  802be0:	5d                   	pop    %ebp
  802be1:	c3                   	ret    
  802be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802be8:	89 e9                	mov    %ebp,%ecx
  802bea:	ba 20 00 00 00       	mov    $0x20,%edx
  802bef:	29 ea                	sub    %ebp,%edx
  802bf1:	d3 e0                	shl    %cl,%eax
  802bf3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bf7:	89 d1                	mov    %edx,%ecx
  802bf9:	89 f8                	mov    %edi,%eax
  802bfb:	d3 e8                	shr    %cl,%eax
  802bfd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c01:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c05:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c09:	09 c1                	or     %eax,%ecx
  802c0b:	89 d8                	mov    %ebx,%eax
  802c0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c11:	89 e9                	mov    %ebp,%ecx
  802c13:	d3 e7                	shl    %cl,%edi
  802c15:	89 d1                	mov    %edx,%ecx
  802c17:	d3 e8                	shr    %cl,%eax
  802c19:	89 e9                	mov    %ebp,%ecx
  802c1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c1f:	d3 e3                	shl    %cl,%ebx
  802c21:	89 c7                	mov    %eax,%edi
  802c23:	89 d1                	mov    %edx,%ecx
  802c25:	89 f0                	mov    %esi,%eax
  802c27:	d3 e8                	shr    %cl,%eax
  802c29:	89 e9                	mov    %ebp,%ecx
  802c2b:	89 fa                	mov    %edi,%edx
  802c2d:	d3 e6                	shl    %cl,%esi
  802c2f:	09 d8                	or     %ebx,%eax
  802c31:	f7 74 24 08          	divl   0x8(%esp)
  802c35:	89 d1                	mov    %edx,%ecx
  802c37:	89 f3                	mov    %esi,%ebx
  802c39:	f7 64 24 0c          	mull   0xc(%esp)
  802c3d:	89 c6                	mov    %eax,%esi
  802c3f:	89 d7                	mov    %edx,%edi
  802c41:	39 d1                	cmp    %edx,%ecx
  802c43:	72 06                	jb     802c4b <__umoddi3+0xfb>
  802c45:	75 10                	jne    802c57 <__umoddi3+0x107>
  802c47:	39 c3                	cmp    %eax,%ebx
  802c49:	73 0c                	jae    802c57 <__umoddi3+0x107>
  802c4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c53:	89 d7                	mov    %edx,%edi
  802c55:	89 c6                	mov    %eax,%esi
  802c57:	89 ca                	mov    %ecx,%edx
  802c59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c5e:	29 f3                	sub    %esi,%ebx
  802c60:	19 fa                	sbb    %edi,%edx
  802c62:	89 d0                	mov    %edx,%eax
  802c64:	d3 e0                	shl    %cl,%eax
  802c66:	89 e9                	mov    %ebp,%ecx
  802c68:	d3 eb                	shr    %cl,%ebx
  802c6a:	d3 ea                	shr    %cl,%edx
  802c6c:	09 d8                	or     %ebx,%eax
  802c6e:	83 c4 1c             	add    $0x1c,%esp
  802c71:	5b                   	pop    %ebx
  802c72:	5e                   	pop    %esi
  802c73:	5f                   	pop    %edi
  802c74:	5d                   	pop    %ebp
  802c75:	c3                   	ret    
  802c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c7d:	8d 76 00             	lea    0x0(%esi),%esi
  802c80:	89 da                	mov    %ebx,%edx
  802c82:	29 fe                	sub    %edi,%esi
  802c84:	19 c2                	sbb    %eax,%edx
  802c86:	89 f1                	mov    %esi,%ecx
  802c88:	89 c8                	mov    %ecx,%eax
  802c8a:	e9 4b ff ff ff       	jmp    802bda <__umoddi3+0x8a>
