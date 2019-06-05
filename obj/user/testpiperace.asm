
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
  80003b:	68 80 2c 80 00       	push   $0x802c80
  800040:	e8 a1 03 00 00       	call   8003e6 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 3e 26 00 00       	call   80268e <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 66                	js     8000bd <umain+0x8a>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 05 14 00 00       	call   801461 <fork>
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
  800068:	68 da 2c 80 00       	push   $0x802cda
  80006d:	e8 74 03 00 00       	call   8003e6 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800072:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800078:	83 c4 08             	add    $0x8,%esp
  80007b:	56                   	push   %esi
  80007c:	68 e5 2c 80 00       	push   $0x802ce5
  800081:	e8 60 03 00 00       	call   8003e6 <cprintf>
	dup(p[0], 10);
  800086:	83 c4 08             	add    $0x8,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	ff 75 f0             	pushl  -0x10(%ebp)
  80008e:	e8 59 19 00 00       	call   8019ec <dup>
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
  8000b3:	e8 34 19 00 00       	call   8019ec <dup>
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	eb e2                	jmp    80009f <umain+0x6c>
		panic("pipe: %e", r);
  8000bd:	50                   	push   %eax
  8000be:	68 99 2c 80 00       	push   $0x802c99
  8000c3:	6a 0d                	push   $0xd
  8000c5:	68 a2 2c 80 00       	push   $0x802ca2
  8000ca:	e8 21 02 00 00       	call   8002f0 <_panic>
		panic("fork: %e", r);
  8000cf:	50                   	push   %eax
  8000d0:	68 b6 2c 80 00       	push   $0x802cb6
  8000d5:	6a 10                	push   $0x10
  8000d7:	68 a2 2c 80 00       	push   $0x802ca2
  8000dc:	e8 0f 02 00 00       	call   8002f0 <_panic>
		close(p[1]);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e7:	e8 ae 18 00 00       	call   80199a <close>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000f4:	eb 1f                	jmp    800115 <umain+0xe2>
				cprintf("RACE: pipe appears closed\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 bf 2c 80 00       	push   $0x802cbf
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
  80011b:	e8 b8 26 00 00       	call   8027d8 <pipeisclosed>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	85 c0                	test   %eax,%eax
  800125:	74 e4                	je     80010b <umain+0xd8>
  800127:	eb cd                	jmp    8000f6 <umain+0xc3>
		ipc_recv(0,0,0);
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	6a 00                	push   $0x0
  80012e:	6a 00                	push   $0x0
  800130:	6a 00                	push   $0x0
  800132:	e8 bc 15 00 00       	call   8016f3 <ipc_recv>
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	e9 25 ff ff ff       	jmp    800064 <umain+0x31>

	cprintf("child done with loop\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 f0 2c 80 00       	push   $0x802cf0
  800147:	e8 9a 02 00 00       	call   8003e6 <cprintf>
	if (pipeisclosed(p[0]))
  80014c:	83 c4 04             	add    $0x4,%esp
  80014f:	ff 75 f0             	pushl  -0x10(%ebp)
  800152:	e8 81 26 00 00       	call   8027d8 <pipeisclosed>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	85 c0                	test   %eax,%eax
  80015c:	75 48                	jne    8001a6 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800164:	50                   	push   %eax
  800165:	ff 75 f0             	pushl  -0x10(%ebp)
  800168:	e8 fb 16 00 00       	call   801868 <fd_lookup>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	78 46                	js     8001ba <umain+0x187>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 ec             	pushl  -0x14(%ebp)
  80017a:	e8 80 16 00 00       	call   8017ff <fd2data>
	if (pageref(va) != 3+1)
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 94 1e 00 00       	call   80201b <pageref>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	83 f8 04             	cmp    $0x4,%eax
  80018d:	74 3d                	je     8001cc <umain+0x199>
		cprintf("\nchild detected race\n");
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	68 1e 2d 80 00       	push   $0x802d1e
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
  8001a9:	68 4c 2d 80 00       	push   $0x802d4c
  8001ae:	6a 3a                	push   $0x3a
  8001b0:	68 a2 2c 80 00       	push   $0x802ca2
  8001b5:	e8 36 01 00 00       	call   8002f0 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001ba:	50                   	push   %eax
  8001bb:	68 06 2d 80 00       	push   $0x802d06
  8001c0:	6a 3c                	push   $0x3c
  8001c2:	68 a2 2c 80 00       	push   $0x802ca2
  8001c7:	e8 24 01 00 00       	call   8002f0 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	68 c8 00 00 00       	push   $0xc8
  8001d4:	68 34 2d 80 00       	push   $0x802d34
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
  800266:	68 76 2d 80 00       	push   $0x802d76
  80026b:	e8 76 01 00 00       	call   8003e6 <cprintf>
	cprintf("before umain\n");
  800270:	c7 04 24 94 2d 80 00 	movl   $0x802d94,(%esp)
  800277:	e8 6a 01 00 00       	call   8003e6 <cprintf>
	// call user main routine
	umain(argc, argv);
  80027c:	83 c4 08             	add    $0x8,%esp
  80027f:	ff 75 0c             	pushl  0xc(%ebp)
  800282:	ff 75 08             	pushl  0x8(%ebp)
  800285:	e8 a9 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80028a:	c7 04 24 a2 2d 80 00 	movl   $0x802da2,(%esp)
  800291:	e8 50 01 00 00       	call   8003e6 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800296:	a1 08 50 80 00       	mov    0x805008,%eax
  80029b:	8b 40 48             	mov    0x48(%eax),%eax
  80029e:	83 c4 08             	add    $0x8,%esp
  8002a1:	50                   	push   %eax
  8002a2:	68 af 2d 80 00       	push   $0x802daf
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
  8002ca:	68 dc 2d 80 00       	push   $0x802ddc
  8002cf:	50                   	push   %eax
  8002d0:	68 ce 2d 80 00       	push   $0x802dce
  8002d5:	e8 0c 01 00 00       	call   8003e6 <cprintf>
	close_all();
  8002da:	e8 e8 16 00 00       	call   8019c7 <close_all>
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
  800300:	68 08 2e 80 00       	push   $0x802e08
  800305:	50                   	push   %eax
  800306:	68 ce 2d 80 00       	push   $0x802dce
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
  800329:	68 e4 2d 80 00       	push   $0x802de4
  80032e:	e8 b3 00 00 00       	call   8003e6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800333:	83 c4 18             	add    $0x18,%esp
  800336:	53                   	push   %ebx
  800337:	ff 75 10             	pushl  0x10(%ebp)
  80033a:	e8 56 00 00 00       	call   800395 <vcprintf>
	cprintf("\n");
  80033f:	c7 04 24 92 2d 80 00 	movl   $0x802d92,(%esp)
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
  800493:	e8 88 25 00 00       	call   802a20 <__udivdi3>
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
  8004bc:	e8 6f 26 00 00       	call   802b30 <__umoddi3>
  8004c1:	83 c4 14             	add    $0x14,%esp
  8004c4:	0f be 80 0f 2e 80 00 	movsbl 0x802e0f(%eax),%eax
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
  80056d:	ff 24 85 e0 2f 80 00 	jmp    *0x802fe0(,%eax,4)
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
  800638:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  80063f:	85 d2                	test   %edx,%edx
  800641:	74 18                	je     80065b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800643:	52                   	push   %edx
  800644:	68 6d 33 80 00       	push   $0x80336d
  800649:	53                   	push   %ebx
  80064a:	56                   	push   %esi
  80064b:	e8 a6 fe ff ff       	call   8004f6 <printfmt>
  800650:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800653:	89 7d 14             	mov    %edi,0x14(%ebp)
  800656:	e9 fe 02 00 00       	jmp    800959 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80065b:	50                   	push   %eax
  80065c:	68 27 2e 80 00       	push   $0x802e27
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
  800683:	b8 20 2e 80 00       	mov    $0x802e20,%eax
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
  800a1b:	bf 45 2f 80 00       	mov    $0x802f45,%edi
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
  800a47:	bf 7d 2f 80 00       	mov    $0x802f7d,%edi
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
  800ee8:	68 88 31 80 00       	push   $0x803188
  800eed:	6a 43                	push   $0x43
  800eef:	68 a5 31 80 00       	push   $0x8031a5
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
  800f69:	68 88 31 80 00       	push   $0x803188
  800f6e:	6a 43                	push   $0x43
  800f70:	68 a5 31 80 00       	push   $0x8031a5
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
  800fab:	68 88 31 80 00       	push   $0x803188
  800fb0:	6a 43                	push   $0x43
  800fb2:	68 a5 31 80 00       	push   $0x8031a5
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
  800fed:	68 88 31 80 00       	push   $0x803188
  800ff2:	6a 43                	push   $0x43
  800ff4:	68 a5 31 80 00       	push   $0x8031a5
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
  80102f:	68 88 31 80 00       	push   $0x803188
  801034:	6a 43                	push   $0x43
  801036:	68 a5 31 80 00       	push   $0x8031a5
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
  801071:	68 88 31 80 00       	push   $0x803188
  801076:	6a 43                	push   $0x43
  801078:	68 a5 31 80 00       	push   $0x8031a5
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
  8010b3:	68 88 31 80 00       	push   $0x803188
  8010b8:	6a 43                	push   $0x43
  8010ba:	68 a5 31 80 00       	push   $0x8031a5
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
  801117:	68 88 31 80 00       	push   $0x803188
  80111c:	6a 43                	push   $0x43
  80111e:	68 a5 31 80 00       	push   $0x8031a5
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
  8011fb:	68 88 31 80 00       	push   $0x803188
  801200:	6a 43                	push   $0x43
  801202:	68 a5 31 80 00       	push   $0x8031a5
  801207:	e8 e4 f0 ff ff       	call   8002f0 <_panic>

0080120c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	53                   	push   %ebx
  801210:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801213:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80121a:	f6 c5 04             	test   $0x4,%ch
  80121d:	75 45                	jne    801264 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80121f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801226:	83 e1 07             	and    $0x7,%ecx
  801229:	83 f9 07             	cmp    $0x7,%ecx
  80122c:	74 6f                	je     80129d <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80122e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801235:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80123b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801241:	0f 84 b6 00 00 00    	je     8012fd <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801247:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80124e:	83 e1 05             	and    $0x5,%ecx
  801251:	83 f9 05             	cmp    $0x5,%ecx
  801254:	0f 84 d7 00 00 00    	je     801331 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
  80125f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801262:	c9                   	leave  
  801263:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801264:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80126b:	c1 e2 0c             	shl    $0xc,%edx
  80126e:	83 ec 0c             	sub    $0xc,%esp
  801271:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801277:	51                   	push   %ecx
  801278:	52                   	push   %edx
  801279:	50                   	push   %eax
  80127a:	52                   	push   %edx
  80127b:	6a 00                	push   $0x0
  80127d:	e8 f8 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  801282:	83 c4 20             	add    $0x20,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	79 d1                	jns    80125a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801289:	83 ec 04             	sub    $0x4,%esp
  80128c:	68 b3 31 80 00       	push   $0x8031b3
  801291:	6a 54                	push   $0x54
  801293:	68 c9 31 80 00       	push   $0x8031c9
  801298:	e8 53 f0 ff ff       	call   8002f0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80129d:	89 d3                	mov    %edx,%ebx
  80129f:	c1 e3 0c             	shl    $0xc,%ebx
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	68 05 08 00 00       	push   $0x805
  8012aa:	53                   	push   %ebx
  8012ab:	50                   	push   %eax
  8012ac:	53                   	push   %ebx
  8012ad:	6a 00                	push   $0x0
  8012af:	e8 c6 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  8012b4:	83 c4 20             	add    $0x20,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 2e                	js     8012e9 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	68 05 08 00 00       	push   $0x805
  8012c3:	53                   	push   %ebx
  8012c4:	6a 00                	push   $0x0
  8012c6:	53                   	push   %ebx
  8012c7:	6a 00                	push   $0x0
  8012c9:	e8 ac fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  8012ce:	83 c4 20             	add    $0x20,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	79 85                	jns    80125a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 b3 31 80 00       	push   $0x8031b3
  8012dd:	6a 5f                	push   $0x5f
  8012df:	68 c9 31 80 00       	push   $0x8031c9
  8012e4:	e8 07 f0 ff ff       	call   8002f0 <_panic>
			panic("sys_page_map() panic\n");
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	68 b3 31 80 00       	push   $0x8031b3
  8012f1:	6a 5b                	push   $0x5b
  8012f3:	68 c9 31 80 00       	push   $0x8031c9
  8012f8:	e8 f3 ef ff ff       	call   8002f0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012fd:	c1 e2 0c             	shl    $0xc,%edx
  801300:	83 ec 0c             	sub    $0xc,%esp
  801303:	68 05 08 00 00       	push   $0x805
  801308:	52                   	push   %edx
  801309:	50                   	push   %eax
  80130a:	52                   	push   %edx
  80130b:	6a 00                	push   $0x0
  80130d:	e8 68 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  801312:	83 c4 20             	add    $0x20,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	0f 89 3d ff ff ff    	jns    80125a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80131d:	83 ec 04             	sub    $0x4,%esp
  801320:	68 b3 31 80 00       	push   $0x8031b3
  801325:	6a 66                	push   $0x66
  801327:	68 c9 31 80 00       	push   $0x8031c9
  80132c:	e8 bf ef ff ff       	call   8002f0 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801331:	c1 e2 0c             	shl    $0xc,%edx
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	6a 05                	push   $0x5
  801339:	52                   	push   %edx
  80133a:	50                   	push   %eax
  80133b:	52                   	push   %edx
  80133c:	6a 00                	push   $0x0
  80133e:	e8 37 fc ff ff       	call   800f7a <sys_page_map>
		if(r < 0)
  801343:	83 c4 20             	add    $0x20,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	0f 89 0c ff ff ff    	jns    80125a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	68 b3 31 80 00       	push   $0x8031b3
  801356:	6a 6d                	push   $0x6d
  801358:	68 c9 31 80 00       	push   $0x8031c9
  80135d:	e8 8e ef ff ff       	call   8002f0 <_panic>

00801362 <pgfault>:
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	53                   	push   %ebx
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80136c:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80136e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801372:	0f 84 99 00 00 00    	je     801411 <pgfault+0xaf>
  801378:	89 c2                	mov    %eax,%edx
  80137a:	c1 ea 16             	shr    $0x16,%edx
  80137d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	0f 84 84 00 00 00    	je     801411 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80138d:	89 c2                	mov    %eax,%edx
  80138f:	c1 ea 0c             	shr    $0xc,%edx
  801392:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801399:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80139f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013a5:	75 6a                	jne    801411 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ac:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013ae:	83 ec 04             	sub    $0x4,%esp
  8013b1:	6a 07                	push   $0x7
  8013b3:	68 00 f0 7f 00       	push   $0x7ff000
  8013b8:	6a 00                	push   $0x0
  8013ba:	e8 78 fb ff ff       	call   800f37 <sys_page_alloc>
	if(ret < 0)
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 5f                	js     801425 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	68 00 10 00 00       	push   $0x1000
  8013ce:	53                   	push   %ebx
  8013cf:	68 00 f0 7f 00       	push   $0x7ff000
  8013d4:	e8 5c f9 ff ff       	call   800d35 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013d9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013e0:	53                   	push   %ebx
  8013e1:	6a 00                	push   $0x0
  8013e3:	68 00 f0 7f 00       	push   $0x7ff000
  8013e8:	6a 00                	push   $0x0
  8013ea:	e8 8b fb ff ff       	call   800f7a <sys_page_map>
	if(ret < 0)
  8013ef:	83 c4 20             	add    $0x20,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 43                	js     801439 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	68 00 f0 7f 00       	push   $0x7ff000
  8013fe:	6a 00                	push   $0x0
  801400:	e8 b7 fb ff ff       	call   800fbc <sys_page_unmap>
	if(ret < 0)
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 41                	js     80144d <pgfault+0xeb>
}
  80140c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140f:	c9                   	leave  
  801410:	c3                   	ret    
		panic("panic at pgfault()\n");
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	68 d4 31 80 00       	push   $0x8031d4
  801419:	6a 26                	push   $0x26
  80141b:	68 c9 31 80 00       	push   $0x8031c9
  801420:	e8 cb ee ff ff       	call   8002f0 <_panic>
		panic("panic in sys_page_alloc()\n");
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	68 e8 31 80 00       	push   $0x8031e8
  80142d:	6a 31                	push   $0x31
  80142f:	68 c9 31 80 00       	push   $0x8031c9
  801434:	e8 b7 ee ff ff       	call   8002f0 <_panic>
		panic("panic in sys_page_map()\n");
  801439:	83 ec 04             	sub    $0x4,%esp
  80143c:	68 03 32 80 00       	push   $0x803203
  801441:	6a 36                	push   $0x36
  801443:	68 c9 31 80 00       	push   $0x8031c9
  801448:	e8 a3 ee ff ff       	call   8002f0 <_panic>
		panic("panic in sys_page_unmap()\n");
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	68 1c 32 80 00       	push   $0x80321c
  801455:	6a 39                	push   $0x39
  801457:	68 c9 31 80 00       	push   $0x8031c9
  80145c:	e8 8f ee ff ff       	call   8002f0 <_panic>

00801461 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	57                   	push   %edi
  801465:	56                   	push   %esi
  801466:	53                   	push   %ebx
  801467:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80146a:	68 62 13 80 00       	push   $0x801362
  80146f:	e8 0c 15 00 00       	call   802980 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801474:	b8 07 00 00 00       	mov    $0x7,%eax
  801479:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 27                	js     8014a9 <fork+0x48>
  801482:	89 c6                	mov    %eax,%esi
  801484:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801486:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80148b:	75 48                	jne    8014d5 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80148d:	e8 67 fa ff ff       	call   800ef9 <sys_getenvid>
  801492:	25 ff 03 00 00       	and    $0x3ff,%eax
  801497:	c1 e0 07             	shl    $0x7,%eax
  80149a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80149f:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014a4:	e9 90 00 00 00       	jmp    801539 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	68 38 32 80 00       	push   $0x803238
  8014b1:	68 8c 00 00 00       	push   $0x8c
  8014b6:	68 c9 31 80 00       	push   $0x8031c9
  8014bb:	e8 30 ee ff ff       	call   8002f0 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014c0:	89 f8                	mov    %edi,%eax
  8014c2:	e8 45 fd ff ff       	call   80120c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014cd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014d3:	74 26                	je     8014fb <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014d5:	89 d8                	mov    %ebx,%eax
  8014d7:	c1 e8 16             	shr    $0x16,%eax
  8014da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e1:	a8 01                	test   $0x1,%al
  8014e3:	74 e2                	je     8014c7 <fork+0x66>
  8014e5:	89 da                	mov    %ebx,%edx
  8014e7:	c1 ea 0c             	shr    $0xc,%edx
  8014ea:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014f1:	83 e0 05             	and    $0x5,%eax
  8014f4:	83 f8 05             	cmp    $0x5,%eax
  8014f7:	75 ce                	jne    8014c7 <fork+0x66>
  8014f9:	eb c5                	jmp    8014c0 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	6a 07                	push   $0x7
  801500:	68 00 f0 bf ee       	push   $0xeebff000
  801505:	56                   	push   %esi
  801506:	e8 2c fa ff ff       	call   800f37 <sys_page_alloc>
	if(ret < 0)
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 31                	js     801543 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	68 ef 29 80 00       	push   $0x8029ef
  80151a:	56                   	push   %esi
  80151b:	e8 62 fb ff ff       	call   801082 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 33                	js     80155a <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801527:	83 ec 08             	sub    $0x8,%esp
  80152a:	6a 02                	push   $0x2
  80152c:	56                   	push   %esi
  80152d:	e8 cc fa ff ff       	call   800ffe <sys_env_set_status>
	if(ret < 0)
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	78 38                	js     801571 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801539:	89 f0                	mov    %esi,%eax
  80153b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153e:	5b                   	pop    %ebx
  80153f:	5e                   	pop    %esi
  801540:	5f                   	pop    %edi
  801541:	5d                   	pop    %ebp
  801542:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801543:	83 ec 04             	sub    $0x4,%esp
  801546:	68 e8 31 80 00       	push   $0x8031e8
  80154b:	68 98 00 00 00       	push   $0x98
  801550:	68 c9 31 80 00       	push   $0x8031c9
  801555:	e8 96 ed ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	68 5c 32 80 00       	push   $0x80325c
  801562:	68 9b 00 00 00       	push   $0x9b
  801567:	68 c9 31 80 00       	push   $0x8031c9
  80156c:	e8 7f ed ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_status()\n");
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	68 84 32 80 00       	push   $0x803284
  801579:	68 9e 00 00 00       	push   $0x9e
  80157e:	68 c9 31 80 00       	push   $0x8031c9
  801583:	e8 68 ed ff ff       	call   8002f0 <_panic>

00801588 <sfork>:

// Challenge!
int
sfork(void)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	57                   	push   %edi
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
  80158e:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801591:	68 62 13 80 00       	push   $0x801362
  801596:	e8 e5 13 00 00       	call   802980 <set_pgfault_handler>
  80159b:	b8 07 00 00 00       	mov    $0x7,%eax
  8015a0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 27                	js     8015d0 <sfork+0x48>
  8015a9:	89 c7                	mov    %eax,%edi
  8015ab:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015ad:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015b2:	75 55                	jne    801609 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015b4:	e8 40 f9 ff ff       	call   800ef9 <sys_getenvid>
  8015b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015be:	c1 e0 07             	shl    $0x7,%eax
  8015c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015c6:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015cb:	e9 d4 00 00 00       	jmp    8016a4 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	68 38 32 80 00       	push   $0x803238
  8015d8:	68 af 00 00 00       	push   $0xaf
  8015dd:	68 c9 31 80 00       	push   $0x8031c9
  8015e2:	e8 09 ed ff ff       	call   8002f0 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015e7:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015ec:	89 f0                	mov    %esi,%eax
  8015ee:	e8 19 fc ff ff       	call   80120c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015f9:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015ff:	77 65                	ja     801666 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801601:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801607:	74 de                	je     8015e7 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801609:	89 d8                	mov    %ebx,%eax
  80160b:	c1 e8 16             	shr    $0x16,%eax
  80160e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801615:	a8 01                	test   $0x1,%al
  801617:	74 da                	je     8015f3 <sfork+0x6b>
  801619:	89 da                	mov    %ebx,%edx
  80161b:	c1 ea 0c             	shr    $0xc,%edx
  80161e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801625:	83 e0 05             	and    $0x5,%eax
  801628:	83 f8 05             	cmp    $0x5,%eax
  80162b:	75 c6                	jne    8015f3 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80162d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801634:	c1 e2 0c             	shl    $0xc,%edx
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	83 e0 07             	and    $0x7,%eax
  80163d:	50                   	push   %eax
  80163e:	52                   	push   %edx
  80163f:	56                   	push   %esi
  801640:	52                   	push   %edx
  801641:	6a 00                	push   $0x0
  801643:	e8 32 f9 ff ff       	call   800f7a <sys_page_map>
  801648:	83 c4 20             	add    $0x20,%esp
  80164b:	85 c0                	test   %eax,%eax
  80164d:	74 a4                	je     8015f3 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	68 b3 31 80 00       	push   $0x8031b3
  801657:	68 ba 00 00 00       	push   $0xba
  80165c:	68 c9 31 80 00       	push   $0x8031c9
  801661:	e8 8a ec ff ff       	call   8002f0 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801666:	83 ec 04             	sub    $0x4,%esp
  801669:	6a 07                	push   $0x7
  80166b:	68 00 f0 bf ee       	push   $0xeebff000
  801670:	57                   	push   %edi
  801671:	e8 c1 f8 ff ff       	call   800f37 <sys_page_alloc>
	if(ret < 0)
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 31                	js     8016ae <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	68 ef 29 80 00       	push   $0x8029ef
  801685:	57                   	push   %edi
  801686:	e8 f7 f9 ff ff       	call   801082 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 33                	js     8016c5 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	6a 02                	push   $0x2
  801697:	57                   	push   %edi
  801698:	e8 61 f9 ff ff       	call   800ffe <sys_env_set_status>
	if(ret < 0)
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 38                	js     8016dc <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016a4:	89 f8                	mov    %edi,%eax
  8016a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016a9:	5b                   	pop    %ebx
  8016aa:	5e                   	pop    %esi
  8016ab:	5f                   	pop    %edi
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 e8 31 80 00       	push   $0x8031e8
  8016b6:	68 c0 00 00 00       	push   $0xc0
  8016bb:	68 c9 31 80 00       	push   $0x8031c9
  8016c0:	e8 2b ec ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	68 5c 32 80 00       	push   $0x80325c
  8016cd:	68 c3 00 00 00       	push   $0xc3
  8016d2:	68 c9 31 80 00       	push   $0x8031c9
  8016d7:	e8 14 ec ff ff       	call   8002f0 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 84 32 80 00       	push   $0x803284
  8016e4:	68 c6 00 00 00       	push   $0xc6
  8016e9:	68 c9 31 80 00       	push   $0x8031c9
  8016ee:	e8 fd eb ff ff       	call   8002f0 <_panic>

008016f3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8016fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801701:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801703:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801708:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80170b:	83 ec 0c             	sub    $0xc,%esp
  80170e:	50                   	push   %eax
  80170f:	e8 d3 f9 ff ff       	call   8010e7 <sys_ipc_recv>
	if(ret < 0){
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	78 2b                	js     801746 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80171b:	85 f6                	test   %esi,%esi
  80171d:	74 0a                	je     801729 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80171f:	a1 08 50 80 00       	mov    0x805008,%eax
  801724:	8b 40 74             	mov    0x74(%eax),%eax
  801727:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801729:	85 db                	test   %ebx,%ebx
  80172b:	74 0a                	je     801737 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80172d:	a1 08 50 80 00       	mov    0x805008,%eax
  801732:	8b 40 78             	mov    0x78(%eax),%eax
  801735:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801737:	a1 08 50 80 00       	mov    0x805008,%eax
  80173c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80173f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801742:	5b                   	pop    %ebx
  801743:	5e                   	pop    %esi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    
		if(from_env_store)
  801746:	85 f6                	test   %esi,%esi
  801748:	74 06                	je     801750 <ipc_recv+0x5d>
			*from_env_store = 0;
  80174a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801750:	85 db                	test   %ebx,%ebx
  801752:	74 eb                	je     80173f <ipc_recv+0x4c>
			*perm_store = 0;
  801754:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80175a:	eb e3                	jmp    80173f <ipc_recv+0x4c>

0080175c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	57                   	push   %edi
  801760:	56                   	push   %esi
  801761:	53                   	push   %ebx
  801762:	83 ec 0c             	sub    $0xc,%esp
  801765:	8b 7d 08             	mov    0x8(%ebp),%edi
  801768:	8b 75 0c             	mov    0xc(%ebp),%esi
  80176b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80176e:	85 db                	test   %ebx,%ebx
  801770:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801775:	0f 44 d8             	cmove  %eax,%ebx
  801778:	eb 05                	jmp    80177f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80177a:	e8 99 f7 ff ff       	call   800f18 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80177f:	ff 75 14             	pushl  0x14(%ebp)
  801782:	53                   	push   %ebx
  801783:	56                   	push   %esi
  801784:	57                   	push   %edi
  801785:	e8 3a f9 ff ff       	call   8010c4 <sys_ipc_try_send>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	74 1b                	je     8017ac <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801791:	79 e7                	jns    80177a <ipc_send+0x1e>
  801793:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801796:	74 e2                	je     80177a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 a3 32 80 00       	push   $0x8032a3
  8017a0:	6a 4a                	push   $0x4a
  8017a2:	68 b8 32 80 00       	push   $0x8032b8
  8017a7:	e8 44 eb ff ff       	call   8002f0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8017ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017bf:	89 c2                	mov    %eax,%edx
  8017c1:	c1 e2 07             	shl    $0x7,%edx
  8017c4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8017ca:	8b 52 50             	mov    0x50(%edx),%edx
  8017cd:	39 ca                	cmp    %ecx,%edx
  8017cf:	74 11                	je     8017e2 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8017d1:	83 c0 01             	add    $0x1,%eax
  8017d4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017d9:	75 e4                	jne    8017bf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e0:	eb 0b                	jmp    8017ed <ipc_find_env+0x39>
			return envs[i].env_id;
  8017e2:	c1 e0 07             	shl    $0x7,%eax
  8017e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017ea:	8b 40 48             	mov    0x48(%eax),%eax
}
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	05 00 00 00 30       	add    $0x30000000,%eax
  8017fa:	c1 e8 0c             	shr    $0xc,%eax
}
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80180a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80180f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80181e:	89 c2                	mov    %eax,%edx
  801820:	c1 ea 16             	shr    $0x16,%edx
  801823:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80182a:	f6 c2 01             	test   $0x1,%dl
  80182d:	74 2d                	je     80185c <fd_alloc+0x46>
  80182f:	89 c2                	mov    %eax,%edx
  801831:	c1 ea 0c             	shr    $0xc,%edx
  801834:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80183b:	f6 c2 01             	test   $0x1,%dl
  80183e:	74 1c                	je     80185c <fd_alloc+0x46>
  801840:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801845:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80184a:	75 d2                	jne    80181e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801855:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80185a:	eb 0a                	jmp    801866 <fd_alloc+0x50>
			*fd_store = fd;
  80185c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80185f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80186e:	83 f8 1f             	cmp    $0x1f,%eax
  801871:	77 30                	ja     8018a3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801873:	c1 e0 0c             	shl    $0xc,%eax
  801876:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80187b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801881:	f6 c2 01             	test   $0x1,%dl
  801884:	74 24                	je     8018aa <fd_lookup+0x42>
  801886:	89 c2                	mov    %eax,%edx
  801888:	c1 ea 0c             	shr    $0xc,%edx
  80188b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801892:	f6 c2 01             	test   $0x1,%dl
  801895:	74 1a                	je     8018b1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	89 02                	mov    %eax,(%edx)
	return 0;
  80189c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a1:	5d                   	pop    %ebp
  8018a2:	c3                   	ret    
		return -E_INVAL;
  8018a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a8:	eb f7                	jmp    8018a1 <fd_lookup+0x39>
		return -E_INVAL;
  8018aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018af:	eb f0                	jmp    8018a1 <fd_lookup+0x39>
  8018b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b6:	eb e9                	jmp    8018a1 <fd_lookup+0x39>

008018b8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c6:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018cb:	39 08                	cmp    %ecx,(%eax)
  8018cd:	74 38                	je     801907 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018cf:	83 c2 01             	add    $0x1,%edx
  8018d2:	8b 04 95 40 33 80 00 	mov    0x803340(,%edx,4),%eax
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	75 ee                	jne    8018cb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018dd:	a1 08 50 80 00       	mov    0x805008,%eax
  8018e2:	8b 40 48             	mov    0x48(%eax),%eax
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	51                   	push   %ecx
  8018e9:	50                   	push   %eax
  8018ea:	68 c4 32 80 00       	push   $0x8032c4
  8018ef:	e8 f2 ea ff ff       	call   8003e6 <cprintf>
	*dev = 0;
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    
			*dev = devtab[i];
  801907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80190a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80190c:	b8 00 00 00 00       	mov    $0x0,%eax
  801911:	eb f2                	jmp    801905 <dev_lookup+0x4d>

00801913 <fd_close>:
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	57                   	push   %edi
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	83 ec 24             	sub    $0x24,%esp
  80191c:	8b 75 08             	mov    0x8(%ebp),%esi
  80191f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801922:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801925:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801926:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80192c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80192f:	50                   	push   %eax
  801930:	e8 33 ff ff ff       	call   801868 <fd_lookup>
  801935:	89 c3                	mov    %eax,%ebx
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 05                	js     801943 <fd_close+0x30>
	    || fd != fd2)
  80193e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801941:	74 16                	je     801959 <fd_close+0x46>
		return (must_exist ? r : 0);
  801943:	89 f8                	mov    %edi,%eax
  801945:	84 c0                	test   %al,%al
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	0f 44 d8             	cmove  %eax,%ebx
}
  80194f:	89 d8                	mov    %ebx,%eax
  801951:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5f                   	pop    %edi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80195f:	50                   	push   %eax
  801960:	ff 36                	pushl  (%esi)
  801962:	e8 51 ff ff ff       	call   8018b8 <dev_lookup>
  801967:	89 c3                	mov    %eax,%ebx
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	85 c0                	test   %eax,%eax
  80196e:	78 1a                	js     80198a <fd_close+0x77>
		if (dev->dev_close)
  801970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801973:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801976:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	74 0b                	je     80198a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80197f:	83 ec 0c             	sub    $0xc,%esp
  801982:	56                   	push   %esi
  801983:	ff d0                	call   *%eax
  801985:	89 c3                	mov    %eax,%ebx
  801987:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	56                   	push   %esi
  80198e:	6a 00                	push   $0x0
  801990:	e8 27 f6 ff ff       	call   800fbc <sys_page_unmap>
	return r;
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	eb b5                	jmp    80194f <fd_close+0x3c>

0080199a <close>:

int
close(int fdnum)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	e8 bc fe ff ff       	call   801868 <fd_lookup>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	79 02                	jns    8019b5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    
		return fd_close(fd, 1);
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	6a 01                	push   $0x1
  8019ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bd:	e8 51 ff ff ff       	call   801913 <fd_close>
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	eb ec                	jmp    8019b3 <close+0x19>

008019c7 <close_all>:

void
close_all(void)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	53                   	push   %ebx
  8019cb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019ce:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019d3:	83 ec 0c             	sub    $0xc,%esp
  8019d6:	53                   	push   %ebx
  8019d7:	e8 be ff ff ff       	call   80199a <close>
	for (i = 0; i < MAXFD; i++)
  8019dc:	83 c3 01             	add    $0x1,%ebx
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	83 fb 20             	cmp    $0x20,%ebx
  8019e5:	75 ec                	jne    8019d3 <close_all+0xc>
}
  8019e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	57                   	push   %edi
  8019f0:	56                   	push   %esi
  8019f1:	53                   	push   %ebx
  8019f2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 67 fe ff ff       	call   801868 <fd_lookup>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	0f 88 81 00 00 00    	js     801a8f <dup+0xa3>
		return r;
	close(newfdnum);
  801a0e:	83 ec 0c             	sub    $0xc,%esp
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	e8 81 ff ff ff       	call   80199a <close>

	newfd = INDEX2FD(newfdnum);
  801a19:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a1c:	c1 e6 0c             	shl    $0xc,%esi
  801a1f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a25:	83 c4 04             	add    $0x4,%esp
  801a28:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a2b:	e8 cf fd ff ff       	call   8017ff <fd2data>
  801a30:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a32:	89 34 24             	mov    %esi,(%esp)
  801a35:	e8 c5 fd ff ff       	call   8017ff <fd2data>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a3f:	89 d8                	mov    %ebx,%eax
  801a41:	c1 e8 16             	shr    $0x16,%eax
  801a44:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a4b:	a8 01                	test   $0x1,%al
  801a4d:	74 11                	je     801a60 <dup+0x74>
  801a4f:	89 d8                	mov    %ebx,%eax
  801a51:	c1 e8 0c             	shr    $0xc,%eax
  801a54:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a5b:	f6 c2 01             	test   $0x1,%dl
  801a5e:	75 39                	jne    801a99 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a63:	89 d0                	mov    %edx,%eax
  801a65:	c1 e8 0c             	shr    $0xc,%eax
  801a68:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	25 07 0e 00 00       	and    $0xe07,%eax
  801a77:	50                   	push   %eax
  801a78:	56                   	push   %esi
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	6a 00                	push   $0x0
  801a7e:	e8 f7 f4 ff ff       	call   800f7a <sys_page_map>
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	83 c4 20             	add    $0x20,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 31                	js     801abd <dup+0xd1>
		goto err;

	return newfdnum;
  801a8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a94:	5b                   	pop    %ebx
  801a95:	5e                   	pop    %esi
  801a96:	5f                   	pop    %edi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a99:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aa0:	83 ec 0c             	sub    $0xc,%esp
  801aa3:	25 07 0e 00 00       	and    $0xe07,%eax
  801aa8:	50                   	push   %eax
  801aa9:	57                   	push   %edi
  801aaa:	6a 00                	push   $0x0
  801aac:	53                   	push   %ebx
  801aad:	6a 00                	push   $0x0
  801aaf:	e8 c6 f4 ff ff       	call   800f7a <sys_page_map>
  801ab4:	89 c3                	mov    %eax,%ebx
  801ab6:	83 c4 20             	add    $0x20,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	79 a3                	jns    801a60 <dup+0x74>
	sys_page_unmap(0, newfd);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	56                   	push   %esi
  801ac1:	6a 00                	push   $0x0
  801ac3:	e8 f4 f4 ff ff       	call   800fbc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	57                   	push   %edi
  801acc:	6a 00                	push   $0x0
  801ace:	e8 e9 f4 ff ff       	call   800fbc <sys_page_unmap>
	return r;
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	eb b7                	jmp    801a8f <dup+0xa3>

00801ad8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	53                   	push   %ebx
  801adc:	83 ec 1c             	sub    $0x1c,%esp
  801adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae5:	50                   	push   %eax
  801ae6:	53                   	push   %ebx
  801ae7:	e8 7c fd ff ff       	call   801868 <fd_lookup>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 3f                	js     801b32 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af3:	83 ec 08             	sub    $0x8,%esp
  801af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af9:	50                   	push   %eax
  801afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afd:	ff 30                	pushl  (%eax)
  801aff:	e8 b4 fd ff ff       	call   8018b8 <dev_lookup>
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 27                	js     801b32 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b0e:	8b 42 08             	mov    0x8(%edx),%eax
  801b11:	83 e0 03             	and    $0x3,%eax
  801b14:	83 f8 01             	cmp    $0x1,%eax
  801b17:	74 1e                	je     801b37 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1c:	8b 40 08             	mov    0x8(%eax),%eax
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	74 35                	je     801b58 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	ff 75 10             	pushl  0x10(%ebp)
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	52                   	push   %edx
  801b2d:	ff d0                	call   *%eax
  801b2f:	83 c4 10             	add    $0x10,%esp
}
  801b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b37:	a1 08 50 80 00       	mov    0x805008,%eax
  801b3c:	8b 40 48             	mov    0x48(%eax),%eax
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	53                   	push   %ebx
  801b43:	50                   	push   %eax
  801b44:	68 05 33 80 00       	push   $0x803305
  801b49:	e8 98 e8 ff ff       	call   8003e6 <cprintf>
		return -E_INVAL;
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b56:	eb da                	jmp    801b32 <read+0x5a>
		return -E_NOT_SUPP;
  801b58:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b5d:	eb d3                	jmp    801b32 <read+0x5a>

00801b5f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	57                   	push   %edi
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b6b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b73:	39 f3                	cmp    %esi,%ebx
  801b75:	73 23                	jae    801b9a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	89 f0                	mov    %esi,%eax
  801b7c:	29 d8                	sub    %ebx,%eax
  801b7e:	50                   	push   %eax
  801b7f:	89 d8                	mov    %ebx,%eax
  801b81:	03 45 0c             	add    0xc(%ebp),%eax
  801b84:	50                   	push   %eax
  801b85:	57                   	push   %edi
  801b86:	e8 4d ff ff ff       	call   801ad8 <read>
		if (m < 0)
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 06                	js     801b98 <readn+0x39>
			return m;
		if (m == 0)
  801b92:	74 06                	je     801b9a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b94:	01 c3                	add    %eax,%ebx
  801b96:	eb db                	jmp    801b73 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b98:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b9a:	89 d8                	mov    %ebx,%eax
  801b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb1:	50                   	push   %eax
  801bb2:	53                   	push   %ebx
  801bb3:	e8 b0 fc ff ff       	call   801868 <fd_lookup>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 3a                	js     801bf9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bbf:	83 ec 08             	sub    $0x8,%esp
  801bc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc5:	50                   	push   %eax
  801bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc9:	ff 30                	pushl  (%eax)
  801bcb:	e8 e8 fc ff ff       	call   8018b8 <dev_lookup>
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 22                	js     801bf9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bda:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bde:	74 1e                	je     801bfe <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be3:	8b 52 0c             	mov    0xc(%edx),%edx
  801be6:	85 d2                	test   %edx,%edx
  801be8:	74 35                	je     801c1f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	ff 75 10             	pushl  0x10(%ebp)
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	50                   	push   %eax
  801bf4:	ff d2                	call   *%edx
  801bf6:	83 c4 10             	add    $0x10,%esp
}
  801bf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bfe:	a1 08 50 80 00       	mov    0x805008,%eax
  801c03:	8b 40 48             	mov    0x48(%eax),%eax
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	53                   	push   %ebx
  801c0a:	50                   	push   %eax
  801c0b:	68 21 33 80 00       	push   $0x803321
  801c10:	e8 d1 e7 ff ff       	call   8003e6 <cprintf>
		return -E_INVAL;
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c1d:	eb da                	jmp    801bf9 <write+0x55>
		return -E_NOT_SUPP;
  801c1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c24:	eb d3                	jmp    801bf9 <write+0x55>

00801c26 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2f:	50                   	push   %eax
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	e8 30 fc ff ff       	call   801868 <fd_lookup>
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	78 0e                	js     801c4d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	53                   	push   %ebx
  801c53:	83 ec 1c             	sub    $0x1c,%esp
  801c56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c59:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c5c:	50                   	push   %eax
  801c5d:	53                   	push   %ebx
  801c5e:	e8 05 fc ff ff       	call   801868 <fd_lookup>
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 37                	js     801ca1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c6a:	83 ec 08             	sub    $0x8,%esp
  801c6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c70:	50                   	push   %eax
  801c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c74:	ff 30                	pushl  (%eax)
  801c76:	e8 3d fc ff ff       	call   8018b8 <dev_lookup>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 1f                	js     801ca1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c85:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c89:	74 1b                	je     801ca6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8e:	8b 52 18             	mov    0x18(%edx),%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	74 32                	je     801cc7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	50                   	push   %eax
  801c9c:	ff d2                	call   *%edx
  801c9e:	83 c4 10             	add    $0x10,%esp
}
  801ca1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ca6:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cab:	8b 40 48             	mov    0x48(%eax),%eax
  801cae:	83 ec 04             	sub    $0x4,%esp
  801cb1:	53                   	push   %ebx
  801cb2:	50                   	push   %eax
  801cb3:	68 e4 32 80 00       	push   $0x8032e4
  801cb8:	e8 29 e7 ff ff       	call   8003e6 <cprintf>
		return -E_INVAL;
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc5:	eb da                	jmp    801ca1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801cc7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ccc:	eb d3                	jmp    801ca1 <ftruncate+0x52>

00801cce <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 1c             	sub    $0x1c,%esp
  801cd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cdb:	50                   	push   %eax
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	e8 84 fb ff ff       	call   801868 <fd_lookup>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 4b                	js     801d36 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ceb:	83 ec 08             	sub    $0x8,%esp
  801cee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf1:	50                   	push   %eax
  801cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf5:	ff 30                	pushl  (%eax)
  801cf7:	e8 bc fb ff ff       	call   8018b8 <dev_lookup>
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	85 c0                	test   %eax,%eax
  801d01:	78 33                	js     801d36 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d0a:	74 2f                	je     801d3b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d0c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d0f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d16:	00 00 00 
	stat->st_isdir = 0;
  801d19:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d20:	00 00 00 
	stat->st_dev = dev;
  801d23:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d29:	83 ec 08             	sub    $0x8,%esp
  801d2c:	53                   	push   %ebx
  801d2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d30:	ff 50 14             	call   *0x14(%eax)
  801d33:	83 c4 10             	add    $0x10,%esp
}
  801d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    
		return -E_NOT_SUPP;
  801d3b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d40:	eb f4                	jmp    801d36 <fstat+0x68>

00801d42 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	6a 00                	push   $0x0
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 22 02 00 00       	call   801f76 <open>
  801d54:	89 c3                	mov    %eax,%ebx
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 1b                	js     801d78 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	50                   	push   %eax
  801d64:	e8 65 ff ff ff       	call   801cce <fstat>
  801d69:	89 c6                	mov    %eax,%esi
	close(fd);
  801d6b:	89 1c 24             	mov    %ebx,(%esp)
  801d6e:	e8 27 fc ff ff       	call   80199a <close>
	return r;
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	89 f3                	mov    %esi,%ebx
}
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	89 c6                	mov    %eax,%esi
  801d88:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d8a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d91:	74 27                	je     801dba <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d93:	6a 07                	push   $0x7
  801d95:	68 00 60 80 00       	push   $0x806000
  801d9a:	56                   	push   %esi
  801d9b:	ff 35 00 50 80 00    	pushl  0x805000
  801da1:	e8 b6 f9 ff ff       	call   80175c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801da6:	83 c4 0c             	add    $0xc,%esp
  801da9:	6a 00                	push   $0x0
  801dab:	53                   	push   %ebx
  801dac:	6a 00                	push   $0x0
  801dae:	e8 40 f9 ff ff       	call   8016f3 <ipc_recv>
}
  801db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	6a 01                	push   $0x1
  801dbf:	e8 f0 f9 ff ff       	call   8017b4 <ipc_find_env>
  801dc4:	a3 00 50 80 00       	mov    %eax,0x805000
  801dc9:	83 c4 10             	add    $0x10,%esp
  801dcc:	eb c5                	jmp    801d93 <fsipc+0x12>

00801dce <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dda:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de2:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	b8 02 00 00 00       	mov    $0x2,%eax
  801df1:	e8 8b ff ff ff       	call   801d81 <fsipc>
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <devfile_flush>:
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	8b 40 0c             	mov    0xc(%eax),%eax
  801e04:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e09:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0e:	b8 06 00 00 00       	mov    $0x6,%eax
  801e13:	e8 69 ff ff ff       	call   801d81 <fsipc>
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <devfile_stat>:
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	53                   	push   %ebx
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e34:	b8 05 00 00 00       	mov    $0x5,%eax
  801e39:	e8 43 ff ff ff       	call   801d81 <fsipc>
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	78 2c                	js     801e6e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e42:	83 ec 08             	sub    $0x8,%esp
  801e45:	68 00 60 80 00       	push   $0x806000
  801e4a:	53                   	push   %ebx
  801e4b:	e8 f5 ec ff ff       	call   800b45 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e50:	a1 80 60 80 00       	mov    0x806080,%eax
  801e55:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e5b:	a1 84 60 80 00       	mov    0x806084,%eax
  801e60:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <devfile_write>:
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	53                   	push   %ebx
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	8b 40 0c             	mov    0xc(%eax),%eax
  801e83:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e88:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e8e:	53                   	push   %ebx
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	68 08 60 80 00       	push   $0x806008
  801e97:	e8 99 ee ff ff       	call   800d35 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea1:	b8 04 00 00 00       	mov    $0x4,%eax
  801ea6:	e8 d6 fe ff ff       	call   801d81 <fsipc>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 0b                	js     801ebd <devfile_write+0x4a>
	assert(r <= n);
  801eb2:	39 d8                	cmp    %ebx,%eax
  801eb4:	77 0c                	ja     801ec2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801eb6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ebb:	7f 1e                	jg     801edb <devfile_write+0x68>
}
  801ebd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    
	assert(r <= n);
  801ec2:	68 54 33 80 00       	push   $0x803354
  801ec7:	68 5b 33 80 00       	push   $0x80335b
  801ecc:	68 98 00 00 00       	push   $0x98
  801ed1:	68 70 33 80 00       	push   $0x803370
  801ed6:	e8 15 e4 ff ff       	call   8002f0 <_panic>
	assert(r <= PGSIZE);
  801edb:	68 7b 33 80 00       	push   $0x80337b
  801ee0:	68 5b 33 80 00       	push   $0x80335b
  801ee5:	68 99 00 00 00       	push   $0x99
  801eea:	68 70 33 80 00       	push   $0x803370
  801eef:	e8 fc e3 ff ff       	call   8002f0 <_panic>

00801ef4 <devfile_read>:
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	8b 40 0c             	mov    0xc(%eax),%eax
  801f02:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f07:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f12:	b8 03 00 00 00       	mov    $0x3,%eax
  801f17:	e8 65 fe ff ff       	call   801d81 <fsipc>
  801f1c:	89 c3                	mov    %eax,%ebx
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 1f                	js     801f41 <devfile_read+0x4d>
	assert(r <= n);
  801f22:	39 f0                	cmp    %esi,%eax
  801f24:	77 24                	ja     801f4a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f26:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f2b:	7f 33                	jg     801f60 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	50                   	push   %eax
  801f31:	68 00 60 80 00       	push   $0x806000
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	e8 95 ed ff ff       	call   800cd3 <memmove>
	return r;
  801f3e:	83 c4 10             	add    $0x10,%esp
}
  801f41:	89 d8                	mov    %ebx,%eax
  801f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5e                   	pop    %esi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
	assert(r <= n);
  801f4a:	68 54 33 80 00       	push   $0x803354
  801f4f:	68 5b 33 80 00       	push   $0x80335b
  801f54:	6a 7c                	push   $0x7c
  801f56:	68 70 33 80 00       	push   $0x803370
  801f5b:	e8 90 e3 ff ff       	call   8002f0 <_panic>
	assert(r <= PGSIZE);
  801f60:	68 7b 33 80 00       	push   $0x80337b
  801f65:	68 5b 33 80 00       	push   $0x80335b
  801f6a:	6a 7d                	push   $0x7d
  801f6c:	68 70 33 80 00       	push   $0x803370
  801f71:	e8 7a e3 ff ff       	call   8002f0 <_panic>

00801f76 <open>:
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	83 ec 1c             	sub    $0x1c,%esp
  801f7e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f81:	56                   	push   %esi
  801f82:	e8 85 eb ff ff       	call   800b0c <strlen>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f8f:	7f 6c                	jg     801ffd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f97:	50                   	push   %eax
  801f98:	e8 79 f8 ff ff       	call   801816 <fd_alloc>
  801f9d:	89 c3                	mov    %eax,%ebx
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 3c                	js     801fe2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	56                   	push   %esi
  801faa:	68 00 60 80 00       	push   $0x806000
  801faf:	e8 91 eb ff ff       	call   800b45 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb7:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc4:	e8 b8 fd ff ff       	call   801d81 <fsipc>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	78 19                	js     801feb <open+0x75>
	return fd2num(fd);
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd8:	e8 12 f8 ff ff       	call   8017ef <fd2num>
  801fdd:	89 c3                	mov    %eax,%ebx
  801fdf:	83 c4 10             	add    $0x10,%esp
}
  801fe2:	89 d8                	mov    %ebx,%eax
  801fe4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe7:	5b                   	pop    %ebx
  801fe8:	5e                   	pop    %esi
  801fe9:	5d                   	pop    %ebp
  801fea:	c3                   	ret    
		fd_close(fd, 0);
  801feb:	83 ec 08             	sub    $0x8,%esp
  801fee:	6a 00                	push   $0x0
  801ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff3:	e8 1b f9 ff ff       	call   801913 <fd_close>
		return r;
  801ff8:	83 c4 10             	add    $0x10,%esp
  801ffb:	eb e5                	jmp    801fe2 <open+0x6c>
		return -E_BAD_PATH;
  801ffd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802002:	eb de                	jmp    801fe2 <open+0x6c>

00802004 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80200a:	ba 00 00 00 00       	mov    $0x0,%edx
  80200f:	b8 08 00 00 00       	mov    $0x8,%eax
  802014:	e8 68 fd ff ff       	call   801d81 <fsipc>
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802021:	89 d0                	mov    %edx,%eax
  802023:	c1 e8 16             	shr    $0x16,%eax
  802026:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802032:	f6 c1 01             	test   $0x1,%cl
  802035:	74 1d                	je     802054 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802037:	c1 ea 0c             	shr    $0xc,%edx
  80203a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802041:	f6 c2 01             	test   $0x1,%dl
  802044:	74 0e                	je     802054 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802046:	c1 ea 0c             	shr    $0xc,%edx
  802049:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802050:	ef 
  802051:	0f b7 c0             	movzwl %ax,%eax
}
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    

00802056 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80205c:	68 87 33 80 00       	push   $0x803387
  802061:	ff 75 0c             	pushl  0xc(%ebp)
  802064:	e8 dc ea ff ff       	call   800b45 <strcpy>
	return 0;
}
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <devsock_close>:
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	53                   	push   %ebx
  802074:	83 ec 10             	sub    $0x10,%esp
  802077:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80207a:	53                   	push   %ebx
  80207b:	e8 9b ff ff ff       	call   80201b <pageref>
  802080:	83 c4 10             	add    $0x10,%esp
		return 0;
  802083:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802088:	83 f8 01             	cmp    $0x1,%eax
  80208b:	74 07                	je     802094 <devsock_close+0x24>
}
  80208d:	89 d0                	mov    %edx,%eax
  80208f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802092:	c9                   	leave  
  802093:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	ff 73 0c             	pushl  0xc(%ebx)
  80209a:	e8 b9 02 00 00       	call   802358 <nsipc_close>
  80209f:	89 c2                	mov    %eax,%edx
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	eb e7                	jmp    80208d <devsock_close+0x1d>

008020a6 <devsock_write>:
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	ff 75 10             	pushl  0x10(%ebp)
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	ff 70 0c             	pushl  0xc(%eax)
  8020ba:	e8 76 03 00 00       	call   802435 <nsipc_send>
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <devsock_read>:
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	ff 75 10             	pushl  0x10(%ebp)
  8020cc:	ff 75 0c             	pushl  0xc(%ebp)
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	ff 70 0c             	pushl  0xc(%eax)
  8020d5:	e8 ef 02 00 00       	call   8023c9 <nsipc_recv>
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <fd2sockid>:
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020e5:	52                   	push   %edx
  8020e6:	50                   	push   %eax
  8020e7:	e8 7c f7 ff ff       	call   801868 <fd_lookup>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 10                	js     802103 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020fc:	39 08                	cmp    %ecx,(%eax)
  8020fe:	75 05                	jne    802105 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802100:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    
		return -E_NOT_SUPP;
  802105:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80210a:	eb f7                	jmp    802103 <fd2sockid+0x27>

0080210c <alloc_sockfd>:
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	56                   	push   %esi
  802110:	53                   	push   %ebx
  802111:	83 ec 1c             	sub    $0x1c,%esp
  802114:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802116:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802119:	50                   	push   %eax
  80211a:	e8 f7 f6 ff ff       	call   801816 <fd_alloc>
  80211f:	89 c3                	mov    %eax,%ebx
  802121:	83 c4 10             	add    $0x10,%esp
  802124:	85 c0                	test   %eax,%eax
  802126:	78 43                	js     80216b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	68 07 04 00 00       	push   $0x407
  802130:	ff 75 f4             	pushl  -0xc(%ebp)
  802133:	6a 00                	push   $0x0
  802135:	e8 fd ed ff ff       	call   800f37 <sys_page_alloc>
  80213a:	89 c3                	mov    %eax,%ebx
  80213c:	83 c4 10             	add    $0x10,%esp
  80213f:	85 c0                	test   %eax,%eax
  802141:	78 28                	js     80216b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80214c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802158:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	50                   	push   %eax
  80215f:	e8 8b f6 ff ff       	call   8017ef <fd2num>
  802164:	89 c3                	mov    %eax,%ebx
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	eb 0c                	jmp    802177 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80216b:	83 ec 0c             	sub    $0xc,%esp
  80216e:	56                   	push   %esi
  80216f:	e8 e4 01 00 00       	call   802358 <nsipc_close>
		return r;
  802174:	83 c4 10             	add    $0x10,%esp
}
  802177:	89 d8                	mov    %ebx,%eax
  802179:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5d                   	pop    %ebp
  80217f:	c3                   	ret    

00802180 <accept>:
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	e8 4e ff ff ff       	call   8020dc <fd2sockid>
  80218e:	85 c0                	test   %eax,%eax
  802190:	78 1b                	js     8021ad <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	ff 75 10             	pushl  0x10(%ebp)
  802198:	ff 75 0c             	pushl  0xc(%ebp)
  80219b:	50                   	push   %eax
  80219c:	e8 0e 01 00 00       	call   8022af <nsipc_accept>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 05                	js     8021ad <accept+0x2d>
	return alloc_sockfd(r);
  8021a8:	e8 5f ff ff ff       	call   80210c <alloc_sockfd>
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <bind>:
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	e8 1f ff ff ff       	call   8020dc <fd2sockid>
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	78 12                	js     8021d3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	ff 75 10             	pushl  0x10(%ebp)
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	50                   	push   %eax
  8021cb:	e8 31 01 00 00       	call   802301 <nsipc_bind>
  8021d0:	83 c4 10             	add    $0x10,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <shutdown>:
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	e8 f9 fe ff ff       	call   8020dc <fd2sockid>
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 0f                	js     8021f6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021e7:	83 ec 08             	sub    $0x8,%esp
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	50                   	push   %eax
  8021ee:	e8 43 01 00 00       	call   802336 <nsipc_shutdown>
  8021f3:	83 c4 10             	add    $0x10,%esp
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <connect>:
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	e8 d6 fe ff ff       	call   8020dc <fd2sockid>
  802206:	85 c0                	test   %eax,%eax
  802208:	78 12                	js     80221c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	ff 75 10             	pushl  0x10(%ebp)
  802210:	ff 75 0c             	pushl  0xc(%ebp)
  802213:	50                   	push   %eax
  802214:	e8 59 01 00 00       	call   802372 <nsipc_connect>
  802219:	83 c4 10             	add    $0x10,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <listen>:
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	e8 b0 fe ff ff       	call   8020dc <fd2sockid>
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 0f                	js     80223f <listen+0x21>
	return nsipc_listen(r, backlog);
  802230:	83 ec 08             	sub    $0x8,%esp
  802233:	ff 75 0c             	pushl  0xc(%ebp)
  802236:	50                   	push   %eax
  802237:	e8 6b 01 00 00       	call   8023a7 <nsipc_listen>
  80223c:	83 c4 10             	add    $0x10,%esp
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <socket>:

int
socket(int domain, int type, int protocol)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802247:	ff 75 10             	pushl  0x10(%ebp)
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	ff 75 08             	pushl  0x8(%ebp)
  802250:	e8 3e 02 00 00       	call   802493 <nsipc_socket>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 05                	js     802261 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80225c:	e8 ab fe ff ff       	call   80210c <alloc_sockfd>
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	53                   	push   %ebx
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80226c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802273:	74 26                	je     80229b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802275:	6a 07                	push   $0x7
  802277:	68 00 70 80 00       	push   $0x807000
  80227c:	53                   	push   %ebx
  80227d:	ff 35 04 50 80 00    	pushl  0x805004
  802283:	e8 d4 f4 ff ff       	call   80175c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802288:	83 c4 0c             	add    $0xc,%esp
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	e8 5d f4 ff ff       	call   8016f3 <ipc_recv>
}
  802296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802299:	c9                   	leave  
  80229a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	6a 02                	push   $0x2
  8022a0:	e8 0f f5 ff ff       	call   8017b4 <ipc_find_env>
  8022a5:	a3 04 50 80 00       	mov    %eax,0x805004
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	eb c6                	jmp    802275 <nsipc+0x12>

008022af <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8022bf:	8b 06                	mov    (%esi),%eax
  8022c1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	e8 93 ff ff ff       	call   802263 <nsipc>
  8022d0:	89 c3                	mov    %eax,%ebx
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	79 09                	jns    8022df <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022d6:	89 d8                	mov    %ebx,%eax
  8022d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5e                   	pop    %esi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	ff 35 10 70 80 00    	pushl  0x807010
  8022e8:	68 00 70 80 00       	push   $0x807000
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	e8 de e9 ff ff       	call   800cd3 <memmove>
		*addrlen = ret->ret_addrlen;
  8022f5:	a1 10 70 80 00       	mov    0x807010,%eax
  8022fa:	89 06                	mov    %eax,(%esi)
  8022fc:	83 c4 10             	add    $0x10,%esp
	return r;
  8022ff:	eb d5                	jmp    8022d6 <nsipc_accept+0x27>

00802301 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	53                   	push   %ebx
  802305:	83 ec 08             	sub    $0x8,%esp
  802308:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802313:	53                   	push   %ebx
  802314:	ff 75 0c             	pushl  0xc(%ebp)
  802317:	68 04 70 80 00       	push   $0x807004
  80231c:	e8 b2 e9 ff ff       	call   800cd3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802321:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802327:	b8 02 00 00 00       	mov    $0x2,%eax
  80232c:	e8 32 ff ff ff       	call   802263 <nsipc>
}
  802331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802344:	8b 45 0c             	mov    0xc(%ebp),%eax
  802347:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80234c:	b8 03 00 00 00       	mov    $0x3,%eax
  802351:	e8 0d ff ff ff       	call   802263 <nsipc>
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <nsipc_close>:

int
nsipc_close(int s)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802366:	b8 04 00 00 00       	mov    $0x4,%eax
  80236b:	e8 f3 fe ff ff       	call   802263 <nsipc>
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	53                   	push   %ebx
  802376:	83 ec 08             	sub    $0x8,%esp
  802379:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802384:	53                   	push   %ebx
  802385:	ff 75 0c             	pushl  0xc(%ebp)
  802388:	68 04 70 80 00       	push   $0x807004
  80238d:	e8 41 e9 ff ff       	call   800cd3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802392:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802398:	b8 05 00 00 00       	mov    $0x5,%eax
  80239d:	e8 c1 fe ff ff       	call   802263 <nsipc>
}
  8023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023bd:	b8 06 00 00 00       	mov    $0x6,%eax
  8023c2:	e8 9c fe ff ff       	call   802263 <nsipc>
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	56                   	push   %esi
  8023cd:	53                   	push   %ebx
  8023ce:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023d9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023df:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023e7:	b8 07 00 00 00       	mov    $0x7,%eax
  8023ec:	e8 72 fe ff ff       	call   802263 <nsipc>
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	78 1f                	js     802416 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023f7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023fc:	7f 21                	jg     80241f <nsipc_recv+0x56>
  8023fe:	39 c6                	cmp    %eax,%esi
  802400:	7c 1d                	jl     80241f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	50                   	push   %eax
  802406:	68 00 70 80 00       	push   $0x807000
  80240b:	ff 75 0c             	pushl  0xc(%ebp)
  80240e:	e8 c0 e8 ff ff       	call   800cd3 <memmove>
  802413:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802416:	89 d8                	mov    %ebx,%eax
  802418:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5d                   	pop    %ebp
  80241e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80241f:	68 93 33 80 00       	push   $0x803393
  802424:	68 5b 33 80 00       	push   $0x80335b
  802429:	6a 62                	push   $0x62
  80242b:	68 a8 33 80 00       	push   $0x8033a8
  802430:	e8 bb de ff ff       	call   8002f0 <_panic>

00802435 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	53                   	push   %ebx
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802447:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80244d:	7f 2e                	jg     80247d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	53                   	push   %ebx
  802453:	ff 75 0c             	pushl  0xc(%ebp)
  802456:	68 0c 70 80 00       	push   $0x80700c
  80245b:	e8 73 e8 ff ff       	call   800cd3 <memmove>
	nsipcbuf.send.req_size = size;
  802460:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802466:	8b 45 14             	mov    0x14(%ebp),%eax
  802469:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80246e:	b8 08 00 00 00       	mov    $0x8,%eax
  802473:	e8 eb fd ff ff       	call   802263 <nsipc>
}
  802478:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    
	assert(size < 1600);
  80247d:	68 b4 33 80 00       	push   $0x8033b4
  802482:	68 5b 33 80 00       	push   $0x80335b
  802487:	6a 6d                	push   $0x6d
  802489:	68 a8 33 80 00       	push   $0x8033a8
  80248e:	e8 5d de ff ff       	call   8002f0 <_panic>

00802493 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a4:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ac:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024b1:	b8 09 00 00 00       	mov    $0x9,%eax
  8024b6:	e8 a8 fd ff ff       	call   802263 <nsipc>
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
  8024c0:	56                   	push   %esi
  8024c1:	53                   	push   %ebx
  8024c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024c5:	83 ec 0c             	sub    $0xc,%esp
  8024c8:	ff 75 08             	pushl  0x8(%ebp)
  8024cb:	e8 2f f3 ff ff       	call   8017ff <fd2data>
  8024d0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024d2:	83 c4 08             	add    $0x8,%esp
  8024d5:	68 c0 33 80 00       	push   $0x8033c0
  8024da:	53                   	push   %ebx
  8024db:	e8 65 e6 ff ff       	call   800b45 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024e0:	8b 46 04             	mov    0x4(%esi),%eax
  8024e3:	2b 06                	sub    (%esi),%eax
  8024e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024f2:	00 00 00 
	stat->st_dev = &devpipe;
  8024f5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024fc:	40 80 00 
	return 0;
}
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802507:	5b                   	pop    %ebx
  802508:	5e                   	pop    %esi
  802509:	5d                   	pop    %ebp
  80250a:	c3                   	ret    

0080250b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	53                   	push   %ebx
  80250f:	83 ec 0c             	sub    $0xc,%esp
  802512:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802515:	53                   	push   %ebx
  802516:	6a 00                	push   $0x0
  802518:	e8 9f ea ff ff       	call   800fbc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80251d:	89 1c 24             	mov    %ebx,(%esp)
  802520:	e8 da f2 ff ff       	call   8017ff <fd2data>
  802525:	83 c4 08             	add    $0x8,%esp
  802528:	50                   	push   %eax
  802529:	6a 00                	push   $0x0
  80252b:	e8 8c ea ff ff       	call   800fbc <sys_page_unmap>
}
  802530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <_pipeisclosed>:
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	57                   	push   %edi
  802539:	56                   	push   %esi
  80253a:	53                   	push   %ebx
  80253b:	83 ec 1c             	sub    $0x1c,%esp
  80253e:	89 c7                	mov    %eax,%edi
  802540:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802542:	a1 08 50 80 00       	mov    0x805008,%eax
  802547:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80254a:	83 ec 0c             	sub    $0xc,%esp
  80254d:	57                   	push   %edi
  80254e:	e8 c8 fa ff ff       	call   80201b <pageref>
  802553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802556:	89 34 24             	mov    %esi,(%esp)
  802559:	e8 bd fa ff ff       	call   80201b <pageref>
		nn = thisenv->env_runs;
  80255e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802564:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	39 cb                	cmp    %ecx,%ebx
  80256c:	74 1b                	je     802589 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80256e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802571:	75 cf                	jne    802542 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802573:	8b 42 58             	mov    0x58(%edx),%eax
  802576:	6a 01                	push   $0x1
  802578:	50                   	push   %eax
  802579:	53                   	push   %ebx
  80257a:	68 c7 33 80 00       	push   $0x8033c7
  80257f:	e8 62 de ff ff       	call   8003e6 <cprintf>
  802584:	83 c4 10             	add    $0x10,%esp
  802587:	eb b9                	jmp    802542 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802589:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80258c:	0f 94 c0             	sete   %al
  80258f:	0f b6 c0             	movzbl %al,%eax
}
  802592:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802595:	5b                   	pop    %ebx
  802596:	5e                   	pop    %esi
  802597:	5f                   	pop    %edi
  802598:	5d                   	pop    %ebp
  802599:	c3                   	ret    

0080259a <devpipe_write>:
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	57                   	push   %edi
  80259e:	56                   	push   %esi
  80259f:	53                   	push   %ebx
  8025a0:	83 ec 28             	sub    $0x28,%esp
  8025a3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025a6:	56                   	push   %esi
  8025a7:	e8 53 f2 ff ff       	call   8017ff <fd2data>
  8025ac:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025b9:	74 4f                	je     80260a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8025be:	8b 0b                	mov    (%ebx),%ecx
  8025c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8025c3:	39 d0                	cmp    %edx,%eax
  8025c5:	72 14                	jb     8025db <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8025c7:	89 da                	mov    %ebx,%edx
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	e8 65 ff ff ff       	call   802535 <_pipeisclosed>
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	75 3b                	jne    80260f <devpipe_write+0x75>
			sys_yield();
  8025d4:	e8 3f e9 ff ff       	call   800f18 <sys_yield>
  8025d9:	eb e0                	jmp    8025bb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025de:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025e2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025e5:	89 c2                	mov    %eax,%edx
  8025e7:	c1 fa 1f             	sar    $0x1f,%edx
  8025ea:	89 d1                	mov    %edx,%ecx
  8025ec:	c1 e9 1b             	shr    $0x1b,%ecx
  8025ef:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025f2:	83 e2 1f             	and    $0x1f,%edx
  8025f5:	29 ca                	sub    %ecx,%edx
  8025f7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025fb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025ff:	83 c0 01             	add    $0x1,%eax
  802602:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802605:	83 c7 01             	add    $0x1,%edi
  802608:	eb ac                	jmp    8025b6 <devpipe_write+0x1c>
	return i;
  80260a:	8b 45 10             	mov    0x10(%ebp),%eax
  80260d:	eb 05                	jmp    802614 <devpipe_write+0x7a>
				return 0;
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802614:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802617:	5b                   	pop    %ebx
  802618:	5e                   	pop    %esi
  802619:	5f                   	pop    %edi
  80261a:	5d                   	pop    %ebp
  80261b:	c3                   	ret    

0080261c <devpipe_read>:
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	57                   	push   %edi
  802620:	56                   	push   %esi
  802621:	53                   	push   %ebx
  802622:	83 ec 18             	sub    $0x18,%esp
  802625:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802628:	57                   	push   %edi
  802629:	e8 d1 f1 ff ff       	call   8017ff <fd2data>
  80262e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802630:	83 c4 10             	add    $0x10,%esp
  802633:	be 00 00 00 00       	mov    $0x0,%esi
  802638:	3b 75 10             	cmp    0x10(%ebp),%esi
  80263b:	75 14                	jne    802651 <devpipe_read+0x35>
	return i;
  80263d:	8b 45 10             	mov    0x10(%ebp),%eax
  802640:	eb 02                	jmp    802644 <devpipe_read+0x28>
				return i;
  802642:	89 f0                	mov    %esi,%eax
}
  802644:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5f                   	pop    %edi
  80264a:	5d                   	pop    %ebp
  80264b:	c3                   	ret    
			sys_yield();
  80264c:	e8 c7 e8 ff ff       	call   800f18 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802651:	8b 03                	mov    (%ebx),%eax
  802653:	3b 43 04             	cmp    0x4(%ebx),%eax
  802656:	75 18                	jne    802670 <devpipe_read+0x54>
			if (i > 0)
  802658:	85 f6                	test   %esi,%esi
  80265a:	75 e6                	jne    802642 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80265c:	89 da                	mov    %ebx,%edx
  80265e:	89 f8                	mov    %edi,%eax
  802660:	e8 d0 fe ff ff       	call   802535 <_pipeisclosed>
  802665:	85 c0                	test   %eax,%eax
  802667:	74 e3                	je     80264c <devpipe_read+0x30>
				return 0;
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	eb d4                	jmp    802644 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802670:	99                   	cltd   
  802671:	c1 ea 1b             	shr    $0x1b,%edx
  802674:	01 d0                	add    %edx,%eax
  802676:	83 e0 1f             	and    $0x1f,%eax
  802679:	29 d0                	sub    %edx,%eax
  80267b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802683:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802686:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802689:	83 c6 01             	add    $0x1,%esi
  80268c:	eb aa                	jmp    802638 <devpipe_read+0x1c>

0080268e <pipe>:
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	56                   	push   %esi
  802692:	53                   	push   %ebx
  802693:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802699:	50                   	push   %eax
  80269a:	e8 77 f1 ff ff       	call   801816 <fd_alloc>
  80269f:	89 c3                	mov    %eax,%ebx
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	0f 88 23 01 00 00    	js     8027cf <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 07 04 00 00       	push   $0x407
  8026b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b7:	6a 00                	push   $0x0
  8026b9:	e8 79 e8 ff ff       	call   800f37 <sys_page_alloc>
  8026be:	89 c3                	mov    %eax,%ebx
  8026c0:	83 c4 10             	add    $0x10,%esp
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	0f 88 04 01 00 00    	js     8027cf <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026d1:	50                   	push   %eax
  8026d2:	e8 3f f1 ff ff       	call   801816 <fd_alloc>
  8026d7:	89 c3                	mov    %eax,%ebx
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	0f 88 db 00 00 00    	js     8027bf <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 07 04 00 00       	push   $0x407
  8026ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ef:	6a 00                	push   $0x0
  8026f1:	e8 41 e8 ff ff       	call   800f37 <sys_page_alloc>
  8026f6:	89 c3                	mov    %eax,%ebx
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	0f 88 bc 00 00 00    	js     8027bf <pipe+0x131>
	va = fd2data(fd0);
  802703:	83 ec 0c             	sub    $0xc,%esp
  802706:	ff 75 f4             	pushl  -0xc(%ebp)
  802709:	e8 f1 f0 ff ff       	call   8017ff <fd2data>
  80270e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802710:	83 c4 0c             	add    $0xc,%esp
  802713:	68 07 04 00 00       	push   $0x407
  802718:	50                   	push   %eax
  802719:	6a 00                	push   $0x0
  80271b:	e8 17 e8 ff ff       	call   800f37 <sys_page_alloc>
  802720:	89 c3                	mov    %eax,%ebx
  802722:	83 c4 10             	add    $0x10,%esp
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 88 82 00 00 00    	js     8027af <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272d:	83 ec 0c             	sub    $0xc,%esp
  802730:	ff 75 f0             	pushl  -0x10(%ebp)
  802733:	e8 c7 f0 ff ff       	call   8017ff <fd2data>
  802738:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80273f:	50                   	push   %eax
  802740:	6a 00                	push   $0x0
  802742:	56                   	push   %esi
  802743:	6a 00                	push   $0x0
  802745:	e8 30 e8 ff ff       	call   800f7a <sys_page_map>
  80274a:	89 c3                	mov    %eax,%ebx
  80274c:	83 c4 20             	add    $0x20,%esp
  80274f:	85 c0                	test   %eax,%eax
  802751:	78 4e                	js     8027a1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802753:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80275d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802760:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802767:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80276a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802776:	83 ec 0c             	sub    $0xc,%esp
  802779:	ff 75 f4             	pushl  -0xc(%ebp)
  80277c:	e8 6e f0 ff ff       	call   8017ef <fd2num>
  802781:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802784:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802786:	83 c4 04             	add    $0x4,%esp
  802789:	ff 75 f0             	pushl  -0x10(%ebp)
  80278c:	e8 5e f0 ff ff       	call   8017ef <fd2num>
  802791:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802794:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802797:	83 c4 10             	add    $0x10,%esp
  80279a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80279f:	eb 2e                	jmp    8027cf <pipe+0x141>
	sys_page_unmap(0, va);
  8027a1:	83 ec 08             	sub    $0x8,%esp
  8027a4:	56                   	push   %esi
  8027a5:	6a 00                	push   $0x0
  8027a7:	e8 10 e8 ff ff       	call   800fbc <sys_page_unmap>
  8027ac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027af:	83 ec 08             	sub    $0x8,%esp
  8027b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8027b5:	6a 00                	push   $0x0
  8027b7:	e8 00 e8 ff ff       	call   800fbc <sys_page_unmap>
  8027bc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8027bf:	83 ec 08             	sub    $0x8,%esp
  8027c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c5:	6a 00                	push   $0x0
  8027c7:	e8 f0 e7 ff ff       	call   800fbc <sys_page_unmap>
  8027cc:	83 c4 10             	add    $0x10,%esp
}
  8027cf:	89 d8                	mov    %ebx,%eax
  8027d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    

008027d8 <pipeisclosed>:
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e1:	50                   	push   %eax
  8027e2:	ff 75 08             	pushl  0x8(%ebp)
  8027e5:	e8 7e f0 ff ff       	call   801868 <fd_lookup>
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	78 18                	js     802809 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027f1:	83 ec 0c             	sub    $0xc,%esp
  8027f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8027f7:	e8 03 f0 ff ff       	call   8017ff <fd2data>
	return _pipeisclosed(fd, p);
  8027fc:	89 c2                	mov    %eax,%edx
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	e8 2f fd ff ff       	call   802535 <_pipeisclosed>
  802806:	83 c4 10             	add    $0x10,%esp
}
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
  802810:	c3                   	ret    

00802811 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802817:	68 df 33 80 00       	push   $0x8033df
  80281c:	ff 75 0c             	pushl  0xc(%ebp)
  80281f:	e8 21 e3 ff ff       	call   800b45 <strcpy>
	return 0;
}
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <devcons_write>:
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	57                   	push   %edi
  80282f:	56                   	push   %esi
  802830:	53                   	push   %ebx
  802831:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802837:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80283c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802842:	3b 75 10             	cmp    0x10(%ebp),%esi
  802845:	73 31                	jae    802878 <devcons_write+0x4d>
		m = n - tot;
  802847:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80284a:	29 f3                	sub    %esi,%ebx
  80284c:	83 fb 7f             	cmp    $0x7f,%ebx
  80284f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802854:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	53                   	push   %ebx
  80285b:	89 f0                	mov    %esi,%eax
  80285d:	03 45 0c             	add    0xc(%ebp),%eax
  802860:	50                   	push   %eax
  802861:	57                   	push   %edi
  802862:	e8 6c e4 ff ff       	call   800cd3 <memmove>
		sys_cputs(buf, m);
  802867:	83 c4 08             	add    $0x8,%esp
  80286a:	53                   	push   %ebx
  80286b:	57                   	push   %edi
  80286c:	e8 0a e6 ff ff       	call   800e7b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802871:	01 de                	add    %ebx,%esi
  802873:	83 c4 10             	add    $0x10,%esp
  802876:	eb ca                	jmp    802842 <devcons_write+0x17>
}
  802878:	89 f0                	mov    %esi,%eax
  80287a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80287d:	5b                   	pop    %ebx
  80287e:	5e                   	pop    %esi
  80287f:	5f                   	pop    %edi
  802880:	5d                   	pop    %ebp
  802881:	c3                   	ret    

00802882 <devcons_read>:
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
  802885:	83 ec 08             	sub    $0x8,%esp
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80288d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802891:	74 21                	je     8028b4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802893:	e8 01 e6 ff ff       	call   800e99 <sys_cgetc>
  802898:	85 c0                	test   %eax,%eax
  80289a:	75 07                	jne    8028a3 <devcons_read+0x21>
		sys_yield();
  80289c:	e8 77 e6 ff ff       	call   800f18 <sys_yield>
  8028a1:	eb f0                	jmp    802893 <devcons_read+0x11>
	if (c < 0)
  8028a3:	78 0f                	js     8028b4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028a5:	83 f8 04             	cmp    $0x4,%eax
  8028a8:	74 0c                	je     8028b6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8028aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ad:	88 02                	mov    %al,(%edx)
	return 1;
  8028af:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    
		return 0;
  8028b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bb:	eb f7                	jmp    8028b4 <devcons_read+0x32>

008028bd <cputchar>:
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
  8028c0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028c9:	6a 01                	push   $0x1
  8028cb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028ce:	50                   	push   %eax
  8028cf:	e8 a7 e5 ff ff       	call   800e7b <sys_cputs>
}
  8028d4:	83 c4 10             	add    $0x10,%esp
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <getchar>:
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028df:	6a 01                	push   $0x1
  8028e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028e4:	50                   	push   %eax
  8028e5:	6a 00                	push   $0x0
  8028e7:	e8 ec f1 ff ff       	call   801ad8 <read>
	if (r < 0)
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 06                	js     8028f9 <getchar+0x20>
	if (r < 1)
  8028f3:	74 06                	je     8028fb <getchar+0x22>
	return c;
  8028f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    
		return -E_EOF;
  8028fb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802900:	eb f7                	jmp    8028f9 <getchar+0x20>

00802902 <iscons>:
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802908:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80290b:	50                   	push   %eax
  80290c:	ff 75 08             	pushl  0x8(%ebp)
  80290f:	e8 54 ef ff ff       	call   801868 <fd_lookup>
  802914:	83 c4 10             	add    $0x10,%esp
  802917:	85 c0                	test   %eax,%eax
  802919:	78 11                	js     80292c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802924:	39 10                	cmp    %edx,(%eax)
  802926:	0f 94 c0             	sete   %al
  802929:	0f b6 c0             	movzbl %al,%eax
}
  80292c:	c9                   	leave  
  80292d:	c3                   	ret    

0080292e <opencons>:
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
  802931:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802937:	50                   	push   %eax
  802938:	e8 d9 ee ff ff       	call   801816 <fd_alloc>
  80293d:	83 c4 10             	add    $0x10,%esp
  802940:	85 c0                	test   %eax,%eax
  802942:	78 3a                	js     80297e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802944:	83 ec 04             	sub    $0x4,%esp
  802947:	68 07 04 00 00       	push   $0x407
  80294c:	ff 75 f4             	pushl  -0xc(%ebp)
  80294f:	6a 00                	push   $0x0
  802951:	e8 e1 e5 ff ff       	call   800f37 <sys_page_alloc>
  802956:	83 c4 10             	add    $0x10,%esp
  802959:	85 c0                	test   %eax,%eax
  80295b:	78 21                	js     80297e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802966:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802972:	83 ec 0c             	sub    $0xc,%esp
  802975:	50                   	push   %eax
  802976:	e8 74 ee ff ff       	call   8017ef <fd2num>
  80297b:	83 c4 10             	add    $0x10,%esp
}
  80297e:	c9                   	leave  
  80297f:	c3                   	ret    

00802980 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802980:	55                   	push   %ebp
  802981:	89 e5                	mov    %esp,%ebp
  802983:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802986:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80298d:	74 0a                	je     802999 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802997:	c9                   	leave  
  802998:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	6a 07                	push   $0x7
  80299e:	68 00 f0 bf ee       	push   $0xeebff000
  8029a3:	6a 00                	push   $0x0
  8029a5:	e8 8d e5 ff ff       	call   800f37 <sys_page_alloc>
		if(r < 0)
  8029aa:	83 c4 10             	add    $0x10,%esp
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	78 2a                	js     8029db <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029b1:	83 ec 08             	sub    $0x8,%esp
  8029b4:	68 ef 29 80 00       	push   $0x8029ef
  8029b9:	6a 00                	push   $0x0
  8029bb:	e8 c2 e6 ff ff       	call   801082 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	79 c8                	jns    80298f <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 1c 34 80 00       	push   $0x80341c
  8029cf:	6a 25                	push   $0x25
  8029d1:	68 58 34 80 00       	push   $0x803458
  8029d6:	e8 15 d9 ff ff       	call   8002f0 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	68 ec 33 80 00       	push   $0x8033ec
  8029e3:	6a 22                	push   $0x22
  8029e5:	68 58 34 80 00       	push   $0x803458
  8029ea:	e8 01 d9 ff ff       	call   8002f0 <_panic>

008029ef <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029ef:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029f0:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029f5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029f7:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029fa:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029fe:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a02:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a05:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a07:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a0b:	83 c4 08             	add    $0x8,%esp
	popal
  802a0e:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a0f:	83 c4 04             	add    $0x4,%esp
	popfl
  802a12:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a13:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a14:	c3                   	ret    
  802a15:	66 90                	xchg   %ax,%ax
  802a17:	66 90                	xchg   %ax,%ax
  802a19:	66 90                	xchg   %ax,%ax
  802a1b:	66 90                	xchg   %ax,%ax
  802a1d:	66 90                	xchg   %ax,%ax
  802a1f:	90                   	nop

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
