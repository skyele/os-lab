
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
  80002c:	e8 d0 01 00 00       	call   800201 <libmain>
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
  80003b:	68 c0 2c 80 00       	push   $0x802cc0
  800040:	e8 c1 03 00 00       	call   800406 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 88 26 00 00       	call   8026d8 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 80 00 00 00    	js     8000db <umain+0xa8>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 41 14 00 00       	call   8014a1 <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 83 00 00 00    	js     8000ed <umain+0xba>
		panic("fork: %e", r);
	if (r == 0) {
  80006a:	0f 84 8f 00 00 00    	je     8000ff <umain+0xcc>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800070:	83 ec 08             	sub    $0x8,%esp
  800073:	56                   	push   %esi
  800074:	68 1a 2d 80 00       	push   $0x802d1a
  800079:	e8 88 03 00 00       	call   800406 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  80007e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800084:	83 c4 08             	add    $0x8,%esp
  800087:	69 c6 84 00 00 00    	imul   $0x84,%esi,%eax
  80008d:	c1 f8 02             	sar    $0x2,%eax
  800090:	69 c0 e1 83 0f 3e    	imul   $0x3e0f83e1,%eax,%eax
  800096:	50                   	push   %eax
  800097:	68 25 2d 80 00       	push   $0x802d25
  80009c:	e8 65 03 00 00       	call   800406 <cprintf>
	dup(p[0], 10);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 0a                	push   $0xa
  8000a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a9:	e8 88 19 00 00       	call   801a36 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	69 de 84 00 00 00    	imul   $0x84,%esi,%ebx
  8000b7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000bd:	8b 53 54             	mov    0x54(%ebx),%edx
  8000c0:	83 fa 02             	cmp    $0x2,%edx
  8000c3:	0f 85 94 00 00 00    	jne    80015d <umain+0x12a>
		dup(p[0], 10);
  8000c9:	83 ec 08             	sub    $0x8,%esp
  8000cc:	6a 0a                	push   $0xa
  8000ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8000d1:	e8 60 19 00 00       	call   801a36 <dup>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	eb e2                	jmp    8000bd <umain+0x8a>
		panic("pipe: %e", r);
  8000db:	50                   	push   %eax
  8000dc:	68 d9 2c 80 00       	push   $0x802cd9
  8000e1:	6a 0d                	push   $0xd
  8000e3:	68 e2 2c 80 00       	push   $0x802ce2
  8000e8:	e8 23 02 00 00       	call   800310 <_panic>
		panic("fork: %e", r);
  8000ed:	50                   	push   %eax
  8000ee:	68 f6 2c 80 00       	push   $0x802cf6
  8000f3:	6a 10                	push   $0x10
  8000f5:	68 e2 2c 80 00       	push   $0x802ce2
  8000fa:	e8 11 02 00 00       	call   800310 <_panic>
		close(p[1]);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	ff 75 f4             	pushl  -0xc(%ebp)
  800105:	e8 da 18 00 00       	call   8019e4 <close>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	bb c8 00 00 00       	mov    $0xc8,%ebx
  800112:	eb 1f                	jmp    800133 <umain+0x100>
				cprintf("RACE: pipe appears closed\n");
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 ff 2c 80 00       	push   $0x802cff
  80011c:	e8 e5 02 00 00       	call   800406 <cprintf>
				exit();
  800121:	e8 b6 01 00 00       	call   8002dc <exit>
  800126:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800129:	e8 0a 0e 00 00       	call   800f38 <sys_yield>
		for (i=0; i<max; i++) {
  80012e:	83 eb 01             	sub    $0x1,%ebx
  800131:	74 14                	je     800147 <umain+0x114>
			if(pipeisclosed(p[0])){
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	ff 75 f0             	pushl  -0x10(%ebp)
  800139:	e8 e4 26 00 00       	call   802822 <pipeisclosed>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	85 c0                	test   %eax,%eax
  800143:	74 e4                	je     800129 <umain+0xf6>
  800145:	eb cd                	jmp    800114 <umain+0xe1>
		ipc_recv(0,0,0);
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	6a 00                	push   $0x0
  80014c:	6a 00                	push   $0x0
  80014e:	6a 00                	push   $0x0
  800150:	e8 e4 15 00 00       	call   801739 <ipc_recv>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	e9 13 ff ff ff       	jmp    800070 <umain+0x3d>

	cprintf("child done with loop\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 30 2d 80 00       	push   $0x802d30
  800165:	e8 9c 02 00 00       	call   800406 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	83 c4 04             	add    $0x4,%esp
  80016d:	ff 75 f0             	pushl  -0x10(%ebp)
  800170:	e8 ad 26 00 00       	call   802822 <pipeisclosed>
  800175:	83 c4 10             	add    $0x10,%esp
  800178:	85 c0                	test   %eax,%eax
  80017a:	75 48                	jne    8001c4 <umain+0x191>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	ff 75 f0             	pushl  -0x10(%ebp)
  800186:	e8 27 17 00 00       	call   8018b2 <fd_lookup>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	85 c0                	test   %eax,%eax
  800190:	78 46                	js     8001d8 <umain+0x1a5>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	ff 75 ec             	pushl  -0x14(%ebp)
  800198:	e8 ac 16 00 00       	call   801849 <fd2data>
	if (pageref(va) != 3+1)
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 c0 1e 00 00       	call   802065 <pageref>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	83 f8 04             	cmp    $0x4,%eax
  8001ab:	74 3d                	je     8001ea <umain+0x1b7>
		cprintf("\nchild detected race\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 5e 2d 80 00       	push   $0x802d5e
  8001b5:	e8 4c 02 00 00       	call   800406 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c0:	5b                   	pop    %ebx
  8001c1:	5e                   	pop    %esi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	68 8c 2d 80 00       	push   $0x802d8c
  8001cc:	6a 3a                	push   $0x3a
  8001ce:	68 e2 2c 80 00       	push   $0x802ce2
  8001d3:	e8 38 01 00 00       	call   800310 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001d8:	50                   	push   %eax
  8001d9:	68 46 2d 80 00       	push   $0x802d46
  8001de:	6a 3c                	push   $0x3c
  8001e0:	68 e2 2c 80 00       	push   $0x802ce2
  8001e5:	e8 26 01 00 00       	call   800310 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	68 c8 00 00 00       	push   $0xc8
  8001f2:	68 74 2d 80 00       	push   $0x802d74
  8001f7:	e8 0a 02 00 00       	call   800406 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
}
  8001ff:	eb bc                	jmp    8001bd <umain+0x18a>

00800201 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	57                   	push   %edi
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80020a:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800211:	00 00 00 
	envid_t find = sys_getenvid();
  800214:	e8 00 0d 00 00       	call   800f19 <sys_getenvid>
  800219:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  80021f:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800224:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800229:	bf 01 00 00 00       	mov    $0x1,%edi
  80022e:	eb 0b                	jmp    80023b <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800230:	83 c2 01             	add    $0x1,%edx
  800233:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800239:	74 23                	je     80025e <libmain+0x5d>
		if(envs[i].env_id == find)
  80023b:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800241:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800247:	8b 49 48             	mov    0x48(%ecx),%ecx
  80024a:	39 c1                	cmp    %eax,%ecx
  80024c:	75 e2                	jne    800230 <libmain+0x2f>
  80024e:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800254:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80025a:	89 fe                	mov    %edi,%esi
  80025c:	eb d2                	jmp    800230 <libmain+0x2f>
  80025e:	89 f0                	mov    %esi,%eax
  800260:	84 c0                	test   %al,%al
  800262:	74 06                	je     80026a <libmain+0x69>
  800264:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80026a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80026e:	7e 0a                	jle    80027a <libmain+0x79>
		binaryname = argv[0];
  800270:	8b 45 0c             	mov    0xc(%ebp),%eax
  800273:	8b 00                	mov    (%eax),%eax
  800275:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80027a:	a1 08 50 80 00       	mov    0x805008,%eax
  80027f:	8b 40 48             	mov    0x48(%eax),%eax
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	50                   	push   %eax
  800286:	68 b6 2d 80 00       	push   $0x802db6
  80028b:	e8 76 01 00 00       	call   800406 <cprintf>
	cprintf("before umain\n");
  800290:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  800297:	e8 6a 01 00 00       	call   800406 <cprintf>
	// call user main routine
	umain(argc, argv);
  80029c:	83 c4 08             	add    $0x8,%esp
  80029f:	ff 75 0c             	pushl  0xc(%ebp)
  8002a2:	ff 75 08             	pushl  0x8(%ebp)
  8002a5:	e8 89 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8002aa:	c7 04 24 e2 2d 80 00 	movl   $0x802de2,(%esp)
  8002b1:	e8 50 01 00 00       	call   800406 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8002b6:	a1 08 50 80 00       	mov    0x805008,%eax
  8002bb:	8b 40 48             	mov    0x48(%eax),%eax
  8002be:	83 c4 08             	add    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	68 ef 2d 80 00       	push   $0x802def
  8002c7:	e8 3a 01 00 00       	call   800406 <cprintf>
	// exit gracefully
	exit();
  8002cc:	e8 0b 00 00 00       	call   8002dc <exit>
}
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    

008002dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002e2:	a1 08 50 80 00       	mov    0x805008,%eax
  8002e7:	8b 40 48             	mov    0x48(%eax),%eax
  8002ea:	68 1c 2e 80 00       	push   $0x802e1c
  8002ef:	50                   	push   %eax
  8002f0:	68 0e 2e 80 00       	push   $0x802e0e
  8002f5:	e8 0c 01 00 00       	call   800406 <cprintf>
	close_all();
  8002fa:	e8 12 17 00 00       	call   801a11 <close_all>
	sys_env_destroy(0);
  8002ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800306:	e8 cd 0b 00 00       	call   800ed8 <sys_env_destroy>
}
  80030b:	83 c4 10             	add    $0x10,%esp
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	56                   	push   %esi
  800314:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800315:	a1 08 50 80 00       	mov    0x805008,%eax
  80031a:	8b 40 48             	mov    0x48(%eax),%eax
  80031d:	83 ec 04             	sub    $0x4,%esp
  800320:	68 48 2e 80 00       	push   $0x802e48
  800325:	50                   	push   %eax
  800326:	68 0e 2e 80 00       	push   $0x802e0e
  80032b:	e8 d6 00 00 00       	call   800406 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800330:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800333:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800339:	e8 db 0b 00 00       	call   800f19 <sys_getenvid>
  80033e:	83 c4 04             	add    $0x4,%esp
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	56                   	push   %esi
  800348:	50                   	push   %eax
  800349:	68 24 2e 80 00       	push   $0x802e24
  80034e:	e8 b3 00 00 00       	call   800406 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800353:	83 c4 18             	add    $0x18,%esp
  800356:	53                   	push   %ebx
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	e8 56 00 00 00       	call   8003b5 <vcprintf>
	cprintf("\n");
  80035f:	c7 04 24 d2 2d 80 00 	movl   $0x802dd2,(%esp)
  800366:	e8 9b 00 00 00       	call   800406 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036e:	cc                   	int3   
  80036f:	eb fd                	jmp    80036e <_panic+0x5e>

00800371 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	53                   	push   %ebx
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037b:	8b 13                	mov    (%ebx),%edx
  80037d:	8d 42 01             	lea    0x1(%edx),%eax
  800380:	89 03                	mov    %eax,(%ebx)
  800382:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800385:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800389:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038e:	74 09                	je     800399 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800390:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800397:	c9                   	leave  
  800398:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	68 ff 00 00 00       	push   $0xff
  8003a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a4:	50                   	push   %eax
  8003a5:	e8 f1 0a 00 00       	call   800e9b <sys_cputs>
		b->idx = 0;
  8003aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	eb db                	jmp    800390 <putch+0x1f>

008003b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c5:	00 00 00 
	b.cnt = 0;
  8003c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	ff 75 08             	pushl  0x8(%ebp)
  8003d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003de:	50                   	push   %eax
  8003df:	68 71 03 80 00       	push   $0x800371
  8003e4:	e8 4a 01 00 00       	call   800533 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e9:	83 c4 08             	add    $0x8,%esp
  8003ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f8:	50                   	push   %eax
  8003f9:	e8 9d 0a 00 00       	call   800e9b <sys_cputs>

	return b.cnt;
}
  8003fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040f:	50                   	push   %eax
  800410:	ff 75 08             	pushl  0x8(%ebp)
  800413:	e8 9d ff ff ff       	call   8003b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	57                   	push   %edi
  80041e:	56                   	push   %esi
  80041f:	53                   	push   %ebx
  800420:	83 ec 1c             	sub    $0x1c,%esp
  800423:	89 c6                	mov    %eax,%esi
  800425:	89 d7                	mov    %edx,%edi
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800430:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800433:	8b 45 10             	mov    0x10(%ebp),%eax
  800436:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800439:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80043d:	74 2c                	je     80046b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80043f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800442:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800449:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80044f:	39 c2                	cmp    %eax,%edx
  800451:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800454:	73 43                	jae    800499 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800456:	83 eb 01             	sub    $0x1,%ebx
  800459:	85 db                	test   %ebx,%ebx
  80045b:	7e 6c                	jle    8004c9 <printnum+0xaf>
				putch(padc, putdat);
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	57                   	push   %edi
  800461:	ff 75 18             	pushl  0x18(%ebp)
  800464:	ff d6                	call   *%esi
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	eb eb                	jmp    800456 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	6a 20                	push   $0x20
  800470:	6a 00                	push   $0x0
  800472:	50                   	push   %eax
  800473:	ff 75 e4             	pushl  -0x1c(%ebp)
  800476:	ff 75 e0             	pushl  -0x20(%ebp)
  800479:	89 fa                	mov    %edi,%edx
  80047b:	89 f0                	mov    %esi,%eax
  80047d:	e8 98 ff ff ff       	call   80041a <printnum>
		while (--width > 0)
  800482:	83 c4 20             	add    $0x20,%esp
  800485:	83 eb 01             	sub    $0x1,%ebx
  800488:	85 db                	test   %ebx,%ebx
  80048a:	7e 65                	jle    8004f1 <printnum+0xd7>
			putch(padc, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	57                   	push   %edi
  800490:	6a 20                	push   $0x20
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	eb ec                	jmp    800485 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800499:	83 ec 0c             	sub    $0xc,%esp
  80049c:	ff 75 18             	pushl  0x18(%ebp)
  80049f:	83 eb 01             	sub    $0x1,%ebx
  8004a2:	53                   	push   %ebx
  8004a3:	50                   	push   %eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8004aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b3:	e8 a8 25 00 00       	call   802a60 <__udivdi3>
  8004b8:	83 c4 18             	add    $0x18,%esp
  8004bb:	52                   	push   %edx
  8004bc:	50                   	push   %eax
  8004bd:	89 fa                	mov    %edi,%edx
  8004bf:	89 f0                	mov    %esi,%eax
  8004c1:	e8 54 ff ff ff       	call   80041a <printnum>
  8004c6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	57                   	push   %edi
  8004cd:	83 ec 04             	sub    $0x4,%esp
  8004d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8004d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dc:	e8 8f 26 00 00       	call   802b70 <__umoddi3>
  8004e1:	83 c4 14             	add    $0x14,%esp
  8004e4:	0f be 80 4f 2e 80 00 	movsbl 0x802e4f(%eax),%eax
  8004eb:	50                   	push   %eax
  8004ec:	ff d6                	call   *%esi
  8004ee:	83 c4 10             	add    $0x10,%esp
	}
}
  8004f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004f4:	5b                   	pop    %ebx
  8004f5:	5e                   	pop    %esi
  8004f6:	5f                   	pop    %edi
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    

008004f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800503:	8b 10                	mov    (%eax),%edx
  800505:	3b 50 04             	cmp    0x4(%eax),%edx
  800508:	73 0a                	jae    800514 <sprintputch+0x1b>
		*b->buf++ = ch;
  80050a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80050d:	89 08                	mov    %ecx,(%eax)
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	88 02                	mov    %al,(%edx)
}
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <printfmt>:
{
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80051c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80051f:	50                   	push   %eax
  800520:	ff 75 10             	pushl  0x10(%ebp)
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	e8 05 00 00 00       	call   800533 <vprintfmt>
}
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <vprintfmt>:
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	57                   	push   %edi
  800537:	56                   	push   %esi
  800538:	53                   	push   %ebx
  800539:	83 ec 3c             	sub    $0x3c,%esp
  80053c:	8b 75 08             	mov    0x8(%ebp),%esi
  80053f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800542:	8b 7d 10             	mov    0x10(%ebp),%edi
  800545:	e9 32 04 00 00       	jmp    80097c <vprintfmt+0x449>
		padc = ' ';
  80054a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80054e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800555:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80055c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800563:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800571:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8d 47 01             	lea    0x1(%edi),%eax
  800579:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80057c:	0f b6 17             	movzbl (%edi),%edx
  80057f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800582:	3c 55                	cmp    $0x55,%al
  800584:	0f 87 12 05 00 00    	ja     800a9c <vprintfmt+0x569>
  80058a:	0f b6 c0             	movzbl %al,%eax
  80058d:	ff 24 85 20 30 80 00 	jmp    *0x803020(,%eax,4)
  800594:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800597:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80059b:	eb d9                	jmp    800576 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005a0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005a4:	eb d0                	jmp    800576 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005a6:	0f b6 d2             	movzbl %dl,%edx
  8005a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b4:	eb 03                	jmp    8005b9 <vprintfmt+0x86>
  8005b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005bc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005c0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005c3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005c6:	83 fe 09             	cmp    $0x9,%esi
  8005c9:	76 eb                	jbe    8005b6 <vprintfmt+0x83>
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d1:	eb 14                	jmp    8005e7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 40 04             	lea    0x4(%eax),%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005eb:	79 89                	jns    800576 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x43>
  8005ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800602:	85 c0                	test   %eax,%eax
  800604:	0f 48 c1             	cmovs  %ecx,%eax
  800607:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80060d:	e9 64 ff ff ff       	jmp    800576 <vprintfmt+0x43>
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800615:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80061c:	e9 55 ff ff ff       	jmp    800576 <vprintfmt+0x43>
			lflag++;
  800621:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800625:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800628:	e9 49 ff ff ff       	jmp    800576 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 78 04             	lea    0x4(%eax),%edi
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	ff 30                	pushl  (%eax)
  800639:	ff d6                	call   *%esi
			break;
  80063b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80063e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800641:	e9 33 03 00 00       	jmp    800979 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 78 04             	lea    0x4(%eax),%edi
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	99                   	cltd   
  80064f:	31 d0                	xor    %edx,%eax
  800651:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800653:	83 f8 11             	cmp    $0x11,%eax
  800656:	7f 23                	jg     80067b <vprintfmt+0x148>
  800658:	8b 14 85 80 31 80 00 	mov    0x803180(,%eax,4),%edx
  80065f:	85 d2                	test   %edx,%edx
  800661:	74 18                	je     80067b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800663:	52                   	push   %edx
  800664:	68 ad 33 80 00       	push   $0x8033ad
  800669:	53                   	push   %ebx
  80066a:	56                   	push   %esi
  80066b:	e8 a6 fe ff ff       	call   800516 <printfmt>
  800670:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800673:	89 7d 14             	mov    %edi,0x14(%ebp)
  800676:	e9 fe 02 00 00       	jmp    800979 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80067b:	50                   	push   %eax
  80067c:	68 67 2e 80 00       	push   $0x802e67
  800681:	53                   	push   %ebx
  800682:	56                   	push   %esi
  800683:	e8 8e fe ff ff       	call   800516 <printfmt>
  800688:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80068b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80068e:	e9 e6 02 00 00       	jmp    800979 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	83 c0 04             	add    $0x4,%eax
  800699:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006a1:	85 c9                	test   %ecx,%ecx
  8006a3:	b8 60 2e 80 00       	mov    $0x802e60,%eax
  8006a8:	0f 45 c1             	cmovne %ecx,%eax
  8006ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b2:	7e 06                	jle    8006ba <vprintfmt+0x187>
  8006b4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006b8:	75 0d                	jne    8006c7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006bd:	89 c7                	mov    %eax,%edi
  8006bf:	03 45 e0             	add    -0x20(%ebp),%eax
  8006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c5:	eb 53                	jmp    80071a <vprintfmt+0x1e7>
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8006cd:	50                   	push   %eax
  8006ce:	e8 71 04 00 00       	call   800b44 <strnlen>
  8006d3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006d6:	29 c1                	sub    %eax,%ecx
  8006d8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006e0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e7:	eb 0f                	jmp    8006f8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f2:	83 ef 01             	sub    $0x1,%edi
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	85 ff                	test   %edi,%edi
  8006fa:	7f ed                	jg     8006e9 <vprintfmt+0x1b6>
  8006fc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006ff:	85 c9                	test   %ecx,%ecx
  800701:	b8 00 00 00 00       	mov    $0x0,%eax
  800706:	0f 49 c1             	cmovns %ecx,%eax
  800709:	29 c1                	sub    %eax,%ecx
  80070b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80070e:	eb aa                	jmp    8006ba <vprintfmt+0x187>
					putch(ch, putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	52                   	push   %edx
  800715:	ff d6                	call   *%esi
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80071d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071f:	83 c7 01             	add    $0x1,%edi
  800722:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800726:	0f be d0             	movsbl %al,%edx
  800729:	85 d2                	test   %edx,%edx
  80072b:	74 4b                	je     800778 <vprintfmt+0x245>
  80072d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800731:	78 06                	js     800739 <vprintfmt+0x206>
  800733:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800737:	78 1e                	js     800757 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800739:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80073d:	74 d1                	je     800710 <vprintfmt+0x1dd>
  80073f:	0f be c0             	movsbl %al,%eax
  800742:	83 e8 20             	sub    $0x20,%eax
  800745:	83 f8 5e             	cmp    $0x5e,%eax
  800748:	76 c6                	jbe    800710 <vprintfmt+0x1dd>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 3f                	push   $0x3f
  800750:	ff d6                	call   *%esi
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	eb c3                	jmp    80071a <vprintfmt+0x1e7>
  800757:	89 cf                	mov    %ecx,%edi
  800759:	eb 0e                	jmp    800769 <vprintfmt+0x236>
				putch(' ', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 20                	push   $0x20
  800761:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800763:	83 ef 01             	sub    $0x1,%edi
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	85 ff                	test   %edi,%edi
  80076b:	7f ee                	jg     80075b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80076d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
  800773:	e9 01 02 00 00       	jmp    800979 <vprintfmt+0x446>
  800778:	89 cf                	mov    %ecx,%edi
  80077a:	eb ed                	jmp    800769 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80077c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80077f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800786:	e9 eb fd ff ff       	jmp    800576 <vprintfmt+0x43>
	if (lflag >= 2)
  80078b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078f:	7f 21                	jg     8007b2 <vprintfmt+0x27f>
	else if (lflag)
  800791:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800795:	74 68                	je     8007ff <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80079f:	89 c1                	mov    %eax,%ecx
  8007a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b0:	eb 17                	jmp    8007c9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 08             	lea    0x8(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007d9:	78 3f                	js     80081a <vprintfmt+0x2e7>
			base = 10;
  8007db:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007e0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007e4:	0f 84 71 01 00 00    	je     80095b <vprintfmt+0x428>
				putch('+', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	53                   	push   %ebx
  8007ee:	6a 2b                	push   $0x2b
  8007f0:	ff d6                	call   *%esi
  8007f2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fa:	e9 5c 01 00 00       	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800807:	89 c1                	mov    %eax,%ecx
  800809:	c1 f9 1f             	sar    $0x1f,%ecx
  80080c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
  800818:	eb af                	jmp    8007c9 <vprintfmt+0x296>
				putch('-', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 2d                	push   $0x2d
  800820:	ff d6                	call   *%esi
				num = -(long long) num;
  800822:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800825:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800828:	f7 d8                	neg    %eax
  80082a:	83 d2 00             	adc    $0x0,%edx
  80082d:	f7 da                	neg    %edx
  80082f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800832:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800835:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800838:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083d:	e9 19 01 00 00       	jmp    80095b <vprintfmt+0x428>
	if (lflag >= 2)
  800842:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800846:	7f 29                	jg     800871 <vprintfmt+0x33e>
	else if (lflag)
  800848:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80084c:	74 44                	je     800892 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
  800858:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 40 04             	lea    0x4(%eax),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800867:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086c:	e9 ea 00 00 00       	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 50 04             	mov    0x4(%eax),%edx
  800877:	8b 00                	mov    (%eax),%eax
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 08             	lea    0x8(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800888:	b8 0a 00 00 00       	mov    $0xa,%eax
  80088d:	e9 c9 00 00 00       	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8d 40 04             	lea    0x4(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b0:	e9 a6 00 00 00       	jmp    80095b <vprintfmt+0x428>
			putch('0', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	6a 30                	push   $0x30
  8008bb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008c4:	7f 26                	jg     8008ec <vprintfmt+0x3b9>
	else if (lflag)
  8008c6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ca:	74 3e                	je     80090a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 40 04             	lea    0x4(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ea:	eb 6f                	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8b 50 04             	mov    0x4(%eax),%edx
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	8d 40 08             	lea    0x8(%eax),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800903:	b8 08 00 00 00       	mov    $0x8,%eax
  800908:	eb 51                	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800917:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8d 40 04             	lea    0x4(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800923:	b8 08 00 00 00       	mov    $0x8,%eax
  800928:	eb 31                	jmp    80095b <vprintfmt+0x428>
			putch('0', putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	53                   	push   %ebx
  80092e:	6a 30                	push   $0x30
  800930:	ff d6                	call   *%esi
			putch('x', putdat);
  800932:	83 c4 08             	add    $0x8,%esp
  800935:	53                   	push   %ebx
  800936:	6a 78                	push   $0x78
  800938:	ff d6                	call   *%esi
			num = (unsigned long long)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	ba 00 00 00 00       	mov    $0x0,%edx
  800944:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800947:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80094a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 40 04             	lea    0x4(%eax),%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800956:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80095b:	83 ec 0c             	sub    $0xc,%esp
  80095e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800962:	52                   	push   %edx
  800963:	ff 75 e0             	pushl  -0x20(%ebp)
  800966:	50                   	push   %eax
  800967:	ff 75 dc             	pushl  -0x24(%ebp)
  80096a:	ff 75 d8             	pushl  -0x28(%ebp)
  80096d:	89 da                	mov    %ebx,%edx
  80096f:	89 f0                	mov    %esi,%eax
  800971:	e8 a4 fa ff ff       	call   80041a <printnum>
			break;
  800976:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800979:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097c:	83 c7 01             	add    $0x1,%edi
  80097f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800983:	83 f8 25             	cmp    $0x25,%eax
  800986:	0f 84 be fb ff ff    	je     80054a <vprintfmt+0x17>
			if (ch == '\0')
  80098c:	85 c0                	test   %eax,%eax
  80098e:	0f 84 28 01 00 00    	je     800abc <vprintfmt+0x589>
			putch(ch, putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	50                   	push   %eax
  800999:	ff d6                	call   *%esi
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	eb dc                	jmp    80097c <vprintfmt+0x449>
	if (lflag >= 2)
  8009a0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009a4:	7f 26                	jg     8009cc <vprintfmt+0x499>
	else if (lflag)
  8009a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009aa:	74 41                	je     8009ed <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	8d 40 04             	lea    0x4(%eax),%eax
  8009c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c5:	b8 10 00 00 00       	mov    $0x10,%eax
  8009ca:	eb 8f                	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	8b 50 04             	mov    0x4(%eax),%edx
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8d 40 08             	lea    0x8(%eax),%eax
  8009e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8009e8:	e9 6e ff ff ff       	jmp    80095b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800a00:	8d 40 04             	lea    0x4(%eax),%eax
  800a03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a06:	b8 10 00 00 00       	mov    $0x10,%eax
  800a0b:	e9 4b ff ff ff       	jmp    80095b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 c0 04             	add    $0x4,%eax
  800a16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8b 00                	mov    (%eax),%eax
  800a1e:	85 c0                	test   %eax,%eax
  800a20:	74 14                	je     800a36 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a22:	8b 13                	mov    (%ebx),%edx
  800a24:	83 fa 7f             	cmp    $0x7f,%edx
  800a27:	7f 37                	jg     800a60 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a29:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a31:	e9 43 ff ff ff       	jmp    800979 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a3b:	bf 85 2f 80 00       	mov    $0x802f85,%edi
							putch(ch, putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	53                   	push   %ebx
  800a44:	50                   	push   %eax
  800a45:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a47:	83 c7 01             	add    $0x1,%edi
  800a4a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	85 c0                	test   %eax,%eax
  800a53:	75 eb                	jne    800a40 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a55:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a58:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5b:	e9 19 ff ff ff       	jmp    800979 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a60:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a67:	bf bd 2f 80 00       	mov    $0x802fbd,%edi
							putch(ch, putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	53                   	push   %ebx
  800a70:	50                   	push   %eax
  800a71:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a73:	83 c7 01             	add    $0x1,%edi
  800a76:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	85 c0                	test   %eax,%eax
  800a7f:	75 eb                	jne    800a6c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a81:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
  800a87:	e9 ed fe ff ff       	jmp    800979 <vprintfmt+0x446>
			putch(ch, putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	53                   	push   %ebx
  800a90:	6a 25                	push   $0x25
  800a92:	ff d6                	call   *%esi
			break;
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	e9 dd fe ff ff       	jmp    800979 <vprintfmt+0x446>
			putch('%', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	53                   	push   %ebx
  800aa0:	6a 25                	push   $0x25
  800aa2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	89 f8                	mov    %edi,%eax
  800aa9:	eb 03                	jmp    800aae <vprintfmt+0x57b>
  800aab:	83 e8 01             	sub    $0x1,%eax
  800aae:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ab2:	75 f7                	jne    800aab <vprintfmt+0x578>
  800ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab7:	e9 bd fe ff ff       	jmp    800979 <vprintfmt+0x446>
}
  800abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 18             	sub    $0x18,%esp
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ad0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ad7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 26                	je     800b0b <vsnprintf+0x47>
  800ae5:	85 d2                	test   %edx,%edx
  800ae7:	7e 22                	jle    800b0b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae9:	ff 75 14             	pushl  0x14(%ebp)
  800aec:	ff 75 10             	pushl  0x10(%ebp)
  800aef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af2:	50                   	push   %eax
  800af3:	68 f9 04 80 00       	push   $0x8004f9
  800af8:	e8 36 fa ff ff       	call   800533 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b00:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b06:	83 c4 10             	add    $0x10,%esp
}
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    
		return -E_INVAL;
  800b0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b10:	eb f7                	jmp    800b09 <vsnprintf+0x45>

00800b12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b18:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b1b:	50                   	push   %eax
  800b1c:	ff 75 10             	pushl  0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 9a ff ff ff       	call   800ac4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
  800b37:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b3b:	74 05                	je     800b42 <strlen+0x16>
		n++;
  800b3d:	83 c0 01             	add    $0x1,%eax
  800b40:	eb f5                	jmp    800b37 <strlen+0xb>
	return n;
}
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	39 c2                	cmp    %eax,%edx
  800b54:	74 0d                	je     800b63 <strnlen+0x1f>
  800b56:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b5a:	74 05                	je     800b61 <strnlen+0x1d>
		n++;
  800b5c:	83 c2 01             	add    $0x1,%edx
  800b5f:	eb f1                	jmp    800b52 <strnlen+0xe>
  800b61:	89 d0                	mov    %edx,%eax
	return n;
}
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b78:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	84 c9                	test   %cl,%cl
  800b80:	75 f2                	jne    800b74 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b82:	5b                   	pop    %ebx
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	53                   	push   %ebx
  800b89:	83 ec 10             	sub    $0x10,%esp
  800b8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b8f:	53                   	push   %ebx
  800b90:	e8 97 ff ff ff       	call   800b2c <strlen>
  800b95:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	01 d8                	add    %ebx,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 c2 ff ff ff       	call   800b65 <strcpy>
	return dst;
}
  800ba3:	89 d8                	mov    %ebx,%eax
  800ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb5:	89 c6                	mov    %eax,%esi
  800bb7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bba:	89 c2                	mov    %eax,%edx
  800bbc:	39 f2                	cmp    %esi,%edx
  800bbe:	74 11                	je     800bd1 <strncpy+0x27>
		*dst++ = *src;
  800bc0:	83 c2 01             	add    $0x1,%edx
  800bc3:	0f b6 19             	movzbl (%ecx),%ebx
  800bc6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bc9:	80 fb 01             	cmp    $0x1,%bl
  800bcc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bcf:	eb eb                	jmp    800bbc <strncpy+0x12>
	}
	return ret;
}
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	8b 75 08             	mov    0x8(%ebp),%esi
  800bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be0:	8b 55 10             	mov    0x10(%ebp),%edx
  800be3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800be5:	85 d2                	test   %edx,%edx
  800be7:	74 21                	je     800c0a <strlcpy+0x35>
  800be9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bed:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bef:	39 c2                	cmp    %eax,%edx
  800bf1:	74 14                	je     800c07 <strlcpy+0x32>
  800bf3:	0f b6 19             	movzbl (%ecx),%ebx
  800bf6:	84 db                	test   %bl,%bl
  800bf8:	74 0b                	je     800c05 <strlcpy+0x30>
			*dst++ = *src++;
  800bfa:	83 c1 01             	add    $0x1,%ecx
  800bfd:	83 c2 01             	add    $0x1,%edx
  800c00:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c03:	eb ea                	jmp    800bef <strlcpy+0x1a>
  800c05:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c0a:	29 f0                	sub    %esi,%eax
}
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c16:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c19:	0f b6 01             	movzbl (%ecx),%eax
  800c1c:	84 c0                	test   %al,%al
  800c1e:	74 0c                	je     800c2c <strcmp+0x1c>
  800c20:	3a 02                	cmp    (%edx),%al
  800c22:	75 08                	jne    800c2c <strcmp+0x1c>
		p++, q++;
  800c24:	83 c1 01             	add    $0x1,%ecx
  800c27:	83 c2 01             	add    $0x1,%edx
  800c2a:	eb ed                	jmp    800c19 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2c:	0f b6 c0             	movzbl %al,%eax
  800c2f:	0f b6 12             	movzbl (%edx),%edx
  800c32:	29 d0                	sub    %edx,%eax
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	53                   	push   %ebx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	89 c3                	mov    %eax,%ebx
  800c42:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c45:	eb 06                	jmp    800c4d <strncmp+0x17>
		n--, p++, q++;
  800c47:	83 c0 01             	add    $0x1,%eax
  800c4a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c4d:	39 d8                	cmp    %ebx,%eax
  800c4f:	74 16                	je     800c67 <strncmp+0x31>
  800c51:	0f b6 08             	movzbl (%eax),%ecx
  800c54:	84 c9                	test   %cl,%cl
  800c56:	74 04                	je     800c5c <strncmp+0x26>
  800c58:	3a 0a                	cmp    (%edx),%cl
  800c5a:	74 eb                	je     800c47 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5c:	0f b6 00             	movzbl (%eax),%eax
  800c5f:	0f b6 12             	movzbl (%edx),%edx
  800c62:	29 d0                	sub    %edx,%eax
}
  800c64:	5b                   	pop    %ebx
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    
		return 0;
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6c:	eb f6                	jmp    800c64 <strncmp+0x2e>

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c78:	0f b6 10             	movzbl (%eax),%edx
  800c7b:	84 d2                	test   %dl,%dl
  800c7d:	74 09                	je     800c88 <strchr+0x1a>
		if (*s == c)
  800c7f:	38 ca                	cmp    %cl,%dl
  800c81:	74 0a                	je     800c8d <strchr+0x1f>
	for (; *s; s++)
  800c83:	83 c0 01             	add    $0x1,%eax
  800c86:	eb f0                	jmp    800c78 <strchr+0xa>
			return (char *) s;
	return 0;
  800c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c99:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c9c:	38 ca                	cmp    %cl,%dl
  800c9e:	74 09                	je     800ca9 <strfind+0x1a>
  800ca0:	84 d2                	test   %dl,%dl
  800ca2:	74 05                	je     800ca9 <strfind+0x1a>
	for (; *s; s++)
  800ca4:	83 c0 01             	add    $0x1,%eax
  800ca7:	eb f0                	jmp    800c99 <strfind+0xa>
			break;
	return (char *) s;
}
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cb4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cb7:	85 c9                	test   %ecx,%ecx
  800cb9:	74 31                	je     800cec <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cbb:	89 f8                	mov    %edi,%eax
  800cbd:	09 c8                	or     %ecx,%eax
  800cbf:	a8 03                	test   $0x3,%al
  800cc1:	75 23                	jne    800ce6 <memset+0x3b>
		c &= 0xFF;
  800cc3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	c1 e3 08             	shl    $0x8,%ebx
  800ccc:	89 d0                	mov    %edx,%eax
  800cce:	c1 e0 18             	shl    $0x18,%eax
  800cd1:	89 d6                	mov    %edx,%esi
  800cd3:	c1 e6 10             	shl    $0x10,%esi
  800cd6:	09 f0                	or     %esi,%eax
  800cd8:	09 c2                	or     %eax,%edx
  800cda:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cdc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cdf:	89 d0                	mov    %edx,%eax
  800ce1:	fc                   	cld    
  800ce2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ce4:	eb 06                	jmp    800cec <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce9:	fc                   	cld    
  800cea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cec:	89 f8                	mov    %edi,%eax
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d01:	39 c6                	cmp    %eax,%esi
  800d03:	73 32                	jae    800d37 <memmove+0x44>
  800d05:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d08:	39 c2                	cmp    %eax,%edx
  800d0a:	76 2b                	jbe    800d37 <memmove+0x44>
		s += n;
		d += n;
  800d0c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d0f:	89 fe                	mov    %edi,%esi
  800d11:	09 ce                	or     %ecx,%esi
  800d13:	09 d6                	or     %edx,%esi
  800d15:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d1b:	75 0e                	jne    800d2b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d1d:	83 ef 04             	sub    $0x4,%edi
  800d20:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d26:	fd                   	std    
  800d27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d29:	eb 09                	jmp    800d34 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d2b:	83 ef 01             	sub    $0x1,%edi
  800d2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d31:	fd                   	std    
  800d32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d34:	fc                   	cld    
  800d35:	eb 1a                	jmp    800d51 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d37:	89 c2                	mov    %eax,%edx
  800d39:	09 ca                	or     %ecx,%edx
  800d3b:	09 f2                	or     %esi,%edx
  800d3d:	f6 c2 03             	test   $0x3,%dl
  800d40:	75 0a                	jne    800d4c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d45:	89 c7                	mov    %eax,%edi
  800d47:	fc                   	cld    
  800d48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d4a:	eb 05                	jmp    800d51 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d4c:	89 c7                	mov    %eax,%edi
  800d4e:	fc                   	cld    
  800d4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d5b:	ff 75 10             	pushl  0x10(%ebp)
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	ff 75 08             	pushl  0x8(%ebp)
  800d64:	e8 8a ff ff ff       	call   800cf3 <memmove>
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d76:	89 c6                	mov    %eax,%esi
  800d78:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d7b:	39 f0                	cmp    %esi,%eax
  800d7d:	74 1c                	je     800d9b <memcmp+0x30>
		if (*s1 != *s2)
  800d7f:	0f b6 08             	movzbl (%eax),%ecx
  800d82:	0f b6 1a             	movzbl (%edx),%ebx
  800d85:	38 d9                	cmp    %bl,%cl
  800d87:	75 08                	jne    800d91 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d89:	83 c0 01             	add    $0x1,%eax
  800d8c:	83 c2 01             	add    $0x1,%edx
  800d8f:	eb ea                	jmp    800d7b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d91:	0f b6 c1             	movzbl %cl,%eax
  800d94:	0f b6 db             	movzbl %bl,%ebx
  800d97:	29 d8                	sub    %ebx,%eax
  800d99:	eb 05                	jmp    800da0 <memcmp+0x35>
	}

	return 0;
  800d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dad:	89 c2                	mov    %eax,%edx
  800daf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800db2:	39 d0                	cmp    %edx,%eax
  800db4:	73 09                	jae    800dbf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800db6:	38 08                	cmp    %cl,(%eax)
  800db8:	74 05                	je     800dbf <memfind+0x1b>
	for (; s < ends; s++)
  800dba:	83 c0 01             	add    $0x1,%eax
  800dbd:	eb f3                	jmp    800db2 <memfind+0xe>
			break;
	return (void *) s;
}
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dcd:	eb 03                	jmp    800dd2 <strtol+0x11>
		s++;
  800dcf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dd2:	0f b6 01             	movzbl (%ecx),%eax
  800dd5:	3c 20                	cmp    $0x20,%al
  800dd7:	74 f6                	je     800dcf <strtol+0xe>
  800dd9:	3c 09                	cmp    $0x9,%al
  800ddb:	74 f2                	je     800dcf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ddd:	3c 2b                	cmp    $0x2b,%al
  800ddf:	74 2a                	je     800e0b <strtol+0x4a>
	int neg = 0;
  800de1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800de6:	3c 2d                	cmp    $0x2d,%al
  800de8:	74 2b                	je     800e15 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dea:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800df0:	75 0f                	jne    800e01 <strtol+0x40>
  800df2:	80 39 30             	cmpb   $0x30,(%ecx)
  800df5:	74 28                	je     800e1f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800df7:	85 db                	test   %ebx,%ebx
  800df9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfe:	0f 44 d8             	cmove  %eax,%ebx
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
  800e06:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e09:	eb 50                	jmp    800e5b <strtol+0x9a>
		s++;
  800e0b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e0e:	bf 00 00 00 00       	mov    $0x0,%edi
  800e13:	eb d5                	jmp    800dea <strtol+0x29>
		s++, neg = 1;
  800e15:	83 c1 01             	add    $0x1,%ecx
  800e18:	bf 01 00 00 00       	mov    $0x1,%edi
  800e1d:	eb cb                	jmp    800dea <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e23:	74 0e                	je     800e33 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e25:	85 db                	test   %ebx,%ebx
  800e27:	75 d8                	jne    800e01 <strtol+0x40>
		s++, base = 8;
  800e29:	83 c1 01             	add    $0x1,%ecx
  800e2c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e31:	eb ce                	jmp    800e01 <strtol+0x40>
		s += 2, base = 16;
  800e33:	83 c1 02             	add    $0x2,%ecx
  800e36:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e3b:	eb c4                	jmp    800e01 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e3d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e40:	89 f3                	mov    %esi,%ebx
  800e42:	80 fb 19             	cmp    $0x19,%bl
  800e45:	77 29                	ja     800e70 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e47:	0f be d2             	movsbl %dl,%edx
  800e4a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e4d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e50:	7d 30                	jge    800e82 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e52:	83 c1 01             	add    $0x1,%ecx
  800e55:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e59:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e5b:	0f b6 11             	movzbl (%ecx),%edx
  800e5e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e61:	89 f3                	mov    %esi,%ebx
  800e63:	80 fb 09             	cmp    $0x9,%bl
  800e66:	77 d5                	ja     800e3d <strtol+0x7c>
			dig = *s - '0';
  800e68:	0f be d2             	movsbl %dl,%edx
  800e6b:	83 ea 30             	sub    $0x30,%edx
  800e6e:	eb dd                	jmp    800e4d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e70:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e73:	89 f3                	mov    %esi,%ebx
  800e75:	80 fb 19             	cmp    $0x19,%bl
  800e78:	77 08                	ja     800e82 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e7a:	0f be d2             	movsbl %dl,%edx
  800e7d:	83 ea 37             	sub    $0x37,%edx
  800e80:	eb cb                	jmp    800e4d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e86:	74 05                	je     800e8d <strtol+0xcc>
		*endptr = (char *) s;
  800e88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e8b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e8d:	89 c2                	mov    %eax,%edx
  800e8f:	f7 da                	neg    %edx
  800e91:	85 ff                	test   %edi,%edi
  800e93:	0f 45 c2             	cmovne %edx,%eax
}
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	89 c3                	mov    %eax,%ebx
  800eae:	89 c7                	mov    %eax,%edi
  800eb0:	89 c6                	mov    %eax,%esi
  800eb2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec9:	89 d1                	mov    %edx,%ecx
  800ecb:	89 d3                	mov    %edx,%ebx
  800ecd:	89 d7                	mov    %edx,%edi
  800ecf:	89 d6                	mov    %edx,%esi
  800ed1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	b8 03 00 00 00       	mov    $0x3,%eax
  800eee:	89 cb                	mov    %ecx,%ebx
  800ef0:	89 cf                	mov    %ecx,%edi
  800ef2:	89 ce                	mov    %ecx,%esi
  800ef4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	7f 08                	jg     800f02 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f02:	83 ec 0c             	sub    $0xc,%esp
  800f05:	50                   	push   %eax
  800f06:	6a 03                	push   $0x3
  800f08:	68 c8 31 80 00       	push   $0x8031c8
  800f0d:	6a 43                	push   $0x43
  800f0f:	68 e5 31 80 00       	push   $0x8031e5
  800f14:	e8 f7 f3 ff ff       	call   800310 <_panic>

00800f19 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	b8 02 00 00 00       	mov    $0x2,%eax
  800f29:	89 d1                	mov    %edx,%ecx
  800f2b:	89 d3                	mov    %edx,%ebx
  800f2d:	89 d7                	mov    %edx,%edi
  800f2f:	89 d6                	mov    %edx,%esi
  800f31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_yield>:

void
sys_yield(void)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f43:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f48:	89 d1                	mov    %edx,%ecx
  800f4a:	89 d3                	mov    %edx,%ebx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	89 d6                	mov    %edx,%esi
  800f50:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
  800f5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f60:	be 00 00 00 00       	mov    $0x0,%esi
  800f65:	8b 55 08             	mov    0x8(%ebp),%edx
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	b8 04 00 00 00       	mov    $0x4,%eax
  800f70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f73:	89 f7                	mov    %esi,%edi
  800f75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7f 08                	jg     800f83 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	50                   	push   %eax
  800f87:	6a 04                	push   $0x4
  800f89:	68 c8 31 80 00       	push   $0x8031c8
  800f8e:	6a 43                	push   $0x43
  800f90:	68 e5 31 80 00       	push   $0x8031e5
  800f95:	e8 76 f3 ff ff       	call   800310 <_panic>

00800f9a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
  800fa0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa9:	b8 05 00 00 00       	mov    $0x5,%eax
  800fae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fb4:	8b 75 18             	mov    0x18(%ebp),%esi
  800fb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7f 08                	jg     800fc5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	50                   	push   %eax
  800fc9:	6a 05                	push   $0x5
  800fcb:	68 c8 31 80 00       	push   $0x8031c8
  800fd0:	6a 43                	push   $0x43
  800fd2:	68 e5 31 80 00       	push   $0x8031e5
  800fd7:	e8 34 f3 ff ff       	call   800310 <_panic>

00800fdc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
  800fe2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ff5:	89 df                	mov    %ebx,%edi
  800ff7:	89 de                	mov    %ebx,%esi
  800ff9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	7f 08                	jg     801007 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	50                   	push   %eax
  80100b:	6a 06                	push   $0x6
  80100d:	68 c8 31 80 00       	push   $0x8031c8
  801012:	6a 43                	push   $0x43
  801014:	68 e5 31 80 00       	push   $0x8031e5
  801019:	e8 f2 f2 ff ff       	call   800310 <_panic>

0080101e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801027:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	b8 08 00 00 00       	mov    $0x8,%eax
  801037:	89 df                	mov    %ebx,%edi
  801039:	89 de                	mov    %ebx,%esi
  80103b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	7f 08                	jg     801049 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	50                   	push   %eax
  80104d:	6a 08                	push   $0x8
  80104f:	68 c8 31 80 00       	push   $0x8031c8
  801054:	6a 43                	push   $0x43
  801056:	68 e5 31 80 00       	push   $0x8031e5
  80105b:	e8 b0 f2 ff ff       	call   800310 <_panic>

00801060 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
  801066:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	b8 09 00 00 00       	mov    $0x9,%eax
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107f:	85 c0                	test   %eax,%eax
  801081:	7f 08                	jg     80108b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801083:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108b:	83 ec 0c             	sub    $0xc,%esp
  80108e:	50                   	push   %eax
  80108f:	6a 09                	push   $0x9
  801091:	68 c8 31 80 00       	push   $0x8031c8
  801096:	6a 43                	push   $0x43
  801098:	68 e5 31 80 00       	push   $0x8031e5
  80109d:	e8 6e f2 ff ff       	call   800310 <_panic>

008010a2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	57                   	push   %edi
  8010a6:	56                   	push   %esi
  8010a7:	53                   	push   %ebx
  8010a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010bb:	89 df                	mov    %ebx,%edi
  8010bd:	89 de                	mov    %ebx,%esi
  8010bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7f 08                	jg     8010cd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	50                   	push   %eax
  8010d1:	6a 0a                	push   $0xa
  8010d3:	68 c8 31 80 00       	push   $0x8031c8
  8010d8:	6a 43                	push   $0x43
  8010da:	68 e5 31 80 00       	push   $0x8031e5
  8010df:	e8 2c f2 ff ff       	call   800310 <_panic>

008010e4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	57                   	push   %edi
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f0:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010f5:	be 00 00 00 00       	mov    $0x0,%esi
  8010fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010fd:	8b 7d 14             	mov    0x14(%ebp),%edi
  801100:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801110:	b9 00 00 00 00       	mov    $0x0,%ecx
  801115:	8b 55 08             	mov    0x8(%ebp),%edx
  801118:	b8 0d 00 00 00       	mov    $0xd,%eax
  80111d:	89 cb                	mov    %ecx,%ebx
  80111f:	89 cf                	mov    %ecx,%edi
  801121:	89 ce                	mov    %ecx,%esi
  801123:	cd 30                	int    $0x30
	if(check && ret > 0)
  801125:	85 c0                	test   %eax,%eax
  801127:	7f 08                	jg     801131 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801129:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	50                   	push   %eax
  801135:	6a 0d                	push   $0xd
  801137:	68 c8 31 80 00       	push   $0x8031c8
  80113c:	6a 43                	push   $0x43
  80113e:	68 e5 31 80 00       	push   $0x8031e5
  801143:	e8 c8 f1 ff ff       	call   800310 <_panic>

00801148 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	57                   	push   %edi
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	b8 0e 00 00 00       	mov    $0xe,%eax
  80115e:	89 df                	mov    %ebx,%edi
  801160:	89 de                	mov    %ebx,%esi
  801162:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	b8 0f 00 00 00       	mov    $0xf,%eax
  80117c:	89 cb                	mov    %ecx,%ebx
  80117e:	89 cf                	mov    %ecx,%edi
  801180:	89 ce                	mov    %ecx,%esi
  801182:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801184:	5b                   	pop    %ebx
  801185:	5e                   	pop    %esi
  801186:	5f                   	pop    %edi
  801187:	5d                   	pop    %ebp
  801188:	c3                   	ret    

00801189 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	57                   	push   %edi
  80118d:	56                   	push   %esi
  80118e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118f:	ba 00 00 00 00       	mov    $0x0,%edx
  801194:	b8 10 00 00 00       	mov    $0x10,%eax
  801199:	89 d1                	mov    %edx,%ecx
  80119b:	89 d3                	mov    %edx,%ebx
  80119d:	89 d7                	mov    %edx,%edi
  80119f:	89 d6                	mov    %edx,%esi
  8011a1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011a3:	5b                   	pop    %ebx
  8011a4:	5e                   	pop    %esi
  8011a5:	5f                   	pop    %edi
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    

008011a8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	57                   	push   %edi
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b9:	b8 11 00 00 00       	mov    $0x11,%eax
  8011be:	89 df                	mov    %ebx,%edi
  8011c0:	89 de                	mov    %ebx,%esi
  8011c2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011c4:	5b                   	pop    %ebx
  8011c5:	5e                   	pop    %esi
  8011c6:	5f                   	pop    %edi
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011da:	b8 12 00 00 00       	mov    $0x12,%eax
  8011df:	89 df                	mov    %ebx,%edi
  8011e1:	89 de                	mov    %ebx,%esi
  8011e3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	57                   	push   %edi
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 13 00 00 00       	mov    $0x13,%eax
  801203:	89 df                	mov    %ebx,%edi
  801205:	89 de                	mov    %ebx,%esi
  801207:	cd 30                	int    $0x30
	if(check && ret > 0)
  801209:	85 c0                	test   %eax,%eax
  80120b:	7f 08                	jg     801215 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80120d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	50                   	push   %eax
  801219:	6a 13                	push   $0x13
  80121b:	68 c8 31 80 00       	push   $0x8031c8
  801220:	6a 43                	push   $0x43
  801222:	68 e5 31 80 00       	push   $0x8031e5
  801227:	e8 e4 f0 ff ff       	call   800310 <_panic>

0080122c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
	asm volatile("int %1\n"
  801232:	b9 00 00 00 00       	mov    $0x0,%ecx
  801237:	8b 55 08             	mov    0x8(%ebp),%edx
  80123a:	b8 14 00 00 00       	mov    $0x14,%eax
  80123f:	89 cb                	mov    %ecx,%ebx
  801241:	89 cf                	mov    %ecx,%edi
  801243:	89 ce                	mov    %ecx,%esi
  801245:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	53                   	push   %ebx
  801250:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801253:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80125a:	f6 c5 04             	test   $0x4,%ch
  80125d:	75 45                	jne    8012a4 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80125f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801266:	83 e1 07             	and    $0x7,%ecx
  801269:	83 f9 07             	cmp    $0x7,%ecx
  80126c:	74 6f                	je     8012dd <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80126e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801275:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80127b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801281:	0f 84 b6 00 00 00    	je     80133d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801287:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80128e:	83 e1 05             	and    $0x5,%ecx
  801291:	83 f9 05             	cmp    $0x5,%ecx
  801294:	0f 84 d7 00 00 00    	je     801371 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80129a:	b8 00 00 00 00       	mov    $0x0,%eax
  80129f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012a4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ab:	c1 e2 0c             	shl    $0xc,%edx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012b7:	51                   	push   %ecx
  8012b8:	52                   	push   %edx
  8012b9:	50                   	push   %eax
  8012ba:	52                   	push   %edx
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 d8 fc ff ff       	call   800f9a <sys_page_map>
		if(r < 0)
  8012c2:	83 c4 20             	add    $0x20,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	79 d1                	jns    80129a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	68 f3 31 80 00       	push   $0x8031f3
  8012d1:	6a 54                	push   $0x54
  8012d3:	68 09 32 80 00       	push   $0x803209
  8012d8:	e8 33 f0 ff ff       	call   800310 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012dd:	89 d3                	mov    %edx,%ebx
  8012df:	c1 e3 0c             	shl    $0xc,%ebx
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 05 08 00 00       	push   $0x805
  8012ea:	53                   	push   %ebx
  8012eb:	50                   	push   %eax
  8012ec:	53                   	push   %ebx
  8012ed:	6a 00                	push   $0x0
  8012ef:	e8 a6 fc ff ff       	call   800f9a <sys_page_map>
		if(r < 0)
  8012f4:	83 c4 20             	add    $0x20,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 2e                	js     801329 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	68 05 08 00 00       	push   $0x805
  801303:	53                   	push   %ebx
  801304:	6a 00                	push   $0x0
  801306:	53                   	push   %ebx
  801307:	6a 00                	push   $0x0
  801309:	e8 8c fc ff ff       	call   800f9a <sys_page_map>
		if(r < 0)
  80130e:	83 c4 20             	add    $0x20,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	79 85                	jns    80129a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	68 f3 31 80 00       	push   $0x8031f3
  80131d:	6a 5f                	push   $0x5f
  80131f:	68 09 32 80 00       	push   $0x803209
  801324:	e8 e7 ef ff ff       	call   800310 <_panic>
			panic("sys_page_map() panic\n");
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	68 f3 31 80 00       	push   $0x8031f3
  801331:	6a 5b                	push   $0x5b
  801333:	68 09 32 80 00       	push   $0x803209
  801338:	e8 d3 ef ff ff       	call   800310 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80133d:	c1 e2 0c             	shl    $0xc,%edx
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	68 05 08 00 00       	push   $0x805
  801348:	52                   	push   %edx
  801349:	50                   	push   %eax
  80134a:	52                   	push   %edx
  80134b:	6a 00                	push   $0x0
  80134d:	e8 48 fc ff ff       	call   800f9a <sys_page_map>
		if(r < 0)
  801352:	83 c4 20             	add    $0x20,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	0f 89 3d ff ff ff    	jns    80129a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	68 f3 31 80 00       	push   $0x8031f3
  801365:	6a 66                	push   $0x66
  801367:	68 09 32 80 00       	push   $0x803209
  80136c:	e8 9f ef ff ff       	call   800310 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801371:	c1 e2 0c             	shl    $0xc,%edx
  801374:	83 ec 0c             	sub    $0xc,%esp
  801377:	6a 05                	push   $0x5
  801379:	52                   	push   %edx
  80137a:	50                   	push   %eax
  80137b:	52                   	push   %edx
  80137c:	6a 00                	push   $0x0
  80137e:	e8 17 fc ff ff       	call   800f9a <sys_page_map>
		if(r < 0)
  801383:	83 c4 20             	add    $0x20,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	0f 89 0c ff ff ff    	jns    80129a <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80138e:	83 ec 04             	sub    $0x4,%esp
  801391:	68 f3 31 80 00       	push   $0x8031f3
  801396:	6a 6d                	push   $0x6d
  801398:	68 09 32 80 00       	push   $0x803209
  80139d:	e8 6e ef ff ff       	call   800310 <_panic>

008013a2 <pgfault>:
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	53                   	push   %ebx
  8013a6:	83 ec 04             	sub    $0x4,%esp
  8013a9:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013ac:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013ae:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013b2:	0f 84 99 00 00 00    	je     801451 <pgfault+0xaf>
  8013b8:	89 c2                	mov    %eax,%edx
  8013ba:	c1 ea 16             	shr    $0x16,%edx
  8013bd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013c4:	f6 c2 01             	test   $0x1,%dl
  8013c7:	0f 84 84 00 00 00    	je     801451 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	c1 ea 0c             	shr    $0xc,%edx
  8013d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d9:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013df:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013e5:	75 6a                	jne    801451 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ec:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	6a 07                	push   $0x7
  8013f3:	68 00 f0 7f 00       	push   $0x7ff000
  8013f8:	6a 00                	push   $0x0
  8013fa:	e8 58 fb ff ff       	call   800f57 <sys_page_alloc>
	if(ret < 0)
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 5f                	js     801465 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	68 00 10 00 00       	push   $0x1000
  80140e:	53                   	push   %ebx
  80140f:	68 00 f0 7f 00       	push   $0x7ff000
  801414:	e8 3c f9 ff ff       	call   800d55 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801419:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801420:	53                   	push   %ebx
  801421:	6a 00                	push   $0x0
  801423:	68 00 f0 7f 00       	push   $0x7ff000
  801428:	6a 00                	push   $0x0
  80142a:	e8 6b fb ff ff       	call   800f9a <sys_page_map>
	if(ret < 0)
  80142f:	83 c4 20             	add    $0x20,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	78 43                	js     801479 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	68 00 f0 7f 00       	push   $0x7ff000
  80143e:	6a 00                	push   $0x0
  801440:	e8 97 fb ff ff       	call   800fdc <sys_page_unmap>
	if(ret < 0)
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 41                	js     80148d <pgfault+0xeb>
}
  80144c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144f:	c9                   	leave  
  801450:	c3                   	ret    
		panic("panic at pgfault()\n");
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	68 14 32 80 00       	push   $0x803214
  801459:	6a 26                	push   $0x26
  80145b:	68 09 32 80 00       	push   $0x803209
  801460:	e8 ab ee ff ff       	call   800310 <_panic>
		panic("panic in sys_page_alloc()\n");
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	68 28 32 80 00       	push   $0x803228
  80146d:	6a 31                	push   $0x31
  80146f:	68 09 32 80 00       	push   $0x803209
  801474:	e8 97 ee ff ff       	call   800310 <_panic>
		panic("panic in sys_page_map()\n");
  801479:	83 ec 04             	sub    $0x4,%esp
  80147c:	68 43 32 80 00       	push   $0x803243
  801481:	6a 36                	push   $0x36
  801483:	68 09 32 80 00       	push   $0x803209
  801488:	e8 83 ee ff ff       	call   800310 <_panic>
		panic("panic in sys_page_unmap()\n");
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 5c 32 80 00       	push   $0x80325c
  801495:	6a 39                	push   $0x39
  801497:	68 09 32 80 00       	push   $0x803209
  80149c:	e8 6f ee ff ff       	call   800310 <_panic>

008014a1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	57                   	push   %edi
  8014a5:	56                   	push   %esi
  8014a6:	53                   	push   %ebx
  8014a7:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014aa:	68 a2 13 80 00       	push   $0x8013a2
  8014af:	e8 16 15 00 00       	call   8029ca <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014b4:	b8 07 00 00 00       	mov    $0x7,%eax
  8014b9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 2a                	js     8014ec <fork+0x4b>
  8014c2:	89 c6                	mov    %eax,%esi
  8014c4:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014c6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014cb:	75 4b                	jne    801518 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014cd:	e8 47 fa ff ff       	call   800f19 <sys_getenvid>
  8014d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014d7:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8014dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014e2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014e7:	e9 90 00 00 00       	jmp    80157c <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	68 78 32 80 00       	push   $0x803278
  8014f4:	68 8c 00 00 00       	push   $0x8c
  8014f9:	68 09 32 80 00       	push   $0x803209
  8014fe:	e8 0d ee ff ff       	call   800310 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801503:	89 f8                	mov    %edi,%eax
  801505:	e8 42 fd ff ff       	call   80124c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80150a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801510:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801516:	74 26                	je     80153e <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801518:	89 d8                	mov    %ebx,%eax
  80151a:	c1 e8 16             	shr    $0x16,%eax
  80151d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801524:	a8 01                	test   $0x1,%al
  801526:	74 e2                	je     80150a <fork+0x69>
  801528:	89 da                	mov    %ebx,%edx
  80152a:	c1 ea 0c             	shr    $0xc,%edx
  80152d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801534:	83 e0 05             	and    $0x5,%eax
  801537:	83 f8 05             	cmp    $0x5,%eax
  80153a:	75 ce                	jne    80150a <fork+0x69>
  80153c:	eb c5                	jmp    801503 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	6a 07                	push   $0x7
  801543:	68 00 f0 bf ee       	push   $0xeebff000
  801548:	56                   	push   %esi
  801549:	e8 09 fa ff ff       	call   800f57 <sys_page_alloc>
	if(ret < 0)
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 31                	js     801586 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	68 39 2a 80 00       	push   $0x802a39
  80155d:	56                   	push   %esi
  80155e:	e8 3f fb ff ff       	call   8010a2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	85 c0                	test   %eax,%eax
  801568:	78 33                	js     80159d <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	6a 02                	push   $0x2
  80156f:	56                   	push   %esi
  801570:	e8 a9 fa ff ff       	call   80101e <sys_env_set_status>
	if(ret < 0)
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	78 38                	js     8015b4 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80157c:	89 f0                	mov    %esi,%eax
  80157e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 28 32 80 00       	push   $0x803228
  80158e:	68 98 00 00 00       	push   $0x98
  801593:	68 09 32 80 00       	push   $0x803209
  801598:	e8 73 ed ff ff       	call   800310 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	68 9c 32 80 00       	push   $0x80329c
  8015a5:	68 9b 00 00 00       	push   $0x9b
  8015aa:	68 09 32 80 00       	push   $0x803209
  8015af:	e8 5c ed ff ff       	call   800310 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 c4 32 80 00       	push   $0x8032c4
  8015bc:	68 9e 00 00 00       	push   $0x9e
  8015c1:	68 09 32 80 00       	push   $0x803209
  8015c6:	e8 45 ed ff ff       	call   800310 <_panic>

008015cb <sfork>:

// Challenge!
int
sfork(void)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	57                   	push   %edi
  8015cf:	56                   	push   %esi
  8015d0:	53                   	push   %ebx
  8015d1:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8015d4:	68 a2 13 80 00       	push   $0x8013a2
  8015d9:	e8 ec 13 00 00       	call   8029ca <set_pgfault_handler>
  8015de:	b8 07 00 00 00       	mov    $0x7,%eax
  8015e3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 2a                	js     801616 <sfork+0x4b>
  8015ec:	89 c7                	mov    %eax,%edi
  8015ee:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015f0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015f5:	75 58                	jne    80164f <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015f7:	e8 1d f9 ff ff       	call   800f19 <sys_getenvid>
  8015fc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801601:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801607:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80160c:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801611:	e9 d4 00 00 00       	jmp    8016ea <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 78 32 80 00       	push   $0x803278
  80161e:	68 af 00 00 00       	push   $0xaf
  801623:	68 09 32 80 00       	push   $0x803209
  801628:	e8 e3 ec ff ff       	call   800310 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80162d:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801632:	89 f0                	mov    %esi,%eax
  801634:	e8 13 fc ff ff       	call   80124c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80163f:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801645:	77 65                	ja     8016ac <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801647:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80164d:	74 de                	je     80162d <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	c1 e8 16             	shr    $0x16,%eax
  801654:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80165b:	a8 01                	test   $0x1,%al
  80165d:	74 da                	je     801639 <sfork+0x6e>
  80165f:	89 da                	mov    %ebx,%edx
  801661:	c1 ea 0c             	shr    $0xc,%edx
  801664:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80166b:	83 e0 05             	and    $0x5,%eax
  80166e:	83 f8 05             	cmp    $0x5,%eax
  801671:	75 c6                	jne    801639 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801673:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80167a:	c1 e2 0c             	shl    $0xc,%edx
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	83 e0 07             	and    $0x7,%eax
  801683:	50                   	push   %eax
  801684:	52                   	push   %edx
  801685:	56                   	push   %esi
  801686:	52                   	push   %edx
  801687:	6a 00                	push   $0x0
  801689:	e8 0c f9 ff ff       	call   800f9a <sys_page_map>
  80168e:	83 c4 20             	add    $0x20,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	74 a4                	je     801639 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	68 f3 31 80 00       	push   $0x8031f3
  80169d:	68 ba 00 00 00       	push   $0xba
  8016a2:	68 09 32 80 00       	push   $0x803209
  8016a7:	e8 64 ec ff ff       	call   800310 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	6a 07                	push   $0x7
  8016b1:	68 00 f0 bf ee       	push   $0xeebff000
  8016b6:	57                   	push   %edi
  8016b7:	e8 9b f8 ff ff       	call   800f57 <sys_page_alloc>
	if(ret < 0)
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 31                	js     8016f4 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	68 39 2a 80 00       	push   $0x802a39
  8016cb:	57                   	push   %edi
  8016cc:	e8 d1 f9 ff ff       	call   8010a2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	78 33                	js     80170b <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	6a 02                	push   $0x2
  8016dd:	57                   	push   %edi
  8016de:	e8 3b f9 ff ff       	call   80101e <sys_env_set_status>
	if(ret < 0)
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 38                	js     801722 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016ea:	89 f8                	mov    %edi,%eax
  8016ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5f                   	pop    %edi
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 28 32 80 00       	push   $0x803228
  8016fc:	68 c0 00 00 00       	push   $0xc0
  801701:	68 09 32 80 00       	push   $0x803209
  801706:	e8 05 ec ff ff       	call   800310 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	68 9c 32 80 00       	push   $0x80329c
  801713:	68 c3 00 00 00       	push   $0xc3
  801718:	68 09 32 80 00       	push   $0x803209
  80171d:	e8 ee eb ff ff       	call   800310 <_panic>
		panic("panic in sys_env_set_status()\n");
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	68 c4 32 80 00       	push   $0x8032c4
  80172a:	68 c6 00 00 00       	push   $0xc6
  80172f:	68 09 32 80 00       	push   $0x803209
  801734:	e8 d7 eb ff ff       	call   800310 <_panic>

00801739 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
  80173e:	8b 75 08             	mov    0x8(%ebp),%esi
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801747:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801749:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80174e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	50                   	push   %eax
  801755:	e8 ad f9 ff ff       	call   801107 <sys_ipc_recv>
	if(ret < 0){
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 2b                	js     80178c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801761:	85 f6                	test   %esi,%esi
  801763:	74 0a                	je     80176f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801765:	a1 08 50 80 00       	mov    0x805008,%eax
  80176a:	8b 40 78             	mov    0x78(%eax),%eax
  80176d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80176f:	85 db                	test   %ebx,%ebx
  801771:	74 0a                	je     80177d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801773:	a1 08 50 80 00       	mov    0x805008,%eax
  801778:	8b 40 7c             	mov    0x7c(%eax),%eax
  80177b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80177d:	a1 08 50 80 00       	mov    0x805008,%eax
  801782:	8b 40 74             	mov    0x74(%eax),%eax
}
  801785:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
		if(from_env_store)
  80178c:	85 f6                	test   %esi,%esi
  80178e:	74 06                	je     801796 <ipc_recv+0x5d>
			*from_env_store = 0;
  801790:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801796:	85 db                	test   %ebx,%ebx
  801798:	74 eb                	je     801785 <ipc_recv+0x4c>
			*perm_store = 0;
  80179a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8017a0:	eb e3                	jmp    801785 <ipc_recv+0x4c>

008017a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	57                   	push   %edi
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8017b4:	85 db                	test   %ebx,%ebx
  8017b6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8017bb:	0f 44 d8             	cmove  %eax,%ebx
  8017be:	eb 05                	jmp    8017c5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8017c0:	e8 73 f7 ff ff       	call   800f38 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8017c5:	ff 75 14             	pushl  0x14(%ebp)
  8017c8:	53                   	push   %ebx
  8017c9:	56                   	push   %esi
  8017ca:	57                   	push   %edi
  8017cb:	e8 14 f9 ff ff       	call   8010e4 <sys_ipc_try_send>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 1b                	je     8017f2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8017d7:	79 e7                	jns    8017c0 <ipc_send+0x1e>
  8017d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017dc:	74 e2                	je     8017c0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	68 e3 32 80 00       	push   $0x8032e3
  8017e6:	6a 46                	push   $0x46
  8017e8:	68 f8 32 80 00       	push   $0x8032f8
  8017ed:	e8 1e eb ff ff       	call   800310 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8017f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f5:	5b                   	pop    %ebx
  8017f6:	5e                   	pop    %esi
  8017f7:	5f                   	pop    %edi
  8017f8:	5d                   	pop    %ebp
  8017f9:	c3                   	ret    

008017fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801805:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80180b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801811:	8b 52 50             	mov    0x50(%edx),%edx
  801814:	39 ca                	cmp    %ecx,%edx
  801816:	74 11                	je     801829 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801818:	83 c0 01             	add    $0x1,%eax
  80181b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801820:	75 e3                	jne    801805 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	eb 0e                	jmp    801837 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801829:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80182f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801834:	8b 40 48             	mov    0x48(%eax),%eax
}
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	05 00 00 00 30       	add    $0x30000000,%eax
  801844:	c1 e8 0c             	shr    $0xc,%eax
}
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801859:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801868:	89 c2                	mov    %eax,%edx
  80186a:	c1 ea 16             	shr    $0x16,%edx
  80186d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801874:	f6 c2 01             	test   $0x1,%dl
  801877:	74 2d                	je     8018a6 <fd_alloc+0x46>
  801879:	89 c2                	mov    %eax,%edx
  80187b:	c1 ea 0c             	shr    $0xc,%edx
  80187e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801885:	f6 c2 01             	test   $0x1,%dl
  801888:	74 1c                	je     8018a6 <fd_alloc+0x46>
  80188a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80188f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801894:	75 d2                	jne    801868 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80189f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8018a4:	eb 0a                	jmp    8018b0 <fd_alloc+0x50>
			*fd_store = fd;
  8018a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    

008018b2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018b8:	83 f8 1f             	cmp    $0x1f,%eax
  8018bb:	77 30                	ja     8018ed <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018bd:	c1 e0 0c             	shl    $0xc,%eax
  8018c0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018c5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8018cb:	f6 c2 01             	test   $0x1,%dl
  8018ce:	74 24                	je     8018f4 <fd_lookup+0x42>
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	c1 ea 0c             	shr    $0xc,%edx
  8018d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018dc:	f6 c2 01             	test   $0x1,%dl
  8018df:	74 1a                	je     8018fb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	89 02                	mov    %eax,(%edx)
	return 0;
  8018e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    
		return -E_INVAL;
  8018ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f2:	eb f7                	jmp    8018eb <fd_lookup+0x39>
		return -E_INVAL;
  8018f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f9:	eb f0                	jmp    8018eb <fd_lookup+0x39>
  8018fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801900:	eb e9                	jmp    8018eb <fd_lookup+0x39>

00801902 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801915:	39 08                	cmp    %ecx,(%eax)
  801917:	74 38                	je     801951 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801919:	83 c2 01             	add    $0x1,%edx
  80191c:	8b 04 95 80 33 80 00 	mov    0x803380(,%edx,4),%eax
  801923:	85 c0                	test   %eax,%eax
  801925:	75 ee                	jne    801915 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801927:	a1 08 50 80 00       	mov    0x805008,%eax
  80192c:	8b 40 48             	mov    0x48(%eax),%eax
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	51                   	push   %ecx
  801933:	50                   	push   %eax
  801934:	68 04 33 80 00       	push   $0x803304
  801939:	e8 c8 ea ff ff       	call   800406 <cprintf>
	*dev = 0;
  80193e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    
			*dev = devtab[i];
  801951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801954:	89 01                	mov    %eax,(%ecx)
			return 0;
  801956:	b8 00 00 00 00       	mov    $0x0,%eax
  80195b:	eb f2                	jmp    80194f <dev_lookup+0x4d>

0080195d <fd_close>:
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	57                   	push   %edi
  801961:	56                   	push   %esi
  801962:	53                   	push   %ebx
  801963:	83 ec 24             	sub    $0x24,%esp
  801966:	8b 75 08             	mov    0x8(%ebp),%esi
  801969:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80196c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80196f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801970:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801976:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801979:	50                   	push   %eax
  80197a:	e8 33 ff ff ff       	call   8018b2 <fd_lookup>
  80197f:	89 c3                	mov    %eax,%ebx
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	78 05                	js     80198d <fd_close+0x30>
	    || fd != fd2)
  801988:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80198b:	74 16                	je     8019a3 <fd_close+0x46>
		return (must_exist ? r : 0);
  80198d:	89 f8                	mov    %edi,%eax
  80198f:	84 c0                	test   %al,%al
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
  801996:	0f 44 d8             	cmove  %eax,%ebx
}
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	ff 36                	pushl  (%esi)
  8019ac:	e8 51 ff ff ff       	call   801902 <dev_lookup>
  8019b1:	89 c3                	mov    %eax,%ebx
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 1a                	js     8019d4 <fd_close+0x77>
		if (dev->dev_close)
  8019ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8019c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	74 0b                	je     8019d4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	56                   	push   %esi
  8019cd:	ff d0                	call   *%eax
  8019cf:	89 c3                	mov    %eax,%ebx
  8019d1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	56                   	push   %esi
  8019d8:	6a 00                	push   $0x0
  8019da:	e8 fd f5 ff ff       	call   800fdc <sys_page_unmap>
	return r;
  8019df:	83 c4 10             	add    $0x10,%esp
  8019e2:	eb b5                	jmp    801999 <fd_close+0x3c>

008019e4 <close>:

int
close(int fdnum)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ed:	50                   	push   %eax
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	e8 bc fe ff ff       	call   8018b2 <fd_lookup>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	79 02                	jns    8019ff <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    
		return fd_close(fd, 1);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	6a 01                	push   $0x1
  801a04:	ff 75 f4             	pushl  -0xc(%ebp)
  801a07:	e8 51 ff ff ff       	call   80195d <fd_close>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	eb ec                	jmp    8019fd <close+0x19>

00801a11 <close_all>:

void
close_all(void)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	53                   	push   %ebx
  801a15:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a18:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	53                   	push   %ebx
  801a21:	e8 be ff ff ff       	call   8019e4 <close>
	for (i = 0; i < MAXFD; i++)
  801a26:	83 c3 01             	add    $0x1,%ebx
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	83 fb 20             	cmp    $0x20,%ebx
  801a2f:	75 ec                	jne    801a1d <close_all+0xc>
}
  801a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	57                   	push   %edi
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
  801a3c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a42:	50                   	push   %eax
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	e8 67 fe ff ff       	call   8018b2 <fd_lookup>
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	0f 88 81 00 00 00    	js     801ad9 <dup+0xa3>
		return r;
	close(newfdnum);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	e8 81 ff ff ff       	call   8019e4 <close>

	newfd = INDEX2FD(newfdnum);
  801a63:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a66:	c1 e6 0c             	shl    $0xc,%esi
  801a69:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a6f:	83 c4 04             	add    $0x4,%esp
  801a72:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a75:	e8 cf fd ff ff       	call   801849 <fd2data>
  801a7a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a7c:	89 34 24             	mov    %esi,(%esp)
  801a7f:	e8 c5 fd ff ff       	call   801849 <fd2data>
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a89:	89 d8                	mov    %ebx,%eax
  801a8b:	c1 e8 16             	shr    $0x16,%eax
  801a8e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a95:	a8 01                	test   $0x1,%al
  801a97:	74 11                	je     801aaa <dup+0x74>
  801a99:	89 d8                	mov    %ebx,%eax
  801a9b:	c1 e8 0c             	shr    $0xc,%eax
  801a9e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801aa5:	f6 c2 01             	test   $0x1,%dl
  801aa8:	75 39                	jne    801ae3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	c1 e8 0c             	shr    $0xc,%eax
  801ab2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	25 07 0e 00 00       	and    $0xe07,%eax
  801ac1:	50                   	push   %eax
  801ac2:	56                   	push   %esi
  801ac3:	6a 00                	push   $0x0
  801ac5:	52                   	push   %edx
  801ac6:	6a 00                	push   $0x0
  801ac8:	e8 cd f4 ff ff       	call   800f9a <sys_page_map>
  801acd:	89 c3                	mov    %eax,%ebx
  801acf:	83 c4 20             	add    $0x20,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 31                	js     801b07 <dup+0xd1>
		goto err;

	return newfdnum;
  801ad6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ade:	5b                   	pop    %ebx
  801adf:	5e                   	pop    %esi
  801ae0:	5f                   	pop    %edi
  801ae1:	5d                   	pop    %ebp
  801ae2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ae3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	25 07 0e 00 00       	and    $0xe07,%eax
  801af2:	50                   	push   %eax
  801af3:	57                   	push   %edi
  801af4:	6a 00                	push   $0x0
  801af6:	53                   	push   %ebx
  801af7:	6a 00                	push   $0x0
  801af9:	e8 9c f4 ff ff       	call   800f9a <sys_page_map>
  801afe:	89 c3                	mov    %eax,%ebx
  801b00:	83 c4 20             	add    $0x20,%esp
  801b03:	85 c0                	test   %eax,%eax
  801b05:	79 a3                	jns    801aaa <dup+0x74>
	sys_page_unmap(0, newfd);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	56                   	push   %esi
  801b0b:	6a 00                	push   $0x0
  801b0d:	e8 ca f4 ff ff       	call   800fdc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b12:	83 c4 08             	add    $0x8,%esp
  801b15:	57                   	push   %edi
  801b16:	6a 00                	push   $0x0
  801b18:	e8 bf f4 ff ff       	call   800fdc <sys_page_unmap>
	return r;
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	eb b7                	jmp    801ad9 <dup+0xa3>

00801b22 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	53                   	push   %ebx
  801b26:	83 ec 1c             	sub    $0x1c,%esp
  801b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	53                   	push   %ebx
  801b31:	e8 7c fd ff ff       	call   8018b2 <fd_lookup>
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 3f                	js     801b7c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b43:	50                   	push   %eax
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b47:	ff 30                	pushl  (%eax)
  801b49:	e8 b4 fd ff ff       	call   801902 <dev_lookup>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 27                	js     801b7c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 42 08             	mov    0x8(%edx),%eax
  801b5b:	83 e0 03             	and    $0x3,%eax
  801b5e:	83 f8 01             	cmp    $0x1,%eax
  801b61:	74 1e                	je     801b81 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b66:	8b 40 08             	mov    0x8(%eax),%eax
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	74 35                	je     801ba2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	ff 75 10             	pushl  0x10(%ebp)
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	52                   	push   %edx
  801b77:	ff d0                	call   *%eax
  801b79:	83 c4 10             	add    $0x10,%esp
}
  801b7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b81:	a1 08 50 80 00       	mov    0x805008,%eax
  801b86:	8b 40 48             	mov    0x48(%eax),%eax
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	53                   	push   %ebx
  801b8d:	50                   	push   %eax
  801b8e:	68 45 33 80 00       	push   $0x803345
  801b93:	e8 6e e8 ff ff       	call   800406 <cprintf>
		return -E_INVAL;
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba0:	eb da                	jmp    801b7c <read+0x5a>
		return -E_NOT_SUPP;
  801ba2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba7:	eb d3                	jmp    801b7c <read+0x5a>

00801ba9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	57                   	push   %edi
  801bad:	56                   	push   %esi
  801bae:	53                   	push   %ebx
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bb5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bbd:	39 f3                	cmp    %esi,%ebx
  801bbf:	73 23                	jae    801be4 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	89 f0                	mov    %esi,%eax
  801bc6:	29 d8                	sub    %ebx,%eax
  801bc8:	50                   	push   %eax
  801bc9:	89 d8                	mov    %ebx,%eax
  801bcb:	03 45 0c             	add    0xc(%ebp),%eax
  801bce:	50                   	push   %eax
  801bcf:	57                   	push   %edi
  801bd0:	e8 4d ff ff ff       	call   801b22 <read>
		if (m < 0)
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 06                	js     801be2 <readn+0x39>
			return m;
		if (m == 0)
  801bdc:	74 06                	je     801be4 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801bde:	01 c3                	add    %eax,%ebx
  801be0:	eb db                	jmp    801bbd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 1c             	sub    $0x1c,%esp
  801bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfb:	50                   	push   %eax
  801bfc:	53                   	push   %ebx
  801bfd:	e8 b0 fc ff ff       	call   8018b2 <fd_lookup>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 3a                	js     801c43 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0f:	50                   	push   %eax
  801c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c13:	ff 30                	pushl  (%eax)
  801c15:	e8 e8 fc ff ff       	call   801902 <dev_lookup>
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	78 22                	js     801c43 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c24:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c28:	74 1e                	je     801c48 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c2d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c30:	85 d2                	test   %edx,%edx
  801c32:	74 35                	je     801c69 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	ff 75 10             	pushl  0x10(%ebp)
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	ff d2                	call   *%edx
  801c40:	83 c4 10             	add    $0x10,%esp
}
  801c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c48:	a1 08 50 80 00       	mov    0x805008,%eax
  801c4d:	8b 40 48             	mov    0x48(%eax),%eax
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	53                   	push   %ebx
  801c54:	50                   	push   %eax
  801c55:	68 61 33 80 00       	push   $0x803361
  801c5a:	e8 a7 e7 ff ff       	call   800406 <cprintf>
		return -E_INVAL;
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c67:	eb da                	jmp    801c43 <write+0x55>
		return -E_NOT_SUPP;
  801c69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c6e:	eb d3                	jmp    801c43 <write+0x55>

00801c70 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c79:	50                   	push   %eax
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	e8 30 fc ff ff       	call   8018b2 <fd_lookup>
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	85 c0                	test   %eax,%eax
  801c87:	78 0e                	js     801c97 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 1c             	sub    $0x1c,%esp
  801ca0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ca3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca6:	50                   	push   %eax
  801ca7:	53                   	push   %ebx
  801ca8:	e8 05 fc ff ff       	call   8018b2 <fd_lookup>
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	78 37                	js     801ceb <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cba:	50                   	push   %eax
  801cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbe:	ff 30                	pushl  (%eax)
  801cc0:	e8 3d fc ff ff       	call   801902 <dev_lookup>
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 1f                	js     801ceb <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cd3:	74 1b                	je     801cf0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd8:	8b 52 18             	mov    0x18(%edx),%edx
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	74 32                	je     801d11 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	50                   	push   %eax
  801ce6:	ff d2                	call   *%edx
  801ce8:	83 c4 10             	add    $0x10,%esp
}
  801ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    
			thisenv->env_id, fdnum);
  801cf0:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cf5:	8b 40 48             	mov    0x48(%eax),%eax
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	53                   	push   %ebx
  801cfc:	50                   	push   %eax
  801cfd:	68 24 33 80 00       	push   $0x803324
  801d02:	e8 ff e6 ff ff       	call   800406 <cprintf>
		return -E_INVAL;
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d0f:	eb da                	jmp    801ceb <ftruncate+0x52>
		return -E_NOT_SUPP;
  801d11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d16:	eb d3                	jmp    801ceb <ftruncate+0x52>

00801d18 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	53                   	push   %ebx
  801d1c:	83 ec 1c             	sub    $0x1c,%esp
  801d1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d22:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d25:	50                   	push   %eax
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 84 fb ff ff       	call   8018b2 <fd_lookup>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 4b                	js     801d80 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d35:	83 ec 08             	sub    $0x8,%esp
  801d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3b:	50                   	push   %eax
  801d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3f:	ff 30                	pushl  (%eax)
  801d41:	e8 bc fb ff ff       	call   801902 <dev_lookup>
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 33                	js     801d80 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d54:	74 2f                	je     801d85 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d56:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d59:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d60:	00 00 00 
	stat->st_isdir = 0;
  801d63:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d6a:	00 00 00 
	stat->st_dev = dev;
  801d6d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d73:	83 ec 08             	sub    $0x8,%esp
  801d76:	53                   	push   %ebx
  801d77:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7a:	ff 50 14             	call   *0x14(%eax)
  801d7d:	83 c4 10             	add    $0x10,%esp
}
  801d80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    
		return -E_NOT_SUPP;
  801d85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d8a:	eb f4                	jmp    801d80 <fstat+0x68>

00801d8c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d91:	83 ec 08             	sub    $0x8,%esp
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 08             	pushl  0x8(%ebp)
  801d99:	e8 22 02 00 00       	call   801fc0 <open>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 1b                	js     801dc2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801da7:	83 ec 08             	sub    $0x8,%esp
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	50                   	push   %eax
  801dae:	e8 65 ff ff ff       	call   801d18 <fstat>
  801db3:	89 c6                	mov    %eax,%esi
	close(fd);
  801db5:	89 1c 24             	mov    %ebx,(%esp)
  801db8:	e8 27 fc ff ff       	call   8019e4 <close>
	return r;
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	89 f3                	mov    %esi,%ebx
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	89 c6                	mov    %eax,%esi
  801dd2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801dd4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ddb:	74 27                	je     801e04 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ddd:	6a 07                	push   $0x7
  801ddf:	68 00 60 80 00       	push   $0x806000
  801de4:	56                   	push   %esi
  801de5:	ff 35 00 50 80 00    	pushl  0x805000
  801deb:	e8 b2 f9 ff ff       	call   8017a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801df0:	83 c4 0c             	add    $0xc,%esp
  801df3:	6a 00                	push   $0x0
  801df5:	53                   	push   %ebx
  801df6:	6a 00                	push   $0x0
  801df8:	e8 3c f9 ff ff       	call   801739 <ipc_recv>
}
  801dfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	6a 01                	push   $0x1
  801e09:	e8 ec f9 ff ff       	call   8017fa <ipc_find_env>
  801e0e:	a3 00 50 80 00       	mov    %eax,0x805000
  801e13:	83 c4 10             	add    $0x10,%esp
  801e16:	eb c5                	jmp    801ddd <fsipc+0x12>

00801e18 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	8b 40 0c             	mov    0xc(%eax),%eax
  801e24:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e31:	ba 00 00 00 00       	mov    $0x0,%edx
  801e36:	b8 02 00 00 00       	mov    $0x2,%eax
  801e3b:	e8 8b ff ff ff       	call   801dcb <fsipc>
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <devfile_flush>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e53:	ba 00 00 00 00       	mov    $0x0,%edx
  801e58:	b8 06 00 00 00       	mov    $0x6,%eax
  801e5d:	e8 69 ff ff ff       	call   801dcb <fsipc>
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <devfile_stat>:
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	53                   	push   %ebx
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	8b 40 0c             	mov    0xc(%eax),%eax
  801e74:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e79:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7e:	b8 05 00 00 00       	mov    $0x5,%eax
  801e83:	e8 43 ff ff ff       	call   801dcb <fsipc>
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	78 2c                	js     801eb8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e8c:	83 ec 08             	sub    $0x8,%esp
  801e8f:	68 00 60 80 00       	push   $0x806000
  801e94:	53                   	push   %ebx
  801e95:	e8 cb ec ff ff       	call   800b65 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e9a:	a1 80 60 80 00       	mov    0x806080,%eax
  801e9f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ea5:	a1 84 60 80 00       	mov    0x806084,%eax
  801eaa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <devfile_write>:
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	53                   	push   %ebx
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ed2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ed8:	53                   	push   %ebx
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	68 08 60 80 00       	push   $0x806008
  801ee1:	e8 6f ee ff ff       	call   800d55 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ee6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eeb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ef0:	e8 d6 fe ff ff       	call   801dcb <fsipc>
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	78 0b                	js     801f07 <devfile_write+0x4a>
	assert(r <= n);
  801efc:	39 d8                	cmp    %ebx,%eax
  801efe:	77 0c                	ja     801f0c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801f00:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f05:	7f 1e                	jg     801f25 <devfile_write+0x68>
}
  801f07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    
	assert(r <= n);
  801f0c:	68 94 33 80 00       	push   $0x803394
  801f11:	68 9b 33 80 00       	push   $0x80339b
  801f16:	68 98 00 00 00       	push   $0x98
  801f1b:	68 b0 33 80 00       	push   $0x8033b0
  801f20:	e8 eb e3 ff ff       	call   800310 <_panic>
	assert(r <= PGSIZE);
  801f25:	68 bb 33 80 00       	push   $0x8033bb
  801f2a:	68 9b 33 80 00       	push   $0x80339b
  801f2f:	68 99 00 00 00       	push   $0x99
  801f34:	68 b0 33 80 00       	push   $0x8033b0
  801f39:	e8 d2 e3 ff ff       	call   800310 <_panic>

00801f3e <devfile_read>:
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	56                   	push   %esi
  801f42:	53                   	push   %ebx
  801f43:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f51:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f61:	e8 65 fe ff ff       	call   801dcb <fsipc>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 1f                	js     801f8b <devfile_read+0x4d>
	assert(r <= n);
  801f6c:	39 f0                	cmp    %esi,%eax
  801f6e:	77 24                	ja     801f94 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f70:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f75:	7f 33                	jg     801faa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	50                   	push   %eax
  801f7b:	68 00 60 80 00       	push   $0x806000
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	e8 6b ed ff ff       	call   800cf3 <memmove>
	return r;
  801f88:	83 c4 10             	add    $0x10,%esp
}
  801f8b:	89 d8                	mov    %ebx,%eax
  801f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
	assert(r <= n);
  801f94:	68 94 33 80 00       	push   $0x803394
  801f99:	68 9b 33 80 00       	push   $0x80339b
  801f9e:	6a 7c                	push   $0x7c
  801fa0:	68 b0 33 80 00       	push   $0x8033b0
  801fa5:	e8 66 e3 ff ff       	call   800310 <_panic>
	assert(r <= PGSIZE);
  801faa:	68 bb 33 80 00       	push   $0x8033bb
  801faf:	68 9b 33 80 00       	push   $0x80339b
  801fb4:	6a 7d                	push   $0x7d
  801fb6:	68 b0 33 80 00       	push   $0x8033b0
  801fbb:	e8 50 e3 ff ff       	call   800310 <_panic>

00801fc0 <open>:
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	56                   	push   %esi
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 1c             	sub    $0x1c,%esp
  801fc8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801fcb:	56                   	push   %esi
  801fcc:	e8 5b eb ff ff       	call   800b2c <strlen>
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fd9:	7f 6c                	jg     802047 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe1:	50                   	push   %eax
  801fe2:	e8 79 f8 ff ff       	call   801860 <fd_alloc>
  801fe7:	89 c3                	mov    %eax,%ebx
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 3c                	js     80202c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	56                   	push   %esi
  801ff4:	68 00 60 80 00       	push   $0x806000
  801ff9:	e8 67 eb ff ff       	call   800b65 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802001:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802006:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802009:	b8 01 00 00 00       	mov    $0x1,%eax
  80200e:	e8 b8 fd ff ff       	call   801dcb <fsipc>
  802013:	89 c3                	mov    %eax,%ebx
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 19                	js     802035 <open+0x75>
	return fd2num(fd);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	ff 75 f4             	pushl  -0xc(%ebp)
  802022:	e8 12 f8 ff ff       	call   801839 <fd2num>
  802027:	89 c3                	mov    %eax,%ebx
  802029:	83 c4 10             	add    $0x10,%esp
}
  80202c:	89 d8                	mov    %ebx,%eax
  80202e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    
		fd_close(fd, 0);
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 f4             	pushl  -0xc(%ebp)
  80203d:	e8 1b f9 ff ff       	call   80195d <fd_close>
		return r;
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	eb e5                	jmp    80202c <open+0x6c>
		return -E_BAD_PATH;
  802047:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80204c:	eb de                	jmp    80202c <open+0x6c>

0080204e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802054:	ba 00 00 00 00       	mov    $0x0,%edx
  802059:	b8 08 00 00 00       	mov    $0x8,%eax
  80205e:	e8 68 fd ff ff       	call   801dcb <fsipc>
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80206b:	89 d0                	mov    %edx,%eax
  80206d:	c1 e8 16             	shr    $0x16,%eax
  802070:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80207c:	f6 c1 01             	test   $0x1,%cl
  80207f:	74 1d                	je     80209e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802081:	c1 ea 0c             	shr    $0xc,%edx
  802084:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80208b:	f6 c2 01             	test   $0x1,%dl
  80208e:	74 0e                	je     80209e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802090:	c1 ea 0c             	shr    $0xc,%edx
  802093:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80209a:	ef 
  80209b:	0f b7 c0             	movzwl %ax,%eax
}
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    

008020a0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8020a6:	68 c7 33 80 00       	push   $0x8033c7
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	e8 b2 ea ff ff       	call   800b65 <strcpy>
	return 0;
}
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <devsock_close>:
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	53                   	push   %ebx
  8020be:	83 ec 10             	sub    $0x10,%esp
  8020c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020c4:	53                   	push   %ebx
  8020c5:	e8 9b ff ff ff       	call   802065 <pageref>
  8020ca:	83 c4 10             	add    $0x10,%esp
		return 0;
  8020cd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8020d2:	83 f8 01             	cmp    $0x1,%eax
  8020d5:	74 07                	je     8020de <devsock_close+0x24>
}
  8020d7:	89 d0                	mov    %edx,%eax
  8020d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8020de:	83 ec 0c             	sub    $0xc,%esp
  8020e1:	ff 73 0c             	pushl  0xc(%ebx)
  8020e4:	e8 b9 02 00 00       	call   8023a2 <nsipc_close>
  8020e9:	89 c2                	mov    %eax,%edx
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	eb e7                	jmp    8020d7 <devsock_close+0x1d>

008020f0 <devsock_write>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020f6:	6a 00                	push   $0x0
  8020f8:	ff 75 10             	pushl  0x10(%ebp)
  8020fb:	ff 75 0c             	pushl  0xc(%ebp)
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	ff 70 0c             	pushl  0xc(%eax)
  802104:	e8 76 03 00 00       	call   80247f <nsipc_send>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <devsock_read>:
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802111:	6a 00                	push   $0x0
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	ff 70 0c             	pushl  0xc(%eax)
  80211f:	e8 ef 02 00 00       	call   802413 <nsipc_recv>
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <fd2sockid>:
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80212c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80212f:	52                   	push   %edx
  802130:	50                   	push   %eax
  802131:	e8 7c f7 ff ff       	call   8018b2 <fd_lookup>
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	85 c0                	test   %eax,%eax
  80213b:	78 10                	js     80214d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802140:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802146:	39 08                	cmp    %ecx,(%eax)
  802148:	75 05                	jne    80214f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80214a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    
		return -E_NOT_SUPP;
  80214f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802154:	eb f7                	jmp    80214d <fd2sockid+0x27>

00802156 <alloc_sockfd>:
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	56                   	push   %esi
  80215a:	53                   	push   %ebx
  80215b:	83 ec 1c             	sub    $0x1c,%esp
  80215e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802160:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802163:	50                   	push   %eax
  802164:	e8 f7 f6 ff ff       	call   801860 <fd_alloc>
  802169:	89 c3                	mov    %eax,%ebx
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	85 c0                	test   %eax,%eax
  802170:	78 43                	js     8021b5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 07 04 00 00       	push   $0x407
  80217a:	ff 75 f4             	pushl  -0xc(%ebp)
  80217d:	6a 00                	push   $0x0
  80217f:	e8 d3 ed ff ff       	call   800f57 <sys_page_alloc>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	85 c0                	test   %eax,%eax
  80218b:	78 28                	js     8021b5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802196:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8021a2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8021a5:	83 ec 0c             	sub    $0xc,%esp
  8021a8:	50                   	push   %eax
  8021a9:	e8 8b f6 ff ff       	call   801839 <fd2num>
  8021ae:	89 c3                	mov    %eax,%ebx
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	eb 0c                	jmp    8021c1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8021b5:	83 ec 0c             	sub    $0xc,%esp
  8021b8:	56                   	push   %esi
  8021b9:	e8 e4 01 00 00       	call   8023a2 <nsipc_close>
		return r;
  8021be:	83 c4 10             	add    $0x10,%esp
}
  8021c1:	89 d8                	mov    %ebx,%eax
  8021c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5e                   	pop    %esi
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <accept>:
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	e8 4e ff ff ff       	call   802126 <fd2sockid>
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	78 1b                	js     8021f7 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	ff 75 10             	pushl  0x10(%ebp)
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	50                   	push   %eax
  8021e6:	e8 0e 01 00 00       	call   8022f9 <nsipc_accept>
  8021eb:	83 c4 10             	add    $0x10,%esp
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	78 05                	js     8021f7 <accept+0x2d>
	return alloc_sockfd(r);
  8021f2:	e8 5f ff ff ff       	call   802156 <alloc_sockfd>
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <bind>:
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	e8 1f ff ff ff       	call   802126 <fd2sockid>
  802207:	85 c0                	test   %eax,%eax
  802209:	78 12                	js     80221d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80220b:	83 ec 04             	sub    $0x4,%esp
  80220e:	ff 75 10             	pushl  0x10(%ebp)
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	50                   	push   %eax
  802215:	e8 31 01 00 00       	call   80234b <nsipc_bind>
  80221a:	83 c4 10             	add    $0x10,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <shutdown>:
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	e8 f9 fe ff ff       	call   802126 <fd2sockid>
  80222d:	85 c0                	test   %eax,%eax
  80222f:	78 0f                	js     802240 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802231:	83 ec 08             	sub    $0x8,%esp
  802234:	ff 75 0c             	pushl  0xc(%ebp)
  802237:	50                   	push   %eax
  802238:	e8 43 01 00 00       	call   802380 <nsipc_shutdown>
  80223d:	83 c4 10             	add    $0x10,%esp
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <connect>:
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	e8 d6 fe ff ff       	call   802126 <fd2sockid>
  802250:	85 c0                	test   %eax,%eax
  802252:	78 12                	js     802266 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	ff 75 10             	pushl  0x10(%ebp)
  80225a:	ff 75 0c             	pushl  0xc(%ebp)
  80225d:	50                   	push   %eax
  80225e:	e8 59 01 00 00       	call   8023bc <nsipc_connect>
  802263:	83 c4 10             	add    $0x10,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <listen>:
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	e8 b0 fe ff ff       	call   802126 <fd2sockid>
  802276:	85 c0                	test   %eax,%eax
  802278:	78 0f                	js     802289 <listen+0x21>
	return nsipc_listen(r, backlog);
  80227a:	83 ec 08             	sub    $0x8,%esp
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	50                   	push   %eax
  802281:	e8 6b 01 00 00       	call   8023f1 <nsipc_listen>
  802286:	83 c4 10             	add    $0x10,%esp
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <socket>:

int
socket(int domain, int type, int protocol)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802291:	ff 75 10             	pushl  0x10(%ebp)
  802294:	ff 75 0c             	pushl  0xc(%ebp)
  802297:	ff 75 08             	pushl  0x8(%ebp)
  80229a:	e8 3e 02 00 00       	call   8024dd <nsipc_socket>
  80229f:	83 c4 10             	add    $0x10,%esp
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	78 05                	js     8022ab <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8022a6:	e8 ab fe ff ff       	call   802156 <alloc_sockfd>
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	53                   	push   %ebx
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022b6:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022bd:	74 26                	je     8022e5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022bf:	6a 07                	push   $0x7
  8022c1:	68 00 70 80 00       	push   $0x807000
  8022c6:	53                   	push   %ebx
  8022c7:	ff 35 04 50 80 00    	pushl  0x805004
  8022cd:	e8 d0 f4 ff ff       	call   8017a2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022d2:	83 c4 0c             	add    $0xc,%esp
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	e8 59 f4 ff ff       	call   801739 <ipc_recv>
}
  8022e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	6a 02                	push   $0x2
  8022ea:	e8 0b f5 ff ff       	call   8017fa <ipc_find_env>
  8022ef:	a3 04 50 80 00       	mov    %eax,0x805004
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	eb c6                	jmp    8022bf <nsipc+0x12>

008022f9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	56                   	push   %esi
  8022fd:	53                   	push   %ebx
  8022fe:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802309:	8b 06                	mov    (%esi),%eax
  80230b:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802310:	b8 01 00 00 00       	mov    $0x1,%eax
  802315:	e8 93 ff ff ff       	call   8022ad <nsipc>
  80231a:	89 c3                	mov    %eax,%ebx
  80231c:	85 c0                	test   %eax,%eax
  80231e:	79 09                	jns    802329 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802320:	89 d8                	mov    %ebx,%eax
  802322:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802325:	5b                   	pop    %ebx
  802326:	5e                   	pop    %esi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	ff 35 10 70 80 00    	pushl  0x807010
  802332:	68 00 70 80 00       	push   $0x807000
  802337:	ff 75 0c             	pushl  0xc(%ebp)
  80233a:	e8 b4 e9 ff ff       	call   800cf3 <memmove>
		*addrlen = ret->ret_addrlen;
  80233f:	a1 10 70 80 00       	mov    0x807010,%eax
  802344:	89 06                	mov    %eax,(%esi)
  802346:	83 c4 10             	add    $0x10,%esp
	return r;
  802349:	eb d5                	jmp    802320 <nsipc_accept+0x27>

0080234b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	53                   	push   %ebx
  80234f:	83 ec 08             	sub    $0x8,%esp
  802352:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80235d:	53                   	push   %ebx
  80235e:	ff 75 0c             	pushl  0xc(%ebp)
  802361:	68 04 70 80 00       	push   $0x807004
  802366:	e8 88 e9 ff ff       	call   800cf3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80236b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802371:	b8 02 00 00 00       	mov    $0x2,%eax
  802376:	e8 32 ff ff ff       	call   8022ad <nsipc>
}
  80237b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80238e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802391:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802396:	b8 03 00 00 00       	mov    $0x3,%eax
  80239b:	e8 0d ff ff ff       	call   8022ad <nsipc>
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <nsipc_close>:

int
nsipc_close(int s)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023b0:	b8 04 00 00 00       	mov    $0x4,%eax
  8023b5:	e8 f3 fe ff ff       	call   8022ad <nsipc>
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 08             	sub    $0x8,%esp
  8023c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8023ce:	53                   	push   %ebx
  8023cf:	ff 75 0c             	pushl  0xc(%ebp)
  8023d2:	68 04 70 80 00       	push   $0x807004
  8023d7:	e8 17 e9 ff ff       	call   800cf3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8023dc:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8023e2:	b8 05 00 00 00       	mov    $0x5,%eax
  8023e7:	e8 c1 fe ff ff       	call   8022ad <nsipc>
}
  8023ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802402:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802407:	b8 06 00 00 00       	mov    $0x6,%eax
  80240c:	e8 9c fe ff ff       	call   8022ad <nsipc>
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802423:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802429:	8b 45 14             	mov    0x14(%ebp),%eax
  80242c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802431:	b8 07 00 00 00       	mov    $0x7,%eax
  802436:	e8 72 fe ff ff       	call   8022ad <nsipc>
  80243b:	89 c3                	mov    %eax,%ebx
  80243d:	85 c0                	test   %eax,%eax
  80243f:	78 1f                	js     802460 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802441:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802446:	7f 21                	jg     802469 <nsipc_recv+0x56>
  802448:	39 c6                	cmp    %eax,%esi
  80244a:	7c 1d                	jl     802469 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	50                   	push   %eax
  802450:	68 00 70 80 00       	push   $0x807000
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	e8 96 e8 ff ff       	call   800cf3 <memmove>
  80245d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802460:	89 d8                	mov    %ebx,%eax
  802462:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802469:	68 d3 33 80 00       	push   $0x8033d3
  80246e:	68 9b 33 80 00       	push   $0x80339b
  802473:	6a 62                	push   $0x62
  802475:	68 e8 33 80 00       	push   $0x8033e8
  80247a:	e8 91 de ff ff       	call   800310 <_panic>

0080247f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	53                   	push   %ebx
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802491:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802497:	7f 2e                	jg     8024c7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	53                   	push   %ebx
  80249d:	ff 75 0c             	pushl  0xc(%ebp)
  8024a0:	68 0c 70 80 00       	push   $0x80700c
  8024a5:	e8 49 e8 ff ff       	call   800cf3 <memmove>
	nsipcbuf.send.req_size = size;
  8024aa:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8024b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8024b3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8024b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8024bd:	e8 eb fd ff ff       	call   8022ad <nsipc>
}
  8024c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    
	assert(size < 1600);
  8024c7:	68 f4 33 80 00       	push   $0x8033f4
  8024cc:	68 9b 33 80 00       	push   $0x80339b
  8024d1:	6a 6d                	push   $0x6d
  8024d3:	68 e8 33 80 00       	push   $0x8033e8
  8024d8:	e8 33 de ff ff       	call   800310 <_panic>

008024dd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ee:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f6:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024fb:	b8 09 00 00 00       	mov    $0x9,%eax
  802500:	e8 a8 fd ff ff       	call   8022ad <nsipc>
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	56                   	push   %esi
  80250b:	53                   	push   %ebx
  80250c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80250f:	83 ec 0c             	sub    $0xc,%esp
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	e8 2f f3 ff ff       	call   801849 <fd2data>
  80251a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80251c:	83 c4 08             	add    $0x8,%esp
  80251f:	68 00 34 80 00       	push   $0x803400
  802524:	53                   	push   %ebx
  802525:	e8 3b e6 ff ff       	call   800b65 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80252a:	8b 46 04             	mov    0x4(%esi),%eax
  80252d:	2b 06                	sub    (%esi),%eax
  80252f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802535:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80253c:	00 00 00 
	stat->st_dev = &devpipe;
  80253f:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802546:	40 80 00 
	return 0;
}
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    

00802555 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	53                   	push   %ebx
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80255f:	53                   	push   %ebx
  802560:	6a 00                	push   $0x0
  802562:	e8 75 ea ff ff       	call   800fdc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802567:	89 1c 24             	mov    %ebx,(%esp)
  80256a:	e8 da f2 ff ff       	call   801849 <fd2data>
  80256f:	83 c4 08             	add    $0x8,%esp
  802572:	50                   	push   %eax
  802573:	6a 00                	push   $0x0
  802575:	e8 62 ea ff ff       	call   800fdc <sys_page_unmap>
}
  80257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80257d:	c9                   	leave  
  80257e:	c3                   	ret    

0080257f <_pipeisclosed>:
{
  80257f:	55                   	push   %ebp
  802580:	89 e5                	mov    %esp,%ebp
  802582:	57                   	push   %edi
  802583:	56                   	push   %esi
  802584:	53                   	push   %ebx
  802585:	83 ec 1c             	sub    $0x1c,%esp
  802588:	89 c7                	mov    %eax,%edi
  80258a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80258c:	a1 08 50 80 00       	mov    0x805008,%eax
  802591:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	57                   	push   %edi
  802598:	e8 c8 fa ff ff       	call   802065 <pageref>
  80259d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8025a0:	89 34 24             	mov    %esi,(%esp)
  8025a3:	e8 bd fa ff ff       	call   802065 <pageref>
		nn = thisenv->env_runs;
  8025a8:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8025ae:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	39 cb                	cmp    %ecx,%ebx
  8025b6:	74 1b                	je     8025d3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8025b8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025bb:	75 cf                	jne    80258c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025bd:	8b 42 58             	mov    0x58(%edx),%eax
  8025c0:	6a 01                	push   $0x1
  8025c2:	50                   	push   %eax
  8025c3:	53                   	push   %ebx
  8025c4:	68 07 34 80 00       	push   $0x803407
  8025c9:	e8 38 de ff ff       	call   800406 <cprintf>
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	eb b9                	jmp    80258c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8025d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8025d6:	0f 94 c0             	sete   %al
  8025d9:	0f b6 c0             	movzbl %al,%eax
}
  8025dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025df:	5b                   	pop    %ebx
  8025e0:	5e                   	pop    %esi
  8025e1:	5f                   	pop    %edi
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    

008025e4 <devpipe_write>:
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	57                   	push   %edi
  8025e8:	56                   	push   %esi
  8025e9:	53                   	push   %ebx
  8025ea:	83 ec 28             	sub    $0x28,%esp
  8025ed:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025f0:	56                   	push   %esi
  8025f1:	e8 53 f2 ff ff       	call   801849 <fd2data>
  8025f6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025f8:	83 c4 10             	add    $0x10,%esp
  8025fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802600:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802603:	74 4f                	je     802654 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802605:	8b 43 04             	mov    0x4(%ebx),%eax
  802608:	8b 0b                	mov    (%ebx),%ecx
  80260a:	8d 51 20             	lea    0x20(%ecx),%edx
  80260d:	39 d0                	cmp    %edx,%eax
  80260f:	72 14                	jb     802625 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802611:	89 da                	mov    %ebx,%edx
  802613:	89 f0                	mov    %esi,%eax
  802615:	e8 65 ff ff ff       	call   80257f <_pipeisclosed>
  80261a:	85 c0                	test   %eax,%eax
  80261c:	75 3b                	jne    802659 <devpipe_write+0x75>
			sys_yield();
  80261e:	e8 15 e9 ff ff       	call   800f38 <sys_yield>
  802623:	eb e0                	jmp    802605 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802625:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802628:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80262c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80262f:	89 c2                	mov    %eax,%edx
  802631:	c1 fa 1f             	sar    $0x1f,%edx
  802634:	89 d1                	mov    %edx,%ecx
  802636:	c1 e9 1b             	shr    $0x1b,%ecx
  802639:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80263c:	83 e2 1f             	and    $0x1f,%edx
  80263f:	29 ca                	sub    %ecx,%edx
  802641:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802645:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802649:	83 c0 01             	add    $0x1,%eax
  80264c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80264f:	83 c7 01             	add    $0x1,%edi
  802652:	eb ac                	jmp    802600 <devpipe_write+0x1c>
	return i;
  802654:	8b 45 10             	mov    0x10(%ebp),%eax
  802657:	eb 05                	jmp    80265e <devpipe_write+0x7a>
				return 0;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    

00802666 <devpipe_read>:
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	57                   	push   %edi
  80266a:	56                   	push   %esi
  80266b:	53                   	push   %ebx
  80266c:	83 ec 18             	sub    $0x18,%esp
  80266f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802672:	57                   	push   %edi
  802673:	e8 d1 f1 ff ff       	call   801849 <fd2data>
  802678:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80267a:	83 c4 10             	add    $0x10,%esp
  80267d:	be 00 00 00 00       	mov    $0x0,%esi
  802682:	3b 75 10             	cmp    0x10(%ebp),%esi
  802685:	75 14                	jne    80269b <devpipe_read+0x35>
	return i;
  802687:	8b 45 10             	mov    0x10(%ebp),%eax
  80268a:	eb 02                	jmp    80268e <devpipe_read+0x28>
				return i;
  80268c:	89 f0                	mov    %esi,%eax
}
  80268e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5f                   	pop    %edi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    
			sys_yield();
  802696:	e8 9d e8 ff ff       	call   800f38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80269b:	8b 03                	mov    (%ebx),%eax
  80269d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026a0:	75 18                	jne    8026ba <devpipe_read+0x54>
			if (i > 0)
  8026a2:	85 f6                	test   %esi,%esi
  8026a4:	75 e6                	jne    80268c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8026a6:	89 da                	mov    %ebx,%edx
  8026a8:	89 f8                	mov    %edi,%eax
  8026aa:	e8 d0 fe ff ff       	call   80257f <_pipeisclosed>
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 e3                	je     802696 <devpipe_read+0x30>
				return 0;
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	eb d4                	jmp    80268e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026ba:	99                   	cltd   
  8026bb:	c1 ea 1b             	shr    $0x1b,%edx
  8026be:	01 d0                	add    %edx,%eax
  8026c0:	83 e0 1f             	and    $0x1f,%eax
  8026c3:	29 d0                	sub    %edx,%eax
  8026c5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026cd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8026d0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8026d3:	83 c6 01             	add    $0x1,%esi
  8026d6:	eb aa                	jmp    802682 <devpipe_read+0x1c>

008026d8 <pipe>:
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	56                   	push   %esi
  8026dc:	53                   	push   %ebx
  8026dd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8026e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e3:	50                   	push   %eax
  8026e4:	e8 77 f1 ff ff       	call   801860 <fd_alloc>
  8026e9:	89 c3                	mov    %eax,%ebx
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	0f 88 23 01 00 00    	js     802819 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026f6:	83 ec 04             	sub    $0x4,%esp
  8026f9:	68 07 04 00 00       	push   $0x407
  8026fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802701:	6a 00                	push   $0x0
  802703:	e8 4f e8 ff ff       	call   800f57 <sys_page_alloc>
  802708:	89 c3                	mov    %eax,%ebx
  80270a:	83 c4 10             	add    $0x10,%esp
  80270d:	85 c0                	test   %eax,%eax
  80270f:	0f 88 04 01 00 00    	js     802819 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80271b:	50                   	push   %eax
  80271c:	e8 3f f1 ff ff       	call   801860 <fd_alloc>
  802721:	89 c3                	mov    %eax,%ebx
  802723:	83 c4 10             	add    $0x10,%esp
  802726:	85 c0                	test   %eax,%eax
  802728:	0f 88 db 00 00 00    	js     802809 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	68 07 04 00 00       	push   $0x407
  802736:	ff 75 f0             	pushl  -0x10(%ebp)
  802739:	6a 00                	push   $0x0
  80273b:	e8 17 e8 ff ff       	call   800f57 <sys_page_alloc>
  802740:	89 c3                	mov    %eax,%ebx
  802742:	83 c4 10             	add    $0x10,%esp
  802745:	85 c0                	test   %eax,%eax
  802747:	0f 88 bc 00 00 00    	js     802809 <pipe+0x131>
	va = fd2data(fd0);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	ff 75 f4             	pushl  -0xc(%ebp)
  802753:	e8 f1 f0 ff ff       	call   801849 <fd2data>
  802758:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275a:	83 c4 0c             	add    $0xc,%esp
  80275d:	68 07 04 00 00       	push   $0x407
  802762:	50                   	push   %eax
  802763:	6a 00                	push   $0x0
  802765:	e8 ed e7 ff ff       	call   800f57 <sys_page_alloc>
  80276a:	89 c3                	mov    %eax,%ebx
  80276c:	83 c4 10             	add    $0x10,%esp
  80276f:	85 c0                	test   %eax,%eax
  802771:	0f 88 82 00 00 00    	js     8027f9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	ff 75 f0             	pushl  -0x10(%ebp)
  80277d:	e8 c7 f0 ff ff       	call   801849 <fd2data>
  802782:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802789:	50                   	push   %eax
  80278a:	6a 00                	push   $0x0
  80278c:	56                   	push   %esi
  80278d:	6a 00                	push   $0x0
  80278f:	e8 06 e8 ff ff       	call   800f9a <sys_page_map>
  802794:	89 c3                	mov    %eax,%ebx
  802796:	83 c4 20             	add    $0x20,%esp
  802799:	85 c0                	test   %eax,%eax
  80279b:	78 4e                	js     8027eb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80279d:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8027a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8027a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027aa:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8027b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8027c0:	83 ec 0c             	sub    $0xc,%esp
  8027c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c6:	e8 6e f0 ff ff       	call   801839 <fd2num>
  8027cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ce:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027d0:	83 c4 04             	add    $0x4,%esp
  8027d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8027d6:	e8 5e f0 ff ff       	call   801839 <fd2num>
  8027db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027de:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027e1:	83 c4 10             	add    $0x10,%esp
  8027e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027e9:	eb 2e                	jmp    802819 <pipe+0x141>
	sys_page_unmap(0, va);
  8027eb:	83 ec 08             	sub    $0x8,%esp
  8027ee:	56                   	push   %esi
  8027ef:	6a 00                	push   $0x0
  8027f1:	e8 e6 e7 ff ff       	call   800fdc <sys_page_unmap>
  8027f6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027f9:	83 ec 08             	sub    $0x8,%esp
  8027fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ff:	6a 00                	push   $0x0
  802801:	e8 d6 e7 ff ff       	call   800fdc <sys_page_unmap>
  802806:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802809:	83 ec 08             	sub    $0x8,%esp
  80280c:	ff 75 f4             	pushl  -0xc(%ebp)
  80280f:	6a 00                	push   $0x0
  802811:	e8 c6 e7 ff ff       	call   800fdc <sys_page_unmap>
  802816:	83 c4 10             	add    $0x10,%esp
}
  802819:	89 d8                	mov    %ebx,%eax
  80281b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80281e:	5b                   	pop    %ebx
  80281f:	5e                   	pop    %esi
  802820:	5d                   	pop    %ebp
  802821:	c3                   	ret    

00802822 <pipeisclosed>:
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802828:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282b:	50                   	push   %eax
  80282c:	ff 75 08             	pushl  0x8(%ebp)
  80282f:	e8 7e f0 ff ff       	call   8018b2 <fd_lookup>
  802834:	83 c4 10             	add    $0x10,%esp
  802837:	85 c0                	test   %eax,%eax
  802839:	78 18                	js     802853 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	ff 75 f4             	pushl  -0xc(%ebp)
  802841:	e8 03 f0 ff ff       	call   801849 <fd2data>
	return _pipeisclosed(fd, p);
  802846:	89 c2                	mov    %eax,%edx
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	e8 2f fd ff ff       	call   80257f <_pipeisclosed>
  802850:	83 c4 10             	add    $0x10,%esp
}
  802853:	c9                   	leave  
  802854:	c3                   	ret    

00802855 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
  80285a:	c3                   	ret    

0080285b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802861:	68 1f 34 80 00       	push   $0x80341f
  802866:	ff 75 0c             	pushl  0xc(%ebp)
  802869:	e8 f7 e2 ff ff       	call   800b65 <strcpy>
	return 0;
}
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <devcons_write>:
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	57                   	push   %edi
  802879:	56                   	push   %esi
  80287a:	53                   	push   %ebx
  80287b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802881:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802886:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80288c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80288f:	73 31                	jae    8028c2 <devcons_write+0x4d>
		m = n - tot;
  802891:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802894:	29 f3                	sub    %esi,%ebx
  802896:	83 fb 7f             	cmp    $0x7f,%ebx
  802899:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80289e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	53                   	push   %ebx
  8028a5:	89 f0                	mov    %esi,%eax
  8028a7:	03 45 0c             	add    0xc(%ebp),%eax
  8028aa:	50                   	push   %eax
  8028ab:	57                   	push   %edi
  8028ac:	e8 42 e4 ff ff       	call   800cf3 <memmove>
		sys_cputs(buf, m);
  8028b1:	83 c4 08             	add    $0x8,%esp
  8028b4:	53                   	push   %ebx
  8028b5:	57                   	push   %edi
  8028b6:	e8 e0 e5 ff ff       	call   800e9b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8028bb:	01 de                	add    %ebx,%esi
  8028bd:	83 c4 10             	add    $0x10,%esp
  8028c0:	eb ca                	jmp    80288c <devcons_write+0x17>
}
  8028c2:	89 f0                	mov    %esi,%eax
  8028c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028c7:	5b                   	pop    %ebx
  8028c8:	5e                   	pop    %esi
  8028c9:	5f                   	pop    %edi
  8028ca:	5d                   	pop    %ebp
  8028cb:	c3                   	ret    

008028cc <devcons_read>:
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 08             	sub    $0x8,%esp
  8028d2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028db:	74 21                	je     8028fe <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028dd:	e8 d7 e5 ff ff       	call   800eb9 <sys_cgetc>
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 07                	jne    8028ed <devcons_read+0x21>
		sys_yield();
  8028e6:	e8 4d e6 ff ff       	call   800f38 <sys_yield>
  8028eb:	eb f0                	jmp    8028dd <devcons_read+0x11>
	if (c < 0)
  8028ed:	78 0f                	js     8028fe <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028ef:	83 f8 04             	cmp    $0x4,%eax
  8028f2:	74 0c                	je     802900 <devcons_read+0x34>
	*(char*)vbuf = c;
  8028f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f7:	88 02                	mov    %al,(%edx)
	return 1;
  8028f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    
		return 0;
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
  802905:	eb f7                	jmp    8028fe <devcons_read+0x32>

00802907 <cputchar>:
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
  80290a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802913:	6a 01                	push   $0x1
  802915:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802918:	50                   	push   %eax
  802919:	e8 7d e5 ff ff       	call   800e9b <sys_cputs>
}
  80291e:	83 c4 10             	add    $0x10,%esp
  802921:	c9                   	leave  
  802922:	c3                   	ret    

00802923 <getchar>:
{
  802923:	55                   	push   %ebp
  802924:	89 e5                	mov    %esp,%ebp
  802926:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802929:	6a 01                	push   $0x1
  80292b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80292e:	50                   	push   %eax
  80292f:	6a 00                	push   $0x0
  802931:	e8 ec f1 ff ff       	call   801b22 <read>
	if (r < 0)
  802936:	83 c4 10             	add    $0x10,%esp
  802939:	85 c0                	test   %eax,%eax
  80293b:	78 06                	js     802943 <getchar+0x20>
	if (r < 1)
  80293d:	74 06                	je     802945 <getchar+0x22>
	return c;
  80293f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802943:	c9                   	leave  
  802944:	c3                   	ret    
		return -E_EOF;
  802945:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80294a:	eb f7                	jmp    802943 <getchar+0x20>

0080294c <iscons>:
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802952:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802955:	50                   	push   %eax
  802956:	ff 75 08             	pushl  0x8(%ebp)
  802959:	e8 54 ef ff ff       	call   8018b2 <fd_lookup>
  80295e:	83 c4 10             	add    $0x10,%esp
  802961:	85 c0                	test   %eax,%eax
  802963:	78 11                	js     802976 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80296e:	39 10                	cmp    %edx,(%eax)
  802970:	0f 94 c0             	sete   %al
  802973:	0f b6 c0             	movzbl %al,%eax
}
  802976:	c9                   	leave  
  802977:	c3                   	ret    

00802978 <opencons>:
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
  80297b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80297e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802981:	50                   	push   %eax
  802982:	e8 d9 ee ff ff       	call   801860 <fd_alloc>
  802987:	83 c4 10             	add    $0x10,%esp
  80298a:	85 c0                	test   %eax,%eax
  80298c:	78 3a                	js     8029c8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	68 07 04 00 00       	push   $0x407
  802996:	ff 75 f4             	pushl  -0xc(%ebp)
  802999:	6a 00                	push   $0x0
  80299b:	e8 b7 e5 ff ff       	call   800f57 <sys_page_alloc>
  8029a0:	83 c4 10             	add    $0x10,%esp
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	78 21                	js     8029c8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8029b0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029bc:	83 ec 0c             	sub    $0xc,%esp
  8029bf:	50                   	push   %eax
  8029c0:	e8 74 ee ff ff       	call   801839 <fd2num>
  8029c5:	83 c4 10             	add    $0x10,%esp
}
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029d0:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029d7:	74 0a                	je     8029e3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029e1:	c9                   	leave  
  8029e2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029e3:	83 ec 04             	sub    $0x4,%esp
  8029e6:	6a 07                	push   $0x7
  8029e8:	68 00 f0 bf ee       	push   $0xeebff000
  8029ed:	6a 00                	push   $0x0
  8029ef:	e8 63 e5 ff ff       	call   800f57 <sys_page_alloc>
		if(r < 0)
  8029f4:	83 c4 10             	add    $0x10,%esp
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	78 2a                	js     802a25 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029fb:	83 ec 08             	sub    $0x8,%esp
  8029fe:	68 39 2a 80 00       	push   $0x802a39
  802a03:	6a 00                	push   $0x0
  802a05:	e8 98 e6 ff ff       	call   8010a2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802a0a:	83 c4 10             	add    $0x10,%esp
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	79 c8                	jns    8029d9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802a11:	83 ec 04             	sub    $0x4,%esp
  802a14:	68 5c 34 80 00       	push   $0x80345c
  802a19:	6a 25                	push   $0x25
  802a1b:	68 98 34 80 00       	push   $0x803498
  802a20:	e8 eb d8 ff ff       	call   800310 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a25:	83 ec 04             	sub    $0x4,%esp
  802a28:	68 2c 34 80 00       	push   $0x80342c
  802a2d:	6a 22                	push   $0x22
  802a2f:	68 98 34 80 00       	push   $0x803498
  802a34:	e8 d7 d8 ff ff       	call   800310 <_panic>

00802a39 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a39:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a3a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a3f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a41:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a44:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a48:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a4c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a4f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a51:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a55:	83 c4 08             	add    $0x8,%esp
	popal
  802a58:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a59:	83 c4 04             	add    $0x4,%esp
	popfl
  802a5c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a5d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a5e:	c3                   	ret    
  802a5f:	90                   	nop

00802a60 <__udivdi3>:
  802a60:	55                   	push   %ebp
  802a61:	57                   	push   %edi
  802a62:	56                   	push   %esi
  802a63:	53                   	push   %ebx
  802a64:	83 ec 1c             	sub    $0x1c,%esp
  802a67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a77:	85 d2                	test   %edx,%edx
  802a79:	75 4d                	jne    802ac8 <__udivdi3+0x68>
  802a7b:	39 f3                	cmp    %esi,%ebx
  802a7d:	76 19                	jbe    802a98 <__udivdi3+0x38>
  802a7f:	31 ff                	xor    %edi,%edi
  802a81:	89 e8                	mov    %ebp,%eax
  802a83:	89 f2                	mov    %esi,%edx
  802a85:	f7 f3                	div    %ebx
  802a87:	89 fa                	mov    %edi,%edx
  802a89:	83 c4 1c             	add    $0x1c,%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	89 d9                	mov    %ebx,%ecx
  802a9a:	85 db                	test   %ebx,%ebx
  802a9c:	75 0b                	jne    802aa9 <__udivdi3+0x49>
  802a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa3:	31 d2                	xor    %edx,%edx
  802aa5:	f7 f3                	div    %ebx
  802aa7:	89 c1                	mov    %eax,%ecx
  802aa9:	31 d2                	xor    %edx,%edx
  802aab:	89 f0                	mov    %esi,%eax
  802aad:	f7 f1                	div    %ecx
  802aaf:	89 c6                	mov    %eax,%esi
  802ab1:	89 e8                	mov    %ebp,%eax
  802ab3:	89 f7                	mov    %esi,%edi
  802ab5:	f7 f1                	div    %ecx
  802ab7:	89 fa                	mov    %edi,%edx
  802ab9:	83 c4 1c             	add    $0x1c,%esp
  802abc:	5b                   	pop    %ebx
  802abd:	5e                   	pop    %esi
  802abe:	5f                   	pop    %edi
  802abf:	5d                   	pop    %ebp
  802ac0:	c3                   	ret    
  802ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	39 f2                	cmp    %esi,%edx
  802aca:	77 1c                	ja     802ae8 <__udivdi3+0x88>
  802acc:	0f bd fa             	bsr    %edx,%edi
  802acf:	83 f7 1f             	xor    $0x1f,%edi
  802ad2:	75 2c                	jne    802b00 <__udivdi3+0xa0>
  802ad4:	39 f2                	cmp    %esi,%edx
  802ad6:	72 06                	jb     802ade <__udivdi3+0x7e>
  802ad8:	31 c0                	xor    %eax,%eax
  802ada:	39 eb                	cmp    %ebp,%ebx
  802adc:	77 a9                	ja     802a87 <__udivdi3+0x27>
  802ade:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae3:	eb a2                	jmp    802a87 <__udivdi3+0x27>
  802ae5:	8d 76 00             	lea    0x0(%esi),%esi
  802ae8:	31 ff                	xor    %edi,%edi
  802aea:	31 c0                	xor    %eax,%eax
  802aec:	89 fa                	mov    %edi,%edx
  802aee:	83 c4 1c             	add    $0x1c,%esp
  802af1:	5b                   	pop    %ebx
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    
  802af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802afd:	8d 76 00             	lea    0x0(%esi),%esi
  802b00:	89 f9                	mov    %edi,%ecx
  802b02:	b8 20 00 00 00       	mov    $0x20,%eax
  802b07:	29 f8                	sub    %edi,%eax
  802b09:	d3 e2                	shl    %cl,%edx
  802b0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b0f:	89 c1                	mov    %eax,%ecx
  802b11:	89 da                	mov    %ebx,%edx
  802b13:	d3 ea                	shr    %cl,%edx
  802b15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b19:	09 d1                	or     %edx,%ecx
  802b1b:	89 f2                	mov    %esi,%edx
  802b1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b21:	89 f9                	mov    %edi,%ecx
  802b23:	d3 e3                	shl    %cl,%ebx
  802b25:	89 c1                	mov    %eax,%ecx
  802b27:	d3 ea                	shr    %cl,%edx
  802b29:	89 f9                	mov    %edi,%ecx
  802b2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b2f:	89 eb                	mov    %ebp,%ebx
  802b31:	d3 e6                	shl    %cl,%esi
  802b33:	89 c1                	mov    %eax,%ecx
  802b35:	d3 eb                	shr    %cl,%ebx
  802b37:	09 de                	or     %ebx,%esi
  802b39:	89 f0                	mov    %esi,%eax
  802b3b:	f7 74 24 08          	divl   0x8(%esp)
  802b3f:	89 d6                	mov    %edx,%esi
  802b41:	89 c3                	mov    %eax,%ebx
  802b43:	f7 64 24 0c          	mull   0xc(%esp)
  802b47:	39 d6                	cmp    %edx,%esi
  802b49:	72 15                	jb     802b60 <__udivdi3+0x100>
  802b4b:	89 f9                	mov    %edi,%ecx
  802b4d:	d3 e5                	shl    %cl,%ebp
  802b4f:	39 c5                	cmp    %eax,%ebp
  802b51:	73 04                	jae    802b57 <__udivdi3+0xf7>
  802b53:	39 d6                	cmp    %edx,%esi
  802b55:	74 09                	je     802b60 <__udivdi3+0x100>
  802b57:	89 d8                	mov    %ebx,%eax
  802b59:	31 ff                	xor    %edi,%edi
  802b5b:	e9 27 ff ff ff       	jmp    802a87 <__udivdi3+0x27>
  802b60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b63:	31 ff                	xor    %edi,%edi
  802b65:	e9 1d ff ff ff       	jmp    802a87 <__udivdi3+0x27>
  802b6a:	66 90                	xchg   %ax,%ax
  802b6c:	66 90                	xchg   %ax,%ax
  802b6e:	66 90                	xchg   %ax,%ax

00802b70 <__umoddi3>:
  802b70:	55                   	push   %ebp
  802b71:	57                   	push   %edi
  802b72:	56                   	push   %esi
  802b73:	53                   	push   %ebx
  802b74:	83 ec 1c             	sub    $0x1c,%esp
  802b77:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b87:	89 da                	mov    %ebx,%edx
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	75 43                	jne    802bd0 <__umoddi3+0x60>
  802b8d:	39 df                	cmp    %ebx,%edi
  802b8f:	76 17                	jbe    802ba8 <__umoddi3+0x38>
  802b91:	89 f0                	mov    %esi,%eax
  802b93:	f7 f7                	div    %edi
  802b95:	89 d0                	mov    %edx,%eax
  802b97:	31 d2                	xor    %edx,%edx
  802b99:	83 c4 1c             	add    $0x1c,%esp
  802b9c:	5b                   	pop    %ebx
  802b9d:	5e                   	pop    %esi
  802b9e:	5f                   	pop    %edi
  802b9f:	5d                   	pop    %ebp
  802ba0:	c3                   	ret    
  802ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	89 fd                	mov    %edi,%ebp
  802baa:	85 ff                	test   %edi,%edi
  802bac:	75 0b                	jne    802bb9 <__umoddi3+0x49>
  802bae:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb3:	31 d2                	xor    %edx,%edx
  802bb5:	f7 f7                	div    %edi
  802bb7:	89 c5                	mov    %eax,%ebp
  802bb9:	89 d8                	mov    %ebx,%eax
  802bbb:	31 d2                	xor    %edx,%edx
  802bbd:	f7 f5                	div    %ebp
  802bbf:	89 f0                	mov    %esi,%eax
  802bc1:	f7 f5                	div    %ebp
  802bc3:	89 d0                	mov    %edx,%eax
  802bc5:	eb d0                	jmp    802b97 <__umoddi3+0x27>
  802bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bce:	66 90                	xchg   %ax,%ax
  802bd0:	89 f1                	mov    %esi,%ecx
  802bd2:	39 d8                	cmp    %ebx,%eax
  802bd4:	76 0a                	jbe    802be0 <__umoddi3+0x70>
  802bd6:	89 f0                	mov    %esi,%eax
  802bd8:	83 c4 1c             	add    $0x1c,%esp
  802bdb:	5b                   	pop    %ebx
  802bdc:	5e                   	pop    %esi
  802bdd:	5f                   	pop    %edi
  802bde:	5d                   	pop    %ebp
  802bdf:	c3                   	ret    
  802be0:	0f bd e8             	bsr    %eax,%ebp
  802be3:	83 f5 1f             	xor    $0x1f,%ebp
  802be6:	75 20                	jne    802c08 <__umoddi3+0x98>
  802be8:	39 d8                	cmp    %ebx,%eax
  802bea:	0f 82 b0 00 00 00    	jb     802ca0 <__umoddi3+0x130>
  802bf0:	39 f7                	cmp    %esi,%edi
  802bf2:	0f 86 a8 00 00 00    	jbe    802ca0 <__umoddi3+0x130>
  802bf8:	89 c8                	mov    %ecx,%eax
  802bfa:	83 c4 1c             	add    $0x1c,%esp
  802bfd:	5b                   	pop    %ebx
  802bfe:	5e                   	pop    %esi
  802bff:	5f                   	pop    %edi
  802c00:	5d                   	pop    %ebp
  802c01:	c3                   	ret    
  802c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c08:	89 e9                	mov    %ebp,%ecx
  802c0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c0f:	29 ea                	sub    %ebp,%edx
  802c11:	d3 e0                	shl    %cl,%eax
  802c13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c17:	89 d1                	mov    %edx,%ecx
  802c19:	89 f8                	mov    %edi,%eax
  802c1b:	d3 e8                	shr    %cl,%eax
  802c1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c29:	09 c1                	or     %eax,%ecx
  802c2b:	89 d8                	mov    %ebx,%eax
  802c2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c31:	89 e9                	mov    %ebp,%ecx
  802c33:	d3 e7                	shl    %cl,%edi
  802c35:	89 d1                	mov    %edx,%ecx
  802c37:	d3 e8                	shr    %cl,%eax
  802c39:	89 e9                	mov    %ebp,%ecx
  802c3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c3f:	d3 e3                	shl    %cl,%ebx
  802c41:	89 c7                	mov    %eax,%edi
  802c43:	89 d1                	mov    %edx,%ecx
  802c45:	89 f0                	mov    %esi,%eax
  802c47:	d3 e8                	shr    %cl,%eax
  802c49:	89 e9                	mov    %ebp,%ecx
  802c4b:	89 fa                	mov    %edi,%edx
  802c4d:	d3 e6                	shl    %cl,%esi
  802c4f:	09 d8                	or     %ebx,%eax
  802c51:	f7 74 24 08          	divl   0x8(%esp)
  802c55:	89 d1                	mov    %edx,%ecx
  802c57:	89 f3                	mov    %esi,%ebx
  802c59:	f7 64 24 0c          	mull   0xc(%esp)
  802c5d:	89 c6                	mov    %eax,%esi
  802c5f:	89 d7                	mov    %edx,%edi
  802c61:	39 d1                	cmp    %edx,%ecx
  802c63:	72 06                	jb     802c6b <__umoddi3+0xfb>
  802c65:	75 10                	jne    802c77 <__umoddi3+0x107>
  802c67:	39 c3                	cmp    %eax,%ebx
  802c69:	73 0c                	jae    802c77 <__umoddi3+0x107>
  802c6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c73:	89 d7                	mov    %edx,%edi
  802c75:	89 c6                	mov    %eax,%esi
  802c77:	89 ca                	mov    %ecx,%edx
  802c79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c7e:	29 f3                	sub    %esi,%ebx
  802c80:	19 fa                	sbb    %edi,%edx
  802c82:	89 d0                	mov    %edx,%eax
  802c84:	d3 e0                	shl    %cl,%eax
  802c86:	89 e9                	mov    %ebp,%ecx
  802c88:	d3 eb                	shr    %cl,%ebx
  802c8a:	d3 ea                	shr    %cl,%edx
  802c8c:	09 d8                	or     %ebx,%eax
  802c8e:	83 c4 1c             	add    $0x1c,%esp
  802c91:	5b                   	pop    %ebx
  802c92:	5e                   	pop    %esi
  802c93:	5f                   	pop    %edi
  802c94:	5d                   	pop    %ebp
  802c95:	c3                   	ret    
  802c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ca0:	89 da                	mov    %ebx,%edx
  802ca2:	29 fe                	sub    %edi,%esi
  802ca4:	19 c2                	sbb    %eax,%edx
  802ca6:	89 f1                	mov    %esi,%ecx
  802ca8:	89 c8                	mov    %ecx,%eax
  802caa:	e9 4b ff ff ff       	jmp    802bfa <__umoddi3+0x8a>
