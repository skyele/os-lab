
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
  80003b:	c7 05 04 40 80 00 60 	movl   $0x802d60,0x804004
  800042:	2d 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 a7 25 00 00       	call   8025f5 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1b 01 00 00    	js     800176 <umain+0x143>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 9f 14 00 00       	call   8014ff <fork>
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
  80007f:	68 8e 2d 80 00       	push   $0x802d8e
  800084:	e8 fb 03 00 00       	call   800484 <cprintf>
		close(p[1]);
  800089:	83 c4 04             	add    $0x4,%esp
  80008c:	ff 75 90             	pushl  -0x70(%ebp)
  80008f:	e8 a8 18 00 00       	call   80193c <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800094:	a1 08 50 80 00       	mov    0x805008,%eax
  800099:	8b 40 48             	mov    0x48(%eax),%eax
  80009c:	83 c4 0c             	add    $0xc,%esp
  80009f:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a2:	50                   	push   %eax
  8000a3:	68 ab 2d 80 00       	push   $0x802dab
  8000a8:	e8 d7 03 00 00       	call   800484 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 63                	push   $0x63
  8000b2:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 8c             	pushl  -0x74(%ebp)
  8000b9:	e8 43 1a 00 00       	call   801b01 <readn>
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
  8000f0:	68 d1 2d 80 00       	push   $0x802dd1
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
  800106:	e8 67 26 00 00       	call   802772 <wait>

	binaryname = "pipewriteeof";
  80010b:	c7 05 04 40 80 00 27 	movl   $0x802e27,0x804004
  800112:	2e 80 00 
	if ((i = pipe(p)) < 0)
  800115:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800118:	89 04 24             	mov    %eax,(%esp)
  80011b:	e8 d5 24 00 00       	call   8025f5 <pipe>
  800120:	89 c6                	mov    %eax,%esi
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 32 01 00 00    	js     80025f <umain+0x22c>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012d:	e8 cd 13 00 00       	call   8014ff <fork>
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
  800148:	e8 ef 17 00 00       	call   80193c <close>
	close(p[1]);
  80014d:	83 c4 04             	add    $0x4,%esp
  800150:	ff 75 90             	pushl  -0x70(%ebp)
  800153:	e8 e4 17 00 00       	call   80193c <close>
	wait(pid);
  800158:	89 1c 24             	mov    %ebx,(%esp)
  80015b:	e8 12 26 00 00       	call   802772 <wait>

	cprintf("pipe tests passed\n");
  800160:	c7 04 24 55 2e 80 00 	movl   $0x802e55,(%esp)
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
  800177:	68 6c 2d 80 00       	push   $0x802d6c
  80017c:	6a 0e                	push   $0xe
  80017e:	68 75 2d 80 00       	push   $0x802d75
  800183:	e8 06 02 00 00       	call   80038e <_panic>
		panic("fork: %e", i);
  800188:	56                   	push   %esi
  800189:	68 85 2d 80 00       	push   $0x802d85
  80018e:	6a 11                	push   $0x11
  800190:	68 75 2d 80 00       	push   $0x802d75
  800195:	e8 f4 01 00 00       	call   80038e <_panic>
			panic("read: %e", i);
  80019a:	50                   	push   %eax
  80019b:	68 c8 2d 80 00       	push   $0x802dc8
  8001a0:	6a 19                	push   $0x19
  8001a2:	68 75 2d 80 00       	push   $0x802d75
  8001a7:	e8 e2 01 00 00       	call   80038e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	56                   	push   %esi
  8001b4:	68 ed 2d 80 00       	push   $0x802ded
  8001b9:	e8 c6 02 00 00       	call   800484 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	e9 37 ff ff ff       	jmp    8000fd <umain+0xca>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d4:	50                   	push   %eax
  8001d5:	68 8e 2d 80 00       	push   $0x802d8e
  8001da:	e8 a5 02 00 00       	call   800484 <cprintf>
		close(p[0]);
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e5:	e8 52 17 00 00       	call   80193c <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ef:	8b 40 48             	mov    0x48(%eax),%eax
  8001f2:	83 c4 0c             	add    $0xc,%esp
  8001f5:	ff 75 90             	pushl  -0x70(%ebp)
  8001f8:	50                   	push   %eax
  8001f9:	68 00 2e 80 00       	push   $0x802e00
  8001fe:	e8 81 02 00 00       	call   800484 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800203:	83 c4 04             	add    $0x4,%esp
  800206:	ff 35 00 40 80 00    	pushl  0x804000
  80020c:	e8 99 09 00 00       	call   800baa <strlen>
  800211:	83 c4 0c             	add    $0xc,%esp
  800214:	50                   	push   %eax
  800215:	ff 35 00 40 80 00    	pushl  0x804000
  80021b:	ff 75 90             	pushl  -0x70(%ebp)
  80021e:	e8 23 19 00 00       	call   801b46 <write>
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
  800240:	e8 f7 16 00 00       	call   80193c <close>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	e9 b5 fe ff ff       	jmp    800102 <umain+0xcf>
			panic("write: %e", i);
  80024d:	56                   	push   %esi
  80024e:	68 1d 2e 80 00       	push   $0x802e1d
  800253:	6a 25                	push   $0x25
  800255:	68 75 2d 80 00       	push   $0x802d75
  80025a:	e8 2f 01 00 00       	call   80038e <_panic>
		panic("pipe: %e", i);
  80025f:	50                   	push   %eax
  800260:	68 6c 2d 80 00       	push   $0x802d6c
  800265:	6a 2c                	push   $0x2c
  800267:	68 75 2d 80 00       	push   $0x802d75
  80026c:	e8 1d 01 00 00       	call   80038e <_panic>
		panic("fork: %e", i);
  800271:	56                   	push   %esi
  800272:	68 85 2d 80 00       	push   $0x802d85
  800277:	6a 2f                	push   $0x2f
  800279:	68 75 2d 80 00       	push   $0x802d75
  80027e:	e8 0b 01 00 00       	call   80038e <_panic>
		close(p[0]);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 8c             	pushl  -0x74(%ebp)
  800289:	e8 ae 16 00 00       	call   80193c <close>
  80028e:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800291:	83 ec 0c             	sub    $0xc,%esp
  800294:	68 34 2e 80 00       	push   $0x802e34
  800299:	e8 e6 01 00 00       	call   800484 <cprintf>
			if (write(p[1], "x", 1) != 1)
  80029e:	83 c4 0c             	add    $0xc,%esp
  8002a1:	6a 01                	push   $0x1
  8002a3:	68 36 2e 80 00       	push   $0x802e36
  8002a8:	ff 75 90             	pushl  -0x70(%ebp)
  8002ab:	e8 96 18 00 00       	call   801b46 <write>
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	83 f8 01             	cmp    $0x1,%eax
  8002b6:	74 d9                	je     800291 <umain+0x25e>
		cprintf("\npipe write closed properly\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 38 2e 80 00       	push   $0x802e38
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

	cprintf("in libmain.c call umain!\n");
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	68 ac 2e 80 00       	push   $0x802eac
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
  80037a:	e8 ea 15 00 00       	call   801969 <close_all>
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
  80039e:	68 00 2f 80 00       	push   $0x802f00
  8003a3:	50                   	push   %eax
  8003a4:	68 d0 2e 80 00       	push   $0x802ed0
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
  8003c7:	68 dc 2e 80 00       	push   $0x802edc
  8003cc:	e8 b3 00 00 00       	call   800484 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d1:	83 c4 18             	add    $0x18,%esp
  8003d4:	53                   	push   %ebx
  8003d5:	ff 75 10             	pushl  0x10(%ebp)
  8003d8:	e8 56 00 00 00       	call   800433 <vcprintf>
	cprintf("\n");
  8003dd:	c7 04 24 c4 2e 80 00 	movl   $0x802ec4,(%esp)
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
  800531:	e8 da 25 00 00       	call   802b10 <__udivdi3>
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
  80055a:	e8 c1 26 00 00       	call   802c20 <__umoddi3>
  80055f:	83 c4 14             	add    $0x14,%esp
  800562:	0f be 80 07 2f 80 00 	movsbl 0x802f07(%eax),%eax
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
  80060b:	ff 24 85 e0 30 80 00 	jmp    *0x8030e0(,%eax,4)
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
  8006d6:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  8006dd:	85 d2                	test   %edx,%edx
  8006df:	74 18                	je     8006f9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8006e1:	52                   	push   %edx
  8006e2:	68 49 34 80 00       	push   $0x803449
  8006e7:	53                   	push   %ebx
  8006e8:	56                   	push   %esi
  8006e9:	e8 a6 fe ff ff       	call   800594 <printfmt>
  8006ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006f1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8006f4:	e9 fe 02 00 00       	jmp    8009f7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8006f9:	50                   	push   %eax
  8006fa:	68 1f 2f 80 00       	push   $0x802f1f
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
  800721:	b8 18 2f 80 00       	mov    $0x802f18,%eax
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
  800ab9:	bf 3d 30 80 00       	mov    $0x80303d,%edi
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
  800ae5:	bf 75 30 80 00       	mov    $0x803075,%edi
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
  800f86:	68 84 32 80 00       	push   $0x803284
  800f8b:	6a 43                	push   $0x43
  800f8d:	68 a1 32 80 00       	push   $0x8032a1
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
  801007:	68 84 32 80 00       	push   $0x803284
  80100c:	6a 43                	push   $0x43
  80100e:	68 a1 32 80 00       	push   $0x8032a1
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
  801049:	68 84 32 80 00       	push   $0x803284
  80104e:	6a 43                	push   $0x43
  801050:	68 a1 32 80 00       	push   $0x8032a1
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
  80108b:	68 84 32 80 00       	push   $0x803284
  801090:	6a 43                	push   $0x43
  801092:	68 a1 32 80 00       	push   $0x8032a1
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
  8010cd:	68 84 32 80 00       	push   $0x803284
  8010d2:	6a 43                	push   $0x43
  8010d4:	68 a1 32 80 00       	push   $0x8032a1
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
  80110f:	68 84 32 80 00       	push   $0x803284
  801114:	6a 43                	push   $0x43
  801116:	68 a1 32 80 00       	push   $0x8032a1
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
  801151:	68 84 32 80 00       	push   $0x803284
  801156:	6a 43                	push   $0x43
  801158:	68 a1 32 80 00       	push   $0x8032a1
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
  8011b5:	68 84 32 80 00       	push   $0x803284
  8011ba:	6a 43                	push   $0x43
  8011bc:	68 a1 32 80 00       	push   $0x8032a1
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
  801299:	68 84 32 80 00       	push   $0x803284
  80129e:	6a 43                	push   $0x43
  8012a0:	68 a1 32 80 00       	push   $0x8032a1
  8012a5:	e8 e4 f0 ff ff       	call   80038e <_panic>

008012aa <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8012b1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012b8:	f6 c5 04             	test   $0x4,%ch
  8012bb:	75 45                	jne    801302 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8012bd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012c4:	83 e1 07             	and    $0x7,%ecx
  8012c7:	83 f9 07             	cmp    $0x7,%ecx
  8012ca:	74 6f                	je     80133b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012cc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012d3:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8012d9:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8012df:	0f 84 b6 00 00 00    	je     80139b <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012e5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8012ec:	83 e1 05             	and    $0x5,%ecx
  8012ef:	83 f9 05             	cmp    $0x5,%ecx
  8012f2:	0f 84 d7 00 00 00    	je     8013cf <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801300:	c9                   	leave  
  801301:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801302:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801309:	c1 e2 0c             	shl    $0xc,%edx
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801315:	51                   	push   %ecx
  801316:	52                   	push   %edx
  801317:	50                   	push   %eax
  801318:	52                   	push   %edx
  801319:	6a 00                	push   $0x0
  80131b:	e8 f8 fc ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  801320:	83 c4 20             	add    $0x20,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	79 d1                	jns    8012f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	68 af 32 80 00       	push   $0x8032af
  80132f:	6a 54                	push   $0x54
  801331:	68 c5 32 80 00       	push   $0x8032c5
  801336:	e8 53 f0 ff ff       	call   80038e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80133b:	89 d3                	mov    %edx,%ebx
  80133d:	c1 e3 0c             	shl    $0xc,%ebx
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	68 05 08 00 00       	push   $0x805
  801348:	53                   	push   %ebx
  801349:	50                   	push   %eax
  80134a:	53                   	push   %ebx
  80134b:	6a 00                	push   $0x0
  80134d:	e8 c6 fc ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  801352:	83 c4 20             	add    $0x20,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 2e                	js     801387 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801359:	83 ec 0c             	sub    $0xc,%esp
  80135c:	68 05 08 00 00       	push   $0x805
  801361:	53                   	push   %ebx
  801362:	6a 00                	push   $0x0
  801364:	53                   	push   %ebx
  801365:	6a 00                	push   $0x0
  801367:	e8 ac fc ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  80136c:	83 c4 20             	add    $0x20,%esp
  80136f:	85 c0                	test   %eax,%eax
  801371:	79 85                	jns    8012f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801373:	83 ec 04             	sub    $0x4,%esp
  801376:	68 af 32 80 00       	push   $0x8032af
  80137b:	6a 5f                	push   $0x5f
  80137d:	68 c5 32 80 00       	push   $0x8032c5
  801382:	e8 07 f0 ff ff       	call   80038e <_panic>
			panic("sys_page_map() panic\n");
  801387:	83 ec 04             	sub    $0x4,%esp
  80138a:	68 af 32 80 00       	push   $0x8032af
  80138f:	6a 5b                	push   $0x5b
  801391:	68 c5 32 80 00       	push   $0x8032c5
  801396:	e8 f3 ef ff ff       	call   80038e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80139b:	c1 e2 0c             	shl    $0xc,%edx
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	68 05 08 00 00       	push   $0x805
  8013a6:	52                   	push   %edx
  8013a7:	50                   	push   %eax
  8013a8:	52                   	push   %edx
  8013a9:	6a 00                	push   $0x0
  8013ab:	e8 68 fc ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  8013b0:	83 c4 20             	add    $0x20,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	0f 89 3d ff ff ff    	jns    8012f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	68 af 32 80 00       	push   $0x8032af
  8013c3:	6a 66                	push   $0x66
  8013c5:	68 c5 32 80 00       	push   $0x8032c5
  8013ca:	e8 bf ef ff ff       	call   80038e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013cf:	c1 e2 0c             	shl    $0xc,%edx
  8013d2:	83 ec 0c             	sub    $0xc,%esp
  8013d5:	6a 05                	push   $0x5
  8013d7:	52                   	push   %edx
  8013d8:	50                   	push   %eax
  8013d9:	52                   	push   %edx
  8013da:	6a 00                	push   $0x0
  8013dc:	e8 37 fc ff ff       	call   801018 <sys_page_map>
		if(r < 0)
  8013e1:	83 c4 20             	add    $0x20,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	0f 89 0c ff ff ff    	jns    8012f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	68 af 32 80 00       	push   $0x8032af
  8013f4:	6a 6d                	push   $0x6d
  8013f6:	68 c5 32 80 00       	push   $0x8032c5
  8013fb:	e8 8e ef ff ff       	call   80038e <_panic>

00801400 <pgfault>:
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	53                   	push   %ebx
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80140a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80140c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801410:	0f 84 99 00 00 00    	je     8014af <pgfault+0xaf>
  801416:	89 c2                	mov    %eax,%edx
  801418:	c1 ea 16             	shr    $0x16,%edx
  80141b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801422:	f6 c2 01             	test   $0x1,%dl
  801425:	0f 84 84 00 00 00    	je     8014af <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80142b:	89 c2                	mov    %eax,%edx
  80142d:	c1 ea 0c             	shr    $0xc,%edx
  801430:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801437:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80143d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801443:	75 6a                	jne    8014af <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801445:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80144a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	6a 07                	push   $0x7
  801451:	68 00 f0 7f 00       	push   $0x7ff000
  801456:	6a 00                	push   $0x0
  801458:	e8 78 fb ff ff       	call   800fd5 <sys_page_alloc>
	if(ret < 0)
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 5f                	js     8014c3 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	68 00 10 00 00       	push   $0x1000
  80146c:	53                   	push   %ebx
  80146d:	68 00 f0 7f 00       	push   $0x7ff000
  801472:	e8 5c f9 ff ff       	call   800dd3 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801477:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80147e:	53                   	push   %ebx
  80147f:	6a 00                	push   $0x0
  801481:	68 00 f0 7f 00       	push   $0x7ff000
  801486:	6a 00                	push   $0x0
  801488:	e8 8b fb ff ff       	call   801018 <sys_page_map>
	if(ret < 0)
  80148d:	83 c4 20             	add    $0x20,%esp
  801490:	85 c0                	test   %eax,%eax
  801492:	78 43                	js     8014d7 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	68 00 f0 7f 00       	push   $0x7ff000
  80149c:	6a 00                	push   $0x0
  80149e:	e8 b7 fb ff ff       	call   80105a <sys_page_unmap>
	if(ret < 0)
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 41                	js     8014eb <pgfault+0xeb>
}
  8014aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    
		panic("panic at pgfault()\n");
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	68 d0 32 80 00       	push   $0x8032d0
  8014b7:	6a 26                	push   $0x26
  8014b9:	68 c5 32 80 00       	push   $0x8032c5
  8014be:	e8 cb ee ff ff       	call   80038e <_panic>
		panic("panic in sys_page_alloc()\n");
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 e4 32 80 00       	push   $0x8032e4
  8014cb:	6a 31                	push   $0x31
  8014cd:	68 c5 32 80 00       	push   $0x8032c5
  8014d2:	e8 b7 ee ff ff       	call   80038e <_panic>
		panic("panic in sys_page_map()\n");
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	68 ff 32 80 00       	push   $0x8032ff
  8014df:	6a 36                	push   $0x36
  8014e1:	68 c5 32 80 00       	push   $0x8032c5
  8014e6:	e8 a3 ee ff ff       	call   80038e <_panic>
		panic("panic in sys_page_unmap()\n");
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	68 18 33 80 00       	push   $0x803318
  8014f3:	6a 39                	push   $0x39
  8014f5:	68 c5 32 80 00       	push   $0x8032c5
  8014fa:	e8 8f ee ff ff       	call   80038e <_panic>

008014ff <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	57                   	push   %edi
  801503:	56                   	push   %esi
  801504:	53                   	push   %ebx
  801505:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801508:	68 00 14 80 00       	push   $0x801400
  80150d:	e8 24 14 00 00       	call   802936 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801512:	b8 07 00 00 00       	mov    $0x7,%eax
  801517:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 27                	js     801547 <fork+0x48>
  801520:	89 c6                	mov    %eax,%esi
  801522:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801524:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801529:	75 48                	jne    801573 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80152b:	e8 67 fa ff ff       	call   800f97 <sys_getenvid>
  801530:	25 ff 03 00 00       	and    $0x3ff,%eax
  801535:	c1 e0 07             	shl    $0x7,%eax
  801538:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80153d:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801542:	e9 90 00 00 00       	jmp    8015d7 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	68 34 33 80 00       	push   $0x803334
  80154f:	68 8c 00 00 00       	push   $0x8c
  801554:	68 c5 32 80 00       	push   $0x8032c5
  801559:	e8 30 ee ff ff       	call   80038e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80155e:	89 f8                	mov    %edi,%eax
  801560:	e8 45 fd ff ff       	call   8012aa <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801565:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80156b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801571:	74 26                	je     801599 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801573:	89 d8                	mov    %ebx,%eax
  801575:	c1 e8 16             	shr    $0x16,%eax
  801578:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80157f:	a8 01                	test   $0x1,%al
  801581:	74 e2                	je     801565 <fork+0x66>
  801583:	89 da                	mov    %ebx,%edx
  801585:	c1 ea 0c             	shr    $0xc,%edx
  801588:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80158f:	83 e0 05             	and    $0x5,%eax
  801592:	83 f8 05             	cmp    $0x5,%eax
  801595:	75 ce                	jne    801565 <fork+0x66>
  801597:	eb c5                	jmp    80155e <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	6a 07                	push   $0x7
  80159e:	68 00 f0 bf ee       	push   $0xeebff000
  8015a3:	56                   	push   %esi
  8015a4:	e8 2c fa ff ff       	call   800fd5 <sys_page_alloc>
	if(ret < 0)
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 31                	js     8015e1 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	68 a5 29 80 00       	push   $0x8029a5
  8015b8:	56                   	push   %esi
  8015b9:	e8 62 fb ff ff       	call   801120 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 33                	js     8015f8 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	6a 02                	push   $0x2
  8015ca:	56                   	push   %esi
  8015cb:	e8 cc fa ff ff       	call   80109c <sys_env_set_status>
	if(ret < 0)
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	78 38                	js     80160f <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8015d7:	89 f0                	mov    %esi,%eax
  8015d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dc:	5b                   	pop    %ebx
  8015dd:	5e                   	pop    %esi
  8015de:	5f                   	pop    %edi
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 e4 32 80 00       	push   $0x8032e4
  8015e9:	68 98 00 00 00       	push   $0x98
  8015ee:	68 c5 32 80 00       	push   $0x8032c5
  8015f3:	e8 96 ed ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 58 33 80 00       	push   $0x803358
  801600:	68 9b 00 00 00       	push   $0x9b
  801605:	68 c5 32 80 00       	push   $0x8032c5
  80160a:	e8 7f ed ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_status()\n");
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 80 33 80 00       	push   $0x803380
  801617:	68 9e 00 00 00       	push   $0x9e
  80161c:	68 c5 32 80 00       	push   $0x8032c5
  801621:	e8 68 ed ff ff       	call   80038e <_panic>

00801626 <sfork>:

// Challenge!
int
sfork(void)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	57                   	push   %edi
  80162a:	56                   	push   %esi
  80162b:	53                   	push   %ebx
  80162c:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80162f:	68 00 14 80 00       	push   $0x801400
  801634:	e8 fd 12 00 00       	call   802936 <set_pgfault_handler>
  801639:	b8 07 00 00 00       	mov    $0x7,%eax
  80163e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	78 27                	js     80166e <sfork+0x48>
  801647:	89 c7                	mov    %eax,%edi
  801649:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80164b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801650:	75 55                	jne    8016a7 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801652:	e8 40 f9 ff ff       	call   800f97 <sys_getenvid>
  801657:	25 ff 03 00 00       	and    $0x3ff,%eax
  80165c:	c1 e0 07             	shl    $0x7,%eax
  80165f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801664:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801669:	e9 d4 00 00 00       	jmp    801742 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	68 34 33 80 00       	push   $0x803334
  801676:	68 af 00 00 00       	push   $0xaf
  80167b:	68 c5 32 80 00       	push   $0x8032c5
  801680:	e8 09 ed ff ff       	call   80038e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801685:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80168a:	89 f0                	mov    %esi,%eax
  80168c:	e8 19 fc ff ff       	call   8012aa <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801697:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80169d:	77 65                	ja     801704 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80169f:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8016a5:	74 de                	je     801685 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8016a7:	89 d8                	mov    %ebx,%eax
  8016a9:	c1 e8 16             	shr    $0x16,%eax
  8016ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016b3:	a8 01                	test   $0x1,%al
  8016b5:	74 da                	je     801691 <sfork+0x6b>
  8016b7:	89 da                	mov    %ebx,%edx
  8016b9:	c1 ea 0c             	shr    $0xc,%edx
  8016bc:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016c3:	83 e0 05             	and    $0x5,%eax
  8016c6:	83 f8 05             	cmp    $0x5,%eax
  8016c9:	75 c6                	jne    801691 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8016cb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8016d2:	c1 e2 0c             	shl    $0xc,%edx
  8016d5:	83 ec 0c             	sub    $0xc,%esp
  8016d8:	83 e0 07             	and    $0x7,%eax
  8016db:	50                   	push   %eax
  8016dc:	52                   	push   %edx
  8016dd:	56                   	push   %esi
  8016de:	52                   	push   %edx
  8016df:	6a 00                	push   $0x0
  8016e1:	e8 32 f9 ff ff       	call   801018 <sys_page_map>
  8016e6:	83 c4 20             	add    $0x20,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	74 a4                	je     801691 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	68 af 32 80 00       	push   $0x8032af
  8016f5:	68 ba 00 00 00       	push   $0xba
  8016fa:	68 c5 32 80 00       	push   $0x8032c5
  8016ff:	e8 8a ec ff ff       	call   80038e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801704:	83 ec 04             	sub    $0x4,%esp
  801707:	6a 07                	push   $0x7
  801709:	68 00 f0 bf ee       	push   $0xeebff000
  80170e:	57                   	push   %edi
  80170f:	e8 c1 f8 ff ff       	call   800fd5 <sys_page_alloc>
	if(ret < 0)
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	85 c0                	test   %eax,%eax
  801719:	78 31                	js     80174c <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	68 a5 29 80 00       	push   $0x8029a5
  801723:	57                   	push   %edi
  801724:	e8 f7 f9 ff ff       	call   801120 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	85 c0                	test   %eax,%eax
  80172e:	78 33                	js     801763 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801730:	83 ec 08             	sub    $0x8,%esp
  801733:	6a 02                	push   $0x2
  801735:	57                   	push   %edi
  801736:	e8 61 f9 ff ff       	call   80109c <sys_env_set_status>
	if(ret < 0)
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 38                	js     80177a <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801742:	89 f8                	mov    %edi,%eax
  801744:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5f                   	pop    %edi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 e4 32 80 00       	push   $0x8032e4
  801754:	68 c0 00 00 00       	push   $0xc0
  801759:	68 c5 32 80 00       	push   $0x8032c5
  80175e:	e8 2b ec ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	68 58 33 80 00       	push   $0x803358
  80176b:	68 c3 00 00 00       	push   $0xc3
  801770:	68 c5 32 80 00       	push   $0x8032c5
  801775:	e8 14 ec ff ff       	call   80038e <_panic>
		panic("panic in sys_env_set_status()\n");
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	68 80 33 80 00       	push   $0x803380
  801782:	68 c6 00 00 00       	push   $0xc6
  801787:	68 c5 32 80 00       	push   $0x8032c5
  80178c:	e8 fd eb ff ff       	call   80038e <_panic>

00801791 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	05 00 00 00 30       	add    $0x30000000,%eax
  80179c:	c1 e8 0c             	shr    $0xc,%eax
}
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    

008017a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	c1 ea 16             	shr    $0x16,%edx
  8017c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017cc:	f6 c2 01             	test   $0x1,%dl
  8017cf:	74 2d                	je     8017fe <fd_alloc+0x46>
  8017d1:	89 c2                	mov    %eax,%edx
  8017d3:	c1 ea 0c             	shr    $0xc,%edx
  8017d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017dd:	f6 c2 01             	test   $0x1,%dl
  8017e0:	74 1c                	je     8017fe <fd_alloc+0x46>
  8017e2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017e7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017ec:	75 d2                	jne    8017c0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017f7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017fc:	eb 0a                	jmp    801808 <fd_alloc+0x50>
			*fd_store = fd;
  8017fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801801:	89 01                	mov    %eax,(%ecx)
			return 0;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    

0080180a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801810:	83 f8 1f             	cmp    $0x1f,%eax
  801813:	77 30                	ja     801845 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801815:	c1 e0 0c             	shl    $0xc,%eax
  801818:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80181d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801823:	f6 c2 01             	test   $0x1,%dl
  801826:	74 24                	je     80184c <fd_lookup+0x42>
  801828:	89 c2                	mov    %eax,%edx
  80182a:	c1 ea 0c             	shr    $0xc,%edx
  80182d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801834:	f6 c2 01             	test   $0x1,%dl
  801837:	74 1a                	je     801853 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183c:	89 02                	mov    %eax,(%edx)
	return 0;
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    
		return -E_INVAL;
  801845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184a:	eb f7                	jmp    801843 <fd_lookup+0x39>
		return -E_INVAL;
  80184c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801851:	eb f0                	jmp    801843 <fd_lookup+0x39>
  801853:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801858:	eb e9                	jmp    801843 <fd_lookup+0x39>

0080185a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801863:	ba 00 00 00 00       	mov    $0x0,%edx
  801868:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80186d:	39 08                	cmp    %ecx,(%eax)
  80186f:	74 38                	je     8018a9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801871:	83 c2 01             	add    $0x1,%edx
  801874:	8b 04 95 1c 34 80 00 	mov    0x80341c(,%edx,4),%eax
  80187b:	85 c0                	test   %eax,%eax
  80187d:	75 ee                	jne    80186d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80187f:	a1 08 50 80 00       	mov    0x805008,%eax
  801884:	8b 40 48             	mov    0x48(%eax),%eax
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	51                   	push   %ecx
  80188b:	50                   	push   %eax
  80188c:	68 a0 33 80 00       	push   $0x8033a0
  801891:	e8 ee eb ff ff       	call   800484 <cprintf>
	*dev = 0;
  801896:	8b 45 0c             	mov    0xc(%ebp),%eax
  801899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    
			*dev = devtab[i];
  8018a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ac:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b3:	eb f2                	jmp    8018a7 <dev_lookup+0x4d>

008018b5 <fd_close>:
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	57                   	push   %edi
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 24             	sub    $0x24,%esp
  8018be:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018c7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018c8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018ce:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d1:	50                   	push   %eax
  8018d2:	e8 33 ff ff ff       	call   80180a <fd_lookup>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 05                	js     8018e5 <fd_close+0x30>
	    || fd != fd2)
  8018e0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018e3:	74 16                	je     8018fb <fd_close+0x46>
		return (must_exist ? r : 0);
  8018e5:	89 f8                	mov    %edi,%eax
  8018e7:	84 c0                	test   %al,%al
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	0f 44 d8             	cmove  %eax,%ebx
}
  8018f1:	89 d8                	mov    %ebx,%eax
  8018f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5f                   	pop    %edi
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018fb:	83 ec 08             	sub    $0x8,%esp
  8018fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801901:	50                   	push   %eax
  801902:	ff 36                	pushl  (%esi)
  801904:	e8 51 ff ff ff       	call   80185a <dev_lookup>
  801909:	89 c3                	mov    %eax,%ebx
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	85 c0                	test   %eax,%eax
  801910:	78 1a                	js     80192c <fd_close+0x77>
		if (dev->dev_close)
  801912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801915:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801918:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80191d:	85 c0                	test   %eax,%eax
  80191f:	74 0b                	je     80192c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	56                   	push   %esi
  801925:	ff d0                	call   *%eax
  801927:	89 c3                	mov    %eax,%ebx
  801929:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	56                   	push   %esi
  801930:	6a 00                	push   $0x0
  801932:	e8 23 f7 ff ff       	call   80105a <sys_page_unmap>
	return r;
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	eb b5                	jmp    8018f1 <fd_close+0x3c>

0080193c <close>:

int
close(int fdnum)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801942:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801945:	50                   	push   %eax
  801946:	ff 75 08             	pushl  0x8(%ebp)
  801949:	e8 bc fe ff ff       	call   80180a <fd_lookup>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	79 02                	jns    801957 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    
		return fd_close(fd, 1);
  801957:	83 ec 08             	sub    $0x8,%esp
  80195a:	6a 01                	push   $0x1
  80195c:	ff 75 f4             	pushl  -0xc(%ebp)
  80195f:	e8 51 ff ff ff       	call   8018b5 <fd_close>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	eb ec                	jmp    801955 <close+0x19>

00801969 <close_all>:

void
close_all(void)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	53                   	push   %ebx
  80196d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801970:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	53                   	push   %ebx
  801979:	e8 be ff ff ff       	call   80193c <close>
	for (i = 0; i < MAXFD; i++)
  80197e:	83 c3 01             	add    $0x1,%ebx
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	83 fb 20             	cmp    $0x20,%ebx
  801987:	75 ec                	jne    801975 <close_all+0xc>
}
  801989:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801997:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80199a:	50                   	push   %eax
  80199b:	ff 75 08             	pushl  0x8(%ebp)
  80199e:	e8 67 fe ff ff       	call   80180a <fd_lookup>
  8019a3:	89 c3                	mov    %eax,%ebx
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	0f 88 81 00 00 00    	js     801a31 <dup+0xa3>
		return r;
	close(newfdnum);
  8019b0:	83 ec 0c             	sub    $0xc,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	e8 81 ff ff ff       	call   80193c <close>

	newfd = INDEX2FD(newfdnum);
  8019bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019be:	c1 e6 0c             	shl    $0xc,%esi
  8019c1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019c7:	83 c4 04             	add    $0x4,%esp
  8019ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019cd:	e8 cf fd ff ff       	call   8017a1 <fd2data>
  8019d2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019d4:	89 34 24             	mov    %esi,(%esp)
  8019d7:	e8 c5 fd ff ff       	call   8017a1 <fd2data>
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019e1:	89 d8                	mov    %ebx,%eax
  8019e3:	c1 e8 16             	shr    $0x16,%eax
  8019e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ed:	a8 01                	test   $0x1,%al
  8019ef:	74 11                	je     801a02 <dup+0x74>
  8019f1:	89 d8                	mov    %ebx,%eax
  8019f3:	c1 e8 0c             	shr    $0xc,%eax
  8019f6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019fd:	f6 c2 01             	test   $0x1,%dl
  801a00:	75 39                	jne    801a3b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a05:	89 d0                	mov    %edx,%eax
  801a07:	c1 e8 0c             	shr    $0xc,%eax
  801a0a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	25 07 0e 00 00       	and    $0xe07,%eax
  801a19:	50                   	push   %eax
  801a1a:	56                   	push   %esi
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	6a 00                	push   $0x0
  801a20:	e8 f3 f5 ff ff       	call   801018 <sys_page_map>
  801a25:	89 c3                	mov    %eax,%ebx
  801a27:	83 c4 20             	add    $0x20,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 31                	js     801a5f <dup+0xd1>
		goto err;

	return newfdnum;
  801a2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a31:	89 d8                	mov    %ebx,%eax
  801a33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a36:	5b                   	pop    %ebx
  801a37:	5e                   	pop    %esi
  801a38:	5f                   	pop    %edi
  801a39:	5d                   	pop    %ebp
  801a3a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a3b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a42:	83 ec 0c             	sub    $0xc,%esp
  801a45:	25 07 0e 00 00       	and    $0xe07,%eax
  801a4a:	50                   	push   %eax
  801a4b:	57                   	push   %edi
  801a4c:	6a 00                	push   $0x0
  801a4e:	53                   	push   %ebx
  801a4f:	6a 00                	push   $0x0
  801a51:	e8 c2 f5 ff ff       	call   801018 <sys_page_map>
  801a56:	89 c3                	mov    %eax,%ebx
  801a58:	83 c4 20             	add    $0x20,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	79 a3                	jns    801a02 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	56                   	push   %esi
  801a63:	6a 00                	push   $0x0
  801a65:	e8 f0 f5 ff ff       	call   80105a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	57                   	push   %edi
  801a6e:	6a 00                	push   $0x0
  801a70:	e8 e5 f5 ff ff       	call   80105a <sys_page_unmap>
	return r;
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	eb b7                	jmp    801a31 <dup+0xa3>

00801a7a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 1c             	sub    $0x1c,%esp
  801a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a87:	50                   	push   %eax
  801a88:	53                   	push   %ebx
  801a89:	e8 7c fd ff ff       	call   80180a <fd_lookup>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 3f                	js     801ad4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9f:	ff 30                	pushl  (%eax)
  801aa1:	e8 b4 fd ff ff       	call   80185a <dev_lookup>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 27                	js     801ad4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801aad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab0:	8b 42 08             	mov    0x8(%edx),%eax
  801ab3:	83 e0 03             	and    $0x3,%eax
  801ab6:	83 f8 01             	cmp    $0x1,%eax
  801ab9:	74 1e                	je     801ad9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abe:	8b 40 08             	mov    0x8(%eax),%eax
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	74 35                	je     801afa <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	ff 75 10             	pushl  0x10(%ebp)
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	52                   	push   %edx
  801acf:	ff d0                	call   *%eax
  801ad1:	83 c4 10             	add    $0x10,%esp
}
  801ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad9:	a1 08 50 80 00       	mov    0x805008,%eax
  801ade:	8b 40 48             	mov    0x48(%eax),%eax
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	53                   	push   %ebx
  801ae5:	50                   	push   %eax
  801ae6:	68 e1 33 80 00       	push   $0x8033e1
  801aeb:	e8 94 e9 ff ff       	call   800484 <cprintf>
		return -E_INVAL;
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af8:	eb da                	jmp    801ad4 <read+0x5a>
		return -E_NOT_SUPP;
  801afa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aff:	eb d3                	jmp    801ad4 <read+0x5a>

00801b01 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	57                   	push   %edi
  801b05:	56                   	push   %esi
  801b06:	53                   	push   %ebx
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b0d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b10:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b15:	39 f3                	cmp    %esi,%ebx
  801b17:	73 23                	jae    801b3c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	89 f0                	mov    %esi,%eax
  801b1e:	29 d8                	sub    %ebx,%eax
  801b20:	50                   	push   %eax
  801b21:	89 d8                	mov    %ebx,%eax
  801b23:	03 45 0c             	add    0xc(%ebp),%eax
  801b26:	50                   	push   %eax
  801b27:	57                   	push   %edi
  801b28:	e8 4d ff ff ff       	call   801a7a <read>
		if (m < 0)
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	85 c0                	test   %eax,%eax
  801b32:	78 06                	js     801b3a <readn+0x39>
			return m;
		if (m == 0)
  801b34:	74 06                	je     801b3c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b36:	01 c3                	add    %eax,%ebx
  801b38:	eb db                	jmp    801b15 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b3a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b3c:	89 d8                	mov    %ebx,%eax
  801b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 1c             	sub    $0x1c,%esp
  801b4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b53:	50                   	push   %eax
  801b54:	53                   	push   %ebx
  801b55:	e8 b0 fc ff ff       	call   80180a <fd_lookup>
  801b5a:	83 c4 10             	add    $0x10,%esp
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 3a                	js     801b9b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6b:	ff 30                	pushl  (%eax)
  801b6d:	e8 e8 fc ff ff       	call   80185a <dev_lookup>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 22                	js     801b9b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b80:	74 1e                	je     801ba0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b85:	8b 52 0c             	mov    0xc(%edx),%edx
  801b88:	85 d2                	test   %edx,%edx
  801b8a:	74 35                	je     801bc1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	ff 75 10             	pushl  0x10(%ebp)
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	50                   	push   %eax
  801b96:	ff d2                	call   *%edx
  801b98:	83 c4 10             	add    $0x10,%esp
}
  801b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ba0:	a1 08 50 80 00       	mov    0x805008,%eax
  801ba5:	8b 40 48             	mov    0x48(%eax),%eax
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	53                   	push   %ebx
  801bac:	50                   	push   %eax
  801bad:	68 fd 33 80 00       	push   $0x8033fd
  801bb2:	e8 cd e8 ff ff       	call   800484 <cprintf>
		return -E_INVAL;
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bbf:	eb da                	jmp    801b9b <write+0x55>
		return -E_NOT_SUPP;
  801bc1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc6:	eb d3                	jmp    801b9b <write+0x55>

00801bc8 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd1:	50                   	push   %eax
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	e8 30 fc ff ff       	call   80180a <fd_lookup>
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	78 0e                	js     801bef <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	53                   	push   %ebx
  801bf5:	83 ec 1c             	sub    $0x1c,%esp
  801bf8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfe:	50                   	push   %eax
  801bff:	53                   	push   %ebx
  801c00:	e8 05 fc ff ff       	call   80180a <fd_lookup>
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	78 37                	js     801c43 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c12:	50                   	push   %eax
  801c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c16:	ff 30                	pushl  (%eax)
  801c18:	e8 3d fc ff ff       	call   80185a <dev_lookup>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	85 c0                	test   %eax,%eax
  801c22:	78 1f                	js     801c43 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c2b:	74 1b                	je     801c48 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c30:	8b 52 18             	mov    0x18(%edx),%edx
  801c33:	85 d2                	test   %edx,%edx
  801c35:	74 32                	je     801c69 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	ff d2                	call   *%edx
  801c40:	83 c4 10             	add    $0x10,%esp
}
  801c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c48:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c4d:	8b 40 48             	mov    0x48(%eax),%eax
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	53                   	push   %ebx
  801c54:	50                   	push   %eax
  801c55:	68 c0 33 80 00       	push   $0x8033c0
  801c5a:	e8 25 e8 ff ff       	call   800484 <cprintf>
		return -E_INVAL;
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c67:	eb da                	jmp    801c43 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c6e:	eb d3                	jmp    801c43 <ftruncate+0x52>

00801c70 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c7d:	50                   	push   %eax
  801c7e:	ff 75 08             	pushl  0x8(%ebp)
  801c81:	e8 84 fb ff ff       	call   80180a <fd_lookup>
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	78 4b                	js     801cd8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c93:	50                   	push   %eax
  801c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c97:	ff 30                	pushl  (%eax)
  801c99:	e8 bc fb ff ff       	call   80185a <dev_lookup>
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	78 33                	js     801cd8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cac:	74 2f                	je     801cdd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cae:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cb1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cb8:	00 00 00 
	stat->st_isdir = 0;
  801cbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cc2:	00 00 00 
	stat->st_dev = dev;
  801cc5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ccb:	83 ec 08             	sub    $0x8,%esp
  801cce:	53                   	push   %ebx
  801ccf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd2:	ff 50 14             	call   *0x14(%eax)
  801cd5:	83 c4 10             	add    $0x10,%esp
}
  801cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    
		return -E_NOT_SUPP;
  801cdd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ce2:	eb f4                	jmp    801cd8 <fstat+0x68>

00801ce4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	56                   	push   %esi
  801ce8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ce9:	83 ec 08             	sub    $0x8,%esp
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	e8 22 02 00 00       	call   801f18 <open>
  801cf6:	89 c3                	mov    %eax,%ebx
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 1b                	js     801d1a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	e8 65 ff ff ff       	call   801c70 <fstat>
  801d0b:	89 c6                	mov    %eax,%esi
	close(fd);
  801d0d:	89 1c 24             	mov    %ebx,(%esp)
  801d10:	e8 27 fc ff ff       	call   80193c <close>
	return r;
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	89 f3                	mov    %esi,%ebx
}
  801d1a:	89 d8                	mov    %ebx,%eax
  801d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    

00801d23 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	89 c6                	mov    %eax,%esi
  801d2a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d2c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d33:	74 27                	je     801d5c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d35:	6a 07                	push   $0x7
  801d37:	68 00 60 80 00       	push   $0x806000
  801d3c:	56                   	push   %esi
  801d3d:	ff 35 00 50 80 00    	pushl  0x805000
  801d43:	e8 ec 0c 00 00       	call   802a34 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d48:	83 c4 0c             	add    $0xc,%esp
  801d4b:	6a 00                	push   $0x0
  801d4d:	53                   	push   %ebx
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 76 0c 00 00       	call   8029cb <ipc_recv>
}
  801d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d58:	5b                   	pop    %ebx
  801d59:	5e                   	pop    %esi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d5c:	83 ec 0c             	sub    $0xc,%esp
  801d5f:	6a 01                	push   $0x1
  801d61:	e8 26 0d 00 00       	call   802a8c <ipc_find_env>
  801d66:	a3 00 50 80 00       	mov    %eax,0x805000
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	eb c5                	jmp    801d35 <fsipc+0x12>

00801d70 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d84:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d89:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d93:	e8 8b ff ff ff       	call   801d23 <fsipc>
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <devfile_flush>:
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8b 40 0c             	mov    0xc(%eax),%eax
  801da6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	b8 06 00 00 00       	mov    $0x6,%eax
  801db5:	e8 69 ff ff ff       	call   801d23 <fsipc>
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <devfile_stat>:
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 04             	sub    $0x4,%esp
  801dc3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcc:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd6:	b8 05 00 00 00       	mov    $0x5,%eax
  801ddb:	e8 43 ff ff ff       	call   801d23 <fsipc>
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 2c                	js     801e10 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801de4:	83 ec 08             	sub    $0x8,%esp
  801de7:	68 00 60 80 00       	push   $0x806000
  801dec:	53                   	push   %ebx
  801ded:	e8 f1 ed ff ff       	call   800be3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801df2:	a1 80 60 80 00       	mov    0x806080,%eax
  801df7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dfd:	a1 84 60 80 00       	mov    0x806084,%eax
  801e02:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <devfile_write>:
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	53                   	push   %ebx
  801e19:	83 ec 08             	sub    $0x8,%esp
  801e1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	8b 40 0c             	mov    0xc(%eax),%eax
  801e25:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e2a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e30:	53                   	push   %ebx
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	68 08 60 80 00       	push   $0x806008
  801e39:	e8 95 ef ff ff       	call   800dd3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e43:	b8 04 00 00 00       	mov    $0x4,%eax
  801e48:	e8 d6 fe ff ff       	call   801d23 <fsipc>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 0b                	js     801e5f <devfile_write+0x4a>
	assert(r <= n);
  801e54:	39 d8                	cmp    %ebx,%eax
  801e56:	77 0c                	ja     801e64 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e58:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e5d:	7f 1e                	jg     801e7d <devfile_write+0x68>
}
  801e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    
	assert(r <= n);
  801e64:	68 30 34 80 00       	push   $0x803430
  801e69:	68 37 34 80 00       	push   $0x803437
  801e6e:	68 98 00 00 00       	push   $0x98
  801e73:	68 4c 34 80 00       	push   $0x80344c
  801e78:	e8 11 e5 ff ff       	call   80038e <_panic>
	assert(r <= PGSIZE);
  801e7d:	68 57 34 80 00       	push   $0x803457
  801e82:	68 37 34 80 00       	push   $0x803437
  801e87:	68 99 00 00 00       	push   $0x99
  801e8c:	68 4c 34 80 00       	push   $0x80344c
  801e91:	e8 f8 e4 ff ff       	call   80038e <_panic>

00801e96 <devfile_read>:
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
  801e9b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ea9:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801eaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb4:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb9:	e8 65 fe ff ff       	call   801d23 <fsipc>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 1f                	js     801ee3 <devfile_read+0x4d>
	assert(r <= n);
  801ec4:	39 f0                	cmp    %esi,%eax
  801ec6:	77 24                	ja     801eec <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ec8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ecd:	7f 33                	jg     801f02 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	50                   	push   %eax
  801ed3:	68 00 60 80 00       	push   $0x806000
  801ed8:	ff 75 0c             	pushl  0xc(%ebp)
  801edb:	e8 91 ee ff ff       	call   800d71 <memmove>
	return r;
  801ee0:	83 c4 10             	add    $0x10,%esp
}
  801ee3:	89 d8                	mov    %ebx,%eax
  801ee5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee8:	5b                   	pop    %ebx
  801ee9:	5e                   	pop    %esi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
	assert(r <= n);
  801eec:	68 30 34 80 00       	push   $0x803430
  801ef1:	68 37 34 80 00       	push   $0x803437
  801ef6:	6a 7c                	push   $0x7c
  801ef8:	68 4c 34 80 00       	push   $0x80344c
  801efd:	e8 8c e4 ff ff       	call   80038e <_panic>
	assert(r <= PGSIZE);
  801f02:	68 57 34 80 00       	push   $0x803457
  801f07:	68 37 34 80 00       	push   $0x803437
  801f0c:	6a 7d                	push   $0x7d
  801f0e:	68 4c 34 80 00       	push   $0x80344c
  801f13:	e8 76 e4 ff ff       	call   80038e <_panic>

00801f18 <open>:
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 1c             	sub    $0x1c,%esp
  801f20:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f23:	56                   	push   %esi
  801f24:	e8 81 ec ff ff       	call   800baa <strlen>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f31:	7f 6c                	jg     801f9f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f39:	50                   	push   %eax
  801f3a:	e8 79 f8 ff ff       	call   8017b8 <fd_alloc>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 3c                	js     801f84 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f48:	83 ec 08             	sub    $0x8,%esp
  801f4b:	56                   	push   %esi
  801f4c:	68 00 60 80 00       	push   $0x806000
  801f51:	e8 8d ec ff ff       	call   800be3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	e8 b8 fd ff ff       	call   801d23 <fsipc>
  801f6b:	89 c3                	mov    %eax,%ebx
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	85 c0                	test   %eax,%eax
  801f72:	78 19                	js     801f8d <open+0x75>
	return fd2num(fd);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	e8 12 f8 ff ff       	call   801791 <fd2num>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
}
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    
		fd_close(fd, 0);
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	6a 00                	push   $0x0
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	e8 1b f9 ff ff       	call   8018b5 <fd_close>
		return r;
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	eb e5                	jmp    801f84 <open+0x6c>
		return -E_BAD_PATH;
  801f9f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fa4:	eb de                	jmp    801f84 <open+0x6c>

00801fa6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fac:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb1:	b8 08 00 00 00       	mov    $0x8,%eax
  801fb6:	e8 68 fd ff ff       	call   801d23 <fsipc>
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fc3:	68 63 34 80 00       	push   $0x803463
  801fc8:	ff 75 0c             	pushl  0xc(%ebp)
  801fcb:	e8 13 ec ff ff       	call   800be3 <strcpy>
	return 0;
}
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <devsock_close>:
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	53                   	push   %ebx
  801fdb:	83 ec 10             	sub    $0x10,%esp
  801fde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fe1:	53                   	push   %ebx
  801fe2:	e8 e0 0a 00 00       	call   802ac7 <pageref>
  801fe7:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fea:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fef:	83 f8 01             	cmp    $0x1,%eax
  801ff2:	74 07                	je     801ffb <devsock_close+0x24>
}
  801ff4:	89 d0                	mov    %edx,%eax
  801ff6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	ff 73 0c             	pushl  0xc(%ebx)
  802001:	e8 b9 02 00 00       	call   8022bf <nsipc_close>
  802006:	89 c2                	mov    %eax,%edx
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	eb e7                	jmp    801ff4 <devsock_close+0x1d>

0080200d <devsock_write>:
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802013:	6a 00                	push   $0x0
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	ff 70 0c             	pushl  0xc(%eax)
  802021:	e8 76 03 00 00       	call   80239c <nsipc_send>
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <devsock_read>:
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80202e:	6a 00                	push   $0x0
  802030:	ff 75 10             	pushl  0x10(%ebp)
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	ff 70 0c             	pushl  0xc(%eax)
  80203c:	e8 ef 02 00 00       	call   802330 <nsipc_recv>
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <fd2sockid>:
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802049:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80204c:	52                   	push   %edx
  80204d:	50                   	push   %eax
  80204e:	e8 b7 f7 ff ff       	call   80180a <fd_lookup>
  802053:	83 c4 10             	add    $0x10,%esp
  802056:	85 c0                	test   %eax,%eax
  802058:	78 10                	js     80206a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  802063:	39 08                	cmp    %ecx,(%eax)
  802065:	75 05                	jne    80206c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802067:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    
		return -E_NOT_SUPP;
  80206c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802071:	eb f7                	jmp    80206a <fd2sockid+0x27>

00802073 <alloc_sockfd>:
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	56                   	push   %esi
  802077:	53                   	push   %ebx
  802078:	83 ec 1c             	sub    $0x1c,%esp
  80207b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80207d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802080:	50                   	push   %eax
  802081:	e8 32 f7 ff ff       	call   8017b8 <fd_alloc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 43                	js     8020d2 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 07 04 00 00       	push   $0x407
  802097:	ff 75 f4             	pushl  -0xc(%ebp)
  80209a:	6a 00                	push   $0x0
  80209c:	e8 34 ef ff ff       	call   800fd5 <sys_page_alloc>
  8020a1:	89 c3                	mov    %eax,%ebx
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 28                	js     8020d2 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8020b3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020bf:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	50                   	push   %eax
  8020c6:	e8 c6 f6 ff ff       	call   801791 <fd2num>
  8020cb:	89 c3                	mov    %eax,%ebx
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	eb 0c                	jmp    8020de <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	56                   	push   %esi
  8020d6:	e8 e4 01 00 00       	call   8022bf <nsipc_close>
		return r;
  8020db:	83 c4 10             	add    $0x10,%esp
}
  8020de:	89 d8                	mov    %ebx,%eax
  8020e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    

008020e7 <accept>:
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	e8 4e ff ff ff       	call   802043 <fd2sockid>
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	78 1b                	js     802114 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	ff 75 10             	pushl  0x10(%ebp)
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	50                   	push   %eax
  802103:	e8 0e 01 00 00       	call   802216 <nsipc_accept>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 05                	js     802114 <accept+0x2d>
	return alloc_sockfd(r);
  80210f:	e8 5f ff ff ff       	call   802073 <alloc_sockfd>
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <bind>:
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	e8 1f ff ff ff       	call   802043 <fd2sockid>
  802124:	85 c0                	test   %eax,%eax
  802126:	78 12                	js     80213a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	ff 75 10             	pushl  0x10(%ebp)
  80212e:	ff 75 0c             	pushl  0xc(%ebp)
  802131:	50                   	push   %eax
  802132:	e8 31 01 00 00       	call   802268 <nsipc_bind>
  802137:	83 c4 10             	add    $0x10,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <shutdown>:
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	e8 f9 fe ff ff       	call   802043 <fd2sockid>
  80214a:	85 c0                	test   %eax,%eax
  80214c:	78 0f                	js     80215d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80214e:	83 ec 08             	sub    $0x8,%esp
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	50                   	push   %eax
  802155:	e8 43 01 00 00       	call   80229d <nsipc_shutdown>
  80215a:	83 c4 10             	add    $0x10,%esp
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <connect>:
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	e8 d6 fe ff ff       	call   802043 <fd2sockid>
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 12                	js     802183 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	ff 75 10             	pushl  0x10(%ebp)
  802177:	ff 75 0c             	pushl  0xc(%ebp)
  80217a:	50                   	push   %eax
  80217b:	e8 59 01 00 00       	call   8022d9 <nsipc_connect>
  802180:	83 c4 10             	add    $0x10,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <listen>:
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	e8 b0 fe ff ff       	call   802043 <fd2sockid>
  802193:	85 c0                	test   %eax,%eax
  802195:	78 0f                	js     8021a6 <listen+0x21>
	return nsipc_listen(r, backlog);
  802197:	83 ec 08             	sub    $0x8,%esp
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	50                   	push   %eax
  80219e:	e8 6b 01 00 00       	call   80230e <nsipc_listen>
  8021a3:	83 c4 10             	add    $0x10,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021ae:	ff 75 10             	pushl  0x10(%ebp)
  8021b1:	ff 75 0c             	pushl  0xc(%ebp)
  8021b4:	ff 75 08             	pushl  0x8(%ebp)
  8021b7:	e8 3e 02 00 00       	call   8023fa <nsipc_socket>
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	78 05                	js     8021c8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021c3:	e8 ab fe ff ff       	call   802073 <alloc_sockfd>
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021d3:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021da:	74 26                	je     802202 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021dc:	6a 07                	push   $0x7
  8021de:	68 00 70 80 00       	push   $0x807000
  8021e3:	53                   	push   %ebx
  8021e4:	ff 35 04 50 80 00    	pushl  0x805004
  8021ea:	e8 45 08 00 00       	call   802a34 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021ef:	83 c4 0c             	add    $0xc,%esp
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	e8 ce 07 00 00       	call   8029cb <ipc_recv>
}
  8021fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802200:	c9                   	leave  
  802201:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802202:	83 ec 0c             	sub    $0xc,%esp
  802205:	6a 02                	push   $0x2
  802207:	e8 80 08 00 00       	call   802a8c <ipc_find_env>
  80220c:	a3 04 50 80 00       	mov    %eax,0x805004
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	eb c6                	jmp    8021dc <nsipc+0x12>

00802216 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	56                   	push   %esi
  80221a:	53                   	push   %ebx
  80221b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802226:	8b 06                	mov    (%esi),%eax
  802228:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80222d:	b8 01 00 00 00       	mov    $0x1,%eax
  802232:	e8 93 ff ff ff       	call   8021ca <nsipc>
  802237:	89 c3                	mov    %eax,%ebx
  802239:	85 c0                	test   %eax,%eax
  80223b:	79 09                	jns    802246 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80223d:	89 d8                	mov    %ebx,%eax
  80223f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802242:	5b                   	pop    %ebx
  802243:	5e                   	pop    %esi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	ff 35 10 70 80 00    	pushl  0x807010
  80224f:	68 00 70 80 00       	push   $0x807000
  802254:	ff 75 0c             	pushl  0xc(%ebp)
  802257:	e8 15 eb ff ff       	call   800d71 <memmove>
		*addrlen = ret->ret_addrlen;
  80225c:	a1 10 70 80 00       	mov    0x807010,%eax
  802261:	89 06                	mov    %eax,(%esi)
  802263:	83 c4 10             	add    $0x10,%esp
	return r;
  802266:	eb d5                	jmp    80223d <nsipc_accept+0x27>

00802268 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	53                   	push   %ebx
  80226c:	83 ec 08             	sub    $0x8,%esp
  80226f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80227a:	53                   	push   %ebx
  80227b:	ff 75 0c             	pushl  0xc(%ebp)
  80227e:	68 04 70 80 00       	push   $0x807004
  802283:	e8 e9 ea ff ff       	call   800d71 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802288:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80228e:	b8 02 00 00 00       	mov    $0x2,%eax
  802293:	e8 32 ff ff ff       	call   8021ca <nsipc>
}
  802298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8022b8:	e8 0d ff ff ff       	call   8021ca <nsipc>
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <nsipc_close>:

int
nsipc_close(int s)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022cd:	b8 04 00 00 00       	mov    $0x4,%eax
  8022d2:	e8 f3 fe ff ff       	call   8021ca <nsipc>
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	53                   	push   %ebx
  8022dd:	83 ec 08             	sub    $0x8,%esp
  8022e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022eb:	53                   	push   %ebx
  8022ec:	ff 75 0c             	pushl  0xc(%ebp)
  8022ef:	68 04 70 80 00       	push   $0x807004
  8022f4:	e8 78 ea ff ff       	call   800d71 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022f9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022ff:	b8 05 00 00 00       	mov    $0x5,%eax
  802304:	e8 c1 fe ff ff       	call   8021ca <nsipc>
}
  802309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80231c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802324:	b8 06 00 00 00       	mov    $0x6,%eax
  802329:	e8 9c fe ff ff       	call   8021ca <nsipc>
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	56                   	push   %esi
  802334:	53                   	push   %ebx
  802335:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802340:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802346:	8b 45 14             	mov    0x14(%ebp),%eax
  802349:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80234e:	b8 07 00 00 00       	mov    $0x7,%eax
  802353:	e8 72 fe ff ff       	call   8021ca <nsipc>
  802358:	89 c3                	mov    %eax,%ebx
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 1f                	js     80237d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80235e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802363:	7f 21                	jg     802386 <nsipc_recv+0x56>
  802365:	39 c6                	cmp    %eax,%esi
  802367:	7c 1d                	jl     802386 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802369:	83 ec 04             	sub    $0x4,%esp
  80236c:	50                   	push   %eax
  80236d:	68 00 70 80 00       	push   $0x807000
  802372:	ff 75 0c             	pushl  0xc(%ebp)
  802375:	e8 f7 e9 ff ff       	call   800d71 <memmove>
  80237a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80237d:	89 d8                	mov    %ebx,%eax
  80237f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802382:	5b                   	pop    %ebx
  802383:	5e                   	pop    %esi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802386:	68 6f 34 80 00       	push   $0x80346f
  80238b:	68 37 34 80 00       	push   $0x803437
  802390:	6a 62                	push   $0x62
  802392:	68 84 34 80 00       	push   $0x803484
  802397:	e8 f2 df ff ff       	call   80038e <_panic>

0080239c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	53                   	push   %ebx
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023ae:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023b4:	7f 2e                	jg     8023e4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	53                   	push   %ebx
  8023ba:	ff 75 0c             	pushl  0xc(%ebp)
  8023bd:	68 0c 70 80 00       	push   $0x80700c
  8023c2:	e8 aa e9 ff ff       	call   800d71 <memmove>
	nsipcbuf.send.req_size = size;
  8023c7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8023da:	e8 eb fd ff ff       	call   8021ca <nsipc>
}
  8023df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    
	assert(size < 1600);
  8023e4:	68 90 34 80 00       	push   $0x803490
  8023e9:	68 37 34 80 00       	push   $0x803437
  8023ee:	6a 6d                	push   $0x6d
  8023f0:	68 84 34 80 00       	push   $0x803484
  8023f5:	e8 94 df ff ff       	call   80038e <_panic>

008023fa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802410:	8b 45 10             	mov    0x10(%ebp),%eax
  802413:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802418:	b8 09 00 00 00       	mov    $0x9,%eax
  80241d:	e8 a8 fd ff ff       	call   8021ca <nsipc>
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	56                   	push   %esi
  802428:	53                   	push   %ebx
  802429:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	ff 75 08             	pushl  0x8(%ebp)
  802432:	e8 6a f3 ff ff       	call   8017a1 <fd2data>
  802437:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802439:	83 c4 08             	add    $0x8,%esp
  80243c:	68 9c 34 80 00       	push   $0x80349c
  802441:	53                   	push   %ebx
  802442:	e8 9c e7 ff ff       	call   800be3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802447:	8b 46 04             	mov    0x4(%esi),%eax
  80244a:	2b 06                	sub    (%esi),%eax
  80244c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802452:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802459:	00 00 00 
	stat->st_dev = &devpipe;
  80245c:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  802463:	40 80 00 
	return 0;
}
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
  80246b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80246e:	5b                   	pop    %ebx
  80246f:	5e                   	pop    %esi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    

00802472 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	53                   	push   %ebx
  802476:	83 ec 0c             	sub    $0xc,%esp
  802479:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80247c:	53                   	push   %ebx
  80247d:	6a 00                	push   $0x0
  80247f:	e8 d6 eb ff ff       	call   80105a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802484:	89 1c 24             	mov    %ebx,(%esp)
  802487:	e8 15 f3 ff ff       	call   8017a1 <fd2data>
  80248c:	83 c4 08             	add    $0x8,%esp
  80248f:	50                   	push   %eax
  802490:	6a 00                	push   $0x0
  802492:	e8 c3 eb ff ff       	call   80105a <sys_page_unmap>
}
  802497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <_pipeisclosed>:
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	57                   	push   %edi
  8024a0:	56                   	push   %esi
  8024a1:	53                   	push   %ebx
  8024a2:	83 ec 1c             	sub    $0x1c,%esp
  8024a5:	89 c7                	mov    %eax,%edi
  8024a7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8024ae:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024b1:	83 ec 0c             	sub    $0xc,%esp
  8024b4:	57                   	push   %edi
  8024b5:	e8 0d 06 00 00       	call   802ac7 <pageref>
  8024ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024bd:	89 34 24             	mov    %esi,(%esp)
  8024c0:	e8 02 06 00 00       	call   802ac7 <pageref>
		nn = thisenv->env_runs;
  8024c5:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024cb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024ce:	83 c4 10             	add    $0x10,%esp
  8024d1:	39 cb                	cmp    %ecx,%ebx
  8024d3:	74 1b                	je     8024f0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024d5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024d8:	75 cf                	jne    8024a9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024da:	8b 42 58             	mov    0x58(%edx),%eax
  8024dd:	6a 01                	push   $0x1
  8024df:	50                   	push   %eax
  8024e0:	53                   	push   %ebx
  8024e1:	68 a3 34 80 00       	push   $0x8034a3
  8024e6:	e8 99 df ff ff       	call   800484 <cprintf>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	eb b9                	jmp    8024a9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024f3:	0f 94 c0             	sete   %al
  8024f6:	0f b6 c0             	movzbl %al,%eax
}
  8024f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024fc:	5b                   	pop    %ebx
  8024fd:	5e                   	pop    %esi
  8024fe:	5f                   	pop    %edi
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    

00802501 <devpipe_write>:
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	57                   	push   %edi
  802505:	56                   	push   %esi
  802506:	53                   	push   %ebx
  802507:	83 ec 28             	sub    $0x28,%esp
  80250a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80250d:	56                   	push   %esi
  80250e:	e8 8e f2 ff ff       	call   8017a1 <fd2data>
  802513:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802515:	83 c4 10             	add    $0x10,%esp
  802518:	bf 00 00 00 00       	mov    $0x0,%edi
  80251d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802520:	74 4f                	je     802571 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802522:	8b 43 04             	mov    0x4(%ebx),%eax
  802525:	8b 0b                	mov    (%ebx),%ecx
  802527:	8d 51 20             	lea    0x20(%ecx),%edx
  80252a:	39 d0                	cmp    %edx,%eax
  80252c:	72 14                	jb     802542 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80252e:	89 da                	mov    %ebx,%edx
  802530:	89 f0                	mov    %esi,%eax
  802532:	e8 65 ff ff ff       	call   80249c <_pipeisclosed>
  802537:	85 c0                	test   %eax,%eax
  802539:	75 3b                	jne    802576 <devpipe_write+0x75>
			sys_yield();
  80253b:	e8 76 ea ff ff       	call   800fb6 <sys_yield>
  802540:	eb e0                	jmp    802522 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802542:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802545:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802549:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	c1 fa 1f             	sar    $0x1f,%edx
  802551:	89 d1                	mov    %edx,%ecx
  802553:	c1 e9 1b             	shr    $0x1b,%ecx
  802556:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802559:	83 e2 1f             	and    $0x1f,%edx
  80255c:	29 ca                	sub    %ecx,%edx
  80255e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802562:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802566:	83 c0 01             	add    $0x1,%eax
  802569:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80256c:	83 c7 01             	add    $0x1,%edi
  80256f:	eb ac                	jmp    80251d <devpipe_write+0x1c>
	return i;
  802571:	8b 45 10             	mov    0x10(%ebp),%eax
  802574:	eb 05                	jmp    80257b <devpipe_write+0x7a>
				return 0;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5f                   	pop    %edi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    

00802583 <devpipe_read>:
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
  802586:	57                   	push   %edi
  802587:	56                   	push   %esi
  802588:	53                   	push   %ebx
  802589:	83 ec 18             	sub    $0x18,%esp
  80258c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80258f:	57                   	push   %edi
  802590:	e8 0c f2 ff ff       	call   8017a1 <fd2data>
  802595:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802597:	83 c4 10             	add    $0x10,%esp
  80259a:	be 00 00 00 00       	mov    $0x0,%esi
  80259f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025a2:	75 14                	jne    8025b8 <devpipe_read+0x35>
	return i;
  8025a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a7:	eb 02                	jmp    8025ab <devpipe_read+0x28>
				return i;
  8025a9:	89 f0                	mov    %esi,%eax
}
  8025ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ae:	5b                   	pop    %ebx
  8025af:	5e                   	pop    %esi
  8025b0:	5f                   	pop    %edi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    
			sys_yield();
  8025b3:	e8 fe e9 ff ff       	call   800fb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025b8:	8b 03                	mov    (%ebx),%eax
  8025ba:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025bd:	75 18                	jne    8025d7 <devpipe_read+0x54>
			if (i > 0)
  8025bf:	85 f6                	test   %esi,%esi
  8025c1:	75 e6                	jne    8025a9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025c3:	89 da                	mov    %ebx,%edx
  8025c5:	89 f8                	mov    %edi,%eax
  8025c7:	e8 d0 fe ff ff       	call   80249c <_pipeisclosed>
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	74 e3                	je     8025b3 <devpipe_read+0x30>
				return 0;
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	eb d4                	jmp    8025ab <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025d7:	99                   	cltd   
  8025d8:	c1 ea 1b             	shr    $0x1b,%edx
  8025db:	01 d0                	add    %edx,%eax
  8025dd:	83 e0 1f             	and    $0x1f,%eax
  8025e0:	29 d0                	sub    %edx,%eax
  8025e2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ea:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025ed:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025f0:	83 c6 01             	add    $0x1,%esi
  8025f3:	eb aa                	jmp    80259f <devpipe_read+0x1c>

008025f5 <pipe>:
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	56                   	push   %esi
  8025f9:	53                   	push   %ebx
  8025fa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802600:	50                   	push   %eax
  802601:	e8 b2 f1 ff ff       	call   8017b8 <fd_alloc>
  802606:	89 c3                	mov    %eax,%ebx
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	85 c0                	test   %eax,%eax
  80260d:	0f 88 23 01 00 00    	js     802736 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802613:	83 ec 04             	sub    $0x4,%esp
  802616:	68 07 04 00 00       	push   $0x407
  80261b:	ff 75 f4             	pushl  -0xc(%ebp)
  80261e:	6a 00                	push   $0x0
  802620:	e8 b0 e9 ff ff       	call   800fd5 <sys_page_alloc>
  802625:	89 c3                	mov    %eax,%ebx
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	85 c0                	test   %eax,%eax
  80262c:	0f 88 04 01 00 00    	js     802736 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802638:	50                   	push   %eax
  802639:	e8 7a f1 ff ff       	call   8017b8 <fd_alloc>
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	83 c4 10             	add    $0x10,%esp
  802643:	85 c0                	test   %eax,%eax
  802645:	0f 88 db 00 00 00    	js     802726 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264b:	83 ec 04             	sub    $0x4,%esp
  80264e:	68 07 04 00 00       	push   $0x407
  802653:	ff 75 f0             	pushl  -0x10(%ebp)
  802656:	6a 00                	push   $0x0
  802658:	e8 78 e9 ff ff       	call   800fd5 <sys_page_alloc>
  80265d:	89 c3                	mov    %eax,%ebx
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	85 c0                	test   %eax,%eax
  802664:	0f 88 bc 00 00 00    	js     802726 <pipe+0x131>
	va = fd2data(fd0);
  80266a:	83 ec 0c             	sub    $0xc,%esp
  80266d:	ff 75 f4             	pushl  -0xc(%ebp)
  802670:	e8 2c f1 ff ff       	call   8017a1 <fd2data>
  802675:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802677:	83 c4 0c             	add    $0xc,%esp
  80267a:	68 07 04 00 00       	push   $0x407
  80267f:	50                   	push   %eax
  802680:	6a 00                	push   $0x0
  802682:	e8 4e e9 ff ff       	call   800fd5 <sys_page_alloc>
  802687:	89 c3                	mov    %eax,%ebx
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	85 c0                	test   %eax,%eax
  80268e:	0f 88 82 00 00 00    	js     802716 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	ff 75 f0             	pushl  -0x10(%ebp)
  80269a:	e8 02 f1 ff ff       	call   8017a1 <fd2data>
  80269f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026a6:	50                   	push   %eax
  8026a7:	6a 00                	push   $0x0
  8026a9:	56                   	push   %esi
  8026aa:	6a 00                	push   $0x0
  8026ac:	e8 67 e9 ff ff       	call   801018 <sys_page_map>
  8026b1:	89 c3                	mov    %eax,%ebx
  8026b3:	83 c4 20             	add    $0x20,%esp
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	78 4e                	js     802708 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e3:	e8 a9 f0 ff ff       	call   801791 <fd2num>
  8026e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026eb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026ed:	83 c4 04             	add    $0x4,%esp
  8026f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026f3:	e8 99 f0 ff ff       	call   801791 <fd2num>
  8026f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026fb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026fe:	83 c4 10             	add    $0x10,%esp
  802701:	bb 00 00 00 00       	mov    $0x0,%ebx
  802706:	eb 2e                	jmp    802736 <pipe+0x141>
	sys_page_unmap(0, va);
  802708:	83 ec 08             	sub    $0x8,%esp
  80270b:	56                   	push   %esi
  80270c:	6a 00                	push   $0x0
  80270e:	e8 47 e9 ff ff       	call   80105a <sys_page_unmap>
  802713:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802716:	83 ec 08             	sub    $0x8,%esp
  802719:	ff 75 f0             	pushl  -0x10(%ebp)
  80271c:	6a 00                	push   $0x0
  80271e:	e8 37 e9 ff ff       	call   80105a <sys_page_unmap>
  802723:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802726:	83 ec 08             	sub    $0x8,%esp
  802729:	ff 75 f4             	pushl  -0xc(%ebp)
  80272c:	6a 00                	push   $0x0
  80272e:	e8 27 e9 ff ff       	call   80105a <sys_page_unmap>
  802733:	83 c4 10             	add    $0x10,%esp
}
  802736:	89 d8                	mov    %ebx,%eax
  802738:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5d                   	pop    %ebp
  80273e:	c3                   	ret    

0080273f <pipeisclosed>:
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802748:	50                   	push   %eax
  802749:	ff 75 08             	pushl  0x8(%ebp)
  80274c:	e8 b9 f0 ff ff       	call   80180a <fd_lookup>
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	85 c0                	test   %eax,%eax
  802756:	78 18                	js     802770 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802758:	83 ec 0c             	sub    $0xc,%esp
  80275b:	ff 75 f4             	pushl  -0xc(%ebp)
  80275e:	e8 3e f0 ff ff       	call   8017a1 <fd2data>
	return _pipeisclosed(fd, p);
  802763:	89 c2                	mov    %eax,%edx
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	e8 2f fd ff ff       	call   80249c <_pipeisclosed>
  80276d:	83 c4 10             	add    $0x10,%esp
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
  802775:	56                   	push   %esi
  802776:	53                   	push   %ebx
  802777:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80277a:	85 f6                	test   %esi,%esi
  80277c:	74 13                	je     802791 <wait+0x1f>
	e = &envs[ENVX(envid)];
  80277e:	89 f3                	mov    %esi,%ebx
  802780:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802786:	c1 e3 07             	shl    $0x7,%ebx
  802789:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80278f:	eb 1b                	jmp    8027ac <wait+0x3a>
	assert(envid != 0);
  802791:	68 bb 34 80 00       	push   $0x8034bb
  802796:	68 37 34 80 00       	push   $0x803437
  80279b:	6a 09                	push   $0x9
  80279d:	68 c6 34 80 00       	push   $0x8034c6
  8027a2:	e8 e7 db ff ff       	call   80038e <_panic>
		sys_yield();
  8027a7:	e8 0a e8 ff ff       	call   800fb6 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027ac:	8b 43 48             	mov    0x48(%ebx),%eax
  8027af:	39 f0                	cmp    %esi,%eax
  8027b1:	75 07                	jne    8027ba <wait+0x48>
  8027b3:	8b 43 54             	mov    0x54(%ebx),%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	75 ed                	jne    8027a7 <wait+0x35>
}
  8027ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027bd:	5b                   	pop    %ebx
  8027be:	5e                   	pop    %esi
  8027bf:	5d                   	pop    %ebp
  8027c0:	c3                   	ret    

008027c1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c6:	c3                   	ret    

008027c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027cd:	68 d1 34 80 00       	push   $0x8034d1
  8027d2:	ff 75 0c             	pushl  0xc(%ebp)
  8027d5:	e8 09 e4 ff ff       	call   800be3 <strcpy>
	return 0;
}
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	c9                   	leave  
  8027e0:	c3                   	ret    

008027e1 <devcons_write>:
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	57                   	push   %edi
  8027e5:	56                   	push   %esi
  8027e6:	53                   	push   %ebx
  8027e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027fb:	73 31                	jae    80282e <devcons_write+0x4d>
		m = n - tot;
  8027fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802800:	29 f3                	sub    %esi,%ebx
  802802:	83 fb 7f             	cmp    $0x7f,%ebx
  802805:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80280a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80280d:	83 ec 04             	sub    $0x4,%esp
  802810:	53                   	push   %ebx
  802811:	89 f0                	mov    %esi,%eax
  802813:	03 45 0c             	add    0xc(%ebp),%eax
  802816:	50                   	push   %eax
  802817:	57                   	push   %edi
  802818:	e8 54 e5 ff ff       	call   800d71 <memmove>
		sys_cputs(buf, m);
  80281d:	83 c4 08             	add    $0x8,%esp
  802820:	53                   	push   %ebx
  802821:	57                   	push   %edi
  802822:	e8 f2 e6 ff ff       	call   800f19 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802827:	01 de                	add    %ebx,%esi
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	eb ca                	jmp    8027f8 <devcons_write+0x17>
}
  80282e:	89 f0                	mov    %esi,%eax
  802830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802833:	5b                   	pop    %ebx
  802834:	5e                   	pop    %esi
  802835:	5f                   	pop    %edi
  802836:	5d                   	pop    %ebp
  802837:	c3                   	ret    

00802838 <devcons_read>:
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 08             	sub    $0x8,%esp
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802843:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802847:	74 21                	je     80286a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802849:	e8 e9 e6 ff ff       	call   800f37 <sys_cgetc>
  80284e:	85 c0                	test   %eax,%eax
  802850:	75 07                	jne    802859 <devcons_read+0x21>
		sys_yield();
  802852:	e8 5f e7 ff ff       	call   800fb6 <sys_yield>
  802857:	eb f0                	jmp    802849 <devcons_read+0x11>
	if (c < 0)
  802859:	78 0f                	js     80286a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80285b:	83 f8 04             	cmp    $0x4,%eax
  80285e:	74 0c                	je     80286c <devcons_read+0x34>
	*(char*)vbuf = c;
  802860:	8b 55 0c             	mov    0xc(%ebp),%edx
  802863:	88 02                	mov    %al,(%edx)
	return 1;
  802865:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    
		return 0;
  80286c:	b8 00 00 00 00       	mov    $0x0,%eax
  802871:	eb f7                	jmp    80286a <devcons_read+0x32>

00802873 <cputchar>:
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80287f:	6a 01                	push   $0x1
  802881:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802884:	50                   	push   %eax
  802885:	e8 8f e6 ff ff       	call   800f19 <sys_cputs>
}
  80288a:	83 c4 10             	add    $0x10,%esp
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <getchar>:
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
  802892:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802895:	6a 01                	push   $0x1
  802897:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80289a:	50                   	push   %eax
  80289b:	6a 00                	push   $0x0
  80289d:	e8 d8 f1 ff ff       	call   801a7a <read>
	if (r < 0)
  8028a2:	83 c4 10             	add    $0x10,%esp
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	78 06                	js     8028af <getchar+0x20>
	if (r < 1)
  8028a9:	74 06                	je     8028b1 <getchar+0x22>
	return c;
  8028ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    
		return -E_EOF;
  8028b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028b6:	eb f7                	jmp    8028af <getchar+0x20>

008028b8 <iscons>:
{
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
  8028bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c1:	50                   	push   %eax
  8028c2:	ff 75 08             	pushl  0x8(%ebp)
  8028c5:	e8 40 ef ff ff       	call   80180a <fd_lookup>
  8028ca:	83 c4 10             	add    $0x10,%esp
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	78 11                	js     8028e2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8028da:	39 10                	cmp    %edx,(%eax)
  8028dc:	0f 94 c0             	sete   %al
  8028df:	0f b6 c0             	movzbl %al,%eax
}
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    

008028e4 <opencons>:
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ed:	50                   	push   %eax
  8028ee:	e8 c5 ee ff ff       	call   8017b8 <fd_alloc>
  8028f3:	83 c4 10             	add    $0x10,%esp
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	78 3a                	js     802934 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	68 07 04 00 00       	push   $0x407
  802902:	ff 75 f4             	pushl  -0xc(%ebp)
  802905:	6a 00                	push   $0x0
  802907:	e8 c9 e6 ff ff       	call   800fd5 <sys_page_alloc>
  80290c:	83 c4 10             	add    $0x10,%esp
  80290f:	85 c0                	test   %eax,%eax
  802911:	78 21                	js     802934 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80291c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	50                   	push   %eax
  80292c:	e8 60 ee ff ff       	call   801791 <fd2num>
  802931:	83 c4 10             	add    $0x10,%esp
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80293c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802943:	74 0a                	je     80294f <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80294d:	c9                   	leave  
  80294e:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80294f:	83 ec 04             	sub    $0x4,%esp
  802952:	6a 07                	push   $0x7
  802954:	68 00 f0 bf ee       	push   $0xeebff000
  802959:	6a 00                	push   $0x0
  80295b:	e8 75 e6 ff ff       	call   800fd5 <sys_page_alloc>
		if(r < 0)
  802960:	83 c4 10             	add    $0x10,%esp
  802963:	85 c0                	test   %eax,%eax
  802965:	78 2a                	js     802991 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802967:	83 ec 08             	sub    $0x8,%esp
  80296a:	68 a5 29 80 00       	push   $0x8029a5
  80296f:	6a 00                	push   $0x0
  802971:	e8 aa e7 ff ff       	call   801120 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802976:	83 c4 10             	add    $0x10,%esp
  802979:	85 c0                	test   %eax,%eax
  80297b:	79 c8                	jns    802945 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80297d:	83 ec 04             	sub    $0x4,%esp
  802980:	68 10 35 80 00       	push   $0x803510
  802985:	6a 25                	push   $0x25
  802987:	68 4c 35 80 00       	push   $0x80354c
  80298c:	e8 fd d9 ff ff       	call   80038e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 e0 34 80 00       	push   $0x8034e0
  802999:	6a 22                	push   $0x22
  80299b:	68 4c 35 80 00       	push   $0x80354c
  8029a0:	e8 e9 d9 ff ff       	call   80038e <_panic>

008029a5 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029a5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029a6:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029ab:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029ad:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029b0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029b4:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029b8:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029bb:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029bd:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029c1:	83 c4 08             	add    $0x8,%esp
	popal
  8029c4:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029c5:	83 c4 04             	add    $0x4,%esp
	popfl
  8029c8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029c9:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029ca:	c3                   	ret    

008029cb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	56                   	push   %esi
  8029cf:	53                   	push   %ebx
  8029d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8029d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8029d9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8029db:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8029e0:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8029e3:	83 ec 0c             	sub    $0xc,%esp
  8029e6:	50                   	push   %eax
  8029e7:	e8 99 e7 ff ff       	call   801185 <sys_ipc_recv>
	if(ret < 0){
  8029ec:	83 c4 10             	add    $0x10,%esp
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	78 2b                	js     802a1e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8029f3:	85 f6                	test   %esi,%esi
  8029f5:	74 0a                	je     802a01 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8029f7:	a1 08 50 80 00       	mov    0x805008,%eax
  8029fc:	8b 40 74             	mov    0x74(%eax),%eax
  8029ff:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802a01:	85 db                	test   %ebx,%ebx
  802a03:	74 0a                	je     802a0f <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802a05:	a1 08 50 80 00       	mov    0x805008,%eax
  802a0a:	8b 40 78             	mov    0x78(%eax),%eax
  802a0d:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802a0f:	a1 08 50 80 00       	mov    0x805008,%eax
  802a14:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a1a:	5b                   	pop    %ebx
  802a1b:	5e                   	pop    %esi
  802a1c:	5d                   	pop    %ebp
  802a1d:	c3                   	ret    
		if(from_env_store)
  802a1e:	85 f6                	test   %esi,%esi
  802a20:	74 06                	je     802a28 <ipc_recv+0x5d>
			*from_env_store = 0;
  802a22:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802a28:	85 db                	test   %ebx,%ebx
  802a2a:	74 eb                	je     802a17 <ipc_recv+0x4c>
			*perm_store = 0;
  802a2c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a32:	eb e3                	jmp    802a17 <ipc_recv+0x4c>

00802a34 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802a34:	55                   	push   %ebp
  802a35:	89 e5                	mov    %esp,%ebp
  802a37:	57                   	push   %edi
  802a38:	56                   	push   %esi
  802a39:	53                   	push   %ebx
  802a3a:	83 ec 0c             	sub    $0xc,%esp
  802a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a40:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802a46:	85 db                	test   %ebx,%ebx
  802a48:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a4d:	0f 44 d8             	cmove  %eax,%ebx
  802a50:	eb 05                	jmp    802a57 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802a52:	e8 5f e5 ff ff       	call   800fb6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802a57:	ff 75 14             	pushl  0x14(%ebp)
  802a5a:	53                   	push   %ebx
  802a5b:	56                   	push   %esi
  802a5c:	57                   	push   %edi
  802a5d:	e8 00 e7 ff ff       	call   801162 <sys_ipc_try_send>
  802a62:	83 c4 10             	add    $0x10,%esp
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 1b                	je     802a84 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802a69:	79 e7                	jns    802a52 <ipc_send+0x1e>
  802a6b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a6e:	74 e2                	je     802a52 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802a70:	83 ec 04             	sub    $0x4,%esp
  802a73:	68 5a 35 80 00       	push   $0x80355a
  802a78:	6a 48                	push   $0x48
  802a7a:	68 6f 35 80 00       	push   $0x80356f
  802a7f:	e8 0a d9 ff ff       	call   80038e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802a84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a87:	5b                   	pop    %ebx
  802a88:	5e                   	pop    %esi
  802a89:	5f                   	pop    %edi
  802a8a:	5d                   	pop    %ebp
  802a8b:	c3                   	ret    

00802a8c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a92:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a97:	89 c2                	mov    %eax,%edx
  802a99:	c1 e2 07             	shl    $0x7,%edx
  802a9c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802aa2:	8b 52 50             	mov    0x50(%edx),%edx
  802aa5:	39 ca                	cmp    %ecx,%edx
  802aa7:	74 11                	je     802aba <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802aa9:	83 c0 01             	add    $0x1,%eax
  802aac:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ab1:	75 e4                	jne    802a97 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab8:	eb 0b                	jmp    802ac5 <ipc_find_env+0x39>
			return envs[i].env_id;
  802aba:	c1 e0 07             	shl    $0x7,%eax
  802abd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ac2:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ac5:	5d                   	pop    %ebp
  802ac6:	c3                   	ret    

00802ac7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ac7:	55                   	push   %ebp
  802ac8:	89 e5                	mov    %esp,%ebp
  802aca:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802acd:	89 d0                	mov    %edx,%eax
  802acf:	c1 e8 16             	shr    $0x16,%eax
  802ad2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802ade:	f6 c1 01             	test   $0x1,%cl
  802ae1:	74 1d                	je     802b00 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802ae3:	c1 ea 0c             	shr    $0xc,%edx
  802ae6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802aed:	f6 c2 01             	test   $0x1,%dl
  802af0:	74 0e                	je     802b00 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802af2:	c1 ea 0c             	shr    $0xc,%edx
  802af5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802afc:	ef 
  802afd:	0f b7 c0             	movzwl %ax,%eax
}
  802b00:	5d                   	pop    %ebp
  802b01:	c3                   	ret    
  802b02:	66 90                	xchg   %ax,%ax
  802b04:	66 90                	xchg   %ax,%ax
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	66 90                	xchg   %ax,%ax
  802b0a:	66 90                	xchg   %ax,%ax
  802b0c:	66 90                	xchg   %ax,%ax
  802b0e:	66 90                	xchg   %ax,%ax

00802b10 <__udivdi3>:
  802b10:	55                   	push   %ebp
  802b11:	57                   	push   %edi
  802b12:	56                   	push   %esi
  802b13:	53                   	push   %ebx
  802b14:	83 ec 1c             	sub    $0x1c,%esp
  802b17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802b1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802b1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802b27:	85 d2                	test   %edx,%edx
  802b29:	75 4d                	jne    802b78 <__udivdi3+0x68>
  802b2b:	39 f3                	cmp    %esi,%ebx
  802b2d:	76 19                	jbe    802b48 <__udivdi3+0x38>
  802b2f:	31 ff                	xor    %edi,%edi
  802b31:	89 e8                	mov    %ebp,%eax
  802b33:	89 f2                	mov    %esi,%edx
  802b35:	f7 f3                	div    %ebx
  802b37:	89 fa                	mov    %edi,%edx
  802b39:	83 c4 1c             	add    $0x1c,%esp
  802b3c:	5b                   	pop    %ebx
  802b3d:	5e                   	pop    %esi
  802b3e:	5f                   	pop    %edi
  802b3f:	5d                   	pop    %ebp
  802b40:	c3                   	ret    
  802b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b48:	89 d9                	mov    %ebx,%ecx
  802b4a:	85 db                	test   %ebx,%ebx
  802b4c:	75 0b                	jne    802b59 <__udivdi3+0x49>
  802b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b53:	31 d2                	xor    %edx,%edx
  802b55:	f7 f3                	div    %ebx
  802b57:	89 c1                	mov    %eax,%ecx
  802b59:	31 d2                	xor    %edx,%edx
  802b5b:	89 f0                	mov    %esi,%eax
  802b5d:	f7 f1                	div    %ecx
  802b5f:	89 c6                	mov    %eax,%esi
  802b61:	89 e8                	mov    %ebp,%eax
  802b63:	89 f7                	mov    %esi,%edi
  802b65:	f7 f1                	div    %ecx
  802b67:	89 fa                	mov    %edi,%edx
  802b69:	83 c4 1c             	add    $0x1c,%esp
  802b6c:	5b                   	pop    %ebx
  802b6d:	5e                   	pop    %esi
  802b6e:	5f                   	pop    %edi
  802b6f:	5d                   	pop    %ebp
  802b70:	c3                   	ret    
  802b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b78:	39 f2                	cmp    %esi,%edx
  802b7a:	77 1c                	ja     802b98 <__udivdi3+0x88>
  802b7c:	0f bd fa             	bsr    %edx,%edi
  802b7f:	83 f7 1f             	xor    $0x1f,%edi
  802b82:	75 2c                	jne    802bb0 <__udivdi3+0xa0>
  802b84:	39 f2                	cmp    %esi,%edx
  802b86:	72 06                	jb     802b8e <__udivdi3+0x7e>
  802b88:	31 c0                	xor    %eax,%eax
  802b8a:	39 eb                	cmp    %ebp,%ebx
  802b8c:	77 a9                	ja     802b37 <__udivdi3+0x27>
  802b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b93:	eb a2                	jmp    802b37 <__udivdi3+0x27>
  802b95:	8d 76 00             	lea    0x0(%esi),%esi
  802b98:	31 ff                	xor    %edi,%edi
  802b9a:	31 c0                	xor    %eax,%eax
  802b9c:	89 fa                	mov    %edi,%edx
  802b9e:	83 c4 1c             	add    $0x1c,%esp
  802ba1:	5b                   	pop    %ebx
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	89 f9                	mov    %edi,%ecx
  802bb2:	b8 20 00 00 00       	mov    $0x20,%eax
  802bb7:	29 f8                	sub    %edi,%eax
  802bb9:	d3 e2                	shl    %cl,%edx
  802bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bbf:	89 c1                	mov    %eax,%ecx
  802bc1:	89 da                	mov    %ebx,%edx
  802bc3:	d3 ea                	shr    %cl,%edx
  802bc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bc9:	09 d1                	or     %edx,%ecx
  802bcb:	89 f2                	mov    %esi,%edx
  802bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bd1:	89 f9                	mov    %edi,%ecx
  802bd3:	d3 e3                	shl    %cl,%ebx
  802bd5:	89 c1                	mov    %eax,%ecx
  802bd7:	d3 ea                	shr    %cl,%edx
  802bd9:	89 f9                	mov    %edi,%ecx
  802bdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802bdf:	89 eb                	mov    %ebp,%ebx
  802be1:	d3 e6                	shl    %cl,%esi
  802be3:	89 c1                	mov    %eax,%ecx
  802be5:	d3 eb                	shr    %cl,%ebx
  802be7:	09 de                	or     %ebx,%esi
  802be9:	89 f0                	mov    %esi,%eax
  802beb:	f7 74 24 08          	divl   0x8(%esp)
  802bef:	89 d6                	mov    %edx,%esi
  802bf1:	89 c3                	mov    %eax,%ebx
  802bf3:	f7 64 24 0c          	mull   0xc(%esp)
  802bf7:	39 d6                	cmp    %edx,%esi
  802bf9:	72 15                	jb     802c10 <__udivdi3+0x100>
  802bfb:	89 f9                	mov    %edi,%ecx
  802bfd:	d3 e5                	shl    %cl,%ebp
  802bff:	39 c5                	cmp    %eax,%ebp
  802c01:	73 04                	jae    802c07 <__udivdi3+0xf7>
  802c03:	39 d6                	cmp    %edx,%esi
  802c05:	74 09                	je     802c10 <__udivdi3+0x100>
  802c07:	89 d8                	mov    %ebx,%eax
  802c09:	31 ff                	xor    %edi,%edi
  802c0b:	e9 27 ff ff ff       	jmp    802b37 <__udivdi3+0x27>
  802c10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c13:	31 ff                	xor    %edi,%edi
  802c15:	e9 1d ff ff ff       	jmp    802b37 <__udivdi3+0x27>
  802c1a:	66 90                	xchg   %ax,%ax
  802c1c:	66 90                	xchg   %ax,%ax
  802c1e:	66 90                	xchg   %ax,%ax

00802c20 <__umoddi3>:
  802c20:	55                   	push   %ebp
  802c21:	57                   	push   %edi
  802c22:	56                   	push   %esi
  802c23:	53                   	push   %ebx
  802c24:	83 ec 1c             	sub    $0x1c,%esp
  802c27:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802c2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c2f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802c33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c37:	89 da                	mov    %ebx,%edx
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	75 43                	jne    802c80 <__umoddi3+0x60>
  802c3d:	39 df                	cmp    %ebx,%edi
  802c3f:	76 17                	jbe    802c58 <__umoddi3+0x38>
  802c41:	89 f0                	mov    %esi,%eax
  802c43:	f7 f7                	div    %edi
  802c45:	89 d0                	mov    %edx,%eax
  802c47:	31 d2                	xor    %edx,%edx
  802c49:	83 c4 1c             	add    $0x1c,%esp
  802c4c:	5b                   	pop    %ebx
  802c4d:	5e                   	pop    %esi
  802c4e:	5f                   	pop    %edi
  802c4f:	5d                   	pop    %ebp
  802c50:	c3                   	ret    
  802c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c58:	89 fd                	mov    %edi,%ebp
  802c5a:	85 ff                	test   %edi,%edi
  802c5c:	75 0b                	jne    802c69 <__umoddi3+0x49>
  802c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802c63:	31 d2                	xor    %edx,%edx
  802c65:	f7 f7                	div    %edi
  802c67:	89 c5                	mov    %eax,%ebp
  802c69:	89 d8                	mov    %ebx,%eax
  802c6b:	31 d2                	xor    %edx,%edx
  802c6d:	f7 f5                	div    %ebp
  802c6f:	89 f0                	mov    %esi,%eax
  802c71:	f7 f5                	div    %ebp
  802c73:	89 d0                	mov    %edx,%eax
  802c75:	eb d0                	jmp    802c47 <__umoddi3+0x27>
  802c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c7e:	66 90                	xchg   %ax,%ax
  802c80:	89 f1                	mov    %esi,%ecx
  802c82:	39 d8                	cmp    %ebx,%eax
  802c84:	76 0a                	jbe    802c90 <__umoddi3+0x70>
  802c86:	89 f0                	mov    %esi,%eax
  802c88:	83 c4 1c             	add    $0x1c,%esp
  802c8b:	5b                   	pop    %ebx
  802c8c:	5e                   	pop    %esi
  802c8d:	5f                   	pop    %edi
  802c8e:	5d                   	pop    %ebp
  802c8f:	c3                   	ret    
  802c90:	0f bd e8             	bsr    %eax,%ebp
  802c93:	83 f5 1f             	xor    $0x1f,%ebp
  802c96:	75 20                	jne    802cb8 <__umoddi3+0x98>
  802c98:	39 d8                	cmp    %ebx,%eax
  802c9a:	0f 82 b0 00 00 00    	jb     802d50 <__umoddi3+0x130>
  802ca0:	39 f7                	cmp    %esi,%edi
  802ca2:	0f 86 a8 00 00 00    	jbe    802d50 <__umoddi3+0x130>
  802ca8:	89 c8                	mov    %ecx,%eax
  802caa:	83 c4 1c             	add    $0x1c,%esp
  802cad:	5b                   	pop    %ebx
  802cae:	5e                   	pop    %esi
  802caf:	5f                   	pop    %edi
  802cb0:	5d                   	pop    %ebp
  802cb1:	c3                   	ret    
  802cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cb8:	89 e9                	mov    %ebp,%ecx
  802cba:	ba 20 00 00 00       	mov    $0x20,%edx
  802cbf:	29 ea                	sub    %ebp,%edx
  802cc1:	d3 e0                	shl    %cl,%eax
  802cc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cc7:	89 d1                	mov    %edx,%ecx
  802cc9:	89 f8                	mov    %edi,%eax
  802ccb:	d3 e8                	shr    %cl,%eax
  802ccd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802cd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cd5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802cd9:	09 c1                	or     %eax,%ecx
  802cdb:	89 d8                	mov    %ebx,%eax
  802cdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ce1:	89 e9                	mov    %ebp,%ecx
  802ce3:	d3 e7                	shl    %cl,%edi
  802ce5:	89 d1                	mov    %edx,%ecx
  802ce7:	d3 e8                	shr    %cl,%eax
  802ce9:	89 e9                	mov    %ebp,%ecx
  802ceb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cef:	d3 e3                	shl    %cl,%ebx
  802cf1:	89 c7                	mov    %eax,%edi
  802cf3:	89 d1                	mov    %edx,%ecx
  802cf5:	89 f0                	mov    %esi,%eax
  802cf7:	d3 e8                	shr    %cl,%eax
  802cf9:	89 e9                	mov    %ebp,%ecx
  802cfb:	89 fa                	mov    %edi,%edx
  802cfd:	d3 e6                	shl    %cl,%esi
  802cff:	09 d8                	or     %ebx,%eax
  802d01:	f7 74 24 08          	divl   0x8(%esp)
  802d05:	89 d1                	mov    %edx,%ecx
  802d07:	89 f3                	mov    %esi,%ebx
  802d09:	f7 64 24 0c          	mull   0xc(%esp)
  802d0d:	89 c6                	mov    %eax,%esi
  802d0f:	89 d7                	mov    %edx,%edi
  802d11:	39 d1                	cmp    %edx,%ecx
  802d13:	72 06                	jb     802d1b <__umoddi3+0xfb>
  802d15:	75 10                	jne    802d27 <__umoddi3+0x107>
  802d17:	39 c3                	cmp    %eax,%ebx
  802d19:	73 0c                	jae    802d27 <__umoddi3+0x107>
  802d1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802d1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802d23:	89 d7                	mov    %edx,%edi
  802d25:	89 c6                	mov    %eax,%esi
  802d27:	89 ca                	mov    %ecx,%edx
  802d29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802d2e:	29 f3                	sub    %esi,%ebx
  802d30:	19 fa                	sbb    %edi,%edx
  802d32:	89 d0                	mov    %edx,%eax
  802d34:	d3 e0                	shl    %cl,%eax
  802d36:	89 e9                	mov    %ebp,%ecx
  802d38:	d3 eb                	shr    %cl,%ebx
  802d3a:	d3 ea                	shr    %cl,%edx
  802d3c:	09 d8                	or     %ebx,%eax
  802d3e:	83 c4 1c             	add    $0x1c,%esp
  802d41:	5b                   	pop    %ebx
  802d42:	5e                   	pop    %esi
  802d43:	5f                   	pop    %edi
  802d44:	5d                   	pop    %ebp
  802d45:	c3                   	ret    
  802d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d4d:	8d 76 00             	lea    0x0(%esi),%esi
  802d50:	89 da                	mov    %ebx,%edx
  802d52:	29 fe                	sub    %edi,%esi
  802d54:	19 c2                	sbb    %eax,%edx
  802d56:	89 f1                	mov    %esi,%ecx
  802d58:	89 c8                	mov    %ecx,%eax
  802d5a:	e9 4b ff ff ff       	jmp    802caa <__umoddi3+0x8a>
