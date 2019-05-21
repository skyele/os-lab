
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
  80003b:	c7 05 04 30 80 00 a0 	movl   $0x8027a0,0x803004
  800042:	27 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 ed 1f 00 00       	call   80203b <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 9e 13 00 00       	call   8013fe <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 1e 01 00 00    	js     800188 <umain+0x155>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	0f 85 56 01 00 00    	jne    8001c6 <umain+0x193>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800070:	a1 04 40 80 00       	mov    0x804004,%eax
  800075:	8b 40 48             	mov    0x48(%eax),%eax
  800078:	83 ec 04             	sub    $0x4,%esp
  80007b:	ff 75 90             	pushl  -0x70(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 ce 27 80 00       	push   $0x8027ce
  800084:	e8 e6 03 00 00       	call   80046f <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 bc 17 00 00       	call   801850 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 04 40 80 00       	mov    0x804004,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 eb 27 80 00       	push   $0x8027eb
  8000a8:	e8 c2 03 00 00       	call   80046f <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 57 19 00 00       	call   801a15 <readn>
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
  8000d3:	ff 35 00 30 80 00    	pushl  0x803000
  8000d9:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000dc:	50                   	push   %eax
  8000dd:	e8 97 0b 00 00       	call   800c79 <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 11 28 80 00       	push   $0x802811
  8000f5:	e8 75 03 00 00       	call   80046f <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 65 02 00 00       	call   800367 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 ad 20 00 00       	call   8021b8 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 30 80 00 67 	movl   $0x802867,0x803004
  800112:	28 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 1b 1f 00 00       	call   80203b <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 cc 12 00 00       	call   8013fe <fork>
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
  800148:	e8 03 17 00 00       	call   801850 <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 f8 16 00 00       	call   801850 <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 58 20 00 00       	call   8021b8 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 95 28 80 00 	movl   $0x802895,(%esp)
  800167:	e8 03 03 00 00       	call   80046f <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 ac 27 80 00       	push   $0x8027ac
  80017c:	6a 0e                	push   $0xe
  80017e:	68 b5 27 80 00       	push   $0x8027b5
  800183:	e8 f1 01 00 00       	call   800379 <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 c5 27 80 00       	push   $0x8027c5
  80018e:	6a 11                	push   $0x11
  800190:	68 b5 27 80 00       	push   $0x8027b5
  800195:	e8 df 01 00 00       	call   800379 <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 08 28 80 00       	push   $0x802808
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 b5 27 80 00       	push   $0x8027b5
  8001a7:	e8 cd 01 00 00       	call   800379 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 2d 28 80 00       	push   $0x80282d
  8001b9:	e8 b1 02 00 00       	call   80046f <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 ce 27 80 00       	push   $0x8027ce
  8001da:	e8 90 02 00 00       	call   80046f <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 66 16 00 00       	call   801850 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 40 28 80 00       	push   $0x802840
  8001fe:	e8 6c 02 00 00       	call   80046f <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 30 80 00    	pushl  0x803000
  80020c:	e8 84 09 00 00       	call   800b95 <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 30 80 00    	pushl  0x803000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 37 18 00 00       	call   801a5a <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 30 80 00    	pushl  0x803000
  80022e:	e8 62 09 00 00       	call   800b95 <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 0b 16 00 00       	call   801850 <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 5d 28 80 00       	push   $0x80285d
  800253:	6a 25                	push   $0x25
  800255:	68 b5 27 80 00       	push   $0x8027b5
  80025a:	e8 1a 01 00 00       	call   800379 <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 ac 27 80 00       	push   $0x8027ac
  800265:	6a 2c                	push   $0x2c
  800267:	68 b5 27 80 00       	push   $0x8027b5
  80026c:	e8 08 01 00 00       	call   800379 <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 c5 27 80 00       	push   $0x8027c5
  800277:	6a 2f                	push   $0x2f
  800279:	68 b5 27 80 00       	push   $0x8027b5
  80027e:	e8 f6 00 00 00       	call   800379 <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 c2 15 00 00       	call   801850 <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 74 28 80 00       	push   $0x802874
  800299:	e8 d1 01 00 00       	call   80046f <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 76 28 80 00       	push   $0x802876
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 aa 17 00 00       	call   801a5a <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 78 28 80 00       	push   $0x802878
  8002c0:	e8 aa 01 00 00       	call   80046f <cprintf>
		exit();
  8002c5:	e8 9d 00 00 00       	call   800367 <exit>
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
  8002db:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8002e2:	00 00 00 
	envid_t find = sys_getenvid();
  8002e5:	e8 98 0c 00 00       	call   800f82 <sys_getenvid>
  8002ea:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
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
  800333:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033d:	7e 0a                	jle    800349 <libmain+0x77>
		binaryname = argv[0];
  80033f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800342:	8b 00                	mov    (%eax),%eax
  800344:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 dc fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800357:	e8 0b 00 00 00       	call   800367 <exit>
}
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800362:	5b                   	pop    %ebx
  800363:	5e                   	pop    %esi
  800364:	5f                   	pop    %edi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80036d:	6a 00                	push   $0x0
  80036f:	e8 cd 0b 00 00       	call   800f41 <sys_env_destroy>
}
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	56                   	push   %esi
  80037d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80037e:	a1 04 40 80 00       	mov    0x804004,%eax
  800383:	8b 40 48             	mov    0x48(%eax),%eax
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 28 29 80 00       	push   $0x802928
  80038e:	50                   	push   %eax
  80038f:	68 f6 28 80 00       	push   $0x8028f6
  800394:	e8 d6 00 00 00       	call   80046f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800399:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039c:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8003a2:	e8 db 0b 00 00       	call   800f82 <sys_getenvid>
  8003a7:	83 c4 04             	add    $0x4,%esp
  8003aa:	ff 75 0c             	pushl  0xc(%ebp)
  8003ad:	ff 75 08             	pushl  0x8(%ebp)
  8003b0:	56                   	push   %esi
  8003b1:	50                   	push   %eax
  8003b2:	68 04 29 80 00       	push   $0x802904
  8003b7:	e8 b3 00 00 00       	call   80046f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003bc:	83 c4 18             	add    $0x18,%esp
  8003bf:	53                   	push   %ebx
  8003c0:	ff 75 10             	pushl  0x10(%ebp)
  8003c3:	e8 56 00 00 00       	call   80041e <vcprintf>
	cprintf("\n");
  8003c8:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  8003cf:	e8 9b 00 00 00       	call   80046f <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d7:	cc                   	int3   
  8003d8:	eb fd                	jmp    8003d7 <_panic+0x5e>

008003da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	53                   	push   %ebx
  8003de:	83 ec 04             	sub    $0x4,%esp
  8003e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e4:	8b 13                	mov    (%ebx),%edx
  8003e6:	8d 42 01             	lea    0x1(%edx),%eax
  8003e9:	89 03                	mov    %eax,(%ebx)
  8003eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f7:	74 09                	je     800402 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800400:	c9                   	leave  
  800401:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800402:	83 ec 08             	sub    $0x8,%esp
  800405:	68 ff 00 00 00       	push   $0xff
  80040a:	8d 43 08             	lea    0x8(%ebx),%eax
  80040d:	50                   	push   %eax
  80040e:	e8 f1 0a 00 00       	call   800f04 <sys_cputs>
		b->idx = 0;
  800413:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	eb db                	jmp    8003f9 <putch+0x1f>

0080041e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800427:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042e:	00 00 00 
	b.cnt = 0;
  800431:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800438:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800447:	50                   	push   %eax
  800448:	68 da 03 80 00       	push   $0x8003da
  80044d:	e8 4a 01 00 00       	call   80059c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800452:	83 c4 08             	add    $0x8,%esp
  800455:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80045b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800461:	50                   	push   %eax
  800462:	e8 9d 0a 00 00       	call   800f04 <sys_cputs>

	return b.cnt;
}
  800467:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800475:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800478:	50                   	push   %eax
  800479:	ff 75 08             	pushl  0x8(%ebp)
  80047c:	e8 9d ff ff ff       	call   80041e <vcprintf>
	va_end(ap);

	return cnt;
}
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	57                   	push   %edi
  800487:	56                   	push   %esi
  800488:	53                   	push   %ebx
  800489:	83 ec 1c             	sub    $0x1c,%esp
  80048c:	89 c6                	mov    %eax,%esi
  80048e:	89 d7                	mov    %edx,%edi
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 55 0c             	mov    0xc(%ebp),%edx
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004a2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004a6:	74 2c                	je     8004d4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004b8:	39 c2                	cmp    %eax,%edx
  8004ba:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004bd:	73 43                	jae    800502 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8004bf:	83 eb 01             	sub    $0x1,%ebx
  8004c2:	85 db                	test   %ebx,%ebx
  8004c4:	7e 6c                	jle    800532 <printnum+0xaf>
				putch(padc, putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	57                   	push   %edi
  8004ca:	ff 75 18             	pushl  0x18(%ebp)
  8004cd:	ff d6                	call   *%esi
  8004cf:	83 c4 10             	add    $0x10,%esp
  8004d2:	eb eb                	jmp    8004bf <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 20                	push   $0x20
  8004d9:	6a 00                	push   $0x0
  8004db:	50                   	push   %eax
  8004dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004df:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e2:	89 fa                	mov    %edi,%edx
  8004e4:	89 f0                	mov    %esi,%eax
  8004e6:	e8 98 ff ff ff       	call   800483 <printnum>
		while (--width > 0)
  8004eb:	83 c4 20             	add    $0x20,%esp
  8004ee:	83 eb 01             	sub    $0x1,%ebx
  8004f1:	85 db                	test   %ebx,%ebx
  8004f3:	7e 65                	jle    80055a <printnum+0xd7>
			putch(padc, putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	57                   	push   %edi
  8004f9:	6a 20                	push   $0x20
  8004fb:	ff d6                	call   *%esi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	eb ec                	jmp    8004ee <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	ff 75 18             	pushl  0x18(%ebp)
  800508:	83 eb 01             	sub    $0x1,%ebx
  80050b:	53                   	push   %ebx
  80050c:	50                   	push   %eax
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	ff 75 dc             	pushl  -0x24(%ebp)
  800513:	ff 75 d8             	pushl  -0x28(%ebp)
  800516:	ff 75 e4             	pushl  -0x1c(%ebp)
  800519:	ff 75 e0             	pushl  -0x20(%ebp)
  80051c:	e8 2f 20 00 00       	call   802550 <__udivdi3>
  800521:	83 c4 18             	add    $0x18,%esp
  800524:	52                   	push   %edx
  800525:	50                   	push   %eax
  800526:	89 fa                	mov    %edi,%edx
  800528:	89 f0                	mov    %esi,%eax
  80052a:	e8 54 ff ff ff       	call   800483 <printnum>
  80052f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	57                   	push   %edi
  800536:	83 ec 04             	sub    $0x4,%esp
  800539:	ff 75 dc             	pushl  -0x24(%ebp)
  80053c:	ff 75 d8             	pushl  -0x28(%ebp)
  80053f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800542:	ff 75 e0             	pushl  -0x20(%ebp)
  800545:	e8 16 21 00 00       	call   802660 <__umoddi3>
  80054a:	83 c4 14             	add    $0x14,%esp
  80054d:	0f be 80 2f 29 80 00 	movsbl 0x80292f(%eax),%eax
  800554:	50                   	push   %eax
  800555:	ff d6                	call   *%esi
  800557:	83 c4 10             	add    $0x10,%esp
	}
}
  80055a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055d:	5b                   	pop    %ebx
  80055e:	5e                   	pop    %esi
  80055f:	5f                   	pop    %edi
  800560:	5d                   	pop    %ebp
  800561:	c3                   	ret    

00800562 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800568:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80056c:	8b 10                	mov    (%eax),%edx
  80056e:	3b 50 04             	cmp    0x4(%eax),%edx
  800571:	73 0a                	jae    80057d <sprintputch+0x1b>
		*b->buf++ = ch;
  800573:	8d 4a 01             	lea    0x1(%edx),%ecx
  800576:	89 08                	mov    %ecx,(%eax)
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	88 02                	mov    %al,(%edx)
}
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <printfmt>:
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800585:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800588:	50                   	push   %eax
  800589:	ff 75 10             	pushl  0x10(%ebp)
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	e8 05 00 00 00       	call   80059c <vprintfmt>
}
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <vprintfmt>:
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	57                   	push   %edi
  8005a0:	56                   	push   %esi
  8005a1:	53                   	push   %ebx
  8005a2:	83 ec 3c             	sub    $0x3c,%esp
  8005a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ae:	e9 32 04 00 00       	jmp    8009e5 <vprintfmt+0x449>
		padc = ' ';
  8005b3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8005b7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8005be:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005c5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8d 47 01             	lea    0x1(%edi),%eax
  8005e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e5:	0f b6 17             	movzbl (%edi),%edx
  8005e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005eb:	3c 55                	cmp    $0x55,%al
  8005ed:	0f 87 12 05 00 00    	ja     800b05 <vprintfmt+0x569>
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
  8005fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800600:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800604:	eb d9                	jmp    8005df <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800606:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800609:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80060d:	eb d0                	jmp    8005df <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80060f:	0f b6 d2             	movzbl %dl,%edx
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800615:	b8 00 00 00 00       	mov    $0x0,%eax
  80061a:	89 75 08             	mov    %esi,0x8(%ebp)
  80061d:	eb 03                	jmp    800622 <vprintfmt+0x86>
  80061f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800622:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800625:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800629:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80062c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80062f:	83 fe 09             	cmp    $0x9,%esi
  800632:	76 eb                	jbe    80061f <vprintfmt+0x83>
  800634:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800637:	8b 75 08             	mov    0x8(%ebp),%esi
  80063a:	eb 14                	jmp    800650 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80064d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800650:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800654:	79 89                	jns    8005df <vprintfmt+0x43>
				width = precision, precision = -1;
  800656:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800659:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800663:	e9 77 ff ff ff       	jmp    8005df <vprintfmt+0x43>
  800668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066b:	85 c0                	test   %eax,%eax
  80066d:	0f 48 c1             	cmovs  %ecx,%eax
  800670:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800676:	e9 64 ff ff ff       	jmp    8005df <vprintfmt+0x43>
  80067b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80067e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800685:	e9 55 ff ff ff       	jmp    8005df <vprintfmt+0x43>
			lflag++;
  80068a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80068e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800691:	e9 49 ff ff ff       	jmp    8005df <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 78 04             	lea    0x4(%eax),%edi
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	ff 30                	pushl  (%eax)
  8006a2:	ff d6                	call   *%esi
			break;
  8006a4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006a7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006aa:	e9 33 03 00 00       	jmp    8009e2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 78 04             	lea    0x4(%eax),%edi
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	99                   	cltd   
  8006b8:	31 d0                	xor    %edx,%eax
  8006ba:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006bc:	83 f8 0f             	cmp    $0xf,%eax
  8006bf:	7f 23                	jg     8006e4 <vprintfmt+0x148>
  8006c1:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  8006c8:	85 d2                	test   %edx,%edx
  8006ca:	74 18                	je     8006e4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006cc:	52                   	push   %edx
  8006cd:	68 92 2e 80 00       	push   $0x802e92
  8006d2:	53                   	push   %ebx
  8006d3:	56                   	push   %esi
  8006d4:	e8 a6 fe ff ff       	call   80057f <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006dc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006df:	e9 fe 02 00 00       	jmp    8009e2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006e4:	50                   	push   %eax
  8006e5:	68 47 29 80 00       	push   $0x802947
  8006ea:	53                   	push   %ebx
  8006eb:	56                   	push   %esi
  8006ec:	e8 8e fe ff ff       	call   80057f <printfmt>
  8006f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006f4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006f7:	e9 e6 02 00 00       	jmp    8009e2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	83 c0 04             	add    $0x4,%eax
  800702:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80070a:	85 c9                	test   %ecx,%ecx
  80070c:	b8 40 29 80 00       	mov    $0x802940,%eax
  800711:	0f 45 c1             	cmovne %ecx,%eax
  800714:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800717:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80071b:	7e 06                	jle    800723 <vprintfmt+0x187>
  80071d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800721:	75 0d                	jne    800730 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	89 c7                	mov    %eax,%edi
  800728:	03 45 e0             	add    -0x20(%ebp),%eax
  80072b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80072e:	eb 53                	jmp    800783 <vprintfmt+0x1e7>
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 d8             	pushl  -0x28(%ebp)
  800736:	50                   	push   %eax
  800737:	e8 71 04 00 00       	call   800bad <strnlen>
  80073c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80073f:	29 c1                	sub    %eax,%ecx
  800741:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800749:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80074d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800750:	eb 0f                	jmp    800761 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	ff 75 e0             	pushl  -0x20(%ebp)
  800759:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80075b:	83 ef 01             	sub    $0x1,%edi
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	85 ff                	test   %edi,%edi
  800763:	7f ed                	jg     800752 <vprintfmt+0x1b6>
  800765:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800768:	85 c9                	test   %ecx,%ecx
  80076a:	b8 00 00 00 00       	mov    $0x0,%eax
  80076f:	0f 49 c1             	cmovns %ecx,%eax
  800772:	29 c1                	sub    %eax,%ecx
  800774:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800777:	eb aa                	jmp    800723 <vprintfmt+0x187>
					putch(ch, putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	52                   	push   %edx
  80077e:	ff d6                	call   *%esi
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800786:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800788:	83 c7 01             	add    $0x1,%edi
  80078b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80078f:	0f be d0             	movsbl %al,%edx
  800792:	85 d2                	test   %edx,%edx
  800794:	74 4b                	je     8007e1 <vprintfmt+0x245>
  800796:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80079a:	78 06                	js     8007a2 <vprintfmt+0x206>
  80079c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007a0:	78 1e                	js     8007c0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007a2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007a6:	74 d1                	je     800779 <vprintfmt+0x1dd>
  8007a8:	0f be c0             	movsbl %al,%eax
  8007ab:	83 e8 20             	sub    $0x20,%eax
  8007ae:	83 f8 5e             	cmp    $0x5e,%eax
  8007b1:	76 c6                	jbe    800779 <vprintfmt+0x1dd>
					putch('?', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 3f                	push   $0x3f
  8007b9:	ff d6                	call   *%esi
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	eb c3                	jmp    800783 <vprintfmt+0x1e7>
  8007c0:	89 cf                	mov    %ecx,%edi
  8007c2:	eb 0e                	jmp    8007d2 <vprintfmt+0x236>
				putch(' ', putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	6a 20                	push   $0x20
  8007ca:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007cc:	83 ef 01             	sub    $0x1,%edi
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	85 ff                	test   %edi,%edi
  8007d4:	7f ee                	jg     8007c4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	e9 01 02 00 00       	jmp    8009e2 <vprintfmt+0x446>
  8007e1:	89 cf                	mov    %ecx,%edi
  8007e3:	eb ed                	jmp    8007d2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007e8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007ef:	e9 eb fd ff ff       	jmp    8005df <vprintfmt+0x43>
	if (lflag >= 2)
  8007f4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f8:	7f 21                	jg     80081b <vprintfmt+0x27f>
	else if (lflag)
  8007fa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007fe:	74 68                	je     800868 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800808:	89 c1                	mov    %eax,%ecx
  80080a:	c1 f9 1f             	sar    $0x1f,%ecx
  80080d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8d 40 04             	lea    0x4(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
  800819:	eb 17                	jmp    800832 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8b 50 04             	mov    0x4(%eax),%edx
  800821:	8b 00                	mov    (%eax),%eax
  800823:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800826:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8d 40 08             	lea    0x8(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800832:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800835:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800838:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80083e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800842:	78 3f                	js     800883 <vprintfmt+0x2e7>
			base = 10;
  800844:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800849:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80084d:	0f 84 71 01 00 00    	je     8009c4 <vprintfmt+0x428>
				putch('+', putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	53                   	push   %ebx
  800857:	6a 2b                	push   $0x2b
  800859:	ff d6                	call   *%esi
  80085b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80085e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800863:	e9 5c 01 00 00       	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800870:	89 c1                	mov    %eax,%ecx
  800872:	c1 f9 1f             	sar    $0x1f,%ecx
  800875:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 40 04             	lea    0x4(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	eb af                	jmp    800832 <vprintfmt+0x296>
				putch('-', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	6a 2d                	push   $0x2d
  800889:	ff d6                	call   *%esi
				num = -(long long) num;
  80088b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80088e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800891:	f7 d8                	neg    %eax
  800893:	83 d2 00             	adc    $0x0,%edx
  800896:	f7 da                	neg    %edx
  800898:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008a6:	e9 19 01 00 00       	jmp    8009c4 <vprintfmt+0x428>
	if (lflag >= 2)
  8008ab:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008af:	7f 29                	jg     8008da <vprintfmt+0x33e>
	else if (lflag)
  8008b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008b5:	74 44                	je     8008fb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8d 40 04             	lea    0x4(%eax),%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008d5:	e9 ea 00 00 00       	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	8b 50 04             	mov    0x4(%eax),%edx
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	8d 40 08             	lea    0x8(%eax),%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f6:	e9 c9 00 00 00       	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
  800905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800908:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8d 40 04             	lea    0x4(%eax),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800914:	b8 0a 00 00 00       	mov    $0xa,%eax
  800919:	e9 a6 00 00 00       	jmp    8009c4 <vprintfmt+0x428>
			putch('0', putdat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	53                   	push   %ebx
  800922:	6a 30                	push   $0x30
  800924:	ff d6                	call   *%esi
	if (lflag >= 2)
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80092d:	7f 26                	jg     800955 <vprintfmt+0x3b9>
	else if (lflag)
  80092f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800933:	74 3e                	je     800973 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	ba 00 00 00 00       	mov    $0x0,%edx
  80093f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800942:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8d 40 04             	lea    0x4(%eax),%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80094e:	b8 08 00 00 00       	mov    $0x8,%eax
  800953:	eb 6f                	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 50 04             	mov    0x4(%eax),%edx
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800960:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8d 40 08             	lea    0x8(%eax),%eax
  800969:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80096c:	b8 08 00 00 00       	mov    $0x8,%eax
  800971:	eb 51                	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
  80097d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800980:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800983:	8b 45 14             	mov    0x14(%ebp),%eax
  800986:	8d 40 04             	lea    0x4(%eax),%eax
  800989:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80098c:	b8 08 00 00 00       	mov    $0x8,%eax
  800991:	eb 31                	jmp    8009c4 <vprintfmt+0x428>
			putch('0', putdat);
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	53                   	push   %ebx
  800997:	6a 30                	push   $0x30
  800999:	ff d6                	call   *%esi
			putch('x', putdat);
  80099b:	83 c4 08             	add    $0x8,%esp
  80099e:	53                   	push   %ebx
  80099f:	6a 78                	push   $0x78
  8009a1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009b3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8d 40 04             	lea    0x4(%eax),%eax
  8009bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009bf:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009c4:	83 ec 0c             	sub    $0xc,%esp
  8009c7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009cb:	52                   	push   %edx
  8009cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8009cf:	50                   	push   %eax
  8009d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8009d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8009d6:	89 da                	mov    %ebx,%edx
  8009d8:	89 f0                	mov    %esi,%eax
  8009da:	e8 a4 fa ff ff       	call   800483 <printnum>
			break;
  8009df:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e5:	83 c7 01             	add    $0x1,%edi
  8009e8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009ec:	83 f8 25             	cmp    $0x25,%eax
  8009ef:	0f 84 be fb ff ff    	je     8005b3 <vprintfmt+0x17>
			if (ch == '\0')
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	0f 84 28 01 00 00    	je     800b25 <vprintfmt+0x589>
			putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	53                   	push   %ebx
  800a01:	50                   	push   %eax
  800a02:	ff d6                	call   *%esi
  800a04:	83 c4 10             	add    $0x10,%esp
  800a07:	eb dc                	jmp    8009e5 <vprintfmt+0x449>
	if (lflag >= 2)
  800a09:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a0d:	7f 26                	jg     800a35 <vprintfmt+0x499>
	else if (lflag)
  800a0f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a13:	74 41                	je     800a56 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8d 40 04             	lea    0x4(%eax),%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a2e:	b8 10 00 00 00       	mov    $0x10,%eax
  800a33:	eb 8f                	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	8b 50 04             	mov    0x4(%eax),%edx
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a40:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	8d 40 08             	lea    0x8(%eax),%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a4c:	b8 10 00 00 00       	mov    $0x10,%eax
  800a51:	e9 6e ff ff ff       	jmp    8009c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a63:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	8d 40 04             	lea    0x4(%eax),%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a6f:	b8 10 00 00 00       	mov    $0x10,%eax
  800a74:	e9 4b ff ff ff       	jmp    8009c4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 c0 04             	add    $0x4,%eax
  800a7f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	85 c0                	test   %eax,%eax
  800a89:	74 14                	je     800a9f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a8b:	8b 13                	mov    (%ebx),%edx
  800a8d:	83 fa 7f             	cmp    $0x7f,%edx
  800a90:	7f 37                	jg     800ac9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a92:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9a:	e9 43 ff ff ff       	jmp    8009e2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a9f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa4:	bf 65 2a 80 00       	mov    $0x802a65,%edi
							putch(ch, putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	53                   	push   %ebx
  800aad:	50                   	push   %eax
  800aae:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ab0:	83 c7 01             	add    $0x1,%edi
  800ab3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ab7:	83 c4 10             	add    $0x10,%esp
  800aba:	85 c0                	test   %eax,%eax
  800abc:	75 eb                	jne    800aa9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800abe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ac1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac4:	e9 19 ff ff ff       	jmp    8009e2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ac9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800acb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad0:	bf 9d 2a 80 00       	mov    $0x802a9d,%edi
							putch(ch, putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	53                   	push   %ebx
  800ad9:	50                   	push   %eax
  800ada:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800adc:	83 c7 01             	add    $0x1,%edi
  800adf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 eb                	jne    800ad5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
  800af0:	e9 ed fe ff ff       	jmp    8009e2 <vprintfmt+0x446>
			putch(ch, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	53                   	push   %ebx
  800af9:	6a 25                	push   $0x25
  800afb:	ff d6                	call   *%esi
			break;
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	e9 dd fe ff ff       	jmp    8009e2 <vprintfmt+0x446>
			putch('%', putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	53                   	push   %ebx
  800b09:	6a 25                	push   $0x25
  800b0b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	eb 03                	jmp    800b17 <vprintfmt+0x57b>
  800b14:	83 e8 01             	sub    $0x1,%eax
  800b17:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b1b:	75 f7                	jne    800b14 <vprintfmt+0x578>
  800b1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b20:	e9 bd fe ff ff       	jmp    8009e2 <vprintfmt+0x446>
}
  800b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5f                   	pop    %edi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 18             	sub    $0x18,%esp
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b40:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	74 26                	je     800b74 <vsnprintf+0x47>
  800b4e:	85 d2                	test   %edx,%edx
  800b50:	7e 22                	jle    800b74 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b52:	ff 75 14             	pushl  0x14(%ebp)
  800b55:	ff 75 10             	pushl  0x10(%ebp)
  800b58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b5b:	50                   	push   %eax
  800b5c:	68 62 05 80 00       	push   $0x800562
  800b61:	e8 36 fa ff ff       	call   80059c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b69:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    
		return -E_INVAL;
  800b74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b79:	eb f7                	jmp    800b72 <vsnprintf+0x45>

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b84:	50                   	push   %eax
  800b85:	ff 75 10             	pushl  0x10(%ebp)
  800b88:	ff 75 0c             	pushl  0xc(%ebp)
  800b8b:	ff 75 08             	pushl  0x8(%ebp)
  800b8e:	e8 9a ff ff ff       	call   800b2d <vsnprintf>
	va_end(ap);

	return rc;
}
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ba4:	74 05                	je     800bab <strlen+0x16>
		n++;
  800ba6:	83 c0 01             	add    $0x1,%eax
  800ba9:	eb f5                	jmp    800ba0 <strlen+0xb>
	return n;
}
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbb:	39 c2                	cmp    %eax,%edx
  800bbd:	74 0d                	je     800bcc <strnlen+0x1f>
  800bbf:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bc3:	74 05                	je     800bca <strnlen+0x1d>
		n++;
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	eb f1                	jmp    800bbb <strnlen+0xe>
  800bca:	89 d0                	mov    %edx,%eax
	return n;
}
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	53                   	push   %ebx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800be1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800be4:	83 c2 01             	add    $0x1,%edx
  800be7:	84 c9                	test   %cl,%cl
  800be9:	75 f2                	jne    800bdd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800beb:	5b                   	pop    %ebx
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	53                   	push   %ebx
  800bf2:	83 ec 10             	sub    $0x10,%esp
  800bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bf8:	53                   	push   %ebx
  800bf9:	e8 97 ff ff ff       	call   800b95 <strlen>
  800bfe:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	01 d8                	add    %ebx,%eax
  800c06:	50                   	push   %eax
  800c07:	e8 c2 ff ff ff       	call   800bce <strcpy>
	return dst;
}
  800c0c:	89 d8                	mov    %ebx,%eax
  800c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	89 c6                	mov    %eax,%esi
  800c20:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c23:	89 c2                	mov    %eax,%edx
  800c25:	39 f2                	cmp    %esi,%edx
  800c27:	74 11                	je     800c3a <strncpy+0x27>
		*dst++ = *src;
  800c29:	83 c2 01             	add    $0x1,%edx
  800c2c:	0f b6 19             	movzbl (%ecx),%ebx
  800c2f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c32:	80 fb 01             	cmp    $0x1,%bl
  800c35:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c38:	eb eb                	jmp    800c25 <strncpy+0x12>
	}
	return ret;
}
  800c3a:	5b                   	pop    %ebx
  800c3b:	5e                   	pop    %esi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	8b 75 08             	mov    0x8(%ebp),%esi
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	8b 55 10             	mov    0x10(%ebp),%edx
  800c4c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c4e:	85 d2                	test   %edx,%edx
  800c50:	74 21                	je     800c73 <strlcpy+0x35>
  800c52:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c56:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c58:	39 c2                	cmp    %eax,%edx
  800c5a:	74 14                	je     800c70 <strlcpy+0x32>
  800c5c:	0f b6 19             	movzbl (%ecx),%ebx
  800c5f:	84 db                	test   %bl,%bl
  800c61:	74 0b                	je     800c6e <strlcpy+0x30>
			*dst++ = *src++;
  800c63:	83 c1 01             	add    $0x1,%ecx
  800c66:	83 c2 01             	add    $0x1,%edx
  800c69:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c6c:	eb ea                	jmp    800c58 <strlcpy+0x1a>
  800c6e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c70:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c73:	29 f0                	sub    %esi,%eax
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c82:	0f b6 01             	movzbl (%ecx),%eax
  800c85:	84 c0                	test   %al,%al
  800c87:	74 0c                	je     800c95 <strcmp+0x1c>
  800c89:	3a 02                	cmp    (%edx),%al
  800c8b:	75 08                	jne    800c95 <strcmp+0x1c>
		p++, q++;
  800c8d:	83 c1 01             	add    $0x1,%ecx
  800c90:	83 c2 01             	add    $0x1,%edx
  800c93:	eb ed                	jmp    800c82 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c95:	0f b6 c0             	movzbl %al,%eax
  800c98:	0f b6 12             	movzbl (%edx),%edx
  800c9b:	29 d0                	sub    %edx,%eax
}
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	53                   	push   %ebx
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca9:	89 c3                	mov    %eax,%ebx
  800cab:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cae:	eb 06                	jmp    800cb6 <strncmp+0x17>
		n--, p++, q++;
  800cb0:	83 c0 01             	add    $0x1,%eax
  800cb3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cb6:	39 d8                	cmp    %ebx,%eax
  800cb8:	74 16                	je     800cd0 <strncmp+0x31>
  800cba:	0f b6 08             	movzbl (%eax),%ecx
  800cbd:	84 c9                	test   %cl,%cl
  800cbf:	74 04                	je     800cc5 <strncmp+0x26>
  800cc1:	3a 0a                	cmp    (%edx),%cl
  800cc3:	74 eb                	je     800cb0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc5:	0f b6 00             	movzbl (%eax),%eax
  800cc8:	0f b6 12             	movzbl (%edx),%edx
  800ccb:	29 d0                	sub    %edx,%eax
}
  800ccd:	5b                   	pop    %ebx
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    
		return 0;
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd5:	eb f6                	jmp    800ccd <strncmp+0x2e>

00800cd7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce1:	0f b6 10             	movzbl (%eax),%edx
  800ce4:	84 d2                	test   %dl,%dl
  800ce6:	74 09                	je     800cf1 <strchr+0x1a>
		if (*s == c)
  800ce8:	38 ca                	cmp    %cl,%dl
  800cea:	74 0a                	je     800cf6 <strchr+0x1f>
	for (; *s; s++)
  800cec:	83 c0 01             	add    $0x1,%eax
  800cef:	eb f0                	jmp    800ce1 <strchr+0xa>
			return (char *) s;
	return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d02:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d05:	38 ca                	cmp    %cl,%dl
  800d07:	74 09                	je     800d12 <strfind+0x1a>
  800d09:	84 d2                	test   %dl,%dl
  800d0b:	74 05                	je     800d12 <strfind+0x1a>
	for (; *s; s++)
  800d0d:	83 c0 01             	add    $0x1,%eax
  800d10:	eb f0                	jmp    800d02 <strfind+0xa>
			break;
	return (char *) s;
}
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
  800d1a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d20:	85 c9                	test   %ecx,%ecx
  800d22:	74 31                	je     800d55 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d24:	89 f8                	mov    %edi,%eax
  800d26:	09 c8                	or     %ecx,%eax
  800d28:	a8 03                	test   $0x3,%al
  800d2a:	75 23                	jne    800d4f <memset+0x3b>
		c &= 0xFF;
  800d2c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d30:	89 d3                	mov    %edx,%ebx
  800d32:	c1 e3 08             	shl    $0x8,%ebx
  800d35:	89 d0                	mov    %edx,%eax
  800d37:	c1 e0 18             	shl    $0x18,%eax
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	c1 e6 10             	shl    $0x10,%esi
  800d3f:	09 f0                	or     %esi,%eax
  800d41:	09 c2                	or     %eax,%edx
  800d43:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d45:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d48:	89 d0                	mov    %edx,%eax
  800d4a:	fc                   	cld    
  800d4b:	f3 ab                	rep stos %eax,%es:(%edi)
  800d4d:	eb 06                	jmp    800d55 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	fc                   	cld    
  800d53:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d55:	89 f8                	mov    %edi,%eax
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d67:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d6a:	39 c6                	cmp    %eax,%esi
  800d6c:	73 32                	jae    800da0 <memmove+0x44>
  800d6e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	76 2b                	jbe    800da0 <memmove+0x44>
		s += n;
		d += n;
  800d75:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d78:	89 fe                	mov    %edi,%esi
  800d7a:	09 ce                	or     %ecx,%esi
  800d7c:	09 d6                	or     %edx,%esi
  800d7e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d84:	75 0e                	jne    800d94 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d86:	83 ef 04             	sub    $0x4,%edi
  800d89:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d8c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d8f:	fd                   	std    
  800d90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d92:	eb 09                	jmp    800d9d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d94:	83 ef 01             	sub    $0x1,%edi
  800d97:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d9a:	fd                   	std    
  800d9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d9d:	fc                   	cld    
  800d9e:	eb 1a                	jmp    800dba <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800da0:	89 c2                	mov    %eax,%edx
  800da2:	09 ca                	or     %ecx,%edx
  800da4:	09 f2                	or     %esi,%edx
  800da6:	f6 c2 03             	test   $0x3,%dl
  800da9:	75 0a                	jne    800db5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dab:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dae:	89 c7                	mov    %eax,%edi
  800db0:	fc                   	cld    
  800db1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db3:	eb 05                	jmp    800dba <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800db5:	89 c7                	mov    %eax,%edi
  800db7:	fc                   	cld    
  800db8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dc4:	ff 75 10             	pushl  0x10(%ebp)
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 8a ff ff ff       	call   800d5c <memmove>
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddf:	89 c6                	mov    %eax,%esi
  800de1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800de4:	39 f0                	cmp    %esi,%eax
  800de6:	74 1c                	je     800e04 <memcmp+0x30>
		if (*s1 != *s2)
  800de8:	0f b6 08             	movzbl (%eax),%ecx
  800deb:	0f b6 1a             	movzbl (%edx),%ebx
  800dee:	38 d9                	cmp    %bl,%cl
  800df0:	75 08                	jne    800dfa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800df2:	83 c0 01             	add    $0x1,%eax
  800df5:	83 c2 01             	add    $0x1,%edx
  800df8:	eb ea                	jmp    800de4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dfa:	0f b6 c1             	movzbl %cl,%eax
  800dfd:	0f b6 db             	movzbl %bl,%ebx
  800e00:	29 d8                	sub    %ebx,%eax
  800e02:	eb 05                	jmp    800e09 <memcmp+0x35>
	}

	return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e16:	89 c2                	mov    %eax,%edx
  800e18:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e1b:	39 d0                	cmp    %edx,%eax
  800e1d:	73 09                	jae    800e28 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e1f:	38 08                	cmp    %cl,(%eax)
  800e21:	74 05                	je     800e28 <memfind+0x1b>
	for (; s < ends; s++)
  800e23:	83 c0 01             	add    $0x1,%eax
  800e26:	eb f3                	jmp    800e1b <memfind+0xe>
			break;
	return (void *) s;
}
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e36:	eb 03                	jmp    800e3b <strtol+0x11>
		s++;
  800e38:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e3b:	0f b6 01             	movzbl (%ecx),%eax
  800e3e:	3c 20                	cmp    $0x20,%al
  800e40:	74 f6                	je     800e38 <strtol+0xe>
  800e42:	3c 09                	cmp    $0x9,%al
  800e44:	74 f2                	je     800e38 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e46:	3c 2b                	cmp    $0x2b,%al
  800e48:	74 2a                	je     800e74 <strtol+0x4a>
	int neg = 0;
  800e4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e4f:	3c 2d                	cmp    $0x2d,%al
  800e51:	74 2b                	je     800e7e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e53:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e59:	75 0f                	jne    800e6a <strtol+0x40>
  800e5b:	80 39 30             	cmpb   $0x30,(%ecx)
  800e5e:	74 28                	je     800e88 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e60:	85 db                	test   %ebx,%ebx
  800e62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e67:	0f 44 d8             	cmove  %eax,%ebx
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e72:	eb 50                	jmp    800ec4 <strtol+0x9a>
		s++;
  800e74:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e77:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7c:	eb d5                	jmp    800e53 <strtol+0x29>
		s++, neg = 1;
  800e7e:	83 c1 01             	add    $0x1,%ecx
  800e81:	bf 01 00 00 00       	mov    $0x1,%edi
  800e86:	eb cb                	jmp    800e53 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e8c:	74 0e                	je     800e9c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e8e:	85 db                	test   %ebx,%ebx
  800e90:	75 d8                	jne    800e6a <strtol+0x40>
		s++, base = 8;
  800e92:	83 c1 01             	add    $0x1,%ecx
  800e95:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e9a:	eb ce                	jmp    800e6a <strtol+0x40>
		s += 2, base = 16;
  800e9c:	83 c1 02             	add    $0x2,%ecx
  800e9f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ea4:	eb c4                	jmp    800e6a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ea6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ea9:	89 f3                	mov    %esi,%ebx
  800eab:	80 fb 19             	cmp    $0x19,%bl
  800eae:	77 29                	ja     800ed9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800eb0:	0f be d2             	movsbl %dl,%edx
  800eb3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800eb6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800eb9:	7d 30                	jge    800eeb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ebb:	83 c1 01             	add    $0x1,%ecx
  800ebe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ec2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ec4:	0f b6 11             	movzbl (%ecx),%edx
  800ec7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eca:	89 f3                	mov    %esi,%ebx
  800ecc:	80 fb 09             	cmp    $0x9,%bl
  800ecf:	77 d5                	ja     800ea6 <strtol+0x7c>
			dig = *s - '0';
  800ed1:	0f be d2             	movsbl %dl,%edx
  800ed4:	83 ea 30             	sub    $0x30,%edx
  800ed7:	eb dd                	jmp    800eb6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ed9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800edc:	89 f3                	mov    %esi,%ebx
  800ede:	80 fb 19             	cmp    $0x19,%bl
  800ee1:	77 08                	ja     800eeb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ee3:	0f be d2             	movsbl %dl,%edx
  800ee6:	83 ea 37             	sub    $0x37,%edx
  800ee9:	eb cb                	jmp    800eb6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800eeb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eef:	74 05                	je     800ef6 <strtol+0xcc>
		*endptr = (char *) s;
  800ef1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ef4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ef6:	89 c2                	mov    %eax,%edx
  800ef8:	f7 da                	neg    %edx
  800efa:	85 ff                	test   %edi,%edi
  800efc:	0f 45 c2             	cmovne %edx,%eax
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f15:	89 c3                	mov    %eax,%ebx
  800f17:	89 c7                	mov    %eax,%edi
  800f19:	89 c6                	mov    %eax,%esi
  800f1b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    

00800f22 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  800f32:	89 d1                	mov    %edx,%ecx
  800f34:	89 d3                	mov    %edx,%ebx
  800f36:	89 d7                	mov    %edx,%edi
  800f38:	89 d6                	mov    %edx,%esi
  800f3a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	57                   	push   %edi
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
  800f47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	b8 03 00 00 00       	mov    $0x3,%eax
  800f57:	89 cb                	mov    %ecx,%ebx
  800f59:	89 cf                	mov    %ecx,%edi
  800f5b:	89 ce                	mov    %ecx,%esi
  800f5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7f 08                	jg     800f6b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	50                   	push   %eax
  800f6f:	6a 03                	push   $0x3
  800f71:	68 a0 2c 80 00       	push   $0x802ca0
  800f76:	6a 43                	push   $0x43
  800f78:	68 bd 2c 80 00       	push   $0x802cbd
  800f7d:	e8 f7 f3 ff ff       	call   800379 <_panic>

00800f82 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	b8 02 00 00 00       	mov    $0x2,%eax
  800f92:	89 d1                	mov    %edx,%ecx
  800f94:	89 d3                	mov    %edx,%ebx
  800f96:	89 d7                	mov    %edx,%edi
  800f98:	89 d6                	mov    %edx,%esi
  800f9a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_yield>:

void
sys_yield(void)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fac:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 d3                	mov    %edx,%ebx
  800fb5:	89 d7                	mov    %edx,%edi
  800fb7:	89 d6                	mov    %edx,%esi
  800fb9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc9:	be 00 00 00 00       	mov    $0x0,%esi
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd4:	b8 04 00 00 00       	mov    $0x4,%eax
  800fd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdc:	89 f7                	mov    %esi,%edi
  800fde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	7f 08                	jg     800fec <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	6a 04                	push   $0x4
  800ff2:	68 a0 2c 80 00       	push   $0x802ca0
  800ff7:	6a 43                	push   $0x43
  800ff9:	68 bd 2c 80 00       	push   $0x802cbd
  800ffe:	e8 76 f3 ff ff       	call   800379 <_panic>

00801003 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801012:	b8 05 00 00 00       	mov    $0x5,%eax
  801017:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80101a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80101d:	8b 75 18             	mov    0x18(%ebp),%esi
  801020:	cd 30                	int    $0x30
	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7f 08                	jg     80102e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	50                   	push   %eax
  801032:	6a 05                	push   $0x5
  801034:	68 a0 2c 80 00       	push   $0x802ca0
  801039:	6a 43                	push   $0x43
  80103b:	68 bd 2c 80 00       	push   $0x802cbd
  801040:	e8 34 f3 ff ff       	call   800379 <_panic>

00801045 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
  80104b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801059:	b8 06 00 00 00       	mov    $0x6,%eax
  80105e:	89 df                	mov    %ebx,%edi
  801060:	89 de                	mov    %ebx,%esi
  801062:	cd 30                	int    $0x30
	if(check && ret > 0)
  801064:	85 c0                	test   %eax,%eax
  801066:	7f 08                	jg     801070 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801070:	83 ec 0c             	sub    $0xc,%esp
  801073:	50                   	push   %eax
  801074:	6a 06                	push   $0x6
  801076:	68 a0 2c 80 00       	push   $0x802ca0
  80107b:	6a 43                	push   $0x43
  80107d:	68 bd 2c 80 00       	push   $0x802cbd
  801082:	e8 f2 f2 ff ff       	call   800379 <_panic>

00801087 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	57                   	push   %edi
  80108b:	56                   	push   %esi
  80108c:	53                   	push   %ebx
  80108d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a0:	89 df                	mov    %ebx,%edi
  8010a2:	89 de                	mov    %ebx,%esi
  8010a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	7f 08                	jg     8010b2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b2:	83 ec 0c             	sub    $0xc,%esp
  8010b5:	50                   	push   %eax
  8010b6:	6a 08                	push   $0x8
  8010b8:	68 a0 2c 80 00       	push   $0x802ca0
  8010bd:	6a 43                	push   $0x43
  8010bf:	68 bd 2c 80 00       	push   $0x802cbd
  8010c4:	e8 b0 f2 ff ff       	call   800379 <_panic>

008010c9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dd:	b8 09 00 00 00       	mov    $0x9,%eax
  8010e2:	89 df                	mov    %ebx,%edi
  8010e4:	89 de                	mov    %ebx,%esi
  8010e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	7f 08                	jg     8010f4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f4:	83 ec 0c             	sub    $0xc,%esp
  8010f7:	50                   	push   %eax
  8010f8:	6a 09                	push   $0x9
  8010fa:	68 a0 2c 80 00       	push   $0x802ca0
  8010ff:	6a 43                	push   $0x43
  801101:	68 bd 2c 80 00       	push   $0x802cbd
  801106:	e8 6e f2 ff ff       	call   800379 <_panic>

0080110b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801124:	89 df                	mov    %ebx,%edi
  801126:	89 de                	mov    %ebx,%esi
  801128:	cd 30                	int    $0x30
	if(check && ret > 0)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	7f 08                	jg     801136 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80112e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	50                   	push   %eax
  80113a:	6a 0a                	push   $0xa
  80113c:	68 a0 2c 80 00       	push   $0x802ca0
  801141:	6a 43                	push   $0x43
  801143:	68 bd 2c 80 00       	push   $0x802cbd
  801148:	e8 2c f2 ff ff       	call   800379 <_panic>

0080114d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	57                   	push   %edi
  801151:	56                   	push   %esi
  801152:	53                   	push   %ebx
	asm volatile("int %1\n"
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	b8 0c 00 00 00       	mov    $0xc,%eax
  80115e:	be 00 00 00 00       	mov    $0x0,%esi
  801163:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801166:	8b 7d 14             	mov    0x14(%ebp),%edi
  801169:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
  801176:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801179:	b9 00 00 00 00       	mov    $0x0,%ecx
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	b8 0d 00 00 00       	mov    $0xd,%eax
  801186:	89 cb                	mov    %ecx,%ebx
  801188:	89 cf                	mov    %ecx,%edi
  80118a:	89 ce                	mov    %ecx,%esi
  80118c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	7f 08                	jg     80119a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	50                   	push   %eax
  80119e:	6a 0d                	push   $0xd
  8011a0:	68 a0 2c 80 00       	push   $0x802ca0
  8011a5:	6a 43                	push   $0x43
  8011a7:	68 bd 2c 80 00       	push   $0x802cbd
  8011ac:	e8 c8 f1 ff ff       	call   800379 <_panic>

008011b1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011c7:	89 df                	mov    %ebx,%edi
  8011c9:	89 de                	mov    %ebx,%esi
  8011cb:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011cd:	5b                   	pop    %ebx
  8011ce:	5e                   	pop    %esi
  8011cf:	5f                   	pop    %edi
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    

008011d2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	57                   	push   %edi
  8011d6:	56                   	push   %esi
  8011d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011e5:	89 cb                	mov    %ecx,%ebx
  8011e7:	89 cf                	mov    %ecx,%edi
  8011e9:	89 ce                	mov    %ecx,%esi
  8011eb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011ed:	5b                   	pop    %ebx
  8011ee:	5e                   	pop    %esi
  8011ef:	5f                   	pop    %edi
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	53                   	push   %ebx
  8011f6:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011f9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801200:	83 e1 07             	and    $0x7,%ecx
  801203:	83 f9 07             	cmp    $0x7,%ecx
  801206:	74 32                	je     80123a <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801208:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80120f:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801215:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80121b:	74 7d                	je     80129a <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80121d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801224:	83 e1 05             	and    $0x5,%ecx
  801227:	83 f9 05             	cmp    $0x5,%ecx
  80122a:	0f 84 9e 00 00 00    	je     8012ce <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801230:	b8 00 00 00 00       	mov    $0x0,%eax
  801235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801238:	c9                   	leave  
  801239:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80123a:	89 d3                	mov    %edx,%ebx
  80123c:	c1 e3 0c             	shl    $0xc,%ebx
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	68 05 08 00 00       	push   $0x805
  801247:	53                   	push   %ebx
  801248:	50                   	push   %eax
  801249:	53                   	push   %ebx
  80124a:	6a 00                	push   $0x0
  80124c:	e8 b2 fd ff ff       	call   801003 <sys_page_map>
		if(r < 0)
  801251:	83 c4 20             	add    $0x20,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	78 2e                	js     801286 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801258:	83 ec 0c             	sub    $0xc,%esp
  80125b:	68 05 08 00 00       	push   $0x805
  801260:	53                   	push   %ebx
  801261:	6a 00                	push   $0x0
  801263:	53                   	push   %ebx
  801264:	6a 00                	push   $0x0
  801266:	e8 98 fd ff ff       	call   801003 <sys_page_map>
		if(r < 0)
  80126b:	83 c4 20             	add    $0x20,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	79 be                	jns    801230 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801272:	83 ec 04             	sub    $0x4,%esp
  801275:	68 cb 2c 80 00       	push   $0x802ccb
  80127a:	6a 57                	push   $0x57
  80127c:	68 e1 2c 80 00       	push   $0x802ce1
  801281:	e8 f3 f0 ff ff       	call   800379 <_panic>
			panic("sys_page_map() panic\n");
  801286:	83 ec 04             	sub    $0x4,%esp
  801289:	68 cb 2c 80 00       	push   $0x802ccb
  80128e:	6a 53                	push   $0x53
  801290:	68 e1 2c 80 00       	push   $0x802ce1
  801295:	e8 df f0 ff ff       	call   800379 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80129a:	c1 e2 0c             	shl    $0xc,%edx
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	68 05 08 00 00       	push   $0x805
  8012a5:	52                   	push   %edx
  8012a6:	50                   	push   %eax
  8012a7:	52                   	push   %edx
  8012a8:	6a 00                	push   $0x0
  8012aa:	e8 54 fd ff ff       	call   801003 <sys_page_map>
		if(r < 0)
  8012af:	83 c4 20             	add    $0x20,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	0f 89 76 ff ff ff    	jns    801230 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	68 cb 2c 80 00       	push   $0x802ccb
  8012c2:	6a 5e                	push   $0x5e
  8012c4:	68 e1 2c 80 00       	push   $0x802ce1
  8012c9:	e8 ab f0 ff ff       	call   800379 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ce:	c1 e2 0c             	shl    $0xc,%edx
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	6a 05                	push   $0x5
  8012d6:	52                   	push   %edx
  8012d7:	50                   	push   %eax
  8012d8:	52                   	push   %edx
  8012d9:	6a 00                	push   $0x0
  8012db:	e8 23 fd ff ff       	call   801003 <sys_page_map>
		if(r < 0)
  8012e0:	83 c4 20             	add    $0x20,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	0f 89 45 ff ff ff    	jns    801230 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	68 cb 2c 80 00       	push   $0x802ccb
  8012f3:	6a 65                	push   $0x65
  8012f5:	68 e1 2c 80 00       	push   $0x802ce1
  8012fa:	e8 7a f0 ff ff       	call   800379 <_panic>

008012ff <pgfault>:
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	53                   	push   %ebx
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801309:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80130b:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80130f:	0f 84 99 00 00 00    	je     8013ae <pgfault+0xaf>
  801315:	89 c2                	mov    %eax,%edx
  801317:	c1 ea 16             	shr    $0x16,%edx
  80131a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801321:	f6 c2 01             	test   $0x1,%dl
  801324:	0f 84 84 00 00 00    	je     8013ae <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	c1 ea 0c             	shr    $0xc,%edx
  80132f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801336:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80133c:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801342:	75 6a                	jne    8013ae <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	6a 07                	push   $0x7
  801350:	68 00 f0 7f 00       	push   $0x7ff000
  801355:	6a 00                	push   $0x0
  801357:	e8 64 fc ff ff       	call   800fc0 <sys_page_alloc>
	if(ret < 0)
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	78 5f                	js     8013c2 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	68 00 10 00 00       	push   $0x1000
  80136b:	53                   	push   %ebx
  80136c:	68 00 f0 7f 00       	push   $0x7ff000
  801371:	e8 48 fa ff ff       	call   800dbe <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801376:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80137d:	53                   	push   %ebx
  80137e:	6a 00                	push   $0x0
  801380:	68 00 f0 7f 00       	push   $0x7ff000
  801385:	6a 00                	push   $0x0
  801387:	e8 77 fc ff ff       	call   801003 <sys_page_map>
	if(ret < 0)
  80138c:	83 c4 20             	add    $0x20,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	78 43                	js     8013d6 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801393:	83 ec 08             	sub    $0x8,%esp
  801396:	68 00 f0 7f 00       	push   $0x7ff000
  80139b:	6a 00                	push   $0x0
  80139d:	e8 a3 fc ff ff       	call   801045 <sys_page_unmap>
	if(ret < 0)
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 41                	js     8013ea <pgfault+0xeb>
}
  8013a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013ae:	83 ec 04             	sub    $0x4,%esp
  8013b1:	68 ec 2c 80 00       	push   $0x802cec
  8013b6:	6a 26                	push   $0x26
  8013b8:	68 e1 2c 80 00       	push   $0x802ce1
  8013bd:	e8 b7 ef ff ff       	call   800379 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	68 00 2d 80 00       	push   $0x802d00
  8013ca:	6a 31                	push   $0x31
  8013cc:	68 e1 2c 80 00       	push   $0x802ce1
  8013d1:	e8 a3 ef ff ff       	call   800379 <_panic>
		panic("panic in sys_page_map()\n");
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	68 1b 2d 80 00       	push   $0x802d1b
  8013de:	6a 36                	push   $0x36
  8013e0:	68 e1 2c 80 00       	push   $0x802ce1
  8013e5:	e8 8f ef ff ff       	call   800379 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	68 34 2d 80 00       	push   $0x802d34
  8013f2:	6a 39                	push   $0x39
  8013f4:	68 e1 2c 80 00       	push   $0x802ce1
  8013f9:	e8 7b ef ff ff       	call   800379 <_panic>

008013fe <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801407:	68 ff 12 80 00       	push   $0x8012ff
  80140c:	e8 6b 0f 00 00       	call   80237c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801411:	b8 07 00 00 00       	mov    $0x7,%eax
  801416:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 27                	js     801446 <fork+0x48>
  80141f:	89 c6                	mov    %eax,%esi
  801421:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801423:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801428:	75 48                	jne    801472 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80142a:	e8 53 fb ff ff       	call   800f82 <sys_getenvid>
  80142f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801434:	c1 e0 07             	shl    $0x7,%eax
  801437:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80143c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801441:	e9 90 00 00 00       	jmp    8014d6 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	68 50 2d 80 00       	push   $0x802d50
  80144e:	68 85 00 00 00       	push   $0x85
  801453:	68 e1 2c 80 00       	push   $0x802ce1
  801458:	e8 1c ef ff ff       	call   800379 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80145d:	89 f8                	mov    %edi,%eax
  80145f:	e8 8e fd ff ff       	call   8011f2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801464:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80146a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801470:	74 26                	je     801498 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801472:	89 d8                	mov    %ebx,%eax
  801474:	c1 e8 16             	shr    $0x16,%eax
  801477:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80147e:	a8 01                	test   $0x1,%al
  801480:	74 e2                	je     801464 <fork+0x66>
  801482:	89 da                	mov    %ebx,%edx
  801484:	c1 ea 0c             	shr    $0xc,%edx
  801487:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80148e:	83 e0 05             	and    $0x5,%eax
  801491:	83 f8 05             	cmp    $0x5,%eax
  801494:	75 ce                	jne    801464 <fork+0x66>
  801496:	eb c5                	jmp    80145d <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801498:	83 ec 04             	sub    $0x4,%esp
  80149b:	6a 07                	push   $0x7
  80149d:	68 00 f0 bf ee       	push   $0xeebff000
  8014a2:	56                   	push   %esi
  8014a3:	e8 18 fb ff ff       	call   800fc0 <sys_page_alloc>
	if(ret < 0)
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 31                	js     8014e0 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	68 eb 23 80 00       	push   $0x8023eb
  8014b7:	56                   	push   %esi
  8014b8:	e8 4e fc ff ff       	call   80110b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 33                	js     8014f7 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	6a 02                	push   $0x2
  8014c9:	56                   	push   %esi
  8014ca:	e8 b8 fb ff ff       	call   801087 <sys_env_set_status>
	if(ret < 0)
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 38                	js     80150e <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014d6:	89 f0                	mov    %esi,%eax
  8014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5f                   	pop    %edi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 00 2d 80 00       	push   $0x802d00
  8014e8:	68 91 00 00 00       	push   $0x91
  8014ed:	68 e1 2c 80 00       	push   $0x802ce1
  8014f2:	e8 82 ee ff ff       	call   800379 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	68 74 2d 80 00       	push   $0x802d74
  8014ff:	68 94 00 00 00       	push   $0x94
  801504:	68 e1 2c 80 00       	push   $0x802ce1
  801509:	e8 6b ee ff ff       	call   800379 <_panic>
		panic("panic in sys_env_set_status()\n");
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	68 9c 2d 80 00       	push   $0x802d9c
  801516:	68 97 00 00 00       	push   $0x97
  80151b:	68 e1 2c 80 00       	push   $0x802ce1
  801520:	e8 54 ee ff ff       	call   800379 <_panic>

00801525 <sfork>:

// Challenge!
int
sfork(void)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	57                   	push   %edi
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
  80152b:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80152e:	a1 04 40 80 00       	mov    0x804004,%eax
  801533:	8b 40 48             	mov    0x48(%eax),%eax
  801536:	68 bc 2d 80 00       	push   $0x802dbc
  80153b:	50                   	push   %eax
  80153c:	68 f6 28 80 00       	push   $0x8028f6
  801541:	e8 29 ef ff ff       	call   80046f <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801546:	c7 04 24 ff 12 80 00 	movl   $0x8012ff,(%esp)
  80154d:	e8 2a 0e 00 00       	call   80237c <set_pgfault_handler>
  801552:	b8 07 00 00 00       	mov    $0x7,%eax
  801557:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 27                	js     801587 <sfork+0x62>
  801560:	89 c7                	mov    %eax,%edi
  801562:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801564:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801569:	75 55                	jne    8015c0 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80156b:	e8 12 fa ff ff       	call   800f82 <sys_getenvid>
  801570:	25 ff 03 00 00       	and    $0x3ff,%eax
  801575:	c1 e0 07             	shl    $0x7,%eax
  801578:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80157d:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801582:	e9 d4 00 00 00       	jmp    80165b <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	68 50 2d 80 00       	push   $0x802d50
  80158f:	68 a9 00 00 00       	push   $0xa9
  801594:	68 e1 2c 80 00       	push   $0x802ce1
  801599:	e8 db ed ff ff       	call   800379 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80159e:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015a3:	89 f0                	mov    %esi,%eax
  8015a5:	e8 48 fc ff ff       	call   8011f2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015b0:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015b6:	77 65                	ja     80161d <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8015b8:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015be:	74 de                	je     80159e <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015c0:	89 d8                	mov    %ebx,%eax
  8015c2:	c1 e8 16             	shr    $0x16,%eax
  8015c5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015cc:	a8 01                	test   $0x1,%al
  8015ce:	74 da                	je     8015aa <sfork+0x85>
  8015d0:	89 da                	mov    %ebx,%edx
  8015d2:	c1 ea 0c             	shr    $0xc,%edx
  8015d5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015dc:	83 e0 05             	and    $0x5,%eax
  8015df:	83 f8 05             	cmp    $0x5,%eax
  8015e2:	75 c6                	jne    8015aa <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015e4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015eb:	c1 e2 0c             	shl    $0xc,%edx
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	83 e0 07             	and    $0x7,%eax
  8015f4:	50                   	push   %eax
  8015f5:	52                   	push   %edx
  8015f6:	56                   	push   %esi
  8015f7:	52                   	push   %edx
  8015f8:	6a 00                	push   $0x0
  8015fa:	e8 04 fa ff ff       	call   801003 <sys_page_map>
  8015ff:	83 c4 20             	add    $0x20,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	74 a4                	je     8015aa <sfork+0x85>
				panic("sys_page_map() panic\n");
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	68 cb 2c 80 00       	push   $0x802ccb
  80160e:	68 b4 00 00 00       	push   $0xb4
  801613:	68 e1 2c 80 00       	push   $0x802ce1
  801618:	e8 5c ed ff ff       	call   800379 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	6a 07                	push   $0x7
  801622:	68 00 f0 bf ee       	push   $0xeebff000
  801627:	57                   	push   %edi
  801628:	e8 93 f9 ff ff       	call   800fc0 <sys_page_alloc>
	if(ret < 0)
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 31                	js     801665 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	68 eb 23 80 00       	push   $0x8023eb
  80163c:	57                   	push   %edi
  80163d:	e8 c9 fa ff ff       	call   80110b <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 33                	js     80167c <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	6a 02                	push   $0x2
  80164e:	57                   	push   %edi
  80164f:	e8 33 fa ff ff       	call   801087 <sys_env_set_status>
	if(ret < 0)
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 38                	js     801693 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80165b:	89 f8                	mov    %edi,%eax
  80165d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801660:	5b                   	pop    %ebx
  801661:	5e                   	pop    %esi
  801662:	5f                   	pop    %edi
  801663:	5d                   	pop    %ebp
  801664:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 00 2d 80 00       	push   $0x802d00
  80166d:	68 ba 00 00 00       	push   $0xba
  801672:	68 e1 2c 80 00       	push   $0x802ce1
  801677:	e8 fd ec ff ff       	call   800379 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	68 74 2d 80 00       	push   $0x802d74
  801684:	68 bd 00 00 00       	push   $0xbd
  801689:	68 e1 2c 80 00       	push   $0x802ce1
  80168e:	e8 e6 ec ff ff       	call   800379 <_panic>
		panic("panic in sys_env_set_status()\n");
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	68 9c 2d 80 00       	push   $0x802d9c
  80169b:	68 c0 00 00 00       	push   $0xc0
  8016a0:	68 e1 2c 80 00       	push   $0x802ce1
  8016a5:	e8 cf ec ff ff       	call   800379 <_panic>

008016aa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	05 00 00 00 30       	add    $0x30000000,%eax
  8016b5:	c1 e8 0c             	shr    $0xc,%eax
}
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ca:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	c1 ea 16             	shr    $0x16,%edx
  8016de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016e5:	f6 c2 01             	test   $0x1,%dl
  8016e8:	74 2d                	je     801717 <fd_alloc+0x46>
  8016ea:	89 c2                	mov    %eax,%edx
  8016ec:	c1 ea 0c             	shr    $0xc,%edx
  8016ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f6:	f6 c2 01             	test   $0x1,%dl
  8016f9:	74 1c                	je     801717 <fd_alloc+0x46>
  8016fb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801700:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801705:	75 d2                	jne    8016d9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801710:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801715:	eb 0a                	jmp    801721 <fd_alloc+0x50>
			*fd_store = fd;
  801717:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    

00801723 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801729:	83 f8 1f             	cmp    $0x1f,%eax
  80172c:	77 30                	ja     80175e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80172e:	c1 e0 0c             	shl    $0xc,%eax
  801731:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801736:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80173c:	f6 c2 01             	test   $0x1,%dl
  80173f:	74 24                	je     801765 <fd_lookup+0x42>
  801741:	89 c2                	mov    %eax,%edx
  801743:	c1 ea 0c             	shr    $0xc,%edx
  801746:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174d:	f6 c2 01             	test   $0x1,%dl
  801750:	74 1a                	je     80176c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	89 02                	mov    %eax,(%edx)
	return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175c:	5d                   	pop    %ebp
  80175d:	c3                   	ret    
		return -E_INVAL;
  80175e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801763:	eb f7                	jmp    80175c <fd_lookup+0x39>
		return -E_INVAL;
  801765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176a:	eb f0                	jmp    80175c <fd_lookup+0x39>
  80176c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801771:	eb e9                	jmp    80175c <fd_lookup+0x39>

00801773 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80177c:	ba 40 2e 80 00       	mov    $0x802e40,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801781:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801786:	39 08                	cmp    %ecx,(%eax)
  801788:	74 33                	je     8017bd <dev_lookup+0x4a>
  80178a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80178d:	8b 02                	mov    (%edx),%eax
  80178f:	85 c0                	test   %eax,%eax
  801791:	75 f3                	jne    801786 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801793:	a1 04 40 80 00       	mov    0x804004,%eax
  801798:	8b 40 48             	mov    0x48(%eax),%eax
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	51                   	push   %ecx
  80179f:	50                   	push   %eax
  8017a0:	68 c4 2d 80 00       	push   $0x802dc4
  8017a5:	e8 c5 ec ff ff       	call   80046f <cprintf>
	*dev = 0;
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    
			*dev = devtab[i];
  8017bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	eb f2                	jmp    8017bb <dev_lookup+0x48>

008017c9 <fd_close>:
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	57                   	push   %edi
  8017cd:	56                   	push   %esi
  8017ce:	53                   	push   %ebx
  8017cf:	83 ec 24             	sub    $0x24,%esp
  8017d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8017d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e5:	50                   	push   %eax
  8017e6:	e8 38 ff ff ff       	call   801723 <fd_lookup>
  8017eb:	89 c3                	mov    %eax,%ebx
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 05                	js     8017f9 <fd_close+0x30>
	    || fd != fd2)
  8017f4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017f7:	74 16                	je     80180f <fd_close+0x46>
		return (must_exist ? r : 0);
  8017f9:	89 f8                	mov    %edi,%eax
  8017fb:	84 c0                	test   %al,%al
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801802:	0f 44 d8             	cmove  %eax,%ebx
}
  801805:	89 d8                	mov    %ebx,%eax
  801807:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801815:	50                   	push   %eax
  801816:	ff 36                	pushl  (%esi)
  801818:	e8 56 ff ff ff       	call   801773 <dev_lookup>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 1a                	js     801840 <fd_close+0x77>
		if (dev->dev_close)
  801826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801829:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80182c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801831:	85 c0                	test   %eax,%eax
  801833:	74 0b                	je     801840 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	56                   	push   %esi
  801839:	ff d0                	call   *%eax
  80183b:	89 c3                	mov    %eax,%ebx
  80183d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801840:	83 ec 08             	sub    $0x8,%esp
  801843:	56                   	push   %esi
  801844:	6a 00                	push   $0x0
  801846:	e8 fa f7 ff ff       	call   801045 <sys_page_unmap>
	return r;
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	eb b5                	jmp    801805 <fd_close+0x3c>

00801850 <close>:

int
close(int fdnum)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	e8 c1 fe ff ff       	call   801723 <fd_lookup>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	85 c0                	test   %eax,%eax
  801867:	79 02                	jns    80186b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    
		return fd_close(fd, 1);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	6a 01                	push   $0x1
  801870:	ff 75 f4             	pushl  -0xc(%ebp)
  801873:	e8 51 ff ff ff       	call   8017c9 <fd_close>
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	eb ec                	jmp    801869 <close+0x19>

0080187d <close_all>:

void
close_all(void)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	53                   	push   %ebx
  801881:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801884:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	53                   	push   %ebx
  80188d:	e8 be ff ff ff       	call   801850 <close>
	for (i = 0; i < MAXFD; i++)
  801892:	83 c3 01             	add    $0x1,%ebx
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	83 fb 20             	cmp    $0x20,%ebx
  80189b:	75 ec                	jne    801889 <close_all+0xc>
}
  80189d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ae:	50                   	push   %eax
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	e8 6c fe ff ff       	call   801723 <fd_lookup>
  8018b7:	89 c3                	mov    %eax,%ebx
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	0f 88 81 00 00 00    	js     801945 <dup+0xa3>
		return r;
	close(newfdnum);
  8018c4:	83 ec 0c             	sub    $0xc,%esp
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	e8 81 ff ff ff       	call   801850 <close>

	newfd = INDEX2FD(newfdnum);
  8018cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018d2:	c1 e6 0c             	shl    $0xc,%esi
  8018d5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018db:	83 c4 04             	add    $0x4,%esp
  8018de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018e1:	e8 d4 fd ff ff       	call   8016ba <fd2data>
  8018e6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018e8:	89 34 24             	mov    %esi,(%esp)
  8018eb:	e8 ca fd ff ff       	call   8016ba <fd2data>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018f5:	89 d8                	mov    %ebx,%eax
  8018f7:	c1 e8 16             	shr    $0x16,%eax
  8018fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801901:	a8 01                	test   $0x1,%al
  801903:	74 11                	je     801916 <dup+0x74>
  801905:	89 d8                	mov    %ebx,%eax
  801907:	c1 e8 0c             	shr    $0xc,%eax
  80190a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801911:	f6 c2 01             	test   $0x1,%dl
  801914:	75 39                	jne    80194f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801919:	89 d0                	mov    %edx,%eax
  80191b:	c1 e8 0c             	shr    $0xc,%eax
  80191e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	25 07 0e 00 00       	and    $0xe07,%eax
  80192d:	50                   	push   %eax
  80192e:	56                   	push   %esi
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	6a 00                	push   $0x0
  801934:	e8 ca f6 ff ff       	call   801003 <sys_page_map>
  801939:	89 c3                	mov    %eax,%ebx
  80193b:	83 c4 20             	add    $0x20,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 31                	js     801973 <dup+0xd1>
		goto err;

	return newfdnum;
  801942:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801945:	89 d8                	mov    %ebx,%eax
  801947:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194a:	5b                   	pop    %ebx
  80194b:	5e                   	pop    %esi
  80194c:	5f                   	pop    %edi
  80194d:	5d                   	pop    %ebp
  80194e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80194f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801956:	83 ec 0c             	sub    $0xc,%esp
  801959:	25 07 0e 00 00       	and    $0xe07,%eax
  80195e:	50                   	push   %eax
  80195f:	57                   	push   %edi
  801960:	6a 00                	push   $0x0
  801962:	53                   	push   %ebx
  801963:	6a 00                	push   $0x0
  801965:	e8 99 f6 ff ff       	call   801003 <sys_page_map>
  80196a:	89 c3                	mov    %eax,%ebx
  80196c:	83 c4 20             	add    $0x20,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	79 a3                	jns    801916 <dup+0x74>
	sys_page_unmap(0, newfd);
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	56                   	push   %esi
  801977:	6a 00                	push   $0x0
  801979:	e8 c7 f6 ff ff       	call   801045 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80197e:	83 c4 08             	add    $0x8,%esp
  801981:	57                   	push   %edi
  801982:	6a 00                	push   $0x0
  801984:	e8 bc f6 ff ff       	call   801045 <sys_page_unmap>
	return r;
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	eb b7                	jmp    801945 <dup+0xa3>

0080198e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	53                   	push   %ebx
  801992:	83 ec 1c             	sub    $0x1c,%esp
  801995:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801998:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80199b:	50                   	push   %eax
  80199c:	53                   	push   %ebx
  80199d:	e8 81 fd ff ff       	call   801723 <fd_lookup>
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	78 3f                	js     8019e8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019af:	50                   	push   %eax
  8019b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b3:	ff 30                	pushl  (%eax)
  8019b5:	e8 b9 fd ff ff       	call   801773 <dev_lookup>
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 27                	js     8019e8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019c4:	8b 42 08             	mov    0x8(%edx),%eax
  8019c7:	83 e0 03             	and    $0x3,%eax
  8019ca:	83 f8 01             	cmp    $0x1,%eax
  8019cd:	74 1e                	je     8019ed <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d2:	8b 40 08             	mov    0x8(%eax),%eax
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	74 35                	je     801a0e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	ff 75 10             	pushl  0x10(%ebp)
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	52                   	push   %edx
  8019e3:	ff d0                	call   *%eax
  8019e5:	83 c4 10             	add    $0x10,%esp
}
  8019e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f2:	8b 40 48             	mov    0x48(%eax),%eax
  8019f5:	83 ec 04             	sub    $0x4,%esp
  8019f8:	53                   	push   %ebx
  8019f9:	50                   	push   %eax
  8019fa:	68 05 2e 80 00       	push   $0x802e05
  8019ff:	e8 6b ea ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0c:	eb da                	jmp    8019e8 <read+0x5a>
		return -E_NOT_SUPP;
  801a0e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a13:	eb d3                	jmp    8019e8 <read+0x5a>

00801a15 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	57                   	push   %edi
  801a19:	56                   	push   %esi
  801a1a:	53                   	push   %ebx
  801a1b:	83 ec 0c             	sub    $0xc,%esp
  801a1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a21:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a24:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a29:	39 f3                	cmp    %esi,%ebx
  801a2b:	73 23                	jae    801a50 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	89 f0                	mov    %esi,%eax
  801a32:	29 d8                	sub    %ebx,%eax
  801a34:	50                   	push   %eax
  801a35:	89 d8                	mov    %ebx,%eax
  801a37:	03 45 0c             	add    0xc(%ebp),%eax
  801a3a:	50                   	push   %eax
  801a3b:	57                   	push   %edi
  801a3c:	e8 4d ff ff ff       	call   80198e <read>
		if (m < 0)
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 06                	js     801a4e <readn+0x39>
			return m;
		if (m == 0)
  801a48:	74 06                	je     801a50 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a4a:	01 c3                	add    %eax,%ebx
  801a4c:	eb db                	jmp    801a29 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a4e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5f                   	pop    %edi
  801a58:	5d                   	pop    %ebp
  801a59:	c3                   	ret    

00801a5a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 1c             	sub    $0x1c,%esp
  801a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a67:	50                   	push   %eax
  801a68:	53                   	push   %ebx
  801a69:	e8 b5 fc ff ff       	call   801723 <fd_lookup>
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 3a                	js     801aaf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a75:	83 ec 08             	sub    $0x8,%esp
  801a78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7b:	50                   	push   %eax
  801a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7f:	ff 30                	pushl  (%eax)
  801a81:	e8 ed fc ff ff       	call   801773 <dev_lookup>
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	85 c0                	test   %eax,%eax
  801a8b:	78 22                	js     801aaf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a90:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a94:	74 1e                	je     801ab4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a99:	8b 52 0c             	mov    0xc(%edx),%edx
  801a9c:	85 d2                	test   %edx,%edx
  801a9e:	74 35                	je     801ad5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	ff 75 10             	pushl  0x10(%ebp)
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff d2                	call   *%edx
  801aac:	83 c4 10             	add    $0x10,%esp
}
  801aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab4:	a1 04 40 80 00       	mov    0x804004,%eax
  801ab9:	8b 40 48             	mov    0x48(%eax),%eax
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	53                   	push   %ebx
  801ac0:	50                   	push   %eax
  801ac1:	68 21 2e 80 00       	push   $0x802e21
  801ac6:	e8 a4 e9 ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad3:	eb da                	jmp    801aaf <write+0x55>
		return -E_NOT_SUPP;
  801ad5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ada:	eb d3                	jmp    801aaf <write+0x55>

00801adc <seek>:

int
seek(int fdnum, off_t offset)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ae2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae5:	50                   	push   %eax
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	e8 35 fc ff ff       	call   801723 <fd_lookup>
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 0e                	js     801b03 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	53                   	push   %ebx
  801b09:	83 ec 1c             	sub    $0x1c,%esp
  801b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b12:	50                   	push   %eax
  801b13:	53                   	push   %ebx
  801b14:	e8 0a fc ff ff       	call   801723 <fd_lookup>
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 37                	js     801b57 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b20:	83 ec 08             	sub    $0x8,%esp
  801b23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b26:	50                   	push   %eax
  801b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2a:	ff 30                	pushl  (%eax)
  801b2c:	e8 42 fc ff ff       	call   801773 <dev_lookup>
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	85 c0                	test   %eax,%eax
  801b36:	78 1f                	js     801b57 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b3f:	74 1b                	je     801b5c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 52 18             	mov    0x18(%edx),%edx
  801b47:	85 d2                	test   %edx,%edx
  801b49:	74 32                	je     801b7d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b4b:	83 ec 08             	sub    $0x8,%esp
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	50                   	push   %eax
  801b52:	ff d2                	call   *%edx
  801b54:	83 c4 10             	add    $0x10,%esp
}
  801b57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b5c:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b61:	8b 40 48             	mov    0x48(%eax),%eax
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	53                   	push   %ebx
  801b68:	50                   	push   %eax
  801b69:	68 e4 2d 80 00       	push   $0x802de4
  801b6e:	e8 fc e8 ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b7b:	eb da                	jmp    801b57 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b7d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b82:	eb d3                	jmp    801b57 <ftruncate+0x52>

00801b84 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	83 ec 1c             	sub    $0x1c,%esp
  801b8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b91:	50                   	push   %eax
  801b92:	ff 75 08             	pushl  0x8(%ebp)
  801b95:	e8 89 fb ff ff       	call   801723 <fd_lookup>
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	85 c0                	test   %eax,%eax
  801b9f:	78 4b                	js     801bec <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba1:	83 ec 08             	sub    $0x8,%esp
  801ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba7:	50                   	push   %eax
  801ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bab:	ff 30                	pushl  (%eax)
  801bad:	e8 c1 fb ff ff       	call   801773 <dev_lookup>
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 33                	js     801bec <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bc0:	74 2f                	je     801bf1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bc2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bc5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bcc:	00 00 00 
	stat->st_isdir = 0;
  801bcf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd6:	00 00 00 
	stat->st_dev = dev;
  801bd9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	53                   	push   %ebx
  801be3:	ff 75 f0             	pushl  -0x10(%ebp)
  801be6:	ff 50 14             	call   *0x14(%eax)
  801be9:	83 c4 10             	add    $0x10,%esp
}
  801bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    
		return -E_NOT_SUPP;
  801bf1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bf6:	eb f4                	jmp    801bec <fstat+0x68>

00801bf8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	56                   	push   %esi
  801bfc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	6a 00                	push   $0x0
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 bb 01 00 00       	call   801dc5 <open>
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 1b                	js     801c2e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	e8 65 ff ff ff       	call   801b84 <fstat>
  801c1f:	89 c6                	mov    %eax,%esi
	close(fd);
  801c21:	89 1c 24             	mov    %ebx,(%esp)
  801c24:	e8 27 fc ff ff       	call   801850 <close>
	return r;
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	89 f3                	mov    %esi,%ebx
}
  801c2e:	89 d8                	mov    %ebx,%eax
  801c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    

00801c37 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	89 c6                	mov    %eax,%esi
  801c3e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c40:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801c47:	74 27                	je     801c70 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c49:	6a 07                	push   $0x7
  801c4b:	68 00 50 80 00       	push   $0x805000
  801c50:	56                   	push   %esi
  801c51:	ff 35 00 40 80 00    	pushl  0x804000
  801c57:	e8 1e 08 00 00       	call   80247a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c5c:	83 c4 0c             	add    $0xc,%esp
  801c5f:	6a 00                	push   $0x0
  801c61:	53                   	push   %ebx
  801c62:	6a 00                	push   $0x0
  801c64:	e8 a8 07 00 00       	call   802411 <ipc_recv>
}
  801c69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	6a 01                	push   $0x1
  801c75:	e8 58 08 00 00       	call   8024d2 <ipc_find_env>
  801c7a:	a3 00 40 80 00       	mov    %eax,0x804000
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	eb c5                	jmp    801c49 <fsipc+0x12>

00801c84 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c90:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca2:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca7:	e8 8b ff ff ff       	call   801c37 <fsipc>
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <devfile_flush>:
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cba:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc4:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc9:	e8 69 ff ff ff       	call   801c37 <fsipc>
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <devfile_stat>:
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cea:	b8 05 00 00 00       	mov    $0x5,%eax
  801cef:	e8 43 ff ff ff       	call   801c37 <fsipc>
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 2c                	js     801d24 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	68 00 50 80 00       	push   $0x805000
  801d00:	53                   	push   %ebx
  801d01:	e8 c8 ee ff ff       	call   800bce <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d06:	a1 80 50 80 00       	mov    0x805080,%eax
  801d0b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d11:	a1 84 50 80 00       	mov    0x805084,%eax
  801d16:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <devfile_write>:
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801d2f:	68 50 2e 80 00       	push   $0x802e50
  801d34:	68 90 00 00 00       	push   $0x90
  801d39:	68 6e 2e 80 00       	push   $0x802e6e
  801d3e:	e8 36 e6 ff ff       	call   800379 <_panic>

00801d43 <devfile_read>:
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d51:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801d56:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d61:	b8 03 00 00 00       	mov    $0x3,%eax
  801d66:	e8 cc fe ff ff       	call   801c37 <fsipc>
  801d6b:	89 c3                	mov    %eax,%ebx
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 1f                	js     801d90 <devfile_read+0x4d>
	assert(r <= n);
  801d71:	39 f0                	cmp    %esi,%eax
  801d73:	77 24                	ja     801d99 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d75:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d7a:	7f 33                	jg     801daf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	50                   	push   %eax
  801d80:	68 00 50 80 00       	push   $0x805000
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	e8 cf ef ff ff       	call   800d5c <memmove>
	return r;
  801d8d:	83 c4 10             	add    $0x10,%esp
}
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    
	assert(r <= n);
  801d99:	68 79 2e 80 00       	push   $0x802e79
  801d9e:	68 80 2e 80 00       	push   $0x802e80
  801da3:	6a 7c                	push   $0x7c
  801da5:	68 6e 2e 80 00       	push   $0x802e6e
  801daa:	e8 ca e5 ff ff       	call   800379 <_panic>
	assert(r <= PGSIZE);
  801daf:	68 95 2e 80 00       	push   $0x802e95
  801db4:	68 80 2e 80 00       	push   $0x802e80
  801db9:	6a 7d                	push   $0x7d
  801dbb:	68 6e 2e 80 00       	push   $0x802e6e
  801dc0:	e8 b4 e5 ff ff       	call   800379 <_panic>

00801dc5 <open>:
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	56                   	push   %esi
  801dc9:	53                   	push   %ebx
  801dca:	83 ec 1c             	sub    $0x1c,%esp
  801dcd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dd0:	56                   	push   %esi
  801dd1:	e8 bf ed ff ff       	call   800b95 <strlen>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dde:	7f 6c                	jg     801e4c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de6:	50                   	push   %eax
  801de7:	e8 e5 f8 ff ff       	call   8016d1 <fd_alloc>
  801dec:	89 c3                	mov    %eax,%ebx
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	85 c0                	test   %eax,%eax
  801df3:	78 3c                	js     801e31 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	56                   	push   %esi
  801df9:	68 00 50 80 00       	push   $0x805000
  801dfe:	e8 cb ed ff ff       	call   800bce <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e06:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e13:	e8 1f fe ff ff       	call   801c37 <fsipc>
  801e18:	89 c3                	mov    %eax,%ebx
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 19                	js     801e3a <open+0x75>
	return fd2num(fd);
  801e21:	83 ec 0c             	sub    $0xc,%esp
  801e24:	ff 75 f4             	pushl  -0xc(%ebp)
  801e27:	e8 7e f8 ff ff       	call   8016aa <fd2num>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	83 c4 10             	add    $0x10,%esp
}
  801e31:	89 d8                	mov    %ebx,%eax
  801e33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e36:	5b                   	pop    %ebx
  801e37:	5e                   	pop    %esi
  801e38:	5d                   	pop    %ebp
  801e39:	c3                   	ret    
		fd_close(fd, 0);
  801e3a:	83 ec 08             	sub    $0x8,%esp
  801e3d:	6a 00                	push   $0x0
  801e3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e42:	e8 82 f9 ff ff       	call   8017c9 <fd_close>
		return r;
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	eb e5                	jmp    801e31 <open+0x6c>
		return -E_BAD_PATH;
  801e4c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e51:	eb de                	jmp    801e31 <open+0x6c>

00801e53 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e59:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e63:	e8 cf fd ff ff       	call   801c37 <fsipc>
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	56                   	push   %esi
  801e6e:	53                   	push   %ebx
  801e6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	ff 75 08             	pushl  0x8(%ebp)
  801e78:	e8 3d f8 ff ff       	call   8016ba <fd2data>
  801e7d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e7f:	83 c4 08             	add    $0x8,%esp
  801e82:	68 a1 2e 80 00       	push   $0x802ea1
  801e87:	53                   	push   %ebx
  801e88:	e8 41 ed ff ff       	call   800bce <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e8d:	8b 46 04             	mov    0x4(%esi),%eax
  801e90:	2b 06                	sub    (%esi),%eax
  801e92:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e98:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e9f:	00 00 00 
	stat->st_dev = &devpipe;
  801ea2:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801ea9:	30 80 00 
	return 0;
}
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb4:	5b                   	pop    %ebx
  801eb5:	5e                   	pop    %esi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	53                   	push   %ebx
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ec2:	53                   	push   %ebx
  801ec3:	6a 00                	push   $0x0
  801ec5:	e8 7b f1 ff ff       	call   801045 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eca:	89 1c 24             	mov    %ebx,(%esp)
  801ecd:	e8 e8 f7 ff ff       	call   8016ba <fd2data>
  801ed2:	83 c4 08             	add    $0x8,%esp
  801ed5:	50                   	push   %eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	e8 68 f1 ff ff       	call   801045 <sys_page_unmap>
}
  801edd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <_pipeisclosed>:
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	57                   	push   %edi
  801ee6:	56                   	push   %esi
  801ee7:	53                   	push   %ebx
  801ee8:	83 ec 1c             	sub    $0x1c,%esp
  801eeb:	89 c7                	mov    %eax,%edi
  801eed:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801eef:	a1 04 40 80 00       	mov    0x804004,%eax
  801ef4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	57                   	push   %edi
  801efb:	e8 0d 06 00 00       	call   80250d <pageref>
  801f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f03:	89 34 24             	mov    %esi,(%esp)
  801f06:	e8 02 06 00 00       	call   80250d <pageref>
		nn = thisenv->env_runs;
  801f0b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f11:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	39 cb                	cmp    %ecx,%ebx
  801f19:	74 1b                	je     801f36 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f1b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f1e:	75 cf                	jne    801eef <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f20:	8b 42 58             	mov    0x58(%edx),%eax
  801f23:	6a 01                	push   $0x1
  801f25:	50                   	push   %eax
  801f26:	53                   	push   %ebx
  801f27:	68 a8 2e 80 00       	push   $0x802ea8
  801f2c:	e8 3e e5 ff ff       	call   80046f <cprintf>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	eb b9                	jmp    801eef <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f36:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f39:	0f 94 c0             	sete   %al
  801f3c:	0f b6 c0             	movzbl %al,%eax
}
  801f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f42:	5b                   	pop    %ebx
  801f43:	5e                   	pop    %esi
  801f44:	5f                   	pop    %edi
  801f45:	5d                   	pop    %ebp
  801f46:	c3                   	ret    

00801f47 <devpipe_write>:
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	57                   	push   %edi
  801f4b:	56                   	push   %esi
  801f4c:	53                   	push   %ebx
  801f4d:	83 ec 28             	sub    $0x28,%esp
  801f50:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f53:	56                   	push   %esi
  801f54:	e8 61 f7 ff ff       	call   8016ba <fd2data>
  801f59:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f63:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f66:	74 4f                	je     801fb7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f68:	8b 43 04             	mov    0x4(%ebx),%eax
  801f6b:	8b 0b                	mov    (%ebx),%ecx
  801f6d:	8d 51 20             	lea    0x20(%ecx),%edx
  801f70:	39 d0                	cmp    %edx,%eax
  801f72:	72 14                	jb     801f88 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f74:	89 da                	mov    %ebx,%edx
  801f76:	89 f0                	mov    %esi,%eax
  801f78:	e8 65 ff ff ff       	call   801ee2 <_pipeisclosed>
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	75 3b                	jne    801fbc <devpipe_write+0x75>
			sys_yield();
  801f81:	e8 1b f0 ff ff       	call   800fa1 <sys_yield>
  801f86:	eb e0                	jmp    801f68 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f8f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f92:	89 c2                	mov    %eax,%edx
  801f94:	c1 fa 1f             	sar    $0x1f,%edx
  801f97:	89 d1                	mov    %edx,%ecx
  801f99:	c1 e9 1b             	shr    $0x1b,%ecx
  801f9c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f9f:	83 e2 1f             	and    $0x1f,%edx
  801fa2:	29 ca                	sub    %ecx,%edx
  801fa4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fa8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fac:	83 c0 01             	add    $0x1,%eax
  801faf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fb2:	83 c7 01             	add    $0x1,%edi
  801fb5:	eb ac                	jmp    801f63 <devpipe_write+0x1c>
	return i;
  801fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fba:	eb 05                	jmp    801fc1 <devpipe_write+0x7a>
				return 0;
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5f                   	pop    %edi
  801fc7:	5d                   	pop    %ebp
  801fc8:	c3                   	ret    

00801fc9 <devpipe_read>:
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	57                   	push   %edi
  801fcd:	56                   	push   %esi
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 18             	sub    $0x18,%esp
  801fd2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fd5:	57                   	push   %edi
  801fd6:	e8 df f6 ff ff       	call   8016ba <fd2data>
  801fdb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	be 00 00 00 00       	mov    $0x0,%esi
  801fe5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fe8:	75 14                	jne    801ffe <devpipe_read+0x35>
	return i;
  801fea:	8b 45 10             	mov    0x10(%ebp),%eax
  801fed:	eb 02                	jmp    801ff1 <devpipe_read+0x28>
				return i;
  801fef:	89 f0                	mov    %esi,%eax
}
  801ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5f                   	pop    %edi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    
			sys_yield();
  801ff9:	e8 a3 ef ff ff       	call   800fa1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ffe:	8b 03                	mov    (%ebx),%eax
  802000:	3b 43 04             	cmp    0x4(%ebx),%eax
  802003:	75 18                	jne    80201d <devpipe_read+0x54>
			if (i > 0)
  802005:	85 f6                	test   %esi,%esi
  802007:	75 e6                	jne    801fef <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802009:	89 da                	mov    %ebx,%edx
  80200b:	89 f8                	mov    %edi,%eax
  80200d:	e8 d0 fe ff ff       	call   801ee2 <_pipeisclosed>
  802012:	85 c0                	test   %eax,%eax
  802014:	74 e3                	je     801ff9 <devpipe_read+0x30>
				return 0;
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	eb d4                	jmp    801ff1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80201d:	99                   	cltd   
  80201e:	c1 ea 1b             	shr    $0x1b,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	83 e0 1f             	and    $0x1f,%eax
  802026:	29 d0                	sub    %edx,%eax
  802028:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80202d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802030:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802033:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802036:	83 c6 01             	add    $0x1,%esi
  802039:	eb aa                	jmp    801fe5 <devpipe_read+0x1c>

0080203b <pipe>:
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802043:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802046:	50                   	push   %eax
  802047:	e8 85 f6 ff ff       	call   8016d1 <fd_alloc>
  80204c:	89 c3                	mov    %eax,%ebx
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	85 c0                	test   %eax,%eax
  802053:	0f 88 23 01 00 00    	js     80217c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	68 07 04 00 00       	push   $0x407
  802061:	ff 75 f4             	pushl  -0xc(%ebp)
  802064:	6a 00                	push   $0x0
  802066:	e8 55 ef ff ff       	call   800fc0 <sys_page_alloc>
  80206b:	89 c3                	mov    %eax,%ebx
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	85 c0                	test   %eax,%eax
  802072:	0f 88 04 01 00 00    	js     80217c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80207e:	50                   	push   %eax
  80207f:	e8 4d f6 ff ff       	call   8016d1 <fd_alloc>
  802084:	89 c3                	mov    %eax,%ebx
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	85 c0                	test   %eax,%eax
  80208b:	0f 88 db 00 00 00    	js     80216c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	68 07 04 00 00       	push   $0x407
  802099:	ff 75 f0             	pushl  -0x10(%ebp)
  80209c:	6a 00                	push   $0x0
  80209e:	e8 1d ef ff ff       	call   800fc0 <sys_page_alloc>
  8020a3:	89 c3                	mov    %eax,%ebx
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	0f 88 bc 00 00 00    	js     80216c <pipe+0x131>
	va = fd2data(fd0);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b6:	e8 ff f5 ff ff       	call   8016ba <fd2data>
  8020bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bd:	83 c4 0c             	add    $0xc,%esp
  8020c0:	68 07 04 00 00       	push   $0x407
  8020c5:	50                   	push   %eax
  8020c6:	6a 00                	push   $0x0
  8020c8:	e8 f3 ee ff ff       	call   800fc0 <sys_page_alloc>
  8020cd:	89 c3                	mov    %eax,%ebx
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	0f 88 82 00 00 00    	js     80215c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e0:	e8 d5 f5 ff ff       	call   8016ba <fd2data>
  8020e5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020ec:	50                   	push   %eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	56                   	push   %esi
  8020f0:	6a 00                	push   $0x0
  8020f2:	e8 0c ef ff ff       	call   801003 <sys_page_map>
  8020f7:	89 c3                	mov    %eax,%ebx
  8020f9:	83 c4 20             	add    $0x20,%esp
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 4e                	js     80214e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802100:	a1 24 30 80 00       	mov    0x803024,%eax
  802105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802108:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80210a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802114:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802117:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	ff 75 f4             	pushl  -0xc(%ebp)
  802129:	e8 7c f5 ff ff       	call   8016aa <fd2num>
  80212e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802131:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802133:	83 c4 04             	add    $0x4,%esp
  802136:	ff 75 f0             	pushl  -0x10(%ebp)
  802139:	e8 6c f5 ff ff       	call   8016aa <fd2num>
  80213e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802141:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	bb 00 00 00 00       	mov    $0x0,%ebx
  80214c:	eb 2e                	jmp    80217c <pipe+0x141>
	sys_page_unmap(0, va);
  80214e:	83 ec 08             	sub    $0x8,%esp
  802151:	56                   	push   %esi
  802152:	6a 00                	push   $0x0
  802154:	e8 ec ee ff ff       	call   801045 <sys_page_unmap>
  802159:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	ff 75 f0             	pushl  -0x10(%ebp)
  802162:	6a 00                	push   $0x0
  802164:	e8 dc ee ff ff       	call   801045 <sys_page_unmap>
  802169:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80216c:	83 ec 08             	sub    $0x8,%esp
  80216f:	ff 75 f4             	pushl  -0xc(%ebp)
  802172:	6a 00                	push   $0x0
  802174:	e8 cc ee ff ff       	call   801045 <sys_page_unmap>
  802179:	83 c4 10             	add    $0x10,%esp
}
  80217c:	89 d8                	mov    %ebx,%eax
  80217e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    

00802185 <pipeisclosed>:
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218e:	50                   	push   %eax
  80218f:	ff 75 08             	pushl  0x8(%ebp)
  802192:	e8 8c f5 ff ff       	call   801723 <fd_lookup>
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 18                	js     8021b6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80219e:	83 ec 0c             	sub    $0xc,%esp
  8021a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a4:	e8 11 f5 ff ff       	call   8016ba <fd2data>
	return _pipeisclosed(fd, p);
  8021a9:	89 c2                	mov    %eax,%edx
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	e8 2f fd ff ff       	call   801ee2 <_pipeisclosed>
  8021b3:	83 c4 10             	add    $0x10,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	56                   	push   %esi
  8021bc:	53                   	push   %ebx
  8021bd:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8021c0:	85 f6                	test   %esi,%esi
  8021c2:	74 13                	je     8021d7 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8021c4:	89 f3                	mov    %esi,%ebx
  8021c6:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8021cc:	c1 e3 07             	shl    $0x7,%ebx
  8021cf:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8021d5:	eb 1b                	jmp    8021f2 <wait+0x3a>
	assert(envid != 0);
  8021d7:	68 c0 2e 80 00       	push   $0x802ec0
  8021dc:	68 80 2e 80 00       	push   $0x802e80
  8021e1:	6a 09                	push   $0x9
  8021e3:	68 cb 2e 80 00       	push   $0x802ecb
  8021e8:	e8 8c e1 ff ff       	call   800379 <_panic>
		sys_yield();
  8021ed:	e8 af ed ff ff       	call   800fa1 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8021f2:	8b 43 48             	mov    0x48(%ebx),%eax
  8021f5:	39 f0                	cmp    %esi,%eax
  8021f7:	75 07                	jne    802200 <wait+0x48>
  8021f9:	8b 43 54             	mov    0x54(%ebx),%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	75 ed                	jne    8021ed <wait+0x35>
}
  802200:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5d                   	pop    %ebp
  802206:	c3                   	ret    

00802207 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
  80220c:	c3                   	ret    

0080220d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802213:	68 d6 2e 80 00       	push   $0x802ed6
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	e8 ae e9 ff ff       	call   800bce <strcpy>
	return 0;
}
  802220:	b8 00 00 00 00       	mov    $0x0,%eax
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <devcons_write>:
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	57                   	push   %edi
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802233:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802238:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80223e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802241:	73 31                	jae    802274 <devcons_write+0x4d>
		m = n - tot;
  802243:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802246:	29 f3                	sub    %esi,%ebx
  802248:	83 fb 7f             	cmp    $0x7f,%ebx
  80224b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802250:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	53                   	push   %ebx
  802257:	89 f0                	mov    %esi,%eax
  802259:	03 45 0c             	add    0xc(%ebp),%eax
  80225c:	50                   	push   %eax
  80225d:	57                   	push   %edi
  80225e:	e8 f9 ea ff ff       	call   800d5c <memmove>
		sys_cputs(buf, m);
  802263:	83 c4 08             	add    $0x8,%esp
  802266:	53                   	push   %ebx
  802267:	57                   	push   %edi
  802268:	e8 97 ec ff ff       	call   800f04 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80226d:	01 de                	add    %ebx,%esi
  80226f:	83 c4 10             	add    $0x10,%esp
  802272:	eb ca                	jmp    80223e <devcons_write+0x17>
}
  802274:	89 f0                	mov    %esi,%eax
  802276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802279:	5b                   	pop    %ebx
  80227a:	5e                   	pop    %esi
  80227b:	5f                   	pop    %edi
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    

0080227e <devcons_read>:
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 08             	sub    $0x8,%esp
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802289:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80228d:	74 21                	je     8022b0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80228f:	e8 8e ec ff ff       	call   800f22 <sys_cgetc>
  802294:	85 c0                	test   %eax,%eax
  802296:	75 07                	jne    80229f <devcons_read+0x21>
		sys_yield();
  802298:	e8 04 ed ff ff       	call   800fa1 <sys_yield>
  80229d:	eb f0                	jmp    80228f <devcons_read+0x11>
	if (c < 0)
  80229f:	78 0f                	js     8022b0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8022a1:	83 f8 04             	cmp    $0x4,%eax
  8022a4:	74 0c                	je     8022b2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	88 02                	mov    %al,(%edx)
	return 1;
  8022ab:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    
		return 0;
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	eb f7                	jmp    8022b0 <devcons_read+0x32>

008022b9 <cputchar>:
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022c5:	6a 01                	push   $0x1
  8022c7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ca:	50                   	push   %eax
  8022cb:	e8 34 ec ff ff       	call   800f04 <sys_cputs>
}
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <getchar>:
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022db:	6a 01                	push   $0x1
  8022dd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022e0:	50                   	push   %eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	e8 a6 f6 ff ff       	call   80198e <read>
	if (r < 0)
  8022e8:	83 c4 10             	add    $0x10,%esp
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	78 06                	js     8022f5 <getchar+0x20>
	if (r < 1)
  8022ef:	74 06                	je     8022f7 <getchar+0x22>
	return c;
  8022f1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    
		return -E_EOF;
  8022f7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022fc:	eb f7                	jmp    8022f5 <getchar+0x20>

008022fe <iscons>:
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802304:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802307:	50                   	push   %eax
  802308:	ff 75 08             	pushl  0x8(%ebp)
  80230b:	e8 13 f4 ff ff       	call   801723 <fd_lookup>
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	85 c0                	test   %eax,%eax
  802315:	78 11                	js     802328 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802320:	39 10                	cmp    %edx,(%eax)
  802322:	0f 94 c0             	sete   %al
  802325:	0f b6 c0             	movzbl %al,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <opencons>:
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802333:	50                   	push   %eax
  802334:	e8 98 f3 ff ff       	call   8016d1 <fd_alloc>
  802339:	83 c4 10             	add    $0x10,%esp
  80233c:	85 c0                	test   %eax,%eax
  80233e:	78 3a                	js     80237a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 07 04 00 00       	push   $0x407
  802348:	ff 75 f4             	pushl  -0xc(%ebp)
  80234b:	6a 00                	push   $0x0
  80234d:	e8 6e ec ff ff       	call   800fc0 <sys_page_alloc>
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	85 c0                	test   %eax,%eax
  802357:	78 21                	js     80237a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802362:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	50                   	push   %eax
  802372:	e8 33 f3 ff ff       	call   8016aa <fd2num>
  802377:	83 c4 10             	add    $0x10,%esp
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802382:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802389:	74 0a                	je     802395 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	6a 07                	push   $0x7
  80239a:	68 00 f0 bf ee       	push   $0xeebff000
  80239f:	6a 00                	push   $0x0
  8023a1:	e8 1a ec ff ff       	call   800fc0 <sys_page_alloc>
		if(r < 0)
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	78 2a                	js     8023d7 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8023ad:	83 ec 08             	sub    $0x8,%esp
  8023b0:	68 eb 23 80 00       	push   $0x8023eb
  8023b5:	6a 00                	push   $0x0
  8023b7:	e8 4f ed ff ff       	call   80110b <sys_env_set_pgfault_upcall>
		if(r < 0)
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	79 c8                	jns    80238b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 14 2f 80 00       	push   $0x802f14
  8023cb:	6a 25                	push   $0x25
  8023cd:	68 50 2f 80 00       	push   $0x802f50
  8023d2:	e8 a2 df ff ff       	call   800379 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 e4 2e 80 00       	push   $0x802ee4
  8023df:	6a 22                	push   $0x22
  8023e1:	68 50 2f 80 00       	push   $0x802f50
  8023e6:	e8 8e df ff ff       	call   800379 <_panic>

008023eb <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023eb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023ec:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8023f1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023f3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8023f6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8023fa:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8023fe:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802401:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802403:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802407:	83 c4 08             	add    $0x8,%esp
	popal
  80240a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80240b:	83 c4 04             	add    $0x4,%esp
	popfl
  80240e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80240f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802410:	c3                   	ret    

00802411 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	56                   	push   %esi
  802415:	53                   	push   %ebx
  802416:	8b 75 08             	mov    0x8(%ebp),%esi
  802419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  80241f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802421:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802426:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	50                   	push   %eax
  80242d:	e8 3e ed ff ff       	call   801170 <sys_ipc_recv>
	if(ret < 0){
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	85 c0                	test   %eax,%eax
  802437:	78 2b                	js     802464 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802439:	85 f6                	test   %esi,%esi
  80243b:	74 0a                	je     802447 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80243d:	a1 04 40 80 00       	mov    0x804004,%eax
  802442:	8b 40 74             	mov    0x74(%eax),%eax
  802445:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802447:	85 db                	test   %ebx,%ebx
  802449:	74 0a                	je     802455 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80244b:	a1 04 40 80 00       	mov    0x804004,%eax
  802450:	8b 40 78             	mov    0x78(%eax),%eax
  802453:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802455:	a1 04 40 80 00       	mov    0x804004,%eax
  80245a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80245d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
		if(from_env_store)
  802464:	85 f6                	test   %esi,%esi
  802466:	74 06                	je     80246e <ipc_recv+0x5d>
			*from_env_store = 0;
  802468:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80246e:	85 db                	test   %ebx,%ebx
  802470:	74 eb                	je     80245d <ipc_recv+0x4c>
			*perm_store = 0;
  802472:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802478:	eb e3                	jmp    80245d <ipc_recv+0x4c>

0080247a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	57                   	push   %edi
  80247e:	56                   	push   %esi
  80247f:	53                   	push   %ebx
  802480:	83 ec 0c             	sub    $0xc,%esp
  802483:	8b 7d 08             	mov    0x8(%ebp),%edi
  802486:	8b 75 0c             	mov    0xc(%ebp),%esi
  802489:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80248c:	85 db                	test   %ebx,%ebx
  80248e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802493:	0f 44 d8             	cmove  %eax,%ebx
  802496:	eb 05                	jmp    80249d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802498:	e8 04 eb ff ff       	call   800fa1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80249d:	ff 75 14             	pushl  0x14(%ebp)
  8024a0:	53                   	push   %ebx
  8024a1:	56                   	push   %esi
  8024a2:	57                   	push   %edi
  8024a3:	e8 a5 ec ff ff       	call   80114d <sys_ipc_try_send>
  8024a8:	83 c4 10             	add    $0x10,%esp
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 1b                	je     8024ca <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8024af:	79 e7                	jns    802498 <ipc_send+0x1e>
  8024b1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024b4:	74 e2                	je     802498 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	68 5e 2f 80 00       	push   $0x802f5e
  8024be:	6a 49                	push   $0x49
  8024c0:	68 73 2f 80 00       	push   $0x802f73
  8024c5:	e8 af de ff ff       	call   800379 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8024ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    

008024d2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024dd:	89 c2                	mov    %eax,%edx
  8024df:	c1 e2 07             	shl    $0x7,%edx
  8024e2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024e8:	8b 52 50             	mov    0x50(%edx),%edx
  8024eb:	39 ca                	cmp    %ecx,%edx
  8024ed:	74 11                	je     802500 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8024ef:	83 c0 01             	add    $0x1,%eax
  8024f2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024f7:	75 e4                	jne    8024dd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	eb 0b                	jmp    80250b <ipc_find_env+0x39>
			return envs[i].env_id;
  802500:	c1 e0 07             	shl    $0x7,%eax
  802503:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802508:	8b 40 48             	mov    0x48(%eax),%eax
}
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    

0080250d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802513:	89 d0                	mov    %edx,%eax
  802515:	c1 e8 16             	shr    $0x16,%eax
  802518:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802524:	f6 c1 01             	test   $0x1,%cl
  802527:	74 1d                	je     802546 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802529:	c1 ea 0c             	shr    $0xc,%edx
  80252c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802533:	f6 c2 01             	test   $0x1,%dl
  802536:	74 0e                	je     802546 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802538:	c1 ea 0c             	shr    $0xc,%edx
  80253b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802542:	ef 
  802543:	0f b7 c0             	movzwl %ax,%eax
}
  802546:	5d                   	pop    %ebp
  802547:	c3                   	ret    
  802548:	66 90                	xchg   %ax,%ax
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__udivdi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80255b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80255f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802563:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802567:	85 d2                	test   %edx,%edx
  802569:	75 4d                	jne    8025b8 <__udivdi3+0x68>
  80256b:	39 f3                	cmp    %esi,%ebx
  80256d:	76 19                	jbe    802588 <__udivdi3+0x38>
  80256f:	31 ff                	xor    %edi,%edi
  802571:	89 e8                	mov    %ebp,%eax
  802573:	89 f2                	mov    %esi,%edx
  802575:	f7 f3                	div    %ebx
  802577:	89 fa                	mov    %edi,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 d9                	mov    %ebx,%ecx
  80258a:	85 db                	test   %ebx,%ebx
  80258c:	75 0b                	jne    802599 <__udivdi3+0x49>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f3                	div    %ebx
  802597:	89 c1                	mov    %eax,%ecx
  802599:	31 d2                	xor    %edx,%edx
  80259b:	89 f0                	mov    %esi,%eax
  80259d:	f7 f1                	div    %ecx
  80259f:	89 c6                	mov    %eax,%esi
  8025a1:	89 e8                	mov    %ebp,%eax
  8025a3:	89 f7                	mov    %esi,%edi
  8025a5:	f7 f1                	div    %ecx
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	83 c4 1c             	add    $0x1c,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5e                   	pop    %esi
  8025ae:	5f                   	pop    %edi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
  8025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	39 f2                	cmp    %esi,%edx
  8025ba:	77 1c                	ja     8025d8 <__udivdi3+0x88>
  8025bc:	0f bd fa             	bsr    %edx,%edi
  8025bf:	83 f7 1f             	xor    $0x1f,%edi
  8025c2:	75 2c                	jne    8025f0 <__udivdi3+0xa0>
  8025c4:	39 f2                	cmp    %esi,%edx
  8025c6:	72 06                	jb     8025ce <__udivdi3+0x7e>
  8025c8:	31 c0                	xor    %eax,%eax
  8025ca:	39 eb                	cmp    %ebp,%ebx
  8025cc:	77 a9                	ja     802577 <__udivdi3+0x27>
  8025ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d3:	eb a2                	jmp    802577 <__udivdi3+0x27>
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	31 ff                	xor    %edi,%edi
  8025da:	31 c0                	xor    %eax,%eax
  8025dc:	89 fa                	mov    %edi,%edx
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 f9                	mov    %edi,%ecx
  8025f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025f7:	29 f8                	sub    %edi,%eax
  8025f9:	d3 e2                	shl    %cl,%edx
  8025fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ff:	89 c1                	mov    %eax,%ecx
  802601:	89 da                	mov    %ebx,%edx
  802603:	d3 ea                	shr    %cl,%edx
  802605:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802609:	09 d1                	or     %edx,%ecx
  80260b:	89 f2                	mov    %esi,%edx
  80260d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802611:	89 f9                	mov    %edi,%ecx
  802613:	d3 e3                	shl    %cl,%ebx
  802615:	89 c1                	mov    %eax,%ecx
  802617:	d3 ea                	shr    %cl,%edx
  802619:	89 f9                	mov    %edi,%ecx
  80261b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80261f:	89 eb                	mov    %ebp,%ebx
  802621:	d3 e6                	shl    %cl,%esi
  802623:	89 c1                	mov    %eax,%ecx
  802625:	d3 eb                	shr    %cl,%ebx
  802627:	09 de                	or     %ebx,%esi
  802629:	89 f0                	mov    %esi,%eax
  80262b:	f7 74 24 08          	divl   0x8(%esp)
  80262f:	89 d6                	mov    %edx,%esi
  802631:	89 c3                	mov    %eax,%ebx
  802633:	f7 64 24 0c          	mull   0xc(%esp)
  802637:	39 d6                	cmp    %edx,%esi
  802639:	72 15                	jb     802650 <__udivdi3+0x100>
  80263b:	89 f9                	mov    %edi,%ecx
  80263d:	d3 e5                	shl    %cl,%ebp
  80263f:	39 c5                	cmp    %eax,%ebp
  802641:	73 04                	jae    802647 <__udivdi3+0xf7>
  802643:	39 d6                	cmp    %edx,%esi
  802645:	74 09                	je     802650 <__udivdi3+0x100>
  802647:	89 d8                	mov    %ebx,%eax
  802649:	31 ff                	xor    %edi,%edi
  80264b:	e9 27 ff ff ff       	jmp    802577 <__udivdi3+0x27>
  802650:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802653:	31 ff                	xor    %edi,%edi
  802655:	e9 1d ff ff ff       	jmp    802577 <__udivdi3+0x27>
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__umoddi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80266b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80266f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802677:	89 da                	mov    %ebx,%edx
  802679:	85 c0                	test   %eax,%eax
  80267b:	75 43                	jne    8026c0 <__umoddi3+0x60>
  80267d:	39 df                	cmp    %ebx,%edi
  80267f:	76 17                	jbe    802698 <__umoddi3+0x38>
  802681:	89 f0                	mov    %esi,%eax
  802683:	f7 f7                	div    %edi
  802685:	89 d0                	mov    %edx,%eax
  802687:	31 d2                	xor    %edx,%edx
  802689:	83 c4 1c             	add    $0x1c,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	89 fd                	mov    %edi,%ebp
  80269a:	85 ff                	test   %edi,%edi
  80269c:	75 0b                	jne    8026a9 <__umoddi3+0x49>
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	31 d2                	xor    %edx,%edx
  8026a5:	f7 f7                	div    %edi
  8026a7:	89 c5                	mov    %eax,%ebp
  8026a9:	89 d8                	mov    %ebx,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	f7 f5                	div    %ebp
  8026af:	89 f0                	mov    %esi,%eax
  8026b1:	f7 f5                	div    %ebp
  8026b3:	89 d0                	mov    %edx,%eax
  8026b5:	eb d0                	jmp    802687 <__umoddi3+0x27>
  8026b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	89 f1                	mov    %esi,%ecx
  8026c2:	39 d8                	cmp    %ebx,%eax
  8026c4:	76 0a                	jbe    8026d0 <__umoddi3+0x70>
  8026c6:	89 f0                	mov    %esi,%eax
  8026c8:	83 c4 1c             	add    $0x1c,%esp
  8026cb:	5b                   	pop    %ebx
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	0f bd e8             	bsr    %eax,%ebp
  8026d3:	83 f5 1f             	xor    $0x1f,%ebp
  8026d6:	75 20                	jne    8026f8 <__umoddi3+0x98>
  8026d8:	39 d8                	cmp    %ebx,%eax
  8026da:	0f 82 b0 00 00 00    	jb     802790 <__umoddi3+0x130>
  8026e0:	39 f7                	cmp    %esi,%edi
  8026e2:	0f 86 a8 00 00 00    	jbe    802790 <__umoddi3+0x130>
  8026e8:	89 c8                	mov    %ecx,%eax
  8026ea:	83 c4 1c             	add    $0x1c,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    
  8026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026ff:	29 ea                	sub    %ebp,%edx
  802701:	d3 e0                	shl    %cl,%eax
  802703:	89 44 24 08          	mov    %eax,0x8(%esp)
  802707:	89 d1                	mov    %edx,%ecx
  802709:	89 f8                	mov    %edi,%eax
  80270b:	d3 e8                	shr    %cl,%eax
  80270d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802711:	89 54 24 04          	mov    %edx,0x4(%esp)
  802715:	8b 54 24 04          	mov    0x4(%esp),%edx
  802719:	09 c1                	or     %eax,%ecx
  80271b:	89 d8                	mov    %ebx,%eax
  80271d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802721:	89 e9                	mov    %ebp,%ecx
  802723:	d3 e7                	shl    %cl,%edi
  802725:	89 d1                	mov    %edx,%ecx
  802727:	d3 e8                	shr    %cl,%eax
  802729:	89 e9                	mov    %ebp,%ecx
  80272b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80272f:	d3 e3                	shl    %cl,%ebx
  802731:	89 c7                	mov    %eax,%edi
  802733:	89 d1                	mov    %edx,%ecx
  802735:	89 f0                	mov    %esi,%eax
  802737:	d3 e8                	shr    %cl,%eax
  802739:	89 e9                	mov    %ebp,%ecx
  80273b:	89 fa                	mov    %edi,%edx
  80273d:	d3 e6                	shl    %cl,%esi
  80273f:	09 d8                	or     %ebx,%eax
  802741:	f7 74 24 08          	divl   0x8(%esp)
  802745:	89 d1                	mov    %edx,%ecx
  802747:	89 f3                	mov    %esi,%ebx
  802749:	f7 64 24 0c          	mull   0xc(%esp)
  80274d:	89 c6                	mov    %eax,%esi
  80274f:	89 d7                	mov    %edx,%edi
  802751:	39 d1                	cmp    %edx,%ecx
  802753:	72 06                	jb     80275b <__umoddi3+0xfb>
  802755:	75 10                	jne    802767 <__umoddi3+0x107>
  802757:	39 c3                	cmp    %eax,%ebx
  802759:	73 0c                	jae    802767 <__umoddi3+0x107>
  80275b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80275f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802763:	89 d7                	mov    %edx,%edi
  802765:	89 c6                	mov    %eax,%esi
  802767:	89 ca                	mov    %ecx,%edx
  802769:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80276e:	29 f3                	sub    %esi,%ebx
  802770:	19 fa                	sbb    %edi,%edx
  802772:	89 d0                	mov    %edx,%eax
  802774:	d3 e0                	shl    %cl,%eax
  802776:	89 e9                	mov    %ebp,%ecx
  802778:	d3 eb                	shr    %cl,%ebx
  80277a:	d3 ea                	shr    %cl,%edx
  80277c:	09 d8                	or     %ebx,%eax
  80277e:	83 c4 1c             	add    $0x1c,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    
  802786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	89 da                	mov    %ebx,%edx
  802792:	29 fe                	sub    %edi,%esi
  802794:	19 c2                	sbb    %eax,%edx
  802796:	89 f1                	mov    %esi,%ecx
  802798:	89 c8                	mov    %ecx,%eax
  80279a:	e9 4b ff ff ff       	jmp    8026ea <__umoddi3+0x8a>
