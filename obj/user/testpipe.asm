
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a1 02 00 00       	call   8002d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 e0 	movl   $0x802de0,0x804004
  800042:	2d 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 18 26 00 00       	call   802666 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 10 15 00 00       	call   801570 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 1e 01 00 00    	js     800188 <umain+0x155>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	0f 85 56 01 00 00    	jne    8001c6 <umain+0x193>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800070:	a1 08 50 80 00       	mov    0x805008,%eax
  800075:	8b 40 48             	mov    0x48(%eax),%eax
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	ff 75 90             	pushl  -0x70(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 0e 2e 80 00       	push   $0x802e0e
  800084:	e8 4c 04 00 00       	call   8004d5 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 19 19 00 00       	call   8019ad <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 2b 2e 80 00       	push   $0x802e2b
  8000a8:	e8 28 04 00 00       	call   8004d5 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 b4 1a 00 00       	call   801b72 <readn>
  8000be:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	0f 88 cf 00 00 00    	js     80019a <umain+0x167>
			panic("read: %e", i);
		buf[i] = 0;
  8000cb:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	ff 35 00 40 80 00    	pushl  0x804000
  8000d9:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 fd 0b 00 00       	call   800cdf <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 51 2e 80 00       	push   $0x802e51
  8000f5:	e8 db 03 00 00       	call   8004d5 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 a9 02 00 00       	call   8003ab <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 d8 26 00 00       	call   8027e3 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 a7 	movl   $0x802ea7,0x804004
  800112:	2e 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 46 25 00 00       	call   802666 <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 3e 14 00 00       	call   801570 <fork>
  800132:	89 c3                	mov    %eax,%ebx
  800134:	85 c0                	test   %eax,%eax
  800136:	0f 88 35 01 00 00    	js     800271 <umain+0x23e>
		panic("fork: %e", i);

	if (pid == 0) {
  80013c:	0f 84 41 01 00 00    	je     800283 <umain+0x250>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 8c             	pushl  -0x74(%ebp)
  800148:	e8 60 18 00 00       	call   8019ad <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 55 18 00 00       	call   8019ad <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 83 26 00 00       	call   8027e3 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 d5 2e 80 00 	movl   $0x802ed5,(%esp)
  800167:	e8 69 03 00 00       	call   8004d5 <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 ec 2d 80 00       	push   $0x802dec
  80017c:	6a 0e                	push   $0xe
  80017e:	68 f5 2d 80 00       	push   $0x802df5
  800183:	e8 57 02 00 00       	call   8003df <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 05 2e 80 00       	push   $0x802e05
  80018e:	6a 11                	push   $0x11
  800190:	68 f5 2d 80 00       	push   $0x802df5
  800195:	e8 45 02 00 00       	call   8003df <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 48 2e 80 00       	push   $0x802e48
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 f5 2d 80 00       	push   $0x802df5
  8001a7:	e8 33 02 00 00       	call   8003df <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 6d 2e 80 00       	push   $0x802e6d
  8001b9:	e8 17 03 00 00       	call   8004d5 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 0e 2e 80 00       	push   $0x802e0e
  8001da:	e8 f6 02 00 00       	call   8004d5 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 c3 17 00 00       	call   8019ad <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 80 2e 80 00       	push   $0x802e80
  8001fe:	e8 d2 02 00 00       	call   8004d5 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 ea 09 00 00       	call   800bfb <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 94 19 00 00       	call   801bb7 <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 40 80 00    	pushl  0x804000
  80022e:	e8 c8 09 00 00       	call   800bfb <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 68 17 00 00       	call   8019ad <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 9d 2e 80 00       	push   $0x802e9d
  800253:	6a 25                	push   $0x25
  800255:	68 f5 2d 80 00       	push   $0x802df5
  80025a:	e8 80 01 00 00       	call   8003df <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 ec 2d 80 00       	push   $0x802dec
  800265:	6a 2c                	push   $0x2c
  800267:	68 f5 2d 80 00       	push   $0x802df5
  80026c:	e8 6e 01 00 00       	call   8003df <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 05 2e 80 00       	push   $0x802e05
  800277:	6a 2f                	push   $0x2f
  800279:	68 f5 2d 80 00       	push   $0x802df5
  80027e:	e8 5c 01 00 00       	call   8003df <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 1f 17 00 00       	call   8019ad <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 b4 2e 80 00       	push   $0x802eb4
  800299:	e8 37 02 00 00       	call   8004d5 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 b6 2e 80 00       	push   $0x802eb6
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 07 19 00 00       	call   801bb7 <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 b8 2e 80 00       	push   $0x802eb8
  8002c0:	e8 10 02 00 00       	call   8004d5 <cprintf>
		exit();
  8002c5:	e8 e1 00 00 00       	call   8003ab <exit>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	e9 70 fe ff ff       	jmp    800142 <umain+0x10f>

008002d2 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8002db:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8002e2:	00 00 00 
	envid_t find = sys_getenvid();
  8002e5:	e8 fe 0c 00 00       	call   800fe8 <sys_getenvid>
  8002ea:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8002f0:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8002f5:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8002fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8002ff:	eb 0b                	jmp    80030c <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800301:	83 c2 01             	add    $0x1,%edx
  800304:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80030a:	74 21                	je     80032d <libmain+0x5b>
		if(envs[i].env_id == find)
  80030c:	89 d1                	mov    %edx,%ecx
  80030e:	c1 e1 07             	shl    $0x7,%ecx
  800311:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800317:	8b 49 48             	mov    0x48(%ecx),%ecx
  80031a:	39 c1                	cmp    %eax,%ecx
  80031c:	75 e3                	jne    800301 <libmain+0x2f>
  80031e:	89 d3                	mov    %edx,%ebx
  800320:	c1 e3 07             	shl    $0x7,%ebx
  800323:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800329:	89 fe                	mov    %edi,%esi
  80032b:	eb d4                	jmp    800301 <libmain+0x2f>
  80032d:	89 f0                	mov    %esi,%eax
  80032f:	84 c0                	test   %al,%al
  800331:	74 06                	je     800339 <libmain+0x67>
  800333:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033d:	7e 0a                	jle    800349 <libmain+0x77>
		binaryname = argv[0];
  80033f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800342:	8b 00                	mov    (%eax),%eax
  800344:	a3 04 40 80 00       	mov    %eax,0x804004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800349:	a1 08 50 80 00       	mov    0x805008,%eax
  80034e:	8b 40 48             	mov    0x48(%eax),%eax
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	50                   	push   %eax
  800355:	68 2c 2f 80 00       	push   $0x802f2c
  80035a:	e8 76 01 00 00       	call   8004d5 <cprintf>
	cprintf("before umain\n");
  80035f:	c7 04 24 4a 2f 80 00 	movl   $0x802f4a,(%esp)
  800366:	e8 6a 01 00 00       	call   8004d5 <cprintf>
	// call user main routine
	umain(argc, argv);
  80036b:	83 c4 08             	add    $0x8,%esp
  80036e:	ff 75 0c             	pushl  0xc(%ebp)
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	e8 ba fc ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800379:	c7 04 24 58 2f 80 00 	movl   $0x802f58,(%esp)
  800380:	e8 50 01 00 00       	call   8004d5 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800385:	a1 08 50 80 00       	mov    0x805008,%eax
  80038a:	8b 40 48             	mov    0x48(%eax),%eax
  80038d:	83 c4 08             	add    $0x8,%esp
  800390:	50                   	push   %eax
  800391:	68 65 2f 80 00       	push   $0x802f65
  800396:	e8 3a 01 00 00       	call   8004d5 <cprintf>
	// exit gracefully
	exit();
  80039b:	e8 0b 00 00 00       	call   8003ab <exit>
}
  8003a0:	83 c4 10             	add    $0x10,%esp
  8003a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a6:	5b                   	pop    %ebx
  8003a7:	5e                   	pop    %esi
  8003a8:	5f                   	pop    %edi
  8003a9:	5d                   	pop    %ebp
  8003aa:	c3                   	ret    

008003ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8003b6:	8b 40 48             	mov    0x48(%eax),%eax
  8003b9:	68 90 2f 80 00       	push   $0x802f90
  8003be:	50                   	push   %eax
  8003bf:	68 84 2f 80 00       	push   $0x802f84
  8003c4:	e8 0c 01 00 00       	call   8004d5 <cprintf>
	close_all();
  8003c9:	e8 0c 16 00 00       	call   8019da <close_all>
	sys_env_destroy(0);
  8003ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003d5:	e8 cd 0b 00 00       	call   800fa7 <sys_env_destroy>
}
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	56                   	push   %esi
  8003e3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003e4:	a1 08 50 80 00       	mov    0x805008,%eax
  8003e9:	8b 40 48             	mov    0x48(%eax),%eax
  8003ec:	83 ec 04             	sub    $0x4,%esp
  8003ef:	68 bc 2f 80 00       	push   $0x802fbc
  8003f4:	50                   	push   %eax
  8003f5:	68 84 2f 80 00       	push   $0x802f84
  8003fa:	e8 d6 00 00 00       	call   8004d5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003ff:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800402:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800408:	e8 db 0b 00 00       	call   800fe8 <sys_getenvid>
  80040d:	83 c4 04             	add    $0x4,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	56                   	push   %esi
  800417:	50                   	push   %eax
  800418:	68 98 2f 80 00       	push   $0x802f98
  80041d:	e8 b3 00 00 00       	call   8004d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800422:	83 c4 18             	add    $0x18,%esp
  800425:	53                   	push   %ebx
  800426:	ff 75 10             	pushl  0x10(%ebp)
  800429:	e8 56 00 00 00       	call   800484 <vcprintf>
	cprintf("\n");
  80042e:	c7 04 24 48 2f 80 00 	movl   $0x802f48,(%esp)
  800435:	e8 9b 00 00 00       	call   8004d5 <cprintf>
  80043a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80043d:	cc                   	int3   
  80043e:	eb fd                	jmp    80043d <_panic+0x5e>

00800440 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	53                   	push   %ebx
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80044a:	8b 13                	mov    (%ebx),%edx
  80044c:	8d 42 01             	lea    0x1(%edx),%eax
  80044f:	89 03                	mov    %eax,(%ebx)
  800451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800454:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800458:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045d:	74 09                	je     800468 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80045f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800466:	c9                   	leave  
  800467:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	68 ff 00 00 00       	push   $0xff
  800470:	8d 43 08             	lea    0x8(%ebx),%eax
  800473:	50                   	push   %eax
  800474:	e8 f1 0a 00 00       	call   800f6a <sys_cputs>
		b->idx = 0;
  800479:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb db                	jmp    80045f <putch+0x1f>

00800484 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80048d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800494:	00 00 00 
	b.cnt = 0;
  800497:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	ff 75 08             	pushl  0x8(%ebp)
  8004a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ad:	50                   	push   %eax
  8004ae:	68 40 04 80 00       	push   $0x800440
  8004b3:	e8 4a 01 00 00       	call   800602 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004b8:	83 c4 08             	add    $0x8,%esp
  8004bb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004c7:	50                   	push   %eax
  8004c8:	e8 9d 0a 00 00       	call   800f6a <sys_cputs>

	return b.cnt;
}
  8004cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d3:	c9                   	leave  
  8004d4:	c3                   	ret    

008004d5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004db:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004de:	50                   	push   %eax
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 9d ff ff ff       	call   800484 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e7:	c9                   	leave  
  8004e8:	c3                   	ret    

008004e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	57                   	push   %edi
  8004ed:	56                   	push   %esi
  8004ee:	53                   	push   %ebx
  8004ef:	83 ec 1c             	sub    $0x1c,%esp
  8004f2:	89 c6                	mov    %eax,%esi
  8004f4:	89 d7                	mov    %edx,%edi
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800508:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80050c:	74 2c                	je     80053a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800518:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80051e:	39 c2                	cmp    %eax,%edx
  800520:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800523:	73 43                	jae    800568 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800525:	83 eb 01             	sub    $0x1,%ebx
  800528:	85 db                	test   %ebx,%ebx
  80052a:	7e 6c                	jle    800598 <printnum+0xaf>
				putch(padc, putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	57                   	push   %edi
  800530:	ff 75 18             	pushl  0x18(%ebp)
  800533:	ff d6                	call   *%esi
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	eb eb                	jmp    800525 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80053a:	83 ec 0c             	sub    $0xc,%esp
  80053d:	6a 20                	push   $0x20
  80053f:	6a 00                	push   $0x0
  800541:	50                   	push   %eax
  800542:	ff 75 e4             	pushl  -0x1c(%ebp)
  800545:	ff 75 e0             	pushl  -0x20(%ebp)
  800548:	89 fa                	mov    %edi,%edx
  80054a:	89 f0                	mov    %esi,%eax
  80054c:	e8 98 ff ff ff       	call   8004e9 <printnum>
		while (--width > 0)
  800551:	83 c4 20             	add    $0x20,%esp
  800554:	83 eb 01             	sub    $0x1,%ebx
  800557:	85 db                	test   %ebx,%ebx
  800559:	7e 65                	jle    8005c0 <printnum+0xd7>
			putch(padc, putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	57                   	push   %edi
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	eb ec                	jmp    800554 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	ff 75 18             	pushl  0x18(%ebp)
  80056e:	83 eb 01             	sub    $0x1,%ebx
  800571:	53                   	push   %ebx
  800572:	50                   	push   %eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 dc             	pushl  -0x24(%ebp)
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80057f:	ff 75 e0             	pushl  -0x20(%ebp)
  800582:	e8 f9 25 00 00       	call   802b80 <__udivdi3>
  800587:	83 c4 18             	add    $0x18,%esp
  80058a:	52                   	push   %edx
  80058b:	50                   	push   %eax
  80058c:	89 fa                	mov    %edi,%edx
  80058e:	89 f0                	mov    %esi,%eax
  800590:	e8 54 ff ff ff       	call   8004e9 <printnum>
  800595:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	57                   	push   %edi
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	ff 75 dc             	pushl  -0x24(%ebp)
  8005a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ab:	e8 e0 26 00 00       	call   802c90 <__umoddi3>
  8005b0:	83 c4 14             	add    $0x14,%esp
  8005b3:	0f be 80 c3 2f 80 00 	movsbl 0x802fc3(%eax),%eax
  8005ba:	50                   	push   %eax
  8005bb:	ff d6                	call   *%esi
  8005bd:	83 c4 10             	add    $0x10,%esp
	}
}
  8005c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c3:	5b                   	pop    %ebx
  8005c4:	5e                   	pop    %esi
  8005c5:	5f                   	pop    %edi
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    

008005c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d7:	73 0a                	jae    8005e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005dc:	89 08                	mov    %ecx,(%eax)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	88 02                	mov    %al,(%edx)
}
  8005e3:	5d                   	pop    %ebp
  8005e4:	c3                   	ret    

008005e5 <printfmt>:
{
  8005e5:	55                   	push   %ebp
  8005e6:	89 e5                	mov    %esp,%ebp
  8005e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ee:	50                   	push   %eax
  8005ef:	ff 75 10             	pushl  0x10(%ebp)
  8005f2:	ff 75 0c             	pushl  0xc(%ebp)
  8005f5:	ff 75 08             	pushl  0x8(%ebp)
  8005f8:	e8 05 00 00 00       	call   800602 <vprintfmt>
}
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <vprintfmt>:
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	57                   	push   %edi
  800606:	56                   	push   %esi
  800607:	53                   	push   %ebx
  800608:	83 ec 3c             	sub    $0x3c,%esp
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800611:	8b 7d 10             	mov    0x10(%ebp),%edi
  800614:	e9 32 04 00 00       	jmp    800a4b <vprintfmt+0x449>
		padc = ' ';
  800619:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80061d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800624:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80062b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800632:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800639:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800640:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800645:	8d 47 01             	lea    0x1(%edi),%eax
  800648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064b:	0f b6 17             	movzbl (%edi),%edx
  80064e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800651:	3c 55                	cmp    $0x55,%al
  800653:	0f 87 12 05 00 00    	ja     800b6b <vprintfmt+0x569>
  800659:	0f b6 c0             	movzbl %al,%eax
  80065c:	ff 24 85 a0 31 80 00 	jmp    *0x8031a0(,%eax,4)
  800663:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800666:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80066a:	eb d9                	jmp    800645 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80066c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80066f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800673:	eb d0                	jmp    800645 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800675:	0f b6 d2             	movzbl %dl,%edx
  800678:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	89 75 08             	mov    %esi,0x8(%ebp)
  800683:	eb 03                	jmp    800688 <vprintfmt+0x86>
  800685:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800688:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80068f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800692:	8d 72 d0             	lea    -0x30(%edx),%esi
  800695:	83 fe 09             	cmp    $0x9,%esi
  800698:	76 eb                	jbe    800685 <vprintfmt+0x83>
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a0:	eb 14                	jmp    8006b6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ba:	79 89                	jns    800645 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c9:	e9 77 ff ff ff       	jmp    800645 <vprintfmt+0x43>
  8006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	0f 48 c1             	cmovs  %ecx,%eax
  8006d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006dc:	e9 64 ff ff ff       	jmp    800645 <vprintfmt+0x43>
  8006e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006eb:	e9 55 ff ff ff       	jmp    800645 <vprintfmt+0x43>
			lflag++;
  8006f0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006f7:	e9 49 ff ff ff       	jmp    800645 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 78 04             	lea    0x4(%eax),%edi
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	ff 30                	pushl  (%eax)
  800708:	ff d6                	call   *%esi
			break;
  80070a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80070d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800710:	e9 33 03 00 00       	jmp    800a48 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 78 04             	lea    0x4(%eax),%edi
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	99                   	cltd   
  80071e:	31 d0                	xor    %edx,%eax
  800720:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800722:	83 f8 11             	cmp    $0x11,%eax
  800725:	7f 23                	jg     80074a <vprintfmt+0x148>
  800727:	8b 14 85 00 33 80 00 	mov    0x803300(,%eax,4),%edx
  80072e:	85 d2                	test   %edx,%edx
  800730:	74 18                	je     80074a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800732:	52                   	push   %edx
  800733:	68 0d 35 80 00       	push   $0x80350d
  800738:	53                   	push   %ebx
  800739:	56                   	push   %esi
  80073a:	e8 a6 fe ff ff       	call   8005e5 <printfmt>
  80073f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800742:	89 7d 14             	mov    %edi,0x14(%ebp)
  800745:	e9 fe 02 00 00       	jmp    800a48 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80074a:	50                   	push   %eax
  80074b:	68 db 2f 80 00       	push   $0x802fdb
  800750:	53                   	push   %ebx
  800751:	56                   	push   %esi
  800752:	e8 8e fe ff ff       	call   8005e5 <printfmt>
  800757:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80075d:	e9 e6 02 00 00       	jmp    800a48 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 c0 04             	add    $0x4,%eax
  800768:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800770:	85 c9                	test   %ecx,%ecx
  800772:	b8 d4 2f 80 00       	mov    $0x802fd4,%eax
  800777:	0f 45 c1             	cmovne %ecx,%eax
  80077a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	7e 06                	jle    800789 <vprintfmt+0x187>
  800783:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800787:	75 0d                	jne    800796 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800789:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80078c:	89 c7                	mov    %eax,%edi
  80078e:	03 45 e0             	add    -0x20(%ebp),%eax
  800791:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800794:	eb 53                	jmp    8007e9 <vprintfmt+0x1e7>
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 d8             	pushl  -0x28(%ebp)
  80079c:	50                   	push   %eax
  80079d:	e8 71 04 00 00       	call   800c13 <strnlen>
  8007a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a5:	29 c1                	sub    %eax,%ecx
  8007a7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007af:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b6:	eb 0f                	jmp    8007c7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c1:	83 ef 01             	sub    $0x1,%edi
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	85 ff                	test   %edi,%edi
  8007c9:	7f ed                	jg     8007b8 <vprintfmt+0x1b6>
  8007cb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007ce:	85 c9                	test   %ecx,%ecx
  8007d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d5:	0f 49 c1             	cmovns %ecx,%eax
  8007d8:	29 c1                	sub    %eax,%ecx
  8007da:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007dd:	eb aa                	jmp    800789 <vprintfmt+0x187>
					putch(ch, putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	52                   	push   %edx
  8007e4:	ff d6                	call   *%esi
  8007e6:	83 c4 10             	add    $0x10,%esp
  8007e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ec:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ee:	83 c7 01             	add    $0x1,%edi
  8007f1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f5:	0f be d0             	movsbl %al,%edx
  8007f8:	85 d2                	test   %edx,%edx
  8007fa:	74 4b                	je     800847 <vprintfmt+0x245>
  8007fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800800:	78 06                	js     800808 <vprintfmt+0x206>
  800802:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800806:	78 1e                	js     800826 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800808:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80080c:	74 d1                	je     8007df <vprintfmt+0x1dd>
  80080e:	0f be c0             	movsbl %al,%eax
  800811:	83 e8 20             	sub    $0x20,%eax
  800814:	83 f8 5e             	cmp    $0x5e,%eax
  800817:	76 c6                	jbe    8007df <vprintfmt+0x1dd>
					putch('?', putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	6a 3f                	push   $0x3f
  80081f:	ff d6                	call   *%esi
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	eb c3                	jmp    8007e9 <vprintfmt+0x1e7>
  800826:	89 cf                	mov    %ecx,%edi
  800828:	eb 0e                	jmp    800838 <vprintfmt+0x236>
				putch(' ', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	53                   	push   %ebx
  80082e:	6a 20                	push   $0x20
  800830:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800832:	83 ef 01             	sub    $0x1,%edi
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	85 ff                	test   %edi,%edi
  80083a:	7f ee                	jg     80082a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80083c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
  800842:	e9 01 02 00 00       	jmp    800a48 <vprintfmt+0x446>
  800847:	89 cf                	mov    %ecx,%edi
  800849:	eb ed                	jmp    800838 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80084b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80084e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800855:	e9 eb fd ff ff       	jmp    800645 <vprintfmt+0x43>
	if (lflag >= 2)
  80085a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80085e:	7f 21                	jg     800881 <vprintfmt+0x27f>
	else if (lflag)
  800860:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800864:	74 68                	je     8008ce <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80086e:	89 c1                	mov    %eax,%ecx
  800870:	c1 f9 1f             	sar    $0x1f,%ecx
  800873:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 40 04             	lea    0x4(%eax),%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	eb 17                	jmp    800898 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 50 04             	mov    0x4(%eax),%edx
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80088c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 08             	lea    0x8(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800898:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80089b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80089e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008a8:	78 3f                	js     8008e9 <vprintfmt+0x2e7>
			base = 10;
  8008aa:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008af:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008b3:	0f 84 71 01 00 00    	je     800a2a <vprintfmt+0x428>
				putch('+', putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	6a 2b                	push   $0x2b
  8008bf:	ff d6                	call   *%esi
  8008c1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c9:	e9 5c 01 00 00       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008d6:	89 c1                	mov    %eax,%ecx
  8008d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8008db:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8d 40 04             	lea    0x4(%eax),%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	eb af                	jmp    800898 <vprintfmt+0x296>
				putch('-', putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	53                   	push   %ebx
  8008ed:	6a 2d                	push   $0x2d
  8008ef:	ff d6                	call   *%esi
				num = -(long long) num;
  8008f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008f7:	f7 d8                	neg    %eax
  8008f9:	83 d2 00             	adc    $0x0,%edx
  8008fc:	f7 da                	neg    %edx
  8008fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800901:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800904:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800907:	b8 0a 00 00 00       	mov    $0xa,%eax
  80090c:	e9 19 01 00 00       	jmp    800a2a <vprintfmt+0x428>
	if (lflag >= 2)
  800911:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800915:	7f 29                	jg     800940 <vprintfmt+0x33e>
	else if (lflag)
  800917:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80091b:	74 44                	je     800961 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	ba 00 00 00 00       	mov    $0x0,%edx
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 40 04             	lea    0x4(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800936:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093b:	e9 ea 00 00 00       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	8b 50 04             	mov    0x4(%eax),%edx
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 40 08             	lea    0x8(%eax),%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800957:	b8 0a 00 00 00       	mov    $0xa,%eax
  80095c:	e9 c9 00 00 00       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 04             	lea    0x4(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80097a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097f:	e9 a6 00 00 00       	jmp    800a2a <vprintfmt+0x428>
			putch('0', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 30                	push   $0x30
  80098a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800993:	7f 26                	jg     8009bb <vprintfmt+0x3b9>
	else if (lflag)
  800995:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800999:	74 3e                	je     8009d9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ae:	8d 40 04             	lea    0x4(%eax),%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8009b9:	eb 6f                	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8b 50 04             	mov    0x4(%eax),%edx
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	8d 40 08             	lea    0x8(%eax),%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8009d7:	eb 51                	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	8d 40 04             	lea    0x4(%eax),%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8009f7:	eb 31                	jmp    800a2a <vprintfmt+0x428>
			putch('0', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	53                   	push   %ebx
  8009fd:	6a 30                	push   $0x30
  8009ff:	ff d6                	call   *%esi
			putch('x', putdat);
  800a01:	83 c4 08             	add    $0x8,%esp
  800a04:	53                   	push   %ebx
  800a05:	6a 78                	push   $0x78
  800a07:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a19:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	8d 40 04             	lea    0x4(%eax),%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a25:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a31:	52                   	push   %edx
  800a32:	ff 75 e0             	pushl  -0x20(%ebp)
  800a35:	50                   	push   %eax
  800a36:	ff 75 dc             	pushl  -0x24(%ebp)
  800a39:	ff 75 d8             	pushl  -0x28(%ebp)
  800a3c:	89 da                	mov    %ebx,%edx
  800a3e:	89 f0                	mov    %esi,%eax
  800a40:	e8 a4 fa ff ff       	call   8004e9 <printnum>
			break;
  800a45:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a48:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4b:	83 c7 01             	add    $0x1,%edi
  800a4e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a52:	83 f8 25             	cmp    $0x25,%eax
  800a55:	0f 84 be fb ff ff    	je     800619 <vprintfmt+0x17>
			if (ch == '\0')
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	0f 84 28 01 00 00    	je     800b8b <vprintfmt+0x589>
			putch(ch, putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	50                   	push   %eax
  800a68:	ff d6                	call   *%esi
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	eb dc                	jmp    800a4b <vprintfmt+0x449>
	if (lflag >= 2)
  800a6f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a73:	7f 26                	jg     800a9b <vprintfmt+0x499>
	else if (lflag)
  800a75:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a79:	74 41                	je     800abc <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	8d 40 04             	lea    0x4(%eax),%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a94:	b8 10 00 00 00       	mov    $0x10,%eax
  800a99:	eb 8f                	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	8b 50 04             	mov    0x4(%eax),%edx
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	8d 40 08             	lea    0x8(%eax),%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab7:	e9 6e ff ff ff       	jmp    800a2a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	8b 00                	mov    (%eax),%eax
  800ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	8d 40 04             	lea    0x4(%eax),%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad5:	b8 10 00 00 00       	mov    $0x10,%eax
  800ada:	e9 4b ff ff ff       	jmp    800a2a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	8b 00                	mov    (%eax),%eax
  800aed:	85 c0                	test   %eax,%eax
  800aef:	74 14                	je     800b05 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800af1:	8b 13                	mov    (%ebx),%edx
  800af3:	83 fa 7f             	cmp    $0x7f,%edx
  800af6:	7f 37                	jg     800b2f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800af8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800afa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
  800b00:	e9 43 ff ff ff       	jmp    800a48 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0a:	bf f9 30 80 00       	mov    $0x8030f9,%edi
							putch(ch, putdat);
  800b0f:	83 ec 08             	sub    $0x8,%esp
  800b12:	53                   	push   %ebx
  800b13:	50                   	push   %eax
  800b14:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b16:	83 c7 01             	add    $0x1,%edi
  800b19:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	85 c0                	test   %eax,%eax
  800b22:	75 eb                	jne    800b0f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b27:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2a:	e9 19 ff ff ff       	jmp    800a48 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b2f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b36:	bf 31 31 80 00       	mov    $0x803131,%edi
							putch(ch, putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	53                   	push   %ebx
  800b3f:	50                   	push   %eax
  800b40:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b42:	83 c7 01             	add    $0x1,%edi
  800b45:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	85 c0                	test   %eax,%eax
  800b4e:	75 eb                	jne    800b3b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b53:	89 45 14             	mov    %eax,0x14(%ebp)
  800b56:	e9 ed fe ff ff       	jmp    800a48 <vprintfmt+0x446>
			putch(ch, putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	53                   	push   %ebx
  800b5f:	6a 25                	push   $0x25
  800b61:	ff d6                	call   *%esi
			break;
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	e9 dd fe ff ff       	jmp    800a48 <vprintfmt+0x446>
			putch('%', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	53                   	push   %ebx
  800b6f:	6a 25                	push   $0x25
  800b71:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 f8                	mov    %edi,%eax
  800b78:	eb 03                	jmp    800b7d <vprintfmt+0x57b>
  800b7a:	83 e8 01             	sub    $0x1,%eax
  800b7d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b81:	75 f7                	jne    800b7a <vprintfmt+0x578>
  800b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b86:	e9 bd fe ff ff       	jmp    800a48 <vprintfmt+0x446>
}
  800b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	83 ec 18             	sub    $0x18,%esp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ba6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb0:	85 c0                	test   %eax,%eax
  800bb2:	74 26                	je     800bda <vsnprintf+0x47>
  800bb4:	85 d2                	test   %edx,%edx
  800bb6:	7e 22                	jle    800bda <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb8:	ff 75 14             	pushl  0x14(%ebp)
  800bbb:	ff 75 10             	pushl  0x10(%ebp)
  800bbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc1:	50                   	push   %eax
  800bc2:	68 c8 05 80 00       	push   $0x8005c8
  800bc7:	e8 36 fa ff ff       	call   800602 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bcf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd5:	83 c4 10             	add    $0x10,%esp
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    
		return -E_INVAL;
  800bda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bdf:	eb f7                	jmp    800bd8 <vsnprintf+0x45>

00800be1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	50                   	push   %eax
  800beb:	ff 75 10             	pushl  0x10(%ebp)
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 9a ff ff ff       	call   800b93 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c0a:	74 05                	je     800c11 <strlen+0x16>
		n++;
  800c0c:	83 c0 01             	add    $0x1,%eax
  800c0f:	eb f5                	jmp    800c06 <strlen+0xb>
	return n;
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	39 c2                	cmp    %eax,%edx
  800c23:	74 0d                	je     800c32 <strnlen+0x1f>
  800c25:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c29:	74 05                	je     800c30 <strnlen+0x1d>
		n++;
  800c2b:	83 c2 01             	add    $0x1,%edx
  800c2e:	eb f1                	jmp    800c21 <strnlen+0xe>
  800c30:	89 d0                	mov    %edx,%eax
	return n;
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c43:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c47:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c4a:	83 c2 01             	add    $0x1,%edx
  800c4d:	84 c9                	test   %cl,%cl
  800c4f:	75 f2                	jne    800c43 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c51:	5b                   	pop    %ebx
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	53                   	push   %ebx
  800c58:	83 ec 10             	sub    $0x10,%esp
  800c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c5e:	53                   	push   %ebx
  800c5f:	e8 97 ff ff ff       	call   800bfb <strlen>
  800c64:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	01 d8                	add    %ebx,%eax
  800c6c:	50                   	push   %eax
  800c6d:	e8 c2 ff ff ff       	call   800c34 <strcpy>
	return dst;
}
  800c72:	89 d8                	mov    %ebx,%eax
  800c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	89 c6                	mov    %eax,%esi
  800c86:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	39 f2                	cmp    %esi,%edx
  800c8d:	74 11                	je     800ca0 <strncpy+0x27>
		*dst++ = *src;
  800c8f:	83 c2 01             	add    $0x1,%edx
  800c92:	0f b6 19             	movzbl (%ecx),%ebx
  800c95:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c98:	80 fb 01             	cmp    $0x1,%bl
  800c9b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c9e:	eb eb                	jmp    800c8b <strncpy+0x12>
	}
	return ret;
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	8b 75 08             	mov    0x8(%ebp),%esi
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	8b 55 10             	mov    0x10(%ebp),%edx
  800cb2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cb4:	85 d2                	test   %edx,%edx
  800cb6:	74 21                	je     800cd9 <strlcpy+0x35>
  800cb8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cbc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cbe:	39 c2                	cmp    %eax,%edx
  800cc0:	74 14                	je     800cd6 <strlcpy+0x32>
  800cc2:	0f b6 19             	movzbl (%ecx),%ebx
  800cc5:	84 db                	test   %bl,%bl
  800cc7:	74 0b                	je     800cd4 <strlcpy+0x30>
			*dst++ = *src++;
  800cc9:	83 c1 01             	add    $0x1,%ecx
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cd2:	eb ea                	jmp    800cbe <strlcpy+0x1a>
  800cd4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd9:	29 f0                	sub    %esi,%eax
}
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ce8:	0f b6 01             	movzbl (%ecx),%eax
  800ceb:	84 c0                	test   %al,%al
  800ced:	74 0c                	je     800cfb <strcmp+0x1c>
  800cef:	3a 02                	cmp    (%edx),%al
  800cf1:	75 08                	jne    800cfb <strcmp+0x1c>
		p++, q++;
  800cf3:	83 c1 01             	add    $0x1,%ecx
  800cf6:	83 c2 01             	add    $0x1,%edx
  800cf9:	eb ed                	jmp    800ce8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfb:	0f b6 c0             	movzbl %al,%eax
  800cfe:	0f b6 12             	movzbl (%edx),%edx
  800d01:	29 d0                	sub    %edx,%eax
}
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	53                   	push   %ebx
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	89 c3                	mov    %eax,%ebx
  800d11:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d14:	eb 06                	jmp    800d1c <strncmp+0x17>
		n--, p++, q++;
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d1c:	39 d8                	cmp    %ebx,%eax
  800d1e:	74 16                	je     800d36 <strncmp+0x31>
  800d20:	0f b6 08             	movzbl (%eax),%ecx
  800d23:	84 c9                	test   %cl,%cl
  800d25:	74 04                	je     800d2b <strncmp+0x26>
  800d27:	3a 0a                	cmp    (%edx),%cl
  800d29:	74 eb                	je     800d16 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	0f b6 00             	movzbl (%eax),%eax
  800d2e:	0f b6 12             	movzbl (%edx),%edx
  800d31:	29 d0                	sub    %edx,%eax
}
  800d33:	5b                   	pop    %ebx
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		return 0;
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	eb f6                	jmp    800d33 <strncmp+0x2e>

00800d3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d47:	0f b6 10             	movzbl (%eax),%edx
  800d4a:	84 d2                	test   %dl,%dl
  800d4c:	74 09                	je     800d57 <strchr+0x1a>
		if (*s == c)
  800d4e:	38 ca                	cmp    %cl,%dl
  800d50:	74 0a                	je     800d5c <strchr+0x1f>
	for (; *s; s++)
  800d52:	83 c0 01             	add    $0x1,%eax
  800d55:	eb f0                	jmp    800d47 <strchr+0xa>
			return (char *) s;
	return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d68:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d6b:	38 ca                	cmp    %cl,%dl
  800d6d:	74 09                	je     800d78 <strfind+0x1a>
  800d6f:	84 d2                	test   %dl,%dl
  800d71:	74 05                	je     800d78 <strfind+0x1a>
	for (; *s; s++)
  800d73:	83 c0 01             	add    $0x1,%eax
  800d76:	eb f0                	jmp    800d68 <strfind+0xa>
			break;
	return (char *) s;
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d86:	85 c9                	test   %ecx,%ecx
  800d88:	74 31                	je     800dbb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8a:	89 f8                	mov    %edi,%eax
  800d8c:	09 c8                	or     %ecx,%eax
  800d8e:	a8 03                	test   $0x3,%al
  800d90:	75 23                	jne    800db5 <memset+0x3b>
		c &= 0xFF;
  800d92:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d96:	89 d3                	mov    %edx,%ebx
  800d98:	c1 e3 08             	shl    $0x8,%ebx
  800d9b:	89 d0                	mov    %edx,%eax
  800d9d:	c1 e0 18             	shl    $0x18,%eax
  800da0:	89 d6                	mov    %edx,%esi
  800da2:	c1 e6 10             	shl    $0x10,%esi
  800da5:	09 f0                	or     %esi,%eax
  800da7:	09 c2                	or     %eax,%edx
  800da9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dab:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dae:	89 d0                	mov    %edx,%eax
  800db0:	fc                   	cld    
  800db1:	f3 ab                	rep stos %eax,%es:(%edi)
  800db3:	eb 06                	jmp    800dbb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	fc                   	cld    
  800db9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dbb:	89 f8                	mov    %edi,%eax
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd0:	39 c6                	cmp    %eax,%esi
  800dd2:	73 32                	jae    800e06 <memmove+0x44>
  800dd4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd7:	39 c2                	cmp    %eax,%edx
  800dd9:	76 2b                	jbe    800e06 <memmove+0x44>
		s += n;
		d += n;
  800ddb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dde:	89 fe                	mov    %edi,%esi
  800de0:	09 ce                	or     %ecx,%esi
  800de2:	09 d6                	or     %edx,%esi
  800de4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dea:	75 0e                	jne    800dfa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dec:	83 ef 04             	sub    $0x4,%edi
  800def:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df5:	fd                   	std    
  800df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df8:	eb 09                	jmp    800e03 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dfa:	83 ef 01             	sub    $0x1,%edi
  800dfd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e00:	fd                   	std    
  800e01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e03:	fc                   	cld    
  800e04:	eb 1a                	jmp    800e20 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e06:	89 c2                	mov    %eax,%edx
  800e08:	09 ca                	or     %ecx,%edx
  800e0a:	09 f2                	or     %esi,%edx
  800e0c:	f6 c2 03             	test   $0x3,%dl
  800e0f:	75 0a                	jne    800e1b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e14:	89 c7                	mov    %eax,%edi
  800e16:	fc                   	cld    
  800e17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e19:	eb 05                	jmp    800e20 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e1b:	89 c7                	mov    %eax,%edi
  800e1d:	fc                   	cld    
  800e1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2a:	ff 75 10             	pushl  0x10(%ebp)
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 8a ff ff ff       	call   800dc2 <memmove>
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	89 c6                	mov    %eax,%esi
  800e47:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e4a:	39 f0                	cmp    %esi,%eax
  800e4c:	74 1c                	je     800e6a <memcmp+0x30>
		if (*s1 != *s2)
  800e4e:	0f b6 08             	movzbl (%eax),%ecx
  800e51:	0f b6 1a             	movzbl (%edx),%ebx
  800e54:	38 d9                	cmp    %bl,%cl
  800e56:	75 08                	jne    800e60 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e58:	83 c0 01             	add    $0x1,%eax
  800e5b:	83 c2 01             	add    $0x1,%edx
  800e5e:	eb ea                	jmp    800e4a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e60:	0f b6 c1             	movzbl %cl,%eax
  800e63:	0f b6 db             	movzbl %bl,%ebx
  800e66:	29 d8                	sub    %ebx,%eax
  800e68:	eb 05                	jmp    800e6f <memcmp+0x35>
	}

	return 0;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e81:	39 d0                	cmp    %edx,%eax
  800e83:	73 09                	jae    800e8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e85:	38 08                	cmp    %cl,(%eax)
  800e87:	74 05                	je     800e8e <memfind+0x1b>
	for (; s < ends; s++)
  800e89:	83 c0 01             	add    $0x1,%eax
  800e8c:	eb f3                	jmp    800e81 <memfind+0xe>
			break;
	return (void *) s;
}
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x11>
		s++;
  800e9e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ea1:	0f b6 01             	movzbl (%ecx),%eax
  800ea4:	3c 20                	cmp    $0x20,%al
  800ea6:	74 f6                	je     800e9e <strtol+0xe>
  800ea8:	3c 09                	cmp    $0x9,%al
  800eaa:	74 f2                	je     800e9e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800eac:	3c 2b                	cmp    $0x2b,%al
  800eae:	74 2a                	je     800eda <strtol+0x4a>
	int neg = 0;
  800eb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eb5:	3c 2d                	cmp    $0x2d,%al
  800eb7:	74 2b                	je     800ee4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ebf:	75 0f                	jne    800ed0 <strtol+0x40>
  800ec1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ec4:	74 28                	je     800eee <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ec6:	85 db                	test   %ebx,%ebx
  800ec8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecd:	0f 44 d8             	cmove  %eax,%ebx
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ed8:	eb 50                	jmp    800f2a <strtol+0x9a>
		s++;
  800eda:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800edd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee2:	eb d5                	jmp    800eb9 <strtol+0x29>
		s++, neg = 1;
  800ee4:	83 c1 01             	add    $0x1,%ecx
  800ee7:	bf 01 00 00 00       	mov    $0x1,%edi
  800eec:	eb cb                	jmp    800eb9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eee:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ef2:	74 0e                	je     800f02 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ef4:	85 db                	test   %ebx,%ebx
  800ef6:	75 d8                	jne    800ed0 <strtol+0x40>
		s++, base = 8;
  800ef8:	83 c1 01             	add    $0x1,%ecx
  800efb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f00:	eb ce                	jmp    800ed0 <strtol+0x40>
		s += 2, base = 16;
  800f02:	83 c1 02             	add    $0x2,%ecx
  800f05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f0a:	eb c4                	jmp    800ed0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f0c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f0f:	89 f3                	mov    %esi,%ebx
  800f11:	80 fb 19             	cmp    $0x19,%bl
  800f14:	77 29                	ja     800f3f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f16:	0f be d2             	movsbl %dl,%edx
  800f19:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f1c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f1f:	7d 30                	jge    800f51 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f21:	83 c1 01             	add    $0x1,%ecx
  800f24:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2a:	0f b6 11             	movzbl (%ecx),%edx
  800f2d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f30:	89 f3                	mov    %esi,%ebx
  800f32:	80 fb 09             	cmp    $0x9,%bl
  800f35:	77 d5                	ja     800f0c <strtol+0x7c>
			dig = *s - '0';
  800f37:	0f be d2             	movsbl %dl,%edx
  800f3a:	83 ea 30             	sub    $0x30,%edx
  800f3d:	eb dd                	jmp    800f1c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f3f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f42:	89 f3                	mov    %esi,%ebx
  800f44:	80 fb 19             	cmp    $0x19,%bl
  800f47:	77 08                	ja     800f51 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f49:	0f be d2             	movsbl %dl,%edx
  800f4c:	83 ea 37             	sub    $0x37,%edx
  800f4f:	eb cb                	jmp    800f1c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f55:	74 05                	je     800f5c <strtol+0xcc>
		*endptr = (char *) s;
  800f57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f5a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	f7 da                	neg    %edx
  800f60:	85 ff                	test   %edi,%edi
  800f62:	0f 45 c2             	cmovne %edx,%eax
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f70:	b8 00 00 00 00       	mov    $0x0,%eax
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	89 c3                	mov    %eax,%ebx
  800f7d:	89 c7                	mov    %eax,%edi
  800f7f:	89 c6                	mov    %eax,%esi
  800f81:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f83:	5b                   	pop    %ebx
  800f84:	5e                   	pop    %esi
  800f85:	5f                   	pop    %edi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f93:	b8 01 00 00 00       	mov    $0x1,%eax
  800f98:	89 d1                	mov    %edx,%ecx
  800f9a:	89 d3                	mov    %edx,%ebx
  800f9c:	89 d7                	mov    %edx,%edi
  800f9e:	89 d6                	mov    %edx,%esi
  800fa0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	57                   	push   %edi
  800fab:	56                   	push   %esi
  800fac:	53                   	push   %ebx
  800fad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	b8 03 00 00 00       	mov    $0x3,%eax
  800fbd:	89 cb                	mov    %ecx,%ebx
  800fbf:	89 cf                	mov    %ecx,%edi
  800fc1:	89 ce                	mov    %ecx,%esi
  800fc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	7f 08                	jg     800fd1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	50                   	push   %eax
  800fd5:	6a 03                	push   $0x3
  800fd7:	68 48 33 80 00       	push   $0x803348
  800fdc:	6a 43                	push   $0x43
  800fde:	68 65 33 80 00       	push   $0x803365
  800fe3:	e8 f7 f3 ff ff       	call   8003df <_panic>

00800fe8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	57                   	push   %edi
  800fec:	56                   	push   %esi
  800fed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	b8 02 00 00 00       	mov    $0x2,%eax
  800ff8:	89 d1                	mov    %edx,%ecx
  800ffa:	89 d3                	mov    %edx,%ebx
  800ffc:	89 d7                	mov    %edx,%edi
  800ffe:	89 d6                	mov    %edx,%esi
  801000:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <sys_yield>:

void
sys_yield(void)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	b8 0b 00 00 00       	mov    $0xb,%eax
  801017:	89 d1                	mov    %edx,%ecx
  801019:	89 d3                	mov    %edx,%ebx
  80101b:	89 d7                	mov    %edx,%edi
  80101d:	89 d6                	mov    %edx,%esi
  80101f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
  80102c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102f:	be 00 00 00 00       	mov    $0x0,%esi
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103a:	b8 04 00 00 00       	mov    $0x4,%eax
  80103f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801042:	89 f7                	mov    %esi,%edi
  801044:	cd 30                	int    $0x30
	if(check && ret > 0)
  801046:	85 c0                	test   %eax,%eax
  801048:	7f 08                	jg     801052 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	50                   	push   %eax
  801056:	6a 04                	push   $0x4
  801058:	68 48 33 80 00       	push   $0x803348
  80105d:	6a 43                	push   $0x43
  80105f:	68 65 33 80 00       	push   $0x803365
  801064:	e8 76 f3 ff ff       	call   8003df <_panic>

00801069 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
  80106f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801072:	8b 55 08             	mov    0x8(%ebp),%edx
  801075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801078:	b8 05 00 00 00       	mov    $0x5,%eax
  80107d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801080:	8b 7d 14             	mov    0x14(%ebp),%edi
  801083:	8b 75 18             	mov    0x18(%ebp),%esi
  801086:	cd 30                	int    $0x30
	if(check && ret > 0)
  801088:	85 c0                	test   %eax,%eax
  80108a:	7f 08                	jg     801094 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	50                   	push   %eax
  801098:	6a 05                	push   $0x5
  80109a:	68 48 33 80 00       	push   $0x803348
  80109f:	6a 43                	push   $0x43
  8010a1:	68 65 33 80 00       	push   $0x803365
  8010a6:	e8 34 f3 ff ff       	call   8003df <_panic>

008010ab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
  8010b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8010c4:	89 df                	mov    %ebx,%edi
  8010c6:	89 de                	mov    %ebx,%esi
  8010c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	7f 08                	jg     8010d6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d6:	83 ec 0c             	sub    $0xc,%esp
  8010d9:	50                   	push   %eax
  8010da:	6a 06                	push   $0x6
  8010dc:	68 48 33 80 00       	push   $0x803348
  8010e1:	6a 43                	push   $0x43
  8010e3:	68 65 33 80 00       	push   $0x803365
  8010e8:	e8 f2 f2 ff ff       	call   8003df <_panic>

008010ed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	57                   	push   %edi
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801101:	b8 08 00 00 00       	mov    $0x8,%eax
  801106:	89 df                	mov    %ebx,%edi
  801108:	89 de                	mov    %ebx,%esi
  80110a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	7f 08                	jg     801118 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	50                   	push   %eax
  80111c:	6a 08                	push   $0x8
  80111e:	68 48 33 80 00       	push   $0x803348
  801123:	6a 43                	push   $0x43
  801125:	68 65 33 80 00       	push   $0x803365
  80112a:	e8 b0 f2 ff ff       	call   8003df <_panic>

0080112f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	57                   	push   %edi
  801133:	56                   	push   %esi
  801134:	53                   	push   %ebx
  801135:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801138:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801143:	b8 09 00 00 00       	mov    $0x9,%eax
  801148:	89 df                	mov    %ebx,%edi
  80114a:	89 de                	mov    %ebx,%esi
  80114c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114e:	85 c0                	test   %eax,%eax
  801150:	7f 08                	jg     80115a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	50                   	push   %eax
  80115e:	6a 09                	push   $0x9
  801160:	68 48 33 80 00       	push   $0x803348
  801165:	6a 43                	push   $0x43
  801167:	68 65 33 80 00       	push   $0x803365
  80116c:	e8 6e f2 ff ff       	call   8003df <_panic>

00801171 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
  801177:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117f:	8b 55 08             	mov    0x8(%ebp),%edx
  801182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801185:	b8 0a 00 00 00       	mov    $0xa,%eax
  80118a:	89 df                	mov    %ebx,%edi
  80118c:	89 de                	mov    %ebx,%esi
  80118e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801190:	85 c0                	test   %eax,%eax
  801192:	7f 08                	jg     80119c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	50                   	push   %eax
  8011a0:	6a 0a                	push   $0xa
  8011a2:	68 48 33 80 00       	push   $0x803348
  8011a7:	6a 43                	push   $0x43
  8011a9:	68 65 33 80 00       	push   $0x803365
  8011ae:	e8 2c f2 ff ff       	call   8003df <_panic>

008011b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	57                   	push   %edi
  8011b7:	56                   	push   %esi
  8011b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bf:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011c4:	be 00 00 00 00       	mov    $0x0,%esi
  8011c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011cc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011cf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011d1:	5b                   	pop    %ebx
  8011d2:	5e                   	pop    %esi
  8011d3:	5f                   	pop    %edi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	57                   	push   %edi
  8011da:	56                   	push   %esi
  8011db:	53                   	push   %ebx
  8011dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011ec:	89 cb                	mov    %ecx,%ebx
  8011ee:	89 cf                	mov    %ecx,%edi
  8011f0:	89 ce                	mov    %ecx,%esi
  8011f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	7f 08                	jg     801200 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801200:	83 ec 0c             	sub    $0xc,%esp
  801203:	50                   	push   %eax
  801204:	6a 0d                	push   $0xd
  801206:	68 48 33 80 00       	push   $0x803348
  80120b:	6a 43                	push   $0x43
  80120d:	68 65 33 80 00       	push   $0x803365
  801212:	e8 c8 f1 ff ff       	call   8003df <_panic>

00801217 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	57                   	push   %edi
  80121b:	56                   	push   %esi
  80121c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80121d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801222:	8b 55 08             	mov    0x8(%ebp),%edx
  801225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801228:	b8 0e 00 00 00       	mov    $0xe,%eax
  80122d:	89 df                	mov    %ebx,%edi
  80122f:	89 de                	mov    %ebx,%esi
  801231:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	57                   	push   %edi
  80123c:	56                   	push   %esi
  80123d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80123e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	b8 0f 00 00 00       	mov    $0xf,%eax
  80124b:	89 cb                	mov    %ecx,%ebx
  80124d:	89 cf                	mov    %ecx,%edi
  80124f:	89 ce                	mov    %ecx,%esi
  801251:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5f                   	pop    %edi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	57                   	push   %edi
  80125c:	56                   	push   %esi
  80125d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80125e:	ba 00 00 00 00       	mov    $0x0,%edx
  801263:	b8 10 00 00 00       	mov    $0x10,%eax
  801268:	89 d1                	mov    %edx,%ecx
  80126a:	89 d3                	mov    %edx,%ebx
  80126c:	89 d7                	mov    %edx,%edi
  80126e:	89 d6                	mov    %edx,%esi
  801270:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801272:	5b                   	pop    %ebx
  801273:	5e                   	pop    %esi
  801274:	5f                   	pop    %edi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	57                   	push   %edi
  80127b:	56                   	push   %esi
  80127c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801282:	8b 55 08             	mov    0x8(%ebp),%edx
  801285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801288:	b8 11 00 00 00       	mov    $0x11,%eax
  80128d:	89 df                	mov    %ebx,%edi
  80128f:	89 de                	mov    %ebx,%esi
  801291:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801293:	5b                   	pop    %ebx
  801294:	5e                   	pop    %esi
  801295:	5f                   	pop    %edi
  801296:	5d                   	pop    %ebp
  801297:	c3                   	ret    

00801298 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	57                   	push   %edi
  80129c:	56                   	push   %esi
  80129d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80129e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a9:	b8 12 00 00 00       	mov    $0x12,%eax
  8012ae:	89 df                	mov    %ebx,%edi
  8012b0:	89 de                	mov    %ebx,%esi
  8012b2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012b4:	5b                   	pop    %ebx
  8012b5:	5e                   	pop    %esi
  8012b6:	5f                   	pop    %edi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cd:	b8 13 00 00 00       	mov    $0x13,%eax
  8012d2:	89 df                	mov    %ebx,%edi
  8012d4:	89 de                	mov    %ebx,%esi
  8012d6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	7f 08                	jg     8012e4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	5f                   	pop    %edi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	50                   	push   %eax
  8012e8:	6a 13                	push   $0x13
  8012ea:	68 48 33 80 00       	push   $0x803348
  8012ef:	6a 43                	push   $0x43
  8012f1:	68 65 33 80 00       	push   $0x803365
  8012f6:	e8 e4 f0 ff ff       	call   8003df <_panic>

008012fb <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
	asm volatile("int %1\n"
  801301:	b9 00 00 00 00       	mov    $0x0,%ecx
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	b8 14 00 00 00       	mov    $0x14,%eax
  80130e:	89 cb                	mov    %ecx,%ebx
  801310:	89 cf                	mov    %ecx,%edi
  801312:	89 ce                	mov    %ecx,%esi
  801314:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801316:	5b                   	pop    %ebx
  801317:	5e                   	pop    %esi
  801318:	5f                   	pop    %edi
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	53                   	push   %ebx
  80131f:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801322:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801329:	f6 c5 04             	test   $0x4,%ch
  80132c:	75 45                	jne    801373 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80132e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801335:	83 e1 07             	and    $0x7,%ecx
  801338:	83 f9 07             	cmp    $0x7,%ecx
  80133b:	74 6f                	je     8013ac <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80133d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801344:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80134a:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801350:	0f 84 b6 00 00 00    	je     80140c <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801356:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80135d:	83 e1 05             	and    $0x5,%ecx
  801360:	83 f9 05             	cmp    $0x5,%ecx
  801363:	0f 84 d7 00 00 00    	je     801440 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801371:	c9                   	leave  
  801372:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801373:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80137a:	c1 e2 0c             	shl    $0xc,%edx
  80137d:	83 ec 0c             	sub    $0xc,%esp
  801380:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801386:	51                   	push   %ecx
  801387:	52                   	push   %edx
  801388:	50                   	push   %eax
  801389:	52                   	push   %edx
  80138a:	6a 00                	push   $0x0
  80138c:	e8 d8 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  801391:	83 c4 20             	add    $0x20,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	79 d1                	jns    801369 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	68 73 33 80 00       	push   $0x803373
  8013a0:	6a 54                	push   $0x54
  8013a2:	68 89 33 80 00       	push   $0x803389
  8013a7:	e8 33 f0 ff ff       	call   8003df <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013ac:	89 d3                	mov    %edx,%ebx
  8013ae:	c1 e3 0c             	shl    $0xc,%ebx
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	68 05 08 00 00       	push   $0x805
  8013b9:	53                   	push   %ebx
  8013ba:	50                   	push   %eax
  8013bb:	53                   	push   %ebx
  8013bc:	6a 00                	push   $0x0
  8013be:	e8 a6 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  8013c3:	83 c4 20             	add    $0x20,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 2e                	js     8013f8 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8013ca:	83 ec 0c             	sub    $0xc,%esp
  8013cd:	68 05 08 00 00       	push   $0x805
  8013d2:	53                   	push   %ebx
  8013d3:	6a 00                	push   $0x0
  8013d5:	53                   	push   %ebx
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 8c fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  8013dd:	83 c4 20             	add    $0x20,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	79 85                	jns    801369 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 73 33 80 00       	push   $0x803373
  8013ec:	6a 5f                	push   $0x5f
  8013ee:	68 89 33 80 00       	push   $0x803389
  8013f3:	e8 e7 ef ff ff       	call   8003df <_panic>
			panic("sys_page_map() panic\n");
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 73 33 80 00       	push   $0x803373
  801400:	6a 5b                	push   $0x5b
  801402:	68 89 33 80 00       	push   $0x803389
  801407:	e8 d3 ef ff ff       	call   8003df <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80140c:	c1 e2 0c             	shl    $0xc,%edx
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	68 05 08 00 00       	push   $0x805
  801417:	52                   	push   %edx
  801418:	50                   	push   %eax
  801419:	52                   	push   %edx
  80141a:	6a 00                	push   $0x0
  80141c:	e8 48 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  801421:	83 c4 20             	add    $0x20,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	0f 89 3d ff ff ff    	jns    801369 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	68 73 33 80 00       	push   $0x803373
  801434:	6a 66                	push   $0x66
  801436:	68 89 33 80 00       	push   $0x803389
  80143b:	e8 9f ef ff ff       	call   8003df <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801440:	c1 e2 0c             	shl    $0xc,%edx
  801443:	83 ec 0c             	sub    $0xc,%esp
  801446:	6a 05                	push   $0x5
  801448:	52                   	push   %edx
  801449:	50                   	push   %eax
  80144a:	52                   	push   %edx
  80144b:	6a 00                	push   $0x0
  80144d:	e8 17 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  801452:	83 c4 20             	add    $0x20,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	0f 89 0c ff ff ff    	jns    801369 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	68 73 33 80 00       	push   $0x803373
  801465:	6a 6d                	push   $0x6d
  801467:	68 89 33 80 00       	push   $0x803389
  80146c:	e8 6e ef ff ff       	call   8003df <_panic>

00801471 <pgfault>:
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80147b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80147d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801481:	0f 84 99 00 00 00    	je     801520 <pgfault+0xaf>
  801487:	89 c2                	mov    %eax,%edx
  801489:	c1 ea 16             	shr    $0x16,%edx
  80148c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801493:	f6 c2 01             	test   $0x1,%dl
  801496:	0f 84 84 00 00 00    	je     801520 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80149c:	89 c2                	mov    %eax,%edx
  80149e:	c1 ea 0c             	shr    $0xc,%edx
  8014a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a8:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8014ae:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8014b4:	75 6a                	jne    801520 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8014b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014bb:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	6a 07                	push   $0x7
  8014c2:	68 00 f0 7f 00       	push   $0x7ff000
  8014c7:	6a 00                	push   $0x0
  8014c9:	e8 58 fb ff ff       	call   801026 <sys_page_alloc>
	if(ret < 0)
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 5f                	js     801534 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	68 00 10 00 00       	push   $0x1000
  8014dd:	53                   	push   %ebx
  8014de:	68 00 f0 7f 00       	push   $0x7ff000
  8014e3:	e8 3c f9 ff ff       	call   800e24 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014e8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014ef:	53                   	push   %ebx
  8014f0:	6a 00                	push   $0x0
  8014f2:	68 00 f0 7f 00       	push   $0x7ff000
  8014f7:	6a 00                	push   $0x0
  8014f9:	e8 6b fb ff ff       	call   801069 <sys_page_map>
	if(ret < 0)
  8014fe:	83 c4 20             	add    $0x20,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 43                	js     801548 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	68 00 f0 7f 00       	push   $0x7ff000
  80150d:	6a 00                	push   $0x0
  80150f:	e8 97 fb ff ff       	call   8010ab <sys_page_unmap>
	if(ret < 0)
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 41                	js     80155c <pgfault+0xeb>
}
  80151b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    
		panic("panic at pgfault()\n");
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	68 94 33 80 00       	push   $0x803394
  801528:	6a 26                	push   $0x26
  80152a:	68 89 33 80 00       	push   $0x803389
  80152f:	e8 ab ee ff ff       	call   8003df <_panic>
		panic("panic in sys_page_alloc()\n");
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	68 a8 33 80 00       	push   $0x8033a8
  80153c:	6a 31                	push   $0x31
  80153e:	68 89 33 80 00       	push   $0x803389
  801543:	e8 97 ee ff ff       	call   8003df <_panic>
		panic("panic in sys_page_map()\n");
  801548:	83 ec 04             	sub    $0x4,%esp
  80154b:	68 c3 33 80 00       	push   $0x8033c3
  801550:	6a 36                	push   $0x36
  801552:	68 89 33 80 00       	push   $0x803389
  801557:	e8 83 ee ff ff       	call   8003df <_panic>
		panic("panic in sys_page_unmap()\n");
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	68 dc 33 80 00       	push   $0x8033dc
  801564:	6a 39                	push   $0x39
  801566:	68 89 33 80 00       	push   $0x803389
  80156b:	e8 6f ee ff ff       	call   8003df <_panic>

00801570 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	57                   	push   %edi
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
  801576:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801579:	68 71 14 80 00       	push   $0x801471
  80157e:	e8 24 14 00 00       	call   8029a7 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801583:	b8 07 00 00 00       	mov    $0x7,%eax
  801588:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 27                	js     8015b8 <fork+0x48>
  801591:	89 c6                	mov    %eax,%esi
  801593:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801595:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80159a:	75 48                	jne    8015e4 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80159c:	e8 47 fa ff ff       	call   800fe8 <sys_getenvid>
  8015a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015a6:	c1 e0 07             	shl    $0x7,%eax
  8015a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015ae:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015b3:	e9 90 00 00 00       	jmp    801648 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	68 f8 33 80 00       	push   $0x8033f8
  8015c0:	68 8c 00 00 00       	push   $0x8c
  8015c5:	68 89 33 80 00       	push   $0x803389
  8015ca:	e8 10 ee ff ff       	call   8003df <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8015cf:	89 f8                	mov    %edi,%eax
  8015d1:	e8 45 fd ff ff       	call   80131b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015dc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8015e2:	74 26                	je     80160a <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8015e4:	89 d8                	mov    %ebx,%eax
  8015e6:	c1 e8 16             	shr    $0x16,%eax
  8015e9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f0:	a8 01                	test   $0x1,%al
  8015f2:	74 e2                	je     8015d6 <fork+0x66>
  8015f4:	89 da                	mov    %ebx,%edx
  8015f6:	c1 ea 0c             	shr    $0xc,%edx
  8015f9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801600:	83 e0 05             	and    $0x5,%eax
  801603:	83 f8 05             	cmp    $0x5,%eax
  801606:	75 ce                	jne    8015d6 <fork+0x66>
  801608:	eb c5                	jmp    8015cf <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	6a 07                	push   $0x7
  80160f:	68 00 f0 bf ee       	push   $0xeebff000
  801614:	56                   	push   %esi
  801615:	e8 0c fa ff ff       	call   801026 <sys_page_alloc>
	if(ret < 0)
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 31                	js     801652 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	68 16 2a 80 00       	push   $0x802a16
  801629:	56                   	push   %esi
  80162a:	e8 42 fb ff ff       	call   801171 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 33                	js     801669 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	6a 02                	push   $0x2
  80163b:	56                   	push   %esi
  80163c:	e8 ac fa ff ff       	call   8010ed <sys_env_set_status>
	if(ret < 0)
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	85 c0                	test   %eax,%eax
  801646:	78 38                	js     801680 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801648:	89 f0                	mov    %esi,%eax
  80164a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164d:	5b                   	pop    %ebx
  80164e:	5e                   	pop    %esi
  80164f:	5f                   	pop    %edi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	68 a8 33 80 00       	push   $0x8033a8
  80165a:	68 98 00 00 00       	push   $0x98
  80165f:	68 89 33 80 00       	push   $0x803389
  801664:	e8 76 ed ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 1c 34 80 00       	push   $0x80341c
  801671:	68 9b 00 00 00       	push   $0x9b
  801676:	68 89 33 80 00       	push   $0x803389
  80167b:	e8 5f ed ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_status()\n");
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	68 44 34 80 00       	push   $0x803444
  801688:	68 9e 00 00 00       	push   $0x9e
  80168d:	68 89 33 80 00       	push   $0x803389
  801692:	e8 48 ed ff ff       	call   8003df <_panic>

00801697 <sfork>:

// Challenge!
int
sfork(void)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	57                   	push   %edi
  80169b:	56                   	push   %esi
  80169c:	53                   	push   %ebx
  80169d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8016a0:	68 71 14 80 00       	push   $0x801471
  8016a5:	e8 fd 12 00 00       	call   8029a7 <set_pgfault_handler>
  8016aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8016af:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	78 27                	js     8016df <sfork+0x48>
  8016b8:	89 c7                	mov    %eax,%edi
  8016ba:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016bc:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016c1:	75 55                	jne    801718 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016c3:	e8 20 f9 ff ff       	call   800fe8 <sys_getenvid>
  8016c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016cd:	c1 e0 07             	shl    $0x7,%eax
  8016d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016d5:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8016da:	e9 d4 00 00 00       	jmp    8017b3 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	68 f8 33 80 00       	push   $0x8033f8
  8016e7:	68 af 00 00 00       	push   $0xaf
  8016ec:	68 89 33 80 00       	push   $0x803389
  8016f1:	e8 e9 ec ff ff       	call   8003df <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8016f6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8016fb:	89 f0                	mov    %esi,%eax
  8016fd:	e8 19 fc ff ff       	call   80131b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801702:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801708:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80170e:	77 65                	ja     801775 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801710:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801716:	74 de                	je     8016f6 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	c1 e8 16             	shr    $0x16,%eax
  80171d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801724:	a8 01                	test   $0x1,%al
  801726:	74 da                	je     801702 <sfork+0x6b>
  801728:	89 da                	mov    %ebx,%edx
  80172a:	c1 ea 0c             	shr    $0xc,%edx
  80172d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801734:	83 e0 05             	and    $0x5,%eax
  801737:	83 f8 05             	cmp    $0x5,%eax
  80173a:	75 c6                	jne    801702 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80173c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801743:	c1 e2 0c             	shl    $0xc,%edx
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	83 e0 07             	and    $0x7,%eax
  80174c:	50                   	push   %eax
  80174d:	52                   	push   %edx
  80174e:	56                   	push   %esi
  80174f:	52                   	push   %edx
  801750:	6a 00                	push   $0x0
  801752:	e8 12 f9 ff ff       	call   801069 <sys_page_map>
  801757:	83 c4 20             	add    $0x20,%esp
  80175a:	85 c0                	test   %eax,%eax
  80175c:	74 a4                	je     801702 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	68 73 33 80 00       	push   $0x803373
  801766:	68 ba 00 00 00       	push   $0xba
  80176b:	68 89 33 80 00       	push   $0x803389
  801770:	e8 6a ec ff ff       	call   8003df <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	6a 07                	push   $0x7
  80177a:	68 00 f0 bf ee       	push   $0xeebff000
  80177f:	57                   	push   %edi
  801780:	e8 a1 f8 ff ff       	call   801026 <sys_page_alloc>
	if(ret < 0)
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 31                	js     8017bd <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	68 16 2a 80 00       	push   $0x802a16
  801794:	57                   	push   %edi
  801795:	e8 d7 f9 ff ff       	call   801171 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 33                	js     8017d4 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	6a 02                	push   $0x2
  8017a6:	57                   	push   %edi
  8017a7:	e8 41 f9 ff ff       	call   8010ed <sys_env_set_status>
	if(ret < 0)
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 38                	js     8017eb <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8017b3:	89 f8                	mov    %edi,%eax
  8017b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5f                   	pop    %edi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 a8 33 80 00       	push   $0x8033a8
  8017c5:	68 c0 00 00 00       	push   $0xc0
  8017ca:	68 89 33 80 00       	push   $0x803389
  8017cf:	e8 0b ec ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 1c 34 80 00       	push   $0x80341c
  8017dc:	68 c3 00 00 00       	push   $0xc3
  8017e1:	68 89 33 80 00       	push   $0x803389
  8017e6:	e8 f4 eb ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_status()\n");
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 44 34 80 00       	push   $0x803444
  8017f3:	68 c6 00 00 00       	push   $0xc6
  8017f8:	68 89 33 80 00       	push   $0x803389
  8017fd:	e8 dd eb ff ff       	call   8003df <_panic>

00801802 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	05 00 00 00 30       	add    $0x30000000,%eax
  80180d:	c1 e8 0c             	shr    $0xc,%eax
}
  801810:	5d                   	pop    %ebp
  801811:	c3                   	ret    

00801812 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80181d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801822:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    

00801829 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801831:	89 c2                	mov    %eax,%edx
  801833:	c1 ea 16             	shr    $0x16,%edx
  801836:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80183d:	f6 c2 01             	test   $0x1,%dl
  801840:	74 2d                	je     80186f <fd_alloc+0x46>
  801842:	89 c2                	mov    %eax,%edx
  801844:	c1 ea 0c             	shr    $0xc,%edx
  801847:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80184e:	f6 c2 01             	test   $0x1,%dl
  801851:	74 1c                	je     80186f <fd_alloc+0x46>
  801853:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801858:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80185d:	75 d2                	jne    801831 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801868:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80186d:	eb 0a                	jmp    801879 <fd_alloc+0x50>
			*fd_store = fd;
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	89 01                	mov    %eax,(%ecx)
			return 0;
  801874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801879:	5d                   	pop    %ebp
  80187a:	c3                   	ret    

0080187b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801881:	83 f8 1f             	cmp    $0x1f,%eax
  801884:	77 30                	ja     8018b6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801886:	c1 e0 0c             	shl    $0xc,%eax
  801889:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80188e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801894:	f6 c2 01             	test   $0x1,%dl
  801897:	74 24                	je     8018bd <fd_lookup+0x42>
  801899:	89 c2                	mov    %eax,%edx
  80189b:	c1 ea 0c             	shr    $0xc,%edx
  80189e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018a5:	f6 c2 01             	test   $0x1,%dl
  8018a8:	74 1a                	je     8018c4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	89 02                	mov    %eax,(%edx)
	return 0;
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    
		return -E_INVAL;
  8018b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bb:	eb f7                	jmp    8018b4 <fd_lookup+0x39>
		return -E_INVAL;
  8018bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c2:	eb f0                	jmp    8018b4 <fd_lookup+0x39>
  8018c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c9:	eb e9                	jmp    8018b4 <fd_lookup+0x39>

008018cb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
  8018d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d9:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018de:	39 08                	cmp    %ecx,(%eax)
  8018e0:	74 38                	je     80191a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018e2:	83 c2 01             	add    $0x1,%edx
  8018e5:	8b 04 95 e0 34 80 00 	mov    0x8034e0(,%edx,4),%eax
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	75 ee                	jne    8018de <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018f0:	a1 08 50 80 00       	mov    0x805008,%eax
  8018f5:	8b 40 48             	mov    0x48(%eax),%eax
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	51                   	push   %ecx
  8018fc:	50                   	push   %eax
  8018fd:	68 64 34 80 00       	push   $0x803464
  801902:	e8 ce eb ff ff       	call   8004d5 <cprintf>
	*dev = 0;
  801907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    
			*dev = devtab[i];
  80191a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
  801924:	eb f2                	jmp    801918 <dev_lookup+0x4d>

00801926 <fd_close>:
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	57                   	push   %edi
  80192a:	56                   	push   %esi
  80192b:	53                   	push   %ebx
  80192c:	83 ec 24             	sub    $0x24,%esp
  80192f:	8b 75 08             	mov    0x8(%ebp),%esi
  801932:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801935:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801938:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801939:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80193f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801942:	50                   	push   %eax
  801943:	e8 33 ff ff ff       	call   80187b <fd_lookup>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 05                	js     801956 <fd_close+0x30>
	    || fd != fd2)
  801951:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801954:	74 16                	je     80196c <fd_close+0x46>
		return (must_exist ? r : 0);
  801956:	89 f8                	mov    %edi,%eax
  801958:	84 c0                	test   %al,%al
  80195a:	b8 00 00 00 00       	mov    $0x0,%eax
  80195f:	0f 44 d8             	cmove  %eax,%ebx
}
  801962:	89 d8                	mov    %ebx,%eax
  801964:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80196c:	83 ec 08             	sub    $0x8,%esp
  80196f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801972:	50                   	push   %eax
  801973:	ff 36                	pushl  (%esi)
  801975:	e8 51 ff ff ff       	call   8018cb <dev_lookup>
  80197a:	89 c3                	mov    %eax,%ebx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 1a                	js     80199d <fd_close+0x77>
		if (dev->dev_close)
  801983:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801986:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801989:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80198e:	85 c0                	test   %eax,%eax
  801990:	74 0b                	je     80199d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	56                   	push   %esi
  801996:	ff d0                	call   *%eax
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	56                   	push   %esi
  8019a1:	6a 00                	push   $0x0
  8019a3:	e8 03 f7 ff ff       	call   8010ab <sys_page_unmap>
	return r;
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	eb b5                	jmp    801962 <fd_close+0x3c>

008019ad <close>:

int
close(int fdnum)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b6:	50                   	push   %eax
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 bc fe ff ff       	call   80187b <fd_lookup>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	79 02                	jns    8019c8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    
		return fd_close(fd, 1);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	6a 01                	push   $0x1
  8019cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d0:	e8 51 ff ff ff       	call   801926 <fd_close>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	eb ec                	jmp    8019c6 <close+0x19>

008019da <close_all>:

void
close_all(void)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	53                   	push   %ebx
  8019ea:	e8 be ff ff ff       	call   8019ad <close>
	for (i = 0; i < MAXFD; i++)
  8019ef:	83 c3 01             	add    $0x1,%ebx
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	83 fb 20             	cmp    $0x20,%ebx
  8019f8:	75 ec                	jne    8019e6 <close_all+0xc>
}
  8019fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a08:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a0b:	50                   	push   %eax
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	e8 67 fe ff ff       	call   80187b <fd_lookup>
  801a14:	89 c3                	mov    %eax,%ebx
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	0f 88 81 00 00 00    	js     801aa2 <dup+0xa3>
		return r;
	close(newfdnum);
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	e8 81 ff ff ff       	call   8019ad <close>

	newfd = INDEX2FD(newfdnum);
  801a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a2f:	c1 e6 0c             	shl    $0xc,%esi
  801a32:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a38:	83 c4 04             	add    $0x4,%esp
  801a3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a3e:	e8 cf fd ff ff       	call   801812 <fd2data>
  801a43:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a45:	89 34 24             	mov    %esi,(%esp)
  801a48:	e8 c5 fd ff ff       	call   801812 <fd2data>
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a52:	89 d8                	mov    %ebx,%eax
  801a54:	c1 e8 16             	shr    $0x16,%eax
  801a57:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a5e:	a8 01                	test   $0x1,%al
  801a60:	74 11                	je     801a73 <dup+0x74>
  801a62:	89 d8                	mov    %ebx,%eax
  801a64:	c1 e8 0c             	shr    $0xc,%eax
  801a67:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a6e:	f6 c2 01             	test   $0x1,%dl
  801a71:	75 39                	jne    801aac <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a76:	89 d0                	mov    %edx,%eax
  801a78:	c1 e8 0c             	shr    $0xc,%eax
  801a7b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	25 07 0e 00 00       	and    $0xe07,%eax
  801a8a:	50                   	push   %eax
  801a8b:	56                   	push   %esi
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	6a 00                	push   $0x0
  801a91:	e8 d3 f5 ff ff       	call   801069 <sys_page_map>
  801a96:	89 c3                	mov    %eax,%ebx
  801a98:	83 c4 20             	add    $0x20,%esp
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 31                	js     801ad0 <dup+0xd1>
		goto err;

	return newfdnum;
  801a9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801aa2:	89 d8                	mov    %ebx,%eax
  801aa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5f                   	pop    %edi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801aac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab3:	83 ec 0c             	sub    $0xc,%esp
  801ab6:	25 07 0e 00 00       	and    $0xe07,%eax
  801abb:	50                   	push   %eax
  801abc:	57                   	push   %edi
  801abd:	6a 00                	push   $0x0
  801abf:	53                   	push   %ebx
  801ac0:	6a 00                	push   $0x0
  801ac2:	e8 a2 f5 ff ff       	call   801069 <sys_page_map>
  801ac7:	89 c3                	mov    %eax,%ebx
  801ac9:	83 c4 20             	add    $0x20,%esp
  801acc:	85 c0                	test   %eax,%eax
  801ace:	79 a3                	jns    801a73 <dup+0x74>
	sys_page_unmap(0, newfd);
  801ad0:	83 ec 08             	sub    $0x8,%esp
  801ad3:	56                   	push   %esi
  801ad4:	6a 00                	push   $0x0
  801ad6:	e8 d0 f5 ff ff       	call   8010ab <sys_page_unmap>
	sys_page_unmap(0, nva);
  801adb:	83 c4 08             	add    $0x8,%esp
  801ade:	57                   	push   %edi
  801adf:	6a 00                	push   $0x0
  801ae1:	e8 c5 f5 ff ff       	call   8010ab <sys_page_unmap>
	return r;
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb b7                	jmp    801aa2 <dup+0xa3>

00801aeb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	53                   	push   %ebx
  801aef:	83 ec 1c             	sub    $0x1c,%esp
  801af2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af8:	50                   	push   %eax
  801af9:	53                   	push   %ebx
  801afa:	e8 7c fd ff ff       	call   80187b <fd_lookup>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 3f                	js     801b45 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b06:	83 ec 08             	sub    $0x8,%esp
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b10:	ff 30                	pushl  (%eax)
  801b12:	e8 b4 fd ff ff       	call   8018cb <dev_lookup>
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 27                	js     801b45 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b21:	8b 42 08             	mov    0x8(%edx),%eax
  801b24:	83 e0 03             	and    $0x3,%eax
  801b27:	83 f8 01             	cmp    $0x1,%eax
  801b2a:	74 1e                	je     801b4a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	8b 40 08             	mov    0x8(%eax),%eax
  801b32:	85 c0                	test   %eax,%eax
  801b34:	74 35                	je     801b6b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	ff 75 10             	pushl  0x10(%ebp)
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	52                   	push   %edx
  801b40:	ff d0                	call   *%eax
  801b42:	83 c4 10             	add    $0x10,%esp
}
  801b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b4a:	a1 08 50 80 00       	mov    0x805008,%eax
  801b4f:	8b 40 48             	mov    0x48(%eax),%eax
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	53                   	push   %ebx
  801b56:	50                   	push   %eax
  801b57:	68 a5 34 80 00       	push   $0x8034a5
  801b5c:	e8 74 e9 ff ff       	call   8004d5 <cprintf>
		return -E_INVAL;
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b69:	eb da                	jmp    801b45 <read+0x5a>
		return -E_NOT_SUPP;
  801b6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b70:	eb d3                	jmp    801b45 <read+0x5a>

00801b72 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b7e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b81:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b86:	39 f3                	cmp    %esi,%ebx
  801b88:	73 23                	jae    801bad <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	89 f0                	mov    %esi,%eax
  801b8f:	29 d8                	sub    %ebx,%eax
  801b91:	50                   	push   %eax
  801b92:	89 d8                	mov    %ebx,%eax
  801b94:	03 45 0c             	add    0xc(%ebp),%eax
  801b97:	50                   	push   %eax
  801b98:	57                   	push   %edi
  801b99:	e8 4d ff ff ff       	call   801aeb <read>
		if (m < 0)
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 06                	js     801bab <readn+0x39>
			return m;
		if (m == 0)
  801ba5:	74 06                	je     801bad <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ba7:	01 c3                	add    %eax,%ebx
  801ba9:	eb db                	jmp    801b86 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bab:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801bad:	89 d8                	mov    %ebx,%eax
  801baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb2:	5b                   	pop    %ebx
  801bb3:	5e                   	pop    %esi
  801bb4:	5f                   	pop    %edi
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    

00801bb7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 1c             	sub    $0x1c,%esp
  801bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc4:	50                   	push   %eax
  801bc5:	53                   	push   %ebx
  801bc6:	e8 b0 fc ff ff       	call   80187b <fd_lookup>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 3a                	js     801c0c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd8:	50                   	push   %eax
  801bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdc:	ff 30                	pushl  (%eax)
  801bde:	e8 e8 fc ff ff       	call   8018cb <dev_lookup>
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 22                	js     801c0c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bf1:	74 1e                	je     801c11 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf6:	8b 52 0c             	mov    0xc(%edx),%edx
  801bf9:	85 d2                	test   %edx,%edx
  801bfb:	74 35                	je     801c32 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bfd:	83 ec 04             	sub    $0x4,%esp
  801c00:	ff 75 10             	pushl  0x10(%ebp)
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	50                   	push   %eax
  801c07:	ff d2                	call   *%edx
  801c09:	83 c4 10             	add    $0x10,%esp
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c11:	a1 08 50 80 00       	mov    0x805008,%eax
  801c16:	8b 40 48             	mov    0x48(%eax),%eax
  801c19:	83 ec 04             	sub    $0x4,%esp
  801c1c:	53                   	push   %ebx
  801c1d:	50                   	push   %eax
  801c1e:	68 c1 34 80 00       	push   $0x8034c1
  801c23:	e8 ad e8 ff ff       	call   8004d5 <cprintf>
		return -E_INVAL;
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c30:	eb da                	jmp    801c0c <write+0x55>
		return -E_NOT_SUPP;
  801c32:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c37:	eb d3                	jmp    801c0c <write+0x55>

00801c39 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c42:	50                   	push   %eax
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	e8 30 fc ff ff       	call   80187b <fd_lookup>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 0e                	js     801c60 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c58:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	53                   	push   %ebx
  801c66:	83 ec 1c             	sub    $0x1c,%esp
  801c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c6f:	50                   	push   %eax
  801c70:	53                   	push   %ebx
  801c71:	e8 05 fc ff ff       	call   80187b <fd_lookup>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	78 37                	js     801cb4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c83:	50                   	push   %eax
  801c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c87:	ff 30                	pushl  (%eax)
  801c89:	e8 3d fc ff ff       	call   8018cb <dev_lookup>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	85 c0                	test   %eax,%eax
  801c93:	78 1f                	js     801cb4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c98:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c9c:	74 1b                	je     801cb9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca1:	8b 52 18             	mov    0x18(%edx),%edx
  801ca4:	85 d2                	test   %edx,%edx
  801ca6:	74 32                	je     801cda <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ca8:	83 ec 08             	sub    $0x8,%esp
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	50                   	push   %eax
  801caf:	ff d2                	call   *%edx
  801cb1:	83 c4 10             	add    $0x10,%esp
}
  801cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    
			thisenv->env_id, fdnum);
  801cb9:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cbe:	8b 40 48             	mov    0x48(%eax),%eax
  801cc1:	83 ec 04             	sub    $0x4,%esp
  801cc4:	53                   	push   %ebx
  801cc5:	50                   	push   %eax
  801cc6:	68 84 34 80 00       	push   $0x803484
  801ccb:	e8 05 e8 ff ff       	call   8004d5 <cprintf>
		return -E_INVAL;
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd8:	eb da                	jmp    801cb4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801cda:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cdf:	eb d3                	jmp    801cb4 <ftruncate+0x52>

00801ce1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 1c             	sub    $0x1c,%esp
  801ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ceb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cee:	50                   	push   %eax
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	e8 84 fb ff ff       	call   80187b <fd_lookup>
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	78 4b                	js     801d49 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cfe:	83 ec 08             	sub    $0x8,%esp
  801d01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d04:	50                   	push   %eax
  801d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d08:	ff 30                	pushl  (%eax)
  801d0a:	e8 bc fb ff ff       	call   8018cb <dev_lookup>
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 33                	js     801d49 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d1d:	74 2f                	je     801d4e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d1f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d22:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d29:	00 00 00 
	stat->st_isdir = 0;
  801d2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d33:	00 00 00 
	stat->st_dev = dev;
  801d36:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d3c:	83 ec 08             	sub    $0x8,%esp
  801d3f:	53                   	push   %ebx
  801d40:	ff 75 f0             	pushl  -0x10(%ebp)
  801d43:	ff 50 14             	call   *0x14(%eax)
  801d46:	83 c4 10             	add    $0x10,%esp
}
  801d49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    
		return -E_NOT_SUPP;
  801d4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d53:	eb f4                	jmp    801d49 <fstat+0x68>

00801d55 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	56                   	push   %esi
  801d59:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d5a:	83 ec 08             	sub    $0x8,%esp
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	e8 22 02 00 00       	call   801f89 <open>
  801d67:	89 c3                	mov    %eax,%ebx
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 1b                	js     801d8b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	50                   	push   %eax
  801d77:	e8 65 ff ff ff       	call   801ce1 <fstat>
  801d7c:	89 c6                	mov    %eax,%esi
	close(fd);
  801d7e:	89 1c 24             	mov    %ebx,(%esp)
  801d81:	e8 27 fc ff ff       	call   8019ad <close>
	return r;
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	89 f3                	mov    %esi,%ebx
}
  801d8b:	89 d8                	mov    %ebx,%eax
  801d8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    

00801d94 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	56                   	push   %esi
  801d98:	53                   	push   %ebx
  801d99:	89 c6                	mov    %eax,%esi
  801d9b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d9d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801da4:	74 27                	je     801dcd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801da6:	6a 07                	push   $0x7
  801da8:	68 00 60 80 00       	push   $0x806000
  801dad:	56                   	push   %esi
  801dae:	ff 35 00 50 80 00    	pushl  0x805000
  801db4:	e8 ec 0c 00 00       	call   802aa5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801db9:	83 c4 0c             	add    $0xc,%esp
  801dbc:	6a 00                	push   $0x0
  801dbe:	53                   	push   %ebx
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 76 0c 00 00       	call   802a3c <ipc_recv>
}
  801dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	6a 01                	push   $0x1
  801dd2:	e8 26 0d 00 00       	call   802afd <ipc_find_env>
  801dd7:	a3 00 50 80 00       	mov    %eax,0x805000
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	eb c5                	jmp    801da6 <fsipc+0x12>

00801de1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801dff:	b8 02 00 00 00       	mov    $0x2,%eax
  801e04:	e8 8b ff ff ff       	call   801d94 <fsipc>
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <devfile_flush>:
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	8b 40 0c             	mov    0xc(%eax),%eax
  801e17:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	b8 06 00 00 00       	mov    $0x6,%eax
  801e26:	e8 69 ff ff ff       	call   801d94 <fsipc>
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <devfile_stat>:
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	53                   	push   %ebx
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
  801e47:	b8 05 00 00 00       	mov    $0x5,%eax
  801e4c:	e8 43 ff ff ff       	call   801d94 <fsipc>
  801e51:	85 c0                	test   %eax,%eax
  801e53:	78 2c                	js     801e81 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	68 00 60 80 00       	push   $0x806000
  801e5d:	53                   	push   %ebx
  801e5e:	e8 d1 ed ff ff       	call   800c34 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e63:	a1 80 60 80 00       	mov    0x806080,%eax
  801e68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e6e:	a1 84 60 80 00       	mov    0x806084,%eax
  801e73:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <devfile_write>:
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	8b 40 0c             	mov    0xc(%eax),%eax
  801e96:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e9b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ea1:	53                   	push   %ebx
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	68 08 60 80 00       	push   $0x806008
  801eaa:	e8 75 ef ff ff       	call   800e24 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801eaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb4:	b8 04 00 00 00       	mov    $0x4,%eax
  801eb9:	e8 d6 fe ff ff       	call   801d94 <fsipc>
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	78 0b                	js     801ed0 <devfile_write+0x4a>
	assert(r <= n);
  801ec5:	39 d8                	cmp    %ebx,%eax
  801ec7:	77 0c                	ja     801ed5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ec9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ece:	7f 1e                	jg     801eee <devfile_write+0x68>
}
  801ed0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    
	assert(r <= n);
  801ed5:	68 f4 34 80 00       	push   $0x8034f4
  801eda:	68 fb 34 80 00       	push   $0x8034fb
  801edf:	68 98 00 00 00       	push   $0x98
  801ee4:	68 10 35 80 00       	push   $0x803510
  801ee9:	e8 f1 e4 ff ff       	call   8003df <_panic>
	assert(r <= PGSIZE);
  801eee:	68 1b 35 80 00       	push   $0x80351b
  801ef3:	68 fb 34 80 00       	push   $0x8034fb
  801ef8:	68 99 00 00 00       	push   $0x99
  801efd:	68 10 35 80 00       	push   $0x803510
  801f02:	e8 d8 e4 ff ff       	call   8003df <_panic>

00801f07 <devfile_read>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	8b 40 0c             	mov    0xc(%eax),%eax
  801f15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f1a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f20:	ba 00 00 00 00       	mov    $0x0,%edx
  801f25:	b8 03 00 00 00       	mov    $0x3,%eax
  801f2a:	e8 65 fe ff ff       	call   801d94 <fsipc>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 1f                	js     801f54 <devfile_read+0x4d>
	assert(r <= n);
  801f35:	39 f0                	cmp    %esi,%eax
  801f37:	77 24                	ja     801f5d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f3e:	7f 33                	jg     801f73 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	50                   	push   %eax
  801f44:	68 00 60 80 00       	push   $0x806000
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	e8 71 ee ff ff       	call   800dc2 <memmove>
	return r;
  801f51:	83 c4 10             	add    $0x10,%esp
}
  801f54:	89 d8                	mov    %ebx,%eax
  801f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f59:	5b                   	pop    %ebx
  801f5a:	5e                   	pop    %esi
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    
	assert(r <= n);
  801f5d:	68 f4 34 80 00       	push   $0x8034f4
  801f62:	68 fb 34 80 00       	push   $0x8034fb
  801f67:	6a 7c                	push   $0x7c
  801f69:	68 10 35 80 00       	push   $0x803510
  801f6e:	e8 6c e4 ff ff       	call   8003df <_panic>
	assert(r <= PGSIZE);
  801f73:	68 1b 35 80 00       	push   $0x80351b
  801f78:	68 fb 34 80 00       	push   $0x8034fb
  801f7d:	6a 7d                	push   $0x7d
  801f7f:	68 10 35 80 00       	push   $0x803510
  801f84:	e8 56 e4 ff ff       	call   8003df <_panic>

00801f89 <open>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	56                   	push   %esi
  801f8d:	53                   	push   %ebx
  801f8e:	83 ec 1c             	sub    $0x1c,%esp
  801f91:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f94:	56                   	push   %esi
  801f95:	e8 61 ec ff ff       	call   800bfb <strlen>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fa2:	7f 6c                	jg     802010 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801fa4:	83 ec 0c             	sub    $0xc,%esp
  801fa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801faa:	50                   	push   %eax
  801fab:	e8 79 f8 ff ff       	call   801829 <fd_alloc>
  801fb0:	89 c3                	mov    %eax,%ebx
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 3c                	js     801ff5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	56                   	push   %esi
  801fbd:	68 00 60 80 00       	push   $0x806000
  801fc2:	e8 6d ec ff ff       	call   800c34 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fca:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd7:	e8 b8 fd ff ff       	call   801d94 <fsipc>
  801fdc:	89 c3                	mov    %eax,%ebx
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 19                	js     801ffe <open+0x75>
	return fd2num(fd);
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	e8 12 f8 ff ff       	call   801802 <fd2num>
  801ff0:	89 c3                	mov    %eax,%ebx
  801ff2:	83 c4 10             	add    $0x10,%esp
}
  801ff5:	89 d8                	mov    %ebx,%eax
  801ff7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffa:	5b                   	pop    %ebx
  801ffb:	5e                   	pop    %esi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    
		fd_close(fd, 0);
  801ffe:	83 ec 08             	sub    $0x8,%esp
  802001:	6a 00                	push   $0x0
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 1b f9 ff ff       	call   801926 <fd_close>
		return r;
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	eb e5                	jmp    801ff5 <open+0x6c>
		return -E_BAD_PATH;
  802010:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802015:	eb de                	jmp    801ff5 <open+0x6c>

00802017 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80201d:	ba 00 00 00 00       	mov    $0x0,%edx
  802022:	b8 08 00 00 00       	mov    $0x8,%eax
  802027:	e8 68 fd ff ff       	call   801d94 <fsipc>
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802034:	68 27 35 80 00       	push   $0x803527
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	e8 f3 eb ff ff       	call   800c34 <strcpy>
	return 0;
}
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <devsock_close>:
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	53                   	push   %ebx
  80204c:	83 ec 10             	sub    $0x10,%esp
  80204f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802052:	53                   	push   %ebx
  802053:	e8 e0 0a 00 00       	call   802b38 <pageref>
  802058:	83 c4 10             	add    $0x10,%esp
		return 0;
  80205b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802060:	83 f8 01             	cmp    $0x1,%eax
  802063:	74 07                	je     80206c <devsock_close+0x24>
}
  802065:	89 d0                	mov    %edx,%eax
  802067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80206c:	83 ec 0c             	sub    $0xc,%esp
  80206f:	ff 73 0c             	pushl  0xc(%ebx)
  802072:	e8 b9 02 00 00       	call   802330 <nsipc_close>
  802077:	89 c2                	mov    %eax,%edx
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	eb e7                	jmp    802065 <devsock_close+0x1d>

0080207e <devsock_write>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802084:	6a 00                	push   $0x0
  802086:	ff 75 10             	pushl  0x10(%ebp)
  802089:	ff 75 0c             	pushl  0xc(%ebp)
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	ff 70 0c             	pushl  0xc(%eax)
  802092:	e8 76 03 00 00       	call   80240d <nsipc_send>
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <devsock_read>:
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	ff 75 10             	pushl  0x10(%ebp)
  8020a4:	ff 75 0c             	pushl  0xc(%ebp)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	ff 70 0c             	pushl  0xc(%eax)
  8020ad:	e8 ef 02 00 00       	call   8023a1 <nsipc_recv>
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <fd2sockid>:
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020ba:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	e8 b7 f7 ff ff       	call   80187b <fd_lookup>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 10                	js     8020db <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8020d4:	39 08                	cmp    %ecx,(%eax)
  8020d6:	75 05                	jne    8020dd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020d8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    
		return -E_NOT_SUPP;
  8020dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020e2:	eb f7                	jmp    8020db <fd2sockid+0x27>

008020e4 <alloc_sockfd>:
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	56                   	push   %esi
  8020e8:	53                   	push   %ebx
  8020e9:	83 ec 1c             	sub    $0x1c,%esp
  8020ec:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f1:	50                   	push   %eax
  8020f2:	e8 32 f7 ff ff       	call   801829 <fd_alloc>
  8020f7:	89 c3                	mov    %eax,%ebx
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 43                	js     802143 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	68 07 04 00 00       	push   $0x407
  802108:	ff 75 f4             	pushl  -0xc(%ebp)
  80210b:	6a 00                	push   $0x0
  80210d:	e8 14 ef ff ff       	call   801026 <sys_page_alloc>
  802112:	89 c3                	mov    %eax,%ebx
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	85 c0                	test   %eax,%eax
  802119:	78 28                	js     802143 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802124:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802130:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	50                   	push   %eax
  802137:	e8 c6 f6 ff ff       	call   801802 <fd2num>
  80213c:	89 c3                	mov    %eax,%ebx
  80213e:	83 c4 10             	add    $0x10,%esp
  802141:	eb 0c                	jmp    80214f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	56                   	push   %esi
  802147:	e8 e4 01 00 00       	call   802330 <nsipc_close>
		return r;
  80214c:	83 c4 10             	add    $0x10,%esp
}
  80214f:	89 d8                	mov    %ebx,%eax
  802151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    

00802158 <accept>:
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	e8 4e ff ff ff       	call   8020b4 <fd2sockid>
  802166:	85 c0                	test   %eax,%eax
  802168:	78 1b                	js     802185 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80216a:	83 ec 04             	sub    $0x4,%esp
  80216d:	ff 75 10             	pushl  0x10(%ebp)
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	50                   	push   %eax
  802174:	e8 0e 01 00 00       	call   802287 <nsipc_accept>
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	78 05                	js     802185 <accept+0x2d>
	return alloc_sockfd(r);
  802180:	e8 5f ff ff ff       	call   8020e4 <alloc_sockfd>
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <bind>:
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	e8 1f ff ff ff       	call   8020b4 <fd2sockid>
  802195:	85 c0                	test   %eax,%eax
  802197:	78 12                	js     8021ab <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	ff 75 10             	pushl  0x10(%ebp)
  80219f:	ff 75 0c             	pushl  0xc(%ebp)
  8021a2:	50                   	push   %eax
  8021a3:	e8 31 01 00 00       	call   8022d9 <nsipc_bind>
  8021a8:	83 c4 10             	add    $0x10,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <shutdown>:
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	e8 f9 fe ff ff       	call   8020b4 <fd2sockid>
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 0f                	js     8021ce <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021bf:	83 ec 08             	sub    $0x8,%esp
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	50                   	push   %eax
  8021c6:	e8 43 01 00 00       	call   80230e <nsipc_shutdown>
  8021cb:	83 c4 10             	add    $0x10,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <connect>:
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	e8 d6 fe ff ff       	call   8020b4 <fd2sockid>
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 12                	js     8021f4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	ff 75 10             	pushl  0x10(%ebp)
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	50                   	push   %eax
  8021ec:	e8 59 01 00 00       	call   80234a <nsipc_connect>
  8021f1:	83 c4 10             	add    $0x10,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <listen>:
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	e8 b0 fe ff ff       	call   8020b4 <fd2sockid>
  802204:	85 c0                	test   %eax,%eax
  802206:	78 0f                	js     802217 <listen+0x21>
	return nsipc_listen(r, backlog);
  802208:	83 ec 08             	sub    $0x8,%esp
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	50                   	push   %eax
  80220f:	e8 6b 01 00 00       	call   80237f <nsipc_listen>
  802214:	83 c4 10             	add    $0x10,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <socket>:

int
socket(int domain, int type, int protocol)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80221f:	ff 75 10             	pushl  0x10(%ebp)
  802222:	ff 75 0c             	pushl  0xc(%ebp)
  802225:	ff 75 08             	pushl  0x8(%ebp)
  802228:	e8 3e 02 00 00       	call   80246b <nsipc_socket>
  80222d:	83 c4 10             	add    $0x10,%esp
  802230:	85 c0                	test   %eax,%eax
  802232:	78 05                	js     802239 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802234:	e8 ab fe ff ff       	call   8020e4 <alloc_sockfd>
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	53                   	push   %ebx
  80223f:	83 ec 04             	sub    $0x4,%esp
  802242:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802244:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80224b:	74 26                	je     802273 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80224d:	6a 07                	push   $0x7
  80224f:	68 00 70 80 00       	push   $0x807000
  802254:	53                   	push   %ebx
  802255:	ff 35 04 50 80 00    	pushl  0x805004
  80225b:	e8 45 08 00 00       	call   802aa5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802260:	83 c4 0c             	add    $0xc,%esp
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	e8 ce 07 00 00       	call   802a3c <ipc_recv>
}
  80226e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802271:	c9                   	leave  
  802272:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	6a 02                	push   $0x2
  802278:	e8 80 08 00 00       	call   802afd <ipc_find_env>
  80227d:	a3 04 50 80 00       	mov    %eax,0x805004
  802282:	83 c4 10             	add    $0x10,%esp
  802285:	eb c6                	jmp    80224d <nsipc+0x12>

00802287 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	56                   	push   %esi
  80228b:	53                   	push   %ebx
  80228c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802297:	8b 06                	mov    (%esi),%eax
  802299:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	e8 93 ff ff ff       	call   80223b <nsipc>
  8022a8:	89 c3                	mov    %eax,%ebx
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	79 09                	jns    8022b7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022ae:	89 d8                	mov    %ebx,%eax
  8022b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b3:	5b                   	pop    %ebx
  8022b4:	5e                   	pop    %esi
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	ff 35 10 70 80 00    	pushl  0x807010
  8022c0:	68 00 70 80 00       	push   $0x807000
  8022c5:	ff 75 0c             	pushl  0xc(%ebp)
  8022c8:	e8 f5 ea ff ff       	call   800dc2 <memmove>
		*addrlen = ret->ret_addrlen;
  8022cd:	a1 10 70 80 00       	mov    0x807010,%eax
  8022d2:	89 06                	mov    %eax,(%esi)
  8022d4:	83 c4 10             	add    $0x10,%esp
	return r;
  8022d7:	eb d5                	jmp    8022ae <nsipc_accept+0x27>

008022d9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	53                   	push   %ebx
  8022dd:	83 ec 08             	sub    $0x8,%esp
  8022e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022eb:	53                   	push   %ebx
  8022ec:	ff 75 0c             	pushl  0xc(%ebp)
  8022ef:	68 04 70 80 00       	push   $0x807004
  8022f4:	e8 c9 ea ff ff       	call   800dc2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022f9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802304:	e8 32 ff ff ff       	call   80223b <nsipc>
}
  802309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80231c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802324:	b8 03 00 00 00       	mov    $0x3,%eax
  802329:	e8 0d ff ff ff       	call   80223b <nsipc>
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <nsipc_close>:

int
nsipc_close(int s)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80233e:	b8 04 00 00 00       	mov    $0x4,%eax
  802343:	e8 f3 fe ff ff       	call   80223b <nsipc>
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	53                   	push   %ebx
  80234e:	83 ec 08             	sub    $0x8,%esp
  802351:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80235c:	53                   	push   %ebx
  80235d:	ff 75 0c             	pushl  0xc(%ebp)
  802360:	68 04 70 80 00       	push   $0x807004
  802365:	e8 58 ea ff ff       	call   800dc2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80236a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802370:	b8 05 00 00 00       	mov    $0x5,%eax
  802375:	e8 c1 fe ff ff       	call   80223b <nsipc>
}
  80237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802395:	b8 06 00 00 00       	mov    $0x6,%eax
  80239a:	e8 9c fe ff ff       	call   80223b <nsipc>
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	56                   	push   %esi
  8023a5:	53                   	push   %ebx
  8023a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023b1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ba:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023bf:	b8 07 00 00 00       	mov    $0x7,%eax
  8023c4:	e8 72 fe ff ff       	call   80223b <nsipc>
  8023c9:	89 c3                	mov    %eax,%ebx
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	78 1f                	js     8023ee <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023cf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023d4:	7f 21                	jg     8023f7 <nsipc_recv+0x56>
  8023d6:	39 c6                	cmp    %eax,%esi
  8023d8:	7c 1d                	jl     8023f7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	50                   	push   %eax
  8023de:	68 00 70 80 00       	push   $0x807000
  8023e3:	ff 75 0c             	pushl  0xc(%ebp)
  8023e6:	e8 d7 e9 ff ff       	call   800dc2 <memmove>
  8023eb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023ee:	89 d8                	mov    %ebx,%eax
  8023f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023f7:	68 33 35 80 00       	push   $0x803533
  8023fc:	68 fb 34 80 00       	push   $0x8034fb
  802401:	6a 62                	push   $0x62
  802403:	68 48 35 80 00       	push   $0x803548
  802408:	e8 d2 df ff ff       	call   8003df <_panic>

0080240d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	53                   	push   %ebx
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80241f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802425:	7f 2e                	jg     802455 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	53                   	push   %ebx
  80242b:	ff 75 0c             	pushl  0xc(%ebp)
  80242e:	68 0c 70 80 00       	push   $0x80700c
  802433:	e8 8a e9 ff ff       	call   800dc2 <memmove>
	nsipcbuf.send.req_size = size;
  802438:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80243e:	8b 45 14             	mov    0x14(%ebp),%eax
  802441:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802446:	b8 08 00 00 00       	mov    $0x8,%eax
  80244b:	e8 eb fd ff ff       	call   80223b <nsipc>
}
  802450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802453:	c9                   	leave  
  802454:	c3                   	ret    
	assert(size < 1600);
  802455:	68 54 35 80 00       	push   $0x803554
  80245a:	68 fb 34 80 00       	push   $0x8034fb
  80245f:	6a 6d                	push   $0x6d
  802461:	68 48 35 80 00       	push   $0x803548
  802466:	e8 74 df ff ff       	call   8003df <_panic>

0080246b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802481:	8b 45 10             	mov    0x10(%ebp),%eax
  802484:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802489:	b8 09 00 00 00       	mov    $0x9,%eax
  80248e:	e8 a8 fd ff ff       	call   80223b <nsipc>
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	56                   	push   %esi
  802499:	53                   	push   %ebx
  80249a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80249d:	83 ec 0c             	sub    $0xc,%esp
  8024a0:	ff 75 08             	pushl  0x8(%ebp)
  8024a3:	e8 6a f3 ff ff       	call   801812 <fd2data>
  8024a8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024aa:	83 c4 08             	add    $0x8,%esp
  8024ad:	68 60 35 80 00       	push   $0x803560
  8024b2:	53                   	push   %ebx
  8024b3:	e8 7c e7 ff ff       	call   800c34 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024b8:	8b 46 04             	mov    0x4(%esi),%eax
  8024bb:	2b 06                	sub    (%esi),%eax
  8024bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024c3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024ca:	00 00 00 
	stat->st_dev = &devpipe;
  8024cd:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8024d4:	40 80 00 
	return 0;
}
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    

008024e3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	53                   	push   %ebx
  8024e7:	83 ec 0c             	sub    $0xc,%esp
  8024ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024ed:	53                   	push   %ebx
  8024ee:	6a 00                	push   $0x0
  8024f0:	e8 b6 eb ff ff       	call   8010ab <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024f5:	89 1c 24             	mov    %ebx,(%esp)
  8024f8:	e8 15 f3 ff ff       	call   801812 <fd2data>
  8024fd:	83 c4 08             	add    $0x8,%esp
  802500:	50                   	push   %eax
  802501:	6a 00                	push   $0x0
  802503:	e8 a3 eb ff ff       	call   8010ab <sys_page_unmap>
}
  802508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <_pipeisclosed>:
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	57                   	push   %edi
  802511:	56                   	push   %esi
  802512:	53                   	push   %ebx
  802513:	83 ec 1c             	sub    $0x1c,%esp
  802516:	89 c7                	mov    %eax,%edi
  802518:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80251a:	a1 08 50 80 00       	mov    0x805008,%eax
  80251f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	57                   	push   %edi
  802526:	e8 0d 06 00 00       	call   802b38 <pageref>
  80252b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80252e:	89 34 24             	mov    %esi,(%esp)
  802531:	e8 02 06 00 00       	call   802b38 <pageref>
		nn = thisenv->env_runs;
  802536:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80253c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80253f:	83 c4 10             	add    $0x10,%esp
  802542:	39 cb                	cmp    %ecx,%ebx
  802544:	74 1b                	je     802561 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802546:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802549:	75 cf                	jne    80251a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80254b:	8b 42 58             	mov    0x58(%edx),%eax
  80254e:	6a 01                	push   $0x1
  802550:	50                   	push   %eax
  802551:	53                   	push   %ebx
  802552:	68 67 35 80 00       	push   $0x803567
  802557:	e8 79 df ff ff       	call   8004d5 <cprintf>
  80255c:	83 c4 10             	add    $0x10,%esp
  80255f:	eb b9                	jmp    80251a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802561:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802564:	0f 94 c0             	sete   %al
  802567:	0f b6 c0             	movzbl %al,%eax
}
  80256a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	5f                   	pop    %edi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    

00802572 <devpipe_write>:
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	57                   	push   %edi
  802576:	56                   	push   %esi
  802577:	53                   	push   %ebx
  802578:	83 ec 28             	sub    $0x28,%esp
  80257b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80257e:	56                   	push   %esi
  80257f:	e8 8e f2 ff ff       	call   801812 <fd2data>
  802584:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	bf 00 00 00 00       	mov    $0x0,%edi
  80258e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802591:	74 4f                	je     8025e2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802593:	8b 43 04             	mov    0x4(%ebx),%eax
  802596:	8b 0b                	mov    (%ebx),%ecx
  802598:	8d 51 20             	lea    0x20(%ecx),%edx
  80259b:	39 d0                	cmp    %edx,%eax
  80259d:	72 14                	jb     8025b3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80259f:	89 da                	mov    %ebx,%edx
  8025a1:	89 f0                	mov    %esi,%eax
  8025a3:	e8 65 ff ff ff       	call   80250d <_pipeisclosed>
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	75 3b                	jne    8025e7 <devpipe_write+0x75>
			sys_yield();
  8025ac:	e8 56 ea ff ff       	call   801007 <sys_yield>
  8025b1:	eb e0                	jmp    802593 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025b6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025ba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	c1 fa 1f             	sar    $0x1f,%edx
  8025c2:	89 d1                	mov    %edx,%ecx
  8025c4:	c1 e9 1b             	shr    $0x1b,%ecx
  8025c7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025ca:	83 e2 1f             	and    $0x1f,%edx
  8025cd:	29 ca                	sub    %ecx,%edx
  8025cf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025d3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025d7:	83 c0 01             	add    $0x1,%eax
  8025da:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025dd:	83 c7 01             	add    $0x1,%edi
  8025e0:	eb ac                	jmp    80258e <devpipe_write+0x1c>
	return i;
  8025e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e5:	eb 05                	jmp    8025ec <devpipe_write+0x7a>
				return 0;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    

008025f4 <devpipe_read>:
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	57                   	push   %edi
  8025f8:	56                   	push   %esi
  8025f9:	53                   	push   %ebx
  8025fa:	83 ec 18             	sub    $0x18,%esp
  8025fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802600:	57                   	push   %edi
  802601:	e8 0c f2 ff ff       	call   801812 <fd2data>
  802606:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	be 00 00 00 00       	mov    $0x0,%esi
  802610:	3b 75 10             	cmp    0x10(%ebp),%esi
  802613:	75 14                	jne    802629 <devpipe_read+0x35>
	return i;
  802615:	8b 45 10             	mov    0x10(%ebp),%eax
  802618:	eb 02                	jmp    80261c <devpipe_read+0x28>
				return i;
  80261a:	89 f0                	mov    %esi,%eax
}
  80261c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80261f:	5b                   	pop    %ebx
  802620:	5e                   	pop    %esi
  802621:	5f                   	pop    %edi
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
			sys_yield();
  802624:	e8 de e9 ff ff       	call   801007 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802629:	8b 03                	mov    (%ebx),%eax
  80262b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80262e:	75 18                	jne    802648 <devpipe_read+0x54>
			if (i > 0)
  802630:	85 f6                	test   %esi,%esi
  802632:	75 e6                	jne    80261a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802634:	89 da                	mov    %ebx,%edx
  802636:	89 f8                	mov    %edi,%eax
  802638:	e8 d0 fe ff ff       	call   80250d <_pipeisclosed>
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 e3                	je     802624 <devpipe_read+0x30>
				return 0;
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	eb d4                	jmp    80261c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802648:	99                   	cltd   
  802649:	c1 ea 1b             	shr    $0x1b,%edx
  80264c:	01 d0                	add    %edx,%eax
  80264e:	83 e0 1f             	and    $0x1f,%eax
  802651:	29 d0                	sub    %edx,%eax
  802653:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802658:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80265e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802661:	83 c6 01             	add    $0x1,%esi
  802664:	eb aa                	jmp    802610 <devpipe_read+0x1c>

00802666 <pipe>:
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	56                   	push   %esi
  80266a:	53                   	push   %ebx
  80266b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80266e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802671:	50                   	push   %eax
  802672:	e8 b2 f1 ff ff       	call   801829 <fd_alloc>
  802677:	89 c3                	mov    %eax,%ebx
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	85 c0                	test   %eax,%eax
  80267e:	0f 88 23 01 00 00    	js     8027a7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 07 04 00 00       	push   $0x407
  80268c:	ff 75 f4             	pushl  -0xc(%ebp)
  80268f:	6a 00                	push   $0x0
  802691:	e8 90 e9 ff ff       	call   801026 <sys_page_alloc>
  802696:	89 c3                	mov    %eax,%ebx
  802698:	83 c4 10             	add    $0x10,%esp
  80269b:	85 c0                	test   %eax,%eax
  80269d:	0f 88 04 01 00 00    	js     8027a7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026a9:	50                   	push   %eax
  8026aa:	e8 7a f1 ff ff       	call   801829 <fd_alloc>
  8026af:	89 c3                	mov    %eax,%ebx
  8026b1:	83 c4 10             	add    $0x10,%esp
  8026b4:	85 c0                	test   %eax,%eax
  8026b6:	0f 88 db 00 00 00    	js     802797 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	68 07 04 00 00       	push   $0x407
  8026c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8026c7:	6a 00                	push   $0x0
  8026c9:	e8 58 e9 ff ff       	call   801026 <sys_page_alloc>
  8026ce:	89 c3                	mov    %eax,%ebx
  8026d0:	83 c4 10             	add    $0x10,%esp
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	0f 88 bc 00 00 00    	js     802797 <pipe+0x131>
	va = fd2data(fd0);
  8026db:	83 ec 0c             	sub    $0xc,%esp
  8026de:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e1:	e8 2c f1 ff ff       	call   801812 <fd2data>
  8026e6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e8:	83 c4 0c             	add    $0xc,%esp
  8026eb:	68 07 04 00 00       	push   $0x407
  8026f0:	50                   	push   %eax
  8026f1:	6a 00                	push   $0x0
  8026f3:	e8 2e e9 ff ff       	call   801026 <sys_page_alloc>
  8026f8:	89 c3                	mov    %eax,%ebx
  8026fa:	83 c4 10             	add    $0x10,%esp
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	0f 88 82 00 00 00    	js     802787 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802705:	83 ec 0c             	sub    $0xc,%esp
  802708:	ff 75 f0             	pushl  -0x10(%ebp)
  80270b:	e8 02 f1 ff ff       	call   801812 <fd2data>
  802710:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802717:	50                   	push   %eax
  802718:	6a 00                	push   $0x0
  80271a:	56                   	push   %esi
  80271b:	6a 00                	push   $0x0
  80271d:	e8 47 e9 ff ff       	call   801069 <sys_page_map>
  802722:	89 c3                	mov    %eax,%ebx
  802724:	83 c4 20             	add    $0x20,%esp
  802727:	85 c0                	test   %eax,%eax
  802729:	78 4e                	js     802779 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80272b:	a1 40 40 80 00       	mov    0x804040,%eax
  802730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802733:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802738:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80273f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802742:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	ff 75 f4             	pushl  -0xc(%ebp)
  802754:	e8 a9 f0 ff ff       	call   801802 <fd2num>
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80275e:	83 c4 04             	add    $0x4,%esp
  802761:	ff 75 f0             	pushl  -0x10(%ebp)
  802764:	e8 99 f0 ff ff       	call   801802 <fd2num>
  802769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80276c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	bb 00 00 00 00       	mov    $0x0,%ebx
  802777:	eb 2e                	jmp    8027a7 <pipe+0x141>
	sys_page_unmap(0, va);
  802779:	83 ec 08             	sub    $0x8,%esp
  80277c:	56                   	push   %esi
  80277d:	6a 00                	push   $0x0
  80277f:	e8 27 e9 ff ff       	call   8010ab <sys_page_unmap>
  802784:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802787:	83 ec 08             	sub    $0x8,%esp
  80278a:	ff 75 f0             	pushl  -0x10(%ebp)
  80278d:	6a 00                	push   $0x0
  80278f:	e8 17 e9 ff ff       	call   8010ab <sys_page_unmap>
  802794:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802797:	83 ec 08             	sub    $0x8,%esp
  80279a:	ff 75 f4             	pushl  -0xc(%ebp)
  80279d:	6a 00                	push   $0x0
  80279f:	e8 07 e9 ff ff       	call   8010ab <sys_page_unmap>
  8027a4:	83 c4 10             	add    $0x10,%esp
}
  8027a7:	89 d8                	mov    %ebx,%eax
  8027a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ac:	5b                   	pop    %ebx
  8027ad:	5e                   	pop    %esi
  8027ae:	5d                   	pop    %ebp
  8027af:	c3                   	ret    

008027b0 <pipeisclosed>:
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b9:	50                   	push   %eax
  8027ba:	ff 75 08             	pushl  0x8(%ebp)
  8027bd:	e8 b9 f0 ff ff       	call   80187b <fd_lookup>
  8027c2:	83 c4 10             	add    $0x10,%esp
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	78 18                	js     8027e1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027c9:	83 ec 0c             	sub    $0xc,%esp
  8027cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cf:	e8 3e f0 ff ff       	call   801812 <fd2data>
	return _pipeisclosed(fd, p);
  8027d4:	89 c2                	mov    %eax,%edx
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	e8 2f fd ff ff       	call   80250d <_pipeisclosed>
  8027de:	83 c4 10             	add    $0x10,%esp
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	56                   	push   %esi
  8027e7:	53                   	push   %ebx
  8027e8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8027eb:	85 f6                	test   %esi,%esi
  8027ed:	74 13                	je     802802 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8027ef:	89 f3                	mov    %esi,%ebx
  8027f1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027f7:	c1 e3 07             	shl    $0x7,%ebx
  8027fa:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802800:	eb 1b                	jmp    80281d <wait+0x3a>
	assert(envid != 0);
  802802:	68 7f 35 80 00       	push   $0x80357f
  802807:	68 fb 34 80 00       	push   $0x8034fb
  80280c:	6a 09                	push   $0x9
  80280e:	68 8a 35 80 00       	push   $0x80358a
  802813:	e8 c7 db ff ff       	call   8003df <_panic>
		sys_yield();
  802818:	e8 ea e7 ff ff       	call   801007 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80281d:	8b 43 48             	mov    0x48(%ebx),%eax
  802820:	39 f0                	cmp    %esi,%eax
  802822:	75 07                	jne    80282b <wait+0x48>
  802824:	8b 43 54             	mov    0x54(%ebx),%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	75 ed                	jne    802818 <wait+0x35>
}
  80282b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80282e:	5b                   	pop    %ebx
  80282f:	5e                   	pop    %esi
  802830:	5d                   	pop    %ebp
  802831:	c3                   	ret    

00802832 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802832:	b8 00 00 00 00       	mov    $0x0,%eax
  802837:	c3                   	ret    

00802838 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80283e:	68 95 35 80 00       	push   $0x803595
  802843:	ff 75 0c             	pushl  0xc(%ebp)
  802846:	e8 e9 e3 ff ff       	call   800c34 <strcpy>
	return 0;
}
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <devcons_write>:
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80285e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802863:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802869:	3b 75 10             	cmp    0x10(%ebp),%esi
  80286c:	73 31                	jae    80289f <devcons_write+0x4d>
		m = n - tot;
  80286e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802871:	29 f3                	sub    %esi,%ebx
  802873:	83 fb 7f             	cmp    $0x7f,%ebx
  802876:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80287b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	53                   	push   %ebx
  802882:	89 f0                	mov    %esi,%eax
  802884:	03 45 0c             	add    0xc(%ebp),%eax
  802887:	50                   	push   %eax
  802888:	57                   	push   %edi
  802889:	e8 34 e5 ff ff       	call   800dc2 <memmove>
		sys_cputs(buf, m);
  80288e:	83 c4 08             	add    $0x8,%esp
  802891:	53                   	push   %ebx
  802892:	57                   	push   %edi
  802893:	e8 d2 e6 ff ff       	call   800f6a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802898:	01 de                	add    %ebx,%esi
  80289a:	83 c4 10             	add    $0x10,%esp
  80289d:	eb ca                	jmp    802869 <devcons_write+0x17>
}
  80289f:	89 f0                	mov    %esi,%eax
  8028a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028a4:	5b                   	pop    %ebx
  8028a5:	5e                   	pop    %esi
  8028a6:	5f                   	pop    %edi
  8028a7:	5d                   	pop    %ebp
  8028a8:	c3                   	ret    

008028a9 <devcons_read>:
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
  8028ac:	83 ec 08             	sub    $0x8,%esp
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028b8:	74 21                	je     8028db <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028ba:	e8 c9 e6 ff ff       	call   800f88 <sys_cgetc>
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	75 07                	jne    8028ca <devcons_read+0x21>
		sys_yield();
  8028c3:	e8 3f e7 ff ff       	call   801007 <sys_yield>
  8028c8:	eb f0                	jmp    8028ba <devcons_read+0x11>
	if (c < 0)
  8028ca:	78 0f                	js     8028db <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028cc:	83 f8 04             	cmp    $0x4,%eax
  8028cf:	74 0c                	je     8028dd <devcons_read+0x34>
	*(char*)vbuf = c;
  8028d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d4:	88 02                	mov    %al,(%edx)
	return 1;
  8028d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    
		return 0;
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e2:	eb f7                	jmp    8028db <devcons_read+0x32>

008028e4 <cputchar>:
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028f0:	6a 01                	push   $0x1
  8028f2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028f5:	50                   	push   %eax
  8028f6:	e8 6f e6 ff ff       	call   800f6a <sys_cputs>
}
  8028fb:	83 c4 10             	add    $0x10,%esp
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <getchar>:
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802906:	6a 01                	push   $0x1
  802908:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80290b:	50                   	push   %eax
  80290c:	6a 00                	push   $0x0
  80290e:	e8 d8 f1 ff ff       	call   801aeb <read>
	if (r < 0)
  802913:	83 c4 10             	add    $0x10,%esp
  802916:	85 c0                	test   %eax,%eax
  802918:	78 06                	js     802920 <getchar+0x20>
	if (r < 1)
  80291a:	74 06                	je     802922 <getchar+0x22>
	return c;
  80291c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    
		return -E_EOF;
  802922:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802927:	eb f7                	jmp    802920 <getchar+0x20>

00802929 <iscons>:
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80292f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802932:	50                   	push   %eax
  802933:	ff 75 08             	pushl  0x8(%ebp)
  802936:	e8 40 ef ff ff       	call   80187b <fd_lookup>
  80293b:	83 c4 10             	add    $0x10,%esp
  80293e:	85 c0                	test   %eax,%eax
  802940:	78 11                	js     802953 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80294b:	39 10                	cmp    %edx,(%eax)
  80294d:	0f 94 c0             	sete   %al
  802950:	0f b6 c0             	movzbl %al,%eax
}
  802953:	c9                   	leave  
  802954:	c3                   	ret    

00802955 <opencons>:
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80295b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80295e:	50                   	push   %eax
  80295f:	e8 c5 ee ff ff       	call   801829 <fd_alloc>
  802964:	83 c4 10             	add    $0x10,%esp
  802967:	85 c0                	test   %eax,%eax
  802969:	78 3a                	js     8029a5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80296b:	83 ec 04             	sub    $0x4,%esp
  80296e:	68 07 04 00 00       	push   $0x407
  802973:	ff 75 f4             	pushl  -0xc(%ebp)
  802976:	6a 00                	push   $0x0
  802978:	e8 a9 e6 ff ff       	call   801026 <sys_page_alloc>
  80297d:	83 c4 10             	add    $0x10,%esp
  802980:	85 c0                	test   %eax,%eax
  802982:	78 21                	js     8029a5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80298d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802999:	83 ec 0c             	sub    $0xc,%esp
  80299c:	50                   	push   %eax
  80299d:	e8 60 ee ff ff       	call   801802 <fd2num>
  8029a2:	83 c4 10             	add    $0x10,%esp
}
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
  8029aa:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029ad:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029b4:	74 0a                	je     8029c0 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	6a 07                	push   $0x7
  8029c5:	68 00 f0 bf ee       	push   $0xeebff000
  8029ca:	6a 00                	push   $0x0
  8029cc:	e8 55 e6 ff ff       	call   801026 <sys_page_alloc>
		if(r < 0)
  8029d1:	83 c4 10             	add    $0x10,%esp
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	78 2a                	js     802a02 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029d8:	83 ec 08             	sub    $0x8,%esp
  8029db:	68 16 2a 80 00       	push   $0x802a16
  8029e0:	6a 00                	push   $0x0
  8029e2:	e8 8a e7 ff ff       	call   801171 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029e7:	83 c4 10             	add    $0x10,%esp
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	79 c8                	jns    8029b6 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	68 d4 35 80 00       	push   $0x8035d4
  8029f6:	6a 25                	push   $0x25
  8029f8:	68 10 36 80 00       	push   $0x803610
  8029fd:	e8 dd d9 ff ff       	call   8003df <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 a4 35 80 00       	push   $0x8035a4
  802a0a:	6a 22                	push   $0x22
  802a0c:	68 10 36 80 00       	push   $0x803610
  802a11:	e8 c9 d9 ff ff       	call   8003df <_panic>

00802a16 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a16:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a17:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a1c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a1e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a21:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a25:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a29:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a2c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a2e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a32:	83 c4 08             	add    $0x8,%esp
	popal
  802a35:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a36:	83 c4 04             	add    $0x4,%esp
	popfl
  802a39:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a3a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a3b:	c3                   	ret    

00802a3c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	56                   	push   %esi
  802a40:	53                   	push   %ebx
  802a41:	8b 75 08             	mov    0x8(%ebp),%esi
  802a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802a4a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802a4c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a51:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a54:	83 ec 0c             	sub    $0xc,%esp
  802a57:	50                   	push   %eax
  802a58:	e8 79 e7 ff ff       	call   8011d6 <sys_ipc_recv>
	if(ret < 0){
  802a5d:	83 c4 10             	add    $0x10,%esp
  802a60:	85 c0                	test   %eax,%eax
  802a62:	78 2b                	js     802a8f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a64:	85 f6                	test   %esi,%esi
  802a66:	74 0a                	je     802a72 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802a68:	a1 08 50 80 00       	mov    0x805008,%eax
  802a6d:	8b 40 74             	mov    0x74(%eax),%eax
  802a70:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a72:	85 db                	test   %ebx,%ebx
  802a74:	74 0a                	je     802a80 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802a76:	a1 08 50 80 00       	mov    0x805008,%eax
  802a7b:	8b 40 78             	mov    0x78(%eax),%eax
  802a7e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802a80:	a1 08 50 80 00       	mov    0x805008,%eax
  802a85:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    
		if(from_env_store)
  802a8f:	85 f6                	test   %esi,%esi
  802a91:	74 06                	je     802a99 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a99:	85 db                	test   %ebx,%ebx
  802a9b:	74 eb                	je     802a88 <ipc_recv+0x4c>
			*perm_store = 0;
  802a9d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802aa3:	eb e3                	jmp    802a88 <ipc_recv+0x4c>

00802aa5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
  802aa8:	57                   	push   %edi
  802aa9:	56                   	push   %esi
  802aaa:	53                   	push   %ebx
  802aab:	83 ec 0c             	sub    $0xc,%esp
  802aae:	8b 7d 08             	mov    0x8(%ebp),%edi
  802ab1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ab4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802ab7:	85 db                	test   %ebx,%ebx
  802ab9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802abe:	0f 44 d8             	cmove  %eax,%ebx
  802ac1:	eb 05                	jmp    802ac8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802ac3:	e8 3f e5 ff ff       	call   801007 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802ac8:	ff 75 14             	pushl  0x14(%ebp)
  802acb:	53                   	push   %ebx
  802acc:	56                   	push   %esi
  802acd:	57                   	push   %edi
  802ace:	e8 e0 e6 ff ff       	call   8011b3 <sys_ipc_try_send>
  802ad3:	83 c4 10             	add    $0x10,%esp
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 1b                	je     802af5 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802ada:	79 e7                	jns    802ac3 <ipc_send+0x1e>
  802adc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802adf:	74 e2                	je     802ac3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 1e 36 80 00       	push   $0x80361e
  802ae9:	6a 46                	push   $0x46
  802aeb:	68 33 36 80 00       	push   $0x803633
  802af0:	e8 ea d8 ff ff       	call   8003df <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802af8:	5b                   	pop    %ebx
  802af9:	5e                   	pop    %esi
  802afa:	5f                   	pop    %edi
  802afb:	5d                   	pop    %ebp
  802afc:	c3                   	ret    

00802afd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802afd:	55                   	push   %ebp
  802afe:	89 e5                	mov    %esp,%ebp
  802b00:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b08:	89 c2                	mov    %eax,%edx
  802b0a:	c1 e2 07             	shl    $0x7,%edx
  802b0d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b13:	8b 52 50             	mov    0x50(%edx),%edx
  802b16:	39 ca                	cmp    %ecx,%edx
  802b18:	74 11                	je     802b2b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802b1a:	83 c0 01             	add    $0x1,%eax
  802b1d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b22:	75 e4                	jne    802b08 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802b24:	b8 00 00 00 00       	mov    $0x0,%eax
  802b29:	eb 0b                	jmp    802b36 <ipc_find_env+0x39>
			return envs[i].env_id;
  802b2b:	c1 e0 07             	shl    $0x7,%eax
  802b2e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b33:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b36:	5d                   	pop    %ebp
  802b37:	c3                   	ret    

00802b38 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b38:	55                   	push   %ebp
  802b39:	89 e5                	mov    %esp,%ebp
  802b3b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b3e:	89 d0                	mov    %edx,%eax
  802b40:	c1 e8 16             	shr    $0x16,%eax
  802b43:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b4f:	f6 c1 01             	test   $0x1,%cl
  802b52:	74 1d                	je     802b71 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b54:	c1 ea 0c             	shr    $0xc,%edx
  802b57:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b5e:	f6 c2 01             	test   $0x1,%dl
  802b61:	74 0e                	je     802b71 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b63:	c1 ea 0c             	shr    $0xc,%edx
  802b66:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b6d:	ef 
  802b6e:	0f b7 c0             	movzwl %ax,%eax
}
  802b71:	5d                   	pop    %ebp
  802b72:	c3                   	ret    
  802b73:	66 90                	xchg   %ax,%ax
  802b75:	66 90                	xchg   %ax,%ax
  802b77:	66 90                	xchg   %ax,%ax
  802b79:	66 90                	xchg   %ax,%ax
  802b7b:	66 90                	xchg   %ax,%ax
  802b7d:	66 90                	xchg   %ax,%ax
  802b7f:	90                   	nop

00802b80 <__udivdi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	53                   	push   %ebx
  802b84:	83 ec 1c             	sub    $0x1c,%esp
  802b87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b97:	85 d2                	test   %edx,%edx
  802b99:	75 4d                	jne    802be8 <__udivdi3+0x68>
  802b9b:	39 f3                	cmp    %esi,%ebx
  802b9d:	76 19                	jbe    802bb8 <__udivdi3+0x38>
  802b9f:	31 ff                	xor    %edi,%edi
  802ba1:	89 e8                	mov    %ebp,%eax
  802ba3:	89 f2                	mov    %esi,%edx
  802ba5:	f7 f3                	div    %ebx
  802ba7:	89 fa                	mov    %edi,%edx
  802ba9:	83 c4 1c             	add    $0x1c,%esp
  802bac:	5b                   	pop    %ebx
  802bad:	5e                   	pop    %esi
  802bae:	5f                   	pop    %edi
  802baf:	5d                   	pop    %ebp
  802bb0:	c3                   	ret    
  802bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	89 d9                	mov    %ebx,%ecx
  802bba:	85 db                	test   %ebx,%ebx
  802bbc:	75 0b                	jne    802bc9 <__udivdi3+0x49>
  802bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc3:	31 d2                	xor    %edx,%edx
  802bc5:	f7 f3                	div    %ebx
  802bc7:	89 c1                	mov    %eax,%ecx
  802bc9:	31 d2                	xor    %edx,%edx
  802bcb:	89 f0                	mov    %esi,%eax
  802bcd:	f7 f1                	div    %ecx
  802bcf:	89 c6                	mov    %eax,%esi
  802bd1:	89 e8                	mov    %ebp,%eax
  802bd3:	89 f7                	mov    %esi,%edi
  802bd5:	f7 f1                	div    %ecx
  802bd7:	89 fa                	mov    %edi,%edx
  802bd9:	83 c4 1c             	add    $0x1c,%esp
  802bdc:	5b                   	pop    %ebx
  802bdd:	5e                   	pop    %esi
  802bde:	5f                   	pop    %edi
  802bdf:	5d                   	pop    %ebp
  802be0:	c3                   	ret    
  802be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802be8:	39 f2                	cmp    %esi,%edx
  802bea:	77 1c                	ja     802c08 <__udivdi3+0x88>
  802bec:	0f bd fa             	bsr    %edx,%edi
  802bef:	83 f7 1f             	xor    $0x1f,%edi
  802bf2:	75 2c                	jne    802c20 <__udivdi3+0xa0>
  802bf4:	39 f2                	cmp    %esi,%edx
  802bf6:	72 06                	jb     802bfe <__udivdi3+0x7e>
  802bf8:	31 c0                	xor    %eax,%eax
  802bfa:	39 eb                	cmp    %ebp,%ebx
  802bfc:	77 a9                	ja     802ba7 <__udivdi3+0x27>
  802bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  802c03:	eb a2                	jmp    802ba7 <__udivdi3+0x27>
  802c05:	8d 76 00             	lea    0x0(%esi),%esi
  802c08:	31 ff                	xor    %edi,%edi
  802c0a:	31 c0                	xor    %eax,%eax
  802c0c:	89 fa                	mov    %edi,%edx
  802c0e:	83 c4 1c             	add    $0x1c,%esp
  802c11:	5b                   	pop    %ebx
  802c12:	5e                   	pop    %esi
  802c13:	5f                   	pop    %edi
  802c14:	5d                   	pop    %ebp
  802c15:	c3                   	ret    
  802c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c1d:	8d 76 00             	lea    0x0(%esi),%esi
  802c20:	89 f9                	mov    %edi,%ecx
  802c22:	b8 20 00 00 00       	mov    $0x20,%eax
  802c27:	29 f8                	sub    %edi,%eax
  802c29:	d3 e2                	shl    %cl,%edx
  802c2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c2f:	89 c1                	mov    %eax,%ecx
  802c31:	89 da                	mov    %ebx,%edx
  802c33:	d3 ea                	shr    %cl,%edx
  802c35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c39:	09 d1                	or     %edx,%ecx
  802c3b:	89 f2                	mov    %esi,%edx
  802c3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c41:	89 f9                	mov    %edi,%ecx
  802c43:	d3 e3                	shl    %cl,%ebx
  802c45:	89 c1                	mov    %eax,%ecx
  802c47:	d3 ea                	shr    %cl,%edx
  802c49:	89 f9                	mov    %edi,%ecx
  802c4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c4f:	89 eb                	mov    %ebp,%ebx
  802c51:	d3 e6                	shl    %cl,%esi
  802c53:	89 c1                	mov    %eax,%ecx
  802c55:	d3 eb                	shr    %cl,%ebx
  802c57:	09 de                	or     %ebx,%esi
  802c59:	89 f0                	mov    %esi,%eax
  802c5b:	f7 74 24 08          	divl   0x8(%esp)
  802c5f:	89 d6                	mov    %edx,%esi
  802c61:	89 c3                	mov    %eax,%ebx
  802c63:	f7 64 24 0c          	mull   0xc(%esp)
  802c67:	39 d6                	cmp    %edx,%esi
  802c69:	72 15                	jb     802c80 <__udivdi3+0x100>
  802c6b:	89 f9                	mov    %edi,%ecx
  802c6d:	d3 e5                	shl    %cl,%ebp
  802c6f:	39 c5                	cmp    %eax,%ebp
  802c71:	73 04                	jae    802c77 <__udivdi3+0xf7>
  802c73:	39 d6                	cmp    %edx,%esi
  802c75:	74 09                	je     802c80 <__udivdi3+0x100>
  802c77:	89 d8                	mov    %ebx,%eax
  802c79:	31 ff                	xor    %edi,%edi
  802c7b:	e9 27 ff ff ff       	jmp    802ba7 <__udivdi3+0x27>
  802c80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c83:	31 ff                	xor    %edi,%edi
  802c85:	e9 1d ff ff ff       	jmp    802ba7 <__udivdi3+0x27>
  802c8a:	66 90                	xchg   %ax,%ax
  802c8c:	66 90                	xchg   %ax,%ax
  802c8e:	66 90                	xchg   %ax,%ax

00802c90 <__umoddi3>:
  802c90:	55                   	push   %ebp
  802c91:	57                   	push   %edi
  802c92:	56                   	push   %esi
  802c93:	53                   	push   %ebx
  802c94:	83 ec 1c             	sub    $0x1c,%esp
  802c97:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ca7:	89 da                	mov    %ebx,%edx
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	75 43                	jne    802cf0 <__umoddi3+0x60>
  802cad:	39 df                	cmp    %ebx,%edi
  802caf:	76 17                	jbe    802cc8 <__umoddi3+0x38>
  802cb1:	89 f0                	mov    %esi,%eax
  802cb3:	f7 f7                	div    %edi
  802cb5:	89 d0                	mov    %edx,%eax
  802cb7:	31 d2                	xor    %edx,%edx
  802cb9:	83 c4 1c             	add    $0x1c,%esp
  802cbc:	5b                   	pop    %ebx
  802cbd:	5e                   	pop    %esi
  802cbe:	5f                   	pop    %edi
  802cbf:	5d                   	pop    %ebp
  802cc0:	c3                   	ret    
  802cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	89 fd                	mov    %edi,%ebp
  802cca:	85 ff                	test   %edi,%edi
  802ccc:	75 0b                	jne    802cd9 <__umoddi3+0x49>
  802cce:	b8 01 00 00 00       	mov    $0x1,%eax
  802cd3:	31 d2                	xor    %edx,%edx
  802cd5:	f7 f7                	div    %edi
  802cd7:	89 c5                	mov    %eax,%ebp
  802cd9:	89 d8                	mov    %ebx,%eax
  802cdb:	31 d2                	xor    %edx,%edx
  802cdd:	f7 f5                	div    %ebp
  802cdf:	89 f0                	mov    %esi,%eax
  802ce1:	f7 f5                	div    %ebp
  802ce3:	89 d0                	mov    %edx,%eax
  802ce5:	eb d0                	jmp    802cb7 <__umoddi3+0x27>
  802ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cee:	66 90                	xchg   %ax,%ax
  802cf0:	89 f1                	mov    %esi,%ecx
  802cf2:	39 d8                	cmp    %ebx,%eax
  802cf4:	76 0a                	jbe    802d00 <__umoddi3+0x70>
  802cf6:	89 f0                	mov    %esi,%eax
  802cf8:	83 c4 1c             	add    $0x1c,%esp
  802cfb:	5b                   	pop    %ebx
  802cfc:	5e                   	pop    %esi
  802cfd:	5f                   	pop    %edi
  802cfe:	5d                   	pop    %ebp
  802cff:	c3                   	ret    
  802d00:	0f bd e8             	bsr    %eax,%ebp
  802d03:	83 f5 1f             	xor    $0x1f,%ebp
  802d06:	75 20                	jne    802d28 <__umoddi3+0x98>
  802d08:	39 d8                	cmp    %ebx,%eax
  802d0a:	0f 82 b0 00 00 00    	jb     802dc0 <__umoddi3+0x130>
  802d10:	39 f7                	cmp    %esi,%edi
  802d12:	0f 86 a8 00 00 00    	jbe    802dc0 <__umoddi3+0x130>
  802d18:	89 c8                	mov    %ecx,%eax
  802d1a:	83 c4 1c             	add    $0x1c,%esp
  802d1d:	5b                   	pop    %ebx
  802d1e:	5e                   	pop    %esi
  802d1f:	5f                   	pop    %edi
  802d20:	5d                   	pop    %ebp
  802d21:	c3                   	ret    
  802d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d28:	89 e9                	mov    %ebp,%ecx
  802d2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802d2f:	29 ea                	sub    %ebp,%edx
  802d31:	d3 e0                	shl    %cl,%eax
  802d33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d37:	89 d1                	mov    %edx,%ecx
  802d39:	89 f8                	mov    %edi,%eax
  802d3b:	d3 e8                	shr    %cl,%eax
  802d3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d49:	09 c1                	or     %eax,%ecx
  802d4b:	89 d8                	mov    %ebx,%eax
  802d4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d51:	89 e9                	mov    %ebp,%ecx
  802d53:	d3 e7                	shl    %cl,%edi
  802d55:	89 d1                	mov    %edx,%ecx
  802d57:	d3 e8                	shr    %cl,%eax
  802d59:	89 e9                	mov    %ebp,%ecx
  802d5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d5f:	d3 e3                	shl    %cl,%ebx
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	89 d1                	mov    %edx,%ecx
  802d65:	89 f0                	mov    %esi,%eax
  802d67:	d3 e8                	shr    %cl,%eax
  802d69:	89 e9                	mov    %ebp,%ecx
  802d6b:	89 fa                	mov    %edi,%edx
  802d6d:	d3 e6                	shl    %cl,%esi
  802d6f:	09 d8                	or     %ebx,%eax
  802d71:	f7 74 24 08          	divl   0x8(%esp)
  802d75:	89 d1                	mov    %edx,%ecx
  802d77:	89 f3                	mov    %esi,%ebx
  802d79:	f7 64 24 0c          	mull   0xc(%esp)
  802d7d:	89 c6                	mov    %eax,%esi
  802d7f:	89 d7                	mov    %edx,%edi
  802d81:	39 d1                	cmp    %edx,%ecx
  802d83:	72 06                	jb     802d8b <__umoddi3+0xfb>
  802d85:	75 10                	jne    802d97 <__umoddi3+0x107>
  802d87:	39 c3                	cmp    %eax,%ebx
  802d89:	73 0c                	jae    802d97 <__umoddi3+0x107>
  802d8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d93:	89 d7                	mov    %edx,%edi
  802d95:	89 c6                	mov    %eax,%esi
  802d97:	89 ca                	mov    %ecx,%edx
  802d99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d9e:	29 f3                	sub    %esi,%ebx
  802da0:	19 fa                	sbb    %edi,%edx
  802da2:	89 d0                	mov    %edx,%eax
  802da4:	d3 e0                	shl    %cl,%eax
  802da6:	89 e9                	mov    %ebp,%ecx
  802da8:	d3 eb                	shr    %cl,%ebx
  802daa:	d3 ea                	shr    %cl,%edx
  802dac:	09 d8                	or     %ebx,%eax
  802dae:	83 c4 1c             	add    $0x1c,%esp
  802db1:	5b                   	pop    %ebx
  802db2:	5e                   	pop    %esi
  802db3:	5f                   	pop    %edi
  802db4:	5d                   	pop    %ebp
  802db5:	c3                   	ret    
  802db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dbd:	8d 76 00             	lea    0x0(%esi),%esi
  802dc0:	89 da                	mov    %ebx,%edx
  802dc2:	29 fe                	sub    %edi,%esi
  802dc4:	19 c2                	sbb    %eax,%edx
  802dc6:	89 f1                	mov    %esi,%ecx
  802dc8:	89 c8                	mov    %ecx,%eax
  802dca:	e9 4b ff ff ff       	jmp    802d1a <__umoddi3+0x8a>
