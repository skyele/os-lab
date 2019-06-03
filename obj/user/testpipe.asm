
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
  80003b:	c7 05 04 40 80 00 80 	movl   $0x802d80,0x804004
  800042:	2d 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 bb 25 00 00       	call   802609 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 b3 14 00 00       	call   801513 <fork>
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
  80007f:	68 ae 2d 80 00       	push   $0x802dae
  800084:	e8 fb 03 00 00       	call   800484 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 bc 18 00 00       	call   801950 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 cb 2d 80 00       	push   $0x802dcb
  8000a8:	e8 d7 03 00 00       	call   800484 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 57 1a 00 00       	call   801b15 <readn>
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
  8000dd:	e8 ac 0b 00 00       	call   800c8e <strcmp>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	0f 85 bf 00 00 00    	jne    8001ac <umain+0x179>
			cprintf("\npipe read closed properly\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 f1 2d 80 00       	push   $0x802df1
  8000f5:	e8 8a 03 00 00       	call   800484 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000fd:	e8 72 02 00 00       	call   800374 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	53                   	push   %ebx
  800106:	e8 7b 26 00 00       	call   802786 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 47 	movl   $0x802e47,0x804004
  800112:	2e 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 e9 24 00 00       	call   802609 <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 e1 13 00 00       	call   801513 <fork>
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
  800148:	e8 03 18 00 00       	call   801950 <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 f8 17 00 00       	call   801950 <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 26 26 00 00       	call   802786 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  800167:	e8 18 03 00 00       	call   800484 <cprintf>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    
		panic("pipe: %e", i);
  800176:	50                   	push   %eax
  800177:	68 8c 2d 80 00       	push   $0x802d8c
  80017c:	6a 0e                	push   $0xe
  80017e:	68 95 2d 80 00       	push   $0x802d95
  800183:	e8 06 02 00 00       	call   80038e <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 a5 2d 80 00       	push   $0x802da5
  80018e:	6a 11                	push   $0x11
  800190:	68 95 2d 80 00       	push   $0x802d95
  800195:	e8 f4 01 00 00       	call   80038e <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 e8 2d 80 00       	push   $0x802de8
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 95 2d 80 00       	push   $0x802d95
  8001a7:	e8 e2 01 00 00       	call   80038e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 0d 2e 80 00       	push   $0x802e0d
  8001b9:	e8 c6 02 00 00       	call   800484 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 ae 2d 80 00       	push   $0x802dae
  8001da:	e8 a5 02 00 00       	call   800484 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 66 17 00 00       	call   801950 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 20 2e 80 00       	push   $0x802e20
  8001fe:	e8 81 02 00 00       	call   800484 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 99 09 00 00       	call   800baa <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 37 19 00 00       	call   801b5a <write>
  800223:	89 c6                	mov    %eax,%esi
  800225:	83 c4 04             	add    $0x4,%esp
  800228:	ff 35 00 40 80 00    	pushl  0x804000
  80022e:	e8 77 09 00 00       	call   800baa <strlen>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	39 f0                	cmp    %esi,%eax
  800238:	75 13                	jne    80024d <umain+0x21a>
		close(p[1]);
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	ff 75 90             	pushl  -0x70(%ebp)
  800240:	e8 0b 17 00 00       	call   801950 <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 3d 2e 80 00       	push   $0x802e3d
  800253:	6a 25                	push   $0x25
  800255:	68 95 2d 80 00       	push   $0x802d95
  80025a:	e8 2f 01 00 00       	call   80038e <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 8c 2d 80 00       	push   $0x802d8c
  800265:	6a 2c                	push   $0x2c
  800267:	68 95 2d 80 00       	push   $0x802d95
  80026c:	e8 1d 01 00 00       	call   80038e <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 a5 2d 80 00       	push   $0x802da5
  800277:	6a 2f                	push   $0x2f
  800279:	68 95 2d 80 00       	push   $0x802d95
  80027e:	e8 0b 01 00 00       	call   80038e <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 c2 16 00 00       	call   801950 <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 54 2e 80 00       	push   $0x802e54
  800299:	e8 e6 01 00 00       	call   800484 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 56 2e 80 00       	push   $0x802e56
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 aa 18 00 00       	call   801b5a <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 58 2e 80 00       	push   $0x802e58
  8002c0:	e8 bf 01 00 00       	call   800484 <cprintf>
		exit();
  8002c5:	e8 aa 00 00 00       	call   800374 <exit>
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
  8002e5:	e8 ad 0c 00 00       	call   800f97 <sys_getenvid>
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

	cprintf("call umain!\n");
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	68 cc 2e 80 00       	push   $0x802ecc
  800351:	e8 2e 01 00 00       	call   800484 <cprintf>
	// call user main routine
	umain(argc, argv);
  800356:	83 c4 08             	add    $0x8,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	e8 cf fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800364:	e8 0b 00 00 00       	call   800374 <exit>
}
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80037a:	e8 fe 15 00 00       	call   80197d <close_all>
	sys_env_destroy(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 cd 0b 00 00       	call   800f56 <sys_env_destroy>
}
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	56                   	push   %esi
  800392:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800393:	a1 08 50 80 00       	mov    0x805008,%eax
  800398:	8b 40 48             	mov    0x48(%eax),%eax
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	68 14 2f 80 00       	push   $0x802f14
  8003a3:	50                   	push   %eax
  8003a4:	68 e3 2e 80 00       	push   $0x802ee3
  8003a9:	e8 d6 00 00 00       	call   800484 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8003ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b1:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8003b7:	e8 db 0b 00 00       	call   800f97 <sys_getenvid>
  8003bc:	83 c4 04             	add    $0x4,%esp
  8003bf:	ff 75 0c             	pushl  0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	56                   	push   %esi
  8003c6:	50                   	push   %eax
  8003c7:	68 f0 2e 80 00       	push   $0x802ef0
  8003cc:	e8 b3 00 00 00       	call   800484 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d1:	83 c4 18             	add    $0x18,%esp
  8003d4:	53                   	push   %ebx
  8003d5:	ff 75 10             	pushl  0x10(%ebp)
  8003d8:	e8 56 00 00 00       	call   800433 <vcprintf>
	cprintf("\n");
  8003dd:	c7 04 24 d7 2e 80 00 	movl   $0x802ed7,(%esp)
  8003e4:	e8 9b 00 00 00       	call   800484 <cprintf>
  8003e9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ec:	cc                   	int3   
  8003ed:	eb fd                	jmp    8003ec <_panic+0x5e>

008003ef <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	53                   	push   %ebx
  8003f3:	83 ec 04             	sub    $0x4,%esp
  8003f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003f9:	8b 13                	mov    (%ebx),%edx
  8003fb:	8d 42 01             	lea    0x1(%edx),%eax
  8003fe:	89 03                	mov    %eax,(%ebx)
  800400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800403:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800407:	3d ff 00 00 00       	cmp    $0xff,%eax
  80040c:	74 09                	je     800417 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80040e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800415:	c9                   	leave  
  800416:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	68 ff 00 00 00       	push   $0xff
  80041f:	8d 43 08             	lea    0x8(%ebx),%eax
  800422:	50                   	push   %eax
  800423:	e8 f1 0a 00 00       	call   800f19 <sys_cputs>
		b->idx = 0;
  800428:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	eb db                	jmp    80040e <putch+0x1f>

00800433 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80043c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800443:	00 00 00 
	b.cnt = 0;
  800446:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80044d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800450:	ff 75 0c             	pushl  0xc(%ebp)
  800453:	ff 75 08             	pushl  0x8(%ebp)
  800456:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80045c:	50                   	push   %eax
  80045d:	68 ef 03 80 00       	push   $0x8003ef
  800462:	e8 4a 01 00 00       	call   8005b1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800467:	83 c4 08             	add    $0x8,%esp
  80046a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800470:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800476:	50                   	push   %eax
  800477:	e8 9d 0a 00 00       	call   800f19 <sys_cputs>

	return b.cnt;
}
  80047c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80048d:	50                   	push   %eax
  80048e:	ff 75 08             	pushl  0x8(%ebp)
  800491:	e8 9d ff ff ff       	call   800433 <vcprintf>
	va_end(ap);

	return cnt;
}
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	57                   	push   %edi
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
  80049e:	83 ec 1c             	sub    $0x1c,%esp
  8004a1:	89 c6                	mov    %eax,%esi
  8004a3:	89 d7                	mov    %edx,%edi
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8004b7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8004bb:	74 2c                	je     8004e9 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8004d2:	73 43                	jae    800517 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8004d4:	83 eb 01             	sub    $0x1,%ebx
  8004d7:	85 db                	test   %ebx,%ebx
  8004d9:	7e 6c                	jle    800547 <printnum+0xaf>
				putch(padc, putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	57                   	push   %edi
  8004df:	ff 75 18             	pushl  0x18(%ebp)
  8004e2:	ff d6                	call   *%esi
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	eb eb                	jmp    8004d4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	6a 20                	push   $0x20
  8004ee:	6a 00                	push   $0x0
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f7:	89 fa                	mov    %edi,%edx
  8004f9:	89 f0                	mov    %esi,%eax
  8004fb:	e8 98 ff ff ff       	call   800498 <printnum>
		while (--width > 0)
  800500:	83 c4 20             	add    $0x20,%esp
  800503:	83 eb 01             	sub    $0x1,%ebx
  800506:	85 db                	test   %ebx,%ebx
  800508:	7e 65                	jle    80056f <printnum+0xd7>
			putch(padc, putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	57                   	push   %edi
  80050e:	6a 20                	push   $0x20
  800510:	ff d6                	call   *%esi
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	eb ec                	jmp    800503 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	ff 75 18             	pushl  0x18(%ebp)
  80051d:	83 eb 01             	sub    $0x1,%ebx
  800520:	53                   	push   %ebx
  800521:	50                   	push   %eax
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	ff 75 dc             	pushl  -0x24(%ebp)
  800528:	ff 75 d8             	pushl  -0x28(%ebp)
  80052b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80052e:	ff 75 e0             	pushl  -0x20(%ebp)
  800531:	e8 ea 25 00 00       	call   802b20 <__udivdi3>
  800536:	83 c4 18             	add    $0x18,%esp
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	89 fa                	mov    %edi,%edx
  80053d:	89 f0                	mov    %esi,%eax
  80053f:	e8 54 ff ff ff       	call   800498 <printnum>
  800544:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	57                   	push   %edi
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	ff 75 dc             	pushl  -0x24(%ebp)
  800551:	ff 75 d8             	pushl  -0x28(%ebp)
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	ff 75 e0             	pushl  -0x20(%ebp)
  80055a:	e8 d1 26 00 00       	call   802c30 <__umoddi3>
  80055f:	83 c4 14             	add    $0x14,%esp
  800562:	0f be 80 1b 2f 80 00 	movsbl 0x802f1b(%eax),%eax
  800569:	50                   	push   %eax
  80056a:	ff d6                	call   *%esi
  80056c:	83 c4 10             	add    $0x10,%esp
	}
}
  80056f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800572:	5b                   	pop    %ebx
  800573:	5e                   	pop    %esi
  800574:	5f                   	pop    %edi
  800575:	5d                   	pop    %ebp
  800576:	c3                   	ret    

00800577 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80057d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800581:	8b 10                	mov    (%eax),%edx
  800583:	3b 50 04             	cmp    0x4(%eax),%edx
  800586:	73 0a                	jae    800592 <sprintputch+0x1b>
		*b->buf++ = ch;
  800588:	8d 4a 01             	lea    0x1(%edx),%ecx
  80058b:	89 08                	mov    %ecx,(%eax)
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	88 02                	mov    %al,(%edx)
}
  800592:	5d                   	pop    %ebp
  800593:	c3                   	ret    

00800594 <printfmt>:
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80059a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80059d:	50                   	push   %eax
  80059e:	ff 75 10             	pushl  0x10(%ebp)
  8005a1:	ff 75 0c             	pushl  0xc(%ebp)
  8005a4:	ff 75 08             	pushl  0x8(%ebp)
  8005a7:	e8 05 00 00 00       	call   8005b1 <vprintfmt>
}
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	c9                   	leave  
  8005b0:	c3                   	ret    

008005b1 <vprintfmt>:
{
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	57                   	push   %edi
  8005b5:	56                   	push   %esi
  8005b6:	53                   	push   %ebx
  8005b7:	83 ec 3c             	sub    $0x3c,%esp
  8005ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8005bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005c3:	e9 32 04 00 00       	jmp    8009fa <vprintfmt+0x449>
		padc = ' ';
  8005c8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8005cc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8005d3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8005da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8005e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005e8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8005ef:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8d 47 01             	lea    0x1(%edi),%eax
  8005f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005fa:	0f b6 17             	movzbl (%edi),%edx
  8005fd:	8d 42 dd             	lea    -0x23(%edx),%eax
  800600:	3c 55                	cmp    $0x55,%al
  800602:	0f 87 12 05 00 00    	ja     800b1a <vprintfmt+0x569>
  800608:	0f b6 c0             	movzbl %al,%eax
  80060b:	ff 24 85 00 31 80 00 	jmp    *0x803100(,%eax,4)
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800615:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800619:	eb d9                	jmp    8005f4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80061e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800622:	eb d0                	jmp    8005f4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800624:	0f b6 d2             	movzbl %dl,%edx
  800627:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80062a:	b8 00 00 00 00       	mov    $0x0,%eax
  80062f:	89 75 08             	mov    %esi,0x8(%ebp)
  800632:	eb 03                	jmp    800637 <vprintfmt+0x86>
  800634:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800637:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80063a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80063e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800641:	8d 72 d0             	lea    -0x30(%edx),%esi
  800644:	83 fe 09             	cmp    $0x9,%esi
  800647:	76 eb                	jbe    800634 <vprintfmt+0x83>
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	8b 75 08             	mov    0x8(%ebp),%esi
  80064f:	eb 14                	jmp    800665 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800662:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800665:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800669:	79 89                	jns    8005f4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80066b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80066e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800671:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800678:	e9 77 ff ff ff       	jmp    8005f4 <vprintfmt+0x43>
  80067d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800680:	85 c0                	test   %eax,%eax
  800682:	0f 48 c1             	cmovs  %ecx,%eax
  800685:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80068b:	e9 64 ff ff ff       	jmp    8005f4 <vprintfmt+0x43>
  800690:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800693:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80069a:	e9 55 ff ff ff       	jmp    8005f4 <vprintfmt+0x43>
			lflag++;
  80069f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006a6:	e9 49 ff ff ff       	jmp    8005f4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8d 78 04             	lea    0x4(%eax),%edi
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	ff 30                	pushl  (%eax)
  8006b7:	ff d6                	call   *%esi
			break;
  8006b9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006bc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006bf:	e9 33 03 00 00       	jmp    8009f7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 78 04             	lea    0x4(%eax),%edi
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	31 d0                	xor    %edx,%eax
  8006cf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006d1:	83 f8 10             	cmp    $0x10,%eax
  8006d4:	7f 23                	jg     8006f9 <vprintfmt+0x148>
  8006d6:	8b 14 85 60 32 80 00 	mov    0x803260(,%eax,4),%edx
  8006dd:	85 d2                	test   %edx,%edx
  8006df:	74 18                	je     8006f9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006e1:	52                   	push   %edx
  8006e2:	68 71 34 80 00       	push   $0x803471
  8006e7:	53                   	push   %ebx
  8006e8:	56                   	push   %esi
  8006e9:	e8 a6 fe ff ff       	call   800594 <printfmt>
  8006ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006f1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006f4:	e9 fe 02 00 00       	jmp    8009f7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006f9:	50                   	push   %eax
  8006fa:	68 33 2f 80 00       	push   $0x802f33
  8006ff:	53                   	push   %ebx
  800700:	56                   	push   %esi
  800701:	e8 8e fe ff ff       	call   800594 <printfmt>
  800706:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800709:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80070c:	e9 e6 02 00 00       	jmp    8009f7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	83 c0 04             	add    $0x4,%eax
  800717:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80071f:	85 c9                	test   %ecx,%ecx
  800721:	b8 2c 2f 80 00       	mov    $0x802f2c,%eax
  800726:	0f 45 c1             	cmovne %ecx,%eax
  800729:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80072c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800730:	7e 06                	jle    800738 <vprintfmt+0x187>
  800732:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800736:	75 0d                	jne    800745 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800738:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80073b:	89 c7                	mov    %eax,%edi
  80073d:	03 45 e0             	add    -0x20(%ebp),%eax
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800743:	eb 53                	jmp    800798 <vprintfmt+0x1e7>
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 d8             	pushl  -0x28(%ebp)
  80074b:	50                   	push   %eax
  80074c:	e8 71 04 00 00       	call   800bc2 <strnlen>
  800751:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800754:	29 c1                	sub    %eax,%ecx
  800756:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80075e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800762:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800765:	eb 0f                	jmp    800776 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	ff 75 e0             	pushl  -0x20(%ebp)
  80076e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800770:	83 ef 01             	sub    $0x1,%edi
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	85 ff                	test   %edi,%edi
  800778:	7f ed                	jg     800767 <vprintfmt+0x1b6>
  80077a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80077d:	85 c9                	test   %ecx,%ecx
  80077f:	b8 00 00 00 00       	mov    $0x0,%eax
  800784:	0f 49 c1             	cmovns %ecx,%eax
  800787:	29 c1                	sub    %eax,%ecx
  800789:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80078c:	eb aa                	jmp    800738 <vprintfmt+0x187>
					putch(ch, putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	52                   	push   %edx
  800793:	ff d6                	call   *%esi
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80079b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80079d:	83 c7 01             	add    $0x1,%edi
  8007a0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a4:	0f be d0             	movsbl %al,%edx
  8007a7:	85 d2                	test   %edx,%edx
  8007a9:	74 4b                	je     8007f6 <vprintfmt+0x245>
  8007ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007af:	78 06                	js     8007b7 <vprintfmt+0x206>
  8007b1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8007b5:	78 1e                	js     8007d5 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007bb:	74 d1                	je     80078e <vprintfmt+0x1dd>
  8007bd:	0f be c0             	movsbl %al,%eax
  8007c0:	83 e8 20             	sub    $0x20,%eax
  8007c3:	83 f8 5e             	cmp    $0x5e,%eax
  8007c6:	76 c6                	jbe    80078e <vprintfmt+0x1dd>
					putch('?', putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	53                   	push   %ebx
  8007cc:	6a 3f                	push   $0x3f
  8007ce:	ff d6                	call   *%esi
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb c3                	jmp    800798 <vprintfmt+0x1e7>
  8007d5:	89 cf                	mov    %ecx,%edi
  8007d7:	eb 0e                	jmp    8007e7 <vprintfmt+0x236>
				putch(' ', putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	53                   	push   %ebx
  8007dd:	6a 20                	push   $0x20
  8007df:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8007e1:	83 ef 01             	sub    $0x1,%edi
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	85 ff                	test   %edi,%edi
  8007e9:	7f ee                	jg     8007d9 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8007eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	e9 01 02 00 00       	jmp    8009f7 <vprintfmt+0x446>
  8007f6:	89 cf                	mov    %ecx,%edi
  8007f8:	eb ed                	jmp    8007e7 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8007fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8007fd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800804:	e9 eb fd ff ff       	jmp    8005f4 <vprintfmt+0x43>
	if (lflag >= 2)
  800809:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80080d:	7f 21                	jg     800830 <vprintfmt+0x27f>
	else if (lflag)
  80080f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800813:	74 68                	je     80087d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80081d:	89 c1                	mov    %eax,%ecx
  80081f:	c1 f9 1f             	sar    $0x1f,%ecx
  800822:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8d 40 04             	lea    0x4(%eax),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
  80082e:	eb 17                	jmp    800847 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8b 50 04             	mov    0x4(%eax),%edx
  800836:	8b 00                	mov    (%eax),%eax
  800838:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80083b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8d 40 08             	lea    0x8(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800847:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80084a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80084d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800850:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800857:	78 3f                	js     800898 <vprintfmt+0x2e7>
			base = 10;
  800859:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80085e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800862:	0f 84 71 01 00 00    	je     8009d9 <vprintfmt+0x428>
				putch('+', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	6a 2b                	push   $0x2b
  80086e:	ff d6                	call   *%esi
  800870:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800873:	b8 0a 00 00 00       	mov    $0xa,%eax
  800878:	e9 5c 01 00 00       	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800885:	89 c1                	mov    %eax,%ecx
  800887:	c1 f9 1f             	sar    $0x1f,%ecx
  80088a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 04             	lea    0x4(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
  800896:	eb af                	jmp    800847 <vprintfmt+0x296>
				putch('-', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 2d                	push   $0x2d
  80089e:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008a6:	f7 d8                	neg    %eax
  8008a8:	83 d2 00             	adc    $0x0,%edx
  8008ab:	f7 da                	neg    %edx
  8008ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bb:	e9 19 01 00 00       	jmp    8009d9 <vprintfmt+0x428>
	if (lflag >= 2)
  8008c0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008c4:	7f 29                	jg     8008ef <vprintfmt+0x33e>
	else if (lflag)
  8008c6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ca:	74 44                	je     800910 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 40 04             	lea    0x4(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ea:	e9 ea 00 00 00       	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	8b 50 04             	mov    0x4(%eax),%edx
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	8d 40 08             	lea    0x8(%eax),%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800906:	b8 0a 00 00 00       	mov    $0xa,%eax
  80090b:	e9 c9 00 00 00       	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	ba 00 00 00 00       	mov    $0x0,%edx
  80091a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8d 40 04             	lea    0x4(%eax),%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800929:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092e:	e9 a6 00 00 00       	jmp    8009d9 <vprintfmt+0x428>
			putch('0', putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	53                   	push   %ebx
  800937:	6a 30                	push   $0x30
  800939:	ff d6                	call   *%esi
	if (lflag >= 2)
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800942:	7f 26                	jg     80096a <vprintfmt+0x3b9>
	else if (lflag)
  800944:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800948:	74 3e                	je     800988 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	ba 00 00 00 00       	mov    $0x0,%edx
  800954:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800957:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8d 40 04             	lea    0x4(%eax),%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800963:	b8 08 00 00 00       	mov    $0x8,%eax
  800968:	eb 6f                	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8b 50 04             	mov    0x4(%eax),%edx
  800970:	8b 00                	mov    (%eax),%eax
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	8d 40 08             	lea    0x8(%eax),%eax
  80097e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800981:	b8 08 00 00 00       	mov    $0x8,%eax
  800986:	eb 51                	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	ba 00 00 00 00       	mov    $0x0,%edx
  800992:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800995:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	8d 40 04             	lea    0x4(%eax),%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8009a6:	eb 31                	jmp    8009d9 <vprintfmt+0x428>
			putch('0', putdat);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	53                   	push   %ebx
  8009ac:	6a 30                	push   $0x30
  8009ae:	ff d6                	call   *%esi
			putch('x', putdat);
  8009b0:	83 c4 08             	add    $0x8,%esp
  8009b3:	53                   	push   %ebx
  8009b4:	6a 78                	push   $0x78
  8009b6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8009c8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	8d 40 04             	lea    0x4(%eax),%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009d4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009d9:	83 ec 0c             	sub    $0xc,%esp
  8009dc:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8009e0:	52                   	push   %edx
  8009e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8009e4:	50                   	push   %eax
  8009e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8009e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8009eb:	89 da                	mov    %ebx,%edx
  8009ed:	89 f0                	mov    %esi,%eax
  8009ef:	e8 a4 fa ff ff       	call   800498 <printnum>
			break;
  8009f4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009fa:	83 c7 01             	add    $0x1,%edi
  8009fd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a01:	83 f8 25             	cmp    $0x25,%eax
  800a04:	0f 84 be fb ff ff    	je     8005c8 <vprintfmt+0x17>
			if (ch == '\0')
  800a0a:	85 c0                	test   %eax,%eax
  800a0c:	0f 84 28 01 00 00    	je     800b3a <vprintfmt+0x589>
			putch(ch, putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	53                   	push   %ebx
  800a16:	50                   	push   %eax
  800a17:	ff d6                	call   *%esi
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	eb dc                	jmp    8009fa <vprintfmt+0x449>
	if (lflag >= 2)
  800a1e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a22:	7f 26                	jg     800a4a <vprintfmt+0x499>
	else if (lflag)
  800a24:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a28:	74 41                	je     800a6b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	8b 00                	mov    (%eax),%eax
  800a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a34:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a37:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	8d 40 04             	lea    0x4(%eax),%eax
  800a40:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a43:	b8 10 00 00 00       	mov    $0x10,%eax
  800a48:	eb 8f                	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	8b 50 04             	mov    0x4(%eax),%edx
  800a50:	8b 00                	mov    (%eax),%eax
  800a52:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a55:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	8d 40 08             	lea    0x8(%eax),%eax
  800a5e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a61:	b8 10 00 00 00       	mov    $0x10,%eax
  800a66:	e9 6e ff ff ff       	jmp    8009d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	ba 00 00 00 00       	mov    $0x0,%edx
  800a75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a78:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	8d 40 04             	lea    0x4(%eax),%eax
  800a81:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a84:	b8 10 00 00 00       	mov    $0x10,%eax
  800a89:	e9 4b ff ff ff       	jmp    8009d9 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	8b 00                	mov    (%eax),%eax
  800a9c:	85 c0                	test   %eax,%eax
  800a9e:	74 14                	je     800ab4 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800aa0:	8b 13                	mov    (%ebx),%edx
  800aa2:	83 fa 7f             	cmp    $0x7f,%edx
  800aa5:	7f 37                	jg     800ade <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800aa7:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaf:	e9 43 ff ff ff       	jmp    8009f7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800ab4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab9:	bf 51 30 80 00       	mov    $0x803051,%edi
							putch(ch, putdat);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	53                   	push   %ebx
  800ac2:	50                   	push   %eax
  800ac3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800ac5:	83 c7 01             	add    $0x1,%edi
  800ac8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	75 eb                	jne    800abe <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800ad3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad9:	e9 19 ff ff ff       	jmp    8009f7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800ade:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800ae0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae5:	bf 89 30 80 00       	mov    $0x803089,%edi
							putch(ch, putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	53                   	push   %ebx
  800aee:	50                   	push   %eax
  800aef:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800af1:	83 c7 01             	add    $0x1,%edi
  800af4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800af8:	83 c4 10             	add    $0x10,%esp
  800afb:	85 c0                	test   %eax,%eax
  800afd:	75 eb                	jne    800aea <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800aff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b02:	89 45 14             	mov    %eax,0x14(%ebp)
  800b05:	e9 ed fe ff ff       	jmp    8009f7 <vprintfmt+0x446>
			putch(ch, putdat);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	53                   	push   %ebx
  800b0e:	6a 25                	push   $0x25
  800b10:	ff d6                	call   *%esi
			break;
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	e9 dd fe ff ff       	jmp    8009f7 <vprintfmt+0x446>
			putch('%', putdat);
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	53                   	push   %ebx
  800b1e:	6a 25                	push   $0x25
  800b20:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	89 f8                	mov    %edi,%eax
  800b27:	eb 03                	jmp    800b2c <vprintfmt+0x57b>
  800b29:	83 e8 01             	sub    $0x1,%eax
  800b2c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b30:	75 f7                	jne    800b29 <vprintfmt+0x578>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b35:	e9 bd fe ff ff       	jmp    8009f7 <vprintfmt+0x446>
}
  800b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3d:	5b                   	pop    %ebx
  800b3e:	5e                   	pop    %esi
  800b3f:	5f                   	pop    %edi
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	83 ec 18             	sub    $0x18,%esp
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b51:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b55:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b5f:	85 c0                	test   %eax,%eax
  800b61:	74 26                	je     800b89 <vsnprintf+0x47>
  800b63:	85 d2                	test   %edx,%edx
  800b65:	7e 22                	jle    800b89 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 77 05 80 00       	push   $0x800577
  800b76:	e8 36 fa ff ff       	call   8005b1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b84:	83 c4 10             	add    $0x10,%esp
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    
		return -E_INVAL;
  800b89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b8e:	eb f7                	jmp    800b87 <vsnprintf+0x45>

00800b90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b96:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b99:	50                   	push   %eax
  800b9a:	ff 75 10             	pushl  0x10(%ebp)
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 9a ff ff ff       	call   800b42 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bb9:	74 05                	je     800bc0 <strlen+0x16>
		n++;
  800bbb:	83 c0 01             	add    $0x1,%eax
  800bbe:	eb f5                	jmp    800bb5 <strlen+0xb>
	return n;
}
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	74 0d                	je     800be1 <strnlen+0x1f>
  800bd4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800bd8:	74 05                	je     800bdf <strnlen+0x1d>
		n++;
  800bda:	83 c2 01             	add    $0x1,%edx
  800bdd:	eb f1                	jmp    800bd0 <strnlen+0xe>
  800bdf:	89 d0                	mov    %edx,%eax
	return n;
}
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	53                   	push   %ebx
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bed:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bf6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bf9:	83 c2 01             	add    $0x1,%edx
  800bfc:	84 c9                	test   %cl,%cl
  800bfe:	75 f2                	jne    800bf2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c00:	5b                   	pop    %ebx
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	53                   	push   %ebx
  800c07:	83 ec 10             	sub    $0x10,%esp
  800c0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c0d:	53                   	push   %ebx
  800c0e:	e8 97 ff ff ff       	call   800baa <strlen>
  800c13:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	01 d8                	add    %ebx,%eax
  800c1b:	50                   	push   %eax
  800c1c:	e8 c2 ff ff ff       	call   800be3 <strcpy>
	return dst;
}
  800c21:	89 d8                	mov    %ebx,%eax
  800c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c26:	c9                   	leave  
  800c27:	c3                   	ret    

00800c28 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	89 c6                	mov    %eax,%esi
  800c35:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	39 f2                	cmp    %esi,%edx
  800c3c:	74 11                	je     800c4f <strncpy+0x27>
		*dst++ = *src;
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	0f b6 19             	movzbl (%ecx),%ebx
  800c44:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c47:	80 fb 01             	cmp    $0x1,%bl
  800c4a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800c4d:	eb eb                	jmp    800c3a <strncpy+0x12>
	}
	return ret;
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	8b 75 08             	mov    0x8(%ebp),%esi
  800c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5e:	8b 55 10             	mov    0x10(%ebp),%edx
  800c61:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c63:	85 d2                	test   %edx,%edx
  800c65:	74 21                	je     800c88 <strlcpy+0x35>
  800c67:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c6b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c6d:	39 c2                	cmp    %eax,%edx
  800c6f:	74 14                	je     800c85 <strlcpy+0x32>
  800c71:	0f b6 19             	movzbl (%ecx),%ebx
  800c74:	84 db                	test   %bl,%bl
  800c76:	74 0b                	je     800c83 <strlcpy+0x30>
			*dst++ = *src++;
  800c78:	83 c1 01             	add    $0x1,%ecx
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c81:	eb ea                	jmp    800c6d <strlcpy+0x1a>
  800c83:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800c85:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c88:	29 f0                	sub    %esi,%eax
}
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c94:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c97:	0f b6 01             	movzbl (%ecx),%eax
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 0c                	je     800caa <strcmp+0x1c>
  800c9e:	3a 02                	cmp    (%edx),%al
  800ca0:	75 08                	jne    800caa <strcmp+0x1c>
		p++, q++;
  800ca2:	83 c1 01             	add    $0x1,%ecx
  800ca5:	83 c2 01             	add    $0x1,%edx
  800ca8:	eb ed                	jmp    800c97 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800caa:	0f b6 c0             	movzbl %al,%eax
  800cad:	0f b6 12             	movzbl (%edx),%edx
  800cb0:	29 d0                	sub    %edx,%eax
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	53                   	push   %ebx
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbe:	89 c3                	mov    %eax,%ebx
  800cc0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cc3:	eb 06                	jmp    800ccb <strncmp+0x17>
		n--, p++, q++;
  800cc5:	83 c0 01             	add    $0x1,%eax
  800cc8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ccb:	39 d8                	cmp    %ebx,%eax
  800ccd:	74 16                	je     800ce5 <strncmp+0x31>
  800ccf:	0f b6 08             	movzbl (%eax),%ecx
  800cd2:	84 c9                	test   %cl,%cl
  800cd4:	74 04                	je     800cda <strncmp+0x26>
  800cd6:	3a 0a                	cmp    (%edx),%cl
  800cd8:	74 eb                	je     800cc5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cda:	0f b6 00             	movzbl (%eax),%eax
  800cdd:	0f b6 12             	movzbl (%edx),%edx
  800ce0:	29 d0                	sub    %edx,%eax
}
  800ce2:	5b                   	pop    %ebx
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
		return 0;
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cea:	eb f6                	jmp    800ce2 <strncmp+0x2e>

00800cec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf6:	0f b6 10             	movzbl (%eax),%edx
  800cf9:	84 d2                	test   %dl,%dl
  800cfb:	74 09                	je     800d06 <strchr+0x1a>
		if (*s == c)
  800cfd:	38 ca                	cmp    %cl,%dl
  800cff:	74 0a                	je     800d0b <strchr+0x1f>
	for (; *s; s++)
  800d01:	83 c0 01             	add    $0x1,%eax
  800d04:	eb f0                	jmp    800cf6 <strchr+0xa>
			return (char *) s;
	return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d17:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d1a:	38 ca                	cmp    %cl,%dl
  800d1c:	74 09                	je     800d27 <strfind+0x1a>
  800d1e:	84 d2                	test   %dl,%dl
  800d20:	74 05                	je     800d27 <strfind+0x1a>
	for (; *s; s++)
  800d22:	83 c0 01             	add    $0x1,%eax
  800d25:	eb f0                	jmp    800d17 <strfind+0xa>
			break;
	return (char *) s;
}
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d35:	85 c9                	test   %ecx,%ecx
  800d37:	74 31                	je     800d6a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d39:	89 f8                	mov    %edi,%eax
  800d3b:	09 c8                	or     %ecx,%eax
  800d3d:	a8 03                	test   $0x3,%al
  800d3f:	75 23                	jne    800d64 <memset+0x3b>
		c &= 0xFF;
  800d41:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d45:	89 d3                	mov    %edx,%ebx
  800d47:	c1 e3 08             	shl    $0x8,%ebx
  800d4a:	89 d0                	mov    %edx,%eax
  800d4c:	c1 e0 18             	shl    $0x18,%eax
  800d4f:	89 d6                	mov    %edx,%esi
  800d51:	c1 e6 10             	shl    $0x10,%esi
  800d54:	09 f0                	or     %esi,%eax
  800d56:	09 c2                	or     %eax,%edx
  800d58:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d5a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d5d:	89 d0                	mov    %edx,%eax
  800d5f:	fc                   	cld    
  800d60:	f3 ab                	rep stos %eax,%es:(%edi)
  800d62:	eb 06                	jmp    800d6a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	fc                   	cld    
  800d68:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d6a:	89 f8                	mov    %edi,%eax
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d7f:	39 c6                	cmp    %eax,%esi
  800d81:	73 32                	jae    800db5 <memmove+0x44>
  800d83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d86:	39 c2                	cmp    %eax,%edx
  800d88:	76 2b                	jbe    800db5 <memmove+0x44>
		s += n;
		d += n;
  800d8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8d:	89 fe                	mov    %edi,%esi
  800d8f:	09 ce                	or     %ecx,%esi
  800d91:	09 d6                	or     %edx,%esi
  800d93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d99:	75 0e                	jne    800da9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d9b:	83 ef 04             	sub    $0x4,%edi
  800d9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800da1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800da4:	fd                   	std    
  800da5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da7:	eb 09                	jmp    800db2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800da9:	83 ef 01             	sub    $0x1,%edi
  800dac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800daf:	fd                   	std    
  800db0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800db2:	fc                   	cld    
  800db3:	eb 1a                	jmp    800dcf <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	09 ca                	or     %ecx,%edx
  800db9:	09 f2                	or     %esi,%edx
  800dbb:	f6 c2 03             	test   $0x3,%dl
  800dbe:	75 0a                	jne    800dca <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dc0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dc3:	89 c7                	mov    %eax,%edi
  800dc5:	fc                   	cld    
  800dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dc8:	eb 05                	jmp    800dcf <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800dca:	89 c7                	mov    %eax,%edi
  800dcc:	fc                   	cld    
  800dcd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dd9:	ff 75 10             	pushl  0x10(%ebp)
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	ff 75 08             	pushl  0x8(%ebp)
  800de2:	e8 8a ff ff ff       	call   800d71 <memmove>
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 c6                	mov    %eax,%esi
  800df6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800df9:	39 f0                	cmp    %esi,%eax
  800dfb:	74 1c                	je     800e19 <memcmp+0x30>
		if (*s1 != *s2)
  800dfd:	0f b6 08             	movzbl (%eax),%ecx
  800e00:	0f b6 1a             	movzbl (%edx),%ebx
  800e03:	38 d9                	cmp    %bl,%cl
  800e05:	75 08                	jne    800e0f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e07:	83 c0 01             	add    $0x1,%eax
  800e0a:	83 c2 01             	add    $0x1,%edx
  800e0d:	eb ea                	jmp    800df9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e0f:	0f b6 c1             	movzbl %cl,%eax
  800e12:	0f b6 db             	movzbl %bl,%ebx
  800e15:	29 d8                	sub    %ebx,%eax
  800e17:	eb 05                	jmp    800e1e <memcmp+0x35>
	}

	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e30:	39 d0                	cmp    %edx,%eax
  800e32:	73 09                	jae    800e3d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e34:	38 08                	cmp    %cl,(%eax)
  800e36:	74 05                	je     800e3d <memfind+0x1b>
	for (; s < ends; s++)
  800e38:	83 c0 01             	add    $0x1,%eax
  800e3b:	eb f3                	jmp    800e30 <memfind+0xe>
			break;
	return (void *) s;
}
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4b:	eb 03                	jmp    800e50 <strtol+0x11>
		s++;
  800e4d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e50:	0f b6 01             	movzbl (%ecx),%eax
  800e53:	3c 20                	cmp    $0x20,%al
  800e55:	74 f6                	je     800e4d <strtol+0xe>
  800e57:	3c 09                	cmp    $0x9,%al
  800e59:	74 f2                	je     800e4d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e5b:	3c 2b                	cmp    $0x2b,%al
  800e5d:	74 2a                	je     800e89 <strtol+0x4a>
	int neg = 0;
  800e5f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e64:	3c 2d                	cmp    $0x2d,%al
  800e66:	74 2b                	je     800e93 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e68:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e6e:	75 0f                	jne    800e7f <strtol+0x40>
  800e70:	80 39 30             	cmpb   $0x30,(%ecx)
  800e73:	74 28                	je     800e9d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e75:	85 db                	test   %ebx,%ebx
  800e77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e7c:	0f 44 d8             	cmove  %eax,%ebx
  800e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e84:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e87:	eb 50                	jmp    800ed9 <strtol+0x9a>
		s++;
  800e89:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800e91:	eb d5                	jmp    800e68 <strtol+0x29>
		s++, neg = 1;
  800e93:	83 c1 01             	add    $0x1,%ecx
  800e96:	bf 01 00 00 00       	mov    $0x1,%edi
  800e9b:	eb cb                	jmp    800e68 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e9d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ea1:	74 0e                	je     800eb1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ea3:	85 db                	test   %ebx,%ebx
  800ea5:	75 d8                	jne    800e7f <strtol+0x40>
		s++, base = 8;
  800ea7:	83 c1 01             	add    $0x1,%ecx
  800eaa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eaf:	eb ce                	jmp    800e7f <strtol+0x40>
		s += 2, base = 16;
  800eb1:	83 c1 02             	add    $0x2,%ecx
  800eb4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800eb9:	eb c4                	jmp    800e7f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ebb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ebe:	89 f3                	mov    %esi,%ebx
  800ec0:	80 fb 19             	cmp    $0x19,%bl
  800ec3:	77 29                	ja     800eee <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ec5:	0f be d2             	movsbl %dl,%edx
  800ec8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ecb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ece:	7d 30                	jge    800f00 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ed0:	83 c1 01             	add    $0x1,%ecx
  800ed3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ed9:	0f b6 11             	movzbl (%ecx),%edx
  800edc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800edf:	89 f3                	mov    %esi,%ebx
  800ee1:	80 fb 09             	cmp    $0x9,%bl
  800ee4:	77 d5                	ja     800ebb <strtol+0x7c>
			dig = *s - '0';
  800ee6:	0f be d2             	movsbl %dl,%edx
  800ee9:	83 ea 30             	sub    $0x30,%edx
  800eec:	eb dd                	jmp    800ecb <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800eee:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ef1:	89 f3                	mov    %esi,%ebx
  800ef3:	80 fb 19             	cmp    $0x19,%bl
  800ef6:	77 08                	ja     800f00 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ef8:	0f be d2             	movsbl %dl,%edx
  800efb:	83 ea 37             	sub    $0x37,%edx
  800efe:	eb cb                	jmp    800ecb <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f04:	74 05                	je     800f0b <strtol+0xcc>
		*endptr = (char *) s;
  800f06:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f09:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f0b:	89 c2                	mov    %eax,%edx
  800f0d:	f7 da                	neg    %edx
  800f0f:	85 ff                	test   %edi,%edi
  800f11:	0f 45 c2             	cmovne %edx,%eax
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2a:	89 c3                	mov    %eax,%ebx
  800f2c:	89 c7                	mov    %eax,%edi
  800f2e:	89 c6                	mov    %eax,%esi
  800f30:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f42:	b8 01 00 00 00       	mov    $0x1,%eax
  800f47:	89 d1                	mov    %edx,%ecx
  800f49:	89 d3                	mov    %edx,%ebx
  800f4b:	89 d7                	mov    %edx,%edi
  800f4d:	89 d6                	mov    %edx,%esi
  800f4f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
  800f5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	b8 03 00 00 00       	mov    $0x3,%eax
  800f6c:	89 cb                	mov    %ecx,%ebx
  800f6e:	89 cf                	mov    %ecx,%edi
  800f70:	89 ce                	mov    %ecx,%esi
  800f72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7f 08                	jg     800f80 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	50                   	push   %eax
  800f84:	6a 03                	push   $0x3
  800f86:	68 a4 32 80 00       	push   $0x8032a4
  800f8b:	6a 43                	push   $0x43
  800f8d:	68 c1 32 80 00       	push   $0x8032c1
  800f92:	e8 f7 f3 ff ff       	call   80038e <_panic>

00800f97 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa2:	b8 02 00 00 00       	mov    $0x2,%eax
  800fa7:	89 d1                	mov    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	89 d7                	mov    %edx,%edi
  800fad:	89 d6                	mov    %edx,%esi
  800faf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_yield>:

void
sys_yield(void)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fc6:	89 d1                	mov    %edx,%ecx
  800fc8:	89 d3                	mov    %edx,%ebx
  800fca:	89 d7                	mov    %edx,%edi
  800fcc:	89 d6                	mov    %edx,%esi
  800fce:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fd0:	5b                   	pop    %ebx
  800fd1:	5e                   	pop    %esi
  800fd2:	5f                   	pop    %edi
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	57                   	push   %edi
  800fd9:	56                   	push   %esi
  800fda:	53                   	push   %ebx
  800fdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fde:	be 00 00 00 00       	mov    $0x0,%esi
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe9:	b8 04 00 00 00       	mov    $0x4,%eax
  800fee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff1:	89 f7                	mov    %esi,%edi
  800ff3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	7f 08                	jg     801001 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	50                   	push   %eax
  801005:	6a 04                	push   $0x4
  801007:	68 a4 32 80 00       	push   $0x8032a4
  80100c:	6a 43                	push   $0x43
  80100e:	68 c1 32 80 00       	push   $0x8032c1
  801013:	e8 76 f3 ff ff       	call   80038e <_panic>

00801018 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801027:	b8 05 00 00 00       	mov    $0x5,%eax
  80102c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80102f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801032:	8b 75 18             	mov    0x18(%ebp),%esi
  801035:	cd 30                	int    $0x30
	if(check && ret > 0)
  801037:	85 c0                	test   %eax,%eax
  801039:	7f 08                	jg     801043 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80103b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	50                   	push   %eax
  801047:	6a 05                	push   $0x5
  801049:	68 a4 32 80 00       	push   $0x8032a4
  80104e:	6a 43                	push   $0x43
  801050:	68 c1 32 80 00       	push   $0x8032c1
  801055:	e8 34 f3 ff ff       	call   80038e <_panic>

0080105a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	b8 06 00 00 00       	mov    $0x6,%eax
  801073:	89 df                	mov    %ebx,%edi
  801075:	89 de                	mov    %ebx,%esi
  801077:	cd 30                	int    $0x30
	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7f 08                	jg     801085 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80107d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	50                   	push   %eax
  801089:	6a 06                	push   $0x6
  80108b:	68 a4 32 80 00       	push   $0x8032a4
  801090:	6a 43                	push   $0x43
  801092:	68 c1 32 80 00       	push   $0x8032c1
  801097:	e8 f2 f2 ff ff       	call   80038e <_panic>

0080109c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
  8010a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8010b5:	89 df                	mov    %ebx,%edi
  8010b7:	89 de                	mov    %ebx,%esi
  8010b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	7f 08                	jg     8010c7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c2:	5b                   	pop    %ebx
  8010c3:	5e                   	pop    %esi
  8010c4:	5f                   	pop    %edi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	50                   	push   %eax
  8010cb:	6a 08                	push   $0x8
  8010cd:	68 a4 32 80 00       	push   $0x8032a4
  8010d2:	6a 43                	push   $0x43
  8010d4:	68 c1 32 80 00       	push   $0x8032c1
  8010d9:	e8 b0 f2 ff ff       	call   80038e <_panic>

008010de <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f2:	b8 09 00 00 00       	mov    $0x9,%eax
  8010f7:	89 df                	mov    %ebx,%edi
  8010f9:	89 de                	mov    %ebx,%esi
  8010fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	7f 08                	jg     801109 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801109:	83 ec 0c             	sub    $0xc,%esp
  80110c:	50                   	push   %eax
  80110d:	6a 09                	push   $0x9
  80110f:	68 a4 32 80 00       	push   $0x8032a4
  801114:	6a 43                	push   $0x43
  801116:	68 c1 32 80 00       	push   $0x8032c1
  80111b:	e8 6e f2 ff ff       	call   80038e <_panic>

00801120 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801134:	b8 0a 00 00 00       	mov    $0xa,%eax
  801139:	89 df                	mov    %ebx,%edi
  80113b:	89 de                	mov    %ebx,%esi
  80113d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113f:	85 c0                	test   %eax,%eax
  801141:	7f 08                	jg     80114b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	50                   	push   %eax
  80114f:	6a 0a                	push   $0xa
  801151:	68 a4 32 80 00       	push   $0x8032a4
  801156:	6a 43                	push   $0x43
  801158:	68 c1 32 80 00       	push   $0x8032c1
  80115d:	e8 2c f2 ff ff       	call   80038e <_panic>

00801162 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	57                   	push   %edi
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
	asm volatile("int %1\n"
  801168:	8b 55 08             	mov    0x8(%ebp),%edx
  80116b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801173:	be 00 00 00 00       	mov    $0x0,%esi
  801178:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80117b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80117e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5f                   	pop    %edi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80118e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	b8 0d 00 00 00       	mov    $0xd,%eax
  80119b:	89 cb                	mov    %ecx,%ebx
  80119d:	89 cf                	mov    %ecx,%edi
  80119f:	89 ce                	mov    %ecx,%esi
  8011a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	7f 08                	jg     8011af <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011aa:	5b                   	pop    %ebx
  8011ab:	5e                   	pop    %esi
  8011ac:	5f                   	pop    %edi
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	50                   	push   %eax
  8011b3:	6a 0d                	push   $0xd
  8011b5:	68 a4 32 80 00       	push   $0x8032a4
  8011ba:	6a 43                	push   $0x43
  8011bc:	68 c1 32 80 00       	push   $0x8032c1
  8011c1:	e8 c8 f1 ff ff       	call   80038e <_panic>

008011c6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011dc:	89 df                	mov    %ebx,%edi
  8011de:	89 de                	mov    %ebx,%esi
  8011e0:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8011e2:	5b                   	pop    %ebx
  8011e3:	5e                   	pop    %esi
  8011e4:	5f                   	pop    %edi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    

008011e7 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	57                   	push   %edi
  8011eb:	56                   	push   %esi
  8011ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011fa:	89 cb                	mov    %ecx,%ebx
  8011fc:	89 cf                	mov    %ecx,%edi
  8011fe:	89 ce                	mov    %ecx,%esi
  801200:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801202:	5b                   	pop    %ebx
  801203:	5e                   	pop    %esi
  801204:	5f                   	pop    %edi
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    

00801207 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	57                   	push   %edi
  80120b:	56                   	push   %esi
  80120c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120d:	ba 00 00 00 00       	mov    $0x0,%edx
  801212:	b8 10 00 00 00       	mov    $0x10,%eax
  801217:	89 d1                	mov    %edx,%ecx
  801219:	89 d3                	mov    %edx,%ebx
  80121b:	89 d7                	mov    %edx,%edi
  80121d:	89 d6                	mov    %edx,%esi
  80121f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    

00801226 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
  801234:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801237:	b8 11 00 00 00       	mov    $0x11,%eax
  80123c:	89 df                	mov    %ebx,%edi
  80123e:	89 de                	mov    %ebx,%esi
  801240:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801242:	5b                   	pop    %ebx
  801243:	5e                   	pop    %esi
  801244:	5f                   	pop    %edi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	57                   	push   %edi
  80124b:	56                   	push   %esi
  80124c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801252:	8b 55 08             	mov    0x8(%ebp),%edx
  801255:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801258:	b8 12 00 00 00       	mov    $0x12,%eax
  80125d:	89 df                	mov    %ebx,%edi
  80125f:	89 de                	mov    %ebx,%esi
  801261:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	57                   	push   %edi
  80126c:	56                   	push   %esi
  80126d:	53                   	push   %ebx
  80126e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801271:	bb 00 00 00 00       	mov    $0x0,%ebx
  801276:	8b 55 08             	mov    0x8(%ebp),%edx
  801279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127c:	b8 13 00 00 00       	mov    $0x13,%eax
  801281:	89 df                	mov    %ebx,%edi
  801283:	89 de                	mov    %ebx,%esi
  801285:	cd 30                	int    $0x30
	if(check && ret > 0)
  801287:	85 c0                	test   %eax,%eax
  801289:	7f 08                	jg     801293 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	50                   	push   %eax
  801297:	6a 13                	push   $0x13
  801299:	68 a4 32 80 00       	push   $0x8032a4
  80129e:	6a 43                	push   $0x43
  8012a0:	68 c1 32 80 00       	push   $0x8032c1
  8012a5:	e8 e4 f0 ff ff       	call   80038e <_panic>

008012aa <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012b4:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012b6:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012ba:	0f 84 99 00 00 00    	je     801359 <pgfault+0xaf>
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	c1 ea 16             	shr    $0x16,%edx
  8012c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cc:	f6 c2 01             	test   $0x1,%dl
  8012cf:	0f 84 84 00 00 00    	je     801359 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	c1 ea 0c             	shr    $0xc,%edx
  8012da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e1:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012e7:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012ed:	75 6a                	jne    801359 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  8012ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f4:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012f6:	83 ec 04             	sub    $0x4,%esp
  8012f9:	6a 07                	push   $0x7
  8012fb:	68 00 f0 7f 00       	push   $0x7ff000
  801300:	6a 00                	push   $0x0
  801302:	e8 ce fc ff ff       	call   800fd5 <sys_page_alloc>
	if(ret < 0)
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	85 c0                	test   %eax,%eax
  80130c:	78 5f                	js     80136d <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	68 00 10 00 00       	push   $0x1000
  801316:	53                   	push   %ebx
  801317:	68 00 f0 7f 00       	push   $0x7ff000
  80131c:	e8 b2 fa ff ff       	call   800dd3 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801321:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801328:	53                   	push   %ebx
  801329:	6a 00                	push   $0x0
  80132b:	68 00 f0 7f 00       	push   $0x7ff000
  801330:	6a 00                	push   $0x0
  801332:	e8 e1 fc ff ff       	call   801018 <sys_page_map>
	if(ret < 0)
  801337:	83 c4 20             	add    $0x20,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 43                	js     801381 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	68 00 f0 7f 00       	push   $0x7ff000
  801346:	6a 00                	push   $0x0
  801348:	e8 0d fd ff ff       	call   80105a <sys_page_unmap>
	if(ret < 0)
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	78 41                	js     801395 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801357:	c9                   	leave  
  801358:	c3                   	ret    
		panic("panic at pgfault()\n");
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	68 cf 32 80 00       	push   $0x8032cf
  801361:	6a 26                	push   $0x26
  801363:	68 e3 32 80 00       	push   $0x8032e3
  801368:	e8 21 f0 ff ff       	call   80038e <_panic>
		panic("panic in sys_page_alloc()\n");
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 ee 32 80 00       	push   $0x8032ee
  801375:	6a 31                	push   $0x31
  801377:	68 e3 32 80 00       	push   $0x8032e3
  80137c:	e8 0d f0 ff ff       	call   80038e <_panic>
		panic("panic in sys_page_map()\n");
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	68 09 33 80 00       	push   $0x803309
  801389:	6a 36                	push   $0x36
  80138b:	68 e3 32 80 00       	push   $0x8032e3
  801390:	e8 f9 ef ff ff       	call   80038e <_panic>
		panic("panic in sys_page_unmap()\n");
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	68 22 33 80 00       	push   $0x803322
  80139d:	6a 39                	push   $0x39
  80139f:	68 e3 32 80 00       	push   $0x8032e3
  8013a4:	e8 e5 ef ff ff       	call   80038e <_panic>

008013a9 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
  8013ae:	89 c6                	mov    %eax,%esi
  8013b0:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	68 c0 33 80 00       	push   $0x8033c0
  8013ba:	68 e7 2e 80 00       	push   $0x802ee7
  8013bf:	e8 c0 f0 ff ff       	call   800484 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8013c4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	f6 c4 04             	test   $0x4,%ah
  8013d1:	75 45                	jne    801418 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8013d3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013da:	83 e0 07             	and    $0x7,%eax
  8013dd:	83 f8 07             	cmp    $0x7,%eax
  8013e0:	74 6e                	je     801450 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8013e2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013e9:	25 05 08 00 00       	and    $0x805,%eax
  8013ee:	3d 05 08 00 00       	cmp    $0x805,%eax
  8013f3:	0f 84 b5 00 00 00    	je     8014ae <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8013f9:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801400:	83 e0 05             	and    $0x5,%eax
  801403:	83 f8 05             	cmp    $0x5,%eax
  801406:	0f 84 d6 00 00 00    	je     8014e2 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801418:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80141f:	c1 e3 0c             	shl    $0xc,%ebx
  801422:	83 ec 0c             	sub    $0xc,%esp
  801425:	25 07 0e 00 00       	and    $0xe07,%eax
  80142a:	50                   	push   %eax
  80142b:	53                   	push   %ebx
  80142c:	56                   	push   %esi
  80142d:	53                   	push   %ebx
  80142e:	6a 00                	push   $0x0
  801430:	e8 e3 fb ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  801435:	83 c4 20             	add    $0x20,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	79 d0                	jns    80140c <duppage+0x63>
			panic("sys_page_map() panic\n");
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	68 3d 33 80 00       	push   $0x80333d
  801444:	6a 55                	push   $0x55
  801446:	68 e3 32 80 00       	push   $0x8032e3
  80144b:	e8 3e ef ff ff       	call   80038e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801450:	c1 e3 0c             	shl    $0xc,%ebx
  801453:	83 ec 0c             	sub    $0xc,%esp
  801456:	68 05 08 00 00       	push   $0x805
  80145b:	53                   	push   %ebx
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	6a 00                	push   $0x0
  801460:	e8 b3 fb ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  801465:	83 c4 20             	add    $0x20,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 2e                	js     80149a <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	68 05 08 00 00       	push   $0x805
  801474:	53                   	push   %ebx
  801475:	6a 00                	push   $0x0
  801477:	53                   	push   %ebx
  801478:	6a 00                	push   $0x0
  80147a:	e8 99 fb ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  80147f:	83 c4 20             	add    $0x20,%esp
  801482:	85 c0                	test   %eax,%eax
  801484:	79 86                	jns    80140c <duppage+0x63>
			panic("sys_page_map() panic\n");
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	68 3d 33 80 00       	push   $0x80333d
  80148e:	6a 60                	push   $0x60
  801490:	68 e3 32 80 00       	push   $0x8032e3
  801495:	e8 f4 ee ff ff       	call   80038e <_panic>
			panic("sys_page_map() panic\n");
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	68 3d 33 80 00       	push   $0x80333d
  8014a2:	6a 5c                	push   $0x5c
  8014a4:	68 e3 32 80 00       	push   $0x8032e3
  8014a9:	e8 e0 ee ff ff       	call   80038e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014ae:	c1 e3 0c             	shl    $0xc,%ebx
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	68 05 08 00 00       	push   $0x805
  8014b9:	53                   	push   %ebx
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	6a 00                	push   $0x0
  8014be:	e8 55 fb ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  8014c3:	83 c4 20             	add    $0x20,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	0f 89 3e ff ff ff    	jns    80140c <duppage+0x63>
			panic("sys_page_map() panic\n");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 3d 33 80 00       	push   $0x80333d
  8014d6:	6a 67                	push   $0x67
  8014d8:	68 e3 32 80 00       	push   $0x8032e3
  8014dd:	e8 ac ee ff ff       	call   80038e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8014e2:	c1 e3 0c             	shl    $0xc,%ebx
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	6a 05                	push   $0x5
  8014ea:	53                   	push   %ebx
  8014eb:	56                   	push   %esi
  8014ec:	53                   	push   %ebx
  8014ed:	6a 00                	push   $0x0
  8014ef:	e8 24 fb ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  8014f4:	83 c4 20             	add    $0x20,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	0f 89 0d ff ff ff    	jns    80140c <duppage+0x63>
			panic("sys_page_map() panic\n");
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	68 3d 33 80 00       	push   $0x80333d
  801507:	6a 6e                	push   $0x6e
  801509:	68 e3 32 80 00       	push   $0x8032e3
  80150e:	e8 7b ee ff ff       	call   80038e <_panic>

00801513 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	57                   	push   %edi
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80151c:	68 aa 12 80 00       	push   $0x8012aa
  801521:	e8 24 14 00 00       	call   80294a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801526:	b8 07 00 00 00       	mov    $0x7,%eax
  80152b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	78 27                	js     80155b <fork+0x48>
  801534:	89 c6                	mov    %eax,%esi
  801536:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801538:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80153d:	75 48                	jne    801587 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80153f:	e8 53 fa ff ff       	call   800f97 <sys_getenvid>
  801544:	25 ff 03 00 00       	and    $0x3ff,%eax
  801549:	c1 e0 07             	shl    $0x7,%eax
  80154c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801551:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801556:	e9 90 00 00 00       	jmp    8015eb <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	68 54 33 80 00       	push   $0x803354
  801563:	68 8d 00 00 00       	push   $0x8d
  801568:	68 e3 32 80 00       	push   $0x8032e3
  80156d:	e8 1c ee ff ff       	call   80038e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801572:	89 f8                	mov    %edi,%eax
  801574:	e8 30 fe ff ff       	call   8013a9 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801579:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80157f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801585:	74 26                	je     8015ad <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801587:	89 d8                	mov    %ebx,%eax
  801589:	c1 e8 16             	shr    $0x16,%eax
  80158c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801593:	a8 01                	test   $0x1,%al
  801595:	74 e2                	je     801579 <fork+0x66>
  801597:	89 da                	mov    %ebx,%edx
  801599:	c1 ea 0c             	shr    $0xc,%edx
  80159c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015a3:	83 e0 05             	and    $0x5,%eax
  8015a6:	83 f8 05             	cmp    $0x5,%eax
  8015a9:	75 ce                	jne    801579 <fork+0x66>
  8015ab:	eb c5                	jmp    801572 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	6a 07                	push   $0x7
  8015b2:	68 00 f0 bf ee       	push   $0xeebff000
  8015b7:	56                   	push   %esi
  8015b8:	e8 18 fa ff ff       	call   800fd5 <sys_page_alloc>
	if(ret < 0)
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 31                	js     8015f5 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	68 b9 29 80 00       	push   $0x8029b9
  8015cc:	56                   	push   %esi
  8015cd:	e8 4e fb ff ff       	call   801120 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 33                	js     80160c <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	6a 02                	push   $0x2
  8015de:	56                   	push   %esi
  8015df:	e8 b8 fa ff ff       	call   80109c <sys_env_set_status>
	if(ret < 0)
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 38                	js     801623 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8015eb:	89 f0                	mov    %esi,%eax
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015f5:	83 ec 04             	sub    $0x4,%esp
  8015f8:	68 ee 32 80 00       	push   $0x8032ee
  8015fd:	68 99 00 00 00       	push   $0x99
  801602:	68 e3 32 80 00       	push   $0x8032e3
  801607:	e8 82 ed ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 78 33 80 00       	push   $0x803378
  801614:	68 9c 00 00 00       	push   $0x9c
  801619:	68 e3 32 80 00       	push   $0x8032e3
  80161e:	e8 6b ed ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_status()\n");
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 a0 33 80 00       	push   $0x8033a0
  80162b:	68 9f 00 00 00       	push   $0x9f
  801630:	68 e3 32 80 00       	push   $0x8032e3
  801635:	e8 54 ed ff ff       	call   80038e <_panic>

0080163a <sfork>:

// Challenge!
int
sfork(void)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	57                   	push   %edi
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
  801640:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801643:	68 aa 12 80 00       	push   $0x8012aa
  801648:	e8 fd 12 00 00       	call   80294a <set_pgfault_handler>
  80164d:	b8 07 00 00 00       	mov    $0x7,%eax
  801652:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 27                	js     801682 <sfork+0x48>
  80165b:	89 c7                	mov    %eax,%edi
  80165d:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80165f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801664:	75 55                	jne    8016bb <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801666:	e8 2c f9 ff ff       	call   800f97 <sys_getenvid>
  80166b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801670:	c1 e0 07             	shl    $0x7,%eax
  801673:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801678:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80167d:	e9 d4 00 00 00       	jmp    801756 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 54 33 80 00       	push   $0x803354
  80168a:	68 b0 00 00 00       	push   $0xb0
  80168f:	68 e3 32 80 00       	push   $0x8032e3
  801694:	e8 f5 ec ff ff       	call   80038e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801699:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80169e:	89 f0                	mov    %esi,%eax
  8016a0:	e8 04 fd ff ff       	call   8013a9 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8016a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016ab:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8016b1:	77 65                	ja     801718 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8016b3:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8016b9:	74 de                	je     801699 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8016bb:	89 d8                	mov    %ebx,%eax
  8016bd:	c1 e8 16             	shr    $0x16,%eax
  8016c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016c7:	a8 01                	test   $0x1,%al
  8016c9:	74 da                	je     8016a5 <sfork+0x6b>
  8016cb:	89 da                	mov    %ebx,%edx
  8016cd:	c1 ea 0c             	shr    $0xc,%edx
  8016d0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016d7:	83 e0 05             	and    $0x5,%eax
  8016da:	83 f8 05             	cmp    $0x5,%eax
  8016dd:	75 c6                	jne    8016a5 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8016df:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8016e6:	c1 e2 0c             	shl    $0xc,%edx
  8016e9:	83 ec 0c             	sub    $0xc,%esp
  8016ec:	83 e0 07             	and    $0x7,%eax
  8016ef:	50                   	push   %eax
  8016f0:	52                   	push   %edx
  8016f1:	56                   	push   %esi
  8016f2:	52                   	push   %edx
  8016f3:	6a 00                	push   $0x0
  8016f5:	e8 1e f9 ff ff       	call   801018 <sys_page_map>
  8016fa:	83 c4 20             	add    $0x20,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	74 a4                	je     8016a5 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	68 3d 33 80 00       	push   $0x80333d
  801709:	68 bb 00 00 00       	push   $0xbb
  80170e:	68 e3 32 80 00       	push   $0x8032e3
  801713:	e8 76 ec ff ff       	call   80038e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	6a 07                	push   $0x7
  80171d:	68 00 f0 bf ee       	push   $0xeebff000
  801722:	57                   	push   %edi
  801723:	e8 ad f8 ff ff       	call   800fd5 <sys_page_alloc>
	if(ret < 0)
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 31                	js     801760 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	68 b9 29 80 00       	push   $0x8029b9
  801737:	57                   	push   %edi
  801738:	e8 e3 f9 ff ff       	call   801120 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 33                	js     801777 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	6a 02                	push   $0x2
  801749:	57                   	push   %edi
  80174a:	e8 4d f9 ff ff       	call   80109c <sys_env_set_status>
	if(ret < 0)
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	85 c0                	test   %eax,%eax
  801754:	78 38                	js     80178e <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801756:	89 f8                	mov    %edi,%eax
  801758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5f                   	pop    %edi
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	68 ee 32 80 00       	push   $0x8032ee
  801768:	68 c1 00 00 00       	push   $0xc1
  80176d:	68 e3 32 80 00       	push   $0x8032e3
  801772:	e8 17 ec ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 78 33 80 00       	push   $0x803378
  80177f:	68 c4 00 00 00       	push   $0xc4
  801784:	68 e3 32 80 00       	push   $0x8032e3
  801789:	e8 00 ec ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_status()\n");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 a0 33 80 00       	push   $0x8033a0
  801796:	68 c7 00 00 00       	push   $0xc7
  80179b:	68 e3 32 80 00       	push   $0x8032e3
  8017a0:	e8 e9 eb ff ff       	call   80038e <_panic>

008017a5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	05 00 00 00 30       	add    $0x30000000,%eax
  8017b0:	c1 e8 0c             	shr    $0xc,%eax
}
  8017b3:	5d                   	pop    %ebp
  8017b4:	c3                   	ret    

008017b5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    

008017cc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017d4:	89 c2                	mov    %eax,%edx
  8017d6:	c1 ea 16             	shr    $0x16,%edx
  8017d9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017e0:	f6 c2 01             	test   $0x1,%dl
  8017e3:	74 2d                	je     801812 <fd_alloc+0x46>
  8017e5:	89 c2                	mov    %eax,%edx
  8017e7:	c1 ea 0c             	shr    $0xc,%edx
  8017ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017f1:	f6 c2 01             	test   $0x1,%dl
  8017f4:	74 1c                	je     801812 <fd_alloc+0x46>
  8017f6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017fb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801800:	75 d2                	jne    8017d4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80180b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801810:	eb 0a                	jmp    80181c <fd_alloc+0x50>
			*fd_store = fd;
  801812:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801815:	89 01                	mov    %eax,(%ecx)
			return 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801824:	83 f8 1f             	cmp    $0x1f,%eax
  801827:	77 30                	ja     801859 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801829:	c1 e0 0c             	shl    $0xc,%eax
  80182c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801831:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801837:	f6 c2 01             	test   $0x1,%dl
  80183a:	74 24                	je     801860 <fd_lookup+0x42>
  80183c:	89 c2                	mov    %eax,%edx
  80183e:	c1 ea 0c             	shr    $0xc,%edx
  801841:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801848:	f6 c2 01             	test   $0x1,%dl
  80184b:	74 1a                	je     801867 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	89 02                	mov    %eax,(%edx)
	return 0;
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801857:	5d                   	pop    %ebp
  801858:	c3                   	ret    
		return -E_INVAL;
  801859:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185e:	eb f7                	jmp    801857 <fd_lookup+0x39>
		return -E_INVAL;
  801860:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801865:	eb f0                	jmp    801857 <fd_lookup+0x39>
  801867:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186c:	eb e9                	jmp    801857 <fd_lookup+0x39>

0080186e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
  80187c:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801881:	39 08                	cmp    %ecx,(%eax)
  801883:	74 38                	je     8018bd <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801885:	83 c2 01             	add    $0x1,%edx
  801888:	8b 04 95 44 34 80 00 	mov    0x803444(,%edx,4),%eax
  80188f:	85 c0                	test   %eax,%eax
  801891:	75 ee                	jne    801881 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801893:	a1 08 50 80 00       	mov    0x805008,%eax
  801898:	8b 40 48             	mov    0x48(%eax),%eax
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	51                   	push   %ecx
  80189f:	50                   	push   %eax
  8018a0:	68 c8 33 80 00       	push   $0x8033c8
  8018a5:	e8 da eb ff ff       	call   800484 <cprintf>
	*dev = 0;
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    
			*dev = devtab[i];
  8018bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb f2                	jmp    8018bb <dev_lookup+0x4d>

008018c9 <fd_close>:
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	57                   	push   %edi
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	83 ec 24             	sub    $0x24,%esp
  8018d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8018d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018e5:	50                   	push   %eax
  8018e6:	e8 33 ff ff ff       	call   80181e <fd_lookup>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 05                	js     8018f9 <fd_close+0x30>
	    || fd != fd2)
  8018f4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018f7:	74 16                	je     80190f <fd_close+0x46>
		return (must_exist ? r : 0);
  8018f9:	89 f8                	mov    %edi,%eax
  8018fb:	84 c0                	test   %al,%al
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801902:	0f 44 d8             	cmove  %eax,%ebx
}
  801905:	89 d8                	mov    %ebx,%eax
  801907:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190a:	5b                   	pop    %ebx
  80190b:	5e                   	pop    %esi
  80190c:	5f                   	pop    %edi
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80190f:	83 ec 08             	sub    $0x8,%esp
  801912:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801915:	50                   	push   %eax
  801916:	ff 36                	pushl  (%esi)
  801918:	e8 51 ff ff ff       	call   80186e <dev_lookup>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 1a                	js     801940 <fd_close+0x77>
		if (dev->dev_close)
  801926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801929:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80192c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801931:	85 c0                	test   %eax,%eax
  801933:	74 0b                	je     801940 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801935:	83 ec 0c             	sub    $0xc,%esp
  801938:	56                   	push   %esi
  801939:	ff d0                	call   *%eax
  80193b:	89 c3                	mov    %eax,%ebx
  80193d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	56                   	push   %esi
  801944:	6a 00                	push   $0x0
  801946:	e8 0f f7 ff ff       	call   80105a <sys_page_unmap>
	return r;
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	eb b5                	jmp    801905 <fd_close+0x3c>

00801950 <close>:

int
close(int fdnum)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801959:	50                   	push   %eax
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	e8 bc fe ff ff       	call   80181e <fd_lookup>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	79 02                	jns    80196b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    
		return fd_close(fd, 1);
  80196b:	83 ec 08             	sub    $0x8,%esp
  80196e:	6a 01                	push   $0x1
  801970:	ff 75 f4             	pushl  -0xc(%ebp)
  801973:	e8 51 ff ff ff       	call   8018c9 <fd_close>
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	eb ec                	jmp    801969 <close+0x19>

0080197d <close_all>:

void
close_all(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	53                   	push   %ebx
  801981:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801984:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801989:	83 ec 0c             	sub    $0xc,%esp
  80198c:	53                   	push   %ebx
  80198d:	e8 be ff ff ff       	call   801950 <close>
	for (i = 0; i < MAXFD; i++)
  801992:	83 c3 01             	add    $0x1,%ebx
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	83 fb 20             	cmp    $0x20,%ebx
  80199b:	75 ec                	jne    801989 <close_all+0xc>
}
  80199d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019ae:	50                   	push   %eax
  8019af:	ff 75 08             	pushl  0x8(%ebp)
  8019b2:	e8 67 fe ff ff       	call   80181e <fd_lookup>
  8019b7:	89 c3                	mov    %eax,%ebx
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	0f 88 81 00 00 00    	js     801a45 <dup+0xa3>
		return r;
	close(newfdnum);
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	e8 81 ff ff ff       	call   801950 <close>

	newfd = INDEX2FD(newfdnum);
  8019cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019d2:	c1 e6 0c             	shl    $0xc,%esi
  8019d5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019db:	83 c4 04             	add    $0x4,%esp
  8019de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019e1:	e8 cf fd ff ff       	call   8017b5 <fd2data>
  8019e6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019e8:	89 34 24             	mov    %esi,(%esp)
  8019eb:	e8 c5 fd ff ff       	call   8017b5 <fd2data>
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019f5:	89 d8                	mov    %ebx,%eax
  8019f7:	c1 e8 16             	shr    $0x16,%eax
  8019fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a01:	a8 01                	test   $0x1,%al
  801a03:	74 11                	je     801a16 <dup+0x74>
  801a05:	89 d8                	mov    %ebx,%eax
  801a07:	c1 e8 0c             	shr    $0xc,%eax
  801a0a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a11:	f6 c2 01             	test   $0x1,%dl
  801a14:	75 39                	jne    801a4f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a19:	89 d0                	mov    %edx,%eax
  801a1b:	c1 e8 0c             	shr    $0xc,%eax
  801a1e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	25 07 0e 00 00       	and    $0xe07,%eax
  801a2d:	50                   	push   %eax
  801a2e:	56                   	push   %esi
  801a2f:	6a 00                	push   $0x0
  801a31:	52                   	push   %edx
  801a32:	6a 00                	push   $0x0
  801a34:	e8 df f5 ff ff       	call   801018 <sys_page_map>
  801a39:	89 c3                	mov    %eax,%ebx
  801a3b:	83 c4 20             	add    $0x20,%esp
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 31                	js     801a73 <dup+0xd1>
		goto err;

	return newfdnum;
  801a42:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a45:	89 d8                	mov    %ebx,%eax
  801a47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5f                   	pop    %edi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a4f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	25 07 0e 00 00       	and    $0xe07,%eax
  801a5e:	50                   	push   %eax
  801a5f:	57                   	push   %edi
  801a60:	6a 00                	push   $0x0
  801a62:	53                   	push   %ebx
  801a63:	6a 00                	push   $0x0
  801a65:	e8 ae f5 ff ff       	call   801018 <sys_page_map>
  801a6a:	89 c3                	mov    %eax,%ebx
  801a6c:	83 c4 20             	add    $0x20,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	79 a3                	jns    801a16 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	56                   	push   %esi
  801a77:	6a 00                	push   $0x0
  801a79:	e8 dc f5 ff ff       	call   80105a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a7e:	83 c4 08             	add    $0x8,%esp
  801a81:	57                   	push   %edi
  801a82:	6a 00                	push   $0x0
  801a84:	e8 d1 f5 ff ff       	call   80105a <sys_page_unmap>
	return r;
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	eb b7                	jmp    801a45 <dup+0xa3>

00801a8e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	53                   	push   %ebx
  801a92:	83 ec 1c             	sub    $0x1c,%esp
  801a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	53                   	push   %ebx
  801a9d:	e8 7c fd ff ff       	call   80181e <fd_lookup>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 3f                	js     801ae8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aaf:	50                   	push   %eax
  801ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab3:	ff 30                	pushl  (%eax)
  801ab5:	e8 b4 fd ff ff       	call   80186e <dev_lookup>
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 27                	js     801ae8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ac1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac4:	8b 42 08             	mov    0x8(%edx),%eax
  801ac7:	83 e0 03             	and    $0x3,%eax
  801aca:	83 f8 01             	cmp    $0x1,%eax
  801acd:	74 1e                	je     801aed <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad2:	8b 40 08             	mov    0x8(%eax),%eax
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	74 35                	je     801b0e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	52                   	push   %edx
  801ae3:	ff d0                	call   *%eax
  801ae5:	83 c4 10             	add    $0x10,%esp
}
  801ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801aed:	a1 08 50 80 00       	mov    0x805008,%eax
  801af2:	8b 40 48             	mov    0x48(%eax),%eax
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	53                   	push   %ebx
  801af9:	50                   	push   %eax
  801afa:	68 09 34 80 00       	push   $0x803409
  801aff:	e8 80 e9 ff ff       	call   800484 <cprintf>
		return -E_INVAL;
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b0c:	eb da                	jmp    801ae8 <read+0x5a>
		return -E_NOT_SUPP;
  801b0e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b13:	eb d3                	jmp    801ae8 <read+0x5a>

00801b15 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	57                   	push   %edi
  801b19:	56                   	push   %esi
  801b1a:	53                   	push   %ebx
  801b1b:	83 ec 0c             	sub    $0xc,%esp
  801b1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b21:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b24:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b29:	39 f3                	cmp    %esi,%ebx
  801b2b:	73 23                	jae    801b50 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	89 f0                	mov    %esi,%eax
  801b32:	29 d8                	sub    %ebx,%eax
  801b34:	50                   	push   %eax
  801b35:	89 d8                	mov    %ebx,%eax
  801b37:	03 45 0c             	add    0xc(%ebp),%eax
  801b3a:	50                   	push   %eax
  801b3b:	57                   	push   %edi
  801b3c:	e8 4d ff ff ff       	call   801a8e <read>
		if (m < 0)
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 06                	js     801b4e <readn+0x39>
			return m;
		if (m == 0)
  801b48:	74 06                	je     801b50 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b4a:	01 c3                	add    %eax,%ebx
  801b4c:	eb db                	jmp    801b29 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b4e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 1c             	sub    $0x1c,%esp
  801b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	53                   	push   %ebx
  801b69:	e8 b0 fc ff ff       	call   80181e <fd_lookup>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	85 c0                	test   %eax,%eax
  801b73:	78 3a                	js     801baf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b75:	83 ec 08             	sub    $0x8,%esp
  801b78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7b:	50                   	push   %eax
  801b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7f:	ff 30                	pushl  (%eax)
  801b81:	e8 e8 fc ff ff       	call   80186e <dev_lookup>
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 22                	js     801baf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b90:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b94:	74 1e                	je     801bb4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b99:	8b 52 0c             	mov    0xc(%edx),%edx
  801b9c:	85 d2                	test   %edx,%edx
  801b9e:	74 35                	je     801bd5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	ff 75 10             	pushl  0x10(%ebp)
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	50                   	push   %eax
  801baa:	ff d2                	call   *%edx
  801bac:	83 c4 10             	add    $0x10,%esp
}
  801baf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb4:	a1 08 50 80 00       	mov    0x805008,%eax
  801bb9:	8b 40 48             	mov    0x48(%eax),%eax
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	53                   	push   %ebx
  801bc0:	50                   	push   %eax
  801bc1:	68 25 34 80 00       	push   $0x803425
  801bc6:	e8 b9 e8 ff ff       	call   800484 <cprintf>
		return -E_INVAL;
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd3:	eb da                	jmp    801baf <write+0x55>
		return -E_NOT_SUPP;
  801bd5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bda:	eb d3                	jmp    801baf <write+0x55>

00801bdc <seek>:

int
seek(int fdnum, off_t offset)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be5:	50                   	push   %eax
  801be6:	ff 75 08             	pushl  0x8(%ebp)
  801be9:	e8 30 fc ff ff       	call   80181e <fd_lookup>
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 0e                	js     801c03 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
  801c09:	83 ec 1c             	sub    $0x1c,%esp
  801c0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c12:	50                   	push   %eax
  801c13:	53                   	push   %ebx
  801c14:	e8 05 fc ff ff       	call   80181e <fd_lookup>
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 37                	js     801c57 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c20:	83 ec 08             	sub    $0x8,%esp
  801c23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c26:	50                   	push   %eax
  801c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2a:	ff 30                	pushl  (%eax)
  801c2c:	e8 3d fc ff ff       	call   80186e <dev_lookup>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 1f                	js     801c57 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c3f:	74 1b                	je     801c5c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c44:	8b 52 18             	mov    0x18(%edx),%edx
  801c47:	85 d2                	test   %edx,%edx
  801c49:	74 32                	je     801c7d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	50                   	push   %eax
  801c52:	ff d2                	call   *%edx
  801c54:	83 c4 10             	add    $0x10,%esp
}
  801c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c5c:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c61:	8b 40 48             	mov    0x48(%eax),%eax
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	53                   	push   %ebx
  801c68:	50                   	push   %eax
  801c69:	68 e8 33 80 00       	push   $0x8033e8
  801c6e:	e8 11 e8 ff ff       	call   800484 <cprintf>
		return -E_INVAL;
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c7b:	eb da                	jmp    801c57 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c7d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c82:	eb d3                	jmp    801c57 <ftruncate+0x52>

00801c84 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
  801c8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c8e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 84 fb ff ff       	call   80181e <fd_lookup>
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	78 4b                	js     801cec <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ca1:	83 ec 08             	sub    $0x8,%esp
  801ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca7:	50                   	push   %eax
  801ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cab:	ff 30                	pushl  (%eax)
  801cad:	e8 bc fb ff ff       	call   80186e <dev_lookup>
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 33                	js     801cec <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cc0:	74 2f                	je     801cf1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cc2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cc5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ccc:	00 00 00 
	stat->st_isdir = 0;
  801ccf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cd6:	00 00 00 
	stat->st_dev = dev;
  801cd9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cdf:	83 ec 08             	sub    $0x8,%esp
  801ce2:	53                   	push   %ebx
  801ce3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce6:	ff 50 14             	call   *0x14(%eax)
  801ce9:	83 c4 10             	add    $0x10,%esp
}
  801cec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    
		return -E_NOT_SUPP;
  801cf1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cf6:	eb f4                	jmp    801cec <fstat+0x68>

00801cf8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	56                   	push   %esi
  801cfc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cfd:	83 ec 08             	sub    $0x8,%esp
  801d00:	6a 00                	push   $0x0
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	e8 22 02 00 00       	call   801f2c <open>
  801d0a:	89 c3                	mov    %eax,%ebx
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 1b                	js     801d2e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	ff 75 0c             	pushl  0xc(%ebp)
  801d19:	50                   	push   %eax
  801d1a:	e8 65 ff ff ff       	call   801c84 <fstat>
  801d1f:	89 c6                	mov    %eax,%esi
	close(fd);
  801d21:	89 1c 24             	mov    %ebx,(%esp)
  801d24:	e8 27 fc ff ff       	call   801950 <close>
	return r;
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	89 f3                	mov    %esi,%ebx
}
  801d2e:	89 d8                	mov    %ebx,%eax
  801d30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    

00801d37 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	89 c6                	mov    %eax,%esi
  801d3e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d40:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d47:	74 27                	je     801d70 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d49:	6a 07                	push   $0x7
  801d4b:	68 00 60 80 00       	push   $0x806000
  801d50:	56                   	push   %esi
  801d51:	ff 35 00 50 80 00    	pushl  0x805000
  801d57:	e8 ec 0c 00 00       	call   802a48 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d5c:	83 c4 0c             	add    $0xc,%esp
  801d5f:	6a 00                	push   $0x0
  801d61:	53                   	push   %ebx
  801d62:	6a 00                	push   $0x0
  801d64:	e8 76 0c 00 00       	call   8029df <ipc_recv>
}
  801d69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	6a 01                	push   $0x1
  801d75:	e8 26 0d 00 00       	call   802aa0 <ipc_find_env>
  801d7a:	a3 00 50 80 00       	mov    %eax,0x805000
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	eb c5                	jmp    801d49 <fsipc+0x12>

00801d84 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d90:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d98:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801da2:	b8 02 00 00 00       	mov    $0x2,%eax
  801da7:	e8 8b ff ff ff       	call   801d37 <fsipc>
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <devfile_flush>:
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dba:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc4:	b8 06 00 00 00       	mov    $0x6,%eax
  801dc9:	e8 69 ff ff ff       	call   801d37 <fsipc>
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <devfile_stat>:
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 04             	sub    $0x4,%esp
  801dd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  801de0:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801de5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dea:	b8 05 00 00 00       	mov    $0x5,%eax
  801def:	e8 43 ff ff ff       	call   801d37 <fsipc>
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 2c                	js     801e24 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801df8:	83 ec 08             	sub    $0x8,%esp
  801dfb:	68 00 60 80 00       	push   $0x806000
  801e00:	53                   	push   %ebx
  801e01:	e8 dd ed ff ff       	call   800be3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e06:	a1 80 60 80 00       	mov    0x806080,%eax
  801e0b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e11:	a1 84 60 80 00       	mov    0x806084,%eax
  801e16:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <devfile_write>:
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	53                   	push   %ebx
  801e2d:	83 ec 08             	sub    $0x8,%esp
  801e30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	8b 40 0c             	mov    0xc(%eax),%eax
  801e39:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e3e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e44:	53                   	push   %ebx
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	68 08 60 80 00       	push   $0x806008
  801e4d:	e8 81 ef ff ff       	call   800dd3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
  801e57:	b8 04 00 00 00       	mov    $0x4,%eax
  801e5c:	e8 d6 fe ff ff       	call   801d37 <fsipc>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 0b                	js     801e73 <devfile_write+0x4a>
	assert(r <= n);
  801e68:	39 d8                	cmp    %ebx,%eax
  801e6a:	77 0c                	ja     801e78 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e6c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e71:	7f 1e                	jg     801e91 <devfile_write+0x68>
}
  801e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    
	assert(r <= n);
  801e78:	68 58 34 80 00       	push   $0x803458
  801e7d:	68 5f 34 80 00       	push   $0x80345f
  801e82:	68 98 00 00 00       	push   $0x98
  801e87:	68 74 34 80 00       	push   $0x803474
  801e8c:	e8 fd e4 ff ff       	call   80038e <_panic>
	assert(r <= PGSIZE);
  801e91:	68 7f 34 80 00       	push   $0x80347f
  801e96:	68 5f 34 80 00       	push   $0x80345f
  801e9b:	68 99 00 00 00       	push   $0x99
  801ea0:	68 74 34 80 00       	push   $0x803474
  801ea5:	e8 e4 e4 ff ff       	call   80038e <_panic>

00801eaa <devfile_read>:
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	56                   	push   %esi
  801eae:	53                   	push   %ebx
  801eaf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ebd:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ec3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec8:	b8 03 00 00 00       	mov    $0x3,%eax
  801ecd:	e8 65 fe ff ff       	call   801d37 <fsipc>
  801ed2:	89 c3                	mov    %eax,%ebx
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 1f                	js     801ef7 <devfile_read+0x4d>
	assert(r <= n);
  801ed8:	39 f0                	cmp    %esi,%eax
  801eda:	77 24                	ja     801f00 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801edc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ee1:	7f 33                	jg     801f16 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ee3:	83 ec 04             	sub    $0x4,%esp
  801ee6:	50                   	push   %eax
  801ee7:	68 00 60 80 00       	push   $0x806000
  801eec:	ff 75 0c             	pushl  0xc(%ebp)
  801eef:	e8 7d ee ff ff       	call   800d71 <memmove>
	return r;
  801ef4:	83 c4 10             	add    $0x10,%esp
}
  801ef7:	89 d8                	mov    %ebx,%eax
  801ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    
	assert(r <= n);
  801f00:	68 58 34 80 00       	push   $0x803458
  801f05:	68 5f 34 80 00       	push   $0x80345f
  801f0a:	6a 7c                	push   $0x7c
  801f0c:	68 74 34 80 00       	push   $0x803474
  801f11:	e8 78 e4 ff ff       	call   80038e <_panic>
	assert(r <= PGSIZE);
  801f16:	68 7f 34 80 00       	push   $0x80347f
  801f1b:	68 5f 34 80 00       	push   $0x80345f
  801f20:	6a 7d                	push   $0x7d
  801f22:	68 74 34 80 00       	push   $0x803474
  801f27:	e8 62 e4 ff ff       	call   80038e <_panic>

00801f2c <open>:
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	56                   	push   %esi
  801f30:	53                   	push   %ebx
  801f31:	83 ec 1c             	sub    $0x1c,%esp
  801f34:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f37:	56                   	push   %esi
  801f38:	e8 6d ec ff ff       	call   800baa <strlen>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f45:	7f 6c                	jg     801fb3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f47:	83 ec 0c             	sub    $0xc,%esp
  801f4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4d:	50                   	push   %eax
  801f4e:	e8 79 f8 ff ff       	call   8017cc <fd_alloc>
  801f53:	89 c3                	mov    %eax,%ebx
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 3c                	js     801f98 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f5c:	83 ec 08             	sub    $0x8,%esp
  801f5f:	56                   	push   %esi
  801f60:	68 00 60 80 00       	push   $0x806000
  801f65:	e8 79 ec ff ff       	call   800be3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7a:	e8 b8 fd ff ff       	call   801d37 <fsipc>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 19                	js     801fa1 <open+0x75>
	return fd2num(fd);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8e:	e8 12 f8 ff ff       	call   8017a5 <fd2num>
  801f93:	89 c3                	mov    %eax,%ebx
  801f95:	83 c4 10             	add    $0x10,%esp
}
  801f98:	89 d8                	mov    %ebx,%eax
  801f9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9d:	5b                   	pop    %ebx
  801f9e:	5e                   	pop    %esi
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    
		fd_close(fd, 0);
  801fa1:	83 ec 08             	sub    $0x8,%esp
  801fa4:	6a 00                	push   $0x0
  801fa6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa9:	e8 1b f9 ff ff       	call   8018c9 <fd_close>
		return r;
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	eb e5                	jmp    801f98 <open+0x6c>
		return -E_BAD_PATH;
  801fb3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fb8:	eb de                	jmp    801f98 <open+0x6c>

00801fba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc5:	b8 08 00 00 00       	mov    $0x8,%eax
  801fca:	e8 68 fd ff ff       	call   801d37 <fsipc>
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fd7:	68 8b 34 80 00       	push   $0x80348b
  801fdc:	ff 75 0c             	pushl  0xc(%ebp)
  801fdf:	e8 ff eb ff ff       	call   800be3 <strcpy>
	return 0;
}
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <devsock_close>:
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	53                   	push   %ebx
  801fef:	83 ec 10             	sub    $0x10,%esp
  801ff2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ff5:	53                   	push   %ebx
  801ff6:	e8 e0 0a 00 00       	call   802adb <pageref>
  801ffb:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ffe:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802003:	83 f8 01             	cmp    $0x1,%eax
  802006:	74 07                	je     80200f <devsock_close+0x24>
}
  802008:	89 d0                	mov    %edx,%eax
  80200a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	ff 73 0c             	pushl  0xc(%ebx)
  802015:	e8 b9 02 00 00       	call   8022d3 <nsipc_close>
  80201a:	89 c2                	mov    %eax,%edx
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	eb e7                	jmp    802008 <devsock_close+0x1d>

00802021 <devsock_write>:
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802027:	6a 00                	push   $0x0
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	ff 70 0c             	pushl  0xc(%eax)
  802035:	e8 76 03 00 00       	call   8023b0 <nsipc_send>
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <devsock_read>:
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802042:	6a 00                	push   $0x0
  802044:	ff 75 10             	pushl  0x10(%ebp)
  802047:	ff 75 0c             	pushl  0xc(%ebp)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	ff 70 0c             	pushl  0xc(%eax)
  802050:	e8 ef 02 00 00       	call   802344 <nsipc_recv>
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <fd2sockid>:
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80205d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	e8 b7 f7 ff ff       	call   80181e <fd_lookup>
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 10                	js     80207e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  802077:	39 08                	cmp    %ecx,(%eax)
  802079:	75 05                	jne    802080 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80207b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    
		return -E_NOT_SUPP;
  802080:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802085:	eb f7                	jmp    80207e <fd2sockid+0x27>

00802087 <alloc_sockfd>:
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	56                   	push   %esi
  80208b:	53                   	push   %ebx
  80208c:	83 ec 1c             	sub    $0x1c,%esp
  80208f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802091:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802094:	50                   	push   %eax
  802095:	e8 32 f7 ff ff       	call   8017cc <fd_alloc>
  80209a:	89 c3                	mov    %eax,%ebx
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 43                	js     8020e6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	68 07 04 00 00       	push   $0x407
  8020ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ae:	6a 00                	push   $0x0
  8020b0:	e8 20 ef ff ff       	call   800fd5 <sys_page_alloc>
  8020b5:	89 c3                	mov    %eax,%ebx
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	78 28                	js     8020e6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8020c7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020d3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	50                   	push   %eax
  8020da:	e8 c6 f6 ff ff       	call   8017a5 <fd2num>
  8020df:	89 c3                	mov    %eax,%ebx
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	eb 0c                	jmp    8020f2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	56                   	push   %esi
  8020ea:	e8 e4 01 00 00       	call   8022d3 <nsipc_close>
		return r;
  8020ef:	83 c4 10             	add    $0x10,%esp
}
  8020f2:	89 d8                	mov    %ebx,%eax
  8020f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    

008020fb <accept>:
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	e8 4e ff ff ff       	call   802057 <fd2sockid>
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 1b                	js     802128 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	ff 75 10             	pushl  0x10(%ebp)
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	50                   	push   %eax
  802117:	e8 0e 01 00 00       	call   80222a <nsipc_accept>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 05                	js     802128 <accept+0x2d>
	return alloc_sockfd(r);
  802123:	e8 5f ff ff ff       	call   802087 <alloc_sockfd>
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <bind>:
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	e8 1f ff ff ff       	call   802057 <fd2sockid>
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 12                	js     80214e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	ff 75 10             	pushl  0x10(%ebp)
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	50                   	push   %eax
  802146:	e8 31 01 00 00       	call   80227c <nsipc_bind>
  80214b:	83 c4 10             	add    $0x10,%esp
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <shutdown>:
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	e8 f9 fe ff ff       	call   802057 <fd2sockid>
  80215e:	85 c0                	test   %eax,%eax
  802160:	78 0f                	js     802171 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802162:	83 ec 08             	sub    $0x8,%esp
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	50                   	push   %eax
  802169:	e8 43 01 00 00       	call   8022b1 <nsipc_shutdown>
  80216e:	83 c4 10             	add    $0x10,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <connect>:
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	e8 d6 fe ff ff       	call   802057 <fd2sockid>
  802181:	85 c0                	test   %eax,%eax
  802183:	78 12                	js     802197 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	ff 75 10             	pushl  0x10(%ebp)
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	50                   	push   %eax
  80218f:	e8 59 01 00 00       	call   8022ed <nsipc_connect>
  802194:	83 c4 10             	add    $0x10,%esp
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <listen>:
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	e8 b0 fe ff ff       	call   802057 <fd2sockid>
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 0f                	js     8021ba <listen+0x21>
	return nsipc_listen(r, backlog);
  8021ab:	83 ec 08             	sub    $0x8,%esp
  8021ae:	ff 75 0c             	pushl  0xc(%ebp)
  8021b1:	50                   	push   %eax
  8021b2:	e8 6b 01 00 00       	call   802322 <nsipc_listen>
  8021b7:	83 c4 10             	add    $0x10,%esp
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <socket>:

int
socket(int domain, int type, int protocol)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021c2:	ff 75 10             	pushl  0x10(%ebp)
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	e8 3e 02 00 00       	call   80240e <nsipc_socket>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 05                	js     8021dc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021d7:	e8 ab fe ff ff       	call   802087 <alloc_sockfd>
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	53                   	push   %ebx
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021e7:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021ee:	74 26                	je     802216 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021f0:	6a 07                	push   $0x7
  8021f2:	68 00 70 80 00       	push   $0x807000
  8021f7:	53                   	push   %ebx
  8021f8:	ff 35 04 50 80 00    	pushl  0x805004
  8021fe:	e8 45 08 00 00       	call   802a48 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802203:	83 c4 0c             	add    $0xc,%esp
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	e8 ce 07 00 00       	call   8029df <ipc_recv>
}
  802211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802214:	c9                   	leave  
  802215:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802216:	83 ec 0c             	sub    $0xc,%esp
  802219:	6a 02                	push   $0x2
  80221b:	e8 80 08 00 00       	call   802aa0 <ipc_find_env>
  802220:	a3 04 50 80 00       	mov    %eax,0x805004
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	eb c6                	jmp    8021f0 <nsipc+0x12>

0080222a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	56                   	push   %esi
  80222e:	53                   	push   %ebx
  80222f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80223a:	8b 06                	mov    (%esi),%eax
  80223c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802241:	b8 01 00 00 00       	mov    $0x1,%eax
  802246:	e8 93 ff ff ff       	call   8021de <nsipc>
  80224b:	89 c3                	mov    %eax,%ebx
  80224d:	85 c0                	test   %eax,%eax
  80224f:	79 09                	jns    80225a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802251:	89 d8                	mov    %ebx,%eax
  802253:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802256:	5b                   	pop    %ebx
  802257:	5e                   	pop    %esi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80225a:	83 ec 04             	sub    $0x4,%esp
  80225d:	ff 35 10 70 80 00    	pushl  0x807010
  802263:	68 00 70 80 00       	push   $0x807000
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	e8 01 eb ff ff       	call   800d71 <memmove>
		*addrlen = ret->ret_addrlen;
  802270:	a1 10 70 80 00       	mov    0x807010,%eax
  802275:	89 06                	mov    %eax,(%esi)
  802277:	83 c4 10             	add    $0x10,%esp
	return r;
  80227a:	eb d5                	jmp    802251 <nsipc_accept+0x27>

0080227c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	53                   	push   %ebx
  802280:	83 ec 08             	sub    $0x8,%esp
  802283:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80228e:	53                   	push   %ebx
  80228f:	ff 75 0c             	pushl  0xc(%ebp)
  802292:	68 04 70 80 00       	push   $0x807004
  802297:	e8 d5 ea ff ff       	call   800d71 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80229c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8022a7:	e8 32 ff ff ff       	call   8021de <nsipc>
}
  8022ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c2:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8022cc:	e8 0d ff ff ff       	call   8021de <nsipc>
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <nsipc_close>:

int
nsipc_close(int s)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022e1:	b8 04 00 00 00       	mov    $0x4,%eax
  8022e6:	e8 f3 fe ff ff       	call   8021de <nsipc>
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
  8022f0:	53                   	push   %ebx
  8022f1:	83 ec 08             	sub    $0x8,%esp
  8022f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022ff:	53                   	push   %ebx
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	68 04 70 80 00       	push   $0x807004
  802308:	e8 64 ea ff ff       	call   800d71 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80230d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802313:	b8 05 00 00 00       	mov    $0x5,%eax
  802318:	e8 c1 fe ff ff       	call   8021de <nsipc>
}
  80231d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802330:	8b 45 0c             	mov    0xc(%ebp),%eax
  802333:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802338:	b8 06 00 00 00       	mov    $0x6,%eax
  80233d:	e8 9c fe ff ff       	call   8021de <nsipc>
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	56                   	push   %esi
  802348:	53                   	push   %ebx
  802349:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802354:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80235a:	8b 45 14             	mov    0x14(%ebp),%eax
  80235d:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802362:	b8 07 00 00 00       	mov    $0x7,%eax
  802367:	e8 72 fe ff ff       	call   8021de <nsipc>
  80236c:	89 c3                	mov    %eax,%ebx
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 1f                	js     802391 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802372:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802377:	7f 21                	jg     80239a <nsipc_recv+0x56>
  802379:	39 c6                	cmp    %eax,%esi
  80237b:	7c 1d                	jl     80239a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80237d:	83 ec 04             	sub    $0x4,%esp
  802380:	50                   	push   %eax
  802381:	68 00 70 80 00       	push   $0x807000
  802386:	ff 75 0c             	pushl  0xc(%ebp)
  802389:	e8 e3 e9 ff ff       	call   800d71 <memmove>
  80238e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802391:	89 d8                	mov    %ebx,%eax
  802393:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802396:	5b                   	pop    %ebx
  802397:	5e                   	pop    %esi
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80239a:	68 97 34 80 00       	push   $0x803497
  80239f:	68 5f 34 80 00       	push   $0x80345f
  8023a4:	6a 62                	push   $0x62
  8023a6:	68 ac 34 80 00       	push   $0x8034ac
  8023ab:	e8 de df ff ff       	call   80038e <_panic>

008023b0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023c2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023c8:	7f 2e                	jg     8023f8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	53                   	push   %ebx
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	68 0c 70 80 00       	push   $0x80700c
  8023d6:	e8 96 e9 ff ff       	call   800d71 <memmove>
	nsipcbuf.send.req_size = size;
  8023db:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8023ee:	e8 eb fd ff ff       	call   8021de <nsipc>
}
  8023f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    
	assert(size < 1600);
  8023f8:	68 b8 34 80 00       	push   $0x8034b8
  8023fd:	68 5f 34 80 00       	push   $0x80345f
  802402:	6a 6d                	push   $0x6d
  802404:	68 ac 34 80 00       	push   $0x8034ac
  802409:	e8 80 df ff ff       	call   80038e <_panic>

0080240e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802424:	8b 45 10             	mov    0x10(%ebp),%eax
  802427:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80242c:	b8 09 00 00 00       	mov    $0x9,%eax
  802431:	e8 a8 fd ff ff       	call   8021de <nsipc>
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	56                   	push   %esi
  80243c:	53                   	push   %ebx
  80243d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802440:	83 ec 0c             	sub    $0xc,%esp
  802443:	ff 75 08             	pushl  0x8(%ebp)
  802446:	e8 6a f3 ff ff       	call   8017b5 <fd2data>
  80244b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80244d:	83 c4 08             	add    $0x8,%esp
  802450:	68 c4 34 80 00       	push   $0x8034c4
  802455:	53                   	push   %ebx
  802456:	e8 88 e7 ff ff       	call   800be3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80245b:	8b 46 04             	mov    0x4(%esi),%eax
  80245e:	2b 06                	sub    (%esi),%eax
  802460:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802466:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80246d:	00 00 00 
	stat->st_dev = &devpipe;
  802470:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  802477:	40 80 00 
	return 0;
}
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
  80247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802482:	5b                   	pop    %ebx
  802483:	5e                   	pop    %esi
  802484:	5d                   	pop    %ebp
  802485:	c3                   	ret    

00802486 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	53                   	push   %ebx
  80248a:	83 ec 0c             	sub    $0xc,%esp
  80248d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802490:	53                   	push   %ebx
  802491:	6a 00                	push   $0x0
  802493:	e8 c2 eb ff ff       	call   80105a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802498:	89 1c 24             	mov    %ebx,(%esp)
  80249b:	e8 15 f3 ff ff       	call   8017b5 <fd2data>
  8024a0:	83 c4 08             	add    $0x8,%esp
  8024a3:	50                   	push   %eax
  8024a4:	6a 00                	push   $0x0
  8024a6:	e8 af eb ff ff       	call   80105a <sys_page_unmap>
}
  8024ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <_pipeisclosed>:
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	57                   	push   %edi
  8024b4:	56                   	push   %esi
  8024b5:	53                   	push   %ebx
  8024b6:	83 ec 1c             	sub    $0x1c,%esp
  8024b9:	89 c7                	mov    %eax,%edi
  8024bb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024bd:	a1 08 50 80 00       	mov    0x805008,%eax
  8024c2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024c5:	83 ec 0c             	sub    $0xc,%esp
  8024c8:	57                   	push   %edi
  8024c9:	e8 0d 06 00 00       	call   802adb <pageref>
  8024ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024d1:	89 34 24             	mov    %esi,(%esp)
  8024d4:	e8 02 06 00 00       	call   802adb <pageref>
		nn = thisenv->env_runs;
  8024d9:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024df:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	39 cb                	cmp    %ecx,%ebx
  8024e7:	74 1b                	je     802504 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024e9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024ec:	75 cf                	jne    8024bd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024ee:	8b 42 58             	mov    0x58(%edx),%eax
  8024f1:	6a 01                	push   $0x1
  8024f3:	50                   	push   %eax
  8024f4:	53                   	push   %ebx
  8024f5:	68 cb 34 80 00       	push   $0x8034cb
  8024fa:	e8 85 df ff ff       	call   800484 <cprintf>
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	eb b9                	jmp    8024bd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802504:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802507:	0f 94 c0             	sete   %al
  80250a:	0f b6 c0             	movzbl %al,%eax
}
  80250d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    

00802515 <devpipe_write>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	57                   	push   %edi
  802519:	56                   	push   %esi
  80251a:	53                   	push   %ebx
  80251b:	83 ec 28             	sub    $0x28,%esp
  80251e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802521:	56                   	push   %esi
  802522:	e8 8e f2 ff ff       	call   8017b5 <fd2data>
  802527:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802529:	83 c4 10             	add    $0x10,%esp
  80252c:	bf 00 00 00 00       	mov    $0x0,%edi
  802531:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802534:	74 4f                	je     802585 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802536:	8b 43 04             	mov    0x4(%ebx),%eax
  802539:	8b 0b                	mov    (%ebx),%ecx
  80253b:	8d 51 20             	lea    0x20(%ecx),%edx
  80253e:	39 d0                	cmp    %edx,%eax
  802540:	72 14                	jb     802556 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802542:	89 da                	mov    %ebx,%edx
  802544:	89 f0                	mov    %esi,%eax
  802546:	e8 65 ff ff ff       	call   8024b0 <_pipeisclosed>
  80254b:	85 c0                	test   %eax,%eax
  80254d:	75 3b                	jne    80258a <devpipe_write+0x75>
			sys_yield();
  80254f:	e8 62 ea ff ff       	call   800fb6 <sys_yield>
  802554:	eb e0                	jmp    802536 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802559:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80255d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802560:	89 c2                	mov    %eax,%edx
  802562:	c1 fa 1f             	sar    $0x1f,%edx
  802565:	89 d1                	mov    %edx,%ecx
  802567:	c1 e9 1b             	shr    $0x1b,%ecx
  80256a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80256d:	83 e2 1f             	and    $0x1f,%edx
  802570:	29 ca                	sub    %ecx,%edx
  802572:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802576:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80257a:	83 c0 01             	add    $0x1,%eax
  80257d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802580:	83 c7 01             	add    $0x1,%edi
  802583:	eb ac                	jmp    802531 <devpipe_write+0x1c>
	return i;
  802585:	8b 45 10             	mov    0x10(%ebp),%eax
  802588:	eb 05                	jmp    80258f <devpipe_write+0x7a>
				return 0;
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802592:	5b                   	pop    %ebx
  802593:	5e                   	pop    %esi
  802594:	5f                   	pop    %edi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    

00802597 <devpipe_read>:
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	57                   	push   %edi
  80259b:	56                   	push   %esi
  80259c:	53                   	push   %ebx
  80259d:	83 ec 18             	sub    $0x18,%esp
  8025a0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025a3:	57                   	push   %edi
  8025a4:	e8 0c f2 ff ff       	call   8017b5 <fd2data>
  8025a9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025ab:	83 c4 10             	add    $0x10,%esp
  8025ae:	be 00 00 00 00       	mov    $0x0,%esi
  8025b3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b6:	75 14                	jne    8025cc <devpipe_read+0x35>
	return i;
  8025b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bb:	eb 02                	jmp    8025bf <devpipe_read+0x28>
				return i;
  8025bd:	89 f0                	mov    %esi,%eax
}
  8025bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c2:	5b                   	pop    %ebx
  8025c3:	5e                   	pop    %esi
  8025c4:	5f                   	pop    %edi
  8025c5:	5d                   	pop    %ebp
  8025c6:	c3                   	ret    
			sys_yield();
  8025c7:	e8 ea e9 ff ff       	call   800fb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025cc:	8b 03                	mov    (%ebx),%eax
  8025ce:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025d1:	75 18                	jne    8025eb <devpipe_read+0x54>
			if (i > 0)
  8025d3:	85 f6                	test   %esi,%esi
  8025d5:	75 e6                	jne    8025bd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025d7:	89 da                	mov    %ebx,%edx
  8025d9:	89 f8                	mov    %edi,%eax
  8025db:	e8 d0 fe ff ff       	call   8024b0 <_pipeisclosed>
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	74 e3                	je     8025c7 <devpipe_read+0x30>
				return 0;
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	eb d4                	jmp    8025bf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025eb:	99                   	cltd   
  8025ec:	c1 ea 1b             	shr    $0x1b,%edx
  8025ef:	01 d0                	add    %edx,%eax
  8025f1:	83 e0 1f             	and    $0x1f,%eax
  8025f4:	29 d0                	sub    %edx,%eax
  8025f6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025fe:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802601:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802604:	83 c6 01             	add    $0x1,%esi
  802607:	eb aa                	jmp    8025b3 <devpipe_read+0x1c>

00802609 <pipe>:
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	56                   	push   %esi
  80260d:	53                   	push   %ebx
  80260e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802611:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802614:	50                   	push   %eax
  802615:	e8 b2 f1 ff ff       	call   8017cc <fd_alloc>
  80261a:	89 c3                	mov    %eax,%ebx
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	85 c0                	test   %eax,%eax
  802621:	0f 88 23 01 00 00    	js     80274a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802627:	83 ec 04             	sub    $0x4,%esp
  80262a:	68 07 04 00 00       	push   $0x407
  80262f:	ff 75 f4             	pushl  -0xc(%ebp)
  802632:	6a 00                	push   $0x0
  802634:	e8 9c e9 ff ff       	call   800fd5 <sys_page_alloc>
  802639:	89 c3                	mov    %eax,%ebx
  80263b:	83 c4 10             	add    $0x10,%esp
  80263e:	85 c0                	test   %eax,%eax
  802640:	0f 88 04 01 00 00    	js     80274a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802646:	83 ec 0c             	sub    $0xc,%esp
  802649:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80264c:	50                   	push   %eax
  80264d:	e8 7a f1 ff ff       	call   8017cc <fd_alloc>
  802652:	89 c3                	mov    %eax,%ebx
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	0f 88 db 00 00 00    	js     80273a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265f:	83 ec 04             	sub    $0x4,%esp
  802662:	68 07 04 00 00       	push   $0x407
  802667:	ff 75 f0             	pushl  -0x10(%ebp)
  80266a:	6a 00                	push   $0x0
  80266c:	e8 64 e9 ff ff       	call   800fd5 <sys_page_alloc>
  802671:	89 c3                	mov    %eax,%ebx
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 88 bc 00 00 00    	js     80273a <pipe+0x131>
	va = fd2data(fd0);
  80267e:	83 ec 0c             	sub    $0xc,%esp
  802681:	ff 75 f4             	pushl  -0xc(%ebp)
  802684:	e8 2c f1 ff ff       	call   8017b5 <fd2data>
  802689:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268b:	83 c4 0c             	add    $0xc,%esp
  80268e:	68 07 04 00 00       	push   $0x407
  802693:	50                   	push   %eax
  802694:	6a 00                	push   $0x0
  802696:	e8 3a e9 ff ff       	call   800fd5 <sys_page_alloc>
  80269b:	89 c3                	mov    %eax,%ebx
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	0f 88 82 00 00 00    	js     80272a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ae:	e8 02 f1 ff ff       	call   8017b5 <fd2data>
  8026b3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026ba:	50                   	push   %eax
  8026bb:	6a 00                	push   $0x0
  8026bd:	56                   	push   %esi
  8026be:	6a 00                	push   $0x0
  8026c0:	e8 53 e9 ff ff       	call   801018 <sys_page_map>
  8026c5:	89 c3                	mov    %eax,%ebx
  8026c7:	83 c4 20             	add    $0x20,%esp
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	78 4e                	js     80271c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026ce:	a1 40 40 80 00       	mov    0x804040,%eax
  8026d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026db:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026f1:	83 ec 0c             	sub    $0xc,%esp
  8026f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f7:	e8 a9 f0 ff ff       	call   8017a5 <fd2num>
  8026fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ff:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802701:	83 c4 04             	add    $0x4,%esp
  802704:	ff 75 f0             	pushl  -0x10(%ebp)
  802707:	e8 99 f0 ff ff       	call   8017a5 <fd2num>
  80270c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80270f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802712:	83 c4 10             	add    $0x10,%esp
  802715:	bb 00 00 00 00       	mov    $0x0,%ebx
  80271a:	eb 2e                	jmp    80274a <pipe+0x141>
	sys_page_unmap(0, va);
  80271c:	83 ec 08             	sub    $0x8,%esp
  80271f:	56                   	push   %esi
  802720:	6a 00                	push   $0x0
  802722:	e8 33 e9 ff ff       	call   80105a <sys_page_unmap>
  802727:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80272a:	83 ec 08             	sub    $0x8,%esp
  80272d:	ff 75 f0             	pushl  -0x10(%ebp)
  802730:	6a 00                	push   $0x0
  802732:	e8 23 e9 ff ff       	call   80105a <sys_page_unmap>
  802737:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80273a:	83 ec 08             	sub    $0x8,%esp
  80273d:	ff 75 f4             	pushl  -0xc(%ebp)
  802740:	6a 00                	push   $0x0
  802742:	e8 13 e9 ff ff       	call   80105a <sys_page_unmap>
  802747:	83 c4 10             	add    $0x10,%esp
}
  80274a:	89 d8                	mov    %ebx,%eax
  80274c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5d                   	pop    %ebp
  802752:	c3                   	ret    

00802753 <pipeisclosed>:
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802759:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275c:	50                   	push   %eax
  80275d:	ff 75 08             	pushl  0x8(%ebp)
  802760:	e8 b9 f0 ff ff       	call   80181e <fd_lookup>
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	85 c0                	test   %eax,%eax
  80276a:	78 18                	js     802784 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80276c:	83 ec 0c             	sub    $0xc,%esp
  80276f:	ff 75 f4             	pushl  -0xc(%ebp)
  802772:	e8 3e f0 ff ff       	call   8017b5 <fd2data>
	return _pipeisclosed(fd, p);
  802777:	89 c2                	mov    %eax,%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	e8 2f fd ff ff       	call   8024b0 <_pipeisclosed>
  802781:	83 c4 10             	add    $0x10,%esp
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	56                   	push   %esi
  80278a:	53                   	push   %ebx
  80278b:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80278e:	85 f6                	test   %esi,%esi
  802790:	74 13                	je     8027a5 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802792:	89 f3                	mov    %esi,%ebx
  802794:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80279a:	c1 e3 07             	shl    $0x7,%ebx
  80279d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8027a3:	eb 1b                	jmp    8027c0 <wait+0x3a>
	assert(envid != 0);
  8027a5:	68 e3 34 80 00       	push   $0x8034e3
  8027aa:	68 5f 34 80 00       	push   $0x80345f
  8027af:	6a 09                	push   $0x9
  8027b1:	68 ee 34 80 00       	push   $0x8034ee
  8027b6:	e8 d3 db ff ff       	call   80038e <_panic>
		sys_yield();
  8027bb:	e8 f6 e7 ff ff       	call   800fb6 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027c0:	8b 43 48             	mov    0x48(%ebx),%eax
  8027c3:	39 f0                	cmp    %esi,%eax
  8027c5:	75 07                	jne    8027ce <wait+0x48>
  8027c7:	8b 43 54             	mov    0x54(%ebx),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	75 ed                	jne    8027bb <wait+0x35>
}
  8027ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027d1:	5b                   	pop    %ebx
  8027d2:	5e                   	pop    %esi
  8027d3:	5d                   	pop    %ebp
  8027d4:	c3                   	ret    

008027d5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027da:	c3                   	ret    

008027db <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027e1:	68 f9 34 80 00       	push   $0x8034f9
  8027e6:	ff 75 0c             	pushl  0xc(%ebp)
  8027e9:	e8 f5 e3 ff ff       	call   800be3 <strcpy>
	return 0;
}
  8027ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <devcons_write>:
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	57                   	push   %edi
  8027f9:	56                   	push   %esi
  8027fa:	53                   	push   %ebx
  8027fb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802801:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802806:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80280c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80280f:	73 31                	jae    802842 <devcons_write+0x4d>
		m = n - tot;
  802811:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802814:	29 f3                	sub    %esi,%ebx
  802816:	83 fb 7f             	cmp    $0x7f,%ebx
  802819:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80281e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802821:	83 ec 04             	sub    $0x4,%esp
  802824:	53                   	push   %ebx
  802825:	89 f0                	mov    %esi,%eax
  802827:	03 45 0c             	add    0xc(%ebp),%eax
  80282a:	50                   	push   %eax
  80282b:	57                   	push   %edi
  80282c:	e8 40 e5 ff ff       	call   800d71 <memmove>
		sys_cputs(buf, m);
  802831:	83 c4 08             	add    $0x8,%esp
  802834:	53                   	push   %ebx
  802835:	57                   	push   %edi
  802836:	e8 de e6 ff ff       	call   800f19 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80283b:	01 de                	add    %ebx,%esi
  80283d:	83 c4 10             	add    $0x10,%esp
  802840:	eb ca                	jmp    80280c <devcons_write+0x17>
}
  802842:	89 f0                	mov    %esi,%eax
  802844:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802847:	5b                   	pop    %ebx
  802848:	5e                   	pop    %esi
  802849:	5f                   	pop    %edi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    

0080284c <devcons_read>:
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	83 ec 08             	sub    $0x8,%esp
  802852:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802857:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80285b:	74 21                	je     80287e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80285d:	e8 d5 e6 ff ff       	call   800f37 <sys_cgetc>
  802862:	85 c0                	test   %eax,%eax
  802864:	75 07                	jne    80286d <devcons_read+0x21>
		sys_yield();
  802866:	e8 4b e7 ff ff       	call   800fb6 <sys_yield>
  80286b:	eb f0                	jmp    80285d <devcons_read+0x11>
	if (c < 0)
  80286d:	78 0f                	js     80287e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80286f:	83 f8 04             	cmp    $0x4,%eax
  802872:	74 0c                	je     802880 <devcons_read+0x34>
	*(char*)vbuf = c;
  802874:	8b 55 0c             	mov    0xc(%ebp),%edx
  802877:	88 02                	mov    %al,(%edx)
	return 1;
  802879:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    
		return 0;
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
  802885:	eb f7                	jmp    80287e <devcons_read+0x32>

00802887 <cputchar>:
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
  80288a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802893:	6a 01                	push   $0x1
  802895:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802898:	50                   	push   %eax
  802899:	e8 7b e6 ff ff       	call   800f19 <sys_cputs>
}
  80289e:	83 c4 10             	add    $0x10,%esp
  8028a1:	c9                   	leave  
  8028a2:	c3                   	ret    

008028a3 <getchar>:
{
  8028a3:	55                   	push   %ebp
  8028a4:	89 e5                	mov    %esp,%ebp
  8028a6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8028a9:	6a 01                	push   $0x1
  8028ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028ae:	50                   	push   %eax
  8028af:	6a 00                	push   $0x0
  8028b1:	e8 d8 f1 ff ff       	call   801a8e <read>
	if (r < 0)
  8028b6:	83 c4 10             	add    $0x10,%esp
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	78 06                	js     8028c3 <getchar+0x20>
	if (r < 1)
  8028bd:	74 06                	je     8028c5 <getchar+0x22>
	return c;
  8028bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    
		return -E_EOF;
  8028c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028ca:	eb f7                	jmp    8028c3 <getchar+0x20>

008028cc <iscons>:
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028d5:	50                   	push   %eax
  8028d6:	ff 75 08             	pushl  0x8(%ebp)
  8028d9:	e8 40 ef ff ff       	call   80181e <fd_lookup>
  8028de:	83 c4 10             	add    $0x10,%esp
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	78 11                	js     8028f6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028ee:	39 10                	cmp    %edx,(%eax)
  8028f0:	0f 94 c0             	sete   %al
  8028f3:	0f b6 c0             	movzbl %al,%eax
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <opencons>:
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802901:	50                   	push   %eax
  802902:	e8 c5 ee ff ff       	call   8017cc <fd_alloc>
  802907:	83 c4 10             	add    $0x10,%esp
  80290a:	85 c0                	test   %eax,%eax
  80290c:	78 3a                	js     802948 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	68 07 04 00 00       	push   $0x407
  802916:	ff 75 f4             	pushl  -0xc(%ebp)
  802919:	6a 00                	push   $0x0
  80291b:	e8 b5 e6 ff ff       	call   800fd5 <sys_page_alloc>
  802920:	83 c4 10             	add    $0x10,%esp
  802923:	85 c0                	test   %eax,%eax
  802925:	78 21                	js     802948 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802930:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80293c:	83 ec 0c             	sub    $0xc,%esp
  80293f:	50                   	push   %eax
  802940:	e8 60 ee ff ff       	call   8017a5 <fd2num>
  802945:	83 c4 10             	add    $0x10,%esp
}
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802950:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802957:	74 0a                	je     802963 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802961:	c9                   	leave  
  802962:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	6a 07                	push   $0x7
  802968:	68 00 f0 bf ee       	push   $0xeebff000
  80296d:	6a 00                	push   $0x0
  80296f:	e8 61 e6 ff ff       	call   800fd5 <sys_page_alloc>
		if(r < 0)
  802974:	83 c4 10             	add    $0x10,%esp
  802977:	85 c0                	test   %eax,%eax
  802979:	78 2a                	js     8029a5 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80297b:	83 ec 08             	sub    $0x8,%esp
  80297e:	68 b9 29 80 00       	push   $0x8029b9
  802983:	6a 00                	push   $0x0
  802985:	e8 96 e7 ff ff       	call   801120 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80298a:	83 c4 10             	add    $0x10,%esp
  80298d:	85 c0                	test   %eax,%eax
  80298f:	79 c8                	jns    802959 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 38 35 80 00       	push   $0x803538
  802999:	6a 25                	push   $0x25
  80299b:	68 74 35 80 00       	push   $0x803574
  8029a0:	e8 e9 d9 ff ff       	call   80038e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8029a5:	83 ec 04             	sub    $0x4,%esp
  8029a8:	68 08 35 80 00       	push   $0x803508
  8029ad:	6a 22                	push   $0x22
  8029af:	68 74 35 80 00       	push   $0x803574
  8029b4:	e8 d5 d9 ff ff       	call   80038e <_panic>

008029b9 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029b9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029ba:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029bf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029c1:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029c4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029c8:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029cc:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029cf:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029d1:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029d5:	83 c4 08             	add    $0x8,%esp
	popal
  8029d8:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029d9:	83 c4 04             	add    $0x4,%esp
	popfl
  8029dc:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029dd:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029de:	c3                   	ret    

008029df <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8029e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8029ed:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029ef:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029f4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029f7:	83 ec 0c             	sub    $0xc,%esp
  8029fa:	50                   	push   %eax
  8029fb:	e8 85 e7 ff ff       	call   801185 <sys_ipc_recv>
	if(ret < 0){
  802a00:	83 c4 10             	add    $0x10,%esp
  802a03:	85 c0                	test   %eax,%eax
  802a05:	78 2b                	js     802a32 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802a07:	85 f6                	test   %esi,%esi
  802a09:	74 0a                	je     802a15 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802a0b:	a1 08 50 80 00       	mov    0x805008,%eax
  802a10:	8b 40 74             	mov    0x74(%eax),%eax
  802a13:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a15:	85 db                	test   %ebx,%ebx
  802a17:	74 0a                	je     802a23 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802a19:	a1 08 50 80 00       	mov    0x805008,%eax
  802a1e:	8b 40 78             	mov    0x78(%eax),%eax
  802a21:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802a23:	a1 08 50 80 00       	mov    0x805008,%eax
  802a28:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a2e:	5b                   	pop    %ebx
  802a2f:	5e                   	pop    %esi
  802a30:	5d                   	pop    %ebp
  802a31:	c3                   	ret    
		if(from_env_store)
  802a32:	85 f6                	test   %esi,%esi
  802a34:	74 06                	je     802a3c <ipc_recv+0x5d>
			*from_env_store = 0;
  802a36:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a3c:	85 db                	test   %ebx,%ebx
  802a3e:	74 eb                	je     802a2b <ipc_recv+0x4c>
			*perm_store = 0;
  802a40:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a46:	eb e3                	jmp    802a2b <ipc_recv+0x4c>

00802a48 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	57                   	push   %edi
  802a4c:	56                   	push   %esi
  802a4d:	53                   	push   %ebx
  802a4e:	83 ec 0c             	sub    $0xc,%esp
  802a51:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a54:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a5a:	85 db                	test   %ebx,%ebx
  802a5c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a61:	0f 44 d8             	cmove  %eax,%ebx
  802a64:	eb 05                	jmp    802a6b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a66:	e8 4b e5 ff ff       	call   800fb6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a6b:	ff 75 14             	pushl  0x14(%ebp)
  802a6e:	53                   	push   %ebx
  802a6f:	56                   	push   %esi
  802a70:	57                   	push   %edi
  802a71:	e8 ec e6 ff ff       	call   801162 <sys_ipc_try_send>
  802a76:	83 c4 10             	add    $0x10,%esp
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 1b                	je     802a98 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a7d:	79 e7                	jns    802a66 <ipc_send+0x1e>
  802a7f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a82:	74 e2                	je     802a66 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 82 35 80 00       	push   $0x803582
  802a8c:	6a 48                	push   $0x48
  802a8e:	68 97 35 80 00       	push   $0x803597
  802a93:	e8 f6 d8 ff ff       	call   80038e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    

00802aa0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
  802aa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802aab:	89 c2                	mov    %eax,%edx
  802aad:	c1 e2 07             	shl    $0x7,%edx
  802ab0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ab6:	8b 52 50             	mov    0x50(%edx),%edx
  802ab9:	39 ca                	cmp    %ecx,%edx
  802abb:	74 11                	je     802ace <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802abd:	83 c0 01             	add    $0x1,%eax
  802ac0:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ac5:	75 e4                	jne    802aab <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  802acc:	eb 0b                	jmp    802ad9 <ipc_find_env+0x39>
			return envs[i].env_id;
  802ace:	c1 e0 07             	shl    $0x7,%eax
  802ad1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ad6:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ad9:	5d                   	pop    %ebp
  802ada:	c3                   	ret    

00802adb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ae1:	89 d0                	mov    %edx,%eax
  802ae3:	c1 e8 16             	shr    $0x16,%eax
  802ae6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802af2:	f6 c1 01             	test   $0x1,%cl
  802af5:	74 1d                	je     802b14 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802af7:	c1 ea 0c             	shr    $0xc,%edx
  802afa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b01:	f6 c2 01             	test   $0x1,%dl
  802b04:	74 0e                	je     802b14 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b06:	c1 ea 0c             	shr    $0xc,%edx
  802b09:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b10:	ef 
  802b11:	0f b7 c0             	movzwl %ax,%eax
}
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    
  802b16:	66 90                	xchg   %ax,%ax
  802b18:	66 90                	xchg   %ax,%ax
  802b1a:	66 90                	xchg   %ax,%ax
  802b1c:	66 90                	xchg   %ax,%ax
  802b1e:	66 90                	xchg   %ax,%ax

00802b20 <__udivdi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	53                   	push   %ebx
  802b24:	83 ec 1c             	sub    $0x1c,%esp
  802b27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b37:	85 d2                	test   %edx,%edx
  802b39:	75 4d                	jne    802b88 <__udivdi3+0x68>
  802b3b:	39 f3                	cmp    %esi,%ebx
  802b3d:	76 19                	jbe    802b58 <__udivdi3+0x38>
  802b3f:	31 ff                	xor    %edi,%edi
  802b41:	89 e8                	mov    %ebp,%eax
  802b43:	89 f2                	mov    %esi,%edx
  802b45:	f7 f3                	div    %ebx
  802b47:	89 fa                	mov    %edi,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	89 d9                	mov    %ebx,%ecx
  802b5a:	85 db                	test   %ebx,%ebx
  802b5c:	75 0b                	jne    802b69 <__udivdi3+0x49>
  802b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b63:	31 d2                	xor    %edx,%edx
  802b65:	f7 f3                	div    %ebx
  802b67:	89 c1                	mov    %eax,%ecx
  802b69:	31 d2                	xor    %edx,%edx
  802b6b:	89 f0                	mov    %esi,%eax
  802b6d:	f7 f1                	div    %ecx
  802b6f:	89 c6                	mov    %eax,%esi
  802b71:	89 e8                	mov    %ebp,%eax
  802b73:	89 f7                	mov    %esi,%edi
  802b75:	f7 f1                	div    %ecx
  802b77:	89 fa                	mov    %edi,%edx
  802b79:	83 c4 1c             	add    $0x1c,%esp
  802b7c:	5b                   	pop    %ebx
  802b7d:	5e                   	pop    %esi
  802b7e:	5f                   	pop    %edi
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    
  802b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b88:	39 f2                	cmp    %esi,%edx
  802b8a:	77 1c                	ja     802ba8 <__udivdi3+0x88>
  802b8c:	0f bd fa             	bsr    %edx,%edi
  802b8f:	83 f7 1f             	xor    $0x1f,%edi
  802b92:	75 2c                	jne    802bc0 <__udivdi3+0xa0>
  802b94:	39 f2                	cmp    %esi,%edx
  802b96:	72 06                	jb     802b9e <__udivdi3+0x7e>
  802b98:	31 c0                	xor    %eax,%eax
  802b9a:	39 eb                	cmp    %ebp,%ebx
  802b9c:	77 a9                	ja     802b47 <__udivdi3+0x27>
  802b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba3:	eb a2                	jmp    802b47 <__udivdi3+0x27>
  802ba5:	8d 76 00             	lea    0x0(%esi),%esi
  802ba8:	31 ff                	xor    %edi,%edi
  802baa:	31 c0                	xor    %eax,%eax
  802bac:	89 fa                	mov    %edi,%edx
  802bae:	83 c4 1c             	add    $0x1c,%esp
  802bb1:	5b                   	pop    %ebx
  802bb2:	5e                   	pop    %esi
  802bb3:	5f                   	pop    %edi
  802bb4:	5d                   	pop    %ebp
  802bb5:	c3                   	ret    
  802bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bbd:	8d 76 00             	lea    0x0(%esi),%esi
  802bc0:	89 f9                	mov    %edi,%ecx
  802bc2:	b8 20 00 00 00       	mov    $0x20,%eax
  802bc7:	29 f8                	sub    %edi,%eax
  802bc9:	d3 e2                	shl    %cl,%edx
  802bcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bcf:	89 c1                	mov    %eax,%ecx
  802bd1:	89 da                	mov    %ebx,%edx
  802bd3:	d3 ea                	shr    %cl,%edx
  802bd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bd9:	09 d1                	or     %edx,%ecx
  802bdb:	89 f2                	mov    %esi,%edx
  802bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be1:	89 f9                	mov    %edi,%ecx
  802be3:	d3 e3                	shl    %cl,%ebx
  802be5:	89 c1                	mov    %eax,%ecx
  802be7:	d3 ea                	shr    %cl,%edx
  802be9:	89 f9                	mov    %edi,%ecx
  802beb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bef:	89 eb                	mov    %ebp,%ebx
  802bf1:	d3 e6                	shl    %cl,%esi
  802bf3:	89 c1                	mov    %eax,%ecx
  802bf5:	d3 eb                	shr    %cl,%ebx
  802bf7:	09 de                	or     %ebx,%esi
  802bf9:	89 f0                	mov    %esi,%eax
  802bfb:	f7 74 24 08          	divl   0x8(%esp)
  802bff:	89 d6                	mov    %edx,%esi
  802c01:	89 c3                	mov    %eax,%ebx
  802c03:	f7 64 24 0c          	mull   0xc(%esp)
  802c07:	39 d6                	cmp    %edx,%esi
  802c09:	72 15                	jb     802c20 <__udivdi3+0x100>
  802c0b:	89 f9                	mov    %edi,%ecx
  802c0d:	d3 e5                	shl    %cl,%ebp
  802c0f:	39 c5                	cmp    %eax,%ebp
  802c11:	73 04                	jae    802c17 <__udivdi3+0xf7>
  802c13:	39 d6                	cmp    %edx,%esi
  802c15:	74 09                	je     802c20 <__udivdi3+0x100>
  802c17:	89 d8                	mov    %ebx,%eax
  802c19:	31 ff                	xor    %edi,%edi
  802c1b:	e9 27 ff ff ff       	jmp    802b47 <__udivdi3+0x27>
  802c20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c23:	31 ff                	xor    %edi,%edi
  802c25:	e9 1d ff ff ff       	jmp    802b47 <__udivdi3+0x27>
  802c2a:	66 90                	xchg   %ax,%ax
  802c2c:	66 90                	xchg   %ax,%ax
  802c2e:	66 90                	xchg   %ax,%ax

00802c30 <__umoddi3>:
  802c30:	55                   	push   %ebp
  802c31:	57                   	push   %edi
  802c32:	56                   	push   %esi
  802c33:	53                   	push   %ebx
  802c34:	83 ec 1c             	sub    $0x1c,%esp
  802c37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c47:	89 da                	mov    %ebx,%edx
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	75 43                	jne    802c90 <__umoddi3+0x60>
  802c4d:	39 df                	cmp    %ebx,%edi
  802c4f:	76 17                	jbe    802c68 <__umoddi3+0x38>
  802c51:	89 f0                	mov    %esi,%eax
  802c53:	f7 f7                	div    %edi
  802c55:	89 d0                	mov    %edx,%eax
  802c57:	31 d2                	xor    %edx,%edx
  802c59:	83 c4 1c             	add    $0x1c,%esp
  802c5c:	5b                   	pop    %ebx
  802c5d:	5e                   	pop    %esi
  802c5e:	5f                   	pop    %edi
  802c5f:	5d                   	pop    %ebp
  802c60:	c3                   	ret    
  802c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c68:	89 fd                	mov    %edi,%ebp
  802c6a:	85 ff                	test   %edi,%edi
  802c6c:	75 0b                	jne    802c79 <__umoddi3+0x49>
  802c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c73:	31 d2                	xor    %edx,%edx
  802c75:	f7 f7                	div    %edi
  802c77:	89 c5                	mov    %eax,%ebp
  802c79:	89 d8                	mov    %ebx,%eax
  802c7b:	31 d2                	xor    %edx,%edx
  802c7d:	f7 f5                	div    %ebp
  802c7f:	89 f0                	mov    %esi,%eax
  802c81:	f7 f5                	div    %ebp
  802c83:	89 d0                	mov    %edx,%eax
  802c85:	eb d0                	jmp    802c57 <__umoddi3+0x27>
  802c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c8e:	66 90                	xchg   %ax,%ax
  802c90:	89 f1                	mov    %esi,%ecx
  802c92:	39 d8                	cmp    %ebx,%eax
  802c94:	76 0a                	jbe    802ca0 <__umoddi3+0x70>
  802c96:	89 f0                	mov    %esi,%eax
  802c98:	83 c4 1c             	add    $0x1c,%esp
  802c9b:	5b                   	pop    %ebx
  802c9c:	5e                   	pop    %esi
  802c9d:	5f                   	pop    %edi
  802c9e:	5d                   	pop    %ebp
  802c9f:	c3                   	ret    
  802ca0:	0f bd e8             	bsr    %eax,%ebp
  802ca3:	83 f5 1f             	xor    $0x1f,%ebp
  802ca6:	75 20                	jne    802cc8 <__umoddi3+0x98>
  802ca8:	39 d8                	cmp    %ebx,%eax
  802caa:	0f 82 b0 00 00 00    	jb     802d60 <__umoddi3+0x130>
  802cb0:	39 f7                	cmp    %esi,%edi
  802cb2:	0f 86 a8 00 00 00    	jbe    802d60 <__umoddi3+0x130>
  802cb8:	89 c8                	mov    %ecx,%eax
  802cba:	83 c4 1c             	add    $0x1c,%esp
  802cbd:	5b                   	pop    %ebx
  802cbe:	5e                   	pop    %esi
  802cbf:	5f                   	pop    %edi
  802cc0:	5d                   	pop    %ebp
  802cc1:	c3                   	ret    
  802cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cc8:	89 e9                	mov    %ebp,%ecx
  802cca:	ba 20 00 00 00       	mov    $0x20,%edx
  802ccf:	29 ea                	sub    %ebp,%edx
  802cd1:	d3 e0                	shl    %cl,%eax
  802cd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cd7:	89 d1                	mov    %edx,%ecx
  802cd9:	89 f8                	mov    %edi,%eax
  802cdb:	d3 e8                	shr    %cl,%eax
  802cdd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ce1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ce5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ce9:	09 c1                	or     %eax,%ecx
  802ceb:	89 d8                	mov    %ebx,%eax
  802ced:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cf1:	89 e9                	mov    %ebp,%ecx
  802cf3:	d3 e7                	shl    %cl,%edi
  802cf5:	89 d1                	mov    %edx,%ecx
  802cf7:	d3 e8                	shr    %cl,%eax
  802cf9:	89 e9                	mov    %ebp,%ecx
  802cfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cff:	d3 e3                	shl    %cl,%ebx
  802d01:	89 c7                	mov    %eax,%edi
  802d03:	89 d1                	mov    %edx,%ecx
  802d05:	89 f0                	mov    %esi,%eax
  802d07:	d3 e8                	shr    %cl,%eax
  802d09:	89 e9                	mov    %ebp,%ecx
  802d0b:	89 fa                	mov    %edi,%edx
  802d0d:	d3 e6                	shl    %cl,%esi
  802d0f:	09 d8                	or     %ebx,%eax
  802d11:	f7 74 24 08          	divl   0x8(%esp)
  802d15:	89 d1                	mov    %edx,%ecx
  802d17:	89 f3                	mov    %esi,%ebx
  802d19:	f7 64 24 0c          	mull   0xc(%esp)
  802d1d:	89 c6                	mov    %eax,%esi
  802d1f:	89 d7                	mov    %edx,%edi
  802d21:	39 d1                	cmp    %edx,%ecx
  802d23:	72 06                	jb     802d2b <__umoddi3+0xfb>
  802d25:	75 10                	jne    802d37 <__umoddi3+0x107>
  802d27:	39 c3                	cmp    %eax,%ebx
  802d29:	73 0c                	jae    802d37 <__umoddi3+0x107>
  802d2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d33:	89 d7                	mov    %edx,%edi
  802d35:	89 c6                	mov    %eax,%esi
  802d37:	89 ca                	mov    %ecx,%edx
  802d39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d3e:	29 f3                	sub    %esi,%ebx
  802d40:	19 fa                	sbb    %edi,%edx
  802d42:	89 d0                	mov    %edx,%eax
  802d44:	d3 e0                	shl    %cl,%eax
  802d46:	89 e9                	mov    %ebp,%ecx
  802d48:	d3 eb                	shr    %cl,%ebx
  802d4a:	d3 ea                	shr    %cl,%edx
  802d4c:	09 d8                	or     %ebx,%eax
  802d4e:	83 c4 1c             	add    $0x1c,%esp
  802d51:	5b                   	pop    %ebx
  802d52:	5e                   	pop    %esi
  802d53:	5f                   	pop    %edi
  802d54:	5d                   	pop    %ebp
  802d55:	c3                   	ret    
  802d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d5d:	8d 76 00             	lea    0x0(%esi),%esi
  802d60:	89 da                	mov    %ebx,%edx
  802d62:	29 fe                	sub    %edi,%esi
  802d64:	19 c2                	sbb    %eax,%edx
  802d66:	89 f1                	mov    %esi,%ecx
  802d68:	89 c8                	mov    %ecx,%eax
  802d6a:	e9 4b ff ff ff       	jmp    802cba <__umoddi3+0x8a>
