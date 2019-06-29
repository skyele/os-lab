
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
  80003b:	c7 05 04 40 80 00 40 	movl   $0x802d40,0x804004
  800042:	2d 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 8e 25 00 00       	call   8025dc <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 80 14 00 00       	call   8014e0 <fork>
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
  80007f:	68 6e 2d 80 00       	push   $0x802d6e
  800084:	e8 bc 03 00 00       	call   800445 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 8f 18 00 00       	call   801923 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 8b 2d 80 00       	push   $0x802d8b
  8000a8:	e8 98 03 00 00       	call   800445 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 2a 1a 00 00       	call   801ae8 <readn>
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
  8000dd:	e8 6d 0b 00 00       	call   800c4f <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 b1 2d 80 00       	push   $0x802db1
  8000f5:	e8 4b 03 00 00       	call   800445 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 19 02 00 00       	call   80031b <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 4e 26 00 00       	call   802759 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 07 	movl   $0x802e07,0x804004
  800112:	2e 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 bc 24 00 00       	call   8025dc <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 ae 13 00 00       	call   8014e0 <fork>
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
  800148:	e8 d6 17 00 00       	call   801923 <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 cb 17 00 00       	call   801923 <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 f9 25 00 00       	call   802759 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  800167:	e8 d9 02 00 00       	call   800445 <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 4c 2d 80 00       	push   $0x802d4c
  80017c:	6a 0e                	push   $0xe
  80017e:	68 55 2d 80 00       	push   $0x802d55
  800183:	e8 c7 01 00 00       	call   80034f <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 65 2d 80 00       	push   $0x802d65
  80018e:	6a 11                	push   $0x11
  800190:	68 55 2d 80 00       	push   $0x802d55
  800195:	e8 b5 01 00 00       	call   80034f <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 a8 2d 80 00       	push   $0x802da8
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 55 2d 80 00       	push   $0x802d55
  8001a7:	e8 a3 01 00 00       	call   80034f <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 cd 2d 80 00       	push   $0x802dcd
  8001b9:	e8 87 02 00 00       	call   800445 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 6e 2d 80 00       	push   $0x802d6e
  8001da:	e8 66 02 00 00       	call   800445 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 39 17 00 00       	call   801923 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 e0 2d 80 00       	push   $0x802de0
  8001fe:	e8 42 02 00 00       	call   800445 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 5a 09 00 00       	call   800b6b <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 0a 19 00 00       	call   801b2d <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 40 80 00    	pushl  0x804000
  80022e:	e8 38 09 00 00       	call   800b6b <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 de 16 00 00       	call   801923 <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 fd 2d 80 00       	push   $0x802dfd
  800253:	6a 25                	push   $0x25
  800255:	68 55 2d 80 00       	push   $0x802d55
  80025a:	e8 f0 00 00 00       	call   80034f <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 4c 2d 80 00       	push   $0x802d4c
  800265:	6a 2c                	push   $0x2c
  800267:	68 55 2d 80 00       	push   $0x802d55
  80026c:	e8 de 00 00 00       	call   80034f <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 65 2d 80 00       	push   $0x802d65
  800277:	6a 2f                	push   $0x2f
  800279:	68 55 2d 80 00       	push   $0x802d55
  80027e:	e8 cc 00 00 00       	call   80034f <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 95 16 00 00       	call   801923 <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 14 2e 80 00       	push   $0x802e14
  800299:	e8 a7 01 00 00       	call   800445 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 16 2e 80 00       	push   $0x802e16
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 7d 18 00 00       	call   801b2d <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 18 2e 80 00       	push   $0x802e18
  8002c0:	e8 80 01 00 00       	call   800445 <cprintf>
		exit();
  8002c5:	e8 51 00 00 00       	call   80031b <exit>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	e9 70 fe ff ff       	jmp    800142 <umain+0x10f>

008002d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8002dd:	e8 76 0c 00 00       	call   800f58 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8002e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e7:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8002ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f2:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f7:	85 db                	test   %ebx,%ebx
  8002f9:	7e 07                	jle    800302 <libmain+0x30>
		binaryname = argv[0];
  8002fb:	8b 06                	mov    (%esi),%eax
  8002fd:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	e8 27 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030c:	e8 0a 00 00 00       	call   80031b <exit>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800317:	5b                   	pop    %ebx
  800318:	5e                   	pop    %esi
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    

0080031b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800321:	a1 08 50 80 00       	mov    0x805008,%eax
  800326:	8b 40 48             	mov    0x48(%eax),%eax
  800329:	68 a4 2e 80 00       	push   $0x802ea4
  80032e:	50                   	push   %eax
  80032f:	68 96 2e 80 00       	push   $0x802e96
  800334:	e8 0c 01 00 00       	call   800445 <cprintf>
	close_all();
  800339:	e8 12 16 00 00       	call   801950 <close_all>
	sys_env_destroy(0);
  80033e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800345:	e8 cd 0b 00 00       	call   800f17 <sys_env_destroy>
}
  80034a:	83 c4 10             	add    $0x10,%esp
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	56                   	push   %esi
  800353:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800354:	a1 08 50 80 00       	mov    0x805008,%eax
  800359:	8b 40 48             	mov    0x48(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	68 d0 2e 80 00       	push   $0x802ed0
  800364:	50                   	push   %eax
  800365:	68 96 2e 80 00       	push   $0x802e96
  80036a:	e8 d6 00 00 00       	call   800445 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80036f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800372:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800378:	e8 db 0b 00 00       	call   800f58 <sys_getenvid>
  80037d:	83 c4 04             	add    $0x4,%esp
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 08             	pushl  0x8(%ebp)
  800386:	56                   	push   %esi
  800387:	50                   	push   %eax
  800388:	68 ac 2e 80 00       	push   $0x802eac
  80038d:	e8 b3 00 00 00       	call   800445 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800392:	83 c4 18             	add    $0x18,%esp
  800395:	53                   	push   %ebx
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	e8 56 00 00 00       	call   8003f4 <vcprintf>
	cprintf("\n");
  80039e:	c7 04 24 e1 32 80 00 	movl   $0x8032e1,(%esp)
  8003a5:	e8 9b 00 00 00       	call   800445 <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ad:	cc                   	int3   
  8003ae:	eb fd                	jmp    8003ad <_panic+0x5e>

008003b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ba:	8b 13                	mov    (%ebx),%edx
  8003bc:	8d 42 01             	lea    0x1(%edx),%eax
  8003bf:	89 03                	mov    %eax,(%ebx)
  8003c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003cd:	74 09                	je     8003d8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	68 ff 00 00 00       	push   $0xff
  8003e0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e3:	50                   	push   %eax
  8003e4:	e8 f1 0a 00 00       	call   800eda <sys_cputs>
		b->idx = 0;
  8003e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	eb db                	jmp    8003cf <putch+0x1f>

008003f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800404:	00 00 00 
	b.cnt = 0;
  800407:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800411:	ff 75 0c             	pushl  0xc(%ebp)
  800414:	ff 75 08             	pushl  0x8(%ebp)
  800417:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041d:	50                   	push   %eax
  80041e:	68 b0 03 80 00       	push   $0x8003b0
  800423:	e8 4a 01 00 00       	call   800572 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800428:	83 c4 08             	add    $0x8,%esp
  80042b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800431:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	e8 9d 0a 00 00       	call   800eda <sys_cputs>

	return b.cnt;
}
  80043d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80044b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80044e:	50                   	push   %eax
  80044f:	ff 75 08             	pushl  0x8(%ebp)
  800452:	e8 9d ff ff ff       	call   8003f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	57                   	push   %edi
  80045d:	56                   	push   %esi
  80045e:	53                   	push   %ebx
  80045f:	83 ec 1c             	sub    $0x1c,%esp
  800462:	89 c6                	mov    %eax,%esi
  800464:	89 d7                	mov    %edx,%edi
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800472:	8b 45 10             	mov    0x10(%ebp),%eax
  800475:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800478:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80047c:	74 2c                	je     8004aa <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80047e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800481:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800488:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800493:	73 43                	jae    8004d8 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800495:	83 eb 01             	sub    $0x1,%ebx
  800498:	85 db                	test   %ebx,%ebx
  80049a:	7e 6c                	jle    800508 <printnum+0xaf>
				putch(padc, putdat);
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	57                   	push   %edi
  8004a0:	ff 75 18             	pushl  0x18(%ebp)
  8004a3:	ff d6                	call   *%esi
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	eb eb                	jmp    800495 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004aa:	83 ec 0c             	sub    $0xc,%esp
  8004ad:	6a 20                	push   $0x20
  8004af:	6a 00                	push   $0x0
  8004b1:	50                   	push   %eax
  8004b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b8:	89 fa                	mov    %edi,%edx
  8004ba:	89 f0                	mov    %esi,%eax
  8004bc:	e8 98 ff ff ff       	call   800459 <printnum>
		while (--width > 0)
  8004c1:	83 c4 20             	add    $0x20,%esp
  8004c4:	83 eb 01             	sub    $0x1,%ebx
  8004c7:	85 db                	test   %ebx,%ebx
  8004c9:	7e 65                	jle    800530 <printnum+0xd7>
			putch(padc, putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	57                   	push   %edi
  8004cf:	6a 20                	push   $0x20
  8004d1:	ff d6                	call   *%esi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	eb ec                	jmp    8004c4 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d8:	83 ec 0c             	sub    $0xc,%esp
  8004db:	ff 75 18             	pushl  0x18(%ebp)
  8004de:	83 eb 01             	sub    $0x1,%ebx
  8004e1:	53                   	push   %ebx
  8004e2:	50                   	push   %eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 dc             	pushl  -0x24(%ebp)
  8004e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f2:	e8 f9 25 00 00       	call   802af0 <__udivdi3>
  8004f7:	83 c4 18             	add    $0x18,%esp
  8004fa:	52                   	push   %edx
  8004fb:	50                   	push   %eax
  8004fc:	89 fa                	mov    %edi,%edx
  8004fe:	89 f0                	mov    %esi,%eax
  800500:	e8 54 ff ff ff       	call   800459 <printnum>
  800505:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	57                   	push   %edi
  80050c:	83 ec 04             	sub    $0x4,%esp
  80050f:	ff 75 dc             	pushl  -0x24(%ebp)
  800512:	ff 75 d8             	pushl  -0x28(%ebp)
  800515:	ff 75 e4             	pushl  -0x1c(%ebp)
  800518:	ff 75 e0             	pushl  -0x20(%ebp)
  80051b:	e8 e0 26 00 00       	call   802c00 <__umoddi3>
  800520:	83 c4 14             	add    $0x14,%esp
  800523:	0f be 80 d7 2e 80 00 	movsbl 0x802ed7(%eax),%eax
  80052a:	50                   	push   %eax
  80052b:	ff d6                	call   *%esi
  80052d:	83 c4 10             	add    $0x10,%esp
	}
}
  800530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800533:	5b                   	pop    %ebx
  800534:	5e                   	pop    %esi
  800535:	5f                   	pop    %edi
  800536:	5d                   	pop    %ebp
  800537:	c3                   	ret    

00800538 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800538:	55                   	push   %ebp
  800539:	89 e5                	mov    %esp,%ebp
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80053e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800542:	8b 10                	mov    (%eax),%edx
  800544:	3b 50 04             	cmp    0x4(%eax),%edx
  800547:	73 0a                	jae    800553 <sprintputch+0x1b>
		*b->buf++ = ch;
  800549:	8d 4a 01             	lea    0x1(%edx),%ecx
  80054c:	89 08                	mov    %ecx,(%eax)
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	88 02                	mov    %al,(%edx)
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <printfmt>:
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80055b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80055e:	50                   	push   %eax
  80055f:	ff 75 10             	pushl  0x10(%ebp)
  800562:	ff 75 0c             	pushl  0xc(%ebp)
  800565:	ff 75 08             	pushl  0x8(%ebp)
  800568:	e8 05 00 00 00       	call   800572 <vprintfmt>
}
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	c9                   	leave  
  800571:	c3                   	ret    

00800572 <vprintfmt>:
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	57                   	push   %edi
  800576:	56                   	push   %esi
  800577:	53                   	push   %ebx
  800578:	83 ec 3c             	sub    $0x3c,%esp
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800581:	8b 7d 10             	mov    0x10(%ebp),%edi
  800584:	e9 32 04 00 00       	jmp    8009bb <vprintfmt+0x449>
		padc = ' ';
  800589:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80058d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800594:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80059b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005b0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005b5:	8d 47 01             	lea    0x1(%edi),%eax
  8005b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005bb:	0f b6 17             	movzbl (%edi),%edx
  8005be:	8d 42 dd             	lea    -0x23(%edx),%eax
  8005c1:	3c 55                	cmp    $0x55,%al
  8005c3:	0f 87 12 05 00 00    	ja     800adb <vprintfmt+0x569>
  8005c9:	0f b6 c0             	movzbl %al,%eax
  8005cc:	ff 24 85 c0 30 80 00 	jmp    *0x8030c0(,%eax,4)
  8005d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005d6:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8005da:	eb d9                	jmp    8005b5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005df:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8005e3:	eb d0                	jmp    8005b5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	0f b6 d2             	movzbl %dl,%edx
  8005e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f3:	eb 03                	jmp    8005f8 <vprintfmt+0x86>
  8005f5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005fb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ff:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800602:	8d 72 d0             	lea    -0x30(%edx),%esi
  800605:	83 fe 09             	cmp    $0x9,%esi
  800608:	76 eb                	jbe    8005f5 <vprintfmt+0x83>
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	8b 75 08             	mov    0x8(%ebp),%esi
  800610:	eb 14                	jmp    800626 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 40 04             	lea    0x4(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800623:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80062a:	79 89                	jns    8005b5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80062c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80062f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800632:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800639:	e9 77 ff ff ff       	jmp    8005b5 <vprintfmt+0x43>
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	85 c0                	test   %eax,%eax
  800643:	0f 48 c1             	cmovs  %ecx,%eax
  800646:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800649:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80064c:	e9 64 ff ff ff       	jmp    8005b5 <vprintfmt+0x43>
  800651:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800654:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80065b:	e9 55 ff ff ff       	jmp    8005b5 <vprintfmt+0x43>
			lflag++;
  800660:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800664:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800667:	e9 49 ff ff ff       	jmp    8005b5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8d 78 04             	lea    0x4(%eax),%edi
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	53                   	push   %ebx
  800676:	ff 30                	pushl  (%eax)
  800678:	ff d6                	call   *%esi
			break;
  80067a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80067d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800680:	e9 33 03 00 00       	jmp    8009b8 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 78 04             	lea    0x4(%eax),%edi
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	99                   	cltd   
  80068e:	31 d0                	xor    %edx,%eax
  800690:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800692:	83 f8 11             	cmp    $0x11,%eax
  800695:	7f 23                	jg     8006ba <vprintfmt+0x148>
  800697:	8b 14 85 20 32 80 00 	mov    0x803220(,%eax,4),%edx
  80069e:	85 d2                	test   %edx,%edx
  8006a0:	74 18                	je     8006ba <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006a2:	52                   	push   %edx
  8006a3:	68 2d 34 80 00       	push   $0x80342d
  8006a8:	53                   	push   %ebx
  8006a9:	56                   	push   %esi
  8006aa:	e8 a6 fe ff ff       	call   800555 <printfmt>
  8006af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006b2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006b5:	e9 fe 02 00 00       	jmp    8009b8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006ba:	50                   	push   %eax
  8006bb:	68 ef 2e 80 00       	push   $0x802eef
  8006c0:	53                   	push   %ebx
  8006c1:	56                   	push   %esi
  8006c2:	e8 8e fe ff ff       	call   800555 <printfmt>
  8006c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006ca:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006cd:	e9 e6 02 00 00       	jmp    8009b8 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	83 c0 04             	add    $0x4,%eax
  8006d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8006e0:	85 c9                	test   %ecx,%ecx
  8006e2:	b8 e8 2e 80 00       	mov    $0x802ee8,%eax
  8006e7:	0f 45 c1             	cmovne %ecx,%eax
  8006ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8006ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f1:	7e 06                	jle    8006f9 <vprintfmt+0x187>
  8006f3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006f7:	75 0d                	jne    800706 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006fc:	89 c7                	mov    %eax,%edi
  8006fe:	03 45 e0             	add    -0x20(%ebp),%eax
  800701:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800704:	eb 53                	jmp    800759 <vprintfmt+0x1e7>
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	50                   	push   %eax
  80070d:	e8 71 04 00 00       	call   800b83 <strnlen>
  800712:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800715:	29 c1                	sub    %eax,%ecx
  800717:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80071f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800723:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800726:	eb 0f                	jmp    800737 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	ff 75 e0             	pushl  -0x20(%ebp)
  80072f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800731:	83 ef 01             	sub    $0x1,%edi
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	85 ff                	test   %edi,%edi
  800739:	7f ed                	jg     800728 <vprintfmt+0x1b6>
  80073b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80073e:	85 c9                	test   %ecx,%ecx
  800740:	b8 00 00 00 00       	mov    $0x0,%eax
  800745:	0f 49 c1             	cmovns %ecx,%eax
  800748:	29 c1                	sub    %eax,%ecx
  80074a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80074d:	eb aa                	jmp    8006f9 <vprintfmt+0x187>
					putch(ch, putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	53                   	push   %ebx
  800753:	52                   	push   %edx
  800754:	ff d6                	call   *%esi
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80075c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80075e:	83 c7 01             	add    $0x1,%edi
  800761:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800765:	0f be d0             	movsbl %al,%edx
  800768:	85 d2                	test   %edx,%edx
  80076a:	74 4b                	je     8007b7 <vprintfmt+0x245>
  80076c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800770:	78 06                	js     800778 <vprintfmt+0x206>
  800772:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800776:	78 1e                	js     800796 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800778:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80077c:	74 d1                	je     80074f <vprintfmt+0x1dd>
  80077e:	0f be c0             	movsbl %al,%eax
  800781:	83 e8 20             	sub    $0x20,%eax
  800784:	83 f8 5e             	cmp    $0x5e,%eax
  800787:	76 c6                	jbe    80074f <vprintfmt+0x1dd>
					putch('?', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 3f                	push   $0x3f
  80078f:	ff d6                	call   *%esi
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	eb c3                	jmp    800759 <vprintfmt+0x1e7>
  800796:	89 cf                	mov    %ecx,%edi
  800798:	eb 0e                	jmp    8007a8 <vprintfmt+0x236>
				putch(' ', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	6a 20                	push   $0x20
  8007a0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007a2:	83 ef 01             	sub    $0x1,%edi
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	85 ff                	test   %edi,%edi
  8007aa:	7f ee                	jg     80079a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	e9 01 02 00 00       	jmp    8009b8 <vprintfmt+0x446>
  8007b7:	89 cf                	mov    %ecx,%edi
  8007b9:	eb ed                	jmp    8007a8 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007be:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8007c5:	e9 eb fd ff ff       	jmp    8005b5 <vprintfmt+0x43>
	if (lflag >= 2)
  8007ca:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ce:	7f 21                	jg     8007f1 <vprintfmt+0x27f>
	else if (lflag)
  8007d0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d4:	74 68                	je     80083e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007de:	89 c1                	mov    %eax,%ecx
  8007e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ef:	eb 17                	jmp    800808 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 50 04             	mov    0x4(%eax),%edx
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8d 40 08             	lea    0x8(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800808:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80080b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80080e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800811:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800814:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800818:	78 3f                	js     800859 <vprintfmt+0x2e7>
			base = 10;
  80081a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80081f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800823:	0f 84 71 01 00 00    	je     80099a <vprintfmt+0x428>
				putch('+', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	53                   	push   %ebx
  80082d:	6a 2b                	push   $0x2b
  80082f:	ff d6                	call   *%esi
  800831:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800834:	b8 0a 00 00 00       	mov    $0xa,%eax
  800839:	e9 5c 01 00 00       	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800846:	89 c1                	mov    %eax,%ecx
  800848:	c1 f9 1f             	sar    $0x1f,%ecx
  80084b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	eb af                	jmp    800808 <vprintfmt+0x296>
				putch('-', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	53                   	push   %ebx
  80085d:	6a 2d                	push   $0x2d
  80085f:	ff d6                	call   *%esi
				num = -(long long) num;
  800861:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800864:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800867:	f7 d8                	neg    %eax
  800869:	83 d2 00             	adc    $0x0,%edx
  80086c:	f7 da                	neg    %edx
  80086e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800871:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800874:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800877:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087c:	e9 19 01 00 00       	jmp    80099a <vprintfmt+0x428>
	if (lflag >= 2)
  800881:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800885:	7f 29                	jg     8008b0 <vprintfmt+0x33e>
	else if (lflag)
  800887:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80088b:	74 44                	je     8008d1 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	ba 00 00 00 00       	mov    $0x0,%edx
  800897:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ab:	e9 ea 00 00 00       	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8b 50 04             	mov    0x4(%eax),%edx
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8d 40 08             	lea    0x8(%eax),%eax
  8008c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008cc:	e9 c9 00 00 00       	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8d 40 04             	lea    0x4(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ef:	e9 a6 00 00 00       	jmp    80099a <vprintfmt+0x428>
			putch('0', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	6a 30                	push   $0x30
  8008fa:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800903:	7f 26                	jg     80092b <vprintfmt+0x3b9>
	else if (lflag)
  800905:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800909:	74 3e                	je     800949 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
  800915:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800918:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8d 40 04             	lea    0x4(%eax),%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800924:	b8 08 00 00 00       	mov    $0x8,%eax
  800929:	eb 6f                	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 50 04             	mov    0x4(%eax),%edx
  800931:	8b 00                	mov    (%eax),%eax
  800933:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800936:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8d 40 08             	lea    0x8(%eax),%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800942:	b8 08 00 00 00       	mov    $0x8,%eax
  800947:	eb 51                	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	ba 00 00 00 00       	mov    $0x0,%edx
  800953:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800956:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	8d 40 04             	lea    0x4(%eax),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800962:	b8 08 00 00 00       	mov    $0x8,%eax
  800967:	eb 31                	jmp    80099a <vprintfmt+0x428>
			putch('0', putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	53                   	push   %ebx
  80096d:	6a 30                	push   $0x30
  80096f:	ff d6                	call   *%esi
			putch('x', putdat);
  800971:	83 c4 08             	add    $0x8,%esp
  800974:	53                   	push   %ebx
  800975:	6a 78                	push   $0x78
  800977:	ff d6                	call   *%esi
			num = (unsigned long long)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	ba 00 00 00 00       	mov    $0x0,%edx
  800983:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800986:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800989:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8d 40 04             	lea    0x4(%eax),%eax
  800992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800995:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80099a:	83 ec 0c             	sub    $0xc,%esp
  80099d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8009a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8009ac:	89 da                	mov    %ebx,%edx
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	e8 a4 fa ff ff       	call   800459 <printnum>
			break;
  8009b5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bb:	83 c7 01             	add    $0x1,%edi
  8009be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c2:	83 f8 25             	cmp    $0x25,%eax
  8009c5:	0f 84 be fb ff ff    	je     800589 <vprintfmt+0x17>
			if (ch == '\0')
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	0f 84 28 01 00 00    	je     800afb <vprintfmt+0x589>
			putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	eb dc                	jmp    8009bb <vprintfmt+0x449>
	if (lflag >= 2)
  8009df:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009e3:	7f 26                	jg     800a0b <vprintfmt+0x499>
	else if (lflag)
  8009e5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009e9:	74 41                	je     800a2c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8009eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	8d 40 04             	lea    0x4(%eax),%eax
  800a01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a04:	b8 10 00 00 00       	mov    $0x10,%eax
  800a09:	eb 8f                	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8b 50 04             	mov    0x4(%eax),%edx
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8d 40 08             	lea    0x8(%eax),%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a22:	b8 10 00 00 00       	mov    $0x10,%eax
  800a27:	e9 6e ff ff ff       	jmp    80099a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	ba 00 00 00 00       	mov    $0x0,%edx
  800a36:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a39:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8d 40 04             	lea    0x4(%eax),%eax
  800a42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a45:	b8 10 00 00 00       	mov    $0x10,%eax
  800a4a:	e9 4b ff ff ff       	jmp    80099a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	74 14                	je     800a75 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a61:	8b 13                	mov    (%ebx),%edx
  800a63:	83 fa 7f             	cmp    $0x7f,%edx
  800a66:	7f 37                	jg     800a9f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a68:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a70:	e9 43 ff ff ff       	jmp    8009b8 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a7a:	bf 0d 30 80 00       	mov    $0x80300d,%edi
							putch(ch, putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	53                   	push   %ebx
  800a83:	50                   	push   %eax
  800a84:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a86:	83 c7 01             	add    $0x1,%edi
  800a89:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
  800a90:	85 c0                	test   %eax,%eax
  800a92:	75 eb                	jne    800a7f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9a:	e9 19 ff ff ff       	jmp    8009b8 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a9f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800aa1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa6:	bf 45 30 80 00       	mov    $0x803045,%edi
							putch(ch, putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	53                   	push   %ebx
  800aaf:	50                   	push   %eax
  800ab0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ab2:	83 c7 01             	add    $0x1,%edi
  800ab5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	85 c0                	test   %eax,%eax
  800abe:	75 eb                	jne    800aab <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800ac0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	e9 ed fe ff ff       	jmp    8009b8 <vprintfmt+0x446>
			putch(ch, putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	53                   	push   %ebx
  800acf:	6a 25                	push   $0x25
  800ad1:	ff d6                	call   *%esi
			break;
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	e9 dd fe ff ff       	jmp    8009b8 <vprintfmt+0x446>
			putch('%', putdat);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	53                   	push   %ebx
  800adf:	6a 25                	push   $0x25
  800ae1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae3:	83 c4 10             	add    $0x10,%esp
  800ae6:	89 f8                	mov    %edi,%eax
  800ae8:	eb 03                	jmp    800aed <vprintfmt+0x57b>
  800aea:	83 e8 01             	sub    $0x1,%eax
  800aed:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800af1:	75 f7                	jne    800aea <vprintfmt+0x578>
  800af3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800af6:	e9 bd fe ff ff       	jmp    8009b8 <vprintfmt+0x446>
}
  800afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5f                   	pop    %edi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 18             	sub    $0x18,%esp
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b12:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b16:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b20:	85 c0                	test   %eax,%eax
  800b22:	74 26                	je     800b4a <vsnprintf+0x47>
  800b24:	85 d2                	test   %edx,%edx
  800b26:	7e 22                	jle    800b4a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b28:	ff 75 14             	pushl  0x14(%ebp)
  800b2b:	ff 75 10             	pushl  0x10(%ebp)
  800b2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b31:	50                   	push   %eax
  800b32:	68 38 05 80 00       	push   $0x800538
  800b37:	e8 36 fa ff ff       	call   800572 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b45:	83 c4 10             	add    $0x10,%esp
}
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    
		return -E_INVAL;
  800b4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b4f:	eb f7                	jmp    800b48 <vsnprintf+0x45>

00800b51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b57:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b5a:	50                   	push   %eax
  800b5b:	ff 75 10             	pushl  0x10(%ebp)
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	e8 9a ff ff ff       	call   800b03 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b7a:	74 05                	je     800b81 <strlen+0x16>
		n++;
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	eb f5                	jmp    800b76 <strlen+0xb>
	return n;
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b91:	39 c2                	cmp    %eax,%edx
  800b93:	74 0d                	je     800ba2 <strnlen+0x1f>
  800b95:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b99:	74 05                	je     800ba0 <strnlen+0x1d>
		n++;
  800b9b:	83 c2 01             	add    $0x1,%edx
  800b9e:	eb f1                	jmp    800b91 <strnlen+0xe>
  800ba0:	89 d0                	mov    %edx,%eax
	return n;
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bb7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bba:	83 c2 01             	add    $0x1,%edx
  800bbd:	84 c9                	test   %cl,%cl
  800bbf:	75 f2                	jne    800bb3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 10             	sub    $0x10,%esp
  800bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bce:	53                   	push   %ebx
  800bcf:	e8 97 ff ff ff       	call   800b6b <strlen>
  800bd4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	01 d8                	add    %ebx,%eax
  800bdc:	50                   	push   %eax
  800bdd:	e8 c2 ff ff ff       	call   800ba4 <strcpy>
	return dst;
}
  800be2:	89 d8                	mov    %ebx,%eax
  800be4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	89 c6                	mov    %eax,%esi
  800bf6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	39 f2                	cmp    %esi,%edx
  800bfd:	74 11                	je     800c10 <strncpy+0x27>
		*dst++ = *src;
  800bff:	83 c2 01             	add    $0x1,%edx
  800c02:	0f b6 19             	movzbl (%ecx),%ebx
  800c05:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c08:	80 fb 01             	cmp    $0x1,%bl
  800c0b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c0e:	eb eb                	jmp    800bfb <strncpy+0x12>
	}
	return ret;
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	8b 75 08             	mov    0x8(%ebp),%esi
  800c1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1f:	8b 55 10             	mov    0x10(%ebp),%edx
  800c22:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c24:	85 d2                	test   %edx,%edx
  800c26:	74 21                	je     800c49 <strlcpy+0x35>
  800c28:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c2c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c2e:	39 c2                	cmp    %eax,%edx
  800c30:	74 14                	je     800c46 <strlcpy+0x32>
  800c32:	0f b6 19             	movzbl (%ecx),%ebx
  800c35:	84 db                	test   %bl,%bl
  800c37:	74 0b                	je     800c44 <strlcpy+0x30>
			*dst++ = *src++;
  800c39:	83 c1 01             	add    $0x1,%ecx
  800c3c:	83 c2 01             	add    $0x1,%edx
  800c3f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c42:	eb ea                	jmp    800c2e <strlcpy+0x1a>
  800c44:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c46:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c49:	29 f0                	sub    %esi,%eax
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c55:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c58:	0f b6 01             	movzbl (%ecx),%eax
  800c5b:	84 c0                	test   %al,%al
  800c5d:	74 0c                	je     800c6b <strcmp+0x1c>
  800c5f:	3a 02                	cmp    (%edx),%al
  800c61:	75 08                	jne    800c6b <strcmp+0x1c>
		p++, q++;
  800c63:	83 c1 01             	add    $0x1,%ecx
  800c66:	83 c2 01             	add    $0x1,%edx
  800c69:	eb ed                	jmp    800c58 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c6b:	0f b6 c0             	movzbl %al,%eax
  800c6e:	0f b6 12             	movzbl (%edx),%edx
  800c71:	29 d0                	sub    %edx,%eax
}
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	53                   	push   %ebx
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7f:	89 c3                	mov    %eax,%ebx
  800c81:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c84:	eb 06                	jmp    800c8c <strncmp+0x17>
		n--, p++, q++;
  800c86:	83 c0 01             	add    $0x1,%eax
  800c89:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c8c:	39 d8                	cmp    %ebx,%eax
  800c8e:	74 16                	je     800ca6 <strncmp+0x31>
  800c90:	0f b6 08             	movzbl (%eax),%ecx
  800c93:	84 c9                	test   %cl,%cl
  800c95:	74 04                	je     800c9b <strncmp+0x26>
  800c97:	3a 0a                	cmp    (%edx),%cl
  800c99:	74 eb                	je     800c86 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9b:	0f b6 00             	movzbl (%eax),%eax
  800c9e:	0f b6 12             	movzbl (%edx),%edx
  800ca1:	29 d0                	sub    %edx,%eax
}
  800ca3:	5b                   	pop    %ebx
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    
		return 0;
  800ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cab:	eb f6                	jmp    800ca3 <strncmp+0x2e>

00800cad <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb7:	0f b6 10             	movzbl (%eax),%edx
  800cba:	84 d2                	test   %dl,%dl
  800cbc:	74 09                	je     800cc7 <strchr+0x1a>
		if (*s == c)
  800cbe:	38 ca                	cmp    %cl,%dl
  800cc0:	74 0a                	je     800ccc <strchr+0x1f>
	for (; *s; s++)
  800cc2:	83 c0 01             	add    $0x1,%eax
  800cc5:	eb f0                	jmp    800cb7 <strchr+0xa>
			return (char *) s;
	return 0;
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cdb:	38 ca                	cmp    %cl,%dl
  800cdd:	74 09                	je     800ce8 <strfind+0x1a>
  800cdf:	84 d2                	test   %dl,%dl
  800ce1:	74 05                	je     800ce8 <strfind+0x1a>
	for (; *s; s++)
  800ce3:	83 c0 01             	add    $0x1,%eax
  800ce6:	eb f0                	jmp    800cd8 <strfind+0xa>
			break;
	return (char *) s;
}
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cf6:	85 c9                	test   %ecx,%ecx
  800cf8:	74 31                	je     800d2b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cfa:	89 f8                	mov    %edi,%eax
  800cfc:	09 c8                	or     %ecx,%eax
  800cfe:	a8 03                	test   $0x3,%al
  800d00:	75 23                	jne    800d25 <memset+0x3b>
		c &= 0xFF;
  800d02:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d06:	89 d3                	mov    %edx,%ebx
  800d08:	c1 e3 08             	shl    $0x8,%ebx
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	c1 e0 18             	shl    $0x18,%eax
  800d10:	89 d6                	mov    %edx,%esi
  800d12:	c1 e6 10             	shl    $0x10,%esi
  800d15:	09 f0                	or     %esi,%eax
  800d17:	09 c2                	or     %eax,%edx
  800d19:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d1b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d1e:	89 d0                	mov    %edx,%eax
  800d20:	fc                   	cld    
  800d21:	f3 ab                	rep stos %eax,%es:(%edi)
  800d23:	eb 06                	jmp    800d2b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	fc                   	cld    
  800d29:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2b:	89 f8                	mov    %edi,%eax
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d40:	39 c6                	cmp    %eax,%esi
  800d42:	73 32                	jae    800d76 <memmove+0x44>
  800d44:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	76 2b                	jbe    800d76 <memmove+0x44>
		s += n;
		d += n;
  800d4b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d4e:	89 fe                	mov    %edi,%esi
  800d50:	09 ce                	or     %ecx,%esi
  800d52:	09 d6                	or     %edx,%esi
  800d54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5a:	75 0e                	jne    800d6a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d5c:	83 ef 04             	sub    $0x4,%edi
  800d5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d65:	fd                   	std    
  800d66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d68:	eb 09                	jmp    800d73 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6a:	83 ef 01             	sub    $0x1,%edi
  800d6d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d70:	fd                   	std    
  800d71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d73:	fc                   	cld    
  800d74:	eb 1a                	jmp    800d90 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d76:	89 c2                	mov    %eax,%edx
  800d78:	09 ca                	or     %ecx,%edx
  800d7a:	09 f2                	or     %esi,%edx
  800d7c:	f6 c2 03             	test   $0x3,%dl
  800d7f:	75 0a                	jne    800d8b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d81:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d84:	89 c7                	mov    %eax,%edi
  800d86:	fc                   	cld    
  800d87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d89:	eb 05                	jmp    800d90 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d8b:	89 c7                	mov    %eax,%edi
  800d8d:	fc                   	cld    
  800d8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d9a:	ff 75 10             	pushl  0x10(%ebp)
  800d9d:	ff 75 0c             	pushl  0xc(%ebp)
  800da0:	ff 75 08             	pushl  0x8(%ebp)
  800da3:	e8 8a ff ff ff       	call   800d32 <memmove>
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	89 c6                	mov    %eax,%esi
  800db7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dba:	39 f0                	cmp    %esi,%eax
  800dbc:	74 1c                	je     800dda <memcmp+0x30>
		if (*s1 != *s2)
  800dbe:	0f b6 08             	movzbl (%eax),%ecx
  800dc1:	0f b6 1a             	movzbl (%edx),%ebx
  800dc4:	38 d9                	cmp    %bl,%cl
  800dc6:	75 08                	jne    800dd0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800dc8:	83 c0 01             	add    $0x1,%eax
  800dcb:	83 c2 01             	add    $0x1,%edx
  800dce:	eb ea                	jmp    800dba <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800dd0:	0f b6 c1             	movzbl %cl,%eax
  800dd3:	0f b6 db             	movzbl %bl,%ebx
  800dd6:	29 d8                	sub    %ebx,%eax
  800dd8:	eb 05                	jmp    800ddf <memcmp+0x35>
	}

	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dec:	89 c2                	mov    %eax,%edx
  800dee:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df1:	39 d0                	cmp    %edx,%eax
  800df3:	73 09                	jae    800dfe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df5:	38 08                	cmp    %cl,(%eax)
  800df7:	74 05                	je     800dfe <memfind+0x1b>
	for (; s < ends; s++)
  800df9:	83 c0 01             	add    $0x1,%eax
  800dfc:	eb f3                	jmp    800df1 <memfind+0xe>
			break;
	return (void *) s;
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0c:	eb 03                	jmp    800e11 <strtol+0x11>
		s++;
  800e0e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e11:	0f b6 01             	movzbl (%ecx),%eax
  800e14:	3c 20                	cmp    $0x20,%al
  800e16:	74 f6                	je     800e0e <strtol+0xe>
  800e18:	3c 09                	cmp    $0x9,%al
  800e1a:	74 f2                	je     800e0e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e1c:	3c 2b                	cmp    $0x2b,%al
  800e1e:	74 2a                	je     800e4a <strtol+0x4a>
	int neg = 0;
  800e20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e25:	3c 2d                	cmp    $0x2d,%al
  800e27:	74 2b                	je     800e54 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e29:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e2f:	75 0f                	jne    800e40 <strtol+0x40>
  800e31:	80 39 30             	cmpb   $0x30,(%ecx)
  800e34:	74 28                	je     800e5e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e36:	85 db                	test   %ebx,%ebx
  800e38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3d:	0f 44 d8             	cmove  %eax,%ebx
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
  800e45:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e48:	eb 50                	jmp    800e9a <strtol+0x9a>
		s++;
  800e4a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e4d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e52:	eb d5                	jmp    800e29 <strtol+0x29>
		s++, neg = 1;
  800e54:	83 c1 01             	add    $0x1,%ecx
  800e57:	bf 01 00 00 00       	mov    $0x1,%edi
  800e5c:	eb cb                	jmp    800e29 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e5e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e62:	74 0e                	je     800e72 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e64:	85 db                	test   %ebx,%ebx
  800e66:	75 d8                	jne    800e40 <strtol+0x40>
		s++, base = 8;
  800e68:	83 c1 01             	add    $0x1,%ecx
  800e6b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e70:	eb ce                	jmp    800e40 <strtol+0x40>
		s += 2, base = 16;
  800e72:	83 c1 02             	add    $0x2,%ecx
  800e75:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e7a:	eb c4                	jmp    800e40 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e7c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e7f:	89 f3                	mov    %esi,%ebx
  800e81:	80 fb 19             	cmp    $0x19,%bl
  800e84:	77 29                	ja     800eaf <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e86:	0f be d2             	movsbl %dl,%edx
  800e89:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e8c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e8f:	7d 30                	jge    800ec1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e91:	83 c1 01             	add    $0x1,%ecx
  800e94:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e98:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e9a:	0f b6 11             	movzbl (%ecx),%edx
  800e9d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ea0:	89 f3                	mov    %esi,%ebx
  800ea2:	80 fb 09             	cmp    $0x9,%bl
  800ea5:	77 d5                	ja     800e7c <strtol+0x7c>
			dig = *s - '0';
  800ea7:	0f be d2             	movsbl %dl,%edx
  800eaa:	83 ea 30             	sub    $0x30,%edx
  800ead:	eb dd                	jmp    800e8c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eaf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eb2:	89 f3                	mov    %esi,%ebx
  800eb4:	80 fb 19             	cmp    $0x19,%bl
  800eb7:	77 08                	ja     800ec1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800eb9:	0f be d2             	movsbl %dl,%edx
  800ebc:	83 ea 37             	sub    $0x37,%edx
  800ebf:	eb cb                	jmp    800e8c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec5:	74 05                	je     800ecc <strtol+0xcc>
		*endptr = (char *) s;
  800ec7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eca:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	f7 da                	neg    %edx
  800ed0:	85 ff                	test   %edi,%edi
  800ed2:	0f 45 c2             	cmovne %edx,%eax
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	89 c3                	mov    %eax,%ebx
  800eed:	89 c7                	mov    %eax,%edi
  800eef:	89 c6                	mov    %eax,%esi
  800ef1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efe:	ba 00 00 00 00       	mov    $0x0,%edx
  800f03:	b8 01 00 00 00       	mov    $0x1,%eax
  800f08:	89 d1                	mov    %edx,%ecx
  800f0a:	89 d3                	mov    %edx,%ebx
  800f0c:	89 d7                	mov    %edx,%edi
  800f0e:	89 d6                	mov    %edx,%esi
  800f10:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	b8 03 00 00 00       	mov    $0x3,%eax
  800f2d:	89 cb                	mov    %ecx,%ebx
  800f2f:	89 cf                	mov    %ecx,%edi
  800f31:	89 ce                	mov    %ecx,%esi
  800f33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7f 08                	jg     800f41 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	50                   	push   %eax
  800f45:	6a 03                	push   $0x3
  800f47:	68 68 32 80 00       	push   $0x803268
  800f4c:	6a 43                	push   $0x43
  800f4e:	68 85 32 80 00       	push   $0x803285
  800f53:	e8 f7 f3 ff ff       	call   80034f <_panic>

00800f58 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f63:	b8 02 00 00 00       	mov    $0x2,%eax
  800f68:	89 d1                	mov    %edx,%ecx
  800f6a:	89 d3                	mov    %edx,%ebx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	89 d6                	mov    %edx,%esi
  800f70:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <sys_yield>:

void
sys_yield(void)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 d3                	mov    %edx,%ebx
  800f8b:	89 d7                	mov    %edx,%edi
  800f8d:	89 d6                	mov    %edx,%esi
  800f8f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9f:	be 00 00 00 00       	mov    $0x0,%esi
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faa:	b8 04 00 00 00       	mov    $0x4,%eax
  800faf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb2:	89 f7                	mov    %esi,%edi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 04                	push   $0x4
  800fc8:	68 68 32 80 00       	push   $0x803268
  800fcd:	6a 43                	push   $0x43
  800fcf:	68 85 32 80 00       	push   $0x803285
  800fd4:	e8 76 f3 ff ff       	call   80034f <_panic>

00800fd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 05 00 00 00       	mov    $0x5,%eax
  800fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ff6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	7f 08                	jg     801004 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	50                   	push   %eax
  801008:	6a 05                	push   $0x5
  80100a:	68 68 32 80 00       	push   $0x803268
  80100f:	6a 43                	push   $0x43
  801011:	68 85 32 80 00       	push   $0x803285
  801016:	e8 34 f3 ff ff       	call   80034f <_panic>

0080101b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
  801021:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	8b 55 08             	mov    0x8(%ebp),%edx
  80102c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102f:	b8 06 00 00 00       	mov    $0x6,%eax
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7f 08                	jg     801046 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	50                   	push   %eax
  80104a:	6a 06                	push   $0x6
  80104c:	68 68 32 80 00       	push   $0x803268
  801051:	6a 43                	push   $0x43
  801053:	68 85 32 80 00       	push   $0x803285
  801058:	e8 f2 f2 ff ff       	call   80034f <_panic>

0080105d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
  801063:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801066:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	b8 08 00 00 00       	mov    $0x8,%eax
  801076:	89 df                	mov    %ebx,%edi
  801078:	89 de                	mov    %ebx,%esi
  80107a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	7f 08                	jg     801088 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	50                   	push   %eax
  80108c:	6a 08                	push   $0x8
  80108e:	68 68 32 80 00       	push   $0x803268
  801093:	6a 43                	push   $0x43
  801095:	68 85 32 80 00       	push   $0x803285
  80109a:	e8 b0 f2 ff ff       	call   80034f <_panic>

0080109f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	53                   	push   %ebx
  8010a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b8:	89 df                	mov    %ebx,%edi
  8010ba:	89 de                	mov    %ebx,%esi
  8010bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	7f 08                	jg     8010ca <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	50                   	push   %eax
  8010ce:	6a 09                	push   $0x9
  8010d0:	68 68 32 80 00       	push   $0x803268
  8010d5:	6a 43                	push   $0x43
  8010d7:	68 85 32 80 00       	push   $0x803285
  8010dc:	e8 6e f2 ff ff       	call   80034f <_panic>

008010e1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010fa:	89 df                	mov    %ebx,%edi
  8010fc:	89 de                	mov    %ebx,%esi
  8010fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801100:	85 c0                	test   %eax,%eax
  801102:	7f 08                	jg     80110c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801107:	5b                   	pop    %ebx
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	50                   	push   %eax
  801110:	6a 0a                	push   $0xa
  801112:	68 68 32 80 00       	push   $0x803268
  801117:	6a 43                	push   $0x43
  801119:	68 85 32 80 00       	push   $0x803285
  80111e:	e8 2c f2 ff ff       	call   80034f <_panic>

00801123 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	57                   	push   %edi
  801127:	56                   	push   %esi
  801128:	53                   	push   %ebx
	asm volatile("int %1\n"
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801134:	be 00 00 00 00       	mov    $0x0,%esi
  801139:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80113f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	57                   	push   %edi
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
  80114c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80114f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	b8 0d 00 00 00       	mov    $0xd,%eax
  80115c:	89 cb                	mov    %ecx,%ebx
  80115e:	89 cf                	mov    %ecx,%edi
  801160:	89 ce                	mov    %ecx,%esi
  801162:	cd 30                	int    $0x30
	if(check && ret > 0)
  801164:	85 c0                	test   %eax,%eax
  801166:	7f 08                	jg     801170 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801168:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5f                   	pop    %edi
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	50                   	push   %eax
  801174:	6a 0d                	push   $0xd
  801176:	68 68 32 80 00       	push   $0x803268
  80117b:	6a 43                	push   $0x43
  80117d:	68 85 32 80 00       	push   $0x803285
  801182:	e8 c8 f1 ff ff       	call   80034f <_panic>

00801187 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	57                   	push   %edi
  80118b:	56                   	push   %esi
  80118c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801192:	8b 55 08             	mov    0x8(%ebp),%edx
  801195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801198:	b8 0e 00 00 00       	mov    $0xe,%eax
  80119d:	89 df                	mov    %ebx,%edi
  80119f:	89 de                	mov    %ebx,%esi
  8011a1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011a3:	5b                   	pop    %ebx
  8011a4:	5e                   	pop    %esi
  8011a5:	5f                   	pop    %edi
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    

008011a8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	57                   	push   %edi
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b6:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011bb:	89 cb                	mov    %ecx,%ebx
  8011bd:	89 cf                	mov    %ecx,%edi
  8011bf:	89 ce                	mov    %ecx,%esi
  8011c1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8011c3:	5b                   	pop    %ebx
  8011c4:	5e                   	pop    %esi
  8011c5:	5f                   	pop    %edi
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	57                   	push   %edi
  8011cc:	56                   	push   %esi
  8011cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d3:	b8 10 00 00 00       	mov    $0x10,%eax
  8011d8:	89 d1                	mov    %edx,%ecx
  8011da:	89 d3                	mov    %edx,%ebx
  8011dc:	89 d7                	mov    %edx,%edi
  8011de:	89 d6                	mov    %edx,%esi
  8011e0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011e2:	5b                   	pop    %ebx
  8011e3:	5e                   	pop    %esi
  8011e4:	5f                   	pop    %edi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    

008011e7 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	57                   	push   %edi
  8011eb:	56                   	push   %esi
  8011ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f8:	b8 11 00 00 00       	mov    $0x11,%eax
  8011fd:	89 df                	mov    %ebx,%edi
  8011ff:	89 de                	mov    %ebx,%esi
  801201:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801203:	5b                   	pop    %ebx
  801204:	5e                   	pop    %esi
  801205:	5f                   	pop    %edi
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	57                   	push   %edi
  80120c:	56                   	push   %esi
  80120d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801219:	b8 12 00 00 00       	mov    $0x12,%eax
  80121e:	89 df                	mov    %ebx,%edi
  801220:	89 de                	mov    %ebx,%esi
  801222:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
  80122f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801232:	bb 00 00 00 00       	mov    $0x0,%ebx
  801237:	8b 55 08             	mov    0x8(%ebp),%edx
  80123a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123d:	b8 13 00 00 00       	mov    $0x13,%eax
  801242:	89 df                	mov    %ebx,%edi
  801244:	89 de                	mov    %ebx,%esi
  801246:	cd 30                	int    $0x30
	if(check && ret > 0)
  801248:	85 c0                	test   %eax,%eax
  80124a:	7f 08                	jg     801254 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	50                   	push   %eax
  801258:	6a 13                	push   $0x13
  80125a:	68 68 32 80 00       	push   $0x803268
  80125f:	6a 43                	push   $0x43
  801261:	68 85 32 80 00       	push   $0x803285
  801266:	e8 e4 f0 ff ff       	call   80034f <_panic>

0080126b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	57                   	push   %edi
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
	asm volatile("int %1\n"
  801271:	b9 00 00 00 00       	mov    $0x0,%ecx
  801276:	8b 55 08             	mov    0x8(%ebp),%edx
  801279:	b8 14 00 00 00       	mov    $0x14,%eax
  80127e:	89 cb                	mov    %ecx,%ebx
  801280:	89 cf                	mov    %ecx,%edi
  801282:	89 ce                	mov    %ecx,%esi
  801284:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801286:	5b                   	pop    %ebx
  801287:	5e                   	pop    %esi
  801288:	5f                   	pop    %edi
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	53                   	push   %ebx
  80128f:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801292:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801299:	f6 c5 04             	test   $0x4,%ch
  80129c:	75 45                	jne    8012e3 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80129e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012a5:	83 e1 07             	and    $0x7,%ecx
  8012a8:	83 f9 07             	cmp    $0x7,%ecx
  8012ab:	74 6f                	je     80131c <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012ad:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012b4:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8012ba:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8012c0:	0f 84 b6 00 00 00    	je     80137c <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012c6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012cd:	83 e1 05             	and    $0x5,%ecx
  8012d0:	83 f9 05             	cmp    $0x5,%ecx
  8012d3:	0f 84 d7 00 00 00    	je     8013b0 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012e3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ea:	c1 e2 0c             	shl    $0xc,%edx
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012f6:	51                   	push   %ecx
  8012f7:	52                   	push   %edx
  8012f8:	50                   	push   %eax
  8012f9:	52                   	push   %edx
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 d8 fc ff ff       	call   800fd9 <sys_page_map>
		if(r < 0)
  801301:	83 c4 20             	add    $0x20,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	79 d1                	jns    8012d9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	68 93 32 80 00       	push   $0x803293
  801310:	6a 54                	push   $0x54
  801312:	68 a9 32 80 00       	push   $0x8032a9
  801317:	e8 33 f0 ff ff       	call   80034f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80131c:	89 d3                	mov    %edx,%ebx
  80131e:	c1 e3 0c             	shl    $0xc,%ebx
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	68 05 08 00 00       	push   $0x805
  801329:	53                   	push   %ebx
  80132a:	50                   	push   %eax
  80132b:	53                   	push   %ebx
  80132c:	6a 00                	push   $0x0
  80132e:	e8 a6 fc ff ff       	call   800fd9 <sys_page_map>
		if(r < 0)
  801333:	83 c4 20             	add    $0x20,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 2e                	js     801368 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	68 05 08 00 00       	push   $0x805
  801342:	53                   	push   %ebx
  801343:	6a 00                	push   $0x0
  801345:	53                   	push   %ebx
  801346:	6a 00                	push   $0x0
  801348:	e8 8c fc ff ff       	call   800fd9 <sys_page_map>
		if(r < 0)
  80134d:	83 c4 20             	add    $0x20,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	79 85                	jns    8012d9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	68 93 32 80 00       	push   $0x803293
  80135c:	6a 5f                	push   $0x5f
  80135e:	68 a9 32 80 00       	push   $0x8032a9
  801363:	e8 e7 ef ff ff       	call   80034f <_panic>
			panic("sys_page_map() panic\n");
  801368:	83 ec 04             	sub    $0x4,%esp
  80136b:	68 93 32 80 00       	push   $0x803293
  801370:	6a 5b                	push   $0x5b
  801372:	68 a9 32 80 00       	push   $0x8032a9
  801377:	e8 d3 ef ff ff       	call   80034f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80137c:	c1 e2 0c             	shl    $0xc,%edx
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	68 05 08 00 00       	push   $0x805
  801387:	52                   	push   %edx
  801388:	50                   	push   %eax
  801389:	52                   	push   %edx
  80138a:	6a 00                	push   $0x0
  80138c:	e8 48 fc ff ff       	call   800fd9 <sys_page_map>
		if(r < 0)
  801391:	83 c4 20             	add    $0x20,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	0f 89 3d ff ff ff    	jns    8012d9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	68 93 32 80 00       	push   $0x803293
  8013a4:	6a 66                	push   $0x66
  8013a6:	68 a9 32 80 00       	push   $0x8032a9
  8013ab:	e8 9f ef ff ff       	call   80034f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013b0:	c1 e2 0c             	shl    $0xc,%edx
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	6a 05                	push   $0x5
  8013b8:	52                   	push   %edx
  8013b9:	50                   	push   %eax
  8013ba:	52                   	push   %edx
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 17 fc ff ff       	call   800fd9 <sys_page_map>
		if(r < 0)
  8013c2:	83 c4 20             	add    $0x20,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	0f 89 0c ff ff ff    	jns    8012d9 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	68 93 32 80 00       	push   $0x803293
  8013d5:	6a 6d                	push   $0x6d
  8013d7:	68 a9 32 80 00       	push   $0x8032a9
  8013dc:	e8 6e ef ff ff       	call   80034f <_panic>

008013e1 <pgfault>:
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8013eb:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013ed:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8013f1:	0f 84 99 00 00 00    	je     801490 <pgfault+0xaf>
  8013f7:	89 c2                	mov    %eax,%edx
  8013f9:	c1 ea 16             	shr    $0x16,%edx
  8013fc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801403:	f6 c2 01             	test   $0x1,%dl
  801406:	0f 84 84 00 00 00    	je     801490 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80140c:	89 c2                	mov    %eax,%edx
  80140e:	c1 ea 0c             	shr    $0xc,%edx
  801411:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801418:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80141e:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801424:	75 6a                	jne    801490 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801426:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	6a 07                	push   $0x7
  801432:	68 00 f0 7f 00       	push   $0x7ff000
  801437:	6a 00                	push   $0x0
  801439:	e8 58 fb ff ff       	call   800f96 <sys_page_alloc>
	if(ret < 0)
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 5f                	js     8014a4 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 00 10 00 00       	push   $0x1000
  80144d:	53                   	push   %ebx
  80144e:	68 00 f0 7f 00       	push   $0x7ff000
  801453:	e8 3c f9 ff ff       	call   800d94 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801458:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80145f:	53                   	push   %ebx
  801460:	6a 00                	push   $0x0
  801462:	68 00 f0 7f 00       	push   $0x7ff000
  801467:	6a 00                	push   $0x0
  801469:	e8 6b fb ff ff       	call   800fd9 <sys_page_map>
	if(ret < 0)
  80146e:	83 c4 20             	add    $0x20,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 43                	js     8014b8 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	68 00 f0 7f 00       	push   $0x7ff000
  80147d:	6a 00                	push   $0x0
  80147f:	e8 97 fb ff ff       	call   80101b <sys_page_unmap>
	if(ret < 0)
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 41                	js     8014cc <pgfault+0xeb>
}
  80148b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    
		panic("panic at pgfault()\n");
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	68 b4 32 80 00       	push   $0x8032b4
  801498:	6a 26                	push   $0x26
  80149a:	68 a9 32 80 00       	push   $0x8032a9
  80149f:	e8 ab ee ff ff       	call   80034f <_panic>
		panic("panic in sys_page_alloc()\n");
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	68 c8 32 80 00       	push   $0x8032c8
  8014ac:	6a 31                	push   $0x31
  8014ae:	68 a9 32 80 00       	push   $0x8032a9
  8014b3:	e8 97 ee ff ff       	call   80034f <_panic>
		panic("panic in sys_page_map()\n");
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	68 e3 32 80 00       	push   $0x8032e3
  8014c0:	6a 36                	push   $0x36
  8014c2:	68 a9 32 80 00       	push   $0x8032a9
  8014c7:	e8 83 ee ff ff       	call   80034f <_panic>
		panic("panic in sys_page_unmap()\n");
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	68 fc 32 80 00       	push   $0x8032fc
  8014d4:	6a 39                	push   $0x39
  8014d6:	68 a9 32 80 00       	push   $0x8032a9
  8014db:	e8 6f ee ff ff       	call   80034f <_panic>

008014e0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	57                   	push   %edi
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8014e9:	68 e1 13 80 00       	push   $0x8013e1
  8014ee:	e8 2d 14 00 00       	call   802920 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8014f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8014f8:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	78 2a                	js     80152b <fork+0x4b>
  801501:	89 c6                	mov    %eax,%esi
  801503:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801505:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80150a:	75 4b                	jne    801557 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80150c:	e8 47 fa ff ff       	call   800f58 <sys_getenvid>
  801511:	25 ff 03 00 00       	and    $0x3ff,%eax
  801516:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80151c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801521:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801526:	e9 90 00 00 00       	jmp    8015bb <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	68 18 33 80 00       	push   $0x803318
  801533:	68 8c 00 00 00       	push   $0x8c
  801538:	68 a9 32 80 00       	push   $0x8032a9
  80153d:	e8 0d ee ff ff       	call   80034f <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801542:	89 f8                	mov    %edi,%eax
  801544:	e8 42 fd ff ff       	call   80128b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801549:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80154f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801555:	74 26                	je     80157d <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801557:	89 d8                	mov    %ebx,%eax
  801559:	c1 e8 16             	shr    $0x16,%eax
  80155c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801563:	a8 01                	test   $0x1,%al
  801565:	74 e2                	je     801549 <fork+0x69>
  801567:	89 da                	mov    %ebx,%edx
  801569:	c1 ea 0c             	shr    $0xc,%edx
  80156c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801573:	83 e0 05             	and    $0x5,%eax
  801576:	83 f8 05             	cmp    $0x5,%eax
  801579:	75 ce                	jne    801549 <fork+0x69>
  80157b:	eb c5                	jmp    801542 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	6a 07                	push   $0x7
  801582:	68 00 f0 bf ee       	push   $0xeebff000
  801587:	56                   	push   %esi
  801588:	e8 09 fa ff ff       	call   800f96 <sys_page_alloc>
	if(ret < 0)
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 31                	js     8015c5 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	68 8f 29 80 00       	push   $0x80298f
  80159c:	56                   	push   %esi
  80159d:	e8 3f fb ff ff       	call   8010e1 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 33                	js     8015dc <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015a9:	83 ec 08             	sub    $0x8,%esp
  8015ac:	6a 02                	push   $0x2
  8015ae:	56                   	push   %esi
  8015af:	e8 a9 fa ff ff       	call   80105d <sys_env_set_status>
	if(ret < 0)
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 38                	js     8015f3 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8015bb:	89 f0                	mov    %esi,%eax
  8015bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	5f                   	pop    %edi
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	68 c8 32 80 00       	push   $0x8032c8
  8015cd:	68 98 00 00 00       	push   $0x98
  8015d2:	68 a9 32 80 00       	push   $0x8032a9
  8015d7:	e8 73 ed ff ff       	call   80034f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	68 3c 33 80 00       	push   $0x80333c
  8015e4:	68 9b 00 00 00       	push   $0x9b
  8015e9:	68 a9 32 80 00       	push   $0x8032a9
  8015ee:	e8 5c ed ff ff       	call   80034f <_panic>
		panic("panic in sys_env_set_status()\n");
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	68 64 33 80 00       	push   $0x803364
  8015fb:	68 9e 00 00 00       	push   $0x9e
  801600:	68 a9 32 80 00       	push   $0x8032a9
  801605:	e8 45 ed ff ff       	call   80034f <_panic>

0080160a <sfork>:

// Challenge!
int
sfork(void)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	57                   	push   %edi
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
  801610:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801613:	68 e1 13 80 00       	push   $0x8013e1
  801618:	e8 03 13 00 00       	call   802920 <set_pgfault_handler>
  80161d:	b8 07 00 00 00       	mov    $0x7,%eax
  801622:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	85 c0                	test   %eax,%eax
  801629:	78 2a                	js     801655 <sfork+0x4b>
  80162b:	89 c7                	mov    %eax,%edi
  80162d:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80162f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801634:	75 58                	jne    80168e <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801636:	e8 1d f9 ff ff       	call   800f58 <sys_getenvid>
  80163b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801640:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801646:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80164b:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801650:	e9 d4 00 00 00       	jmp    801729 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801655:	83 ec 04             	sub    $0x4,%esp
  801658:	68 18 33 80 00       	push   $0x803318
  80165d:	68 af 00 00 00       	push   $0xaf
  801662:	68 a9 32 80 00       	push   $0x8032a9
  801667:	e8 e3 ec ff ff       	call   80034f <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80166c:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801671:	89 f0                	mov    %esi,%eax
  801673:	e8 13 fc ff ff       	call   80128b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801678:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80167e:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801684:	77 65                	ja     8016eb <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801686:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80168c:	74 de                	je     80166c <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80168e:	89 d8                	mov    %ebx,%eax
  801690:	c1 e8 16             	shr    $0x16,%eax
  801693:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80169a:	a8 01                	test   $0x1,%al
  80169c:	74 da                	je     801678 <sfork+0x6e>
  80169e:	89 da                	mov    %ebx,%edx
  8016a0:	c1 ea 0c             	shr    $0xc,%edx
  8016a3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016aa:	83 e0 05             	and    $0x5,%eax
  8016ad:	83 f8 05             	cmp    $0x5,%eax
  8016b0:	75 c6                	jne    801678 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8016b2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8016b9:	c1 e2 0c             	shl    $0xc,%edx
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	83 e0 07             	and    $0x7,%eax
  8016c2:	50                   	push   %eax
  8016c3:	52                   	push   %edx
  8016c4:	56                   	push   %esi
  8016c5:	52                   	push   %edx
  8016c6:	6a 00                	push   $0x0
  8016c8:	e8 0c f9 ff ff       	call   800fd9 <sys_page_map>
  8016cd:	83 c4 20             	add    $0x20,%esp
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	74 a4                	je     801678 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	68 93 32 80 00       	push   $0x803293
  8016dc:	68 ba 00 00 00       	push   $0xba
  8016e1:	68 a9 32 80 00       	push   $0x8032a9
  8016e6:	e8 64 ec ff ff       	call   80034f <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	6a 07                	push   $0x7
  8016f0:	68 00 f0 bf ee       	push   $0xeebff000
  8016f5:	57                   	push   %edi
  8016f6:	e8 9b f8 ff ff       	call   800f96 <sys_page_alloc>
	if(ret < 0)
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 31                	js     801733 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	68 8f 29 80 00       	push   $0x80298f
  80170a:	57                   	push   %edi
  80170b:	e8 d1 f9 ff ff       	call   8010e1 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	78 33                	js     80174a <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	6a 02                	push   $0x2
  80171c:	57                   	push   %edi
  80171d:	e8 3b f9 ff ff       	call   80105d <sys_env_set_status>
	if(ret < 0)
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	78 38                	js     801761 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801729:	89 f8                	mov    %edi,%eax
  80172b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172e:	5b                   	pop    %ebx
  80172f:	5e                   	pop    %esi
  801730:	5f                   	pop    %edi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 c8 32 80 00       	push   $0x8032c8
  80173b:	68 c0 00 00 00       	push   $0xc0
  801740:	68 a9 32 80 00       	push   $0x8032a9
  801745:	e8 05 ec ff ff       	call   80034f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	68 3c 33 80 00       	push   $0x80333c
  801752:	68 c3 00 00 00       	push   $0xc3
  801757:	68 a9 32 80 00       	push   $0x8032a9
  80175c:	e8 ee eb ff ff       	call   80034f <_panic>
		panic("panic in sys_env_set_status()\n");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 64 33 80 00       	push   $0x803364
  801769:	68 c6 00 00 00       	push   $0xc6
  80176e:	68 a9 32 80 00       	push   $0x8032a9
  801773:	e8 d7 eb ff ff       	call   80034f <_panic>

00801778 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	05 00 00 00 30       	add    $0x30000000,%eax
  801783:	c1 e8 0c             	shr    $0xc,%eax
}
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801793:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801798:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    

0080179f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017a7:	89 c2                	mov    %eax,%edx
  8017a9:	c1 ea 16             	shr    $0x16,%edx
  8017ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017b3:	f6 c2 01             	test   $0x1,%dl
  8017b6:	74 2d                	je     8017e5 <fd_alloc+0x46>
  8017b8:	89 c2                	mov    %eax,%edx
  8017ba:	c1 ea 0c             	shr    $0xc,%edx
  8017bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c4:	f6 c2 01             	test   $0x1,%dl
  8017c7:	74 1c                	je     8017e5 <fd_alloc+0x46>
  8017c9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017ce:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017d3:	75 d2                	jne    8017a7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017de:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017e3:	eb 0a                	jmp    8017ef <fd_alloc+0x50>
			*fd_store = fd;
  8017e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    

008017f1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017f7:	83 f8 1f             	cmp    $0x1f,%eax
  8017fa:	77 30                	ja     80182c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017fc:	c1 e0 0c             	shl    $0xc,%eax
  8017ff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801804:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80180a:	f6 c2 01             	test   $0x1,%dl
  80180d:	74 24                	je     801833 <fd_lookup+0x42>
  80180f:	89 c2                	mov    %eax,%edx
  801811:	c1 ea 0c             	shr    $0xc,%edx
  801814:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80181b:	f6 c2 01             	test   $0x1,%dl
  80181e:	74 1a                	je     80183a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	89 02                	mov    %eax,(%edx)
	return 0;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    
		return -E_INVAL;
  80182c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801831:	eb f7                	jmp    80182a <fd_lookup+0x39>
		return -E_INVAL;
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801838:	eb f0                	jmp    80182a <fd_lookup+0x39>
  80183a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183f:	eb e9                	jmp    80182a <fd_lookup+0x39>

00801841 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801854:	39 08                	cmp    %ecx,(%eax)
  801856:	74 38                	je     801890 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801858:	83 c2 01             	add    $0x1,%edx
  80185b:	8b 04 95 00 34 80 00 	mov    0x803400(,%edx,4),%eax
  801862:	85 c0                	test   %eax,%eax
  801864:	75 ee                	jne    801854 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801866:	a1 08 50 80 00       	mov    0x805008,%eax
  80186b:	8b 40 48             	mov    0x48(%eax),%eax
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	51                   	push   %ecx
  801872:	50                   	push   %eax
  801873:	68 84 33 80 00       	push   $0x803384
  801878:	e8 c8 eb ff ff       	call   800445 <cprintf>
	*dev = 0;
  80187d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    
			*dev = devtab[i];
  801890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801893:	89 01                	mov    %eax,(%ecx)
			return 0;
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
  80189a:	eb f2                	jmp    80188e <dev_lookup+0x4d>

0080189c <fd_close>:
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	57                   	push   %edi
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 24             	sub    $0x24,%esp
  8018a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8018a8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018af:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018b5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018b8:	50                   	push   %eax
  8018b9:	e8 33 ff ff ff       	call   8017f1 <fd_lookup>
  8018be:	89 c3                	mov    %eax,%ebx
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 05                	js     8018cc <fd_close+0x30>
	    || fd != fd2)
  8018c7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018ca:	74 16                	je     8018e2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018cc:	89 f8                	mov    %edi,%eax
  8018ce:	84 c0                	test   %al,%al
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5f                   	pop    %edi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018e8:	50                   	push   %eax
  8018e9:	ff 36                	pushl  (%esi)
  8018eb:	e8 51 ff ff ff       	call   801841 <dev_lookup>
  8018f0:	89 c3                	mov    %eax,%ebx
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 1a                	js     801913 <fd_close+0x77>
		if (dev->dev_close)
  8018f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801904:	85 c0                	test   %eax,%eax
  801906:	74 0b                	je     801913 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	56                   	push   %esi
  80190c:	ff d0                	call   *%eax
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801913:	83 ec 08             	sub    $0x8,%esp
  801916:	56                   	push   %esi
  801917:	6a 00                	push   $0x0
  801919:	e8 fd f6 ff ff       	call   80101b <sys_page_unmap>
	return r;
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	eb b5                	jmp    8018d8 <fd_close+0x3c>

00801923 <close>:

int
close(int fdnum)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801929:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192c:	50                   	push   %eax
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	e8 bc fe ff ff       	call   8017f1 <fd_lookup>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	79 02                	jns    80193e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    
		return fd_close(fd, 1);
  80193e:	83 ec 08             	sub    $0x8,%esp
  801941:	6a 01                	push   $0x1
  801943:	ff 75 f4             	pushl  -0xc(%ebp)
  801946:	e8 51 ff ff ff       	call   80189c <fd_close>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	eb ec                	jmp    80193c <close+0x19>

00801950 <close_all>:

void
close_all(void)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	53                   	push   %ebx
  801954:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801957:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	53                   	push   %ebx
  801960:	e8 be ff ff ff       	call   801923 <close>
	for (i = 0; i < MAXFD; i++)
  801965:	83 c3 01             	add    $0x1,%ebx
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	83 fb 20             	cmp    $0x20,%ebx
  80196e:	75 ec                	jne    80195c <close_all+0xc>
}
  801970:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	57                   	push   %edi
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80197e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801981:	50                   	push   %eax
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	e8 67 fe ff ff       	call   8017f1 <fd_lookup>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	0f 88 81 00 00 00    	js     801a18 <dup+0xa3>
		return r;
	close(newfdnum);
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	e8 81 ff ff ff       	call   801923 <close>

	newfd = INDEX2FD(newfdnum);
  8019a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019a5:	c1 e6 0c             	shl    $0xc,%esi
  8019a8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019ae:	83 c4 04             	add    $0x4,%esp
  8019b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019b4:	e8 cf fd ff ff       	call   801788 <fd2data>
  8019b9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019bb:	89 34 24             	mov    %esi,(%esp)
  8019be:	e8 c5 fd ff ff       	call   801788 <fd2data>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019c8:	89 d8                	mov    %ebx,%eax
  8019ca:	c1 e8 16             	shr    $0x16,%eax
  8019cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019d4:	a8 01                	test   $0x1,%al
  8019d6:	74 11                	je     8019e9 <dup+0x74>
  8019d8:	89 d8                	mov    %ebx,%eax
  8019da:	c1 e8 0c             	shr    $0xc,%eax
  8019dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019e4:	f6 c2 01             	test   $0x1,%dl
  8019e7:	75 39                	jne    801a22 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019ec:	89 d0                	mov    %edx,%eax
  8019ee:	c1 e8 0c             	shr    $0xc,%eax
  8019f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019f8:	83 ec 0c             	sub    $0xc,%esp
  8019fb:	25 07 0e 00 00       	and    $0xe07,%eax
  801a00:	50                   	push   %eax
  801a01:	56                   	push   %esi
  801a02:	6a 00                	push   $0x0
  801a04:	52                   	push   %edx
  801a05:	6a 00                	push   $0x0
  801a07:	e8 cd f5 ff ff       	call   800fd9 <sys_page_map>
  801a0c:	89 c3                	mov    %eax,%ebx
  801a0e:	83 c4 20             	add    $0x20,%esp
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 31                	js     801a46 <dup+0xd1>
		goto err;

	return newfdnum;
  801a15:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a18:	89 d8                	mov    %ebx,%eax
  801a1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5f                   	pop    %edi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a22:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	25 07 0e 00 00       	and    $0xe07,%eax
  801a31:	50                   	push   %eax
  801a32:	57                   	push   %edi
  801a33:	6a 00                	push   $0x0
  801a35:	53                   	push   %ebx
  801a36:	6a 00                	push   $0x0
  801a38:	e8 9c f5 ff ff       	call   800fd9 <sys_page_map>
  801a3d:	89 c3                	mov    %eax,%ebx
  801a3f:	83 c4 20             	add    $0x20,%esp
  801a42:	85 c0                	test   %eax,%eax
  801a44:	79 a3                	jns    8019e9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	56                   	push   %esi
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 ca f5 ff ff       	call   80101b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a51:	83 c4 08             	add    $0x8,%esp
  801a54:	57                   	push   %edi
  801a55:	6a 00                	push   $0x0
  801a57:	e8 bf f5 ff ff       	call   80101b <sys_page_unmap>
	return r;
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	eb b7                	jmp    801a18 <dup+0xa3>

00801a61 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	53                   	push   %ebx
  801a65:	83 ec 1c             	sub    $0x1c,%esp
  801a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a6e:	50                   	push   %eax
  801a6f:	53                   	push   %ebx
  801a70:	e8 7c fd ff ff       	call   8017f1 <fd_lookup>
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 3f                	js     801abb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a82:	50                   	push   %eax
  801a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a86:	ff 30                	pushl  (%eax)
  801a88:	e8 b4 fd ff ff       	call   801841 <dev_lookup>
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 27                	js     801abb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a97:	8b 42 08             	mov    0x8(%edx),%eax
  801a9a:	83 e0 03             	and    $0x3,%eax
  801a9d:	83 f8 01             	cmp    $0x1,%eax
  801aa0:	74 1e                	je     801ac0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa5:	8b 40 08             	mov    0x8(%eax),%eax
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	74 35                	je     801ae1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	52                   	push   %edx
  801ab6:	ff d0                	call   *%eax
  801ab8:	83 c4 10             	add    $0x10,%esp
}
  801abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ac0:	a1 08 50 80 00       	mov    0x805008,%eax
  801ac5:	8b 40 48             	mov    0x48(%eax),%eax
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	53                   	push   %ebx
  801acc:	50                   	push   %eax
  801acd:	68 c5 33 80 00       	push   $0x8033c5
  801ad2:	e8 6e e9 ff ff       	call   800445 <cprintf>
		return -E_INVAL;
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801adf:	eb da                	jmp    801abb <read+0x5a>
		return -E_NOT_SUPP;
  801ae1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae6:	eb d3                	jmp    801abb <read+0x5a>

00801ae8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	57                   	push   %edi
  801aec:	56                   	push   %esi
  801aed:	53                   	push   %ebx
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801af7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801afc:	39 f3                	cmp    %esi,%ebx
  801afe:	73 23                	jae    801b23 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	89 f0                	mov    %esi,%eax
  801b05:	29 d8                	sub    %ebx,%eax
  801b07:	50                   	push   %eax
  801b08:	89 d8                	mov    %ebx,%eax
  801b0a:	03 45 0c             	add    0xc(%ebp),%eax
  801b0d:	50                   	push   %eax
  801b0e:	57                   	push   %edi
  801b0f:	e8 4d ff ff ff       	call   801a61 <read>
		if (m < 0)
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 06                	js     801b21 <readn+0x39>
			return m;
		if (m == 0)
  801b1b:	74 06                	je     801b23 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b1d:	01 c3                	add    %eax,%ebx
  801b1f:	eb db                	jmp    801afc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b21:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b23:	89 d8                	mov    %ebx,%eax
  801b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b28:	5b                   	pop    %ebx
  801b29:	5e                   	pop    %esi
  801b2a:	5f                   	pop    %edi
  801b2b:	5d                   	pop    %ebp
  801b2c:	c3                   	ret    

00801b2d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	53                   	push   %ebx
  801b31:	83 ec 1c             	sub    $0x1c,%esp
  801b34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	53                   	push   %ebx
  801b3c:	e8 b0 fc ff ff       	call   8017f1 <fd_lookup>
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 3a                	js     801b82 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4e:	50                   	push   %eax
  801b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b52:	ff 30                	pushl  (%eax)
  801b54:	e8 e8 fc ff ff       	call   801841 <dev_lookup>
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 22                	js     801b82 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b67:	74 1e                	je     801b87 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b6f:	85 d2                	test   %edx,%edx
  801b71:	74 35                	je     801ba8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	ff 75 10             	pushl  0x10(%ebp)
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	50                   	push   %eax
  801b7d:	ff d2                	call   *%edx
  801b7f:	83 c4 10             	add    $0x10,%esp
}
  801b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b87:	a1 08 50 80 00       	mov    0x805008,%eax
  801b8c:	8b 40 48             	mov    0x48(%eax),%eax
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	53                   	push   %ebx
  801b93:	50                   	push   %eax
  801b94:	68 e1 33 80 00       	push   $0x8033e1
  801b99:	e8 a7 e8 ff ff       	call   800445 <cprintf>
		return -E_INVAL;
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba6:	eb da                	jmp    801b82 <write+0x55>
		return -E_NOT_SUPP;
  801ba8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bad:	eb d3                	jmp    801b82 <write+0x55>

00801baf <seek>:

int
seek(int fdnum, off_t offset)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb8:	50                   	push   %eax
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	e8 30 fc ff ff       	call   8017f1 <fd_lookup>
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 0e                	js     801bd6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bce:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	53                   	push   %ebx
  801bdc:	83 ec 1c             	sub    $0x1c,%esp
  801bdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be5:	50                   	push   %eax
  801be6:	53                   	push   %ebx
  801be7:	e8 05 fc ff ff       	call   8017f1 <fd_lookup>
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 37                	js     801c2a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf3:	83 ec 08             	sub    $0x8,%esp
  801bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf9:	50                   	push   %eax
  801bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfd:	ff 30                	pushl  (%eax)
  801bff:	e8 3d fc ff ff       	call   801841 <dev_lookup>
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 1f                	js     801c2a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c12:	74 1b                	je     801c2f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c17:	8b 52 18             	mov    0x18(%edx),%edx
  801c1a:	85 d2                	test   %edx,%edx
  801c1c:	74 32                	je     801c50 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c1e:	83 ec 08             	sub    $0x8,%esp
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	50                   	push   %eax
  801c25:	ff d2                	call   *%edx
  801c27:	83 c4 10             	add    $0x10,%esp
}
  801c2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c2f:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c34:	8b 40 48             	mov    0x48(%eax),%eax
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	53                   	push   %ebx
  801c3b:	50                   	push   %eax
  801c3c:	68 a4 33 80 00       	push   $0x8033a4
  801c41:	e8 ff e7 ff ff       	call   800445 <cprintf>
		return -E_INVAL;
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c4e:	eb da                	jmp    801c2a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c50:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c55:	eb d3                	jmp    801c2a <ftruncate+0x52>

00801c57 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	53                   	push   %ebx
  801c5b:	83 ec 1c             	sub    $0x1c,%esp
  801c5e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c64:	50                   	push   %eax
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	e8 84 fb ff ff       	call   8017f1 <fd_lookup>
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	85 c0                	test   %eax,%eax
  801c72:	78 4b                	js     801cbf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c74:	83 ec 08             	sub    $0x8,%esp
  801c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7a:	50                   	push   %eax
  801c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7e:	ff 30                	pushl  (%eax)
  801c80:	e8 bc fb ff ff       	call   801841 <dev_lookup>
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	78 33                	js     801cbf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c93:	74 2f                	je     801cc4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c95:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c98:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c9f:	00 00 00 
	stat->st_isdir = 0;
  801ca2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ca9:	00 00 00 
	stat->st_dev = dev;
  801cac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cb2:	83 ec 08             	sub    $0x8,%esp
  801cb5:	53                   	push   %ebx
  801cb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb9:	ff 50 14             	call   *0x14(%eax)
  801cbc:	83 c4 10             	add    $0x10,%esp
}
  801cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    
		return -E_NOT_SUPP;
  801cc4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cc9:	eb f4                	jmp    801cbf <fstat+0x68>

00801ccb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	e8 22 02 00 00       	call   801eff <open>
  801cdd:	89 c3                	mov    %eax,%ebx
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 1b                	js     801d01 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	50                   	push   %eax
  801ced:	e8 65 ff ff ff       	call   801c57 <fstat>
  801cf2:	89 c6                	mov    %eax,%esi
	close(fd);
  801cf4:	89 1c 24             	mov    %ebx,(%esp)
  801cf7:	e8 27 fc ff ff       	call   801923 <close>
	return r;
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	89 f3                	mov    %esi,%ebx
}
  801d01:	89 d8                	mov    %ebx,%eax
  801d03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	56                   	push   %esi
  801d0e:	53                   	push   %ebx
  801d0f:	89 c6                	mov    %eax,%esi
  801d11:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d13:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d1a:	74 27                	je     801d43 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d1c:	6a 07                	push   $0x7
  801d1e:	68 00 60 80 00       	push   $0x806000
  801d23:	56                   	push   %esi
  801d24:	ff 35 00 50 80 00    	pushl  0x805000
  801d2a:	e8 ef 0c 00 00       	call   802a1e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d2f:	83 c4 0c             	add    $0xc,%esp
  801d32:	6a 00                	push   $0x0
  801d34:	53                   	push   %ebx
  801d35:	6a 00                	push   $0x0
  801d37:	e8 79 0c 00 00       	call   8029b5 <ipc_recv>
}
  801d3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5e                   	pop    %esi
  801d41:	5d                   	pop    %ebp
  801d42:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	6a 01                	push   $0x1
  801d48:	e8 29 0d 00 00       	call   802a76 <ipc_find_env>
  801d4d:	a3 00 50 80 00       	mov    %eax,0x805000
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	eb c5                	jmp    801d1c <fsipc+0x12>

00801d57 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	8b 40 0c             	mov    0xc(%eax),%eax
  801d63:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	b8 02 00 00 00       	mov    $0x2,%eax
  801d7a:	e8 8b ff ff ff       	call   801d0a <fsipc>
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <devfile_flush>:
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d92:	ba 00 00 00 00       	mov    $0x0,%edx
  801d97:	b8 06 00 00 00       	mov    $0x6,%eax
  801d9c:	e8 69 ff ff ff       	call   801d0a <fsipc>
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <devfile_stat>:
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	53                   	push   %ebx
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	8b 40 0c             	mov    0xc(%eax),%eax
  801db3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801db8:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbd:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc2:	e8 43 ff ff ff       	call   801d0a <fsipc>
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	78 2c                	js     801df7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dcb:	83 ec 08             	sub    $0x8,%esp
  801dce:	68 00 60 80 00       	push   $0x806000
  801dd3:	53                   	push   %ebx
  801dd4:	e8 cb ed ff ff       	call   800ba4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dd9:	a1 80 60 80 00       	mov    0x806080,%eax
  801dde:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801de4:	a1 84 60 80 00       	mov    0x806084,%eax
  801de9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801def:	83 c4 10             	add    $0x10,%esp
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <devfile_write>:
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	53                   	push   %ebx
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e11:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e17:	53                   	push   %ebx
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	68 08 60 80 00       	push   $0x806008
  801e20:	e8 6f ef ff ff       	call   800d94 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e25:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2a:	b8 04 00 00 00       	mov    $0x4,%eax
  801e2f:	e8 d6 fe ff ff       	call   801d0a <fsipc>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 0b                	js     801e46 <devfile_write+0x4a>
	assert(r <= n);
  801e3b:	39 d8                	cmp    %ebx,%eax
  801e3d:	77 0c                	ja     801e4b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e3f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e44:	7f 1e                	jg     801e64 <devfile_write+0x68>
}
  801e46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    
	assert(r <= n);
  801e4b:	68 14 34 80 00       	push   $0x803414
  801e50:	68 1b 34 80 00       	push   $0x80341b
  801e55:	68 98 00 00 00       	push   $0x98
  801e5a:	68 30 34 80 00       	push   $0x803430
  801e5f:	e8 eb e4 ff ff       	call   80034f <_panic>
	assert(r <= PGSIZE);
  801e64:	68 3b 34 80 00       	push   $0x80343b
  801e69:	68 1b 34 80 00       	push   $0x80341b
  801e6e:	68 99 00 00 00       	push   $0x99
  801e73:	68 30 34 80 00       	push   $0x803430
  801e78:	e8 d2 e4 ff ff       	call   80034f <_panic>

00801e7d <devfile_read>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	56                   	push   %esi
  801e81:	53                   	push   %ebx
  801e82:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e90:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e96:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9b:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea0:	e8 65 fe ff ff       	call   801d0a <fsipc>
  801ea5:	89 c3                	mov    %eax,%ebx
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 1f                	js     801eca <devfile_read+0x4d>
	assert(r <= n);
  801eab:	39 f0                	cmp    %esi,%eax
  801ead:	77 24                	ja     801ed3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801eaf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eb4:	7f 33                	jg     801ee9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	50                   	push   %eax
  801eba:	68 00 60 80 00       	push   $0x806000
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	e8 6b ee ff ff       	call   800d32 <memmove>
	return r;
  801ec7:	83 c4 10             	add    $0x10,%esp
}
  801eca:	89 d8                	mov    %ebx,%eax
  801ecc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    
	assert(r <= n);
  801ed3:	68 14 34 80 00       	push   $0x803414
  801ed8:	68 1b 34 80 00       	push   $0x80341b
  801edd:	6a 7c                	push   $0x7c
  801edf:	68 30 34 80 00       	push   $0x803430
  801ee4:	e8 66 e4 ff ff       	call   80034f <_panic>
	assert(r <= PGSIZE);
  801ee9:	68 3b 34 80 00       	push   $0x80343b
  801eee:	68 1b 34 80 00       	push   $0x80341b
  801ef3:	6a 7d                	push   $0x7d
  801ef5:	68 30 34 80 00       	push   $0x803430
  801efa:	e8 50 e4 ff ff       	call   80034f <_panic>

00801eff <open>:
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	83 ec 1c             	sub    $0x1c,%esp
  801f07:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f0a:	56                   	push   %esi
  801f0b:	e8 5b ec ff ff       	call   800b6b <strlen>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f18:	7f 6c                	jg     801f86 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f20:	50                   	push   %eax
  801f21:	e8 79 f8 ff ff       	call   80179f <fd_alloc>
  801f26:	89 c3                	mov    %eax,%ebx
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 3c                	js     801f6b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f2f:	83 ec 08             	sub    $0x8,%esp
  801f32:	56                   	push   %esi
  801f33:	68 00 60 80 00       	push   $0x806000
  801f38:	e8 67 ec ff ff       	call   800ba4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f40:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f48:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4d:	e8 b8 fd ff ff       	call   801d0a <fsipc>
  801f52:	89 c3                	mov    %eax,%ebx
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 19                	js     801f74 <open+0x75>
	return fd2num(fd);
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f61:	e8 12 f8 ff ff       	call   801778 <fd2num>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	83 c4 10             	add    $0x10,%esp
}
  801f6b:	89 d8                	mov    %ebx,%eax
  801f6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    
		fd_close(fd, 0);
  801f74:	83 ec 08             	sub    $0x8,%esp
  801f77:	6a 00                	push   $0x0
  801f79:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7c:	e8 1b f9 ff ff       	call   80189c <fd_close>
		return r;
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	eb e5                	jmp    801f6b <open+0x6c>
		return -E_BAD_PATH;
  801f86:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f8b:	eb de                	jmp    801f6b <open+0x6c>

00801f8d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f93:	ba 00 00 00 00       	mov    $0x0,%edx
  801f98:	b8 08 00 00 00       	mov    $0x8,%eax
  801f9d:	e8 68 fd ff ff       	call   801d0a <fsipc>
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801faa:	68 47 34 80 00       	push   $0x803447
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	e8 ed eb ff ff       	call   800ba4 <strcpy>
	return 0;
}
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <devsock_close>:
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	53                   	push   %ebx
  801fc2:	83 ec 10             	sub    $0x10,%esp
  801fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fc8:	53                   	push   %ebx
  801fc9:	e8 e7 0a 00 00       	call   802ab5 <pageref>
  801fce:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fd1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fd6:	83 f8 01             	cmp    $0x1,%eax
  801fd9:	74 07                	je     801fe2 <devsock_close+0x24>
}
  801fdb:	89 d0                	mov    %edx,%eax
  801fdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	ff 73 0c             	pushl  0xc(%ebx)
  801fe8:	e8 b9 02 00 00       	call   8022a6 <nsipc_close>
  801fed:	89 c2                	mov    %eax,%edx
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	eb e7                	jmp    801fdb <devsock_close+0x1d>

00801ff4 <devsock_write>:
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	ff 75 10             	pushl  0x10(%ebp)
  801fff:	ff 75 0c             	pushl  0xc(%ebp)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	ff 70 0c             	pushl  0xc(%eax)
  802008:	e8 76 03 00 00       	call   802383 <nsipc_send>
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <devsock_read>:
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802015:	6a 00                	push   $0x0
  802017:	ff 75 10             	pushl  0x10(%ebp)
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	ff 70 0c             	pushl  0xc(%eax)
  802023:	e8 ef 02 00 00       	call   802317 <nsipc_recv>
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <fd2sockid>:
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802030:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802033:	52                   	push   %edx
  802034:	50                   	push   %eax
  802035:	e8 b7 f7 ff ff       	call   8017f1 <fd_lookup>
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 10                	js     802051 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  80204a:	39 08                	cmp    %ecx,(%eax)
  80204c:	75 05                	jne    802053 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80204e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    
		return -E_NOT_SUPP;
  802053:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802058:	eb f7                	jmp    802051 <fd2sockid+0x27>

0080205a <alloc_sockfd>:
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	56                   	push   %esi
  80205e:	53                   	push   %ebx
  80205f:	83 ec 1c             	sub    $0x1c,%esp
  802062:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802064:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802067:	50                   	push   %eax
  802068:	e8 32 f7 ff ff       	call   80179f <fd_alloc>
  80206d:	89 c3                	mov    %eax,%ebx
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	85 c0                	test   %eax,%eax
  802074:	78 43                	js     8020b9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802076:	83 ec 04             	sub    $0x4,%esp
  802079:	68 07 04 00 00       	push   $0x407
  80207e:	ff 75 f4             	pushl  -0xc(%ebp)
  802081:	6a 00                	push   $0x0
  802083:	e8 0e ef ff ff       	call   800f96 <sys_page_alloc>
  802088:	89 c3                	mov    %eax,%ebx
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 28                	js     8020b9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 15 24 40 80 00    	mov    0x804024,%edx
  80209a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020a6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020a9:	83 ec 0c             	sub    $0xc,%esp
  8020ac:	50                   	push   %eax
  8020ad:	e8 c6 f6 ff ff       	call   801778 <fd2num>
  8020b2:	89 c3                	mov    %eax,%ebx
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	eb 0c                	jmp    8020c5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	56                   	push   %esi
  8020bd:	e8 e4 01 00 00       	call   8022a6 <nsipc_close>
		return r;
  8020c2:	83 c4 10             	add    $0x10,%esp
}
  8020c5:	89 d8                	mov    %ebx,%eax
  8020c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5e                   	pop    %esi
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <accept>:
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	e8 4e ff ff ff       	call   80202a <fd2sockid>
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 1b                	js     8020fb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	ff 75 10             	pushl  0x10(%ebp)
  8020e6:	ff 75 0c             	pushl  0xc(%ebp)
  8020e9:	50                   	push   %eax
  8020ea:	e8 0e 01 00 00       	call   8021fd <nsipc_accept>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 05                	js     8020fb <accept+0x2d>
	return alloc_sockfd(r);
  8020f6:	e8 5f ff ff ff       	call   80205a <alloc_sockfd>
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <bind>:
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	e8 1f ff ff ff       	call   80202a <fd2sockid>
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 12                	js     802121 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	ff 75 10             	pushl  0x10(%ebp)
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	50                   	push   %eax
  802119:	e8 31 01 00 00       	call   80224f <nsipc_bind>
  80211e:	83 c4 10             	add    $0x10,%esp
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <shutdown>:
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	e8 f9 fe ff ff       	call   80202a <fd2sockid>
  802131:	85 c0                	test   %eax,%eax
  802133:	78 0f                	js     802144 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802135:	83 ec 08             	sub    $0x8,%esp
  802138:	ff 75 0c             	pushl  0xc(%ebp)
  80213b:	50                   	push   %eax
  80213c:	e8 43 01 00 00       	call   802284 <nsipc_shutdown>
  802141:	83 c4 10             	add    $0x10,%esp
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <connect>:
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	e8 d6 fe ff ff       	call   80202a <fd2sockid>
  802154:	85 c0                	test   %eax,%eax
  802156:	78 12                	js     80216a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	ff 75 10             	pushl  0x10(%ebp)
  80215e:	ff 75 0c             	pushl  0xc(%ebp)
  802161:	50                   	push   %eax
  802162:	e8 59 01 00 00       	call   8022c0 <nsipc_connect>
  802167:	83 c4 10             	add    $0x10,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <listen>:
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	e8 b0 fe ff ff       	call   80202a <fd2sockid>
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 0f                	js     80218d <listen+0x21>
	return nsipc_listen(r, backlog);
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	50                   	push   %eax
  802185:	e8 6b 01 00 00       	call   8022f5 <nsipc_listen>
  80218a:	83 c4 10             	add    $0x10,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <socket>:

int
socket(int domain, int type, int protocol)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802195:	ff 75 10             	pushl  0x10(%ebp)
  802198:	ff 75 0c             	pushl  0xc(%ebp)
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	e8 3e 02 00 00       	call   8023e1 <nsipc_socket>
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 05                	js     8021af <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021aa:	e8 ab fe ff ff       	call   80205a <alloc_sockfd>
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	53                   	push   %ebx
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021ba:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021c1:	74 26                	je     8021e9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021c3:	6a 07                	push   $0x7
  8021c5:	68 00 70 80 00       	push   $0x807000
  8021ca:	53                   	push   %ebx
  8021cb:	ff 35 04 50 80 00    	pushl  0x805004
  8021d1:	e8 48 08 00 00       	call   802a1e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021d6:	83 c4 0c             	add    $0xc,%esp
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	e8 d1 07 00 00       	call   8029b5 <ipc_recv>
}
  8021e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	6a 02                	push   $0x2
  8021ee:	e8 83 08 00 00       	call   802a76 <ipc_find_env>
  8021f3:	a3 04 50 80 00       	mov    %eax,0x805004
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	eb c6                	jmp    8021c3 <nsipc+0x12>

008021fd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80220d:	8b 06                	mov    (%esi),%eax
  80220f:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802214:	b8 01 00 00 00       	mov    $0x1,%eax
  802219:	e8 93 ff ff ff       	call   8021b1 <nsipc>
  80221e:	89 c3                	mov    %eax,%ebx
  802220:	85 c0                	test   %eax,%eax
  802222:	79 09                	jns    80222d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802224:	89 d8                	mov    %ebx,%eax
  802226:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802229:	5b                   	pop    %ebx
  80222a:	5e                   	pop    %esi
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	ff 35 10 70 80 00    	pushl  0x807010
  802236:	68 00 70 80 00       	push   $0x807000
  80223b:	ff 75 0c             	pushl  0xc(%ebp)
  80223e:	e8 ef ea ff ff       	call   800d32 <memmove>
		*addrlen = ret->ret_addrlen;
  802243:	a1 10 70 80 00       	mov    0x807010,%eax
  802248:	89 06                	mov    %eax,(%esi)
  80224a:	83 c4 10             	add    $0x10,%esp
	return r;
  80224d:	eb d5                	jmp    802224 <nsipc_accept+0x27>

0080224f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	53                   	push   %ebx
  802253:	83 ec 08             	sub    $0x8,%esp
  802256:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802261:	53                   	push   %ebx
  802262:	ff 75 0c             	pushl  0xc(%ebp)
  802265:	68 04 70 80 00       	push   $0x807004
  80226a:	e8 c3 ea ff ff       	call   800d32 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80226f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802275:	b8 02 00 00 00       	mov    $0x2,%eax
  80227a:	e8 32 ff ff ff       	call   8021b1 <nsipc>
}
  80227f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802292:	8b 45 0c             	mov    0xc(%ebp),%eax
  802295:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80229a:	b8 03 00 00 00       	mov    $0x3,%eax
  80229f:	e8 0d ff ff ff       	call   8021b1 <nsipc>
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <nsipc_close>:

int
nsipc_close(int s)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8022b9:	e8 f3 fe ff ff       	call   8021b1 <nsipc>
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 08             	sub    $0x8,%esp
  8022c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022d2:	53                   	push   %ebx
  8022d3:	ff 75 0c             	pushl  0xc(%ebp)
  8022d6:	68 04 70 80 00       	push   $0x807004
  8022db:	e8 52 ea ff ff       	call   800d32 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022e0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022e6:	b8 05 00 00 00       	mov    $0x5,%eax
  8022eb:	e8 c1 fe ff ff       	call   8021b1 <nsipc>
}
  8022f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802303:	8b 45 0c             	mov    0xc(%ebp),%eax
  802306:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80230b:	b8 06 00 00 00       	mov    $0x6,%eax
  802310:	e8 9c fe ff ff       	call   8021b1 <nsipc>
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	56                   	push   %esi
  80231b:	53                   	push   %ebx
  80231c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802327:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80232d:	8b 45 14             	mov    0x14(%ebp),%eax
  802330:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802335:	b8 07 00 00 00       	mov    $0x7,%eax
  80233a:	e8 72 fe ff ff       	call   8021b1 <nsipc>
  80233f:	89 c3                	mov    %eax,%ebx
  802341:	85 c0                	test   %eax,%eax
  802343:	78 1f                	js     802364 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802345:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80234a:	7f 21                	jg     80236d <nsipc_recv+0x56>
  80234c:	39 c6                	cmp    %eax,%esi
  80234e:	7c 1d                	jl     80236d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802350:	83 ec 04             	sub    $0x4,%esp
  802353:	50                   	push   %eax
  802354:	68 00 70 80 00       	push   $0x807000
  802359:	ff 75 0c             	pushl  0xc(%ebp)
  80235c:	e8 d1 e9 ff ff       	call   800d32 <memmove>
  802361:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802364:	89 d8                	mov    %ebx,%eax
  802366:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802369:	5b                   	pop    %ebx
  80236a:	5e                   	pop    %esi
  80236b:	5d                   	pop    %ebp
  80236c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80236d:	68 53 34 80 00       	push   $0x803453
  802372:	68 1b 34 80 00       	push   $0x80341b
  802377:	6a 62                	push   $0x62
  802379:	68 68 34 80 00       	push   $0x803468
  80237e:	e8 cc df ff ff       	call   80034f <_panic>

00802383 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	53                   	push   %ebx
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802395:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80239b:	7f 2e                	jg     8023cb <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	53                   	push   %ebx
  8023a1:	ff 75 0c             	pushl  0xc(%ebp)
  8023a4:	68 0c 70 80 00       	push   $0x80700c
  8023a9:	e8 84 e9 ff ff       	call   800d32 <memmove>
	nsipcbuf.send.req_size = size;
  8023ae:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8023c1:	e8 eb fd ff ff       	call   8021b1 <nsipc>
}
  8023c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    
	assert(size < 1600);
  8023cb:	68 74 34 80 00       	push   $0x803474
  8023d0:	68 1b 34 80 00       	push   $0x80341b
  8023d5:	6a 6d                	push   $0x6d
  8023d7:	68 68 34 80 00       	push   $0x803468
  8023dc:	e8 6e df ff ff       	call   80034f <_panic>

008023e1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f2:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fa:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023ff:	b8 09 00 00 00       	mov    $0x9,%eax
  802404:	e8 a8 fd ff ff       	call   8021b1 <nsipc>
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	56                   	push   %esi
  80240f:	53                   	push   %ebx
  802410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	ff 75 08             	pushl  0x8(%ebp)
  802419:	e8 6a f3 ff ff       	call   801788 <fd2data>
  80241e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802420:	83 c4 08             	add    $0x8,%esp
  802423:	68 80 34 80 00       	push   $0x803480
  802428:	53                   	push   %ebx
  802429:	e8 76 e7 ff ff       	call   800ba4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80242e:	8b 46 04             	mov    0x4(%esi),%eax
  802431:	2b 06                	sub    (%esi),%eax
  802433:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802439:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802440:	00 00 00 
	stat->st_dev = &devpipe;
  802443:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80244a:	40 80 00 
	return 0;
}
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    

00802459 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	53                   	push   %ebx
  80245d:	83 ec 0c             	sub    $0xc,%esp
  802460:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802463:	53                   	push   %ebx
  802464:	6a 00                	push   $0x0
  802466:	e8 b0 eb ff ff       	call   80101b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80246b:	89 1c 24             	mov    %ebx,(%esp)
  80246e:	e8 15 f3 ff ff       	call   801788 <fd2data>
  802473:	83 c4 08             	add    $0x8,%esp
  802476:	50                   	push   %eax
  802477:	6a 00                	push   $0x0
  802479:	e8 9d eb ff ff       	call   80101b <sys_page_unmap>
}
  80247e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <_pipeisclosed>:
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	57                   	push   %edi
  802487:	56                   	push   %esi
  802488:	53                   	push   %ebx
  802489:	83 ec 1c             	sub    $0x1c,%esp
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802490:	a1 08 50 80 00       	mov    0x805008,%eax
  802495:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802498:	83 ec 0c             	sub    $0xc,%esp
  80249b:	57                   	push   %edi
  80249c:	e8 14 06 00 00       	call   802ab5 <pageref>
  8024a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024a4:	89 34 24             	mov    %esi,(%esp)
  8024a7:	e8 09 06 00 00       	call   802ab5 <pageref>
		nn = thisenv->env_runs;
  8024ac:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024b2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024b5:	83 c4 10             	add    $0x10,%esp
  8024b8:	39 cb                	cmp    %ecx,%ebx
  8024ba:	74 1b                	je     8024d7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024bf:	75 cf                	jne    802490 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024c1:	8b 42 58             	mov    0x58(%edx),%eax
  8024c4:	6a 01                	push   $0x1
  8024c6:	50                   	push   %eax
  8024c7:	53                   	push   %ebx
  8024c8:	68 87 34 80 00       	push   $0x803487
  8024cd:	e8 73 df ff ff       	call   800445 <cprintf>
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	eb b9                	jmp    802490 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024d7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024da:	0f 94 c0             	sete   %al
  8024dd:	0f b6 c0             	movzbl %al,%eax
}
  8024e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e3:	5b                   	pop    %ebx
  8024e4:	5e                   	pop    %esi
  8024e5:	5f                   	pop    %edi
  8024e6:	5d                   	pop    %ebp
  8024e7:	c3                   	ret    

008024e8 <devpipe_write>:
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	57                   	push   %edi
  8024ec:	56                   	push   %esi
  8024ed:	53                   	push   %ebx
  8024ee:	83 ec 28             	sub    $0x28,%esp
  8024f1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024f4:	56                   	push   %esi
  8024f5:	e8 8e f2 ff ff       	call   801788 <fd2data>
  8024fa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802504:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802507:	74 4f                	je     802558 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802509:	8b 43 04             	mov    0x4(%ebx),%eax
  80250c:	8b 0b                	mov    (%ebx),%ecx
  80250e:	8d 51 20             	lea    0x20(%ecx),%edx
  802511:	39 d0                	cmp    %edx,%eax
  802513:	72 14                	jb     802529 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802515:	89 da                	mov    %ebx,%edx
  802517:	89 f0                	mov    %esi,%eax
  802519:	e8 65 ff ff ff       	call   802483 <_pipeisclosed>
  80251e:	85 c0                	test   %eax,%eax
  802520:	75 3b                	jne    80255d <devpipe_write+0x75>
			sys_yield();
  802522:	e8 50 ea ff ff       	call   800f77 <sys_yield>
  802527:	eb e0                	jmp    802509 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802529:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80252c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802530:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802533:	89 c2                	mov    %eax,%edx
  802535:	c1 fa 1f             	sar    $0x1f,%edx
  802538:	89 d1                	mov    %edx,%ecx
  80253a:	c1 e9 1b             	shr    $0x1b,%ecx
  80253d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802540:	83 e2 1f             	and    $0x1f,%edx
  802543:	29 ca                	sub    %ecx,%edx
  802545:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802549:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80254d:	83 c0 01             	add    $0x1,%eax
  802550:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802553:	83 c7 01             	add    $0x1,%edi
  802556:	eb ac                	jmp    802504 <devpipe_write+0x1c>
	return i;
  802558:	8b 45 10             	mov    0x10(%ebp),%eax
  80255b:	eb 05                	jmp    802562 <devpipe_write+0x7a>
				return 0;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802565:	5b                   	pop    %ebx
  802566:	5e                   	pop    %esi
  802567:	5f                   	pop    %edi
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    

0080256a <devpipe_read>:
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	57                   	push   %edi
  80256e:	56                   	push   %esi
  80256f:	53                   	push   %ebx
  802570:	83 ec 18             	sub    $0x18,%esp
  802573:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802576:	57                   	push   %edi
  802577:	e8 0c f2 ff ff       	call   801788 <fd2data>
  80257c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80257e:	83 c4 10             	add    $0x10,%esp
  802581:	be 00 00 00 00       	mov    $0x0,%esi
  802586:	3b 75 10             	cmp    0x10(%ebp),%esi
  802589:	75 14                	jne    80259f <devpipe_read+0x35>
	return i;
  80258b:	8b 45 10             	mov    0x10(%ebp),%eax
  80258e:	eb 02                	jmp    802592 <devpipe_read+0x28>
				return i;
  802590:	89 f0                	mov    %esi,%eax
}
  802592:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802595:	5b                   	pop    %ebx
  802596:	5e                   	pop    %esi
  802597:	5f                   	pop    %edi
  802598:	5d                   	pop    %ebp
  802599:	c3                   	ret    
			sys_yield();
  80259a:	e8 d8 e9 ff ff       	call   800f77 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80259f:	8b 03                	mov    (%ebx),%eax
  8025a1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025a4:	75 18                	jne    8025be <devpipe_read+0x54>
			if (i > 0)
  8025a6:	85 f6                	test   %esi,%esi
  8025a8:	75 e6                	jne    802590 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025aa:	89 da                	mov    %ebx,%edx
  8025ac:	89 f8                	mov    %edi,%eax
  8025ae:	e8 d0 fe ff ff       	call   802483 <_pipeisclosed>
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 e3                	je     80259a <devpipe_read+0x30>
				return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	eb d4                	jmp    802592 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025be:	99                   	cltd   
  8025bf:	c1 ea 1b             	shr    $0x1b,%edx
  8025c2:	01 d0                	add    %edx,%eax
  8025c4:	83 e0 1f             	and    $0x1f,%eax
  8025c7:	29 d0                	sub    %edx,%eax
  8025c9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025d1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025d4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025d7:	83 c6 01             	add    $0x1,%esi
  8025da:	eb aa                	jmp    802586 <devpipe_read+0x1c>

008025dc <pipe>:
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	56                   	push   %esi
  8025e0:	53                   	push   %ebx
  8025e1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e7:	50                   	push   %eax
  8025e8:	e8 b2 f1 ff ff       	call   80179f <fd_alloc>
  8025ed:	89 c3                	mov    %eax,%ebx
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	0f 88 23 01 00 00    	js     80271d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 07 04 00 00       	push   $0x407
  802602:	ff 75 f4             	pushl  -0xc(%ebp)
  802605:	6a 00                	push   $0x0
  802607:	e8 8a e9 ff ff       	call   800f96 <sys_page_alloc>
  80260c:	89 c3                	mov    %eax,%ebx
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	0f 88 04 01 00 00    	js     80271d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80261f:	50                   	push   %eax
  802620:	e8 7a f1 ff ff       	call   80179f <fd_alloc>
  802625:	89 c3                	mov    %eax,%ebx
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	85 c0                	test   %eax,%eax
  80262c:	0f 88 db 00 00 00    	js     80270d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	68 07 04 00 00       	push   $0x407
  80263a:	ff 75 f0             	pushl  -0x10(%ebp)
  80263d:	6a 00                	push   $0x0
  80263f:	e8 52 e9 ff ff       	call   800f96 <sys_page_alloc>
  802644:	89 c3                	mov    %eax,%ebx
  802646:	83 c4 10             	add    $0x10,%esp
  802649:	85 c0                	test   %eax,%eax
  80264b:	0f 88 bc 00 00 00    	js     80270d <pipe+0x131>
	va = fd2data(fd0);
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	ff 75 f4             	pushl  -0xc(%ebp)
  802657:	e8 2c f1 ff ff       	call   801788 <fd2data>
  80265c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265e:	83 c4 0c             	add    $0xc,%esp
  802661:	68 07 04 00 00       	push   $0x407
  802666:	50                   	push   %eax
  802667:	6a 00                	push   $0x0
  802669:	e8 28 e9 ff ff       	call   800f96 <sys_page_alloc>
  80266e:	89 c3                	mov    %eax,%ebx
  802670:	83 c4 10             	add    $0x10,%esp
  802673:	85 c0                	test   %eax,%eax
  802675:	0f 88 82 00 00 00    	js     8026fd <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	ff 75 f0             	pushl  -0x10(%ebp)
  802681:	e8 02 f1 ff ff       	call   801788 <fd2data>
  802686:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80268d:	50                   	push   %eax
  80268e:	6a 00                	push   $0x0
  802690:	56                   	push   %esi
  802691:	6a 00                	push   $0x0
  802693:	e8 41 e9 ff ff       	call   800fd9 <sys_page_map>
  802698:	89 c3                	mov    %eax,%ebx
  80269a:	83 c4 20             	add    $0x20,%esp
  80269d:	85 c0                	test   %eax,%eax
  80269f:	78 4e                	js     8026ef <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8026a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ae:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026c4:	83 ec 0c             	sub    $0xc,%esp
  8026c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ca:	e8 a9 f0 ff ff       	call   801778 <fd2num>
  8026cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026d4:	83 c4 04             	add    $0x4,%esp
  8026d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8026da:	e8 99 f0 ff ff       	call   801778 <fd2num>
  8026df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026e5:	83 c4 10             	add    $0x10,%esp
  8026e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026ed:	eb 2e                	jmp    80271d <pipe+0x141>
	sys_page_unmap(0, va);
  8026ef:	83 ec 08             	sub    $0x8,%esp
  8026f2:	56                   	push   %esi
  8026f3:	6a 00                	push   $0x0
  8026f5:	e8 21 e9 ff ff       	call   80101b <sys_page_unmap>
  8026fa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026fd:	83 ec 08             	sub    $0x8,%esp
  802700:	ff 75 f0             	pushl  -0x10(%ebp)
  802703:	6a 00                	push   $0x0
  802705:	e8 11 e9 ff ff       	call   80101b <sys_page_unmap>
  80270a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80270d:	83 ec 08             	sub    $0x8,%esp
  802710:	ff 75 f4             	pushl  -0xc(%ebp)
  802713:	6a 00                	push   $0x0
  802715:	e8 01 e9 ff ff       	call   80101b <sys_page_unmap>
  80271a:	83 c4 10             	add    $0x10,%esp
}
  80271d:	89 d8                	mov    %ebx,%eax
  80271f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802722:	5b                   	pop    %ebx
  802723:	5e                   	pop    %esi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <pipeisclosed>:
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272f:	50                   	push   %eax
  802730:	ff 75 08             	pushl  0x8(%ebp)
  802733:	e8 b9 f0 ff ff       	call   8017f1 <fd_lookup>
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	85 c0                	test   %eax,%eax
  80273d:	78 18                	js     802757 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80273f:	83 ec 0c             	sub    $0xc,%esp
  802742:	ff 75 f4             	pushl  -0xc(%ebp)
  802745:	e8 3e f0 ff ff       	call   801788 <fd2data>
	return _pipeisclosed(fd, p);
  80274a:	89 c2                	mov    %eax,%edx
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	e8 2f fd ff ff       	call   802483 <_pipeisclosed>
  802754:	83 c4 10             	add    $0x10,%esp
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	56                   	push   %esi
  80275d:	53                   	push   %ebx
  80275e:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802761:	85 f6                	test   %esi,%esi
  802763:	74 16                	je     80277b <wait+0x22>
	e = &envs[ENVX(envid)];
  802765:	89 f3                	mov    %esi,%ebx
  802767:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80276d:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802773:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802779:	eb 1b                	jmp    802796 <wait+0x3d>
	assert(envid != 0);
  80277b:	68 9f 34 80 00       	push   $0x80349f
  802780:	68 1b 34 80 00       	push   $0x80341b
  802785:	6a 09                	push   $0x9
  802787:	68 aa 34 80 00       	push   $0x8034aa
  80278c:	e8 be db ff ff       	call   80034f <_panic>
		sys_yield();
  802791:	e8 e1 e7 ff ff       	call   800f77 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802796:	8b 43 48             	mov    0x48(%ebx),%eax
  802799:	39 f0                	cmp    %esi,%eax
  80279b:	75 07                	jne    8027a4 <wait+0x4b>
  80279d:	8b 43 54             	mov    0x54(%ebx),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	75 ed                	jne    802791 <wait+0x38>
	}
}
  8027a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027a7:	5b                   	pop    %ebx
  8027a8:	5e                   	pop    %esi
  8027a9:	5d                   	pop    %ebp
  8027aa:	c3                   	ret    

008027ab <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	c3                   	ret    

008027b1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027b7:	68 b5 34 80 00       	push   $0x8034b5
  8027bc:	ff 75 0c             	pushl  0xc(%ebp)
  8027bf:	e8 e0 e3 ff ff       	call   800ba4 <strcpy>
	return 0;
}
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <devcons_write>:
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	57                   	push   %edi
  8027cf:	56                   	push   %esi
  8027d0:	53                   	push   %ebx
  8027d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027d7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027e5:	73 31                	jae    802818 <devcons_write+0x4d>
		m = n - tot;
  8027e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027ea:	29 f3                	sub    %esi,%ebx
  8027ec:	83 fb 7f             	cmp    $0x7f,%ebx
  8027ef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027f4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	53                   	push   %ebx
  8027fb:	89 f0                	mov    %esi,%eax
  8027fd:	03 45 0c             	add    0xc(%ebp),%eax
  802800:	50                   	push   %eax
  802801:	57                   	push   %edi
  802802:	e8 2b e5 ff ff       	call   800d32 <memmove>
		sys_cputs(buf, m);
  802807:	83 c4 08             	add    $0x8,%esp
  80280a:	53                   	push   %ebx
  80280b:	57                   	push   %edi
  80280c:	e8 c9 e6 ff ff       	call   800eda <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802811:	01 de                	add    %ebx,%esi
  802813:	83 c4 10             	add    $0x10,%esp
  802816:	eb ca                	jmp    8027e2 <devcons_write+0x17>
}
  802818:	89 f0                	mov    %esi,%eax
  80281a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80281d:	5b                   	pop    %ebx
  80281e:	5e                   	pop    %esi
  80281f:	5f                   	pop    %edi
  802820:	5d                   	pop    %ebp
  802821:	c3                   	ret    

00802822 <devcons_read>:
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 08             	sub    $0x8,%esp
  802828:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80282d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802831:	74 21                	je     802854 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802833:	e8 c0 e6 ff ff       	call   800ef8 <sys_cgetc>
  802838:	85 c0                	test   %eax,%eax
  80283a:	75 07                	jne    802843 <devcons_read+0x21>
		sys_yield();
  80283c:	e8 36 e7 ff ff       	call   800f77 <sys_yield>
  802841:	eb f0                	jmp    802833 <devcons_read+0x11>
	if (c < 0)
  802843:	78 0f                	js     802854 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802845:	83 f8 04             	cmp    $0x4,%eax
  802848:	74 0c                	je     802856 <devcons_read+0x34>
	*(char*)vbuf = c;
  80284a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284d:	88 02                	mov    %al,(%edx)
	return 1;
  80284f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    
		return 0;
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	eb f7                	jmp    802854 <devcons_read+0x32>

0080285d <cputchar>:
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802869:	6a 01                	push   $0x1
  80286b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80286e:	50                   	push   %eax
  80286f:	e8 66 e6 ff ff       	call   800eda <sys_cputs>
}
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <getchar>:
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
  80287c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80287f:	6a 01                	push   $0x1
  802881:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802884:	50                   	push   %eax
  802885:	6a 00                	push   $0x0
  802887:	e8 d5 f1 ff ff       	call   801a61 <read>
	if (r < 0)
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	85 c0                	test   %eax,%eax
  802891:	78 06                	js     802899 <getchar+0x20>
	if (r < 1)
  802893:	74 06                	je     80289b <getchar+0x22>
	return c;
  802895:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802899:	c9                   	leave  
  80289a:	c3                   	ret    
		return -E_EOF;
  80289b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028a0:	eb f7                	jmp    802899 <getchar+0x20>

008028a2 <iscons>:
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ab:	50                   	push   %eax
  8028ac:	ff 75 08             	pushl  0x8(%ebp)
  8028af:	e8 3d ef ff ff       	call   8017f1 <fd_lookup>
  8028b4:	83 c4 10             	add    $0x10,%esp
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	78 11                	js     8028cc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028c4:	39 10                	cmp    %edx,(%eax)
  8028c6:	0f 94 c0             	sete   %al
  8028c9:	0f b6 c0             	movzbl %al,%eax
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <opencons>:
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
  8028d1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028d7:	50                   	push   %eax
  8028d8:	e8 c2 ee ff ff       	call   80179f <fd_alloc>
  8028dd:	83 c4 10             	add    $0x10,%esp
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	78 3a                	js     80291e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028e4:	83 ec 04             	sub    $0x4,%esp
  8028e7:	68 07 04 00 00       	push   $0x407
  8028ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ef:	6a 00                	push   $0x0
  8028f1:	e8 a0 e6 ff ff       	call   800f96 <sys_page_alloc>
  8028f6:	83 c4 10             	add    $0x10,%esp
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	78 21                	js     80291e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802906:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802912:	83 ec 0c             	sub    $0xc,%esp
  802915:	50                   	push   %eax
  802916:	e8 5d ee ff ff       	call   801778 <fd2num>
  80291b:	83 c4 10             	add    $0x10,%esp
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802926:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80292d:	74 0a                	je     802939 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	6a 07                	push   $0x7
  80293e:	68 00 f0 bf ee       	push   $0xeebff000
  802943:	6a 00                	push   $0x0
  802945:	e8 4c e6 ff ff       	call   800f96 <sys_page_alloc>
		if(r < 0)
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	85 c0                	test   %eax,%eax
  80294f:	78 2a                	js     80297b <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802951:	83 ec 08             	sub    $0x8,%esp
  802954:	68 8f 29 80 00       	push   $0x80298f
  802959:	6a 00                	push   $0x0
  80295b:	e8 81 e7 ff ff       	call   8010e1 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802960:	83 c4 10             	add    $0x10,%esp
  802963:	85 c0                	test   %eax,%eax
  802965:	79 c8                	jns    80292f <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 f4 34 80 00       	push   $0x8034f4
  80296f:	6a 25                	push   $0x25
  802971:	68 30 35 80 00       	push   $0x803530
  802976:	e8 d4 d9 ff ff       	call   80034f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80297b:	83 ec 04             	sub    $0x4,%esp
  80297e:	68 c4 34 80 00       	push   $0x8034c4
  802983:	6a 22                	push   $0x22
  802985:	68 30 35 80 00       	push   $0x803530
  80298a:	e8 c0 d9 ff ff       	call   80034f <_panic>

0080298f <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80298f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802990:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802995:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802997:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80299a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80299e:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029a2:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029a5:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029a7:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029ab:	83 c4 08             	add    $0x8,%esp
	popal
  8029ae:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029af:	83 c4 04             	add    $0x4,%esp
	popfl
  8029b2:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029b3:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029b4:	c3                   	ret    

008029b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	56                   	push   %esi
  8029b9:	53                   	push   %ebx
  8029ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8029c3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029c5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029ca:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029cd:	83 ec 0c             	sub    $0xc,%esp
  8029d0:	50                   	push   %eax
  8029d1:	e8 70 e7 ff ff       	call   801146 <sys_ipc_recv>
	if(ret < 0){
  8029d6:	83 c4 10             	add    $0x10,%esp
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	78 2b                	js     802a08 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8029dd:	85 f6                	test   %esi,%esi
  8029df:	74 0a                	je     8029eb <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8029e1:	a1 08 50 80 00       	mov    0x805008,%eax
  8029e6:	8b 40 78             	mov    0x78(%eax),%eax
  8029e9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8029eb:	85 db                	test   %ebx,%ebx
  8029ed:	74 0a                	je     8029f9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8029ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8029f4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8029f7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8029f9:	a1 08 50 80 00       	mov    0x805008,%eax
  8029fe:	8b 40 74             	mov    0x74(%eax),%eax
}
  802a01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a04:	5b                   	pop    %ebx
  802a05:	5e                   	pop    %esi
  802a06:	5d                   	pop    %ebp
  802a07:	c3                   	ret    
		if(from_env_store)
  802a08:	85 f6                	test   %esi,%esi
  802a0a:	74 06                	je     802a12 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a0c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a12:	85 db                	test   %ebx,%ebx
  802a14:	74 eb                	je     802a01 <ipc_recv+0x4c>
			*perm_store = 0;
  802a16:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a1c:	eb e3                	jmp    802a01 <ipc_recv+0x4c>

00802a1e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	53                   	push   %ebx
  802a24:	83 ec 0c             	sub    $0xc,%esp
  802a27:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a30:	85 db                	test   %ebx,%ebx
  802a32:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a37:	0f 44 d8             	cmove  %eax,%ebx
  802a3a:	eb 05                	jmp    802a41 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a3c:	e8 36 e5 ff ff       	call   800f77 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a41:	ff 75 14             	pushl  0x14(%ebp)
  802a44:	53                   	push   %ebx
  802a45:	56                   	push   %esi
  802a46:	57                   	push   %edi
  802a47:	e8 d7 e6 ff ff       	call   801123 <sys_ipc_try_send>
  802a4c:	83 c4 10             	add    $0x10,%esp
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	74 1b                	je     802a6e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a53:	79 e7                	jns    802a3c <ipc_send+0x1e>
  802a55:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a58:	74 e2                	je     802a3c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a5a:	83 ec 04             	sub    $0x4,%esp
  802a5d:	68 3e 35 80 00       	push   $0x80353e
  802a62:	6a 46                	push   $0x46
  802a64:	68 53 35 80 00       	push   $0x803553
  802a69:	e8 e1 d8 ff ff       	call   80034f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a71:	5b                   	pop    %ebx
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    

00802a76 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a76:	55                   	push   %ebp
  802a77:	89 e5                	mov    %esp,%ebp
  802a79:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a7c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a81:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802a87:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a8d:	8b 52 50             	mov    0x50(%edx),%edx
  802a90:	39 ca                	cmp    %ecx,%edx
  802a92:	74 11                	je     802aa5 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802a94:	83 c0 01             	add    $0x1,%eax
  802a97:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a9c:	75 e3                	jne    802a81 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa3:	eb 0e                	jmp    802ab3 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802aa5:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802aab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ab0:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ab3:	5d                   	pop    %ebp
  802ab4:	c3                   	ret    

00802ab5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
  802ab8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802abb:	89 d0                	mov    %edx,%eax
  802abd:	c1 e8 16             	shr    $0x16,%eax
  802ac0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802acc:	f6 c1 01             	test   $0x1,%cl
  802acf:	74 1d                	je     802aee <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ad1:	c1 ea 0c             	shr    $0xc,%edx
  802ad4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802adb:	f6 c2 01             	test   $0x1,%dl
  802ade:	74 0e                	je     802aee <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ae0:	c1 ea 0c             	shr    $0xc,%edx
  802ae3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802aea:	ef 
  802aeb:	0f b7 c0             	movzwl %ax,%eax
}
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    

00802af0 <__udivdi3>:
  802af0:	55                   	push   %ebp
  802af1:	57                   	push   %edi
  802af2:	56                   	push   %esi
  802af3:	53                   	push   %ebx
  802af4:	83 ec 1c             	sub    $0x1c,%esp
  802af7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802afb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802aff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b07:	85 d2                	test   %edx,%edx
  802b09:	75 4d                	jne    802b58 <__udivdi3+0x68>
  802b0b:	39 f3                	cmp    %esi,%ebx
  802b0d:	76 19                	jbe    802b28 <__udivdi3+0x38>
  802b0f:	31 ff                	xor    %edi,%edi
  802b11:	89 e8                	mov    %ebp,%eax
  802b13:	89 f2                	mov    %esi,%edx
  802b15:	f7 f3                	div    %ebx
  802b17:	89 fa                	mov    %edi,%edx
  802b19:	83 c4 1c             	add    $0x1c,%esp
  802b1c:	5b                   	pop    %ebx
  802b1d:	5e                   	pop    %esi
  802b1e:	5f                   	pop    %edi
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    
  802b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b28:	89 d9                	mov    %ebx,%ecx
  802b2a:	85 db                	test   %ebx,%ebx
  802b2c:	75 0b                	jne    802b39 <__udivdi3+0x49>
  802b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b33:	31 d2                	xor    %edx,%edx
  802b35:	f7 f3                	div    %ebx
  802b37:	89 c1                	mov    %eax,%ecx
  802b39:	31 d2                	xor    %edx,%edx
  802b3b:	89 f0                	mov    %esi,%eax
  802b3d:	f7 f1                	div    %ecx
  802b3f:	89 c6                	mov    %eax,%esi
  802b41:	89 e8                	mov    %ebp,%eax
  802b43:	89 f7                	mov    %esi,%edi
  802b45:	f7 f1                	div    %ecx
  802b47:	89 fa                	mov    %edi,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	39 f2                	cmp    %esi,%edx
  802b5a:	77 1c                	ja     802b78 <__udivdi3+0x88>
  802b5c:	0f bd fa             	bsr    %edx,%edi
  802b5f:	83 f7 1f             	xor    $0x1f,%edi
  802b62:	75 2c                	jne    802b90 <__udivdi3+0xa0>
  802b64:	39 f2                	cmp    %esi,%edx
  802b66:	72 06                	jb     802b6e <__udivdi3+0x7e>
  802b68:	31 c0                	xor    %eax,%eax
  802b6a:	39 eb                	cmp    %ebp,%ebx
  802b6c:	77 a9                	ja     802b17 <__udivdi3+0x27>
  802b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b73:	eb a2                	jmp    802b17 <__udivdi3+0x27>
  802b75:	8d 76 00             	lea    0x0(%esi),%esi
  802b78:	31 ff                	xor    %edi,%edi
  802b7a:	31 c0                	xor    %eax,%eax
  802b7c:	89 fa                	mov    %edi,%edx
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	89 f9                	mov    %edi,%ecx
  802b92:	b8 20 00 00 00       	mov    $0x20,%eax
  802b97:	29 f8                	sub    %edi,%eax
  802b99:	d3 e2                	shl    %cl,%edx
  802b9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b9f:	89 c1                	mov    %eax,%ecx
  802ba1:	89 da                	mov    %ebx,%edx
  802ba3:	d3 ea                	shr    %cl,%edx
  802ba5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba9:	09 d1                	or     %edx,%ecx
  802bab:	89 f2                	mov    %esi,%edx
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 f9                	mov    %edi,%ecx
  802bb3:	d3 e3                	shl    %cl,%ebx
  802bb5:	89 c1                	mov    %eax,%ecx
  802bb7:	d3 ea                	shr    %cl,%edx
  802bb9:	89 f9                	mov    %edi,%ecx
  802bbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bbf:	89 eb                	mov    %ebp,%ebx
  802bc1:	d3 e6                	shl    %cl,%esi
  802bc3:	89 c1                	mov    %eax,%ecx
  802bc5:	d3 eb                	shr    %cl,%ebx
  802bc7:	09 de                	or     %ebx,%esi
  802bc9:	89 f0                	mov    %esi,%eax
  802bcb:	f7 74 24 08          	divl   0x8(%esp)
  802bcf:	89 d6                	mov    %edx,%esi
  802bd1:	89 c3                	mov    %eax,%ebx
  802bd3:	f7 64 24 0c          	mull   0xc(%esp)
  802bd7:	39 d6                	cmp    %edx,%esi
  802bd9:	72 15                	jb     802bf0 <__udivdi3+0x100>
  802bdb:	89 f9                	mov    %edi,%ecx
  802bdd:	d3 e5                	shl    %cl,%ebp
  802bdf:	39 c5                	cmp    %eax,%ebp
  802be1:	73 04                	jae    802be7 <__udivdi3+0xf7>
  802be3:	39 d6                	cmp    %edx,%esi
  802be5:	74 09                	je     802bf0 <__udivdi3+0x100>
  802be7:	89 d8                	mov    %ebx,%eax
  802be9:	31 ff                	xor    %edi,%edi
  802beb:	e9 27 ff ff ff       	jmp    802b17 <__udivdi3+0x27>
  802bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802bf3:	31 ff                	xor    %edi,%edi
  802bf5:	e9 1d ff ff ff       	jmp    802b17 <__udivdi3+0x27>
  802bfa:	66 90                	xchg   %ax,%ax
  802bfc:	66 90                	xchg   %ax,%ax
  802bfe:	66 90                	xchg   %ax,%ax

00802c00 <__umoddi3>:
  802c00:	55                   	push   %ebp
  802c01:	57                   	push   %edi
  802c02:	56                   	push   %esi
  802c03:	53                   	push   %ebx
  802c04:	83 ec 1c             	sub    $0x1c,%esp
  802c07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c17:	89 da                	mov    %ebx,%edx
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	75 43                	jne    802c60 <__umoddi3+0x60>
  802c1d:	39 df                	cmp    %ebx,%edi
  802c1f:	76 17                	jbe    802c38 <__umoddi3+0x38>
  802c21:	89 f0                	mov    %esi,%eax
  802c23:	f7 f7                	div    %edi
  802c25:	89 d0                	mov    %edx,%eax
  802c27:	31 d2                	xor    %edx,%edx
  802c29:	83 c4 1c             	add    $0x1c,%esp
  802c2c:	5b                   	pop    %ebx
  802c2d:	5e                   	pop    %esi
  802c2e:	5f                   	pop    %edi
  802c2f:	5d                   	pop    %ebp
  802c30:	c3                   	ret    
  802c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c38:	89 fd                	mov    %edi,%ebp
  802c3a:	85 ff                	test   %edi,%edi
  802c3c:	75 0b                	jne    802c49 <__umoddi3+0x49>
  802c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c43:	31 d2                	xor    %edx,%edx
  802c45:	f7 f7                	div    %edi
  802c47:	89 c5                	mov    %eax,%ebp
  802c49:	89 d8                	mov    %ebx,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f5                	div    %ebp
  802c4f:	89 f0                	mov    %esi,%eax
  802c51:	f7 f5                	div    %ebp
  802c53:	89 d0                	mov    %edx,%eax
  802c55:	eb d0                	jmp    802c27 <__umoddi3+0x27>
  802c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c5e:	66 90                	xchg   %ax,%ax
  802c60:	89 f1                	mov    %esi,%ecx
  802c62:	39 d8                	cmp    %ebx,%eax
  802c64:	76 0a                	jbe    802c70 <__umoddi3+0x70>
  802c66:	89 f0                	mov    %esi,%eax
  802c68:	83 c4 1c             	add    $0x1c,%esp
  802c6b:	5b                   	pop    %ebx
  802c6c:	5e                   	pop    %esi
  802c6d:	5f                   	pop    %edi
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    
  802c70:	0f bd e8             	bsr    %eax,%ebp
  802c73:	83 f5 1f             	xor    $0x1f,%ebp
  802c76:	75 20                	jne    802c98 <__umoddi3+0x98>
  802c78:	39 d8                	cmp    %ebx,%eax
  802c7a:	0f 82 b0 00 00 00    	jb     802d30 <__umoddi3+0x130>
  802c80:	39 f7                	cmp    %esi,%edi
  802c82:	0f 86 a8 00 00 00    	jbe    802d30 <__umoddi3+0x130>
  802c88:	89 c8                	mov    %ecx,%eax
  802c8a:	83 c4 1c             	add    $0x1c,%esp
  802c8d:	5b                   	pop    %ebx
  802c8e:	5e                   	pop    %esi
  802c8f:	5f                   	pop    %edi
  802c90:	5d                   	pop    %ebp
  802c91:	c3                   	ret    
  802c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c98:	89 e9                	mov    %ebp,%ecx
  802c9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802c9f:	29 ea                	sub    %ebp,%edx
  802ca1:	d3 e0                	shl    %cl,%eax
  802ca3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ca7:	89 d1                	mov    %edx,%ecx
  802ca9:	89 f8                	mov    %edi,%eax
  802cab:	d3 e8                	shr    %cl,%eax
  802cad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cb5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cb9:	09 c1                	or     %eax,%ecx
  802cbb:	89 d8                	mov    %ebx,%eax
  802cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cc1:	89 e9                	mov    %ebp,%ecx
  802cc3:	d3 e7                	shl    %cl,%edi
  802cc5:	89 d1                	mov    %edx,%ecx
  802cc7:	d3 e8                	shr    %cl,%eax
  802cc9:	89 e9                	mov    %ebp,%ecx
  802ccb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ccf:	d3 e3                	shl    %cl,%ebx
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	89 d1                	mov    %edx,%ecx
  802cd5:	89 f0                	mov    %esi,%eax
  802cd7:	d3 e8                	shr    %cl,%eax
  802cd9:	89 e9                	mov    %ebp,%ecx
  802cdb:	89 fa                	mov    %edi,%edx
  802cdd:	d3 e6                	shl    %cl,%esi
  802cdf:	09 d8                	or     %ebx,%eax
  802ce1:	f7 74 24 08          	divl   0x8(%esp)
  802ce5:	89 d1                	mov    %edx,%ecx
  802ce7:	89 f3                	mov    %esi,%ebx
  802ce9:	f7 64 24 0c          	mull   0xc(%esp)
  802ced:	89 c6                	mov    %eax,%esi
  802cef:	89 d7                	mov    %edx,%edi
  802cf1:	39 d1                	cmp    %edx,%ecx
  802cf3:	72 06                	jb     802cfb <__umoddi3+0xfb>
  802cf5:	75 10                	jne    802d07 <__umoddi3+0x107>
  802cf7:	39 c3                	cmp    %eax,%ebx
  802cf9:	73 0c                	jae    802d07 <__umoddi3+0x107>
  802cfb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802cff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d03:	89 d7                	mov    %edx,%edi
  802d05:	89 c6                	mov    %eax,%esi
  802d07:	89 ca                	mov    %ecx,%edx
  802d09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d0e:	29 f3                	sub    %esi,%ebx
  802d10:	19 fa                	sbb    %edi,%edx
  802d12:	89 d0                	mov    %edx,%eax
  802d14:	d3 e0                	shl    %cl,%eax
  802d16:	89 e9                	mov    %ebp,%ecx
  802d18:	d3 eb                	shr    %cl,%ebx
  802d1a:	d3 ea                	shr    %cl,%edx
  802d1c:	09 d8                	or     %ebx,%eax
  802d1e:	83 c4 1c             	add    $0x1c,%esp
  802d21:	5b                   	pop    %ebx
  802d22:	5e                   	pop    %esi
  802d23:	5f                   	pop    %edi
  802d24:	5d                   	pop    %ebp
  802d25:	c3                   	ret    
  802d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d2d:	8d 76 00             	lea    0x0(%esi),%esi
  802d30:	89 da                	mov    %ebx,%edx
  802d32:	29 fe                	sub    %edi,%esi
  802d34:	19 c2                	sbb    %eax,%edx
  802d36:	89 f1                	mov    %esi,%ecx
  802d38:	89 c8                	mov    %ecx,%eax
  802d3a:	e9 4b ff ff ff       	jmp    802c8a <__umoddi3+0x8a>
