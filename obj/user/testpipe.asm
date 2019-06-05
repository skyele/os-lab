
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
  80003b:	c7 05 04 40 80 00 c0 	movl   $0x802dc0,0x804004
  800042:	2d 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 f8 25 00 00       	call   802646 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 f0 14 00 00       	call   801550 <fork>
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
  80007f:	68 ee 2d 80 00       	push   $0x802dee
  800084:	e8 4c 04 00 00       	call   8004d5 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 f9 18 00 00       	call   80198d <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 0b 2e 80 00       	push   $0x802e0b
  8000a8:	e8 28 04 00 00       	call   8004d5 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 94 1a 00 00       	call   801b52 <readn>
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
  8000f0:	68 31 2e 80 00       	push   $0x802e31
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
  800106:	e8 b8 26 00 00       	call   8027c3 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 87 	movl   $0x802e87,0x804004
  800112:	2e 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 26 25 00 00       	call   802646 <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 1e 14 00 00       	call   801550 <fork>
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
  800148:	e8 40 18 00 00       	call   80198d <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 35 18 00 00       	call   80198d <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 63 26 00 00       	call   8027c3 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 b5 2e 80 00 	movl   $0x802eb5,(%esp)
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
  800177:	68 cc 2d 80 00       	push   $0x802dcc
  80017c:	6a 0e                	push   $0xe
  80017e:	68 d5 2d 80 00       	push   $0x802dd5
  800183:	e8 57 02 00 00       	call   8003df <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 e5 2d 80 00       	push   $0x802de5
  80018e:	6a 11                	push   $0x11
  800190:	68 d5 2d 80 00       	push   $0x802dd5
  800195:	e8 45 02 00 00       	call   8003df <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 28 2e 80 00       	push   $0x802e28
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 d5 2d 80 00       	push   $0x802dd5
  8001a7:	e8 33 02 00 00       	call   8003df <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 4d 2e 80 00       	push   $0x802e4d
  8001b9:	e8 17 03 00 00       	call   8004d5 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 ee 2d 80 00       	push   $0x802dee
  8001da:	e8 f6 02 00 00       	call   8004d5 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 a3 17 00 00       	call   80198d <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 60 2e 80 00       	push   $0x802e60
  8001fe:	e8 d2 02 00 00       	call   8004d5 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 ea 09 00 00       	call   800bfb <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 74 19 00 00       	call   801b97 <write>
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
  800240:	e8 48 17 00 00       	call   80198d <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 7d 2e 80 00       	push   $0x802e7d
  800253:	6a 25                	push   $0x25
  800255:	68 d5 2d 80 00       	push   $0x802dd5
  80025a:	e8 80 01 00 00       	call   8003df <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 cc 2d 80 00       	push   $0x802dcc
  800265:	6a 2c                	push   $0x2c
  800267:	68 d5 2d 80 00       	push   $0x802dd5
  80026c:	e8 6e 01 00 00       	call   8003df <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 e5 2d 80 00       	push   $0x802de5
  800277:	6a 2f                	push   $0x2f
  800279:	68 d5 2d 80 00       	push   $0x802dd5
  80027e:	e8 5c 01 00 00       	call   8003df <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 ff 16 00 00       	call   80198d <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 94 2e 80 00       	push   $0x802e94
  800299:	e8 37 02 00 00       	call   8004d5 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 96 2e 80 00       	push   $0x802e96
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 e7 18 00 00       	call   801b97 <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 98 2e 80 00       	push   $0x802e98
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
  800355:	68 0c 2f 80 00       	push   $0x802f0c
  80035a:	e8 76 01 00 00       	call   8004d5 <cprintf>
	cprintf("before umain\n");
  80035f:	c7 04 24 2a 2f 80 00 	movl   $0x802f2a,(%esp)
  800366:	e8 6a 01 00 00       	call   8004d5 <cprintf>
	// call user main routine
	umain(argc, argv);
  80036b:	83 c4 08             	add    $0x8,%esp
  80036e:	ff 75 0c             	pushl  0xc(%ebp)
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	e8 ba fc ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800379:	c7 04 24 38 2f 80 00 	movl   $0x802f38,(%esp)
  800380:	e8 50 01 00 00       	call   8004d5 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800385:	a1 08 50 80 00       	mov    0x805008,%eax
  80038a:	8b 40 48             	mov    0x48(%eax),%eax
  80038d:	83 c4 08             	add    $0x8,%esp
  800390:	50                   	push   %eax
  800391:	68 45 2f 80 00       	push   $0x802f45
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
  8003b9:	68 70 2f 80 00       	push   $0x802f70
  8003be:	50                   	push   %eax
  8003bf:	68 64 2f 80 00       	push   $0x802f64
  8003c4:	e8 0c 01 00 00       	call   8004d5 <cprintf>
	close_all();
  8003c9:	e8 ec 15 00 00       	call   8019ba <close_all>
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
  8003ef:	68 9c 2f 80 00       	push   $0x802f9c
  8003f4:	50                   	push   %eax
  8003f5:	68 64 2f 80 00       	push   $0x802f64
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
  800418:	68 78 2f 80 00       	push   $0x802f78
  80041d:	e8 b3 00 00 00       	call   8004d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800422:	83 c4 18             	add    $0x18,%esp
  800425:	53                   	push   %ebx
  800426:	ff 75 10             	pushl  0x10(%ebp)
  800429:	e8 56 00 00 00       	call   800484 <vcprintf>
	cprintf("\n");
  80042e:	c7 04 24 28 2f 80 00 	movl   $0x802f28,(%esp)
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
  800582:	e8 d9 25 00 00       	call   802b60 <__udivdi3>
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
  8005ab:	e8 c0 26 00 00       	call   802c70 <__umoddi3>
  8005b0:	83 c4 14             	add    $0x14,%esp
  8005b3:	0f be 80 a3 2f 80 00 	movsbl 0x802fa3(%eax),%eax
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
  80065c:	ff 24 85 80 31 80 00 	jmp    *0x803180(,%eax,4)
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
  800727:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  80072e:	85 d2                	test   %edx,%edx
  800730:	74 18                	je     80074a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800732:	52                   	push   %edx
  800733:	68 ed 34 80 00       	push   $0x8034ed
  800738:	53                   	push   %ebx
  800739:	56                   	push   %esi
  80073a:	e8 a6 fe ff ff       	call   8005e5 <printfmt>
  80073f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800742:	89 7d 14             	mov    %edi,0x14(%ebp)
  800745:	e9 fe 02 00 00       	jmp    800a48 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80074a:	50                   	push   %eax
  80074b:	68 bb 2f 80 00       	push   $0x802fbb
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
  800772:	b8 b4 2f 80 00       	mov    $0x802fb4,%eax
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
  800b0a:	bf d9 30 80 00       	mov    $0x8030d9,%edi
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
  800b36:	bf 11 31 80 00       	mov    $0x803111,%edi
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
  800fd7:	68 28 33 80 00       	push   $0x803328
  800fdc:	6a 43                	push   $0x43
  800fde:	68 45 33 80 00       	push   $0x803345
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
  801058:	68 28 33 80 00       	push   $0x803328
  80105d:	6a 43                	push   $0x43
  80105f:	68 45 33 80 00       	push   $0x803345
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
  80109a:	68 28 33 80 00       	push   $0x803328
  80109f:	6a 43                	push   $0x43
  8010a1:	68 45 33 80 00       	push   $0x803345
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
  8010dc:	68 28 33 80 00       	push   $0x803328
  8010e1:	6a 43                	push   $0x43
  8010e3:	68 45 33 80 00       	push   $0x803345
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
  80111e:	68 28 33 80 00       	push   $0x803328
  801123:	6a 43                	push   $0x43
  801125:	68 45 33 80 00       	push   $0x803345
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
  801160:	68 28 33 80 00       	push   $0x803328
  801165:	6a 43                	push   $0x43
  801167:	68 45 33 80 00       	push   $0x803345
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
  8011a2:	68 28 33 80 00       	push   $0x803328
  8011a7:	6a 43                	push   $0x43
  8011a9:	68 45 33 80 00       	push   $0x803345
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
  801206:	68 28 33 80 00       	push   $0x803328
  80120b:	6a 43                	push   $0x43
  80120d:	68 45 33 80 00       	push   $0x803345
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
  8012ea:	68 28 33 80 00       	push   $0x803328
  8012ef:	6a 43                	push   $0x43
  8012f1:	68 45 33 80 00       	push   $0x803345
  8012f6:	e8 e4 f0 ff ff       	call   8003df <_panic>

008012fb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801302:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801309:	f6 c5 04             	test   $0x4,%ch
  80130c:	75 45                	jne    801353 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80130e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801315:	83 e1 07             	and    $0x7,%ecx
  801318:	83 f9 07             	cmp    $0x7,%ecx
  80131b:	74 6f                	je     80138c <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80131d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801324:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80132a:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801330:	0f 84 b6 00 00 00    	je     8013ec <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801336:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80133d:	83 e1 05             	and    $0x5,%ecx
  801340:	83 f9 05             	cmp    $0x5,%ecx
  801343:	0f 84 d7 00 00 00    	je     801420 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801349:	b8 00 00 00 00       	mov    $0x0,%eax
  80134e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801351:	c9                   	leave  
  801352:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801353:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80135a:	c1 e2 0c             	shl    $0xc,%edx
  80135d:	83 ec 0c             	sub    $0xc,%esp
  801360:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801366:	51                   	push   %ecx
  801367:	52                   	push   %edx
  801368:	50                   	push   %eax
  801369:	52                   	push   %edx
  80136a:	6a 00                	push   $0x0
  80136c:	e8 f8 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  801371:	83 c4 20             	add    $0x20,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	79 d1                	jns    801349 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	68 53 33 80 00       	push   $0x803353
  801380:	6a 54                	push   $0x54
  801382:	68 69 33 80 00       	push   $0x803369
  801387:	e8 53 f0 ff ff       	call   8003df <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80138c:	89 d3                	mov    %edx,%ebx
  80138e:	c1 e3 0c             	shl    $0xc,%ebx
  801391:	83 ec 0c             	sub    $0xc,%esp
  801394:	68 05 08 00 00       	push   $0x805
  801399:	53                   	push   %ebx
  80139a:	50                   	push   %eax
  80139b:	53                   	push   %ebx
  80139c:	6a 00                	push   $0x0
  80139e:	e8 c6 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  8013a3:	83 c4 20             	add    $0x20,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 2e                	js     8013d8 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	68 05 08 00 00       	push   $0x805
  8013b2:	53                   	push   %ebx
  8013b3:	6a 00                	push   $0x0
  8013b5:	53                   	push   %ebx
  8013b6:	6a 00                	push   $0x0
  8013b8:	e8 ac fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  8013bd:	83 c4 20             	add    $0x20,%esp
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	79 85                	jns    801349 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	68 53 33 80 00       	push   $0x803353
  8013cc:	6a 5f                	push   $0x5f
  8013ce:	68 69 33 80 00       	push   $0x803369
  8013d3:	e8 07 f0 ff ff       	call   8003df <_panic>
			panic("sys_page_map() panic\n");
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	68 53 33 80 00       	push   $0x803353
  8013e0:	6a 5b                	push   $0x5b
  8013e2:	68 69 33 80 00       	push   $0x803369
  8013e7:	e8 f3 ef ff ff       	call   8003df <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013ec:	c1 e2 0c             	shl    $0xc,%edx
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 05 08 00 00       	push   $0x805
  8013f7:	52                   	push   %edx
  8013f8:	50                   	push   %eax
  8013f9:	52                   	push   %edx
  8013fa:	6a 00                	push   $0x0
  8013fc:	e8 68 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  801401:	83 c4 20             	add    $0x20,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	0f 89 3d ff ff ff    	jns    801349 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	68 53 33 80 00       	push   $0x803353
  801414:	6a 66                	push   $0x66
  801416:	68 69 33 80 00       	push   $0x803369
  80141b:	e8 bf ef ff ff       	call   8003df <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801420:	c1 e2 0c             	shl    $0xc,%edx
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	6a 05                	push   $0x5
  801428:	52                   	push   %edx
  801429:	50                   	push   %eax
  80142a:	52                   	push   %edx
  80142b:	6a 00                	push   $0x0
  80142d:	e8 37 fc ff ff       	call   801069 <sys_page_map>
		if(r < 0)
  801432:	83 c4 20             	add    $0x20,%esp
  801435:	85 c0                	test   %eax,%eax
  801437:	0f 89 0c ff ff ff    	jns    801349 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	68 53 33 80 00       	push   $0x803353
  801445:	6a 6d                	push   $0x6d
  801447:	68 69 33 80 00       	push   $0x803369
  80144c:	e8 8e ef ff ff       	call   8003df <_panic>

00801451 <pgfault>:
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	53                   	push   %ebx
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80145b:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80145d:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801461:	0f 84 99 00 00 00    	je     801500 <pgfault+0xaf>
  801467:	89 c2                	mov    %eax,%edx
  801469:	c1 ea 16             	shr    $0x16,%edx
  80146c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801473:	f6 c2 01             	test   $0x1,%dl
  801476:	0f 84 84 00 00 00    	je     801500 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80147c:	89 c2                	mov    %eax,%edx
  80147e:	c1 ea 0c             	shr    $0xc,%edx
  801481:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801488:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80148e:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801494:	75 6a                	jne    801500 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801496:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80149b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	6a 07                	push   $0x7
  8014a2:	68 00 f0 7f 00       	push   $0x7ff000
  8014a7:	6a 00                	push   $0x0
  8014a9:	e8 78 fb ff ff       	call   801026 <sys_page_alloc>
	if(ret < 0)
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 5f                	js     801514 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	68 00 10 00 00       	push   $0x1000
  8014bd:	53                   	push   %ebx
  8014be:	68 00 f0 7f 00       	push   $0x7ff000
  8014c3:	e8 5c f9 ff ff       	call   800e24 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014c8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014cf:	53                   	push   %ebx
  8014d0:	6a 00                	push   $0x0
  8014d2:	68 00 f0 7f 00       	push   $0x7ff000
  8014d7:	6a 00                	push   $0x0
  8014d9:	e8 8b fb ff ff       	call   801069 <sys_page_map>
	if(ret < 0)
  8014de:	83 c4 20             	add    $0x20,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 43                	js     801528 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	68 00 f0 7f 00       	push   $0x7ff000
  8014ed:	6a 00                	push   $0x0
  8014ef:	e8 b7 fb ff ff       	call   8010ab <sys_page_unmap>
	if(ret < 0)
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 41                	js     80153c <pgfault+0xeb>
}
  8014fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    
		panic("panic at pgfault()\n");
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	68 74 33 80 00       	push   $0x803374
  801508:	6a 26                	push   $0x26
  80150a:	68 69 33 80 00       	push   $0x803369
  80150f:	e8 cb ee ff ff       	call   8003df <_panic>
		panic("panic in sys_page_alloc()\n");
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 88 33 80 00       	push   $0x803388
  80151c:	6a 31                	push   $0x31
  80151e:	68 69 33 80 00       	push   $0x803369
  801523:	e8 b7 ee ff ff       	call   8003df <_panic>
		panic("panic in sys_page_map()\n");
  801528:	83 ec 04             	sub    $0x4,%esp
  80152b:	68 a3 33 80 00       	push   $0x8033a3
  801530:	6a 36                	push   $0x36
  801532:	68 69 33 80 00       	push   $0x803369
  801537:	e8 a3 ee ff ff       	call   8003df <_panic>
		panic("panic in sys_page_unmap()\n");
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	68 bc 33 80 00       	push   $0x8033bc
  801544:	6a 39                	push   $0x39
  801546:	68 69 33 80 00       	push   $0x803369
  80154b:	e8 8f ee ff ff       	call   8003df <_panic>

00801550 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	57                   	push   %edi
  801554:	56                   	push   %esi
  801555:	53                   	push   %ebx
  801556:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801559:	68 51 14 80 00       	push   $0x801451
  80155e:	e8 24 14 00 00       	call   802987 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801563:	b8 07 00 00 00       	mov    $0x7,%eax
  801568:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 27                	js     801598 <fork+0x48>
  801571:	89 c6                	mov    %eax,%esi
  801573:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801575:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80157a:	75 48                	jne    8015c4 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80157c:	e8 67 fa ff ff       	call   800fe8 <sys_getenvid>
  801581:	25 ff 03 00 00       	and    $0x3ff,%eax
  801586:	c1 e0 07             	shl    $0x7,%eax
  801589:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80158e:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801593:	e9 90 00 00 00       	jmp    801628 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	68 d8 33 80 00       	push   $0x8033d8
  8015a0:	68 8c 00 00 00       	push   $0x8c
  8015a5:	68 69 33 80 00       	push   $0x803369
  8015aa:	e8 30 ee ff ff       	call   8003df <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8015af:	89 f8                	mov    %edi,%eax
  8015b1:	e8 45 fd ff ff       	call   8012fb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015bc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8015c2:	74 26                	je     8015ea <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8015c4:	89 d8                	mov    %ebx,%eax
  8015c6:	c1 e8 16             	shr    $0x16,%eax
  8015c9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015d0:	a8 01                	test   $0x1,%al
  8015d2:	74 e2                	je     8015b6 <fork+0x66>
  8015d4:	89 da                	mov    %ebx,%edx
  8015d6:	c1 ea 0c             	shr    $0xc,%edx
  8015d9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015e0:	83 e0 05             	and    $0x5,%eax
  8015e3:	83 f8 05             	cmp    $0x5,%eax
  8015e6:	75 ce                	jne    8015b6 <fork+0x66>
  8015e8:	eb c5                	jmp    8015af <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	6a 07                	push   $0x7
  8015ef:	68 00 f0 bf ee       	push   $0xeebff000
  8015f4:	56                   	push   %esi
  8015f5:	e8 2c fa ff ff       	call   801026 <sys_page_alloc>
	if(ret < 0)
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	78 31                	js     801632 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	68 f6 29 80 00       	push   $0x8029f6
  801609:	56                   	push   %esi
  80160a:	e8 62 fb ff ff       	call   801171 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	78 33                	js     801649 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	6a 02                	push   $0x2
  80161b:	56                   	push   %esi
  80161c:	e8 cc fa ff ff       	call   8010ed <sys_env_set_status>
	if(ret < 0)
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 38                	js     801660 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801628:	89 f0                	mov    %esi,%eax
  80162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162d:	5b                   	pop    %ebx
  80162e:	5e                   	pop    %esi
  80162f:	5f                   	pop    %edi
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	68 88 33 80 00       	push   $0x803388
  80163a:	68 98 00 00 00       	push   $0x98
  80163f:	68 69 33 80 00       	push   $0x803369
  801644:	e8 96 ed ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	68 fc 33 80 00       	push   $0x8033fc
  801651:	68 9b 00 00 00       	push   $0x9b
  801656:	68 69 33 80 00       	push   $0x803369
  80165b:	e8 7f ed ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_status()\n");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 24 34 80 00       	push   $0x803424
  801668:	68 9e 00 00 00       	push   $0x9e
  80166d:	68 69 33 80 00       	push   $0x803369
  801672:	e8 68 ed ff ff       	call   8003df <_panic>

00801677 <sfork>:

// Challenge!
int
sfork(void)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	57                   	push   %edi
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801680:	68 51 14 80 00       	push   $0x801451
  801685:	e8 fd 12 00 00       	call   802987 <set_pgfault_handler>
  80168a:	b8 07 00 00 00       	mov    $0x7,%eax
  80168f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	85 c0                	test   %eax,%eax
  801696:	78 27                	js     8016bf <sfork+0x48>
  801698:	89 c7                	mov    %eax,%edi
  80169a:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80169c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016a1:	75 55                	jne    8016f8 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016a3:	e8 40 f9 ff ff       	call   800fe8 <sys_getenvid>
  8016a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016ad:	c1 e0 07             	shl    $0x7,%eax
  8016b0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016b5:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8016ba:	e9 d4 00 00 00       	jmp    801793 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	68 d8 33 80 00       	push   $0x8033d8
  8016c7:	68 af 00 00 00       	push   $0xaf
  8016cc:	68 69 33 80 00       	push   $0x803369
  8016d1:	e8 09 ed ff ff       	call   8003df <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8016d6:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8016db:	89 f0                	mov    %esi,%eax
  8016dd:	e8 19 fc ff ff       	call   8012fb <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016e8:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8016ee:	77 65                	ja     801755 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8016f0:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8016f6:	74 de                	je     8016d6 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8016f8:	89 d8                	mov    %ebx,%eax
  8016fa:	c1 e8 16             	shr    $0x16,%eax
  8016fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801704:	a8 01                	test   $0x1,%al
  801706:	74 da                	je     8016e2 <sfork+0x6b>
  801708:	89 da                	mov    %ebx,%edx
  80170a:	c1 ea 0c             	shr    $0xc,%edx
  80170d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801714:	83 e0 05             	and    $0x5,%eax
  801717:	83 f8 05             	cmp    $0x5,%eax
  80171a:	75 c6                	jne    8016e2 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80171c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801723:	c1 e2 0c             	shl    $0xc,%edx
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	83 e0 07             	and    $0x7,%eax
  80172c:	50                   	push   %eax
  80172d:	52                   	push   %edx
  80172e:	56                   	push   %esi
  80172f:	52                   	push   %edx
  801730:	6a 00                	push   $0x0
  801732:	e8 32 f9 ff ff       	call   801069 <sys_page_map>
  801737:	83 c4 20             	add    $0x20,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	74 a4                	je     8016e2 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	68 53 33 80 00       	push   $0x803353
  801746:	68 ba 00 00 00       	push   $0xba
  80174b:	68 69 33 80 00       	push   $0x803369
  801750:	e8 8a ec ff ff       	call   8003df <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	6a 07                	push   $0x7
  80175a:	68 00 f0 bf ee       	push   $0xeebff000
  80175f:	57                   	push   %edi
  801760:	e8 c1 f8 ff ff       	call   801026 <sys_page_alloc>
	if(ret < 0)
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 31                	js     80179d <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	68 f6 29 80 00       	push   $0x8029f6
  801774:	57                   	push   %edi
  801775:	e8 f7 f9 ff ff       	call   801171 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 33                	js     8017b4 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801781:	83 ec 08             	sub    $0x8,%esp
  801784:	6a 02                	push   $0x2
  801786:	57                   	push   %edi
  801787:	e8 61 f9 ff ff       	call   8010ed <sys_env_set_status>
	if(ret < 0)
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 38                	js     8017cb <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801793:	89 f8                	mov    %edi,%eax
  801795:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801798:	5b                   	pop    %ebx
  801799:	5e                   	pop    %esi
  80179a:	5f                   	pop    %edi
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 88 33 80 00       	push   $0x803388
  8017a5:	68 c0 00 00 00       	push   $0xc0
  8017aa:	68 69 33 80 00       	push   $0x803369
  8017af:	e8 2b ec ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 fc 33 80 00       	push   $0x8033fc
  8017bc:	68 c3 00 00 00       	push   $0xc3
  8017c1:	68 69 33 80 00       	push   $0x803369
  8017c6:	e8 14 ec ff ff       	call   8003df <_panic>
		panic("panic in sys_env_set_status()\n");
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	68 24 34 80 00       	push   $0x803424
  8017d3:	68 c6 00 00 00       	push   $0xc6
  8017d8:	68 69 33 80 00       	push   $0x803369
  8017dd:	e8 fd eb ff ff       	call   8003df <_panic>

008017e2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	05 00 00 00 30       	add    $0x30000000,%eax
  8017ed:	c1 e8 0c             	shr    $0xc,%eax
}
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    

008017f2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801802:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    

00801809 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801811:	89 c2                	mov    %eax,%edx
  801813:	c1 ea 16             	shr    $0x16,%edx
  801816:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80181d:	f6 c2 01             	test   $0x1,%dl
  801820:	74 2d                	je     80184f <fd_alloc+0x46>
  801822:	89 c2                	mov    %eax,%edx
  801824:	c1 ea 0c             	shr    $0xc,%edx
  801827:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80182e:	f6 c2 01             	test   $0x1,%dl
  801831:	74 1c                	je     80184f <fd_alloc+0x46>
  801833:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801838:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80183d:	75 d2                	jne    801811 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801848:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80184d:	eb 0a                	jmp    801859 <fd_alloc+0x50>
			*fd_store = fd;
  80184f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801852:	89 01                	mov    %eax,(%ecx)
			return 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    

0080185b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801861:	83 f8 1f             	cmp    $0x1f,%eax
  801864:	77 30                	ja     801896 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801866:	c1 e0 0c             	shl    $0xc,%eax
  801869:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80186e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801874:	f6 c2 01             	test   $0x1,%dl
  801877:	74 24                	je     80189d <fd_lookup+0x42>
  801879:	89 c2                	mov    %eax,%edx
  80187b:	c1 ea 0c             	shr    $0xc,%edx
  80187e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801885:	f6 c2 01             	test   $0x1,%dl
  801888:	74 1a                	je     8018a4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	89 02                	mov    %eax,(%edx)
	return 0;
  80188f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    
		return -E_INVAL;
  801896:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189b:	eb f7                	jmp    801894 <fd_lookup+0x39>
		return -E_INVAL;
  80189d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a2:	eb f0                	jmp    801894 <fd_lookup+0x39>
  8018a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a9:	eb e9                	jmp    801894 <fd_lookup+0x39>

008018ab <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b9:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018be:	39 08                	cmp    %ecx,(%eax)
  8018c0:	74 38                	je     8018fa <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018c2:	83 c2 01             	add    $0x1,%edx
  8018c5:	8b 04 95 c0 34 80 00 	mov    0x8034c0(,%edx,4),%eax
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	75 ee                	jne    8018be <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018d0:	a1 08 50 80 00       	mov    0x805008,%eax
  8018d5:	8b 40 48             	mov    0x48(%eax),%eax
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	51                   	push   %ecx
  8018dc:	50                   	push   %eax
  8018dd:	68 44 34 80 00       	push   $0x803444
  8018e2:	e8 ee eb ff ff       	call   8004d5 <cprintf>
	*dev = 0;
  8018e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    
			*dev = devtab[i];
  8018fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018fd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801904:	eb f2                	jmp    8018f8 <dev_lookup+0x4d>

00801906 <fd_close>:
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	57                   	push   %edi
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	83 ec 24             	sub    $0x24,%esp
  80190f:	8b 75 08             	mov    0x8(%ebp),%esi
  801912:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801915:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801918:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801919:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80191f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801922:	50                   	push   %eax
  801923:	e8 33 ff ff ff       	call   80185b <fd_lookup>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 05                	js     801936 <fd_close+0x30>
	    || fd != fd2)
  801931:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801934:	74 16                	je     80194c <fd_close+0x46>
		return (must_exist ? r : 0);
  801936:	89 f8                	mov    %edi,%eax
  801938:	84 c0                	test   %al,%al
  80193a:	b8 00 00 00 00       	mov    $0x0,%eax
  80193f:	0f 44 d8             	cmove  %eax,%ebx
}
  801942:	89 d8                	mov    %ebx,%eax
  801944:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801947:	5b                   	pop    %ebx
  801948:	5e                   	pop    %esi
  801949:	5f                   	pop    %edi
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	ff 36                	pushl  (%esi)
  801955:	e8 51 ff ff ff       	call   8018ab <dev_lookup>
  80195a:	89 c3                	mov    %eax,%ebx
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 1a                	js     80197d <fd_close+0x77>
		if (dev->dev_close)
  801963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801966:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801969:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80196e:	85 c0                	test   %eax,%eax
  801970:	74 0b                	je     80197d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	56                   	push   %esi
  801976:	ff d0                	call   *%eax
  801978:	89 c3                	mov    %eax,%ebx
  80197a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	56                   	push   %esi
  801981:	6a 00                	push   $0x0
  801983:	e8 23 f7 ff ff       	call   8010ab <sys_page_unmap>
	return r;
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	eb b5                	jmp    801942 <fd_close+0x3c>

0080198d <close>:

int
close(int fdnum)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801993:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801996:	50                   	push   %eax
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	e8 bc fe ff ff       	call   80185b <fd_lookup>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	79 02                	jns    8019a8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    
		return fd_close(fd, 1);
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	6a 01                	push   $0x1
  8019ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b0:	e8 51 ff ff ff       	call   801906 <fd_close>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	eb ec                	jmp    8019a6 <close+0x19>

008019ba <close_all>:

void
close_all(void)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	53                   	push   %ebx
  8019be:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019c6:	83 ec 0c             	sub    $0xc,%esp
  8019c9:	53                   	push   %ebx
  8019ca:	e8 be ff ff ff       	call   80198d <close>
	for (i = 0; i < MAXFD; i++)
  8019cf:	83 c3 01             	add    $0x1,%ebx
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	83 fb 20             	cmp    $0x20,%ebx
  8019d8:	75 ec                	jne    8019c6 <close_all+0xc>
}
  8019da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	57                   	push   %edi
  8019e3:	56                   	push   %esi
  8019e4:	53                   	push   %ebx
  8019e5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019eb:	50                   	push   %eax
  8019ec:	ff 75 08             	pushl  0x8(%ebp)
  8019ef:	e8 67 fe ff ff       	call   80185b <fd_lookup>
  8019f4:	89 c3                	mov    %eax,%ebx
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	0f 88 81 00 00 00    	js     801a82 <dup+0xa3>
		return r;
	close(newfdnum);
  801a01:	83 ec 0c             	sub    $0xc,%esp
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	e8 81 ff ff ff       	call   80198d <close>

	newfd = INDEX2FD(newfdnum);
  801a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a0f:	c1 e6 0c             	shl    $0xc,%esi
  801a12:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a18:	83 c4 04             	add    $0x4,%esp
  801a1b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a1e:	e8 cf fd ff ff       	call   8017f2 <fd2data>
  801a23:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a25:	89 34 24             	mov    %esi,(%esp)
  801a28:	e8 c5 fd ff ff       	call   8017f2 <fd2data>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a32:	89 d8                	mov    %ebx,%eax
  801a34:	c1 e8 16             	shr    $0x16,%eax
  801a37:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a3e:	a8 01                	test   $0x1,%al
  801a40:	74 11                	je     801a53 <dup+0x74>
  801a42:	89 d8                	mov    %ebx,%eax
  801a44:	c1 e8 0c             	shr    $0xc,%eax
  801a47:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a4e:	f6 c2 01             	test   $0x1,%dl
  801a51:	75 39                	jne    801a8c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a56:	89 d0                	mov    %edx,%eax
  801a58:	c1 e8 0c             	shr    $0xc,%eax
  801a5b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a62:	83 ec 0c             	sub    $0xc,%esp
  801a65:	25 07 0e 00 00       	and    $0xe07,%eax
  801a6a:	50                   	push   %eax
  801a6b:	56                   	push   %esi
  801a6c:	6a 00                	push   $0x0
  801a6e:	52                   	push   %edx
  801a6f:	6a 00                	push   $0x0
  801a71:	e8 f3 f5 ff ff       	call   801069 <sys_page_map>
  801a76:	89 c3                	mov    %eax,%ebx
  801a78:	83 c4 20             	add    $0x20,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 31                	js     801ab0 <dup+0xd1>
		goto err;

	return newfdnum;
  801a7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a82:	89 d8                	mov    %ebx,%eax
  801a84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5f                   	pop    %edi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a8c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	25 07 0e 00 00       	and    $0xe07,%eax
  801a9b:	50                   	push   %eax
  801a9c:	57                   	push   %edi
  801a9d:	6a 00                	push   $0x0
  801a9f:	53                   	push   %ebx
  801aa0:	6a 00                	push   $0x0
  801aa2:	e8 c2 f5 ff ff       	call   801069 <sys_page_map>
  801aa7:	89 c3                	mov    %eax,%ebx
  801aa9:	83 c4 20             	add    $0x20,%esp
  801aac:	85 c0                	test   %eax,%eax
  801aae:	79 a3                	jns    801a53 <dup+0x74>
	sys_page_unmap(0, newfd);
  801ab0:	83 ec 08             	sub    $0x8,%esp
  801ab3:	56                   	push   %esi
  801ab4:	6a 00                	push   $0x0
  801ab6:	e8 f0 f5 ff ff       	call   8010ab <sys_page_unmap>
	sys_page_unmap(0, nva);
  801abb:	83 c4 08             	add    $0x8,%esp
  801abe:	57                   	push   %edi
  801abf:	6a 00                	push   $0x0
  801ac1:	e8 e5 f5 ff ff       	call   8010ab <sys_page_unmap>
	return r;
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	eb b7                	jmp    801a82 <dup+0xa3>

00801acb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	53                   	push   %ebx
  801acf:	83 ec 1c             	sub    $0x1c,%esp
  801ad2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad8:	50                   	push   %eax
  801ad9:	53                   	push   %ebx
  801ada:	e8 7c fd ff ff       	call   80185b <fd_lookup>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 3f                	js     801b25 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae6:	83 ec 08             	sub    $0x8,%esp
  801ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aec:	50                   	push   %eax
  801aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af0:	ff 30                	pushl  (%eax)
  801af2:	e8 b4 fd ff ff       	call   8018ab <dev_lookup>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 27                	js     801b25 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b01:	8b 42 08             	mov    0x8(%edx),%eax
  801b04:	83 e0 03             	and    $0x3,%eax
  801b07:	83 f8 01             	cmp    $0x1,%eax
  801b0a:	74 1e                	je     801b2a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0f:	8b 40 08             	mov    0x8(%eax),%eax
  801b12:	85 c0                	test   %eax,%eax
  801b14:	74 35                	je     801b4b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	ff 75 10             	pushl  0x10(%ebp)
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	52                   	push   %edx
  801b20:	ff d0                	call   *%eax
  801b22:	83 c4 10             	add    $0x10,%esp
}
  801b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b2a:	a1 08 50 80 00       	mov    0x805008,%eax
  801b2f:	8b 40 48             	mov    0x48(%eax),%eax
  801b32:	83 ec 04             	sub    $0x4,%esp
  801b35:	53                   	push   %ebx
  801b36:	50                   	push   %eax
  801b37:	68 85 34 80 00       	push   $0x803485
  801b3c:	e8 94 e9 ff ff       	call   8004d5 <cprintf>
		return -E_INVAL;
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b49:	eb da                	jmp    801b25 <read+0x5a>
		return -E_NOT_SUPP;
  801b4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b50:	eb d3                	jmp    801b25 <read+0x5a>

00801b52 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	57                   	push   %edi
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b5e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b61:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b66:	39 f3                	cmp    %esi,%ebx
  801b68:	73 23                	jae    801b8d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b6a:	83 ec 04             	sub    $0x4,%esp
  801b6d:	89 f0                	mov    %esi,%eax
  801b6f:	29 d8                	sub    %ebx,%eax
  801b71:	50                   	push   %eax
  801b72:	89 d8                	mov    %ebx,%eax
  801b74:	03 45 0c             	add    0xc(%ebp),%eax
  801b77:	50                   	push   %eax
  801b78:	57                   	push   %edi
  801b79:	e8 4d ff ff ff       	call   801acb <read>
		if (m < 0)
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 06                	js     801b8b <readn+0x39>
			return m;
		if (m == 0)
  801b85:	74 06                	je     801b8d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b87:	01 c3                	add    %eax,%ebx
  801b89:	eb db                	jmp    801b66 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b8b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b8d:	89 d8                	mov    %ebx,%eax
  801b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b92:	5b                   	pop    %ebx
  801b93:	5e                   	pop    %esi
  801b94:	5f                   	pop    %edi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    

00801b97 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	53                   	push   %ebx
  801b9b:	83 ec 1c             	sub    $0x1c,%esp
  801b9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ba1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ba4:	50                   	push   %eax
  801ba5:	53                   	push   %ebx
  801ba6:	e8 b0 fc ff ff       	call   80185b <fd_lookup>
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 3a                	js     801bec <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb8:	50                   	push   %eax
  801bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbc:	ff 30                	pushl  (%eax)
  801bbe:	e8 e8 fc ff ff       	call   8018ab <dev_lookup>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 22                	js     801bec <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bd1:	74 1e                	je     801bf1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd6:	8b 52 0c             	mov    0xc(%edx),%edx
  801bd9:	85 d2                	test   %edx,%edx
  801bdb:	74 35                	je     801c12 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	ff 75 10             	pushl  0x10(%ebp)
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	50                   	push   %eax
  801be7:	ff d2                	call   *%edx
  801be9:	83 c4 10             	add    $0x10,%esp
}
  801bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bf1:	a1 08 50 80 00       	mov    0x805008,%eax
  801bf6:	8b 40 48             	mov    0x48(%eax),%eax
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	53                   	push   %ebx
  801bfd:	50                   	push   %eax
  801bfe:	68 a1 34 80 00       	push   $0x8034a1
  801c03:	e8 cd e8 ff ff       	call   8004d5 <cprintf>
		return -E_INVAL;
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c10:	eb da                	jmp    801bec <write+0x55>
		return -E_NOT_SUPP;
  801c12:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c17:	eb d3                	jmp    801bec <write+0x55>

00801c19 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c22:	50                   	push   %eax
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	e8 30 fc ff ff       	call   80185b <fd_lookup>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 0e                	js     801c40 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c38:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	53                   	push   %ebx
  801c46:	83 ec 1c             	sub    $0x1c,%esp
  801c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c4f:	50                   	push   %eax
  801c50:	53                   	push   %ebx
  801c51:	e8 05 fc ff ff       	call   80185b <fd_lookup>
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	78 37                	js     801c94 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c5d:	83 ec 08             	sub    $0x8,%esp
  801c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c63:	50                   	push   %eax
  801c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c67:	ff 30                	pushl  (%eax)
  801c69:	e8 3d fc ff ff       	call   8018ab <dev_lookup>
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 1f                	js     801c94 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c78:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c7c:	74 1b                	je     801c99 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c81:	8b 52 18             	mov    0x18(%edx),%edx
  801c84:	85 d2                	test   %edx,%edx
  801c86:	74 32                	je     801cba <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c88:	83 ec 08             	sub    $0x8,%esp
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	50                   	push   %eax
  801c8f:	ff d2                	call   *%edx
  801c91:	83 c4 10             	add    $0x10,%esp
}
  801c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c99:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c9e:	8b 40 48             	mov    0x48(%eax),%eax
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	53                   	push   %ebx
  801ca5:	50                   	push   %eax
  801ca6:	68 64 34 80 00       	push   $0x803464
  801cab:	e8 25 e8 ff ff       	call   8004d5 <cprintf>
		return -E_INVAL;
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cb8:	eb da                	jmp    801c94 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801cba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cbf:	eb d3                	jmp    801c94 <ftruncate+0x52>

00801cc1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	53                   	push   %ebx
  801cc5:	83 ec 1c             	sub    $0x1c,%esp
  801cc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ccb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cce:	50                   	push   %eax
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	e8 84 fb ff ff       	call   80185b <fd_lookup>
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 4b                	js     801d29 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cde:	83 ec 08             	sub    $0x8,%esp
  801ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce4:	50                   	push   %eax
  801ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce8:	ff 30                	pushl  (%eax)
  801cea:	e8 bc fb ff ff       	call   8018ab <dev_lookup>
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	78 33                	js     801d29 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cfd:	74 2f                	je     801d2e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cff:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d02:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d09:	00 00 00 
	stat->st_isdir = 0;
  801d0c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d13:	00 00 00 
	stat->st_dev = dev;
  801d16:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d1c:	83 ec 08             	sub    $0x8,%esp
  801d1f:	53                   	push   %ebx
  801d20:	ff 75 f0             	pushl  -0x10(%ebp)
  801d23:	ff 50 14             	call   *0x14(%eax)
  801d26:	83 c4 10             	add    $0x10,%esp
}
  801d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    
		return -E_NOT_SUPP;
  801d2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d33:	eb f4                	jmp    801d29 <fstat+0x68>

00801d35 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d3a:	83 ec 08             	sub    $0x8,%esp
  801d3d:	6a 00                	push   $0x0
  801d3f:	ff 75 08             	pushl  0x8(%ebp)
  801d42:	e8 22 02 00 00       	call   801f69 <open>
  801d47:	89 c3                	mov    %eax,%ebx
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 1b                	js     801d6b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d50:	83 ec 08             	sub    $0x8,%esp
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	50                   	push   %eax
  801d57:	e8 65 ff ff ff       	call   801cc1 <fstat>
  801d5c:	89 c6                	mov    %eax,%esi
	close(fd);
  801d5e:	89 1c 24             	mov    %ebx,(%esp)
  801d61:	e8 27 fc ff ff       	call   80198d <close>
	return r;
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	89 f3                	mov    %esi,%ebx
}
  801d6b:	89 d8                	mov    %ebx,%eax
  801d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	56                   	push   %esi
  801d78:	53                   	push   %ebx
  801d79:	89 c6                	mov    %eax,%esi
  801d7b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d7d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d84:	74 27                	je     801dad <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d86:	6a 07                	push   $0x7
  801d88:	68 00 60 80 00       	push   $0x806000
  801d8d:	56                   	push   %esi
  801d8e:	ff 35 00 50 80 00    	pushl  0x805000
  801d94:	e8 ec 0c 00 00       	call   802a85 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d99:	83 c4 0c             	add    $0xc,%esp
  801d9c:	6a 00                	push   $0x0
  801d9e:	53                   	push   %ebx
  801d9f:	6a 00                	push   $0x0
  801da1:	e8 76 0c 00 00       	call   802a1c <ipc_recv>
}
  801da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da9:	5b                   	pop    %ebx
  801daa:	5e                   	pop    %esi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	6a 01                	push   $0x1
  801db2:	e8 26 0d 00 00       	call   802add <ipc_find_env>
  801db7:	a3 00 50 80 00       	mov    %eax,0x805000
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	eb c5                	jmp    801d86 <fsipc+0x12>

00801dc1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcd:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dda:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddf:	b8 02 00 00 00       	mov    $0x2,%eax
  801de4:	e8 8b ff ff ff       	call   801d74 <fsipc>
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <devfile_flush>:
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8b 40 0c             	mov    0xc(%eax),%eax
  801df7:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dfc:	ba 00 00 00 00       	mov    $0x0,%edx
  801e01:	b8 06 00 00 00       	mov    $0x6,%eax
  801e06:	e8 69 ff ff ff       	call   801d74 <fsipc>
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <devfile_stat>:
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	53                   	push   %ebx
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
  801e27:	b8 05 00 00 00       	mov    $0x5,%eax
  801e2c:	e8 43 ff ff ff       	call   801d74 <fsipc>
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 2c                	js     801e61 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e35:	83 ec 08             	sub    $0x8,%esp
  801e38:	68 00 60 80 00       	push   $0x806000
  801e3d:	53                   	push   %ebx
  801e3e:	e8 f1 ed ff ff       	call   800c34 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e43:	a1 80 60 80 00       	mov    0x806080,%eax
  801e48:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e4e:	a1 84 60 80 00       	mov    0x806084,%eax
  801e53:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <devfile_write>:
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	53                   	push   %ebx
  801e6a:	83 ec 08             	sub    $0x8,%esp
  801e6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	8b 40 0c             	mov    0xc(%eax),%eax
  801e76:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e7b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e81:	53                   	push   %ebx
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	68 08 60 80 00       	push   $0x806008
  801e8a:	e8 95 ef ff ff       	call   800e24 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e94:	b8 04 00 00 00       	mov    $0x4,%eax
  801e99:	e8 d6 fe ff ff       	call   801d74 <fsipc>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 0b                	js     801eb0 <devfile_write+0x4a>
	assert(r <= n);
  801ea5:	39 d8                	cmp    %ebx,%eax
  801ea7:	77 0c                	ja     801eb5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ea9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eae:	7f 1e                	jg     801ece <devfile_write+0x68>
}
  801eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    
	assert(r <= n);
  801eb5:	68 d4 34 80 00       	push   $0x8034d4
  801eba:	68 db 34 80 00       	push   $0x8034db
  801ebf:	68 98 00 00 00       	push   $0x98
  801ec4:	68 f0 34 80 00       	push   $0x8034f0
  801ec9:	e8 11 e5 ff ff       	call   8003df <_panic>
	assert(r <= PGSIZE);
  801ece:	68 fb 34 80 00       	push   $0x8034fb
  801ed3:	68 db 34 80 00       	push   $0x8034db
  801ed8:	68 99 00 00 00       	push   $0x99
  801edd:	68 f0 34 80 00       	push   $0x8034f0
  801ee2:	e8 f8 e4 ff ff       	call   8003df <_panic>

00801ee7 <devfile_read>:
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801efa:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f00:	ba 00 00 00 00       	mov    $0x0,%edx
  801f05:	b8 03 00 00 00       	mov    $0x3,%eax
  801f0a:	e8 65 fe ff ff       	call   801d74 <fsipc>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	85 c0                	test   %eax,%eax
  801f13:	78 1f                	js     801f34 <devfile_read+0x4d>
	assert(r <= n);
  801f15:	39 f0                	cmp    %esi,%eax
  801f17:	77 24                	ja     801f3d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f1e:	7f 33                	jg     801f53 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	50                   	push   %eax
  801f24:	68 00 60 80 00       	push   $0x806000
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	e8 91 ee ff ff       	call   800dc2 <memmove>
	return r;
  801f31:	83 c4 10             	add    $0x10,%esp
}
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5d                   	pop    %ebp
  801f3c:	c3                   	ret    
	assert(r <= n);
  801f3d:	68 d4 34 80 00       	push   $0x8034d4
  801f42:	68 db 34 80 00       	push   $0x8034db
  801f47:	6a 7c                	push   $0x7c
  801f49:	68 f0 34 80 00       	push   $0x8034f0
  801f4e:	e8 8c e4 ff ff       	call   8003df <_panic>
	assert(r <= PGSIZE);
  801f53:	68 fb 34 80 00       	push   $0x8034fb
  801f58:	68 db 34 80 00       	push   $0x8034db
  801f5d:	6a 7d                	push   $0x7d
  801f5f:	68 f0 34 80 00       	push   $0x8034f0
  801f64:	e8 76 e4 ff ff       	call   8003df <_panic>

00801f69 <open>:
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
  801f6e:	83 ec 1c             	sub    $0x1c,%esp
  801f71:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f74:	56                   	push   %esi
  801f75:	e8 81 ec ff ff       	call   800bfb <strlen>
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f82:	7f 6c                	jg     801ff0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8a:	50                   	push   %eax
  801f8b:	e8 79 f8 ff ff       	call   801809 <fd_alloc>
  801f90:	89 c3                	mov    %eax,%ebx
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 3c                	js     801fd5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f99:	83 ec 08             	sub    $0x8,%esp
  801f9c:	56                   	push   %esi
  801f9d:	68 00 60 80 00       	push   $0x806000
  801fa2:	e8 8d ec ff ff       	call   800c34 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faa:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb7:	e8 b8 fd ff ff       	call   801d74 <fsipc>
  801fbc:	89 c3                	mov    %eax,%ebx
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	78 19                	js     801fde <open+0x75>
	return fd2num(fd);
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcb:	e8 12 f8 ff ff       	call   8017e2 <fd2num>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
}
  801fd5:	89 d8                	mov    %ebx,%eax
  801fd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fda:	5b                   	pop    %ebx
  801fdb:	5e                   	pop    %esi
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    
		fd_close(fd, 0);
  801fde:	83 ec 08             	sub    $0x8,%esp
  801fe1:	6a 00                	push   $0x0
  801fe3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe6:	e8 1b f9 ff ff       	call   801906 <fd_close>
		return r;
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	eb e5                	jmp    801fd5 <open+0x6c>
		return -E_BAD_PATH;
  801ff0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ff5:	eb de                	jmp    801fd5 <open+0x6c>

00801ff7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ffd:	ba 00 00 00 00       	mov    $0x0,%edx
  802002:	b8 08 00 00 00       	mov    $0x8,%eax
  802007:	e8 68 fd ff ff       	call   801d74 <fsipc>
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802014:	68 07 35 80 00       	push   $0x803507
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	e8 13 ec ff ff       	call   800c34 <strcpy>
	return 0;
}
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <devsock_close>:
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	53                   	push   %ebx
  80202c:	83 ec 10             	sub    $0x10,%esp
  80202f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802032:	53                   	push   %ebx
  802033:	e8 e0 0a 00 00       	call   802b18 <pageref>
  802038:	83 c4 10             	add    $0x10,%esp
		return 0;
  80203b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802040:	83 f8 01             	cmp    $0x1,%eax
  802043:	74 07                	je     80204c <devsock_close+0x24>
}
  802045:	89 d0                	mov    %edx,%eax
  802047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	ff 73 0c             	pushl  0xc(%ebx)
  802052:	e8 b9 02 00 00       	call   802310 <nsipc_close>
  802057:	89 c2                	mov    %eax,%edx
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	eb e7                	jmp    802045 <devsock_close+0x1d>

0080205e <devsock_write>:
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802064:	6a 00                	push   $0x0
  802066:	ff 75 10             	pushl  0x10(%ebp)
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	ff 70 0c             	pushl  0xc(%eax)
  802072:	e8 76 03 00 00       	call   8023ed <nsipc_send>
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <devsock_read>:
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80207f:	6a 00                	push   $0x0
  802081:	ff 75 10             	pushl  0x10(%ebp)
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	ff 70 0c             	pushl  0xc(%eax)
  80208d:	e8 ef 02 00 00       	call   802381 <nsipc_recv>
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <fd2sockid>:
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80209a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80209d:	52                   	push   %edx
  80209e:	50                   	push   %eax
  80209f:	e8 b7 f7 ff ff       	call   80185b <fd_lookup>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	78 10                	js     8020bb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8020b4:	39 08                	cmp    %ecx,(%eax)
  8020b6:	75 05                	jne    8020bd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020b8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    
		return -E_NOT_SUPP;
  8020bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020c2:	eb f7                	jmp    8020bb <fd2sockid+0x27>

008020c4 <alloc_sockfd>:
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 1c             	sub    $0x1c,%esp
  8020cc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d1:	50                   	push   %eax
  8020d2:	e8 32 f7 ff ff       	call   801809 <fd_alloc>
  8020d7:	89 c3                	mov    %eax,%ebx
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 43                	js     802123 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	68 07 04 00 00       	push   $0x407
  8020e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020eb:	6a 00                	push   $0x0
  8020ed:	e8 34 ef ff ff       	call   801026 <sys_page_alloc>
  8020f2:	89 c3                	mov    %eax,%ebx
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	78 28                	js     802123 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802104:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802110:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	50                   	push   %eax
  802117:	e8 c6 f6 ff ff       	call   8017e2 <fd2num>
  80211c:	89 c3                	mov    %eax,%ebx
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	eb 0c                	jmp    80212f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	56                   	push   %esi
  802127:	e8 e4 01 00 00       	call   802310 <nsipc_close>
		return r;
  80212c:	83 c4 10             	add    $0x10,%esp
}
  80212f:	89 d8                	mov    %ebx,%eax
  802131:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <accept>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	e8 4e ff ff ff       	call   802094 <fd2sockid>
  802146:	85 c0                	test   %eax,%eax
  802148:	78 1b                	js     802165 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	ff 75 10             	pushl  0x10(%ebp)
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	50                   	push   %eax
  802154:	e8 0e 01 00 00       	call   802267 <nsipc_accept>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 05                	js     802165 <accept+0x2d>
	return alloc_sockfd(r);
  802160:	e8 5f ff ff ff       	call   8020c4 <alloc_sockfd>
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <bind>:
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	e8 1f ff ff ff       	call   802094 <fd2sockid>
  802175:	85 c0                	test   %eax,%eax
  802177:	78 12                	js     80218b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	ff 75 10             	pushl  0x10(%ebp)
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	50                   	push   %eax
  802183:	e8 31 01 00 00       	call   8022b9 <nsipc_bind>
  802188:	83 c4 10             	add    $0x10,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <shutdown>:
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	e8 f9 fe ff ff       	call   802094 <fd2sockid>
  80219b:	85 c0                	test   %eax,%eax
  80219d:	78 0f                	js     8021ae <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80219f:	83 ec 08             	sub    $0x8,%esp
  8021a2:	ff 75 0c             	pushl  0xc(%ebp)
  8021a5:	50                   	push   %eax
  8021a6:	e8 43 01 00 00       	call   8022ee <nsipc_shutdown>
  8021ab:	83 c4 10             	add    $0x10,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <connect>:
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	e8 d6 fe ff ff       	call   802094 <fd2sockid>
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 12                	js     8021d4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	ff 75 10             	pushl  0x10(%ebp)
  8021c8:	ff 75 0c             	pushl  0xc(%ebp)
  8021cb:	50                   	push   %eax
  8021cc:	e8 59 01 00 00       	call   80232a <nsipc_connect>
  8021d1:	83 c4 10             	add    $0x10,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <listen>:
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	e8 b0 fe ff ff       	call   802094 <fd2sockid>
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 0f                	js     8021f7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8021e8:	83 ec 08             	sub    $0x8,%esp
  8021eb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ee:	50                   	push   %eax
  8021ef:	e8 6b 01 00 00       	call   80235f <nsipc_listen>
  8021f4:	83 c4 10             	add    $0x10,%esp
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	e8 3e 02 00 00       	call   80244b <nsipc_socket>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	85 c0                	test   %eax,%eax
  802212:	78 05                	js     802219 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802214:	e8 ab fe ff ff       	call   8020c4 <alloc_sockfd>
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802224:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80222b:	74 26                	je     802253 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80222d:	6a 07                	push   $0x7
  80222f:	68 00 70 80 00       	push   $0x807000
  802234:	53                   	push   %ebx
  802235:	ff 35 04 50 80 00    	pushl  0x805004
  80223b:	e8 45 08 00 00       	call   802a85 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802240:	83 c4 0c             	add    $0xc,%esp
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	e8 ce 07 00 00       	call   802a1c <ipc_recv>
}
  80224e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802251:	c9                   	leave  
  802252:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	6a 02                	push   $0x2
  802258:	e8 80 08 00 00       	call   802add <ipc_find_env>
  80225d:	a3 04 50 80 00       	mov    %eax,0x805004
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	eb c6                	jmp    80222d <nsipc+0x12>

00802267 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	56                   	push   %esi
  80226b:	53                   	push   %ebx
  80226c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802277:	8b 06                	mov    (%esi),%eax
  802279:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	e8 93 ff ff ff       	call   80221b <nsipc>
  802288:	89 c3                	mov    %eax,%ebx
  80228a:	85 c0                	test   %eax,%eax
  80228c:	79 09                	jns    802297 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80228e:	89 d8                	mov    %ebx,%eax
  802290:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	ff 35 10 70 80 00    	pushl  0x807010
  8022a0:	68 00 70 80 00       	push   $0x807000
  8022a5:	ff 75 0c             	pushl  0xc(%ebp)
  8022a8:	e8 15 eb ff ff       	call   800dc2 <memmove>
		*addrlen = ret->ret_addrlen;
  8022ad:	a1 10 70 80 00       	mov    0x807010,%eax
  8022b2:	89 06                	mov    %eax,(%esi)
  8022b4:	83 c4 10             	add    $0x10,%esp
	return r;
  8022b7:	eb d5                	jmp    80228e <nsipc_accept+0x27>

008022b9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	53                   	push   %ebx
  8022bd:	83 ec 08             	sub    $0x8,%esp
  8022c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022cb:	53                   	push   %ebx
  8022cc:	ff 75 0c             	pushl  0xc(%ebp)
  8022cf:	68 04 70 80 00       	push   $0x807004
  8022d4:	e8 e9 ea ff ff       	call   800dc2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022d9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022df:	b8 02 00 00 00       	mov    $0x2,%eax
  8022e4:	e8 32 ff ff ff       	call   80221b <nsipc>
}
  8022e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802304:	b8 03 00 00 00       	mov    $0x3,%eax
  802309:	e8 0d ff ff ff       	call   80221b <nsipc>
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <nsipc_close>:

int
nsipc_close(int s)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80231e:	b8 04 00 00 00       	mov    $0x4,%eax
  802323:	e8 f3 fe ff ff       	call   80221b <nsipc>
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	53                   	push   %ebx
  80232e:	83 ec 08             	sub    $0x8,%esp
  802331:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80233c:	53                   	push   %ebx
  80233d:	ff 75 0c             	pushl  0xc(%ebp)
  802340:	68 04 70 80 00       	push   $0x807004
  802345:	e8 78 ea ff ff       	call   800dc2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80234a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802350:	b8 05 00 00 00       	mov    $0x5,%eax
  802355:	e8 c1 fe ff ff       	call   80221b <nsipc>
}
  80235a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802375:	b8 06 00 00 00       	mov    $0x6,%eax
  80237a:	e8 9c fe ff ff       	call   80221b <nsipc>
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	56                   	push   %esi
  802385:	53                   	push   %ebx
  802386:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802391:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802397:	8b 45 14             	mov    0x14(%ebp),%eax
  80239a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80239f:	b8 07 00 00 00       	mov    $0x7,%eax
  8023a4:	e8 72 fe ff ff       	call   80221b <nsipc>
  8023a9:	89 c3                	mov    %eax,%ebx
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	78 1f                	js     8023ce <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023af:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023b4:	7f 21                	jg     8023d7 <nsipc_recv+0x56>
  8023b6:	39 c6                	cmp    %eax,%esi
  8023b8:	7c 1d                	jl     8023d7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	50                   	push   %eax
  8023be:	68 00 70 80 00       	push   $0x807000
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	e8 f7 e9 ff ff       	call   800dc2 <memmove>
  8023cb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023ce:	89 d8                	mov    %ebx,%eax
  8023d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5d                   	pop    %ebp
  8023d6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023d7:	68 13 35 80 00       	push   $0x803513
  8023dc:	68 db 34 80 00       	push   $0x8034db
  8023e1:	6a 62                	push   $0x62
  8023e3:	68 28 35 80 00       	push   $0x803528
  8023e8:	e8 f2 df ff ff       	call   8003df <_panic>

008023ed <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	53                   	push   %ebx
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023ff:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802405:	7f 2e                	jg     802435 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	53                   	push   %ebx
  80240b:	ff 75 0c             	pushl  0xc(%ebp)
  80240e:	68 0c 70 80 00       	push   $0x80700c
  802413:	e8 aa e9 ff ff       	call   800dc2 <memmove>
	nsipcbuf.send.req_size = size;
  802418:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80241e:	8b 45 14             	mov    0x14(%ebp),%eax
  802421:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802426:	b8 08 00 00 00       	mov    $0x8,%eax
  80242b:	e8 eb fd ff ff       	call   80221b <nsipc>
}
  802430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802433:	c9                   	leave  
  802434:	c3                   	ret    
	assert(size < 1600);
  802435:	68 34 35 80 00       	push   $0x803534
  80243a:	68 db 34 80 00       	push   $0x8034db
  80243f:	6a 6d                	push   $0x6d
  802441:	68 28 35 80 00       	push   $0x803528
  802446:	e8 94 df ff ff       	call   8003df <_panic>

0080244b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802461:	8b 45 10             	mov    0x10(%ebp),%eax
  802464:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802469:	b8 09 00 00 00       	mov    $0x9,%eax
  80246e:	e8 a8 fd ff ff       	call   80221b <nsipc>
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	ff 75 08             	pushl  0x8(%ebp)
  802483:	e8 6a f3 ff ff       	call   8017f2 <fd2data>
  802488:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80248a:	83 c4 08             	add    $0x8,%esp
  80248d:	68 40 35 80 00       	push   $0x803540
  802492:	53                   	push   %ebx
  802493:	e8 9c e7 ff ff       	call   800c34 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802498:	8b 46 04             	mov    0x4(%esi),%eax
  80249b:	2b 06                	sub    (%esi),%eax
  80249d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024aa:	00 00 00 
	stat->st_dev = &devpipe;
  8024ad:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8024b4:	40 80 00 
	return 0;
}
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    

008024c3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	53                   	push   %ebx
  8024c7:	83 ec 0c             	sub    $0xc,%esp
  8024ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024cd:	53                   	push   %ebx
  8024ce:	6a 00                	push   $0x0
  8024d0:	e8 d6 eb ff ff       	call   8010ab <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024d5:	89 1c 24             	mov    %ebx,(%esp)
  8024d8:	e8 15 f3 ff ff       	call   8017f2 <fd2data>
  8024dd:	83 c4 08             	add    $0x8,%esp
  8024e0:	50                   	push   %eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	e8 c3 eb ff ff       	call   8010ab <sys_page_unmap>
}
  8024e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <_pipeisclosed>:
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	57                   	push   %edi
  8024f1:	56                   	push   %esi
  8024f2:	53                   	push   %ebx
  8024f3:	83 ec 1c             	sub    $0x1c,%esp
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8024ff:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	57                   	push   %edi
  802506:	e8 0d 06 00 00       	call   802b18 <pageref>
  80250b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80250e:	89 34 24             	mov    %esi,(%esp)
  802511:	e8 02 06 00 00       	call   802b18 <pageref>
		nn = thisenv->env_runs;
  802516:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80251c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	39 cb                	cmp    %ecx,%ebx
  802524:	74 1b                	je     802541 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802526:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802529:	75 cf                	jne    8024fa <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80252b:	8b 42 58             	mov    0x58(%edx),%eax
  80252e:	6a 01                	push   $0x1
  802530:	50                   	push   %eax
  802531:	53                   	push   %ebx
  802532:	68 47 35 80 00       	push   $0x803547
  802537:	e8 99 df ff ff       	call   8004d5 <cprintf>
  80253c:	83 c4 10             	add    $0x10,%esp
  80253f:	eb b9                	jmp    8024fa <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802541:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802544:	0f 94 c0             	sete   %al
  802547:	0f b6 c0             	movzbl %al,%eax
}
  80254a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <devpipe_write>:
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	57                   	push   %edi
  802556:	56                   	push   %esi
  802557:	53                   	push   %ebx
  802558:	83 ec 28             	sub    $0x28,%esp
  80255b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80255e:	56                   	push   %esi
  80255f:	e8 8e f2 ff ff       	call   8017f2 <fd2data>
  802564:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	bf 00 00 00 00       	mov    $0x0,%edi
  80256e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802571:	74 4f                	je     8025c2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802573:	8b 43 04             	mov    0x4(%ebx),%eax
  802576:	8b 0b                	mov    (%ebx),%ecx
  802578:	8d 51 20             	lea    0x20(%ecx),%edx
  80257b:	39 d0                	cmp    %edx,%eax
  80257d:	72 14                	jb     802593 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80257f:	89 da                	mov    %ebx,%edx
  802581:	89 f0                	mov    %esi,%eax
  802583:	e8 65 ff ff ff       	call   8024ed <_pipeisclosed>
  802588:	85 c0                	test   %eax,%eax
  80258a:	75 3b                	jne    8025c7 <devpipe_write+0x75>
			sys_yield();
  80258c:	e8 76 ea ff ff       	call   801007 <sys_yield>
  802591:	eb e0                	jmp    802573 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802593:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802596:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80259a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80259d:	89 c2                	mov    %eax,%edx
  80259f:	c1 fa 1f             	sar    $0x1f,%edx
  8025a2:	89 d1                	mov    %edx,%ecx
  8025a4:	c1 e9 1b             	shr    $0x1b,%ecx
  8025a7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025aa:	83 e2 1f             	and    $0x1f,%edx
  8025ad:	29 ca                	sub    %ecx,%edx
  8025af:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025b7:	83 c0 01             	add    $0x1,%eax
  8025ba:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025bd:	83 c7 01             	add    $0x1,%edi
  8025c0:	eb ac                	jmp    80256e <devpipe_write+0x1c>
	return i;
  8025c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c5:	eb 05                	jmp    8025cc <devpipe_write+0x7a>
				return 0;
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <devpipe_read>:
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	57                   	push   %edi
  8025d8:	56                   	push   %esi
  8025d9:	53                   	push   %ebx
  8025da:	83 ec 18             	sub    $0x18,%esp
  8025dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025e0:	57                   	push   %edi
  8025e1:	e8 0c f2 ff ff       	call   8017f2 <fd2data>
  8025e6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	be 00 00 00 00       	mov    $0x0,%esi
  8025f0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025f3:	75 14                	jne    802609 <devpipe_read+0x35>
	return i;
  8025f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f8:	eb 02                	jmp    8025fc <devpipe_read+0x28>
				return i;
  8025fa:	89 f0                	mov    %esi,%eax
}
  8025fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ff:	5b                   	pop    %ebx
  802600:	5e                   	pop    %esi
  802601:	5f                   	pop    %edi
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    
			sys_yield();
  802604:	e8 fe e9 ff ff       	call   801007 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802609:	8b 03                	mov    (%ebx),%eax
  80260b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80260e:	75 18                	jne    802628 <devpipe_read+0x54>
			if (i > 0)
  802610:	85 f6                	test   %esi,%esi
  802612:	75 e6                	jne    8025fa <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802614:	89 da                	mov    %ebx,%edx
  802616:	89 f8                	mov    %edi,%eax
  802618:	e8 d0 fe ff ff       	call   8024ed <_pipeisclosed>
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 e3                	je     802604 <devpipe_read+0x30>
				return 0;
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
  802626:	eb d4                	jmp    8025fc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802628:	99                   	cltd   
  802629:	c1 ea 1b             	shr    $0x1b,%edx
  80262c:	01 d0                	add    %edx,%eax
  80262e:	83 e0 1f             	and    $0x1f,%eax
  802631:	29 d0                	sub    %edx,%eax
  802633:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80263b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80263e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802641:	83 c6 01             	add    $0x1,%esi
  802644:	eb aa                	jmp    8025f0 <devpipe_read+0x1c>

00802646 <pipe>:
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	56                   	push   %esi
  80264a:	53                   	push   %ebx
  80264b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80264e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802651:	50                   	push   %eax
  802652:	e8 b2 f1 ff ff       	call   801809 <fd_alloc>
  802657:	89 c3                	mov    %eax,%ebx
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	85 c0                	test   %eax,%eax
  80265e:	0f 88 23 01 00 00    	js     802787 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 07 04 00 00       	push   $0x407
  80266c:	ff 75 f4             	pushl  -0xc(%ebp)
  80266f:	6a 00                	push   $0x0
  802671:	e8 b0 e9 ff ff       	call   801026 <sys_page_alloc>
  802676:	89 c3                	mov    %eax,%ebx
  802678:	83 c4 10             	add    $0x10,%esp
  80267b:	85 c0                	test   %eax,%eax
  80267d:	0f 88 04 01 00 00    	js     802787 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802689:	50                   	push   %eax
  80268a:	e8 7a f1 ff ff       	call   801809 <fd_alloc>
  80268f:	89 c3                	mov    %eax,%ebx
  802691:	83 c4 10             	add    $0x10,%esp
  802694:	85 c0                	test   %eax,%eax
  802696:	0f 88 db 00 00 00    	js     802777 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	68 07 04 00 00       	push   $0x407
  8026a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a7:	6a 00                	push   $0x0
  8026a9:	e8 78 e9 ff ff       	call   801026 <sys_page_alloc>
  8026ae:	89 c3                	mov    %eax,%ebx
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	0f 88 bc 00 00 00    	js     802777 <pipe+0x131>
	va = fd2data(fd0);
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c1:	e8 2c f1 ff ff       	call   8017f2 <fd2data>
  8026c6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026c8:	83 c4 0c             	add    $0xc,%esp
  8026cb:	68 07 04 00 00       	push   $0x407
  8026d0:	50                   	push   %eax
  8026d1:	6a 00                	push   $0x0
  8026d3:	e8 4e e9 ff ff       	call   801026 <sys_page_alloc>
  8026d8:	89 c3                	mov    %eax,%ebx
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	0f 88 82 00 00 00    	js     802767 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026eb:	e8 02 f1 ff ff       	call   8017f2 <fd2data>
  8026f0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026f7:	50                   	push   %eax
  8026f8:	6a 00                	push   $0x0
  8026fa:	56                   	push   %esi
  8026fb:	6a 00                	push   $0x0
  8026fd:	e8 67 e9 ff ff       	call   801069 <sys_page_map>
  802702:	89 c3                	mov    %eax,%ebx
  802704:	83 c4 20             	add    $0x20,%esp
  802707:	85 c0                	test   %eax,%eax
  802709:	78 4e                	js     802759 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80270b:	a1 40 40 80 00       	mov    0x804040,%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802718:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80271f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802722:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	ff 75 f4             	pushl  -0xc(%ebp)
  802734:	e8 a9 f0 ff ff       	call   8017e2 <fd2num>
  802739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80273c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80273e:	83 c4 04             	add    $0x4,%esp
  802741:	ff 75 f0             	pushl  -0x10(%ebp)
  802744:	e8 99 f0 ff ff       	call   8017e2 <fd2num>
  802749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80274c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	bb 00 00 00 00       	mov    $0x0,%ebx
  802757:	eb 2e                	jmp    802787 <pipe+0x141>
	sys_page_unmap(0, va);
  802759:	83 ec 08             	sub    $0x8,%esp
  80275c:	56                   	push   %esi
  80275d:	6a 00                	push   $0x0
  80275f:	e8 47 e9 ff ff       	call   8010ab <sys_page_unmap>
  802764:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802767:	83 ec 08             	sub    $0x8,%esp
  80276a:	ff 75 f0             	pushl  -0x10(%ebp)
  80276d:	6a 00                	push   $0x0
  80276f:	e8 37 e9 ff ff       	call   8010ab <sys_page_unmap>
  802774:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802777:	83 ec 08             	sub    $0x8,%esp
  80277a:	ff 75 f4             	pushl  -0xc(%ebp)
  80277d:	6a 00                	push   $0x0
  80277f:	e8 27 e9 ff ff       	call   8010ab <sys_page_unmap>
  802784:	83 c4 10             	add    $0x10,%esp
}
  802787:	89 d8                	mov    %ebx,%eax
  802789:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80278c:	5b                   	pop    %ebx
  80278d:	5e                   	pop    %esi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    

00802790 <pipeisclosed>:
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802796:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802799:	50                   	push   %eax
  80279a:	ff 75 08             	pushl  0x8(%ebp)
  80279d:	e8 b9 f0 ff ff       	call   80185b <fd_lookup>
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	78 18                	js     8027c1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8027af:	e8 3e f0 ff ff       	call   8017f2 <fd2data>
	return _pipeisclosed(fd, p);
  8027b4:	89 c2                	mov    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	e8 2f fd ff ff       	call   8024ed <_pipeisclosed>
  8027be:	83 c4 10             	add    $0x10,%esp
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	56                   	push   %esi
  8027c7:	53                   	push   %ebx
  8027c8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8027cb:	85 f6                	test   %esi,%esi
  8027cd:	74 13                	je     8027e2 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8027cf:	89 f3                	mov    %esi,%ebx
  8027d1:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027d7:	c1 e3 07             	shl    $0x7,%ebx
  8027da:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8027e0:	eb 1b                	jmp    8027fd <wait+0x3a>
	assert(envid != 0);
  8027e2:	68 5f 35 80 00       	push   $0x80355f
  8027e7:	68 db 34 80 00       	push   $0x8034db
  8027ec:	6a 09                	push   $0x9
  8027ee:	68 6a 35 80 00       	push   $0x80356a
  8027f3:	e8 e7 db ff ff       	call   8003df <_panic>
		sys_yield();
  8027f8:	e8 0a e8 ff ff       	call   801007 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027fd:	8b 43 48             	mov    0x48(%ebx),%eax
  802800:	39 f0                	cmp    %esi,%eax
  802802:	75 07                	jne    80280b <wait+0x48>
  802804:	8b 43 54             	mov    0x54(%ebx),%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	75 ed                	jne    8027f8 <wait+0x35>
}
  80280b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80280e:	5b                   	pop    %ebx
  80280f:	5e                   	pop    %esi
  802810:	5d                   	pop    %ebp
  802811:	c3                   	ret    

00802812 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
  802817:	c3                   	ret    

00802818 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80281e:	68 75 35 80 00       	push   $0x803575
  802823:	ff 75 0c             	pushl  0xc(%ebp)
  802826:	e8 09 e4 ff ff       	call   800c34 <strcpy>
	return 0;
}
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	c9                   	leave  
  802831:	c3                   	ret    

00802832 <devcons_write>:
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
  802838:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80283e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802843:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802849:	3b 75 10             	cmp    0x10(%ebp),%esi
  80284c:	73 31                	jae    80287f <devcons_write+0x4d>
		m = n - tot;
  80284e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802851:	29 f3                	sub    %esi,%ebx
  802853:	83 fb 7f             	cmp    $0x7f,%ebx
  802856:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80285b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80285e:	83 ec 04             	sub    $0x4,%esp
  802861:	53                   	push   %ebx
  802862:	89 f0                	mov    %esi,%eax
  802864:	03 45 0c             	add    0xc(%ebp),%eax
  802867:	50                   	push   %eax
  802868:	57                   	push   %edi
  802869:	e8 54 e5 ff ff       	call   800dc2 <memmove>
		sys_cputs(buf, m);
  80286e:	83 c4 08             	add    $0x8,%esp
  802871:	53                   	push   %ebx
  802872:	57                   	push   %edi
  802873:	e8 f2 e6 ff ff       	call   800f6a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802878:	01 de                	add    %ebx,%esi
  80287a:	83 c4 10             	add    $0x10,%esp
  80287d:	eb ca                	jmp    802849 <devcons_write+0x17>
}
  80287f:	89 f0                	mov    %esi,%eax
  802881:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802884:	5b                   	pop    %ebx
  802885:	5e                   	pop    %esi
  802886:	5f                   	pop    %edi
  802887:	5d                   	pop    %ebp
  802888:	c3                   	ret    

00802889 <devcons_read>:
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	83 ec 08             	sub    $0x8,%esp
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802894:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802898:	74 21                	je     8028bb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80289a:	e8 e9 e6 ff ff       	call   800f88 <sys_cgetc>
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	75 07                	jne    8028aa <devcons_read+0x21>
		sys_yield();
  8028a3:	e8 5f e7 ff ff       	call   801007 <sys_yield>
  8028a8:	eb f0                	jmp    80289a <devcons_read+0x11>
	if (c < 0)
  8028aa:	78 0f                	js     8028bb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028ac:	83 f8 04             	cmp    $0x4,%eax
  8028af:	74 0c                	je     8028bd <devcons_read+0x34>
	*(char*)vbuf = c;
  8028b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b4:	88 02                	mov    %al,(%edx)
	return 1;
  8028b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    
		return 0;
  8028bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c2:	eb f7                	jmp    8028bb <devcons_read+0x32>

008028c4 <cputchar>:
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028d0:	6a 01                	push   $0x1
  8028d2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028d5:	50                   	push   %eax
  8028d6:	e8 8f e6 ff ff       	call   800f6a <sys_cputs>
}
  8028db:	83 c4 10             	add    $0x10,%esp
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <getchar>:
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028e6:	6a 01                	push   $0x1
  8028e8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028eb:	50                   	push   %eax
  8028ec:	6a 00                	push   $0x0
  8028ee:	e8 d8 f1 ff ff       	call   801acb <read>
	if (r < 0)
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	78 06                	js     802900 <getchar+0x20>
	if (r < 1)
  8028fa:	74 06                	je     802902 <getchar+0x22>
	return c;
  8028fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    
		return -E_EOF;
  802902:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802907:	eb f7                	jmp    802900 <getchar+0x20>

00802909 <iscons>:
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80290f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802912:	50                   	push   %eax
  802913:	ff 75 08             	pushl  0x8(%ebp)
  802916:	e8 40 ef ff ff       	call   80185b <fd_lookup>
  80291b:	83 c4 10             	add    $0x10,%esp
  80291e:	85 c0                	test   %eax,%eax
  802920:	78 11                	js     802933 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80292b:	39 10                	cmp    %edx,(%eax)
  80292d:	0f 94 c0             	sete   %al
  802930:	0f b6 c0             	movzbl %al,%eax
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <opencons>:
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80293b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80293e:	50                   	push   %eax
  80293f:	e8 c5 ee ff ff       	call   801809 <fd_alloc>
  802944:	83 c4 10             	add    $0x10,%esp
  802947:	85 c0                	test   %eax,%eax
  802949:	78 3a                	js     802985 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 07 04 00 00       	push   $0x407
  802953:	ff 75 f4             	pushl  -0xc(%ebp)
  802956:	6a 00                	push   $0x0
  802958:	e8 c9 e6 ff ff       	call   801026 <sys_page_alloc>
  80295d:	83 c4 10             	add    $0x10,%esp
  802960:	85 c0                	test   %eax,%eax
  802962:	78 21                	js     802985 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80296d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802979:	83 ec 0c             	sub    $0xc,%esp
  80297c:	50                   	push   %eax
  80297d:	e8 60 ee ff ff       	call   8017e2 <fd2num>
  802982:	83 c4 10             	add    $0x10,%esp
}
  802985:	c9                   	leave  
  802986:	c3                   	ret    

00802987 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802987:	55                   	push   %ebp
  802988:	89 e5                	mov    %esp,%ebp
  80298a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80298d:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802994:	74 0a                	je     8029a0 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029a0:	83 ec 04             	sub    $0x4,%esp
  8029a3:	6a 07                	push   $0x7
  8029a5:	68 00 f0 bf ee       	push   $0xeebff000
  8029aa:	6a 00                	push   $0x0
  8029ac:	e8 75 e6 ff ff       	call   801026 <sys_page_alloc>
		if(r < 0)
  8029b1:	83 c4 10             	add    $0x10,%esp
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	78 2a                	js     8029e2 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029b8:	83 ec 08             	sub    $0x8,%esp
  8029bb:	68 f6 29 80 00       	push   $0x8029f6
  8029c0:	6a 00                	push   $0x0
  8029c2:	e8 aa e7 ff ff       	call   801171 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029c7:	83 c4 10             	add    $0x10,%esp
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	79 c8                	jns    802996 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8029ce:	83 ec 04             	sub    $0x4,%esp
  8029d1:	68 b4 35 80 00       	push   $0x8035b4
  8029d6:	6a 25                	push   $0x25
  8029d8:	68 f0 35 80 00       	push   $0x8035f0
  8029dd:	e8 fd d9 ff ff       	call   8003df <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 84 35 80 00       	push   $0x803584
  8029ea:	6a 22                	push   $0x22
  8029ec:	68 f0 35 80 00       	push   $0x8035f0
  8029f1:	e8 e9 d9 ff ff       	call   8003df <_panic>

008029f6 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029f6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029f7:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029fc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029fe:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a01:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a05:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a09:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a0c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a0e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a12:	83 c4 08             	add    $0x8,%esp
	popal
  802a15:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a16:	83 c4 04             	add    $0x4,%esp
	popfl
  802a19:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a1a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a1b:	c3                   	ret    

00802a1c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	56                   	push   %esi
  802a20:	53                   	push   %ebx
  802a21:	8b 75 08             	mov    0x8(%ebp),%esi
  802a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802a2a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802a2c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a31:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a34:	83 ec 0c             	sub    $0xc,%esp
  802a37:	50                   	push   %eax
  802a38:	e8 99 e7 ff ff       	call   8011d6 <sys_ipc_recv>
	if(ret < 0){
  802a3d:	83 c4 10             	add    $0x10,%esp
  802a40:	85 c0                	test   %eax,%eax
  802a42:	78 2b                	js     802a6f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a44:	85 f6                	test   %esi,%esi
  802a46:	74 0a                	je     802a52 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802a48:	a1 08 50 80 00       	mov    0x805008,%eax
  802a4d:	8b 40 74             	mov    0x74(%eax),%eax
  802a50:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a52:	85 db                	test   %ebx,%ebx
  802a54:	74 0a                	je     802a60 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802a56:	a1 08 50 80 00       	mov    0x805008,%eax
  802a5b:	8b 40 78             	mov    0x78(%eax),%eax
  802a5e:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802a60:	a1 08 50 80 00       	mov    0x805008,%eax
  802a65:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5d                   	pop    %ebp
  802a6e:	c3                   	ret    
		if(from_env_store)
  802a6f:	85 f6                	test   %esi,%esi
  802a71:	74 06                	je     802a79 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a73:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a79:	85 db                	test   %ebx,%ebx
  802a7b:	74 eb                	je     802a68 <ipc_recv+0x4c>
			*perm_store = 0;
  802a7d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a83:	eb e3                	jmp    802a68 <ipc_recv+0x4c>

00802a85 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
  802a88:	57                   	push   %edi
  802a89:	56                   	push   %esi
  802a8a:	53                   	push   %ebx
  802a8b:	83 ec 0c             	sub    $0xc,%esp
  802a8e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a97:	85 db                	test   %ebx,%ebx
  802a99:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a9e:	0f 44 d8             	cmove  %eax,%ebx
  802aa1:	eb 05                	jmp    802aa8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802aa3:	e8 5f e5 ff ff       	call   801007 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802aa8:	ff 75 14             	pushl  0x14(%ebp)
  802aab:	53                   	push   %ebx
  802aac:	56                   	push   %esi
  802aad:	57                   	push   %edi
  802aae:	e8 00 e7 ff ff       	call   8011b3 <sys_ipc_try_send>
  802ab3:	83 c4 10             	add    $0x10,%esp
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	74 1b                	je     802ad5 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802aba:	79 e7                	jns    802aa3 <ipc_send+0x1e>
  802abc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802abf:	74 e2                	je     802aa3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802ac1:	83 ec 04             	sub    $0x4,%esp
  802ac4:	68 fe 35 80 00       	push   $0x8035fe
  802ac9:	6a 4a                	push   $0x4a
  802acb:	68 13 36 80 00       	push   $0x803613
  802ad0:	e8 0a d9 ff ff       	call   8003df <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ad8:	5b                   	pop    %ebx
  802ad9:	5e                   	pop    %esi
  802ada:	5f                   	pop    %edi
  802adb:	5d                   	pop    %ebp
  802adc:	c3                   	ret    

00802add <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
  802ae0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802ae8:	89 c2                	mov    %eax,%edx
  802aea:	c1 e2 07             	shl    $0x7,%edx
  802aed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802af3:	8b 52 50             	mov    0x50(%edx),%edx
  802af6:	39 ca                	cmp    %ecx,%edx
  802af8:	74 11                	je     802b0b <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802afa:	83 c0 01             	add    $0x1,%eax
  802afd:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b02:	75 e4                	jne    802ae8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	eb 0b                	jmp    802b16 <ipc_find_env+0x39>
			return envs[i].env_id;
  802b0b:	c1 e0 07             	shl    $0x7,%eax
  802b0e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b13:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b16:	5d                   	pop    %ebp
  802b17:	c3                   	ret    

00802b18 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
  802b1b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b1e:	89 d0                	mov    %edx,%eax
  802b20:	c1 e8 16             	shr    $0x16,%eax
  802b23:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b2a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b2f:	f6 c1 01             	test   $0x1,%cl
  802b32:	74 1d                	je     802b51 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b34:	c1 ea 0c             	shr    $0xc,%edx
  802b37:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b3e:	f6 c2 01             	test   $0x1,%dl
  802b41:	74 0e                	je     802b51 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b43:	c1 ea 0c             	shr    $0xc,%edx
  802b46:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b4d:	ef 
  802b4e:	0f b7 c0             	movzwl %ax,%eax
}
  802b51:	5d                   	pop    %ebp
  802b52:	c3                   	ret    
  802b53:	66 90                	xchg   %ax,%ax
  802b55:	66 90                	xchg   %ax,%ax
  802b57:	66 90                	xchg   %ax,%ax
  802b59:	66 90                	xchg   %ax,%ax
  802b5b:	66 90                	xchg   %ax,%ax
  802b5d:	66 90                	xchg   %ax,%ax
  802b5f:	90                   	nop

00802b60 <__udivdi3>:
  802b60:	55                   	push   %ebp
  802b61:	57                   	push   %edi
  802b62:	56                   	push   %esi
  802b63:	53                   	push   %ebx
  802b64:	83 ec 1c             	sub    $0x1c,%esp
  802b67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b77:	85 d2                	test   %edx,%edx
  802b79:	75 4d                	jne    802bc8 <__udivdi3+0x68>
  802b7b:	39 f3                	cmp    %esi,%ebx
  802b7d:	76 19                	jbe    802b98 <__udivdi3+0x38>
  802b7f:	31 ff                	xor    %edi,%edi
  802b81:	89 e8                	mov    %ebp,%eax
  802b83:	89 f2                	mov    %esi,%edx
  802b85:	f7 f3                	div    %ebx
  802b87:	89 fa                	mov    %edi,%edx
  802b89:	83 c4 1c             	add    $0x1c,%esp
  802b8c:	5b                   	pop    %ebx
  802b8d:	5e                   	pop    %esi
  802b8e:	5f                   	pop    %edi
  802b8f:	5d                   	pop    %ebp
  802b90:	c3                   	ret    
  802b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b98:	89 d9                	mov    %ebx,%ecx
  802b9a:	85 db                	test   %ebx,%ebx
  802b9c:	75 0b                	jne    802ba9 <__udivdi3+0x49>
  802b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba3:	31 d2                	xor    %edx,%edx
  802ba5:	f7 f3                	div    %ebx
  802ba7:	89 c1                	mov    %eax,%ecx
  802ba9:	31 d2                	xor    %edx,%edx
  802bab:	89 f0                	mov    %esi,%eax
  802bad:	f7 f1                	div    %ecx
  802baf:	89 c6                	mov    %eax,%esi
  802bb1:	89 e8                	mov    %ebp,%eax
  802bb3:	89 f7                	mov    %esi,%edi
  802bb5:	f7 f1                	div    %ecx
  802bb7:	89 fa                	mov    %edi,%edx
  802bb9:	83 c4 1c             	add    $0x1c,%esp
  802bbc:	5b                   	pop    %ebx
  802bbd:	5e                   	pop    %esi
  802bbe:	5f                   	pop    %edi
  802bbf:	5d                   	pop    %ebp
  802bc0:	c3                   	ret    
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	39 f2                	cmp    %esi,%edx
  802bca:	77 1c                	ja     802be8 <__udivdi3+0x88>
  802bcc:	0f bd fa             	bsr    %edx,%edi
  802bcf:	83 f7 1f             	xor    $0x1f,%edi
  802bd2:	75 2c                	jne    802c00 <__udivdi3+0xa0>
  802bd4:	39 f2                	cmp    %esi,%edx
  802bd6:	72 06                	jb     802bde <__udivdi3+0x7e>
  802bd8:	31 c0                	xor    %eax,%eax
  802bda:	39 eb                	cmp    %ebp,%ebx
  802bdc:	77 a9                	ja     802b87 <__udivdi3+0x27>
  802bde:	b8 01 00 00 00       	mov    $0x1,%eax
  802be3:	eb a2                	jmp    802b87 <__udivdi3+0x27>
  802be5:	8d 76 00             	lea    0x0(%esi),%esi
  802be8:	31 ff                	xor    %edi,%edi
  802bea:	31 c0                	xor    %eax,%eax
  802bec:	89 fa                	mov    %edi,%edx
  802bee:	83 c4 1c             	add    $0x1c,%esp
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    
  802bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	89 f9                	mov    %edi,%ecx
  802c02:	b8 20 00 00 00       	mov    $0x20,%eax
  802c07:	29 f8                	sub    %edi,%eax
  802c09:	d3 e2                	shl    %cl,%edx
  802c0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c0f:	89 c1                	mov    %eax,%ecx
  802c11:	89 da                	mov    %ebx,%edx
  802c13:	d3 ea                	shr    %cl,%edx
  802c15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c19:	09 d1                	or     %edx,%ecx
  802c1b:	89 f2                	mov    %esi,%edx
  802c1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c21:	89 f9                	mov    %edi,%ecx
  802c23:	d3 e3                	shl    %cl,%ebx
  802c25:	89 c1                	mov    %eax,%ecx
  802c27:	d3 ea                	shr    %cl,%edx
  802c29:	89 f9                	mov    %edi,%ecx
  802c2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c2f:	89 eb                	mov    %ebp,%ebx
  802c31:	d3 e6                	shl    %cl,%esi
  802c33:	89 c1                	mov    %eax,%ecx
  802c35:	d3 eb                	shr    %cl,%ebx
  802c37:	09 de                	or     %ebx,%esi
  802c39:	89 f0                	mov    %esi,%eax
  802c3b:	f7 74 24 08          	divl   0x8(%esp)
  802c3f:	89 d6                	mov    %edx,%esi
  802c41:	89 c3                	mov    %eax,%ebx
  802c43:	f7 64 24 0c          	mull   0xc(%esp)
  802c47:	39 d6                	cmp    %edx,%esi
  802c49:	72 15                	jb     802c60 <__udivdi3+0x100>
  802c4b:	89 f9                	mov    %edi,%ecx
  802c4d:	d3 e5                	shl    %cl,%ebp
  802c4f:	39 c5                	cmp    %eax,%ebp
  802c51:	73 04                	jae    802c57 <__udivdi3+0xf7>
  802c53:	39 d6                	cmp    %edx,%esi
  802c55:	74 09                	je     802c60 <__udivdi3+0x100>
  802c57:	89 d8                	mov    %ebx,%eax
  802c59:	31 ff                	xor    %edi,%edi
  802c5b:	e9 27 ff ff ff       	jmp    802b87 <__udivdi3+0x27>
  802c60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c63:	31 ff                	xor    %edi,%edi
  802c65:	e9 1d ff ff ff       	jmp    802b87 <__udivdi3+0x27>
  802c6a:	66 90                	xchg   %ax,%ax
  802c6c:	66 90                	xchg   %ax,%ax
  802c6e:	66 90                	xchg   %ax,%ax

00802c70 <__umoddi3>:
  802c70:	55                   	push   %ebp
  802c71:	57                   	push   %edi
  802c72:	56                   	push   %esi
  802c73:	53                   	push   %ebx
  802c74:	83 ec 1c             	sub    $0x1c,%esp
  802c77:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c87:	89 da                	mov    %ebx,%edx
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	75 43                	jne    802cd0 <__umoddi3+0x60>
  802c8d:	39 df                	cmp    %ebx,%edi
  802c8f:	76 17                	jbe    802ca8 <__umoddi3+0x38>
  802c91:	89 f0                	mov    %esi,%eax
  802c93:	f7 f7                	div    %edi
  802c95:	89 d0                	mov    %edx,%eax
  802c97:	31 d2                	xor    %edx,%edx
  802c99:	83 c4 1c             	add    $0x1c,%esp
  802c9c:	5b                   	pop    %ebx
  802c9d:	5e                   	pop    %esi
  802c9e:	5f                   	pop    %edi
  802c9f:	5d                   	pop    %ebp
  802ca0:	c3                   	ret    
  802ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	89 fd                	mov    %edi,%ebp
  802caa:	85 ff                	test   %edi,%edi
  802cac:	75 0b                	jne    802cb9 <__umoddi3+0x49>
  802cae:	b8 01 00 00 00       	mov    $0x1,%eax
  802cb3:	31 d2                	xor    %edx,%edx
  802cb5:	f7 f7                	div    %edi
  802cb7:	89 c5                	mov    %eax,%ebp
  802cb9:	89 d8                	mov    %ebx,%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	f7 f5                	div    %ebp
  802cbf:	89 f0                	mov    %esi,%eax
  802cc1:	f7 f5                	div    %ebp
  802cc3:	89 d0                	mov    %edx,%eax
  802cc5:	eb d0                	jmp    802c97 <__umoddi3+0x27>
  802cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cce:	66 90                	xchg   %ax,%ax
  802cd0:	89 f1                	mov    %esi,%ecx
  802cd2:	39 d8                	cmp    %ebx,%eax
  802cd4:	76 0a                	jbe    802ce0 <__umoddi3+0x70>
  802cd6:	89 f0                	mov    %esi,%eax
  802cd8:	83 c4 1c             	add    $0x1c,%esp
  802cdb:	5b                   	pop    %ebx
  802cdc:	5e                   	pop    %esi
  802cdd:	5f                   	pop    %edi
  802cde:	5d                   	pop    %ebp
  802cdf:	c3                   	ret    
  802ce0:	0f bd e8             	bsr    %eax,%ebp
  802ce3:	83 f5 1f             	xor    $0x1f,%ebp
  802ce6:	75 20                	jne    802d08 <__umoddi3+0x98>
  802ce8:	39 d8                	cmp    %ebx,%eax
  802cea:	0f 82 b0 00 00 00    	jb     802da0 <__umoddi3+0x130>
  802cf0:	39 f7                	cmp    %esi,%edi
  802cf2:	0f 86 a8 00 00 00    	jbe    802da0 <__umoddi3+0x130>
  802cf8:	89 c8                	mov    %ecx,%eax
  802cfa:	83 c4 1c             	add    $0x1c,%esp
  802cfd:	5b                   	pop    %ebx
  802cfe:	5e                   	pop    %esi
  802cff:	5f                   	pop    %edi
  802d00:	5d                   	pop    %ebp
  802d01:	c3                   	ret    
  802d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d08:	89 e9                	mov    %ebp,%ecx
  802d0a:	ba 20 00 00 00       	mov    $0x20,%edx
  802d0f:	29 ea                	sub    %ebp,%edx
  802d11:	d3 e0                	shl    %cl,%eax
  802d13:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d17:	89 d1                	mov    %edx,%ecx
  802d19:	89 f8                	mov    %edi,%eax
  802d1b:	d3 e8                	shr    %cl,%eax
  802d1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d21:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d25:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d29:	09 c1                	or     %eax,%ecx
  802d2b:	89 d8                	mov    %ebx,%eax
  802d2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d31:	89 e9                	mov    %ebp,%ecx
  802d33:	d3 e7                	shl    %cl,%edi
  802d35:	89 d1                	mov    %edx,%ecx
  802d37:	d3 e8                	shr    %cl,%eax
  802d39:	89 e9                	mov    %ebp,%ecx
  802d3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d3f:	d3 e3                	shl    %cl,%ebx
  802d41:	89 c7                	mov    %eax,%edi
  802d43:	89 d1                	mov    %edx,%ecx
  802d45:	89 f0                	mov    %esi,%eax
  802d47:	d3 e8                	shr    %cl,%eax
  802d49:	89 e9                	mov    %ebp,%ecx
  802d4b:	89 fa                	mov    %edi,%edx
  802d4d:	d3 e6                	shl    %cl,%esi
  802d4f:	09 d8                	or     %ebx,%eax
  802d51:	f7 74 24 08          	divl   0x8(%esp)
  802d55:	89 d1                	mov    %edx,%ecx
  802d57:	89 f3                	mov    %esi,%ebx
  802d59:	f7 64 24 0c          	mull   0xc(%esp)
  802d5d:	89 c6                	mov    %eax,%esi
  802d5f:	89 d7                	mov    %edx,%edi
  802d61:	39 d1                	cmp    %edx,%ecx
  802d63:	72 06                	jb     802d6b <__umoddi3+0xfb>
  802d65:	75 10                	jne    802d77 <__umoddi3+0x107>
  802d67:	39 c3                	cmp    %eax,%ebx
  802d69:	73 0c                	jae    802d77 <__umoddi3+0x107>
  802d6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d73:	89 d7                	mov    %edx,%edi
  802d75:	89 c6                	mov    %eax,%esi
  802d77:	89 ca                	mov    %ecx,%edx
  802d79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d7e:	29 f3                	sub    %esi,%ebx
  802d80:	19 fa                	sbb    %edi,%edx
  802d82:	89 d0                	mov    %edx,%eax
  802d84:	d3 e0                	shl    %cl,%eax
  802d86:	89 e9                	mov    %ebp,%ecx
  802d88:	d3 eb                	shr    %cl,%ebx
  802d8a:	d3 ea                	shr    %cl,%edx
  802d8c:	09 d8                	or     %ebx,%eax
  802d8e:	83 c4 1c             	add    $0x1c,%esp
  802d91:	5b                   	pop    %ebx
  802d92:	5e                   	pop    %esi
  802d93:	5f                   	pop    %edi
  802d94:	5d                   	pop    %ebp
  802d95:	c3                   	ret    
  802d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d9d:	8d 76 00             	lea    0x0(%esi),%esi
  802da0:	89 da                	mov    %ebx,%edx
  802da2:	29 fe                	sub    %edi,%esi
  802da4:	19 c2                	sbb    %eax,%edx
  802da6:	89 f1                	mov    %esi,%ecx
  802da8:	89 c8                	mov    %ecx,%eax
  802daa:	e9 4b ff ff ff       	jmp    802cfa <__umoddi3+0x8a>
