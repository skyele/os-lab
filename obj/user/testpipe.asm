
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
  800049:	e8 20 26 00 00       	call   80266e <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 12 15 00 00       	call   801572 <fork>
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
  800084:	e8 4e 04 00 00       	call   8004d7 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 21 19 00 00       	call   8019b5 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 2b 2e 80 00       	push   $0x802e2b
  8000a8:	e8 2a 04 00 00       	call   8004d7 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 bc 1a 00 00       	call   801b7a <readn>
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
  8000dd:	e8 ff 0b 00 00       	call   800ce1 <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 51 2e 80 00       	push   $0x802e51
  8000f5:	e8 dd 03 00 00       	call   8004d7 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 ab 02 00 00       	call   8003ad <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 e0 26 00 00       	call   8027eb <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 a7 	movl   $0x802ea7,0x804004
  800112:	2e 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 4e 25 00 00       	call   80266e <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 40 14 00 00       	call   801572 <fork>
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
  800148:	e8 68 18 00 00       	call   8019b5 <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 5d 18 00 00       	call   8019b5 <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 8b 26 00 00       	call   8027eb <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 d5 2e 80 00 	movl   $0x802ed5,(%esp)
  800167:	e8 6b 03 00 00       	call   8004d7 <cprintf>
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
  800183:	e8 59 02 00 00       	call   8003e1 <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 05 2e 80 00       	push   $0x802e05
  80018e:	6a 11                	push   $0x11
  800190:	68 f5 2d 80 00       	push   $0x802df5
  800195:	e8 47 02 00 00       	call   8003e1 <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 48 2e 80 00       	push   $0x802e48
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 f5 2d 80 00       	push   $0x802df5
  8001a7:	e8 35 02 00 00       	call   8003e1 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 6d 2e 80 00       	push   $0x802e6d
  8001b9:	e8 19 03 00 00       	call   8004d7 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 0e 2e 80 00       	push   $0x802e0e
  8001da:	e8 f8 02 00 00       	call   8004d7 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 cb 17 00 00       	call   8019b5 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 80 2e 80 00       	push   $0x802e80
  8001fe:	e8 d4 02 00 00       	call   8004d7 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 ec 09 00 00       	call   800bfd <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 9c 19 00 00       	call   801bbf <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 40 80 00    	pushl  0x804000
  80022e:	e8 ca 09 00 00       	call   800bfd <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 70 17 00 00       	call   8019b5 <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 9d 2e 80 00       	push   $0x802e9d
  800253:	6a 25                	push   $0x25
  800255:	68 f5 2d 80 00       	push   $0x802df5
  80025a:	e8 82 01 00 00       	call   8003e1 <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 ec 2d 80 00       	push   $0x802dec
  800265:	6a 2c                	push   $0x2c
  800267:	68 f5 2d 80 00       	push   $0x802df5
  80026c:	e8 70 01 00 00       	call   8003e1 <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 05 2e 80 00       	push   $0x802e05
  800277:	6a 2f                	push   $0x2f
  800279:	68 f5 2d 80 00       	push   $0x802df5
  80027e:	e8 5e 01 00 00       	call   8003e1 <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 27 17 00 00       	call   8019b5 <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 b4 2e 80 00       	push   $0x802eb4
  800299:	e8 39 02 00 00       	call   8004d7 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 b6 2e 80 00       	push   $0x802eb6
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 0f 19 00 00       	call   801bbf <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 b8 2e 80 00       	push   $0x802eb8
  8002c0:	e8 12 02 00 00       	call   8004d7 <cprintf>
		exit();
  8002c5:	e8 e3 00 00 00       	call   8003ad <exit>
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
  8002e5:	e8 00 0d 00 00       	call   800fea <sys_getenvid>
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
  80030a:	74 23                	je     80032f <libmain+0x5d>
		if(envs[i].env_id == find)
  80030c:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800312:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800318:	8b 49 48             	mov    0x48(%ecx),%ecx
  80031b:	39 c1                	cmp    %eax,%ecx
  80031d:	75 e2                	jne    800301 <libmain+0x2f>
  80031f:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800325:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80032b:	89 fe                	mov    %edi,%esi
  80032d:	eb d2                	jmp    800301 <libmain+0x2f>
  80032f:	89 f0                	mov    %esi,%eax
  800331:	84 c0                	test   %al,%al
  800333:	74 06                	je     80033b <libmain+0x69>
  800335:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033f:	7e 0a                	jle    80034b <libmain+0x79>
		binaryname = argv[0];
  800341:	8b 45 0c             	mov    0xc(%ebp),%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	a3 04 40 80 00       	mov    %eax,0x804004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80034b:	a1 08 50 80 00       	mov    0x805008,%eax
  800350:	8b 40 48             	mov    0x48(%eax),%eax
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	50                   	push   %eax
  800357:	68 2c 2f 80 00       	push   $0x802f2c
  80035c:	e8 76 01 00 00       	call   8004d7 <cprintf>
	cprintf("before umain\n");
  800361:	c7 04 24 4a 2f 80 00 	movl   $0x802f4a,(%esp)
  800368:	e8 6a 01 00 00       	call   8004d7 <cprintf>
	// call user main routine
	umain(argc, argv);
  80036d:	83 c4 08             	add    $0x8,%esp
  800370:	ff 75 0c             	pushl  0xc(%ebp)
  800373:	ff 75 08             	pushl  0x8(%ebp)
  800376:	e8 b8 fc ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80037b:	c7 04 24 58 2f 80 00 	movl   $0x802f58,(%esp)
  800382:	e8 50 01 00 00       	call   8004d7 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800387:	a1 08 50 80 00       	mov    0x805008,%eax
  80038c:	8b 40 48             	mov    0x48(%eax),%eax
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	50                   	push   %eax
  800393:	68 65 2f 80 00       	push   $0x802f65
  800398:	e8 3a 01 00 00       	call   8004d7 <cprintf>
	// exit gracefully
	exit();
  80039d:	e8 0b 00 00 00       	call   8003ad <exit>
}
  8003a2:	83 c4 10             	add    $0x10,%esp
  8003a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a8:	5b                   	pop    %ebx
  8003a9:	5e                   	pop    %esi
  8003aa:	5f                   	pop    %edi
  8003ab:	5d                   	pop    %ebp
  8003ac:	c3                   	ret    

008003ad <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003b3:	a1 08 50 80 00       	mov    0x805008,%eax
  8003b8:	8b 40 48             	mov    0x48(%eax),%eax
  8003bb:	68 90 2f 80 00       	push   $0x802f90
  8003c0:	50                   	push   %eax
  8003c1:	68 84 2f 80 00       	push   $0x802f84
  8003c6:	e8 0c 01 00 00       	call   8004d7 <cprintf>
	close_all();
  8003cb:	e8 12 16 00 00       	call   8019e2 <close_all>
	sys_env_destroy(0);
  8003d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003d7:	e8 cd 0b 00 00       	call   800fa9 <sys_env_destroy>
}
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	56                   	push   %esi
  8003e5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003e6:	a1 08 50 80 00       	mov    0x805008,%eax
  8003eb:	8b 40 48             	mov    0x48(%eax),%eax
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	68 bc 2f 80 00       	push   $0x802fbc
  8003f6:	50                   	push   %eax
  8003f7:	68 84 2f 80 00       	push   $0x802f84
  8003fc:	e8 d6 00 00 00       	call   8004d7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800401:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800404:	8b 35 04 40 80 00    	mov    0x804004,%esi
  80040a:	e8 db 0b 00 00       	call   800fea <sys_getenvid>
  80040f:	83 c4 04             	add    $0x4,%esp
  800412:	ff 75 0c             	pushl  0xc(%ebp)
  800415:	ff 75 08             	pushl  0x8(%ebp)
  800418:	56                   	push   %esi
  800419:	50                   	push   %eax
  80041a:	68 98 2f 80 00       	push   $0x802f98
  80041f:	e8 b3 00 00 00       	call   8004d7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800424:	83 c4 18             	add    $0x18,%esp
  800427:	53                   	push   %ebx
  800428:	ff 75 10             	pushl  0x10(%ebp)
  80042b:	e8 56 00 00 00       	call   800486 <vcprintf>
	cprintf("\n");
  800430:	c7 04 24 48 2f 80 00 	movl   $0x802f48,(%esp)
  800437:	e8 9b 00 00 00       	call   8004d7 <cprintf>
  80043c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80043f:	cc                   	int3   
  800440:	eb fd                	jmp    80043f <_panic+0x5e>

00800442 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	53                   	push   %ebx
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80044c:	8b 13                	mov    (%ebx),%edx
  80044e:	8d 42 01             	lea    0x1(%edx),%eax
  800451:	89 03                	mov    %eax,(%ebx)
  800453:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800456:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80045a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045f:	74 09                	je     80046a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800461:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800468:	c9                   	leave  
  800469:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	68 ff 00 00 00       	push   $0xff
  800472:	8d 43 08             	lea    0x8(%ebx),%eax
  800475:	50                   	push   %eax
  800476:	e8 f1 0a 00 00       	call   800f6c <sys_cputs>
		b->idx = 0;
  80047b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	eb db                	jmp    800461 <putch+0x1f>

00800486 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80048f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800496:	00 00 00 
	b.cnt = 0;
  800499:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a3:	ff 75 0c             	pushl  0xc(%ebp)
  8004a6:	ff 75 08             	pushl  0x8(%ebp)
  8004a9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004af:	50                   	push   %eax
  8004b0:	68 42 04 80 00       	push   $0x800442
  8004b5:	e8 4a 01 00 00       	call   800604 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ba:	83 c4 08             	add    $0x8,%esp
  8004bd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004c9:	50                   	push   %eax
  8004ca:	e8 9d 0a 00 00       	call   800f6c <sys_cputs>

	return b.cnt;
}
  8004cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    

008004d7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004dd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e0:	50                   	push   %eax
  8004e1:	ff 75 08             	pushl  0x8(%ebp)
  8004e4:	e8 9d ff ff ff       	call   800486 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	57                   	push   %edi
  8004ef:	56                   	push   %esi
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 1c             	sub    $0x1c,%esp
  8004f4:	89 c6                	mov    %eax,%esi
  8004f6:	89 d7                	mov    %edx,%edi
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800501:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800504:	8b 45 10             	mov    0x10(%ebp),%eax
  800507:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80050a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80050e:	74 2c                	je     80053c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800510:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800513:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80051a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800520:	39 c2                	cmp    %eax,%edx
  800522:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800525:	73 43                	jae    80056a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800527:	83 eb 01             	sub    $0x1,%ebx
  80052a:	85 db                	test   %ebx,%ebx
  80052c:	7e 6c                	jle    80059a <printnum+0xaf>
				putch(padc, putdat);
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	57                   	push   %edi
  800532:	ff 75 18             	pushl  0x18(%ebp)
  800535:	ff d6                	call   *%esi
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	eb eb                	jmp    800527 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	6a 20                	push   $0x20
  800541:	6a 00                	push   $0x0
  800543:	50                   	push   %eax
  800544:	ff 75 e4             	pushl  -0x1c(%ebp)
  800547:	ff 75 e0             	pushl  -0x20(%ebp)
  80054a:	89 fa                	mov    %edi,%edx
  80054c:	89 f0                	mov    %esi,%eax
  80054e:	e8 98 ff ff ff       	call   8004eb <printnum>
		while (--width > 0)
  800553:	83 c4 20             	add    $0x20,%esp
  800556:	83 eb 01             	sub    $0x1,%ebx
  800559:	85 db                	test   %ebx,%ebx
  80055b:	7e 65                	jle    8005c2 <printnum+0xd7>
			putch(padc, putdat);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	57                   	push   %edi
  800561:	6a 20                	push   $0x20
  800563:	ff d6                	call   *%esi
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	eb ec                	jmp    800556 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80056a:	83 ec 0c             	sub    $0xc,%esp
  80056d:	ff 75 18             	pushl  0x18(%ebp)
  800570:	83 eb 01             	sub    $0x1,%ebx
  800573:	53                   	push   %ebx
  800574:	50                   	push   %eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 dc             	pushl  -0x24(%ebp)
  80057b:	ff 75 d8             	pushl  -0x28(%ebp)
  80057e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800581:	ff 75 e0             	pushl  -0x20(%ebp)
  800584:	e8 07 26 00 00       	call   802b90 <__udivdi3>
  800589:	83 c4 18             	add    $0x18,%esp
  80058c:	52                   	push   %edx
  80058d:	50                   	push   %eax
  80058e:	89 fa                	mov    %edi,%edx
  800590:	89 f0                	mov    %esi,%eax
  800592:	e8 54 ff ff ff       	call   8004eb <printnum>
  800597:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	57                   	push   %edi
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8005a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ad:	e8 ee 26 00 00       	call   802ca0 <__umoddi3>
  8005b2:	83 c4 14             	add    $0x14,%esp
  8005b5:	0f be 80 c3 2f 80 00 	movsbl 0x802fc3(%eax),%eax
  8005bc:	50                   	push   %eax
  8005bd:	ff d6                	call   *%esi
  8005bf:	83 c4 10             	add    $0x10,%esp
	}
}
  8005c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c5:	5b                   	pop    %ebx
  8005c6:	5e                   	pop    %esi
  8005c7:	5f                   	pop    %edi
  8005c8:	5d                   	pop    %ebp
  8005c9:	c3                   	ret    

008005ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d4:	8b 10                	mov    (%eax),%edx
  8005d6:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d9:	73 0a                	jae    8005e5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005de:	89 08                	mov    %ecx,(%eax)
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	88 02                	mov    %al,(%edx)
}
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    

008005e7 <printfmt>:
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005ed:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005f0:	50                   	push   %eax
  8005f1:	ff 75 10             	pushl  0x10(%ebp)
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	ff 75 08             	pushl  0x8(%ebp)
  8005fa:	e8 05 00 00 00       	call   800604 <vprintfmt>
}
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <vprintfmt>:
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	57                   	push   %edi
  800608:	56                   	push   %esi
  800609:	53                   	push   %ebx
  80060a:	83 ec 3c             	sub    $0x3c,%esp
  80060d:	8b 75 08             	mov    0x8(%ebp),%esi
  800610:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800613:	8b 7d 10             	mov    0x10(%ebp),%edi
  800616:	e9 32 04 00 00       	jmp    800a4d <vprintfmt+0x449>
		padc = ' ';
  80061b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80061f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800626:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80062d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800634:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80063b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800642:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800647:	8d 47 01             	lea    0x1(%edi),%eax
  80064a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064d:	0f b6 17             	movzbl (%edi),%edx
  800650:	8d 42 dd             	lea    -0x23(%edx),%eax
  800653:	3c 55                	cmp    $0x55,%al
  800655:	0f 87 12 05 00 00    	ja     800b6d <vprintfmt+0x569>
  80065b:	0f b6 c0             	movzbl %al,%eax
  80065e:	ff 24 85 a0 31 80 00 	jmp    *0x8031a0(,%eax,4)
  800665:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800668:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80066c:	eb d9                	jmp    800647 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80066e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800671:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800675:	eb d0                	jmp    800647 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800677:	0f b6 d2             	movzbl %dl,%edx
  80067a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80067d:	b8 00 00 00 00       	mov    $0x0,%eax
  800682:	89 75 08             	mov    %esi,0x8(%ebp)
  800685:	eb 03                	jmp    80068a <vprintfmt+0x86>
  800687:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80068a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800691:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800694:	8d 72 d0             	lea    -0x30(%edx),%esi
  800697:	83 fe 09             	cmp    $0x9,%esi
  80069a:	76 eb                	jbe    800687 <vprintfmt+0x83>
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a2:	eb 14                	jmp    8006b8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bc:	79 89                	jns    800647 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006cb:	e9 77 ff ff ff       	jmp    800647 <vprintfmt+0x43>
  8006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	0f 48 c1             	cmovs  %ecx,%eax
  8006d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006de:	e9 64 ff ff ff       	jmp    800647 <vprintfmt+0x43>
  8006e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8006ed:	e9 55 ff ff ff       	jmp    800647 <vprintfmt+0x43>
			lflag++;
  8006f2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006f9:	e9 49 ff ff ff       	jmp    800647 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 78 04             	lea    0x4(%eax),%edi
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	ff 30                	pushl  (%eax)
  80070a:	ff d6                	call   *%esi
			break;
  80070c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80070f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800712:	e9 33 03 00 00       	jmp    800a4a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 78 04             	lea    0x4(%eax),%edi
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	99                   	cltd   
  800720:	31 d0                	xor    %edx,%eax
  800722:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800724:	83 f8 11             	cmp    $0x11,%eax
  800727:	7f 23                	jg     80074c <vprintfmt+0x148>
  800729:	8b 14 85 00 33 80 00 	mov    0x803300(,%eax,4),%edx
  800730:	85 d2                	test   %edx,%edx
  800732:	74 18                	je     80074c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800734:	52                   	push   %edx
  800735:	68 0d 35 80 00       	push   $0x80350d
  80073a:	53                   	push   %ebx
  80073b:	56                   	push   %esi
  80073c:	e8 a6 fe ff ff       	call   8005e7 <printfmt>
  800741:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800744:	89 7d 14             	mov    %edi,0x14(%ebp)
  800747:	e9 fe 02 00 00       	jmp    800a4a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80074c:	50                   	push   %eax
  80074d:	68 db 2f 80 00       	push   $0x802fdb
  800752:	53                   	push   %ebx
  800753:	56                   	push   %esi
  800754:	e8 8e fe ff ff       	call   8005e7 <printfmt>
  800759:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80075f:	e9 e6 02 00 00       	jmp    800a4a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 c0 04             	add    $0x4,%eax
  80076a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800772:	85 c9                	test   %ecx,%ecx
  800774:	b8 d4 2f 80 00       	mov    $0x802fd4,%eax
  800779:	0f 45 c1             	cmovne %ecx,%eax
  80077c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80077f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800783:	7e 06                	jle    80078b <vprintfmt+0x187>
  800785:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800789:	75 0d                	jne    800798 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80078e:	89 c7                	mov    %eax,%edi
  800790:	03 45 e0             	add    -0x20(%ebp),%eax
  800793:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800796:	eb 53                	jmp    8007eb <vprintfmt+0x1e7>
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 d8             	pushl  -0x28(%ebp)
  80079e:	50                   	push   %eax
  80079f:	e8 71 04 00 00       	call   800c15 <strnlen>
  8007a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007a7:	29 c1                	sub    %eax,%ecx
  8007a9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007b1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b8:	eb 0f                	jmp    8007c9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c3:	83 ef 01             	sub    $0x1,%edi
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	85 ff                	test   %edi,%edi
  8007cb:	7f ed                	jg     8007ba <vprintfmt+0x1b6>
  8007cd:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007d0:	85 c9                	test   %ecx,%ecx
  8007d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d7:	0f 49 c1             	cmovns %ecx,%eax
  8007da:	29 c1                	sub    %eax,%ecx
  8007dc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007df:	eb aa                	jmp    80078b <vprintfmt+0x187>
					putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	52                   	push   %edx
  8007e6:	ff d6                	call   *%esi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007ee:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f0:	83 c7 01             	add    $0x1,%edi
  8007f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f7:	0f be d0             	movsbl %al,%edx
  8007fa:	85 d2                	test   %edx,%edx
  8007fc:	74 4b                	je     800849 <vprintfmt+0x245>
  8007fe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800802:	78 06                	js     80080a <vprintfmt+0x206>
  800804:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800808:	78 1e                	js     800828 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80080a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80080e:	74 d1                	je     8007e1 <vprintfmt+0x1dd>
  800810:	0f be c0             	movsbl %al,%eax
  800813:	83 e8 20             	sub    $0x20,%eax
  800816:	83 f8 5e             	cmp    $0x5e,%eax
  800819:	76 c6                	jbe    8007e1 <vprintfmt+0x1dd>
					putch('?', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	6a 3f                	push   $0x3f
  800821:	ff d6                	call   *%esi
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb c3                	jmp    8007eb <vprintfmt+0x1e7>
  800828:	89 cf                	mov    %ecx,%edi
  80082a:	eb 0e                	jmp    80083a <vprintfmt+0x236>
				putch(' ', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	6a 20                	push   $0x20
  800832:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800834:	83 ef 01             	sub    $0x1,%edi
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	85 ff                	test   %edi,%edi
  80083c:	7f ee                	jg     80082c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80083e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
  800844:	e9 01 02 00 00       	jmp    800a4a <vprintfmt+0x446>
  800849:	89 cf                	mov    %ecx,%edi
  80084b:	eb ed                	jmp    80083a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80084d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800850:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800857:	e9 eb fd ff ff       	jmp    800647 <vprintfmt+0x43>
	if (lflag >= 2)
  80085c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800860:	7f 21                	jg     800883 <vprintfmt+0x27f>
	else if (lflag)
  800862:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800866:	74 68                	je     8008d0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800870:	89 c1                	mov    %eax,%ecx
  800872:	c1 f9 1f             	sar    $0x1f,%ecx
  800875:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 40 04             	lea    0x4(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	eb 17                	jmp    80089a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8b 50 04             	mov    0x4(%eax),%edx
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80088e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 08             	lea    0x8(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80089a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80089d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008aa:	78 3f                	js     8008eb <vprintfmt+0x2e7>
			base = 10;
  8008ac:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008b1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008b5:	0f 84 71 01 00 00    	je     800a2c <vprintfmt+0x428>
				putch('+', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 2b                	push   $0x2b
  8008c1:	ff d6                	call   *%esi
  8008c3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008cb:	e9 5c 01 00 00       	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008d8:	89 c1                	mov    %eax,%ecx
  8008da:	c1 f9 1f             	sar    $0x1f,%ecx
  8008dd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 40 04             	lea    0x4(%eax),%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	eb af                	jmp    80089a <vprintfmt+0x296>
				putch('-', putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	53                   	push   %ebx
  8008ef:	6a 2d                	push   $0x2d
  8008f1:	ff d6                	call   *%esi
				num = -(long long) num;
  8008f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008f9:	f7 d8                	neg    %eax
  8008fb:	83 d2 00             	adc    $0x0,%edx
  8008fe:	f7 da                	neg    %edx
  800900:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800903:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800906:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800909:	b8 0a 00 00 00       	mov    $0xa,%eax
  80090e:	e9 19 01 00 00       	jmp    800a2c <vprintfmt+0x428>
	if (lflag >= 2)
  800913:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800917:	7f 29                	jg     800942 <vprintfmt+0x33e>
	else if (lflag)
  800919:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80091d:	74 44                	je     800963 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8d 40 04             	lea    0x4(%eax),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800938:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093d:	e9 ea 00 00 00       	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 50 04             	mov    0x4(%eax),%edx
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8d 40 08             	lea    0x8(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800959:	b8 0a 00 00 00       	mov    $0xa,%eax
  80095e:	e9 c9 00 00 00       	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	ba 00 00 00 00       	mov    $0x0,%edx
  80096d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800970:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8d 40 04             	lea    0x4(%eax),%eax
  800979:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80097c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800981:	e9 a6 00 00 00       	jmp    800a2c <vprintfmt+0x428>
			putch('0', putdat);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	53                   	push   %ebx
  80098a:	6a 30                	push   $0x30
  80098c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800995:	7f 26                	jg     8009bd <vprintfmt+0x3b9>
	else if (lflag)
  800997:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80099b:	74 3e                	je     8009db <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80099d:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	8d 40 04             	lea    0x4(%eax),%eax
  8009b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8009bb:	eb 6f                	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 50 04             	mov    0x4(%eax),%edx
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8d 40 08             	lea    0x8(%eax),%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8009d9:	eb 51                	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009db:	8b 45 14             	mov    0x14(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ee:	8d 40 04             	lea    0x4(%eax),%eax
  8009f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8009f9:	eb 31                	jmp    800a2c <vprintfmt+0x428>
			putch('0', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	53                   	push   %ebx
  8009ff:	6a 30                	push   $0x30
  800a01:	ff d6                	call   *%esi
			putch('x', putdat);
  800a03:	83 c4 08             	add    $0x8,%esp
  800a06:	53                   	push   %ebx
  800a07:	6a 78                	push   $0x78
  800a09:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
  800a15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a18:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a1b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	8d 40 04             	lea    0x4(%eax),%eax
  800a24:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a27:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a2c:	83 ec 0c             	sub    $0xc,%esp
  800a2f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a33:	52                   	push   %edx
  800a34:	ff 75 e0             	pushl  -0x20(%ebp)
  800a37:	50                   	push   %eax
  800a38:	ff 75 dc             	pushl  -0x24(%ebp)
  800a3b:	ff 75 d8             	pushl  -0x28(%ebp)
  800a3e:	89 da                	mov    %ebx,%edx
  800a40:	89 f0                	mov    %esi,%eax
  800a42:	e8 a4 fa ff ff       	call   8004eb <printnum>
			break;
  800a47:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a4a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a4d:	83 c7 01             	add    $0x1,%edi
  800a50:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a54:	83 f8 25             	cmp    $0x25,%eax
  800a57:	0f 84 be fb ff ff    	je     80061b <vprintfmt+0x17>
			if (ch == '\0')
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	0f 84 28 01 00 00    	je     800b8d <vprintfmt+0x589>
			putch(ch, putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	53                   	push   %ebx
  800a69:	50                   	push   %eax
  800a6a:	ff d6                	call   *%esi
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	eb dc                	jmp    800a4d <vprintfmt+0x449>
	if (lflag >= 2)
  800a71:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a75:	7f 26                	jg     800a9d <vprintfmt+0x499>
	else if (lflag)
  800a77:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a7b:	74 41                	je     800abe <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8b 00                	mov    (%eax),%eax
  800a82:	ba 00 00 00 00       	mov    $0x0,%edx
  800a87:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	8d 40 04             	lea    0x4(%eax),%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a96:	b8 10 00 00 00       	mov    $0x10,%eax
  800a9b:	eb 8f                	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	8b 50 04             	mov    0x4(%eax),%edx
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	8d 40 08             	lea    0x8(%eax),%eax
  800ab1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab9:	e9 6e ff ff ff       	jmp    800a2c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800acb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	8d 40 04             	lea    0x4(%eax),%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad7:	b8 10 00 00 00       	mov    $0x10,%eax
  800adc:	e9 4b ff ff ff       	jmp    800a2c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	8b 00                	mov    (%eax),%eax
  800aef:	85 c0                	test   %eax,%eax
  800af1:	74 14                	je     800b07 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800af3:	8b 13                	mov    (%ebx),%edx
  800af5:	83 fa 7f             	cmp    $0x7f,%edx
  800af8:	7f 37                	jg     800b31 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800afa:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800afc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aff:	89 45 14             	mov    %eax,0x14(%ebp)
  800b02:	e9 43 ff ff ff       	jmp    800a4a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0c:	bf f9 30 80 00       	mov    $0x8030f9,%edi
							putch(ch, putdat);
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	53                   	push   %ebx
  800b15:	50                   	push   %eax
  800b16:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b18:	83 c7 01             	add    $0x1,%edi
  800b1b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	85 c0                	test   %eax,%eax
  800b24:	75 eb                	jne    800b11 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b29:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2c:	e9 19 ff ff ff       	jmp    800a4a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b31:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b33:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b38:	bf 31 31 80 00       	mov    $0x803131,%edi
							putch(ch, putdat);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	53                   	push   %ebx
  800b41:	50                   	push   %eax
  800b42:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b44:	83 c7 01             	add    $0x1,%edi
  800b47:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	85 c0                	test   %eax,%eax
  800b50:	75 eb                	jne    800b3d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b55:	89 45 14             	mov    %eax,0x14(%ebp)
  800b58:	e9 ed fe ff ff       	jmp    800a4a <vprintfmt+0x446>
			putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	53                   	push   %ebx
  800b61:	6a 25                	push   $0x25
  800b63:	ff d6                	call   *%esi
			break;
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	e9 dd fe ff ff       	jmp    800a4a <vprintfmt+0x446>
			putch('%', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	53                   	push   %ebx
  800b71:	6a 25                	push   $0x25
  800b73:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	89 f8                	mov    %edi,%eax
  800b7a:	eb 03                	jmp    800b7f <vprintfmt+0x57b>
  800b7c:	83 e8 01             	sub    $0x1,%eax
  800b7f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b83:	75 f7                	jne    800b7c <vprintfmt+0x578>
  800b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b88:	e9 bd fe ff ff       	jmp    800a4a <vprintfmt+0x446>
}
  800b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 18             	sub    $0x18,%esp
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ba8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bb2:	85 c0                	test   %eax,%eax
  800bb4:	74 26                	je     800bdc <vsnprintf+0x47>
  800bb6:	85 d2                	test   %edx,%edx
  800bb8:	7e 22                	jle    800bdc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bba:	ff 75 14             	pushl  0x14(%ebp)
  800bbd:	ff 75 10             	pushl  0x10(%ebp)
  800bc0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	68 ca 05 80 00       	push   $0x8005ca
  800bc9:	e8 36 fa ff ff       	call   800604 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd7:	83 c4 10             	add    $0x10,%esp
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    
		return -E_INVAL;
  800bdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800be1:	eb f7                	jmp    800bda <vsnprintf+0x45>

00800be3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bec:	50                   	push   %eax
  800bed:	ff 75 10             	pushl  0x10(%ebp)
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	e8 9a ff ff ff       	call   800b95 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
  800c08:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c0c:	74 05                	je     800c13 <strlen+0x16>
		n++;
  800c0e:	83 c0 01             	add    $0x1,%eax
  800c11:	eb f5                	jmp    800c08 <strlen+0xb>
	return n;
}
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c23:	39 c2                	cmp    %eax,%edx
  800c25:	74 0d                	je     800c34 <strnlen+0x1f>
  800c27:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c2b:	74 05                	je     800c32 <strnlen+0x1d>
		n++;
  800c2d:	83 c2 01             	add    $0x1,%edx
  800c30:	eb f1                	jmp    800c23 <strnlen+0xe>
  800c32:	89 d0                	mov    %edx,%eax
	return n;
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	53                   	push   %ebx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c40:	ba 00 00 00 00       	mov    $0x0,%edx
  800c45:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c49:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c4c:	83 c2 01             	add    $0x1,%edx
  800c4f:	84 c9                	test   %cl,%cl
  800c51:	75 f2                	jne    800c45 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c53:	5b                   	pop    %ebx
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 10             	sub    $0x10,%esp
  800c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c60:	53                   	push   %ebx
  800c61:	e8 97 ff ff ff       	call   800bfd <strlen>
  800c66:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	01 d8                	add    %ebx,%eax
  800c6e:	50                   	push   %eax
  800c6f:	e8 c2 ff ff ff       	call   800c36 <strcpy>
	return dst;
}
  800c74:	89 d8                	mov    %ebx,%eax
  800c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c86:	89 c6                	mov    %eax,%esi
  800c88:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	39 f2                	cmp    %esi,%edx
  800c8f:	74 11                	je     800ca2 <strncpy+0x27>
		*dst++ = *src;
  800c91:	83 c2 01             	add    $0x1,%edx
  800c94:	0f b6 19             	movzbl (%ecx),%ebx
  800c97:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c9a:	80 fb 01             	cmp    $0x1,%bl
  800c9d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ca0:	eb eb                	jmp    800c8d <strncpy+0x12>
	}
	return ret;
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	8b 75 08             	mov    0x8(%ebp),%esi
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	8b 55 10             	mov    0x10(%ebp),%edx
  800cb4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cb6:	85 d2                	test   %edx,%edx
  800cb8:	74 21                	je     800cdb <strlcpy+0x35>
  800cba:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cbe:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cc0:	39 c2                	cmp    %eax,%edx
  800cc2:	74 14                	je     800cd8 <strlcpy+0x32>
  800cc4:	0f b6 19             	movzbl (%ecx),%ebx
  800cc7:	84 db                	test   %bl,%bl
  800cc9:	74 0b                	je     800cd6 <strlcpy+0x30>
			*dst++ = *src++;
  800ccb:	83 c1 01             	add    $0x1,%ecx
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cd4:	eb ea                	jmp    800cc0 <strlcpy+0x1a>
  800cd6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cd8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cdb:	29 f0                	sub    %esi,%eax
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cea:	0f b6 01             	movzbl (%ecx),%eax
  800ced:	84 c0                	test   %al,%al
  800cef:	74 0c                	je     800cfd <strcmp+0x1c>
  800cf1:	3a 02                	cmp    (%edx),%al
  800cf3:	75 08                	jne    800cfd <strcmp+0x1c>
		p++, q++;
  800cf5:	83 c1 01             	add    $0x1,%ecx
  800cf8:	83 c2 01             	add    $0x1,%edx
  800cfb:	eb ed                	jmp    800cea <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfd:	0f b6 c0             	movzbl %al,%eax
  800d00:	0f b6 12             	movzbl (%edx),%edx
  800d03:	29 d0                	sub    %edx,%eax
}
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	53                   	push   %ebx
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d11:	89 c3                	mov    %eax,%ebx
  800d13:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strncmp+0x17>
		n--, p++, q++;
  800d18:	83 c0 01             	add    $0x1,%eax
  800d1b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d1e:	39 d8                	cmp    %ebx,%eax
  800d20:	74 16                	je     800d38 <strncmp+0x31>
  800d22:	0f b6 08             	movzbl (%eax),%ecx
  800d25:	84 c9                	test   %cl,%cl
  800d27:	74 04                	je     800d2d <strncmp+0x26>
  800d29:	3a 0a                	cmp    (%edx),%cl
  800d2b:	74 eb                	je     800d18 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2d:	0f b6 00             	movzbl (%eax),%eax
  800d30:	0f b6 12             	movzbl (%edx),%edx
  800d33:	29 d0                	sub    %edx,%eax
}
  800d35:	5b                   	pop    %ebx
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
		return 0;
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3d:	eb f6                	jmp    800d35 <strncmp+0x2e>

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d49:	0f b6 10             	movzbl (%eax),%edx
  800d4c:	84 d2                	test   %dl,%dl
  800d4e:	74 09                	je     800d59 <strchr+0x1a>
		if (*s == c)
  800d50:	38 ca                	cmp    %cl,%dl
  800d52:	74 0a                	je     800d5e <strchr+0x1f>
	for (; *s; s++)
  800d54:	83 c0 01             	add    $0x1,%eax
  800d57:	eb f0                	jmp    800d49 <strchr+0xa>
			return (char *) s;
	return 0;
  800d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d6a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d6d:	38 ca                	cmp    %cl,%dl
  800d6f:	74 09                	je     800d7a <strfind+0x1a>
  800d71:	84 d2                	test   %dl,%dl
  800d73:	74 05                	je     800d7a <strfind+0x1a>
	for (; *s; s++)
  800d75:	83 c0 01             	add    $0x1,%eax
  800d78:	eb f0                	jmp    800d6a <strfind+0xa>
			break;
	return (char *) s;
}
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d88:	85 c9                	test   %ecx,%ecx
  800d8a:	74 31                	je     800dbd <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8c:	89 f8                	mov    %edi,%eax
  800d8e:	09 c8                	or     %ecx,%eax
  800d90:	a8 03                	test   $0x3,%al
  800d92:	75 23                	jne    800db7 <memset+0x3b>
		c &= 0xFF;
  800d94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d98:	89 d3                	mov    %edx,%ebx
  800d9a:	c1 e3 08             	shl    $0x8,%ebx
  800d9d:	89 d0                	mov    %edx,%eax
  800d9f:	c1 e0 18             	shl    $0x18,%eax
  800da2:	89 d6                	mov    %edx,%esi
  800da4:	c1 e6 10             	shl    $0x10,%esi
  800da7:	09 f0                	or     %esi,%eax
  800da9:	09 c2                	or     %eax,%edx
  800dab:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800db0:	89 d0                	mov    %edx,%eax
  800db2:	fc                   	cld    
  800db3:	f3 ab                	rep stos %eax,%es:(%edi)
  800db5:	eb 06                	jmp    800dbd <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	fc                   	cld    
  800dbb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dbd:	89 f8                	mov    %edi,%eax
  800dbf:	5b                   	pop    %ebx
  800dc0:	5e                   	pop    %esi
  800dc1:	5f                   	pop    %edi
  800dc2:	5d                   	pop    %ebp
  800dc3:	c3                   	ret    

00800dc4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd2:	39 c6                	cmp    %eax,%esi
  800dd4:	73 32                	jae    800e08 <memmove+0x44>
  800dd6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd9:	39 c2                	cmp    %eax,%edx
  800ddb:	76 2b                	jbe    800e08 <memmove+0x44>
		s += n;
		d += n;
  800ddd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de0:	89 fe                	mov    %edi,%esi
  800de2:	09 ce                	or     %ecx,%esi
  800de4:	09 d6                	or     %edx,%esi
  800de6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dec:	75 0e                	jne    800dfc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dee:	83 ef 04             	sub    $0x4,%edi
  800df1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df7:	fd                   	std    
  800df8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dfa:	eb 09                	jmp    800e05 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dfc:	83 ef 01             	sub    $0x1,%edi
  800dff:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e02:	fd                   	std    
  800e03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e05:	fc                   	cld    
  800e06:	eb 1a                	jmp    800e22 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e08:	89 c2                	mov    %eax,%edx
  800e0a:	09 ca                	or     %ecx,%edx
  800e0c:	09 f2                	or     %esi,%edx
  800e0e:	f6 c2 03             	test   $0x3,%dl
  800e11:	75 0a                	jne    800e1d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e16:	89 c7                	mov    %eax,%edi
  800e18:	fc                   	cld    
  800e19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e1b:	eb 05                	jmp    800e22 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e1d:	89 c7                	mov    %eax,%edi
  800e1f:	fc                   	cld    
  800e20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2c:	ff 75 10             	pushl  0x10(%ebp)
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	ff 75 08             	pushl  0x8(%ebp)
  800e35:	e8 8a ff ff ff       	call   800dc4 <memmove>
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e47:	89 c6                	mov    %eax,%esi
  800e49:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e4c:	39 f0                	cmp    %esi,%eax
  800e4e:	74 1c                	je     800e6c <memcmp+0x30>
		if (*s1 != *s2)
  800e50:	0f b6 08             	movzbl (%eax),%ecx
  800e53:	0f b6 1a             	movzbl (%edx),%ebx
  800e56:	38 d9                	cmp    %bl,%cl
  800e58:	75 08                	jne    800e62 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e5a:	83 c0 01             	add    $0x1,%eax
  800e5d:	83 c2 01             	add    $0x1,%edx
  800e60:	eb ea                	jmp    800e4c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e62:	0f b6 c1             	movzbl %cl,%eax
  800e65:	0f b6 db             	movzbl %bl,%ebx
  800e68:	29 d8                	sub    %ebx,%eax
  800e6a:	eb 05                	jmp    800e71 <memcmp+0x35>
	}

	return 0;
  800e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e83:	39 d0                	cmp    %edx,%eax
  800e85:	73 09                	jae    800e90 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e87:	38 08                	cmp    %cl,(%eax)
  800e89:	74 05                	je     800e90 <memfind+0x1b>
	for (; s < ends; s++)
  800e8b:	83 c0 01             	add    $0x1,%eax
  800e8e:	eb f3                	jmp    800e83 <memfind+0xe>
			break;
	return (void *) s;
}
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
  800e98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e9e:	eb 03                	jmp    800ea3 <strtol+0x11>
		s++;
  800ea0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ea3:	0f b6 01             	movzbl (%ecx),%eax
  800ea6:	3c 20                	cmp    $0x20,%al
  800ea8:	74 f6                	je     800ea0 <strtol+0xe>
  800eaa:	3c 09                	cmp    $0x9,%al
  800eac:	74 f2                	je     800ea0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800eae:	3c 2b                	cmp    $0x2b,%al
  800eb0:	74 2a                	je     800edc <strtol+0x4a>
	int neg = 0;
  800eb2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eb7:	3c 2d                	cmp    $0x2d,%al
  800eb9:	74 2b                	je     800ee6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ebb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ec1:	75 0f                	jne    800ed2 <strtol+0x40>
  800ec3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ec6:	74 28                	je     800ef0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ec8:	85 db                	test   %ebx,%ebx
  800eca:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecf:	0f 44 d8             	cmove  %eax,%ebx
  800ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800eda:	eb 50                	jmp    800f2c <strtol+0x9a>
		s++;
  800edc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800edf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee4:	eb d5                	jmp    800ebb <strtol+0x29>
		s++, neg = 1;
  800ee6:	83 c1 01             	add    $0x1,%ecx
  800ee9:	bf 01 00 00 00       	mov    $0x1,%edi
  800eee:	eb cb                	jmp    800ebb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ef0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ef4:	74 0e                	je     800f04 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ef6:	85 db                	test   %ebx,%ebx
  800ef8:	75 d8                	jne    800ed2 <strtol+0x40>
		s++, base = 8;
  800efa:	83 c1 01             	add    $0x1,%ecx
  800efd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f02:	eb ce                	jmp    800ed2 <strtol+0x40>
		s += 2, base = 16;
  800f04:	83 c1 02             	add    $0x2,%ecx
  800f07:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f0c:	eb c4                	jmp    800ed2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f0e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f11:	89 f3                	mov    %esi,%ebx
  800f13:	80 fb 19             	cmp    $0x19,%bl
  800f16:	77 29                	ja     800f41 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f18:	0f be d2             	movsbl %dl,%edx
  800f1b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f1e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f21:	7d 30                	jge    800f53 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f23:	83 c1 01             	add    $0x1,%ecx
  800f26:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f2a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2c:	0f b6 11             	movzbl (%ecx),%edx
  800f2f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f32:	89 f3                	mov    %esi,%ebx
  800f34:	80 fb 09             	cmp    $0x9,%bl
  800f37:	77 d5                	ja     800f0e <strtol+0x7c>
			dig = *s - '0';
  800f39:	0f be d2             	movsbl %dl,%edx
  800f3c:	83 ea 30             	sub    $0x30,%edx
  800f3f:	eb dd                	jmp    800f1e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f41:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f44:	89 f3                	mov    %esi,%ebx
  800f46:	80 fb 19             	cmp    $0x19,%bl
  800f49:	77 08                	ja     800f53 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f4b:	0f be d2             	movsbl %dl,%edx
  800f4e:	83 ea 37             	sub    $0x37,%edx
  800f51:	eb cb                	jmp    800f1e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f57:	74 05                	je     800f5e <strtol+0xcc>
		*endptr = (char *) s;
  800f59:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f5c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f5e:	89 c2                	mov    %eax,%edx
  800f60:	f7 da                	neg    %edx
  800f62:	85 ff                	test   %edi,%edi
  800f64:	0f 45 c2             	cmovne %edx,%eax
}
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	89 c3                	mov    %eax,%ebx
  800f7f:	89 c7                	mov    %eax,%edi
  800f81:	89 c6                	mov    %eax,%esi
  800f83:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
  800f95:	b8 01 00 00 00       	mov    $0x1,%eax
  800f9a:	89 d1                	mov    %edx,%ecx
  800f9c:	89 d3                	mov    %edx,%ebx
  800f9e:	89 d7                	mov    %edx,%edi
  800fa0:	89 d6                	mov    %edx,%esi
  800fa2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fba:	b8 03 00 00 00       	mov    $0x3,%eax
  800fbf:	89 cb                	mov    %ecx,%ebx
  800fc1:	89 cf                	mov    %ecx,%edi
  800fc3:	89 ce                	mov    %ecx,%esi
  800fc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	7f 08                	jg     800fd3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	50                   	push   %eax
  800fd7:	6a 03                	push   $0x3
  800fd9:	68 48 33 80 00       	push   $0x803348
  800fde:	6a 43                	push   $0x43
  800fe0:	68 65 33 80 00       	push   $0x803365
  800fe5:	e8 f7 f3 ff ff       	call   8003e1 <_panic>

00800fea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff5:	b8 02 00 00 00       	mov    $0x2,%eax
  800ffa:	89 d1                	mov    %edx,%ecx
  800ffc:	89 d3                	mov    %edx,%ebx
  800ffe:	89 d7                	mov    %edx,%edi
  801000:	89 d6                	mov    %edx,%esi
  801002:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_yield>:

void
sys_yield(void)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100f:	ba 00 00 00 00       	mov    $0x0,%edx
  801014:	b8 0b 00 00 00       	mov    $0xb,%eax
  801019:	89 d1                	mov    %edx,%ecx
  80101b:	89 d3                	mov    %edx,%ebx
  80101d:	89 d7                	mov    %edx,%edi
  80101f:	89 d6                	mov    %edx,%esi
  801021:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5f                   	pop    %edi
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
  80102e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801031:	be 00 00 00 00       	mov    $0x0,%esi
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103c:	b8 04 00 00 00       	mov    $0x4,%eax
  801041:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801044:	89 f7                	mov    %esi,%edi
  801046:	cd 30                	int    $0x30
	if(check && ret > 0)
  801048:	85 c0                	test   %eax,%eax
  80104a:	7f 08                	jg     801054 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80104c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	50                   	push   %eax
  801058:	6a 04                	push   $0x4
  80105a:	68 48 33 80 00       	push   $0x803348
  80105f:	6a 43                	push   $0x43
  801061:	68 65 33 80 00       	push   $0x803365
  801066:	e8 76 f3 ff ff       	call   8003e1 <_panic>

0080106b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107a:	b8 05 00 00 00       	mov    $0x5,%eax
  80107f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801082:	8b 7d 14             	mov    0x14(%ebp),%edi
  801085:	8b 75 18             	mov    0x18(%ebp),%esi
  801088:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108a:	85 c0                	test   %eax,%eax
  80108c:	7f 08                	jg     801096 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	50                   	push   %eax
  80109a:	6a 05                	push   $0x5
  80109c:	68 48 33 80 00       	push   $0x803348
  8010a1:	6a 43                	push   $0x43
  8010a3:	68 65 33 80 00       	push   $0x803365
  8010a8:	e8 34 f3 ff ff       	call   8003e1 <_panic>

008010ad <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8010c6:	89 df                	mov    %ebx,%edi
  8010c8:	89 de                	mov    %ebx,%esi
  8010ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	7f 08                	jg     8010d8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d8:	83 ec 0c             	sub    $0xc,%esp
  8010db:	50                   	push   %eax
  8010dc:	6a 06                	push   $0x6
  8010de:	68 48 33 80 00       	push   $0x803348
  8010e3:	6a 43                	push   $0x43
  8010e5:	68 65 33 80 00       	push   $0x803365
  8010ea:	e8 f2 f2 ff ff       	call   8003e1 <_panic>

008010ef <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	57                   	push   %edi
  8010f3:	56                   	push   %esi
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801103:	b8 08 00 00 00       	mov    $0x8,%eax
  801108:	89 df                	mov    %ebx,%edi
  80110a:	89 de                	mov    %ebx,%esi
  80110c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110e:	85 c0                	test   %eax,%eax
  801110:	7f 08                	jg     80111a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801112:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	50                   	push   %eax
  80111e:	6a 08                	push   $0x8
  801120:	68 48 33 80 00       	push   $0x803348
  801125:	6a 43                	push   $0x43
  801127:	68 65 33 80 00       	push   $0x803365
  80112c:	e8 b0 f2 ff ff       	call   8003e1 <_panic>

00801131 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	57                   	push   %edi
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
  801137:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80113a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113f:	8b 55 08             	mov    0x8(%ebp),%edx
  801142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801145:	b8 09 00 00 00       	mov    $0x9,%eax
  80114a:	89 df                	mov    %ebx,%edi
  80114c:	89 de                	mov    %ebx,%esi
  80114e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801150:	85 c0                	test   %eax,%eax
  801152:	7f 08                	jg     80115c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	50                   	push   %eax
  801160:	6a 09                	push   $0x9
  801162:	68 48 33 80 00       	push   $0x803348
  801167:	6a 43                	push   $0x43
  801169:	68 65 33 80 00       	push   $0x803365
  80116e:	e8 6e f2 ff ff       	call   8003e1 <_panic>

00801173 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80117c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
  801184:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801187:	b8 0a 00 00 00       	mov    $0xa,%eax
  80118c:	89 df                	mov    %ebx,%edi
  80118e:	89 de                	mov    %ebx,%esi
  801190:	cd 30                	int    $0x30
	if(check && ret > 0)
  801192:	85 c0                	test   %eax,%eax
  801194:	7f 08                	jg     80119e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119e:	83 ec 0c             	sub    $0xc,%esp
  8011a1:	50                   	push   %eax
  8011a2:	6a 0a                	push   $0xa
  8011a4:	68 48 33 80 00       	push   $0x803348
  8011a9:	6a 43                	push   $0x43
  8011ab:	68 65 33 80 00       	push   $0x803365
  8011b0:	e8 2c f2 ff ff       	call   8003e1 <_panic>

008011b5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	57                   	push   %edi
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011c6:	be 00 00 00 00       	mov    $0x0,%esi
  8011cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011d1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5f                   	pop    %edi
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    

008011d8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011ee:	89 cb                	mov    %ecx,%ebx
  8011f0:	89 cf                	mov    %ecx,%edi
  8011f2:	89 ce                	mov    %ecx,%esi
  8011f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	7f 08                	jg     801202 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fd:	5b                   	pop    %ebx
  8011fe:	5e                   	pop    %esi
  8011ff:	5f                   	pop    %edi
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	50                   	push   %eax
  801206:	6a 0d                	push   $0xd
  801208:	68 48 33 80 00       	push   $0x803348
  80120d:	6a 43                	push   $0x43
  80120f:	68 65 33 80 00       	push   $0x803365
  801214:	e8 c8 f1 ff ff       	call   8003e1 <_panic>

00801219 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	57                   	push   %edi
  80121d:	56                   	push   %esi
  80121e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80121f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801224:	8b 55 08             	mov    0x8(%ebp),%edx
  801227:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80122f:	89 df                	mov    %ebx,%edi
  801231:	89 de                	mov    %ebx,%esi
  801233:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801235:	5b                   	pop    %ebx
  801236:	5e                   	pop    %esi
  801237:	5f                   	pop    %edi
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	57                   	push   %edi
  80123e:	56                   	push   %esi
  80123f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801240:	b9 00 00 00 00       	mov    $0x0,%ecx
  801245:	8b 55 08             	mov    0x8(%ebp),%edx
  801248:	b8 0f 00 00 00       	mov    $0xf,%eax
  80124d:	89 cb                	mov    %ecx,%ebx
  80124f:	89 cf                	mov    %ecx,%edi
  801251:	89 ce                	mov    %ecx,%esi
  801253:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5f                   	pop    %edi
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	57                   	push   %edi
  80125e:	56                   	push   %esi
  80125f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801260:	ba 00 00 00 00       	mov    $0x0,%edx
  801265:	b8 10 00 00 00       	mov    $0x10,%eax
  80126a:	89 d1                	mov    %edx,%ecx
  80126c:	89 d3                	mov    %edx,%ebx
  80126e:	89 d7                	mov    %edx,%edi
  801270:	89 d6                	mov    %edx,%esi
  801272:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801274:	5b                   	pop    %ebx
  801275:	5e                   	pop    %esi
  801276:	5f                   	pop    %edi
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	57                   	push   %edi
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80127f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801284:	8b 55 08             	mov    0x8(%ebp),%edx
  801287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128a:	b8 11 00 00 00       	mov    $0x11,%eax
  80128f:	89 df                	mov    %ebx,%edi
  801291:	89 de                	mov    %ebx,%esi
  801293:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    

0080129a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	57                   	push   %edi
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ab:	b8 12 00 00 00       	mov    $0x12,%eax
  8012b0:	89 df                	mov    %ebx,%edi
  8012b2:	89 de                	mov    %ebx,%esi
  8012b4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	57                   	push   %edi
  8012bf:	56                   	push   %esi
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cf:	b8 13 00 00 00       	mov    $0x13,%eax
  8012d4:	89 df                	mov    %ebx,%edi
  8012d6:	89 de                	mov    %ebx,%esi
  8012d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	7f 08                	jg     8012e6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5f                   	pop    %edi
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e6:	83 ec 0c             	sub    $0xc,%esp
  8012e9:	50                   	push   %eax
  8012ea:	6a 13                	push   $0x13
  8012ec:	68 48 33 80 00       	push   $0x803348
  8012f1:	6a 43                	push   $0x43
  8012f3:	68 65 33 80 00       	push   $0x803365
  8012f8:	e8 e4 f0 ff ff       	call   8003e1 <_panic>

008012fd <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	57                   	push   %edi
  801301:	56                   	push   %esi
  801302:	53                   	push   %ebx
	asm volatile("int %1\n"
  801303:	b9 00 00 00 00       	mov    $0x0,%ecx
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	b8 14 00 00 00       	mov    $0x14,%eax
  801310:	89 cb                	mov    %ecx,%ebx
  801312:	89 cf                	mov    %ecx,%edi
  801314:	89 ce                	mov    %ecx,%esi
  801316:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801318:	5b                   	pop    %ebx
  801319:	5e                   	pop    %esi
  80131a:	5f                   	pop    %edi
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	53                   	push   %ebx
  801321:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801324:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80132b:	f6 c5 04             	test   $0x4,%ch
  80132e:	75 45                	jne    801375 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801330:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801337:	83 e1 07             	and    $0x7,%ecx
  80133a:	83 f9 07             	cmp    $0x7,%ecx
  80133d:	74 6f                	je     8013ae <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80133f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801346:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80134c:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801352:	0f 84 b6 00 00 00    	je     80140e <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801358:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80135f:	83 e1 05             	and    $0x5,%ecx
  801362:	83 f9 05             	cmp    $0x5,%ecx
  801365:	0f 84 d7 00 00 00    	je     801442 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80136b:	b8 00 00 00 00       	mov    $0x0,%eax
  801370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801373:	c9                   	leave  
  801374:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801375:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80137c:	c1 e2 0c             	shl    $0xc,%edx
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801388:	51                   	push   %ecx
  801389:	52                   	push   %edx
  80138a:	50                   	push   %eax
  80138b:	52                   	push   %edx
  80138c:	6a 00                	push   $0x0
  80138e:	e8 d8 fc ff ff       	call   80106b <sys_page_map>
		if(r < 0)
  801393:	83 c4 20             	add    $0x20,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	79 d1                	jns    80136b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	68 73 33 80 00       	push   $0x803373
  8013a2:	6a 54                	push   $0x54
  8013a4:	68 89 33 80 00       	push   $0x803389
  8013a9:	e8 33 f0 ff ff       	call   8003e1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013ae:	89 d3                	mov    %edx,%ebx
  8013b0:	c1 e3 0c             	shl    $0xc,%ebx
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	68 05 08 00 00       	push   $0x805
  8013bb:	53                   	push   %ebx
  8013bc:	50                   	push   %eax
  8013bd:	53                   	push   %ebx
  8013be:	6a 00                	push   $0x0
  8013c0:	e8 a6 fc ff ff       	call   80106b <sys_page_map>
		if(r < 0)
  8013c5:	83 c4 20             	add    $0x20,%esp
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	78 2e                	js     8013fa <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	68 05 08 00 00       	push   $0x805
  8013d4:	53                   	push   %ebx
  8013d5:	6a 00                	push   $0x0
  8013d7:	53                   	push   %ebx
  8013d8:	6a 00                	push   $0x0
  8013da:	e8 8c fc ff ff       	call   80106b <sys_page_map>
		if(r < 0)
  8013df:	83 c4 20             	add    $0x20,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	79 85                	jns    80136b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	68 73 33 80 00       	push   $0x803373
  8013ee:	6a 5f                	push   $0x5f
  8013f0:	68 89 33 80 00       	push   $0x803389
  8013f5:	e8 e7 ef ff ff       	call   8003e1 <_panic>
			panic("sys_page_map() panic\n");
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	68 73 33 80 00       	push   $0x803373
  801402:	6a 5b                	push   $0x5b
  801404:	68 89 33 80 00       	push   $0x803389
  801409:	e8 d3 ef ff ff       	call   8003e1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80140e:	c1 e2 0c             	shl    $0xc,%edx
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	68 05 08 00 00       	push   $0x805
  801419:	52                   	push   %edx
  80141a:	50                   	push   %eax
  80141b:	52                   	push   %edx
  80141c:	6a 00                	push   $0x0
  80141e:	e8 48 fc ff ff       	call   80106b <sys_page_map>
		if(r < 0)
  801423:	83 c4 20             	add    $0x20,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	0f 89 3d ff ff ff    	jns    80136b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 73 33 80 00       	push   $0x803373
  801436:	6a 66                	push   $0x66
  801438:	68 89 33 80 00       	push   $0x803389
  80143d:	e8 9f ef ff ff       	call   8003e1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801442:	c1 e2 0c             	shl    $0xc,%edx
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	6a 05                	push   $0x5
  80144a:	52                   	push   %edx
  80144b:	50                   	push   %eax
  80144c:	52                   	push   %edx
  80144d:	6a 00                	push   $0x0
  80144f:	e8 17 fc ff ff       	call   80106b <sys_page_map>
		if(r < 0)
  801454:	83 c4 20             	add    $0x20,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	0f 89 0c ff ff ff    	jns    80136b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80145f:	83 ec 04             	sub    $0x4,%esp
  801462:	68 73 33 80 00       	push   $0x803373
  801467:	6a 6d                	push   $0x6d
  801469:	68 89 33 80 00       	push   $0x803389
  80146e:	e8 6e ef ff ff       	call   8003e1 <_panic>

00801473 <pgfault>:
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	53                   	push   %ebx
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80147d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80147f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801483:	0f 84 99 00 00 00    	je     801522 <pgfault+0xaf>
  801489:	89 c2                	mov    %eax,%edx
  80148b:	c1 ea 16             	shr    $0x16,%edx
  80148e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801495:	f6 c2 01             	test   $0x1,%dl
  801498:	0f 84 84 00 00 00    	je     801522 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	c1 ea 0c             	shr    $0xc,%edx
  8014a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014aa:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8014b0:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8014b6:	75 6a                	jne    801522 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8014b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014bd:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	6a 07                	push   $0x7
  8014c4:	68 00 f0 7f 00       	push   $0x7ff000
  8014c9:	6a 00                	push   $0x0
  8014cb:	e8 58 fb ff ff       	call   801028 <sys_page_alloc>
	if(ret < 0)
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 5f                	js     801536 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	68 00 10 00 00       	push   $0x1000
  8014df:	53                   	push   %ebx
  8014e0:	68 00 f0 7f 00       	push   $0x7ff000
  8014e5:	e8 3c f9 ff ff       	call   800e26 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8014ea:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8014f1:	53                   	push   %ebx
  8014f2:	6a 00                	push   $0x0
  8014f4:	68 00 f0 7f 00       	push   $0x7ff000
  8014f9:	6a 00                	push   $0x0
  8014fb:	e8 6b fb ff ff       	call   80106b <sys_page_map>
	if(ret < 0)
  801500:	83 c4 20             	add    $0x20,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 43                	js     80154a <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	68 00 f0 7f 00       	push   $0x7ff000
  80150f:	6a 00                	push   $0x0
  801511:	e8 97 fb ff ff       	call   8010ad <sys_page_unmap>
	if(ret < 0)
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 41                	js     80155e <pgfault+0xeb>
}
  80151d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801520:	c9                   	leave  
  801521:	c3                   	ret    
		panic("panic at pgfault()\n");
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	68 94 33 80 00       	push   $0x803394
  80152a:	6a 26                	push   $0x26
  80152c:	68 89 33 80 00       	push   $0x803389
  801531:	e8 ab ee ff ff       	call   8003e1 <_panic>
		panic("panic in sys_page_alloc()\n");
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	68 a8 33 80 00       	push   $0x8033a8
  80153e:	6a 31                	push   $0x31
  801540:	68 89 33 80 00       	push   $0x803389
  801545:	e8 97 ee ff ff       	call   8003e1 <_panic>
		panic("panic in sys_page_map()\n");
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 c3 33 80 00       	push   $0x8033c3
  801552:	6a 36                	push   $0x36
  801554:	68 89 33 80 00       	push   $0x803389
  801559:	e8 83 ee ff ff       	call   8003e1 <_panic>
		panic("panic in sys_page_unmap()\n");
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	68 dc 33 80 00       	push   $0x8033dc
  801566:	6a 39                	push   $0x39
  801568:	68 89 33 80 00       	push   $0x803389
  80156d:	e8 6f ee ff ff       	call   8003e1 <_panic>

00801572 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	57                   	push   %edi
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
  801578:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80157b:	68 73 14 80 00       	push   $0x801473
  801580:	e8 2d 14 00 00       	call   8029b2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801585:	b8 07 00 00 00       	mov    $0x7,%eax
  80158a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 2a                	js     8015bd <fork+0x4b>
  801593:	89 c6                	mov    %eax,%esi
  801595:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801597:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80159c:	75 4b                	jne    8015e9 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80159e:	e8 47 fa ff ff       	call   800fea <sys_getenvid>
  8015a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015a8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015b3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015b8:	e9 90 00 00 00       	jmp    80164d <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	68 f8 33 80 00       	push   $0x8033f8
  8015c5:	68 8c 00 00 00       	push   $0x8c
  8015ca:	68 89 33 80 00       	push   $0x803389
  8015cf:	e8 0d ee ff ff       	call   8003e1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8015d4:	89 f8                	mov    %edi,%eax
  8015d6:	e8 42 fd ff ff       	call   80131d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015e1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8015e7:	74 26                	je     80160f <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8015e9:	89 d8                	mov    %ebx,%eax
  8015eb:	c1 e8 16             	shr    $0x16,%eax
  8015ee:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f5:	a8 01                	test   $0x1,%al
  8015f7:	74 e2                	je     8015db <fork+0x69>
  8015f9:	89 da                	mov    %ebx,%edx
  8015fb:	c1 ea 0c             	shr    $0xc,%edx
  8015fe:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801605:	83 e0 05             	and    $0x5,%eax
  801608:	83 f8 05             	cmp    $0x5,%eax
  80160b:	75 ce                	jne    8015db <fork+0x69>
  80160d:	eb c5                	jmp    8015d4 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	6a 07                	push   $0x7
  801614:	68 00 f0 bf ee       	push   $0xeebff000
  801619:	56                   	push   %esi
  80161a:	e8 09 fa ff ff       	call   801028 <sys_page_alloc>
	if(ret < 0)
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	85 c0                	test   %eax,%eax
  801624:	78 31                	js     801657 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	68 21 2a 80 00       	push   $0x802a21
  80162e:	56                   	push   %esi
  80162f:	e8 3f fb ff ff       	call   801173 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 33                	js     80166e <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	6a 02                	push   $0x2
  801640:	56                   	push   %esi
  801641:	e8 a9 fa ff ff       	call   8010ef <sys_env_set_status>
	if(ret < 0)
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 38                	js     801685 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80164d:	89 f0                	mov    %esi,%eax
  80164f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5f                   	pop    %edi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	68 a8 33 80 00       	push   $0x8033a8
  80165f:	68 98 00 00 00       	push   $0x98
  801664:	68 89 33 80 00       	push   $0x803389
  801669:	e8 73 ed ff ff       	call   8003e1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	68 1c 34 80 00       	push   $0x80341c
  801676:	68 9b 00 00 00       	push   $0x9b
  80167b:	68 89 33 80 00       	push   $0x803389
  801680:	e8 5c ed ff ff       	call   8003e1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	68 44 34 80 00       	push   $0x803444
  80168d:	68 9e 00 00 00       	push   $0x9e
  801692:	68 89 33 80 00       	push   $0x803389
  801697:	e8 45 ed ff ff       	call   8003e1 <_panic>

0080169c <sfork>:

// Challenge!
int
sfork(void)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8016a5:	68 73 14 80 00       	push   $0x801473
  8016aa:	e8 03 13 00 00       	call   8029b2 <set_pgfault_handler>
  8016af:	b8 07 00 00 00       	mov    $0x7,%eax
  8016b4:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 2a                	js     8016e7 <sfork+0x4b>
  8016bd:	89 c7                	mov    %eax,%edi
  8016bf:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016c1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8016c6:	75 58                	jne    801720 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8016c8:	e8 1d f9 ff ff       	call   800fea <sys_getenvid>
  8016cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016d2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8016d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016dd:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8016e2:	e9 d4 00 00 00       	jmp    8017bb <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	68 f8 33 80 00       	push   $0x8033f8
  8016ef:	68 af 00 00 00       	push   $0xaf
  8016f4:	68 89 33 80 00       	push   $0x803389
  8016f9:	e8 e3 ec ff ff       	call   8003e1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8016fe:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801703:	89 f0                	mov    %esi,%eax
  801705:	e8 13 fc ff ff       	call   80131d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80170a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801710:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801716:	77 65                	ja     80177d <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801718:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80171e:	74 de                	je     8016fe <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801720:	89 d8                	mov    %ebx,%eax
  801722:	c1 e8 16             	shr    $0x16,%eax
  801725:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80172c:	a8 01                	test   $0x1,%al
  80172e:	74 da                	je     80170a <sfork+0x6e>
  801730:	89 da                	mov    %ebx,%edx
  801732:	c1 ea 0c             	shr    $0xc,%edx
  801735:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80173c:	83 e0 05             	and    $0x5,%eax
  80173f:	83 f8 05             	cmp    $0x5,%eax
  801742:	75 c6                	jne    80170a <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801744:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80174b:	c1 e2 0c             	shl    $0xc,%edx
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	83 e0 07             	and    $0x7,%eax
  801754:	50                   	push   %eax
  801755:	52                   	push   %edx
  801756:	56                   	push   %esi
  801757:	52                   	push   %edx
  801758:	6a 00                	push   $0x0
  80175a:	e8 0c f9 ff ff       	call   80106b <sys_page_map>
  80175f:	83 c4 20             	add    $0x20,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	74 a4                	je     80170a <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 73 33 80 00       	push   $0x803373
  80176e:	68 ba 00 00 00       	push   $0xba
  801773:	68 89 33 80 00       	push   $0x803389
  801778:	e8 64 ec ff ff       	call   8003e1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	6a 07                	push   $0x7
  801782:	68 00 f0 bf ee       	push   $0xeebff000
  801787:	57                   	push   %edi
  801788:	e8 9b f8 ff ff       	call   801028 <sys_page_alloc>
	if(ret < 0)
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	85 c0                	test   %eax,%eax
  801792:	78 31                	js     8017c5 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801794:	83 ec 08             	sub    $0x8,%esp
  801797:	68 21 2a 80 00       	push   $0x802a21
  80179c:	57                   	push   %edi
  80179d:	e8 d1 f9 ff ff       	call   801173 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 33                	js     8017dc <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	6a 02                	push   $0x2
  8017ae:	57                   	push   %edi
  8017af:	e8 3b f9 ff ff       	call   8010ef <sys_env_set_status>
	if(ret < 0)
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 38                	js     8017f3 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8017bb:	89 f8                	mov    %edi,%eax
  8017bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5e                   	pop    %esi
  8017c2:	5f                   	pop    %edi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	68 a8 33 80 00       	push   $0x8033a8
  8017cd:	68 c0 00 00 00       	push   $0xc0
  8017d2:	68 89 33 80 00       	push   $0x803389
  8017d7:	e8 05 ec ff ff       	call   8003e1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 1c 34 80 00       	push   $0x80341c
  8017e4:	68 c3 00 00 00       	push   $0xc3
  8017e9:	68 89 33 80 00       	push   $0x803389
  8017ee:	e8 ee eb ff ff       	call   8003e1 <_panic>
		panic("panic in sys_env_set_status()\n");
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	68 44 34 80 00       	push   $0x803444
  8017fb:	68 c6 00 00 00       	push   $0xc6
  801800:	68 89 33 80 00       	push   $0x803389
  801805:	e8 d7 eb ff ff       	call   8003e1 <_panic>

0080180a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	05 00 00 00 30       	add    $0x30000000,%eax
  801815:	c1 e8 0c             	shr    $0xc,%eax
}
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80182a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801839:	89 c2                	mov    %eax,%edx
  80183b:	c1 ea 16             	shr    $0x16,%edx
  80183e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801845:	f6 c2 01             	test   $0x1,%dl
  801848:	74 2d                	je     801877 <fd_alloc+0x46>
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	c1 ea 0c             	shr    $0xc,%edx
  80184f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801856:	f6 c2 01             	test   $0x1,%dl
  801859:	74 1c                	je     801877 <fd_alloc+0x46>
  80185b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801860:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801865:	75 d2                	jne    801839 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801870:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801875:	eb 0a                	jmp    801881 <fd_alloc+0x50>
			*fd_store = fd;
  801877:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80187c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801889:	83 f8 1f             	cmp    $0x1f,%eax
  80188c:	77 30                	ja     8018be <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80188e:	c1 e0 0c             	shl    $0xc,%eax
  801891:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801896:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80189c:	f6 c2 01             	test   $0x1,%dl
  80189f:	74 24                	je     8018c5 <fd_lookup+0x42>
  8018a1:	89 c2                	mov    %eax,%edx
  8018a3:	c1 ea 0c             	shr    $0xc,%edx
  8018a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018ad:	f6 c2 01             	test   $0x1,%dl
  8018b0:	74 1a                	je     8018cc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	89 02                	mov    %eax,(%edx)
	return 0;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    
		return -E_INVAL;
  8018be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c3:	eb f7                	jmp    8018bc <fd_lookup+0x39>
		return -E_INVAL;
  8018c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ca:	eb f0                	jmp    8018bc <fd_lookup+0x39>
  8018cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d1:	eb e9                	jmp    8018bc <fd_lookup+0x39>

008018d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 08             	sub    $0x8,%esp
  8018d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e1:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018e6:	39 08                	cmp    %ecx,(%eax)
  8018e8:	74 38                	je     801922 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8018ea:	83 c2 01             	add    $0x1,%edx
  8018ed:	8b 04 95 e0 34 80 00 	mov    0x8034e0(,%edx,4),%eax
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	75 ee                	jne    8018e6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018f8:	a1 08 50 80 00       	mov    0x805008,%eax
  8018fd:	8b 40 48             	mov    0x48(%eax),%eax
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	51                   	push   %ecx
  801904:	50                   	push   %eax
  801905:	68 64 34 80 00       	push   $0x803464
  80190a:	e8 c8 eb ff ff       	call   8004d7 <cprintf>
	*dev = 0;
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    
			*dev = devtab[i];
  801922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801925:	89 01                	mov    %eax,(%ecx)
			return 0;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	eb f2                	jmp    801920 <dev_lookup+0x4d>

0080192e <fd_close>:
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	57                   	push   %edi
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	83 ec 24             	sub    $0x24,%esp
  801937:	8b 75 08             	mov    0x8(%ebp),%esi
  80193a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80193d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801940:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801941:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801947:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80194a:	50                   	push   %eax
  80194b:	e8 33 ff ff ff       	call   801883 <fd_lookup>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	78 05                	js     80195e <fd_close+0x30>
	    || fd != fd2)
  801959:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80195c:	74 16                	je     801974 <fd_close+0x46>
		return (must_exist ? r : 0);
  80195e:	89 f8                	mov    %edi,%eax
  801960:	84 c0                	test   %al,%al
  801962:	b8 00 00 00 00       	mov    $0x0,%eax
  801967:	0f 44 d8             	cmove  %eax,%ebx
}
  80196a:	89 d8                	mov    %ebx,%eax
  80196c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5f                   	pop    %edi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80197a:	50                   	push   %eax
  80197b:	ff 36                	pushl  (%esi)
  80197d:	e8 51 ff ff ff       	call   8018d3 <dev_lookup>
  801982:	89 c3                	mov    %eax,%ebx
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	85 c0                	test   %eax,%eax
  801989:	78 1a                	js     8019a5 <fd_close+0x77>
		if (dev->dev_close)
  80198b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80198e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801991:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801996:	85 c0                	test   %eax,%eax
  801998:	74 0b                	je     8019a5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	56                   	push   %esi
  80199e:	ff d0                	call   *%eax
  8019a0:	89 c3                	mov    %eax,%ebx
  8019a2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	56                   	push   %esi
  8019a9:	6a 00                	push   $0x0
  8019ab:	e8 fd f6 ff ff       	call   8010ad <sys_page_unmap>
	return r;
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	eb b5                	jmp    80196a <fd_close+0x3c>

008019b5 <close>:

int
close(int fdnum)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019be:	50                   	push   %eax
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	e8 bc fe ff ff       	call   801883 <fd_lookup>
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	79 02                	jns    8019d0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    
		return fd_close(fd, 1);
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	6a 01                	push   $0x1
  8019d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d8:	e8 51 ff ff ff       	call   80192e <fd_close>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	eb ec                	jmp    8019ce <close+0x19>

008019e2 <close_all>:

void
close_all(void)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	53                   	push   %ebx
  8019e6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019ee:	83 ec 0c             	sub    $0xc,%esp
  8019f1:	53                   	push   %ebx
  8019f2:	e8 be ff ff ff       	call   8019b5 <close>
	for (i = 0; i < MAXFD; i++)
  8019f7:	83 c3 01             	add    $0x1,%ebx
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	83 fb 20             	cmp    $0x20,%ebx
  801a00:	75 ec                	jne    8019ee <close_all+0xc>
}
  801a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	57                   	push   %edi
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a13:	50                   	push   %eax
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 67 fe ff ff       	call   801883 <fd_lookup>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	0f 88 81 00 00 00    	js     801aaa <dup+0xa3>
		return r;
	close(newfdnum);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	e8 81 ff ff ff       	call   8019b5 <close>

	newfd = INDEX2FD(newfdnum);
  801a34:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a37:	c1 e6 0c             	shl    $0xc,%esi
  801a3a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801a40:	83 c4 04             	add    $0x4,%esp
  801a43:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a46:	e8 cf fd ff ff       	call   80181a <fd2data>
  801a4b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a4d:	89 34 24             	mov    %esi,(%esp)
  801a50:	e8 c5 fd ff ff       	call   80181a <fd2data>
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a5a:	89 d8                	mov    %ebx,%eax
  801a5c:	c1 e8 16             	shr    $0x16,%eax
  801a5f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a66:	a8 01                	test   $0x1,%al
  801a68:	74 11                	je     801a7b <dup+0x74>
  801a6a:	89 d8                	mov    %ebx,%eax
  801a6c:	c1 e8 0c             	shr    $0xc,%eax
  801a6f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a76:	f6 c2 01             	test   $0x1,%dl
  801a79:	75 39                	jne    801ab4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a7e:	89 d0                	mov    %edx,%eax
  801a80:	c1 e8 0c             	shr    $0xc,%eax
  801a83:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	25 07 0e 00 00       	and    $0xe07,%eax
  801a92:	50                   	push   %eax
  801a93:	56                   	push   %esi
  801a94:	6a 00                	push   $0x0
  801a96:	52                   	push   %edx
  801a97:	6a 00                	push   $0x0
  801a99:	e8 cd f5 ff ff       	call   80106b <sys_page_map>
  801a9e:	89 c3                	mov    %eax,%ebx
  801aa0:	83 c4 20             	add    $0x20,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 31                	js     801ad8 <dup+0xd1>
		goto err;

	return newfdnum;
  801aa7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801aaa:	89 d8                	mov    %ebx,%eax
  801aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ab4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801abb:	83 ec 0c             	sub    $0xc,%esp
  801abe:	25 07 0e 00 00       	and    $0xe07,%eax
  801ac3:	50                   	push   %eax
  801ac4:	57                   	push   %edi
  801ac5:	6a 00                	push   $0x0
  801ac7:	53                   	push   %ebx
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 9c f5 ff ff       	call   80106b <sys_page_map>
  801acf:	89 c3                	mov    %eax,%ebx
  801ad1:	83 c4 20             	add    $0x20,%esp
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	79 a3                	jns    801a7b <dup+0x74>
	sys_page_unmap(0, newfd);
  801ad8:	83 ec 08             	sub    $0x8,%esp
  801adb:	56                   	push   %esi
  801adc:	6a 00                	push   $0x0
  801ade:	e8 ca f5 ff ff       	call   8010ad <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ae3:	83 c4 08             	add    $0x8,%esp
  801ae6:	57                   	push   %edi
  801ae7:	6a 00                	push   $0x0
  801ae9:	e8 bf f5 ff ff       	call   8010ad <sys_page_unmap>
	return r;
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	eb b7                	jmp    801aaa <dup+0xa3>

00801af3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	53                   	push   %ebx
  801af7:	83 ec 1c             	sub    $0x1c,%esp
  801afa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801afd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b00:	50                   	push   %eax
  801b01:	53                   	push   %ebx
  801b02:	e8 7c fd ff ff       	call   801883 <fd_lookup>
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 3f                	js     801b4d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b14:	50                   	push   %eax
  801b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b18:	ff 30                	pushl  (%eax)
  801b1a:	e8 b4 fd ff ff       	call   8018d3 <dev_lookup>
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 27                	js     801b4d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b29:	8b 42 08             	mov    0x8(%edx),%eax
  801b2c:	83 e0 03             	and    $0x3,%eax
  801b2f:	83 f8 01             	cmp    $0x1,%eax
  801b32:	74 1e                	je     801b52 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b37:	8b 40 08             	mov    0x8(%eax),%eax
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	74 35                	je     801b73 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	ff 75 10             	pushl  0x10(%ebp)
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	52                   	push   %edx
  801b48:	ff d0                	call   *%eax
  801b4a:	83 c4 10             	add    $0x10,%esp
}
  801b4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b52:	a1 08 50 80 00       	mov    0x805008,%eax
  801b57:	8b 40 48             	mov    0x48(%eax),%eax
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	53                   	push   %ebx
  801b5e:	50                   	push   %eax
  801b5f:	68 a5 34 80 00       	push   $0x8034a5
  801b64:	e8 6e e9 ff ff       	call   8004d7 <cprintf>
		return -E_INVAL;
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b71:	eb da                	jmp    801b4d <read+0x5a>
		return -E_NOT_SUPP;
  801b73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b78:	eb d3                	jmp    801b4d <read+0x5a>

00801b7a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	57                   	push   %edi
  801b7e:	56                   	push   %esi
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b86:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b89:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b8e:	39 f3                	cmp    %esi,%ebx
  801b90:	73 23                	jae    801bb5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	89 f0                	mov    %esi,%eax
  801b97:	29 d8                	sub    %ebx,%eax
  801b99:	50                   	push   %eax
  801b9a:	89 d8                	mov    %ebx,%eax
  801b9c:	03 45 0c             	add    0xc(%ebp),%eax
  801b9f:	50                   	push   %eax
  801ba0:	57                   	push   %edi
  801ba1:	e8 4d ff ff ff       	call   801af3 <read>
		if (m < 0)
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	78 06                	js     801bb3 <readn+0x39>
			return m;
		if (m == 0)
  801bad:	74 06                	je     801bb5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801baf:	01 c3                	add    %eax,%ebx
  801bb1:	eb db                	jmp    801b8e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bb3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801bb5:	89 d8                	mov    %ebx,%eax
  801bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5f                   	pop    %edi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	53                   	push   %ebx
  801bc3:	83 ec 1c             	sub    $0x1c,%esp
  801bc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bcc:	50                   	push   %eax
  801bcd:	53                   	push   %ebx
  801bce:	e8 b0 fc ff ff       	call   801883 <fd_lookup>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	78 3a                	js     801c14 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bda:	83 ec 08             	sub    $0x8,%esp
  801bdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be0:	50                   	push   %eax
  801be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be4:	ff 30                	pushl  (%eax)
  801be6:	e8 e8 fc ff ff       	call   8018d3 <dev_lookup>
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 22                	js     801c14 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bf9:	74 1e                	je     801c19 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfe:	8b 52 0c             	mov    0xc(%edx),%edx
  801c01:	85 d2                	test   %edx,%edx
  801c03:	74 35                	je     801c3a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	ff 75 10             	pushl  0x10(%ebp)
  801c0b:	ff 75 0c             	pushl  0xc(%ebp)
  801c0e:	50                   	push   %eax
  801c0f:	ff d2                	call   *%edx
  801c11:	83 c4 10             	add    $0x10,%esp
}
  801c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c19:	a1 08 50 80 00       	mov    0x805008,%eax
  801c1e:	8b 40 48             	mov    0x48(%eax),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	53                   	push   %ebx
  801c25:	50                   	push   %eax
  801c26:	68 c1 34 80 00       	push   $0x8034c1
  801c2b:	e8 a7 e8 ff ff       	call   8004d7 <cprintf>
		return -E_INVAL;
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c38:	eb da                	jmp    801c14 <write+0x55>
		return -E_NOT_SUPP;
  801c3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3f:	eb d3                	jmp    801c14 <write+0x55>

00801c41 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4a:	50                   	push   %eax
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 30 fc ff ff       	call   801883 <fd_lookup>
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 0e                	js     801c68 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c60:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	53                   	push   %ebx
  801c6e:	83 ec 1c             	sub    $0x1c,%esp
  801c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c77:	50                   	push   %eax
  801c78:	53                   	push   %ebx
  801c79:	e8 05 fc ff ff       	call   801883 <fd_lookup>
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	85 c0                	test   %eax,%eax
  801c83:	78 37                	js     801cbc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8b:	50                   	push   %eax
  801c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8f:	ff 30                	pushl  (%eax)
  801c91:	e8 3d fc ff ff       	call   8018d3 <dev_lookup>
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 1f                	js     801cbc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ca4:	74 1b                	je     801cc1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca9:	8b 52 18             	mov    0x18(%edx),%edx
  801cac:	85 d2                	test   %edx,%edx
  801cae:	74 32                	je     801ce2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cb0:	83 ec 08             	sub    $0x8,%esp
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	50                   	push   %eax
  801cb7:	ff d2                	call   *%edx
  801cb9:	83 c4 10             	add    $0x10,%esp
}
  801cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    
			thisenv->env_id, fdnum);
  801cc1:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801cc6:	8b 40 48             	mov    0x48(%eax),%eax
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	53                   	push   %ebx
  801ccd:	50                   	push   %eax
  801cce:	68 84 34 80 00       	push   $0x803484
  801cd3:	e8 ff e7 ff ff       	call   8004d7 <cprintf>
		return -E_INVAL;
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ce0:	eb da                	jmp    801cbc <ftruncate+0x52>
		return -E_NOT_SUPP;
  801ce2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ce7:	eb d3                	jmp    801cbc <ftruncate+0x52>

00801ce9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	53                   	push   %ebx
  801ced:	83 ec 1c             	sub    $0x1c,%esp
  801cf0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cf3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cf6:	50                   	push   %eax
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	e8 84 fb ff ff       	call   801883 <fd_lookup>
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 4b                	js     801d51 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d06:	83 ec 08             	sub    $0x8,%esp
  801d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0c:	50                   	push   %eax
  801d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d10:	ff 30                	pushl  (%eax)
  801d12:	e8 bc fb ff ff       	call   8018d3 <dev_lookup>
  801d17:	83 c4 10             	add    $0x10,%esp
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	78 33                	js     801d51 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d25:	74 2f                	je     801d56 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d27:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d2a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d31:	00 00 00 
	stat->st_isdir = 0;
  801d34:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d3b:	00 00 00 
	stat->st_dev = dev;
  801d3e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d44:	83 ec 08             	sub    $0x8,%esp
  801d47:	53                   	push   %ebx
  801d48:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4b:	ff 50 14             	call   *0x14(%eax)
  801d4e:	83 c4 10             	add    $0x10,%esp
}
  801d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    
		return -E_NOT_SUPP;
  801d56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d5b:	eb f4                	jmp    801d51 <fstat+0x68>

00801d5d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	56                   	push   %esi
  801d61:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d62:	83 ec 08             	sub    $0x8,%esp
  801d65:	6a 00                	push   $0x0
  801d67:	ff 75 08             	pushl  0x8(%ebp)
  801d6a:	e8 22 02 00 00       	call   801f91 <open>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	78 1b                	js     801d93 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d78:	83 ec 08             	sub    $0x8,%esp
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	50                   	push   %eax
  801d7f:	e8 65 ff ff ff       	call   801ce9 <fstat>
  801d84:	89 c6                	mov    %eax,%esi
	close(fd);
  801d86:	89 1c 24             	mov    %ebx,(%esp)
  801d89:	e8 27 fc ff ff       	call   8019b5 <close>
	return r;
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	89 f3                	mov    %esi,%ebx
}
  801d93:	89 d8                	mov    %ebx,%eax
  801d95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d98:	5b                   	pop    %ebx
  801d99:	5e                   	pop    %esi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    

00801d9c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	89 c6                	mov    %eax,%esi
  801da3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801da5:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801dac:	74 27                	je     801dd5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801dae:	6a 07                	push   $0x7
  801db0:	68 00 60 80 00       	push   $0x806000
  801db5:	56                   	push   %esi
  801db6:	ff 35 00 50 80 00    	pushl  0x805000
  801dbc:	e8 ef 0c 00 00       	call   802ab0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dc1:	83 c4 0c             	add    $0xc,%esp
  801dc4:	6a 00                	push   $0x0
  801dc6:	53                   	push   %ebx
  801dc7:	6a 00                	push   $0x0
  801dc9:	e8 79 0c 00 00       	call   802a47 <ipc_recv>
}
  801dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	6a 01                	push   $0x1
  801dda:	e8 29 0d 00 00       	call   802b08 <ipc_find_env>
  801ddf:	a3 00 50 80 00       	mov    %eax,0x805000
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	eb c5                	jmp    801dae <fsipc+0x12>

00801de9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e02:	ba 00 00 00 00       	mov    $0x0,%edx
  801e07:	b8 02 00 00 00       	mov    $0x2,%eax
  801e0c:	e8 8b ff ff ff       	call   801d9c <fsipc>
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <devfile_flush>:
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e24:	ba 00 00 00 00       	mov    $0x0,%edx
  801e29:	b8 06 00 00 00       	mov    $0x6,%eax
  801e2e:	e8 69 ff ff ff       	call   801d9c <fsipc>
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <devfile_stat>:
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	53                   	push   %ebx
  801e39:	83 ec 04             	sub    $0x4,%esp
  801e3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	8b 40 0c             	mov    0xc(%eax),%eax
  801e45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e54:	e8 43 ff ff ff       	call   801d9c <fsipc>
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 2c                	js     801e89 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e5d:	83 ec 08             	sub    $0x8,%esp
  801e60:	68 00 60 80 00       	push   $0x806000
  801e65:	53                   	push   %ebx
  801e66:	e8 cb ed ff ff       	call   800c36 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e6b:	a1 80 60 80 00       	mov    0x806080,%eax
  801e70:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e76:	a1 84 60 80 00       	mov    0x806084,%eax
  801e7b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <devfile_write>:
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	53                   	push   %ebx
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ea3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ea9:	53                   	push   %ebx
  801eaa:	ff 75 0c             	pushl  0xc(%ebp)
  801ead:	68 08 60 80 00       	push   $0x806008
  801eb2:	e8 6f ef ff ff       	call   800e26 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebc:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec1:	e8 d6 fe ff ff       	call   801d9c <fsipc>
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	78 0b                	js     801ed8 <devfile_write+0x4a>
	assert(r <= n);
  801ecd:	39 d8                	cmp    %ebx,%eax
  801ecf:	77 0c                	ja     801edd <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ed1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ed6:	7f 1e                	jg     801ef6 <devfile_write+0x68>
}
  801ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    
	assert(r <= n);
  801edd:	68 f4 34 80 00       	push   $0x8034f4
  801ee2:	68 fb 34 80 00       	push   $0x8034fb
  801ee7:	68 98 00 00 00       	push   $0x98
  801eec:	68 10 35 80 00       	push   $0x803510
  801ef1:	e8 eb e4 ff ff       	call   8003e1 <_panic>
	assert(r <= PGSIZE);
  801ef6:	68 1b 35 80 00       	push   $0x80351b
  801efb:	68 fb 34 80 00       	push   $0x8034fb
  801f00:	68 99 00 00 00       	push   $0x99
  801f05:	68 10 35 80 00       	push   $0x803510
  801f0a:	e8 d2 e4 ff ff       	call   8003e1 <_panic>

00801f0f <devfile_read>:
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	56                   	push   %esi
  801f13:	53                   	push   %ebx
  801f14:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f22:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f28:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2d:	b8 03 00 00 00       	mov    $0x3,%eax
  801f32:	e8 65 fe ff ff       	call   801d9c <fsipc>
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	78 1f                	js     801f5c <devfile_read+0x4d>
	assert(r <= n);
  801f3d:	39 f0                	cmp    %esi,%eax
  801f3f:	77 24                	ja     801f65 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f41:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f46:	7f 33                	jg     801f7b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	50                   	push   %eax
  801f4c:	68 00 60 80 00       	push   $0x806000
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	e8 6b ee ff ff       	call   800dc4 <memmove>
	return r;
  801f59:	83 c4 10             	add    $0x10,%esp
}
  801f5c:	89 d8                	mov    %ebx,%eax
  801f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5d                   	pop    %ebp
  801f64:	c3                   	ret    
	assert(r <= n);
  801f65:	68 f4 34 80 00       	push   $0x8034f4
  801f6a:	68 fb 34 80 00       	push   $0x8034fb
  801f6f:	6a 7c                	push   $0x7c
  801f71:	68 10 35 80 00       	push   $0x803510
  801f76:	e8 66 e4 ff ff       	call   8003e1 <_panic>
	assert(r <= PGSIZE);
  801f7b:	68 1b 35 80 00       	push   $0x80351b
  801f80:	68 fb 34 80 00       	push   $0x8034fb
  801f85:	6a 7d                	push   $0x7d
  801f87:	68 10 35 80 00       	push   $0x803510
  801f8c:	e8 50 e4 ff ff       	call   8003e1 <_panic>

00801f91 <open>:
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	56                   	push   %esi
  801f95:	53                   	push   %ebx
  801f96:	83 ec 1c             	sub    $0x1c,%esp
  801f99:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f9c:	56                   	push   %esi
  801f9d:	e8 5b ec ff ff       	call   800bfd <strlen>
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801faa:	7f 6c                	jg     802018 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb2:	50                   	push   %eax
  801fb3:	e8 79 f8 ff ff       	call   801831 <fd_alloc>
  801fb8:	89 c3                	mov    %eax,%ebx
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 3c                	js     801ffd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	56                   	push   %esi
  801fc5:	68 00 60 80 00       	push   $0x806000
  801fca:	e8 67 ec ff ff       	call   800c36 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fda:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdf:	e8 b8 fd ff ff       	call   801d9c <fsipc>
  801fe4:	89 c3                	mov    %eax,%ebx
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 19                	js     802006 <open+0x75>
	return fd2num(fd);
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff3:	e8 12 f8 ff ff       	call   80180a <fd2num>
  801ff8:	89 c3                	mov    %eax,%ebx
  801ffa:	83 c4 10             	add    $0x10,%esp
}
  801ffd:	89 d8                	mov    %ebx,%eax
  801fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802002:	5b                   	pop    %ebx
  802003:	5e                   	pop    %esi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
		fd_close(fd, 0);
  802006:	83 ec 08             	sub    $0x8,%esp
  802009:	6a 00                	push   $0x0
  80200b:	ff 75 f4             	pushl  -0xc(%ebp)
  80200e:	e8 1b f9 ff ff       	call   80192e <fd_close>
		return r;
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	eb e5                	jmp    801ffd <open+0x6c>
		return -E_BAD_PATH;
  802018:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80201d:	eb de                	jmp    801ffd <open+0x6c>

0080201f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802025:	ba 00 00 00 00       	mov    $0x0,%edx
  80202a:	b8 08 00 00 00       	mov    $0x8,%eax
  80202f:	e8 68 fd ff ff       	call   801d9c <fsipc>
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80203c:	68 27 35 80 00       	push   $0x803527
  802041:	ff 75 0c             	pushl  0xc(%ebp)
  802044:	e8 ed eb ff ff       	call   800c36 <strcpy>
	return 0;
}
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <devsock_close>:
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	53                   	push   %ebx
  802054:	83 ec 10             	sub    $0x10,%esp
  802057:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80205a:	53                   	push   %ebx
  80205b:	e8 e7 0a 00 00       	call   802b47 <pageref>
  802060:	83 c4 10             	add    $0x10,%esp
		return 0;
  802063:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802068:	83 f8 01             	cmp    $0x1,%eax
  80206b:	74 07                	je     802074 <devsock_close+0x24>
}
  80206d:	89 d0                	mov    %edx,%eax
  80206f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802072:	c9                   	leave  
  802073:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	ff 73 0c             	pushl  0xc(%ebx)
  80207a:	e8 b9 02 00 00       	call   802338 <nsipc_close>
  80207f:	89 c2                	mov    %eax,%edx
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	eb e7                	jmp    80206d <devsock_close+0x1d>

00802086 <devsock_write>:
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80208c:	6a 00                	push   $0x0
  80208e:	ff 75 10             	pushl  0x10(%ebp)
  802091:	ff 75 0c             	pushl  0xc(%ebp)
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	ff 70 0c             	pushl  0xc(%eax)
  80209a:	e8 76 03 00 00       	call   802415 <nsipc_send>
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <devsock_read>:
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	ff 75 10             	pushl  0x10(%ebp)
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	ff 70 0c             	pushl  0xc(%eax)
  8020b5:	e8 ef 02 00 00       	call   8023a9 <nsipc_recv>
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <fd2sockid>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020c5:	52                   	push   %edx
  8020c6:	50                   	push   %eax
  8020c7:	e8 b7 f7 ff ff       	call   801883 <fd_lookup>
  8020cc:	83 c4 10             	add    $0x10,%esp
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	78 10                	js     8020e3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  8020dc:	39 08                	cmp    %ecx,(%eax)
  8020de:	75 05                	jne    8020e5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020e0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    
		return -E_NOT_SUPP;
  8020e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020ea:	eb f7                	jmp    8020e3 <fd2sockid+0x27>

008020ec <alloc_sockfd>:
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	56                   	push   %esi
  8020f0:	53                   	push   %ebx
  8020f1:	83 ec 1c             	sub    $0x1c,%esp
  8020f4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f9:	50                   	push   %eax
  8020fa:	e8 32 f7 ff ff       	call   801831 <fd_alloc>
  8020ff:	89 c3                	mov    %eax,%ebx
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	85 c0                	test   %eax,%eax
  802106:	78 43                	js     80214b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	68 07 04 00 00       	push   $0x407
  802110:	ff 75 f4             	pushl  -0xc(%ebp)
  802113:	6a 00                	push   $0x0
  802115:	e8 0e ef ff ff       	call   801028 <sys_page_alloc>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 28                	js     80214b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 15 24 40 80 00    	mov    0x804024,%edx
  80212c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802138:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	50                   	push   %eax
  80213f:	e8 c6 f6 ff ff       	call   80180a <fd2num>
  802144:	89 c3                	mov    %eax,%ebx
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	eb 0c                	jmp    802157 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	56                   	push   %esi
  80214f:	e8 e4 01 00 00       	call   802338 <nsipc_close>
		return r;
  802154:	83 c4 10             	add    $0x10,%esp
}
  802157:	89 d8                	mov    %ebx,%eax
  802159:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215c:	5b                   	pop    %ebx
  80215d:	5e                   	pop    %esi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    

00802160 <accept>:
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	e8 4e ff ff ff       	call   8020bc <fd2sockid>
  80216e:	85 c0                	test   %eax,%eax
  802170:	78 1b                	js     80218d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	ff 75 10             	pushl  0x10(%ebp)
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	50                   	push   %eax
  80217c:	e8 0e 01 00 00       	call   80228f <nsipc_accept>
  802181:	83 c4 10             	add    $0x10,%esp
  802184:	85 c0                	test   %eax,%eax
  802186:	78 05                	js     80218d <accept+0x2d>
	return alloc_sockfd(r);
  802188:	e8 5f ff ff ff       	call   8020ec <alloc_sockfd>
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <bind>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	e8 1f ff ff ff       	call   8020bc <fd2sockid>
  80219d:	85 c0                	test   %eax,%eax
  80219f:	78 12                	js     8021b3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8021a1:	83 ec 04             	sub    $0x4,%esp
  8021a4:	ff 75 10             	pushl  0x10(%ebp)
  8021a7:	ff 75 0c             	pushl  0xc(%ebp)
  8021aa:	50                   	push   %eax
  8021ab:	e8 31 01 00 00       	call   8022e1 <nsipc_bind>
  8021b0:	83 c4 10             	add    $0x10,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <shutdown>:
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	e8 f9 fe ff ff       	call   8020bc <fd2sockid>
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	78 0f                	js     8021d6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8021c7:	83 ec 08             	sub    $0x8,%esp
  8021ca:	ff 75 0c             	pushl  0xc(%ebp)
  8021cd:	50                   	push   %eax
  8021ce:	e8 43 01 00 00       	call   802316 <nsipc_shutdown>
  8021d3:	83 c4 10             	add    $0x10,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <connect>:
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	e8 d6 fe ff ff       	call   8020bc <fd2sockid>
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 12                	js     8021fc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	ff 75 10             	pushl  0x10(%ebp)
  8021f0:	ff 75 0c             	pushl  0xc(%ebp)
  8021f3:	50                   	push   %eax
  8021f4:	e8 59 01 00 00       	call   802352 <nsipc_connect>
  8021f9:	83 c4 10             	add    $0x10,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <listen>:
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	e8 b0 fe ff ff       	call   8020bc <fd2sockid>
  80220c:	85 c0                	test   %eax,%eax
  80220e:	78 0f                	js     80221f <listen+0x21>
	return nsipc_listen(r, backlog);
  802210:	83 ec 08             	sub    $0x8,%esp
  802213:	ff 75 0c             	pushl  0xc(%ebp)
  802216:	50                   	push   %eax
  802217:	e8 6b 01 00 00       	call   802387 <nsipc_listen>
  80221c:	83 c4 10             	add    $0x10,%esp
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <socket>:

int
socket(int domain, int type, int protocol)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802227:	ff 75 10             	pushl  0x10(%ebp)
  80222a:	ff 75 0c             	pushl  0xc(%ebp)
  80222d:	ff 75 08             	pushl  0x8(%ebp)
  802230:	e8 3e 02 00 00       	call   802473 <nsipc_socket>
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	85 c0                	test   %eax,%eax
  80223a:	78 05                	js     802241 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80223c:	e8 ab fe ff ff       	call   8020ec <alloc_sockfd>
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	53                   	push   %ebx
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80224c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802253:	74 26                	je     80227b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802255:	6a 07                	push   $0x7
  802257:	68 00 70 80 00       	push   $0x807000
  80225c:	53                   	push   %ebx
  80225d:	ff 35 04 50 80 00    	pushl  0x805004
  802263:	e8 48 08 00 00       	call   802ab0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802268:	83 c4 0c             	add    $0xc,%esp
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	e8 d1 07 00 00       	call   802a47 <ipc_recv>
}
  802276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802279:	c9                   	leave  
  80227a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	6a 02                	push   $0x2
  802280:	e8 83 08 00 00       	call   802b08 <ipc_find_env>
  802285:	a3 04 50 80 00       	mov    %eax,0x805004
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	eb c6                	jmp    802255 <nsipc+0x12>

0080228f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80229f:	8b 06                	mov    (%esi),%eax
  8022a1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ab:	e8 93 ff ff ff       	call   802243 <nsipc>
  8022b0:	89 c3                	mov    %eax,%ebx
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	79 09                	jns    8022bf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022b6:	89 d8                	mov    %ebx,%eax
  8022b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5e                   	pop    %esi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	ff 35 10 70 80 00    	pushl  0x807010
  8022c8:	68 00 70 80 00       	push   $0x807000
  8022cd:	ff 75 0c             	pushl  0xc(%ebp)
  8022d0:	e8 ef ea ff ff       	call   800dc4 <memmove>
		*addrlen = ret->ret_addrlen;
  8022d5:	a1 10 70 80 00       	mov    0x807010,%eax
  8022da:	89 06                	mov    %eax,(%esi)
  8022dc:	83 c4 10             	add    $0x10,%esp
	return r;
  8022df:	eb d5                	jmp    8022b6 <nsipc_accept+0x27>

008022e1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 08             	sub    $0x8,%esp
  8022e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022f3:	53                   	push   %ebx
  8022f4:	ff 75 0c             	pushl  0xc(%ebp)
  8022f7:	68 04 70 80 00       	push   $0x807004
  8022fc:	e8 c3 ea ff ff       	call   800dc4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802301:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802307:	b8 02 00 00 00       	mov    $0x2,%eax
  80230c:	e8 32 ff ff ff       	call   802243 <nsipc>
}
  802311:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80232c:	b8 03 00 00 00       	mov    $0x3,%eax
  802331:	e8 0d ff ff ff       	call   802243 <nsipc>
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <nsipc_close>:

int
nsipc_close(int s)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802346:	b8 04 00 00 00       	mov    $0x4,%eax
  80234b:	e8 f3 fe ff ff       	call   802243 <nsipc>
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	53                   	push   %ebx
  802356:	83 ec 08             	sub    $0x8,%esp
  802359:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802364:	53                   	push   %ebx
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	68 04 70 80 00       	push   $0x807004
  80236d:	e8 52 ea ff ff       	call   800dc4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802372:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802378:	b8 05 00 00 00       	mov    $0x5,%eax
  80237d:	e8 c1 fe ff ff       	call   802243 <nsipc>
}
  802382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802395:	8b 45 0c             	mov    0xc(%ebp),%eax
  802398:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80239d:	b8 06 00 00 00       	mov    $0x6,%eax
  8023a2:	e8 9c fe ff ff       	call   802243 <nsipc>
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	56                   	push   %esi
  8023ad:	53                   	push   %ebx
  8023ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023b9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023c7:	b8 07 00 00 00       	mov    $0x7,%eax
  8023cc:	e8 72 fe ff ff       	call   802243 <nsipc>
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	78 1f                	js     8023f6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023d7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023dc:	7f 21                	jg     8023ff <nsipc_recv+0x56>
  8023de:	39 c6                	cmp    %eax,%esi
  8023e0:	7c 1d                	jl     8023ff <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023e2:	83 ec 04             	sub    $0x4,%esp
  8023e5:	50                   	push   %eax
  8023e6:	68 00 70 80 00       	push   $0x807000
  8023eb:	ff 75 0c             	pushl  0xc(%ebp)
  8023ee:	e8 d1 e9 ff ff       	call   800dc4 <memmove>
  8023f3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023f6:	89 d8                	mov    %ebx,%eax
  8023f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5d                   	pop    %ebp
  8023fe:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023ff:	68 33 35 80 00       	push   $0x803533
  802404:	68 fb 34 80 00       	push   $0x8034fb
  802409:	6a 62                	push   $0x62
  80240b:	68 48 35 80 00       	push   $0x803548
  802410:	e8 cc df ff ff       	call   8003e1 <_panic>

00802415 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	53                   	push   %ebx
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802427:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80242d:	7f 2e                	jg     80245d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80242f:	83 ec 04             	sub    $0x4,%esp
  802432:	53                   	push   %ebx
  802433:	ff 75 0c             	pushl  0xc(%ebp)
  802436:	68 0c 70 80 00       	push   $0x80700c
  80243b:	e8 84 e9 ff ff       	call   800dc4 <memmove>
	nsipcbuf.send.req_size = size;
  802440:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802446:	8b 45 14             	mov    0x14(%ebp),%eax
  802449:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80244e:	b8 08 00 00 00       	mov    $0x8,%eax
  802453:	e8 eb fd ff ff       	call   802243 <nsipc>
}
  802458:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    
	assert(size < 1600);
  80245d:	68 54 35 80 00       	push   $0x803554
  802462:	68 fb 34 80 00       	push   $0x8034fb
  802467:	6a 6d                	push   $0x6d
  802469:	68 48 35 80 00       	push   $0x803548
  80246e:	e8 6e df ff ff       	call   8003e1 <_panic>

00802473 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802481:	8b 45 0c             	mov    0xc(%ebp),%eax
  802484:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802489:	8b 45 10             	mov    0x10(%ebp),%eax
  80248c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802491:	b8 09 00 00 00       	mov    $0x9,%eax
  802496:	e8 a8 fd ff ff       	call   802243 <nsipc>
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	56                   	push   %esi
  8024a1:	53                   	push   %ebx
  8024a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024a5:	83 ec 0c             	sub    $0xc,%esp
  8024a8:	ff 75 08             	pushl  0x8(%ebp)
  8024ab:	e8 6a f3 ff ff       	call   80181a <fd2data>
  8024b0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024b2:	83 c4 08             	add    $0x8,%esp
  8024b5:	68 60 35 80 00       	push   $0x803560
  8024ba:	53                   	push   %ebx
  8024bb:	e8 76 e7 ff ff       	call   800c36 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024c0:	8b 46 04             	mov    0x4(%esi),%eax
  8024c3:	2b 06                	sub    (%esi),%eax
  8024c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024d2:	00 00 00 
	stat->st_dev = &devpipe;
  8024d5:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8024dc:	40 80 00 
	return 0;
}
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5d                   	pop    %ebp
  8024ea:	c3                   	ret    

008024eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 0c             	sub    $0xc,%esp
  8024f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024f5:	53                   	push   %ebx
  8024f6:	6a 00                	push   $0x0
  8024f8:	e8 b0 eb ff ff       	call   8010ad <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024fd:	89 1c 24             	mov    %ebx,(%esp)
  802500:	e8 15 f3 ff ff       	call   80181a <fd2data>
  802505:	83 c4 08             	add    $0x8,%esp
  802508:	50                   	push   %eax
  802509:	6a 00                	push   $0x0
  80250b:	e8 9d eb ff ff       	call   8010ad <sys_page_unmap>
}
  802510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <_pipeisclosed>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	57                   	push   %edi
  802519:	56                   	push   %esi
  80251a:	53                   	push   %ebx
  80251b:	83 ec 1c             	sub    $0x1c,%esp
  80251e:	89 c7                	mov    %eax,%edi
  802520:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802522:	a1 08 50 80 00       	mov    0x805008,%eax
  802527:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80252a:	83 ec 0c             	sub    $0xc,%esp
  80252d:	57                   	push   %edi
  80252e:	e8 14 06 00 00       	call   802b47 <pageref>
  802533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802536:	89 34 24             	mov    %esi,(%esp)
  802539:	e8 09 06 00 00       	call   802b47 <pageref>
		nn = thisenv->env_runs;
  80253e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802544:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	39 cb                	cmp    %ecx,%ebx
  80254c:	74 1b                	je     802569 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80254e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802551:	75 cf                	jne    802522 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802553:	8b 42 58             	mov    0x58(%edx),%eax
  802556:	6a 01                	push   $0x1
  802558:	50                   	push   %eax
  802559:	53                   	push   %ebx
  80255a:	68 67 35 80 00       	push   $0x803567
  80255f:	e8 73 df ff ff       	call   8004d7 <cprintf>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	eb b9                	jmp    802522 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802569:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80256c:	0f 94 c0             	sete   %al
  80256f:	0f b6 c0             	movzbl %al,%eax
}
  802572:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802575:	5b                   	pop    %ebx
  802576:	5e                   	pop    %esi
  802577:	5f                   	pop    %edi
  802578:	5d                   	pop    %ebp
  802579:	c3                   	ret    

0080257a <devpipe_write>:
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	57                   	push   %edi
  80257e:	56                   	push   %esi
  80257f:	53                   	push   %ebx
  802580:	83 ec 28             	sub    $0x28,%esp
  802583:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802586:	56                   	push   %esi
  802587:	e8 8e f2 ff ff       	call   80181a <fd2data>
  80258c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80258e:	83 c4 10             	add    $0x10,%esp
  802591:	bf 00 00 00 00       	mov    $0x0,%edi
  802596:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802599:	74 4f                	je     8025ea <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80259b:	8b 43 04             	mov    0x4(%ebx),%eax
  80259e:	8b 0b                	mov    (%ebx),%ecx
  8025a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8025a3:	39 d0                	cmp    %edx,%eax
  8025a5:	72 14                	jb     8025bb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8025a7:	89 da                	mov    %ebx,%edx
  8025a9:	89 f0                	mov    %esi,%eax
  8025ab:	e8 65 ff ff ff       	call   802515 <_pipeisclosed>
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	75 3b                	jne    8025ef <devpipe_write+0x75>
			sys_yield();
  8025b4:	e8 50 ea ff ff       	call   801009 <sys_yield>
  8025b9:	eb e0                	jmp    80259b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025be:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025c2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025c5:	89 c2                	mov    %eax,%edx
  8025c7:	c1 fa 1f             	sar    $0x1f,%edx
  8025ca:	89 d1                	mov    %edx,%ecx
  8025cc:	c1 e9 1b             	shr    $0x1b,%ecx
  8025cf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025d2:	83 e2 1f             	and    $0x1f,%edx
  8025d5:	29 ca                	sub    %ecx,%edx
  8025d7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025df:	83 c0 01             	add    $0x1,%eax
  8025e2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025e5:	83 c7 01             	add    $0x1,%edi
  8025e8:	eb ac                	jmp    802596 <devpipe_write+0x1c>
	return i;
  8025ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ed:	eb 05                	jmp    8025f4 <devpipe_write+0x7a>
				return 0;
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f7:	5b                   	pop    %ebx
  8025f8:	5e                   	pop    %esi
  8025f9:	5f                   	pop    %edi
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    

008025fc <devpipe_read>:
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	57                   	push   %edi
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	83 ec 18             	sub    $0x18,%esp
  802605:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802608:	57                   	push   %edi
  802609:	e8 0c f2 ff ff       	call   80181a <fd2data>
  80260e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	be 00 00 00 00       	mov    $0x0,%esi
  802618:	3b 75 10             	cmp    0x10(%ebp),%esi
  80261b:	75 14                	jne    802631 <devpipe_read+0x35>
	return i;
  80261d:	8b 45 10             	mov    0x10(%ebp),%eax
  802620:	eb 02                	jmp    802624 <devpipe_read+0x28>
				return i;
  802622:	89 f0                	mov    %esi,%eax
}
  802624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5f                   	pop    %edi
  80262a:	5d                   	pop    %ebp
  80262b:	c3                   	ret    
			sys_yield();
  80262c:	e8 d8 e9 ff ff       	call   801009 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802631:	8b 03                	mov    (%ebx),%eax
  802633:	3b 43 04             	cmp    0x4(%ebx),%eax
  802636:	75 18                	jne    802650 <devpipe_read+0x54>
			if (i > 0)
  802638:	85 f6                	test   %esi,%esi
  80263a:	75 e6                	jne    802622 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80263c:	89 da                	mov    %ebx,%edx
  80263e:	89 f8                	mov    %edi,%eax
  802640:	e8 d0 fe ff ff       	call   802515 <_pipeisclosed>
  802645:	85 c0                	test   %eax,%eax
  802647:	74 e3                	je     80262c <devpipe_read+0x30>
				return 0;
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
  80264e:	eb d4                	jmp    802624 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802650:	99                   	cltd   
  802651:	c1 ea 1b             	shr    $0x1b,%edx
  802654:	01 d0                	add    %edx,%eax
  802656:	83 e0 1f             	and    $0x1f,%eax
  802659:	29 d0                	sub    %edx,%eax
  80265b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802660:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802663:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802666:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802669:	83 c6 01             	add    $0x1,%esi
  80266c:	eb aa                	jmp    802618 <devpipe_read+0x1c>

0080266e <pipe>:
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	56                   	push   %esi
  802672:	53                   	push   %ebx
  802673:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802676:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802679:	50                   	push   %eax
  80267a:	e8 b2 f1 ff ff       	call   801831 <fd_alloc>
  80267f:	89 c3                	mov    %eax,%ebx
  802681:	83 c4 10             	add    $0x10,%esp
  802684:	85 c0                	test   %eax,%eax
  802686:	0f 88 23 01 00 00    	js     8027af <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 07 04 00 00       	push   $0x407
  802694:	ff 75 f4             	pushl  -0xc(%ebp)
  802697:	6a 00                	push   $0x0
  802699:	e8 8a e9 ff ff       	call   801028 <sys_page_alloc>
  80269e:	89 c3                	mov    %eax,%ebx
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	0f 88 04 01 00 00    	js     8027af <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8026ab:	83 ec 0c             	sub    $0xc,%esp
  8026ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026b1:	50                   	push   %eax
  8026b2:	e8 7a f1 ff ff       	call   801831 <fd_alloc>
  8026b7:	89 c3                	mov    %eax,%ebx
  8026b9:	83 c4 10             	add    $0x10,%esp
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	0f 88 db 00 00 00    	js     80279f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	68 07 04 00 00       	push   $0x407
  8026cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8026cf:	6a 00                	push   $0x0
  8026d1:	e8 52 e9 ff ff       	call   801028 <sys_page_alloc>
  8026d6:	89 c3                	mov    %eax,%ebx
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	0f 88 bc 00 00 00    	js     80279f <pipe+0x131>
	va = fd2data(fd0);
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e9:	e8 2c f1 ff ff       	call   80181a <fd2data>
  8026ee:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026f0:	83 c4 0c             	add    $0xc,%esp
  8026f3:	68 07 04 00 00       	push   $0x407
  8026f8:	50                   	push   %eax
  8026f9:	6a 00                	push   $0x0
  8026fb:	e8 28 e9 ff ff       	call   801028 <sys_page_alloc>
  802700:	89 c3                	mov    %eax,%ebx
  802702:	83 c4 10             	add    $0x10,%esp
  802705:	85 c0                	test   %eax,%eax
  802707:	0f 88 82 00 00 00    	js     80278f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270d:	83 ec 0c             	sub    $0xc,%esp
  802710:	ff 75 f0             	pushl  -0x10(%ebp)
  802713:	e8 02 f1 ff ff       	call   80181a <fd2data>
  802718:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80271f:	50                   	push   %eax
  802720:	6a 00                	push   $0x0
  802722:	56                   	push   %esi
  802723:	6a 00                	push   $0x0
  802725:	e8 41 e9 ff ff       	call   80106b <sys_page_map>
  80272a:	89 c3                	mov    %eax,%ebx
  80272c:	83 c4 20             	add    $0x20,%esp
  80272f:	85 c0                	test   %eax,%eax
  802731:	78 4e                	js     802781 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802733:	a1 40 40 80 00       	mov    0x804040,%eax
  802738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80273d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802740:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802747:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80274a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802756:	83 ec 0c             	sub    $0xc,%esp
  802759:	ff 75 f4             	pushl  -0xc(%ebp)
  80275c:	e8 a9 f0 ff ff       	call   80180a <fd2num>
  802761:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802764:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802766:	83 c4 04             	add    $0x4,%esp
  802769:	ff 75 f0             	pushl  -0x10(%ebp)
  80276c:	e8 99 f0 ff ff       	call   80180a <fd2num>
  802771:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802774:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802777:	83 c4 10             	add    $0x10,%esp
  80277a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80277f:	eb 2e                	jmp    8027af <pipe+0x141>
	sys_page_unmap(0, va);
  802781:	83 ec 08             	sub    $0x8,%esp
  802784:	56                   	push   %esi
  802785:	6a 00                	push   $0x0
  802787:	e8 21 e9 ff ff       	call   8010ad <sys_page_unmap>
  80278c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80278f:	83 ec 08             	sub    $0x8,%esp
  802792:	ff 75 f0             	pushl  -0x10(%ebp)
  802795:	6a 00                	push   $0x0
  802797:	e8 11 e9 ff ff       	call   8010ad <sys_page_unmap>
  80279c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80279f:	83 ec 08             	sub    $0x8,%esp
  8027a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a5:	6a 00                	push   $0x0
  8027a7:	e8 01 e9 ff ff       	call   8010ad <sys_page_unmap>
  8027ac:	83 c4 10             	add    $0x10,%esp
}
  8027af:	89 d8                	mov    %ebx,%eax
  8027b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027b4:	5b                   	pop    %ebx
  8027b5:	5e                   	pop    %esi
  8027b6:	5d                   	pop    %ebp
  8027b7:	c3                   	ret    

008027b8 <pipeisclosed>:
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c1:	50                   	push   %eax
  8027c2:	ff 75 08             	pushl  0x8(%ebp)
  8027c5:	e8 b9 f0 ff ff       	call   801883 <fd_lookup>
  8027ca:	83 c4 10             	add    $0x10,%esp
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	78 18                	js     8027e9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027d1:	83 ec 0c             	sub    $0xc,%esp
  8027d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d7:	e8 3e f0 ff ff       	call   80181a <fd2data>
	return _pipeisclosed(fd, p);
  8027dc:	89 c2                	mov    %eax,%edx
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	e8 2f fd ff ff       	call   802515 <_pipeisclosed>
  8027e6:	83 c4 10             	add    $0x10,%esp
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	56                   	push   %esi
  8027ef:	53                   	push   %ebx
  8027f0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8027f3:	85 f6                	test   %esi,%esi
  8027f5:	74 16                	je     80280d <wait+0x22>
	e = &envs[ENVX(envid)];
  8027f7:	89 f3                	mov    %esi,%ebx
  8027f9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027ff:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802805:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80280b:	eb 1b                	jmp    802828 <wait+0x3d>
	assert(envid != 0);
  80280d:	68 7f 35 80 00       	push   $0x80357f
  802812:	68 fb 34 80 00       	push   $0x8034fb
  802817:	6a 09                	push   $0x9
  802819:	68 8a 35 80 00       	push   $0x80358a
  80281e:	e8 be db ff ff       	call   8003e1 <_panic>
		sys_yield();
  802823:	e8 e1 e7 ff ff       	call   801009 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802828:	8b 43 48             	mov    0x48(%ebx),%eax
  80282b:	39 f0                	cmp    %esi,%eax
  80282d:	75 07                	jne    802836 <wait+0x4b>
  80282f:	8b 43 54             	mov    0x54(%ebx),%eax
  802832:	85 c0                	test   %eax,%eax
  802834:	75 ed                	jne    802823 <wait+0x38>
}
  802836:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802839:	5b                   	pop    %ebx
  80283a:	5e                   	pop    %esi
  80283b:	5d                   	pop    %ebp
  80283c:	c3                   	ret    

0080283d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	c3                   	ret    

00802843 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802849:	68 95 35 80 00       	push   $0x803595
  80284e:	ff 75 0c             	pushl  0xc(%ebp)
  802851:	e8 e0 e3 ff ff       	call   800c36 <strcpy>
	return 0;
}
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <devcons_write>:
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	57                   	push   %edi
  802861:	56                   	push   %esi
  802862:	53                   	push   %ebx
  802863:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802869:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80286e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802874:	3b 75 10             	cmp    0x10(%ebp),%esi
  802877:	73 31                	jae    8028aa <devcons_write+0x4d>
		m = n - tot;
  802879:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80287c:	29 f3                	sub    %esi,%ebx
  80287e:	83 fb 7f             	cmp    $0x7f,%ebx
  802881:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802886:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	53                   	push   %ebx
  80288d:	89 f0                	mov    %esi,%eax
  80288f:	03 45 0c             	add    0xc(%ebp),%eax
  802892:	50                   	push   %eax
  802893:	57                   	push   %edi
  802894:	e8 2b e5 ff ff       	call   800dc4 <memmove>
		sys_cputs(buf, m);
  802899:	83 c4 08             	add    $0x8,%esp
  80289c:	53                   	push   %ebx
  80289d:	57                   	push   %edi
  80289e:	e8 c9 e6 ff ff       	call   800f6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8028a3:	01 de                	add    %ebx,%esi
  8028a5:	83 c4 10             	add    $0x10,%esp
  8028a8:	eb ca                	jmp    802874 <devcons_write+0x17>
}
  8028aa:	89 f0                	mov    %esi,%eax
  8028ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028af:	5b                   	pop    %ebx
  8028b0:	5e                   	pop    %esi
  8028b1:	5f                   	pop    %edi
  8028b2:	5d                   	pop    %ebp
  8028b3:	c3                   	ret    

008028b4 <devcons_read>:
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 08             	sub    $0x8,%esp
  8028ba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8028bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028c3:	74 21                	je     8028e6 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8028c5:	e8 c0 e6 ff ff       	call   800f8a <sys_cgetc>
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	75 07                	jne    8028d5 <devcons_read+0x21>
		sys_yield();
  8028ce:	e8 36 e7 ff ff       	call   801009 <sys_yield>
  8028d3:	eb f0                	jmp    8028c5 <devcons_read+0x11>
	if (c < 0)
  8028d5:	78 0f                	js     8028e6 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8028d7:	83 f8 04             	cmp    $0x4,%eax
  8028da:	74 0c                	je     8028e8 <devcons_read+0x34>
	*(char*)vbuf = c;
  8028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028df:	88 02                	mov    %al,(%edx)
	return 1;
  8028e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028e6:	c9                   	leave  
  8028e7:	c3                   	ret    
		return 0;
  8028e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ed:	eb f7                	jmp    8028e6 <devcons_read+0x32>

008028ef <cputchar>:
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8028fb:	6a 01                	push   $0x1
  8028fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802900:	50                   	push   %eax
  802901:	e8 66 e6 ff ff       	call   800f6c <sys_cputs>
}
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	c9                   	leave  
  80290a:	c3                   	ret    

0080290b <getchar>:
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802911:	6a 01                	push   $0x1
  802913:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802916:	50                   	push   %eax
  802917:	6a 00                	push   $0x0
  802919:	e8 d5 f1 ff ff       	call   801af3 <read>
	if (r < 0)
  80291e:	83 c4 10             	add    $0x10,%esp
  802921:	85 c0                	test   %eax,%eax
  802923:	78 06                	js     80292b <getchar+0x20>
	if (r < 1)
  802925:	74 06                	je     80292d <getchar+0x22>
	return c;
  802927:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    
		return -E_EOF;
  80292d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802932:	eb f7                	jmp    80292b <getchar+0x20>

00802934 <iscons>:
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80293a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80293d:	50                   	push   %eax
  80293e:	ff 75 08             	pushl  0x8(%ebp)
  802941:	e8 3d ef ff ff       	call   801883 <fd_lookup>
  802946:	83 c4 10             	add    $0x10,%esp
  802949:	85 c0                	test   %eax,%eax
  80294b:	78 11                	js     80295e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802956:	39 10                	cmp    %edx,(%eax)
  802958:	0f 94 c0             	sete   %al
  80295b:	0f b6 c0             	movzbl %al,%eax
}
  80295e:	c9                   	leave  
  80295f:	c3                   	ret    

00802960 <opencons>:
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802969:	50                   	push   %eax
  80296a:	e8 c2 ee ff ff       	call   801831 <fd_alloc>
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	85 c0                	test   %eax,%eax
  802974:	78 3a                	js     8029b0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802976:	83 ec 04             	sub    $0x4,%esp
  802979:	68 07 04 00 00       	push   $0x407
  80297e:	ff 75 f4             	pushl  -0xc(%ebp)
  802981:	6a 00                	push   $0x0
  802983:	e8 a0 e6 ff ff       	call   801028 <sys_page_alloc>
  802988:	83 c4 10             	add    $0x10,%esp
  80298b:	85 c0                	test   %eax,%eax
  80298d:	78 21                	js     8029b0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802998:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8029a4:	83 ec 0c             	sub    $0xc,%esp
  8029a7:	50                   	push   %eax
  8029a8:	e8 5d ee ff ff       	call   80180a <fd2num>
  8029ad:	83 c4 10             	add    $0x10,%esp
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029b8:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8029bf:	74 0a                	je     8029cb <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	6a 07                	push   $0x7
  8029d0:	68 00 f0 bf ee       	push   $0xeebff000
  8029d5:	6a 00                	push   $0x0
  8029d7:	e8 4c e6 ff ff       	call   801028 <sys_page_alloc>
		if(r < 0)
  8029dc:	83 c4 10             	add    $0x10,%esp
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	78 2a                	js     802a0d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8029e3:	83 ec 08             	sub    $0x8,%esp
  8029e6:	68 21 2a 80 00       	push   $0x802a21
  8029eb:	6a 00                	push   $0x0
  8029ed:	e8 81 e7 ff ff       	call   801173 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8029f2:	83 c4 10             	add    $0x10,%esp
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	79 c8                	jns    8029c1 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8029f9:	83 ec 04             	sub    $0x4,%esp
  8029fc:	68 d4 35 80 00       	push   $0x8035d4
  802a01:	6a 25                	push   $0x25
  802a03:	68 10 36 80 00       	push   $0x803610
  802a08:	e8 d4 d9 ff ff       	call   8003e1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802a0d:	83 ec 04             	sub    $0x4,%esp
  802a10:	68 a4 35 80 00       	push   $0x8035a4
  802a15:	6a 22                	push   $0x22
  802a17:	68 10 36 80 00       	push   $0x803610
  802a1c:	e8 c0 d9 ff ff       	call   8003e1 <_panic>

00802a21 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a21:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a22:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a27:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a29:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802a2c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802a30:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802a34:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802a37:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802a39:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802a3d:	83 c4 08             	add    $0x8,%esp
	popal
  802a40:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a41:	83 c4 04             	add    $0x4,%esp
	popfl
  802a44:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a45:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802a46:	c3                   	ret    

00802a47 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
  802a4a:	56                   	push   %esi
  802a4b:	53                   	push   %ebx
  802a4c:	8b 75 08             	mov    0x8(%ebp),%esi
  802a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802a55:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802a57:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802a5c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802a5f:	83 ec 0c             	sub    $0xc,%esp
  802a62:	50                   	push   %eax
  802a63:	e8 70 e7 ff ff       	call   8011d8 <sys_ipc_recv>
	if(ret < 0){
  802a68:	83 c4 10             	add    $0x10,%esp
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	78 2b                	js     802a9a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a6f:	85 f6                	test   %esi,%esi
  802a71:	74 0a                	je     802a7d <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802a73:	a1 08 50 80 00       	mov    0x805008,%eax
  802a78:	8b 40 78             	mov    0x78(%eax),%eax
  802a7b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a7d:	85 db                	test   %ebx,%ebx
  802a7f:	74 0a                	je     802a8b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802a81:	a1 08 50 80 00       	mov    0x805008,%eax
  802a86:	8b 40 7c             	mov    0x7c(%eax),%eax
  802a89:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802a8b:	a1 08 50 80 00       	mov    0x805008,%eax
  802a90:	8b 40 74             	mov    0x74(%eax),%eax
}
  802a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a96:	5b                   	pop    %ebx
  802a97:	5e                   	pop    %esi
  802a98:	5d                   	pop    %ebp
  802a99:	c3                   	ret    
		if(from_env_store)
  802a9a:	85 f6                	test   %esi,%esi
  802a9c:	74 06                	je     802aa4 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a9e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802aa4:	85 db                	test   %ebx,%ebx
  802aa6:	74 eb                	je     802a93 <ipc_recv+0x4c>
			*perm_store = 0;
  802aa8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802aae:	eb e3                	jmp    802a93 <ipc_recv+0x4c>

00802ab0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	57                   	push   %edi
  802ab4:	56                   	push   %esi
  802ab5:	53                   	push   %ebx
  802ab6:	83 ec 0c             	sub    $0xc,%esp
  802ab9:	8b 7d 08             	mov    0x8(%ebp),%edi
  802abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  802abf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802ac2:	85 db                	test   %ebx,%ebx
  802ac4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802ac9:	0f 44 d8             	cmove  %eax,%ebx
  802acc:	eb 05                	jmp    802ad3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802ace:	e8 36 e5 ff ff       	call   801009 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802ad3:	ff 75 14             	pushl  0x14(%ebp)
  802ad6:	53                   	push   %ebx
  802ad7:	56                   	push   %esi
  802ad8:	57                   	push   %edi
  802ad9:	e8 d7 e6 ff ff       	call   8011b5 <sys_ipc_try_send>
  802ade:	83 c4 10             	add    $0x10,%esp
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 1b                	je     802b00 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802ae5:	79 e7                	jns    802ace <ipc_send+0x1e>
  802ae7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802aea:	74 e2                	je     802ace <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 1e 36 80 00       	push   $0x80361e
  802af4:	6a 46                	push   $0x46
  802af6:	68 33 36 80 00       	push   $0x803633
  802afb:	e8 e1 d8 ff ff       	call   8003e1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b03:	5b                   	pop    %ebx
  802b04:	5e                   	pop    %esi
  802b05:	5f                   	pop    %edi
  802b06:	5d                   	pop    %ebp
  802b07:	c3                   	ret    

00802b08 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
  802b0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b0e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b13:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802b19:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b1f:	8b 52 50             	mov    0x50(%edx),%edx
  802b22:	39 ca                	cmp    %ecx,%edx
  802b24:	74 11                	je     802b37 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802b26:	83 c0 01             	add    $0x1,%eax
  802b29:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b2e:	75 e3                	jne    802b13 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802b30:	b8 00 00 00 00       	mov    $0x0,%eax
  802b35:	eb 0e                	jmp    802b45 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802b37:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802b3d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b42:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b45:	5d                   	pop    %ebp
  802b46:	c3                   	ret    

00802b47 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b47:	55                   	push   %ebp
  802b48:	89 e5                	mov    %esp,%ebp
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b4d:	89 d0                	mov    %edx,%eax
  802b4f:	c1 e8 16             	shr    $0x16,%eax
  802b52:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802b5e:	f6 c1 01             	test   $0x1,%cl
  802b61:	74 1d                	je     802b80 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802b63:	c1 ea 0c             	shr    $0xc,%edx
  802b66:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b6d:	f6 c2 01             	test   $0x1,%dl
  802b70:	74 0e                	je     802b80 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b72:	c1 ea 0c             	shr    $0xc,%edx
  802b75:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b7c:	ef 
  802b7d:	0f b7 c0             	movzwl %ax,%eax
}
  802b80:	5d                   	pop    %ebp
  802b81:	c3                   	ret    
  802b82:	66 90                	xchg   %ax,%ax
  802b84:	66 90                	xchg   %ax,%ax
  802b86:	66 90                	xchg   %ax,%ax
  802b88:	66 90                	xchg   %ax,%ax
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	66 90                	xchg   %ax,%ax
  802b8e:	66 90                	xchg   %ax,%ax

00802b90 <__udivdi3>:
  802b90:	55                   	push   %ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	53                   	push   %ebx
  802b94:	83 ec 1c             	sub    $0x1c,%esp
  802b97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ba3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ba7:	85 d2                	test   %edx,%edx
  802ba9:	75 4d                	jne    802bf8 <__udivdi3+0x68>
  802bab:	39 f3                	cmp    %esi,%ebx
  802bad:	76 19                	jbe    802bc8 <__udivdi3+0x38>
  802baf:	31 ff                	xor    %edi,%edi
  802bb1:	89 e8                	mov    %ebp,%eax
  802bb3:	89 f2                	mov    %esi,%edx
  802bb5:	f7 f3                	div    %ebx
  802bb7:	89 fa                	mov    %edi,%edx
  802bb9:	83 c4 1c             	add    $0x1c,%esp
  802bbc:	5b                   	pop    %ebx
  802bbd:	5e                   	pop    %esi
  802bbe:	5f                   	pop    %edi
  802bbf:	5d                   	pop    %ebp
  802bc0:	c3                   	ret    
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	89 d9                	mov    %ebx,%ecx
  802bca:	85 db                	test   %ebx,%ebx
  802bcc:	75 0b                	jne    802bd9 <__udivdi3+0x49>
  802bce:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd3:	31 d2                	xor    %edx,%edx
  802bd5:	f7 f3                	div    %ebx
  802bd7:	89 c1                	mov    %eax,%ecx
  802bd9:	31 d2                	xor    %edx,%edx
  802bdb:	89 f0                	mov    %esi,%eax
  802bdd:	f7 f1                	div    %ecx
  802bdf:	89 c6                	mov    %eax,%esi
  802be1:	89 e8                	mov    %ebp,%eax
  802be3:	89 f7                	mov    %esi,%edi
  802be5:	f7 f1                	div    %ecx
  802be7:	89 fa                	mov    %edi,%edx
  802be9:	83 c4 1c             	add    $0x1c,%esp
  802bec:	5b                   	pop    %ebx
  802bed:	5e                   	pop    %esi
  802bee:	5f                   	pop    %edi
  802bef:	5d                   	pop    %ebp
  802bf0:	c3                   	ret    
  802bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	39 f2                	cmp    %esi,%edx
  802bfa:	77 1c                	ja     802c18 <__udivdi3+0x88>
  802bfc:	0f bd fa             	bsr    %edx,%edi
  802bff:	83 f7 1f             	xor    $0x1f,%edi
  802c02:	75 2c                	jne    802c30 <__udivdi3+0xa0>
  802c04:	39 f2                	cmp    %esi,%edx
  802c06:	72 06                	jb     802c0e <__udivdi3+0x7e>
  802c08:	31 c0                	xor    %eax,%eax
  802c0a:	39 eb                	cmp    %ebp,%ebx
  802c0c:	77 a9                	ja     802bb7 <__udivdi3+0x27>
  802c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c13:	eb a2                	jmp    802bb7 <__udivdi3+0x27>
  802c15:	8d 76 00             	lea    0x0(%esi),%esi
  802c18:	31 ff                	xor    %edi,%edi
  802c1a:	31 c0                	xor    %eax,%eax
  802c1c:	89 fa                	mov    %edi,%edx
  802c1e:	83 c4 1c             	add    $0x1c,%esp
  802c21:	5b                   	pop    %ebx
  802c22:	5e                   	pop    %esi
  802c23:	5f                   	pop    %edi
  802c24:	5d                   	pop    %ebp
  802c25:	c3                   	ret    
  802c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c2d:	8d 76 00             	lea    0x0(%esi),%esi
  802c30:	89 f9                	mov    %edi,%ecx
  802c32:	b8 20 00 00 00       	mov    $0x20,%eax
  802c37:	29 f8                	sub    %edi,%eax
  802c39:	d3 e2                	shl    %cl,%edx
  802c3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c3f:	89 c1                	mov    %eax,%ecx
  802c41:	89 da                	mov    %ebx,%edx
  802c43:	d3 ea                	shr    %cl,%edx
  802c45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c49:	09 d1                	or     %edx,%ecx
  802c4b:	89 f2                	mov    %esi,%edx
  802c4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c51:	89 f9                	mov    %edi,%ecx
  802c53:	d3 e3                	shl    %cl,%ebx
  802c55:	89 c1                	mov    %eax,%ecx
  802c57:	d3 ea                	shr    %cl,%edx
  802c59:	89 f9                	mov    %edi,%ecx
  802c5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802c5f:	89 eb                	mov    %ebp,%ebx
  802c61:	d3 e6                	shl    %cl,%esi
  802c63:	89 c1                	mov    %eax,%ecx
  802c65:	d3 eb                	shr    %cl,%ebx
  802c67:	09 de                	or     %ebx,%esi
  802c69:	89 f0                	mov    %esi,%eax
  802c6b:	f7 74 24 08          	divl   0x8(%esp)
  802c6f:	89 d6                	mov    %edx,%esi
  802c71:	89 c3                	mov    %eax,%ebx
  802c73:	f7 64 24 0c          	mull   0xc(%esp)
  802c77:	39 d6                	cmp    %edx,%esi
  802c79:	72 15                	jb     802c90 <__udivdi3+0x100>
  802c7b:	89 f9                	mov    %edi,%ecx
  802c7d:	d3 e5                	shl    %cl,%ebp
  802c7f:	39 c5                	cmp    %eax,%ebp
  802c81:	73 04                	jae    802c87 <__udivdi3+0xf7>
  802c83:	39 d6                	cmp    %edx,%esi
  802c85:	74 09                	je     802c90 <__udivdi3+0x100>
  802c87:	89 d8                	mov    %ebx,%eax
  802c89:	31 ff                	xor    %edi,%edi
  802c8b:	e9 27 ff ff ff       	jmp    802bb7 <__udivdi3+0x27>
  802c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c93:	31 ff                	xor    %edi,%edi
  802c95:	e9 1d ff ff ff       	jmp    802bb7 <__udivdi3+0x27>
  802c9a:	66 90                	xchg   %ax,%ax
  802c9c:	66 90                	xchg   %ax,%ax
  802c9e:	66 90                	xchg   %ax,%ax

00802ca0 <__umoddi3>:
  802ca0:	55                   	push   %ebp
  802ca1:	57                   	push   %edi
  802ca2:	56                   	push   %esi
  802ca3:	53                   	push   %ebx
  802ca4:	83 ec 1c             	sub    $0x1c,%esp
  802ca7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802caf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802cb7:	89 da                	mov    %ebx,%edx
  802cb9:	85 c0                	test   %eax,%eax
  802cbb:	75 43                	jne    802d00 <__umoddi3+0x60>
  802cbd:	39 df                	cmp    %ebx,%edi
  802cbf:	76 17                	jbe    802cd8 <__umoddi3+0x38>
  802cc1:	89 f0                	mov    %esi,%eax
  802cc3:	f7 f7                	div    %edi
  802cc5:	89 d0                	mov    %edx,%eax
  802cc7:	31 d2                	xor    %edx,%edx
  802cc9:	83 c4 1c             	add    $0x1c,%esp
  802ccc:	5b                   	pop    %ebx
  802ccd:	5e                   	pop    %esi
  802cce:	5f                   	pop    %edi
  802ccf:	5d                   	pop    %ebp
  802cd0:	c3                   	ret    
  802cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cd8:	89 fd                	mov    %edi,%ebp
  802cda:	85 ff                	test   %edi,%edi
  802cdc:	75 0b                	jne    802ce9 <__umoddi3+0x49>
  802cde:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce3:	31 d2                	xor    %edx,%edx
  802ce5:	f7 f7                	div    %edi
  802ce7:	89 c5                	mov    %eax,%ebp
  802ce9:	89 d8                	mov    %ebx,%eax
  802ceb:	31 d2                	xor    %edx,%edx
  802ced:	f7 f5                	div    %ebp
  802cef:	89 f0                	mov    %esi,%eax
  802cf1:	f7 f5                	div    %ebp
  802cf3:	89 d0                	mov    %edx,%eax
  802cf5:	eb d0                	jmp    802cc7 <__umoddi3+0x27>
  802cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cfe:	66 90                	xchg   %ax,%ax
  802d00:	89 f1                	mov    %esi,%ecx
  802d02:	39 d8                	cmp    %ebx,%eax
  802d04:	76 0a                	jbe    802d10 <__umoddi3+0x70>
  802d06:	89 f0                	mov    %esi,%eax
  802d08:	83 c4 1c             	add    $0x1c,%esp
  802d0b:	5b                   	pop    %ebx
  802d0c:	5e                   	pop    %esi
  802d0d:	5f                   	pop    %edi
  802d0e:	5d                   	pop    %ebp
  802d0f:	c3                   	ret    
  802d10:	0f bd e8             	bsr    %eax,%ebp
  802d13:	83 f5 1f             	xor    $0x1f,%ebp
  802d16:	75 20                	jne    802d38 <__umoddi3+0x98>
  802d18:	39 d8                	cmp    %ebx,%eax
  802d1a:	0f 82 b0 00 00 00    	jb     802dd0 <__umoddi3+0x130>
  802d20:	39 f7                	cmp    %esi,%edi
  802d22:	0f 86 a8 00 00 00    	jbe    802dd0 <__umoddi3+0x130>
  802d28:	89 c8                	mov    %ecx,%eax
  802d2a:	83 c4 1c             	add    $0x1c,%esp
  802d2d:	5b                   	pop    %ebx
  802d2e:	5e                   	pop    %esi
  802d2f:	5f                   	pop    %edi
  802d30:	5d                   	pop    %ebp
  802d31:	c3                   	ret    
  802d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d38:	89 e9                	mov    %ebp,%ecx
  802d3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802d3f:	29 ea                	sub    %ebp,%edx
  802d41:	d3 e0                	shl    %cl,%eax
  802d43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d47:	89 d1                	mov    %edx,%ecx
  802d49:	89 f8                	mov    %edi,%eax
  802d4b:	d3 e8                	shr    %cl,%eax
  802d4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d59:	09 c1                	or     %eax,%ecx
  802d5b:	89 d8                	mov    %ebx,%eax
  802d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d61:	89 e9                	mov    %ebp,%ecx
  802d63:	d3 e7                	shl    %cl,%edi
  802d65:	89 d1                	mov    %edx,%ecx
  802d67:	d3 e8                	shr    %cl,%eax
  802d69:	89 e9                	mov    %ebp,%ecx
  802d6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d6f:	d3 e3                	shl    %cl,%ebx
  802d71:	89 c7                	mov    %eax,%edi
  802d73:	89 d1                	mov    %edx,%ecx
  802d75:	89 f0                	mov    %esi,%eax
  802d77:	d3 e8                	shr    %cl,%eax
  802d79:	89 e9                	mov    %ebp,%ecx
  802d7b:	89 fa                	mov    %edi,%edx
  802d7d:	d3 e6                	shl    %cl,%esi
  802d7f:	09 d8                	or     %ebx,%eax
  802d81:	f7 74 24 08          	divl   0x8(%esp)
  802d85:	89 d1                	mov    %edx,%ecx
  802d87:	89 f3                	mov    %esi,%ebx
  802d89:	f7 64 24 0c          	mull   0xc(%esp)
  802d8d:	89 c6                	mov    %eax,%esi
  802d8f:	89 d7                	mov    %edx,%edi
  802d91:	39 d1                	cmp    %edx,%ecx
  802d93:	72 06                	jb     802d9b <__umoddi3+0xfb>
  802d95:	75 10                	jne    802da7 <__umoddi3+0x107>
  802d97:	39 c3                	cmp    %eax,%ebx
  802d99:	73 0c                	jae    802da7 <__umoddi3+0x107>
  802d9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802da3:	89 d7                	mov    %edx,%edi
  802da5:	89 c6                	mov    %eax,%esi
  802da7:	89 ca                	mov    %ecx,%edx
  802da9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802dae:	29 f3                	sub    %esi,%ebx
  802db0:	19 fa                	sbb    %edi,%edx
  802db2:	89 d0                	mov    %edx,%eax
  802db4:	d3 e0                	shl    %cl,%eax
  802db6:	89 e9                	mov    %ebp,%ecx
  802db8:	d3 eb                	shr    %cl,%ebx
  802dba:	d3 ea                	shr    %cl,%edx
  802dbc:	09 d8                	or     %ebx,%eax
  802dbe:	83 c4 1c             	add    $0x1c,%esp
  802dc1:	5b                   	pop    %ebx
  802dc2:	5e                   	pop    %esi
  802dc3:	5f                   	pop    %edi
  802dc4:	5d                   	pop    %ebp
  802dc5:	c3                   	ret    
  802dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dcd:	8d 76 00             	lea    0x0(%esi),%esi
  802dd0:	89 da                	mov    %ebx,%edx
  802dd2:	29 fe                	sub    %edi,%esi
  802dd4:	19 c2                	sbb    %eax,%edx
  802dd6:	89 f1                	mov    %esi,%ecx
  802dd8:	89 c8                	mov    %ecx,%eax
  802dda:	e9 4b ff ff ff       	jmp    802d2a <__umoddi3+0x8a>
