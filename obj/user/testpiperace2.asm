
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 b5 01 00 00       	call   8001e6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 80 2c 80 00       	push   $0x802c80
  800041:	e8 a3 03 00 00       	call   8003e9 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 09 25 00 00       	call   80255a <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 71                	js     8000c9 <umain+0x96>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 07 14 00 00       	call   801464 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 78                	js     8000db <umain+0xa8>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	0f 84 84 00 00 00    	je     8000ed <umain+0xba>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800069:	89 fb                	mov    %edi,%ebx
  80006b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  800071:	c1 e3 07             	shl    $0x7,%ebx
  800074:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80007a:	8b 43 54             	mov    0x54(%ebx),%eax
  80007d:	83 f8 02             	cmp    $0x2,%eax
  800080:	0f 85 e3 00 00 00    	jne    800169 <umain+0x136>
		if (pipeisclosed(p[0]) != 0) {
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	ff 75 e0             	pushl  -0x20(%ebp)
  80008c:	e8 13 26 00 00       	call   8026a4 <pipeisclosed>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	74 e2                	je     80007a <umain+0x47>
			cprintf("\nRACE: pipe appears closed\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 f9 2c 80 00       	push   $0x802cf9
  8000a0:	e8 44 03 00 00       	call   8003e9 <cprintf>
			cprintf("in %s\n", __FUNCTION__);
  8000a5:	83 c4 08             	add    $0x8,%esp
  8000a8:	68 58 2d 80 00       	push   $0x802d58
  8000ad:	68 ba 2d 80 00       	push   $0x802dba
  8000b2:	e8 32 03 00 00       	call   8003e9 <cprintf>
			sys_env_destroy(r);
  8000b7:	89 3c 24             	mov    %edi,(%esp)
  8000ba:	e8 fc 0d 00 00       	call   800ebb <sys_env_destroy>
			exit();
  8000bf:	e8 fb 01 00 00       	call   8002bf <exit>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	eb b1                	jmp    80007a <umain+0x47>
		panic("pipe: %e", r);
  8000c9:	50                   	push   %eax
  8000ca:	68 ce 2c 80 00       	push   $0x802cce
  8000cf:	6a 0d                	push   $0xd
  8000d1:	68 d7 2c 80 00       	push   $0x802cd7
  8000d6:	e8 18 02 00 00       	call   8002f3 <_panic>
		panic("fork: %e", r);
  8000db:	50                   	push   %eax
  8000dc:	68 ec 2c 80 00       	push   $0x802cec
  8000e1:	6a 0f                	push   $0xf
  8000e3:	68 d7 2c 80 00       	push   $0x802cd7
  8000e8:	e8 06 02 00 00       	call   8002f3 <_panic>
		close(p[1]);
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f3:	e8 a9 17 00 00       	call   8018a1 <close>
  8000f8:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000fb:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000fd:	be 67 66 66 66       	mov    $0x66666667,%esi
  800102:	eb 42                	jmp    800146 <umain+0x113>
				cprintf("%d.", i);
  800104:	83 ec 08             	sub    $0x8,%esp
  800107:	53                   	push   %ebx
  800108:	68 f5 2c 80 00       	push   $0x802cf5
  80010d:	e8 d7 02 00 00       	call   8003e9 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	ff 75 e0             	pushl  -0x20(%ebp)
  80011d:	e8 d1 17 00 00       	call   8018f3 <dup>
			sys_yield();
  800122:	e8 f4 0d 00 00       	call   800f1b <sys_yield>
			close(10);
  800127:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80012e:	e8 6e 17 00 00       	call   8018a1 <close>
			sys_yield();
  800133:	e8 e3 0d 00 00       	call   800f1b <sys_yield>
		for (i = 0; i < 200; i++) {
  800138:	83 c3 01             	add    $0x1,%ebx
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800144:	74 19                	je     80015f <umain+0x12c>
			if (i % 10 == 0)
  800146:	89 d8                	mov    %ebx,%eax
  800148:	f7 ee                	imul   %esi
  80014a:	c1 fa 02             	sar    $0x2,%edx
  80014d:	89 d8                	mov    %ebx,%eax
  80014f:	c1 f8 1f             	sar    $0x1f,%eax
  800152:	29 c2                	sub    %eax,%edx
  800154:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800157:	01 c0                	add    %eax,%eax
  800159:	39 c3                	cmp    %eax,%ebx
  80015b:	75 b8                	jne    800115 <umain+0xe2>
  80015d:	eb a5                	jmp    800104 <umain+0xd1>
		exit();
  80015f:	e8 5b 01 00 00       	call   8002bf <exit>
  800164:	e9 00 ff ff ff       	jmp    800069 <umain+0x36>
		}
	cprintf("child done with loop\n");
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	68 15 2d 80 00       	push   $0x802d15
  800171:	e8 73 02 00 00       	call   8003e9 <cprintf>
	if (pipeisclosed(p[0]))
  800176:	83 c4 04             	add    $0x4,%esp
  800179:	ff 75 e0             	pushl  -0x20(%ebp)
  80017c:	e8 23 25 00 00       	call   8026a4 <pipeisclosed>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	75 38                	jne    8001c0 <umain+0x18d>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	ff 75 e0             	pushl  -0x20(%ebp)
  800192:	e8 d8 15 00 00       	call   80176f <fd_lookup>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	85 c0                	test   %eax,%eax
  80019c:	78 36                	js     8001d4 <umain+0x1a1>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a4:	e8 5d 15 00 00       	call   801706 <fd2data>
	cprintf("race didn't happen\n");
  8001a9:	c7 04 24 43 2d 80 00 	movl   $0x802d43,(%esp)
  8001b0:	e8 34 02 00 00       	call   8003e9 <cprintf>
}
  8001b5:	83 c4 10             	add    $0x10,%esp
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 a4 2c 80 00       	push   $0x802ca4
  8001c8:	6a 41                	push   $0x41
  8001ca:	68 d7 2c 80 00       	push   $0x802cd7
  8001cf:	e8 1f 01 00 00       	call   8002f3 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001d4:	50                   	push   %eax
  8001d5:	68 2b 2d 80 00       	push   $0x802d2b
  8001da:	6a 43                	push   $0x43
  8001dc:	68 d7 2c 80 00       	push   $0x802cd7
  8001e1:	e8 0d 01 00 00       	call   8002f3 <_panic>

008001e6 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001ef:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001f6:	00 00 00 
	envid_t find = sys_getenvid();
  8001f9:	e8 fe 0c 00 00       	call   800efc <sys_getenvid>
  8001fe:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800204:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800209:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80020e:	bf 01 00 00 00       	mov    $0x1,%edi
  800213:	eb 0b                	jmp    800220 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800215:	83 c2 01             	add    $0x1,%edx
  800218:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80021e:	74 21                	je     800241 <libmain+0x5b>
		if(envs[i].env_id == find)
  800220:	89 d1                	mov    %edx,%ecx
  800222:	c1 e1 07             	shl    $0x7,%ecx
  800225:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80022b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	75 e3                	jne    800215 <libmain+0x2f>
  800232:	89 d3                	mov    %edx,%ebx
  800234:	c1 e3 07             	shl    $0x7,%ebx
  800237:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80023d:	89 fe                	mov    %edi,%esi
  80023f:	eb d4                	jmp    800215 <libmain+0x2f>
  800241:	89 f0                	mov    %esi,%eax
  800243:	84 c0                	test   %al,%al
  800245:	74 06                	je     80024d <libmain+0x67>
  800247:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800251:	7e 0a                	jle    80025d <libmain+0x77>
		binaryname = argv[0];
  800253:	8b 45 0c             	mov    0xc(%ebp),%eax
  800256:	8b 00                	mov    (%eax),%eax
  800258:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80025d:	a1 08 50 80 00       	mov    0x805008,%eax
  800262:	8b 40 48             	mov    0x48(%eax),%eax
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	50                   	push   %eax
  800269:	68 5e 2d 80 00       	push   $0x802d5e
  80026e:	e8 76 01 00 00       	call   8003e9 <cprintf>
	cprintf("before umain\n");
  800273:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  80027a:	e8 6a 01 00 00       	call   8003e9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80027f:	83 c4 08             	add    $0x8,%esp
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	e8 a6 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80028d:	c7 04 24 8a 2d 80 00 	movl   $0x802d8a,(%esp)
  800294:	e8 50 01 00 00       	call   8003e9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800299:	a1 08 50 80 00       	mov    0x805008,%eax
  80029e:	8b 40 48             	mov    0x48(%eax),%eax
  8002a1:	83 c4 08             	add    $0x8,%esp
  8002a4:	50                   	push   %eax
  8002a5:	68 97 2d 80 00       	push   $0x802d97
  8002aa:	e8 3a 01 00 00       	call   8003e9 <cprintf>
	// exit gracefully
	exit();
  8002af:	e8 0b 00 00 00       	call   8002bf <exit>
}
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ba:	5b                   	pop    %ebx
  8002bb:	5e                   	pop    %esi
  8002bc:	5f                   	pop    %edi
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002c5:	a1 08 50 80 00       	mov    0x805008,%eax
  8002ca:	8b 40 48             	mov    0x48(%eax),%eax
  8002cd:	68 c4 2d 80 00       	push   $0x802dc4
  8002d2:	50                   	push   %eax
  8002d3:	68 b6 2d 80 00       	push   $0x802db6
  8002d8:	e8 0c 01 00 00       	call   8003e9 <cprintf>
	close_all();
  8002dd:	e8 ec 15 00 00       	call   8018ce <close_all>
	sys_env_destroy(0);
  8002e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002e9:	e8 cd 0b 00 00       	call   800ebb <sys_env_destroy>
}
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	56                   	push   %esi
  8002f7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002f8:	a1 08 50 80 00       	mov    0x805008,%eax
  8002fd:	8b 40 48             	mov    0x48(%eax),%eax
  800300:	83 ec 04             	sub    $0x4,%esp
  800303:	68 f0 2d 80 00       	push   $0x802df0
  800308:	50                   	push   %eax
  800309:	68 b6 2d 80 00       	push   $0x802db6
  80030e:	e8 d6 00 00 00       	call   8003e9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800313:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800316:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80031c:	e8 db 0b 00 00       	call   800efc <sys_getenvid>
  800321:	83 c4 04             	add    $0x4,%esp
  800324:	ff 75 0c             	pushl  0xc(%ebp)
  800327:	ff 75 08             	pushl  0x8(%ebp)
  80032a:	56                   	push   %esi
  80032b:	50                   	push   %eax
  80032c:	68 cc 2d 80 00       	push   $0x802dcc
  800331:	e8 b3 00 00 00       	call   8003e9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800336:	83 c4 18             	add    $0x18,%esp
  800339:	53                   	push   %ebx
  80033a:	ff 75 10             	pushl  0x10(%ebp)
  80033d:	e8 56 00 00 00       	call   800398 <vcprintf>
	cprintf("\n");
  800342:	c7 04 24 7a 2d 80 00 	movl   $0x802d7a,(%esp)
  800349:	e8 9b 00 00 00       	call   8003e9 <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800351:	cc                   	int3   
  800352:	eb fd                	jmp    800351 <_panic+0x5e>

00800354 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	53                   	push   %ebx
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80035e:	8b 13                	mov    (%ebx),%edx
  800360:	8d 42 01             	lea    0x1(%edx),%eax
  800363:	89 03                	mov    %eax,(%ebx)
  800365:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800368:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80036c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800371:	74 09                	je     80037c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800373:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	68 ff 00 00 00       	push   $0xff
  800384:	8d 43 08             	lea    0x8(%ebx),%eax
  800387:	50                   	push   %eax
  800388:	e8 f1 0a 00 00       	call   800e7e <sys_cputs>
		b->idx = 0;
  80038d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	eb db                	jmp    800373 <putch+0x1f>

00800398 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a8:	00 00 00 
	b.cnt = 0;
  8003ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	68 54 03 80 00       	push   $0x800354
  8003c7:	e8 4a 01 00 00       	call   800516 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003d5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	e8 9d 0a 00 00       	call   800e7e <sys_cputs>

	return b.cnt;
}
  8003e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ef:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003f2:	50                   	push   %eax
  8003f3:	ff 75 08             	pushl  0x8(%ebp)
  8003f6:	e8 9d ff ff ff       	call   800398 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	57                   	push   %edi
  800401:	56                   	push   %esi
  800402:	53                   	push   %ebx
  800403:	83 ec 1c             	sub    $0x1c,%esp
  800406:	89 c6                	mov    %eax,%esi
  800408:	89 d7                	mov    %edx,%edi
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800410:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800413:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800416:	8b 45 10             	mov    0x10(%ebp),%eax
  800419:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80041c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800420:	74 2c                	je     80044e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800422:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800425:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80042c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800432:	39 c2                	cmp    %eax,%edx
  800434:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800437:	73 43                	jae    80047c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800439:	83 eb 01             	sub    $0x1,%ebx
  80043c:	85 db                	test   %ebx,%ebx
  80043e:	7e 6c                	jle    8004ac <printnum+0xaf>
				putch(padc, putdat);
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	57                   	push   %edi
  800444:	ff 75 18             	pushl  0x18(%ebp)
  800447:	ff d6                	call   *%esi
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	eb eb                	jmp    800439 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80044e:	83 ec 0c             	sub    $0xc,%esp
  800451:	6a 20                	push   $0x20
  800453:	6a 00                	push   $0x0
  800455:	50                   	push   %eax
  800456:	ff 75 e4             	pushl  -0x1c(%ebp)
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	89 fa                	mov    %edi,%edx
  80045e:	89 f0                	mov    %esi,%eax
  800460:	e8 98 ff ff ff       	call   8003fd <printnum>
		while (--width > 0)
  800465:	83 c4 20             	add    $0x20,%esp
  800468:	83 eb 01             	sub    $0x1,%ebx
  80046b:	85 db                	test   %ebx,%ebx
  80046d:	7e 65                	jle    8004d4 <printnum+0xd7>
			putch(padc, putdat);
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	57                   	push   %edi
  800473:	6a 20                	push   $0x20
  800475:	ff d6                	call   *%esi
  800477:	83 c4 10             	add    $0x10,%esp
  80047a:	eb ec                	jmp    800468 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80047c:	83 ec 0c             	sub    $0xc,%esp
  80047f:	ff 75 18             	pushl  0x18(%ebp)
  800482:	83 eb 01             	sub    $0x1,%ebx
  800485:	53                   	push   %ebx
  800486:	50                   	push   %eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 dc             	pushl  -0x24(%ebp)
  80048d:	ff 75 d8             	pushl  -0x28(%ebp)
  800490:	ff 75 e4             	pushl  -0x1c(%ebp)
  800493:	ff 75 e0             	pushl  -0x20(%ebp)
  800496:	e8 85 25 00 00       	call   802a20 <__udivdi3>
  80049b:	83 c4 18             	add    $0x18,%esp
  80049e:	52                   	push   %edx
  80049f:	50                   	push   %eax
  8004a0:	89 fa                	mov    %edi,%edx
  8004a2:	89 f0                	mov    %esi,%eax
  8004a4:	e8 54 ff ff ff       	call   8003fd <printnum>
  8004a9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	57                   	push   %edi
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bf:	e8 6c 26 00 00       	call   802b30 <__umoddi3>
  8004c4:	83 c4 14             	add    $0x14,%esp
  8004c7:	0f be 80 f7 2d 80 00 	movsbl 0x802df7(%eax),%eax
  8004ce:	50                   	push   %eax
  8004cf:	ff d6                	call   *%esi
  8004d1:	83 c4 10             	add    $0x10,%esp
	}
}
  8004d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d7:	5b                   	pop    %ebx
  8004d8:	5e                   	pop    %esi
  8004d9:	5f                   	pop    %edi
  8004da:	5d                   	pop    %ebp
  8004db:	c3                   	ret    

008004dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e6:	8b 10                	mov    (%eax),%edx
  8004e8:	3b 50 04             	cmp    0x4(%eax),%edx
  8004eb:	73 0a                	jae    8004f7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f0:	89 08                	mov    %ecx,(%eax)
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	88 02                	mov    %al,(%edx)
}
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    

008004f9 <printfmt>:
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ff:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800502:	50                   	push   %eax
  800503:	ff 75 10             	pushl  0x10(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 05 00 00 00       	call   800516 <vprintfmt>
}
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	c9                   	leave  
  800515:	c3                   	ret    

00800516 <vprintfmt>:
{
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	57                   	push   %edi
  80051a:	56                   	push   %esi
  80051b:	53                   	push   %ebx
  80051c:	83 ec 3c             	sub    $0x3c,%esp
  80051f:	8b 75 08             	mov    0x8(%ebp),%esi
  800522:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800525:	8b 7d 10             	mov    0x10(%ebp),%edi
  800528:	e9 32 04 00 00       	jmp    80095f <vprintfmt+0x449>
		padc = ' ';
  80052d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800531:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800538:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80053f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800546:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80054d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800554:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800559:	8d 47 01             	lea    0x1(%edi),%eax
  80055c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055f:	0f b6 17             	movzbl (%edi),%edx
  800562:	8d 42 dd             	lea    -0x23(%edx),%eax
  800565:	3c 55                	cmp    $0x55,%al
  800567:	0f 87 12 05 00 00    	ja     800a7f <vprintfmt+0x569>
  80056d:	0f b6 c0             	movzbl %al,%eax
  800570:	ff 24 85 e0 2f 80 00 	jmp    *0x802fe0(,%eax,4)
  800577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80057e:	eb d9                	jmp    800559 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800583:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800587:	eb d0                	jmp    800559 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800589:	0f b6 d2             	movzbl %dl,%edx
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	89 75 08             	mov    %esi,0x8(%ebp)
  800597:	eb 03                	jmp    80059c <vprintfmt+0x86>
  800599:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80059c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005a9:	83 fe 09             	cmp    $0x9,%esi
  8005ac:	76 eb                	jbe    800599 <vprintfmt+0x83>
  8005ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b4:	eb 14                	jmp    8005ca <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ce:	79 89                	jns    800559 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005dd:	e9 77 ff ff ff       	jmp    800559 <vprintfmt+0x43>
  8005e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e5:	85 c0                	test   %eax,%eax
  8005e7:	0f 48 c1             	cmovs  %ecx,%eax
  8005ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f0:	e9 64 ff ff ff       	jmp    800559 <vprintfmt+0x43>
  8005f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005ff:	e9 55 ff ff ff       	jmp    800559 <vprintfmt+0x43>
			lflag++;
  800604:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800608:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80060b:	e9 49 ff ff ff       	jmp    800559 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 78 04             	lea    0x4(%eax),%edi
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	ff 30                	pushl  (%eax)
  80061c:	ff d6                	call   *%esi
			break;
  80061e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800621:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800624:	e9 33 03 00 00       	jmp    80095c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8d 78 04             	lea    0x4(%eax),%edi
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
  800632:	31 d0                	xor    %edx,%eax
  800634:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800636:	83 f8 11             	cmp    $0x11,%eax
  800639:	7f 23                	jg     80065e <vprintfmt+0x148>
  80063b:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  800642:	85 d2                	test   %edx,%edx
  800644:	74 18                	je     80065e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800646:	52                   	push   %edx
  800647:	68 4d 33 80 00       	push   $0x80334d
  80064c:	53                   	push   %ebx
  80064d:	56                   	push   %esi
  80064e:	e8 a6 fe ff ff       	call   8004f9 <printfmt>
  800653:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800656:	89 7d 14             	mov    %edi,0x14(%ebp)
  800659:	e9 fe 02 00 00       	jmp    80095c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80065e:	50                   	push   %eax
  80065f:	68 0f 2e 80 00       	push   $0x802e0f
  800664:	53                   	push   %ebx
  800665:	56                   	push   %esi
  800666:	e8 8e fe ff ff       	call   8004f9 <printfmt>
  80066b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800671:	e9 e6 02 00 00       	jmp    80095c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	83 c0 04             	add    $0x4,%eax
  80067c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800684:	85 c9                	test   %ecx,%ecx
  800686:	b8 08 2e 80 00       	mov    $0x802e08,%eax
  80068b:	0f 45 c1             	cmovne %ecx,%eax
  80068e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800691:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800695:	7e 06                	jle    80069d <vprintfmt+0x187>
  800697:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80069b:	75 0d                	jne    8006aa <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a0:	89 c7                	mov    %eax,%edi
  8006a2:	03 45 e0             	add    -0x20(%ebp),%eax
  8006a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a8:	eb 53                	jmp    8006fd <vprintfmt+0x1e7>
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b0:	50                   	push   %eax
  8006b1:	e8 71 04 00 00       	call   800b27 <strnlen>
  8006b6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b9:	29 c1                	sub    %eax,%ecx
  8006bb:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006c3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ca:	eb 0f                	jmp    8006db <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d5:	83 ef 01             	sub    $0x1,%edi
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	85 ff                	test   %edi,%edi
  8006dd:	7f ed                	jg     8006cc <vprintfmt+0x1b6>
  8006df:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006e2:	85 c9                	test   %ecx,%ecx
  8006e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e9:	0f 49 c1             	cmovns %ecx,%eax
  8006ec:	29 c1                	sub    %eax,%ecx
  8006ee:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006f1:	eb aa                	jmp    80069d <vprintfmt+0x187>
					putch(ch, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	52                   	push   %edx
  8006f8:	ff d6                	call   *%esi
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800700:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800702:	83 c7 01             	add    $0x1,%edi
  800705:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800709:	0f be d0             	movsbl %al,%edx
  80070c:	85 d2                	test   %edx,%edx
  80070e:	74 4b                	je     80075b <vprintfmt+0x245>
  800710:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800714:	78 06                	js     80071c <vprintfmt+0x206>
  800716:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80071a:	78 1e                	js     80073a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80071c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800720:	74 d1                	je     8006f3 <vprintfmt+0x1dd>
  800722:	0f be c0             	movsbl %al,%eax
  800725:	83 e8 20             	sub    $0x20,%eax
  800728:	83 f8 5e             	cmp    $0x5e,%eax
  80072b:	76 c6                	jbe    8006f3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	6a 3f                	push   $0x3f
  800733:	ff d6                	call   *%esi
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	eb c3                	jmp    8006fd <vprintfmt+0x1e7>
  80073a:	89 cf                	mov    %ecx,%edi
  80073c:	eb 0e                	jmp    80074c <vprintfmt+0x236>
				putch(' ', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	53                   	push   %ebx
  800742:	6a 20                	push   $0x20
  800744:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800746:	83 ef 01             	sub    $0x1,%edi
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	85 ff                	test   %edi,%edi
  80074e:	7f ee                	jg     80073e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800750:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
  800756:	e9 01 02 00 00       	jmp    80095c <vprintfmt+0x446>
  80075b:	89 cf                	mov    %ecx,%edi
  80075d:	eb ed                	jmp    80074c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80075f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800762:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800769:	e9 eb fd ff ff       	jmp    800559 <vprintfmt+0x43>
	if (lflag >= 2)
  80076e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800772:	7f 21                	jg     800795 <vprintfmt+0x27f>
	else if (lflag)
  800774:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800778:	74 68                	je     8007e2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800782:	89 c1                	mov    %eax,%ecx
  800784:	c1 f9 1f             	sar    $0x1f,%ecx
  800787:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
  800793:	eb 17                	jmp    8007ac <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 50 04             	mov    0x4(%eax),%edx
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 08             	lea    0x8(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007bc:	78 3f                	js     8007fd <vprintfmt+0x2e7>
			base = 10;
  8007be:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007c3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007c7:	0f 84 71 01 00 00    	je     80093e <vprintfmt+0x428>
				putch('+', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	6a 2b                	push   $0x2b
  8007d3:	ff d6                	call   *%esi
  8007d5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007dd:	e9 5c 01 00 00       	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ea:	89 c1                	mov    %eax,%ecx
  8007ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ef:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 40 04             	lea    0x4(%eax),%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fb:	eb af                	jmp    8007ac <vprintfmt+0x296>
				putch('-', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 2d                	push   $0x2d
  800803:	ff d6                	call   *%esi
				num = -(long long) num;
  800805:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800808:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80080b:	f7 d8                	neg    %eax
  80080d:	83 d2 00             	adc    $0x0,%edx
  800810:	f7 da                	neg    %edx
  800812:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800815:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800818:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80081b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800820:	e9 19 01 00 00       	jmp    80093e <vprintfmt+0x428>
	if (lflag >= 2)
  800825:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800829:	7f 29                	jg     800854 <vprintfmt+0x33e>
	else if (lflag)
  80082b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082f:	74 44                	je     800875 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084f:	e9 ea 00 00 00       	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 50 04             	mov    0x4(%eax),%edx
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8d 40 08             	lea    0x8(%eax),%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80086b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800870:	e9 c9 00 00 00       	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	ba 00 00 00 00       	mov    $0x0,%edx
  80087f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800882:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 40 04             	lea    0x4(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80088e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800893:	e9 a6 00 00 00       	jmp    80093e <vprintfmt+0x428>
			putch('0', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 30                	push   $0x30
  80089e:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a7:	7f 26                	jg     8008cf <vprintfmt+0x3b9>
	else if (lflag)
  8008a9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ad:	74 3e                	je     8008ed <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 40 04             	lea    0x4(%eax),%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8008cd:	eb 6f                	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8b 50 04             	mov    0x4(%eax),%edx
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8d 40 08             	lea    0x8(%eax),%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8008eb:	eb 51                	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	8d 40 04             	lea    0x4(%eax),%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800906:	b8 08 00 00 00       	mov    $0x8,%eax
  80090b:	eb 31                	jmp    80093e <vprintfmt+0x428>
			putch('0', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	53                   	push   %ebx
  800911:	6a 30                	push   $0x30
  800913:	ff d6                	call   *%esi
			putch('x', putdat);
  800915:	83 c4 08             	add    $0x8,%esp
  800918:	53                   	push   %ebx
  800919:	6a 78                	push   $0x78
  80091b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	ba 00 00 00 00       	mov    $0x0,%edx
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80092d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 40 04             	lea    0x4(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800939:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80093e:	83 ec 0c             	sub    $0xc,%esp
  800941:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800945:	52                   	push   %edx
  800946:	ff 75 e0             	pushl  -0x20(%ebp)
  800949:	50                   	push   %eax
  80094a:	ff 75 dc             	pushl  -0x24(%ebp)
  80094d:	ff 75 d8             	pushl  -0x28(%ebp)
  800950:	89 da                	mov    %ebx,%edx
  800952:	89 f0                	mov    %esi,%eax
  800954:	e8 a4 fa ff ff       	call   8003fd <printnum>
			break;
  800959:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80095c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095f:	83 c7 01             	add    $0x1,%edi
  800962:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800966:	83 f8 25             	cmp    $0x25,%eax
  800969:	0f 84 be fb ff ff    	je     80052d <vprintfmt+0x17>
			if (ch == '\0')
  80096f:	85 c0                	test   %eax,%eax
  800971:	0f 84 28 01 00 00    	je     800a9f <vprintfmt+0x589>
			putch(ch, putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	53                   	push   %ebx
  80097b:	50                   	push   %eax
  80097c:	ff d6                	call   *%esi
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	eb dc                	jmp    80095f <vprintfmt+0x449>
	if (lflag >= 2)
  800983:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800987:	7f 26                	jg     8009af <vprintfmt+0x499>
	else if (lflag)
  800989:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80098d:	74 41                	je     8009d0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 40 04             	lea    0x4(%eax),%eax
  8009a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8009ad:	eb 8f                	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8b 50 04             	mov    0x4(%eax),%edx
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8d 40 08             	lea    0x8(%eax),%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8009cb:	e9 6e ff ff ff       	jmp    80093e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e3:	8d 40 04             	lea    0x4(%eax),%eax
  8009e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8009ee:	e9 4b ff ff ff       	jmp    80093e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 c0 04             	add    $0x4,%eax
  8009f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	85 c0                	test   %eax,%eax
  800a03:	74 14                	je     800a19 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a05:	8b 13                	mov    (%ebx),%edx
  800a07:	83 fa 7f             	cmp    $0x7f,%edx
  800a0a:	7f 37                	jg     800a43 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a0c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a11:	89 45 14             	mov    %eax,0x14(%ebp)
  800a14:	e9 43 ff ff ff       	jmp    80095c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a1e:	bf 2d 2f 80 00       	mov    $0x802f2d,%edi
							putch(ch, putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	53                   	push   %ebx
  800a27:	50                   	push   %eax
  800a28:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a2a:	83 c7 01             	add    $0x1,%edi
  800a2d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	85 c0                	test   %eax,%eax
  800a36:	75 eb                	jne    800a23 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	e9 19 ff ff ff       	jmp    80095c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a43:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a4a:	bf 65 2f 80 00       	mov    $0x802f65,%edi
							putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	50                   	push   %eax
  800a54:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a56:	83 c7 01             	add    $0x1,%edi
  800a59:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	85 c0                	test   %eax,%eax
  800a62:	75 eb                	jne    800a4f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a67:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6a:	e9 ed fe ff ff       	jmp    80095c <vprintfmt+0x446>
			putch(ch, putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	53                   	push   %ebx
  800a73:	6a 25                	push   $0x25
  800a75:	ff d6                	call   *%esi
			break;
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	e9 dd fe ff ff       	jmp    80095c <vprintfmt+0x446>
			putch('%', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	53                   	push   %ebx
  800a83:	6a 25                	push   $0x25
  800a85:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	89 f8                	mov    %edi,%eax
  800a8c:	eb 03                	jmp    800a91 <vprintfmt+0x57b>
  800a8e:	83 e8 01             	sub    $0x1,%eax
  800a91:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a95:	75 f7                	jne    800a8e <vprintfmt+0x578>
  800a97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a9a:	e9 bd fe ff ff       	jmp    80095c <vprintfmt+0x446>
}
  800a9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aa2:	5b                   	pop    %ebx
  800aa3:	5e                   	pop    %esi
  800aa4:	5f                   	pop    %edi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 18             	sub    $0x18,%esp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ac4:	85 c0                	test   %eax,%eax
  800ac6:	74 26                	je     800aee <vsnprintf+0x47>
  800ac8:	85 d2                	test   %edx,%edx
  800aca:	7e 22                	jle    800aee <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800acc:	ff 75 14             	pushl  0x14(%ebp)
  800acf:	ff 75 10             	pushl  0x10(%ebp)
  800ad2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad5:	50                   	push   %eax
  800ad6:	68 dc 04 80 00       	push   $0x8004dc
  800adb:	e8 36 fa ff ff       	call   800516 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
}
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    
		return -E_INVAL;
  800aee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800af3:	eb f7                	jmp    800aec <vsnprintf+0x45>

00800af5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800afb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800afe:	50                   	push   %eax
  800aff:	ff 75 10             	pushl  0x10(%ebp)
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 9a ff ff ff       	call   800aa7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b0d:	c9                   	leave  
  800b0e:	c3                   	ret    

00800b0f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b15:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b1e:	74 05                	je     800b25 <strlen+0x16>
		n++;
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	eb f5                	jmp    800b1a <strlen+0xb>
	return n;
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	39 c2                	cmp    %eax,%edx
  800b37:	74 0d                	je     800b46 <strnlen+0x1f>
  800b39:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b3d:	74 05                	je     800b44 <strnlen+0x1d>
		n++;
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	eb f1                	jmp    800b35 <strnlen+0xe>
  800b44:	89 d0                	mov    %edx,%eax
	return n;
}
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	53                   	push   %ebx
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b5b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	84 c9                	test   %cl,%cl
  800b63:	75 f2                	jne    800b57 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b65:	5b                   	pop    %ebx
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	53                   	push   %ebx
  800b6c:	83 ec 10             	sub    $0x10,%esp
  800b6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b72:	53                   	push   %ebx
  800b73:	e8 97 ff ff ff       	call   800b0f <strlen>
  800b78:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	01 d8                	add    %ebx,%eax
  800b80:	50                   	push   %eax
  800b81:	e8 c2 ff ff ff       	call   800b48 <strcpy>
	return dst;
}
  800b86:	89 d8                	mov    %ebx,%eax
  800b88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b98:	89 c6                	mov    %eax,%esi
  800b9a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	39 f2                	cmp    %esi,%edx
  800ba1:	74 11                	je     800bb4 <strncpy+0x27>
		*dst++ = *src;
  800ba3:	83 c2 01             	add    $0x1,%edx
  800ba6:	0f b6 19             	movzbl (%ecx),%ebx
  800ba9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bac:	80 fb 01             	cmp    $0x1,%bl
  800baf:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bb2:	eb eb                	jmp    800b9f <strncpy+0x12>
	}
	return ret;
}
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	8b 75 08             	mov    0x8(%ebp),%esi
  800bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc3:	8b 55 10             	mov    0x10(%ebp),%edx
  800bc6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bc8:	85 d2                	test   %edx,%edx
  800bca:	74 21                	je     800bed <strlcpy+0x35>
  800bcc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bd0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bd2:	39 c2                	cmp    %eax,%edx
  800bd4:	74 14                	je     800bea <strlcpy+0x32>
  800bd6:	0f b6 19             	movzbl (%ecx),%ebx
  800bd9:	84 db                	test   %bl,%bl
  800bdb:	74 0b                	je     800be8 <strlcpy+0x30>
			*dst++ = *src++;
  800bdd:	83 c1 01             	add    $0x1,%ecx
  800be0:	83 c2 01             	add    $0x1,%edx
  800be3:	88 5a ff             	mov    %bl,-0x1(%edx)
  800be6:	eb ea                	jmp    800bd2 <strlcpy+0x1a>
  800be8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bed:	29 f0                	sub    %esi,%eax
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bfc:	0f b6 01             	movzbl (%ecx),%eax
  800bff:	84 c0                	test   %al,%al
  800c01:	74 0c                	je     800c0f <strcmp+0x1c>
  800c03:	3a 02                	cmp    (%edx),%al
  800c05:	75 08                	jne    800c0f <strcmp+0x1c>
		p++, q++;
  800c07:	83 c1 01             	add    $0x1,%ecx
  800c0a:	83 c2 01             	add    $0x1,%edx
  800c0d:	eb ed                	jmp    800bfc <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0f:	0f b6 c0             	movzbl %al,%eax
  800c12:	0f b6 12             	movzbl (%edx),%edx
  800c15:	29 d0                	sub    %edx,%eax
}
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	53                   	push   %ebx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c23:	89 c3                	mov    %eax,%ebx
  800c25:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c28:	eb 06                	jmp    800c30 <strncmp+0x17>
		n--, p++, q++;
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c30:	39 d8                	cmp    %ebx,%eax
  800c32:	74 16                	je     800c4a <strncmp+0x31>
  800c34:	0f b6 08             	movzbl (%eax),%ecx
  800c37:	84 c9                	test   %cl,%cl
  800c39:	74 04                	je     800c3f <strncmp+0x26>
  800c3b:	3a 0a                	cmp    (%edx),%cl
  800c3d:	74 eb                	je     800c2a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3f:	0f b6 00             	movzbl (%eax),%eax
  800c42:	0f b6 12             	movzbl (%edx),%edx
  800c45:	29 d0                	sub    %edx,%eax
}
  800c47:	5b                   	pop    %ebx
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
		return 0;
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	eb f6                	jmp    800c47 <strncmp+0x2e>

00800c51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c5b:	0f b6 10             	movzbl (%eax),%edx
  800c5e:	84 d2                	test   %dl,%dl
  800c60:	74 09                	je     800c6b <strchr+0x1a>
		if (*s == c)
  800c62:	38 ca                	cmp    %cl,%dl
  800c64:	74 0a                	je     800c70 <strchr+0x1f>
	for (; *s; s++)
  800c66:	83 c0 01             	add    $0x1,%eax
  800c69:	eb f0                	jmp    800c5b <strchr+0xa>
			return (char *) s;
	return 0;
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c7c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c7f:	38 ca                	cmp    %cl,%dl
  800c81:	74 09                	je     800c8c <strfind+0x1a>
  800c83:	84 d2                	test   %dl,%dl
  800c85:	74 05                	je     800c8c <strfind+0x1a>
	for (; *s; s++)
  800c87:	83 c0 01             	add    $0x1,%eax
  800c8a:	eb f0                	jmp    800c7c <strfind+0xa>
			break;
	return (char *) s;
}
  800c8c:	5d                   	pop    %ebp
  800c8d:	c3                   	ret    

00800c8e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c9a:	85 c9                	test   %ecx,%ecx
  800c9c:	74 31                	je     800ccf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c9e:	89 f8                	mov    %edi,%eax
  800ca0:	09 c8                	or     %ecx,%eax
  800ca2:	a8 03                	test   $0x3,%al
  800ca4:	75 23                	jne    800cc9 <memset+0x3b>
		c &= 0xFF;
  800ca6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800caa:	89 d3                	mov    %edx,%ebx
  800cac:	c1 e3 08             	shl    $0x8,%ebx
  800caf:	89 d0                	mov    %edx,%eax
  800cb1:	c1 e0 18             	shl    $0x18,%eax
  800cb4:	89 d6                	mov    %edx,%esi
  800cb6:	c1 e6 10             	shl    $0x10,%esi
  800cb9:	09 f0                	or     %esi,%eax
  800cbb:	09 c2                	or     %eax,%edx
  800cbd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cbf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cc2:	89 d0                	mov    %edx,%eax
  800cc4:	fc                   	cld    
  800cc5:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc7:	eb 06                	jmp    800ccf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	fc                   	cld    
  800ccd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ccf:	89 f8                	mov    %edi,%eax
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce4:	39 c6                	cmp    %eax,%esi
  800ce6:	73 32                	jae    800d1a <memmove+0x44>
  800ce8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ceb:	39 c2                	cmp    %eax,%edx
  800ced:	76 2b                	jbe    800d1a <memmove+0x44>
		s += n;
		d += n;
  800cef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf2:	89 fe                	mov    %edi,%esi
  800cf4:	09 ce                	or     %ecx,%esi
  800cf6:	09 d6                	or     %edx,%esi
  800cf8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cfe:	75 0e                	jne    800d0e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d00:	83 ef 04             	sub    $0x4,%edi
  800d03:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d09:	fd                   	std    
  800d0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d0c:	eb 09                	jmp    800d17 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0e:	83 ef 01             	sub    $0x1,%edi
  800d11:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d14:	fd                   	std    
  800d15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d17:	fc                   	cld    
  800d18:	eb 1a                	jmp    800d34 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d1a:	89 c2                	mov    %eax,%edx
  800d1c:	09 ca                	or     %ecx,%edx
  800d1e:	09 f2                	or     %esi,%edx
  800d20:	f6 c2 03             	test   $0x3,%dl
  800d23:	75 0a                	jne    800d2f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d28:	89 c7                	mov    %eax,%edi
  800d2a:	fc                   	cld    
  800d2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2d:	eb 05                	jmp    800d34 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d2f:	89 c7                	mov    %eax,%edi
  800d31:	fc                   	cld    
  800d32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d3e:	ff 75 10             	pushl  0x10(%ebp)
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	ff 75 08             	pushl  0x8(%ebp)
  800d47:	e8 8a ff ff ff       	call   800cd6 <memmove>
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	89 c6                	mov    %eax,%esi
  800d5b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d5e:	39 f0                	cmp    %esi,%eax
  800d60:	74 1c                	je     800d7e <memcmp+0x30>
		if (*s1 != *s2)
  800d62:	0f b6 08             	movzbl (%eax),%ecx
  800d65:	0f b6 1a             	movzbl (%edx),%ebx
  800d68:	38 d9                	cmp    %bl,%cl
  800d6a:	75 08                	jne    800d74 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d6c:	83 c0 01             	add    $0x1,%eax
  800d6f:	83 c2 01             	add    $0x1,%edx
  800d72:	eb ea                	jmp    800d5e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d74:	0f b6 c1             	movzbl %cl,%eax
  800d77:	0f b6 db             	movzbl %bl,%ebx
  800d7a:	29 d8                	sub    %ebx,%eax
  800d7c:	eb 05                	jmp    800d83 <memcmp+0x35>
	}

	return 0;
  800d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d95:	39 d0                	cmp    %edx,%eax
  800d97:	73 09                	jae    800da2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d99:	38 08                	cmp    %cl,(%eax)
  800d9b:	74 05                	je     800da2 <memfind+0x1b>
	for (; s < ends; s++)
  800d9d:	83 c0 01             	add    $0x1,%eax
  800da0:	eb f3                	jmp    800d95 <memfind+0xe>
			break;
	return (void *) s;
}
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db0:	eb 03                	jmp    800db5 <strtol+0x11>
		s++;
  800db2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800db5:	0f b6 01             	movzbl (%ecx),%eax
  800db8:	3c 20                	cmp    $0x20,%al
  800dba:	74 f6                	je     800db2 <strtol+0xe>
  800dbc:	3c 09                	cmp    $0x9,%al
  800dbe:	74 f2                	je     800db2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dc0:	3c 2b                	cmp    $0x2b,%al
  800dc2:	74 2a                	je     800dee <strtol+0x4a>
	int neg = 0;
  800dc4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dc9:	3c 2d                	cmp    $0x2d,%al
  800dcb:	74 2b                	je     800df8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dcd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dd3:	75 0f                	jne    800de4 <strtol+0x40>
  800dd5:	80 39 30             	cmpb   $0x30,(%ecx)
  800dd8:	74 28                	je     800e02 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dda:	85 db                	test   %ebx,%ebx
  800ddc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de1:	0f 44 d8             	cmove  %eax,%ebx
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dec:	eb 50                	jmp    800e3e <strtol+0x9a>
		s++;
  800dee:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800df1:	bf 00 00 00 00       	mov    $0x0,%edi
  800df6:	eb d5                	jmp    800dcd <strtol+0x29>
		s++, neg = 1;
  800df8:	83 c1 01             	add    $0x1,%ecx
  800dfb:	bf 01 00 00 00       	mov    $0x1,%edi
  800e00:	eb cb                	jmp    800dcd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e02:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e06:	74 0e                	je     800e16 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e08:	85 db                	test   %ebx,%ebx
  800e0a:	75 d8                	jne    800de4 <strtol+0x40>
		s++, base = 8;
  800e0c:	83 c1 01             	add    $0x1,%ecx
  800e0f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e14:	eb ce                	jmp    800de4 <strtol+0x40>
		s += 2, base = 16;
  800e16:	83 c1 02             	add    $0x2,%ecx
  800e19:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e1e:	eb c4                	jmp    800de4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e23:	89 f3                	mov    %esi,%ebx
  800e25:	80 fb 19             	cmp    $0x19,%bl
  800e28:	77 29                	ja     800e53 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e2a:	0f be d2             	movsbl %dl,%edx
  800e2d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e33:	7d 30                	jge    800e65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e35:	83 c1 01             	add    $0x1,%ecx
  800e38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e3e:	0f b6 11             	movzbl (%ecx),%edx
  800e41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e44:	89 f3                	mov    %esi,%ebx
  800e46:	80 fb 09             	cmp    $0x9,%bl
  800e49:	77 d5                	ja     800e20 <strtol+0x7c>
			dig = *s - '0';
  800e4b:	0f be d2             	movsbl %dl,%edx
  800e4e:	83 ea 30             	sub    $0x30,%edx
  800e51:	eb dd                	jmp    800e30 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e53:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e56:	89 f3                	mov    %esi,%ebx
  800e58:	80 fb 19             	cmp    $0x19,%bl
  800e5b:	77 08                	ja     800e65 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e5d:	0f be d2             	movsbl %dl,%edx
  800e60:	83 ea 37             	sub    $0x37,%edx
  800e63:	eb cb                	jmp    800e30 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e69:	74 05                	je     800e70 <strtol+0xcc>
		*endptr = (char *) s;
  800e6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e6e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	f7 da                	neg    %edx
  800e74:	85 ff                	test   %edi,%edi
  800e76:	0f 45 c2             	cmovne %edx,%eax
}
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	89 c3                	mov    %eax,%ebx
  800e91:	89 c7                	mov    %eax,%edi
  800e93:	89 c6                	mov    %eax,%esi
  800e95:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_cgetc>:

int
sys_cgetc(void)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea7:	b8 01 00 00 00       	mov    $0x1,%eax
  800eac:	89 d1                	mov    %edx,%ecx
  800eae:	89 d3                	mov    %edx,%ebx
  800eb0:	89 d7                	mov    %edx,%edi
  800eb2:	89 d6                	mov    %edx,%esi
  800eb4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	b8 03 00 00 00       	mov    $0x3,%eax
  800ed1:	89 cb                	mov    %ecx,%ebx
  800ed3:	89 cf                	mov    %ecx,%edi
  800ed5:	89 ce                	mov    %ecx,%esi
  800ed7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	7f 08                	jg     800ee5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	50                   	push   %eax
  800ee9:	6a 03                	push   $0x3
  800eeb:	68 88 31 80 00       	push   $0x803188
  800ef0:	6a 43                	push   $0x43
  800ef2:	68 a5 31 80 00       	push   $0x8031a5
  800ef7:	e8 f7 f3 ff ff       	call   8002f3 <_panic>

00800efc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f02:	ba 00 00 00 00       	mov    $0x0,%edx
  800f07:	b8 02 00 00 00       	mov    $0x2,%eax
  800f0c:	89 d1                	mov    %edx,%ecx
  800f0e:	89 d3                	mov    %edx,%ebx
  800f10:	89 d7                	mov    %edx,%edi
  800f12:	89 d6                	mov    %edx,%esi
  800f14:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_yield>:

void
sys_yield(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f43:	be 00 00 00 00       	mov    $0x0,%esi
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	b8 04 00 00 00       	mov    $0x4,%eax
  800f53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f56:	89 f7                	mov    %esi,%edi
  800f58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	7f 08                	jg     800f66 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	50                   	push   %eax
  800f6a:	6a 04                	push   $0x4
  800f6c:	68 88 31 80 00       	push   $0x803188
  800f71:	6a 43                	push   $0x43
  800f73:	68 a5 31 80 00       	push   $0x8031a5
  800f78:	e8 76 f3 ff ff       	call   8002f3 <_panic>

00800f7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
  800f83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8c:	b8 05 00 00 00       	mov    $0x5,%eax
  800f91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f94:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f97:	8b 75 18             	mov    0x18(%ebp),%esi
  800f9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	7f 08                	jg     800fa8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa8:	83 ec 0c             	sub    $0xc,%esp
  800fab:	50                   	push   %eax
  800fac:	6a 05                	push   $0x5
  800fae:	68 88 31 80 00       	push   $0x803188
  800fb3:	6a 43                	push   $0x43
  800fb5:	68 a5 31 80 00       	push   $0x8031a5
  800fba:	e8 34 f3 ff ff       	call   8002f3 <_panic>

00800fbf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	b8 06 00 00 00       	mov    $0x6,%eax
  800fd8:	89 df                	mov    %ebx,%edi
  800fda:	89 de                	mov    %ebx,%esi
  800fdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	7f 08                	jg     800fea <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fea:	83 ec 0c             	sub    $0xc,%esp
  800fed:	50                   	push   %eax
  800fee:	6a 06                	push   $0x6
  800ff0:	68 88 31 80 00       	push   $0x803188
  800ff5:	6a 43                	push   $0x43
  800ff7:	68 a5 31 80 00       	push   $0x8031a5
  800ffc:	e8 f2 f2 ff ff       	call   8002f3 <_panic>

00801001 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
  801007:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801015:	b8 08 00 00 00       	mov    $0x8,%eax
  80101a:	89 df                	mov    %ebx,%edi
  80101c:	89 de                	mov    %ebx,%esi
  80101e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801020:	85 c0                	test   %eax,%eax
  801022:	7f 08                	jg     80102c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801024:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	50                   	push   %eax
  801030:	6a 08                	push   $0x8
  801032:	68 88 31 80 00       	push   $0x803188
  801037:	6a 43                	push   $0x43
  801039:	68 a5 31 80 00       	push   $0x8031a5
  80103e:	e8 b0 f2 ff ff       	call   8002f3 <_panic>

00801043 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
  801049:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801057:	b8 09 00 00 00       	mov    $0x9,%eax
  80105c:	89 df                	mov    %ebx,%edi
  80105e:	89 de                	mov    %ebx,%esi
  801060:	cd 30                	int    $0x30
	if(check && ret > 0)
  801062:	85 c0                	test   %eax,%eax
  801064:	7f 08                	jg     80106e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801066:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106e:	83 ec 0c             	sub    $0xc,%esp
  801071:	50                   	push   %eax
  801072:	6a 09                	push   $0x9
  801074:	68 88 31 80 00       	push   $0x803188
  801079:	6a 43                	push   $0x43
  80107b:	68 a5 31 80 00       	push   $0x8031a5
  801080:	e8 6e f2 ff ff       	call   8002f3 <_panic>

00801085 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	b8 0a 00 00 00       	mov    $0xa,%eax
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7f 08                	jg     8010b0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5f                   	pop    %edi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	50                   	push   %eax
  8010b4:	6a 0a                	push   $0xa
  8010b6:	68 88 31 80 00       	push   $0x803188
  8010bb:	6a 43                	push   $0x43
  8010bd:	68 a5 31 80 00       	push   $0x8031a5
  8010c2:	e8 2c f2 ff ff       	call   8002f3 <_panic>

008010c7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010d8:	be 00 00 00 00       	mov    $0x0,%esi
  8010dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	b8 0d 00 00 00       	mov    $0xd,%eax
  801100:	89 cb                	mov    %ecx,%ebx
  801102:	89 cf                	mov    %ecx,%edi
  801104:	89 ce                	mov    %ecx,%esi
  801106:	cd 30                	int    $0x30
	if(check && ret > 0)
  801108:	85 c0                	test   %eax,%eax
  80110a:	7f 08                	jg     801114 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80110c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801114:	83 ec 0c             	sub    $0xc,%esp
  801117:	50                   	push   %eax
  801118:	6a 0d                	push   $0xd
  80111a:	68 88 31 80 00       	push   $0x803188
  80111f:	6a 43                	push   $0x43
  801121:	68 a5 31 80 00       	push   $0x8031a5
  801126:	e8 c8 f1 ff ff       	call   8002f3 <_panic>

0080112b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
	asm volatile("int %1\n"
  801131:	bb 00 00 00 00       	mov    $0x0,%ebx
  801136:	8b 55 08             	mov    0x8(%ebp),%edx
  801139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801141:	89 df                	mov    %ebx,%edi
  801143:	89 de                	mov    %ebx,%esi
  801145:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
	asm volatile("int %1\n"
  801152:	b9 00 00 00 00       	mov    $0x0,%ecx
  801157:	8b 55 08             	mov    0x8(%ebp),%edx
  80115a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80115f:	89 cb                	mov    %ecx,%ebx
  801161:	89 cf                	mov    %ecx,%edi
  801163:	89 ce                	mov    %ecx,%esi
  801165:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	57                   	push   %edi
  801170:	56                   	push   %esi
  801171:	53                   	push   %ebx
	asm volatile("int %1\n"
  801172:	ba 00 00 00 00       	mov    $0x0,%edx
  801177:	b8 10 00 00 00       	mov    $0x10,%eax
  80117c:	89 d1                	mov    %edx,%ecx
  80117e:	89 d3                	mov    %edx,%ebx
  801180:	89 d7                	mov    %edx,%edi
  801182:	89 d6                	mov    %edx,%esi
  801184:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	57                   	push   %edi
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
	asm volatile("int %1\n"
  801191:	bb 00 00 00 00       	mov    $0x0,%ebx
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119c:	b8 11 00 00 00       	mov    $0x11,%eax
  8011a1:	89 df                	mov    %ebx,%edi
  8011a3:	89 de                	mov    %ebx,%esi
  8011a5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bd:	b8 12 00 00 00       	mov    $0x12,%eax
  8011c2:	89 df                	mov    %ebx,%edi
  8011c4:	89 de                	mov    %ebx,%esi
  8011c6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5f                   	pop    %edi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	57                   	push   %edi
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011db:	8b 55 08             	mov    0x8(%ebp),%edx
  8011de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e1:	b8 13 00 00 00       	mov    $0x13,%eax
  8011e6:	89 df                	mov    %ebx,%edi
  8011e8:	89 de                	mov    %ebx,%esi
  8011ea:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	7f 08                	jg     8011f8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5f                   	pop    %edi
  8011f6:	5d                   	pop    %ebp
  8011f7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	50                   	push   %eax
  8011fc:	6a 13                	push   $0x13
  8011fe:	68 88 31 80 00       	push   $0x803188
  801203:	6a 43                	push   $0x43
  801205:	68 a5 31 80 00       	push   $0x8031a5
  80120a:	e8 e4 f0 ff ff       	call   8002f3 <_panic>

0080120f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	53                   	push   %ebx
  801213:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801216:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80121d:	f6 c5 04             	test   $0x4,%ch
  801220:	75 45                	jne    801267 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801222:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801229:	83 e1 07             	and    $0x7,%ecx
  80122c:	83 f9 07             	cmp    $0x7,%ecx
  80122f:	74 6f                	je     8012a0 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801231:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801238:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80123e:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801244:	0f 84 b6 00 00 00    	je     801300 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80124a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801251:	83 e1 05             	and    $0x5,%ecx
  801254:	83 f9 05             	cmp    $0x5,%ecx
  801257:	0f 84 d7 00 00 00    	je     801334 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
  801262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801265:	c9                   	leave  
  801266:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801267:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80126e:	c1 e2 0c             	shl    $0xc,%edx
  801271:	83 ec 0c             	sub    $0xc,%esp
  801274:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80127a:	51                   	push   %ecx
  80127b:	52                   	push   %edx
  80127c:	50                   	push   %eax
  80127d:	52                   	push   %edx
  80127e:	6a 00                	push   $0x0
  801280:	e8 f8 fc ff ff       	call   800f7d <sys_page_map>
		if(r < 0)
  801285:	83 c4 20             	add    $0x20,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	79 d1                	jns    80125d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80128c:	83 ec 04             	sub    $0x4,%esp
  80128f:	68 b3 31 80 00       	push   $0x8031b3
  801294:	6a 54                	push   $0x54
  801296:	68 c9 31 80 00       	push   $0x8031c9
  80129b:	e8 53 f0 ff ff       	call   8002f3 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012a0:	89 d3                	mov    %edx,%ebx
  8012a2:	c1 e3 0c             	shl    $0xc,%ebx
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	68 05 08 00 00       	push   $0x805
  8012ad:	53                   	push   %ebx
  8012ae:	50                   	push   %eax
  8012af:	53                   	push   %ebx
  8012b0:	6a 00                	push   $0x0
  8012b2:	e8 c6 fc ff ff       	call   800f7d <sys_page_map>
		if(r < 0)
  8012b7:	83 c4 20             	add    $0x20,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 2e                	js     8012ec <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	68 05 08 00 00       	push   $0x805
  8012c6:	53                   	push   %ebx
  8012c7:	6a 00                	push   $0x0
  8012c9:	53                   	push   %ebx
  8012ca:	6a 00                	push   $0x0
  8012cc:	e8 ac fc ff ff       	call   800f7d <sys_page_map>
		if(r < 0)
  8012d1:	83 c4 20             	add    $0x20,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	79 85                	jns    80125d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	68 b3 31 80 00       	push   $0x8031b3
  8012e0:	6a 5f                	push   $0x5f
  8012e2:	68 c9 31 80 00       	push   $0x8031c9
  8012e7:	e8 07 f0 ff ff       	call   8002f3 <_panic>
			panic("sys_page_map() panic\n");
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	68 b3 31 80 00       	push   $0x8031b3
  8012f4:	6a 5b                	push   $0x5b
  8012f6:	68 c9 31 80 00       	push   $0x8031c9
  8012fb:	e8 f3 ef ff ff       	call   8002f3 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801300:	c1 e2 0c             	shl    $0xc,%edx
  801303:	83 ec 0c             	sub    $0xc,%esp
  801306:	68 05 08 00 00       	push   $0x805
  80130b:	52                   	push   %edx
  80130c:	50                   	push   %eax
  80130d:	52                   	push   %edx
  80130e:	6a 00                	push   $0x0
  801310:	e8 68 fc ff ff       	call   800f7d <sys_page_map>
		if(r < 0)
  801315:	83 c4 20             	add    $0x20,%esp
  801318:	85 c0                	test   %eax,%eax
  80131a:	0f 89 3d ff ff ff    	jns    80125d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801320:	83 ec 04             	sub    $0x4,%esp
  801323:	68 b3 31 80 00       	push   $0x8031b3
  801328:	6a 66                	push   $0x66
  80132a:	68 c9 31 80 00       	push   $0x8031c9
  80132f:	e8 bf ef ff ff       	call   8002f3 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801334:	c1 e2 0c             	shl    $0xc,%edx
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	6a 05                	push   $0x5
  80133c:	52                   	push   %edx
  80133d:	50                   	push   %eax
  80133e:	52                   	push   %edx
  80133f:	6a 00                	push   $0x0
  801341:	e8 37 fc ff ff       	call   800f7d <sys_page_map>
		if(r < 0)
  801346:	83 c4 20             	add    $0x20,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	0f 89 0c ff ff ff    	jns    80125d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	68 b3 31 80 00       	push   $0x8031b3
  801359:	6a 6d                	push   $0x6d
  80135b:	68 c9 31 80 00       	push   $0x8031c9
  801360:	e8 8e ef ff ff       	call   8002f3 <_panic>

00801365 <pgfault>:
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	53                   	push   %ebx
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80136f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801371:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801375:	0f 84 99 00 00 00    	je     801414 <pgfault+0xaf>
  80137b:	89 c2                	mov    %eax,%edx
  80137d:	c1 ea 16             	shr    $0x16,%edx
  801380:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801387:	f6 c2 01             	test   $0x1,%dl
  80138a:	0f 84 84 00 00 00    	je     801414 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801390:	89 c2                	mov    %eax,%edx
  801392:	c1 ea 0c             	shr    $0xc,%edx
  801395:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139c:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013a2:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013a8:	75 6a                	jne    801414 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013af:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	6a 07                	push   $0x7
  8013b6:	68 00 f0 7f 00       	push   $0x7ff000
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 78 fb ff ff       	call   800f3a <sys_page_alloc>
	if(ret < 0)
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 5f                	js     801428 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013c9:	83 ec 04             	sub    $0x4,%esp
  8013cc:	68 00 10 00 00       	push   $0x1000
  8013d1:	53                   	push   %ebx
  8013d2:	68 00 f0 7f 00       	push   $0x7ff000
  8013d7:	e8 5c f9 ff ff       	call   800d38 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013dc:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013e3:	53                   	push   %ebx
  8013e4:	6a 00                	push   $0x0
  8013e6:	68 00 f0 7f 00       	push   $0x7ff000
  8013eb:	6a 00                	push   $0x0
  8013ed:	e8 8b fb ff ff       	call   800f7d <sys_page_map>
	if(ret < 0)
  8013f2:	83 c4 20             	add    $0x20,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 43                	js     80143c <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	68 00 f0 7f 00       	push   $0x7ff000
  801401:	6a 00                	push   $0x0
  801403:	e8 b7 fb ff ff       	call   800fbf <sys_page_unmap>
	if(ret < 0)
  801408:	83 c4 10             	add    $0x10,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 41                	js     801450 <pgfault+0xeb>
}
  80140f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801412:	c9                   	leave  
  801413:	c3                   	ret    
		panic("panic at pgfault()\n");
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	68 d4 31 80 00       	push   $0x8031d4
  80141c:	6a 26                	push   $0x26
  80141e:	68 c9 31 80 00       	push   $0x8031c9
  801423:	e8 cb ee ff ff       	call   8002f3 <_panic>
		panic("panic in sys_page_alloc()\n");
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	68 e8 31 80 00       	push   $0x8031e8
  801430:	6a 31                	push   $0x31
  801432:	68 c9 31 80 00       	push   $0x8031c9
  801437:	e8 b7 ee ff ff       	call   8002f3 <_panic>
		panic("panic in sys_page_map()\n");
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	68 03 32 80 00       	push   $0x803203
  801444:	6a 36                	push   $0x36
  801446:	68 c9 31 80 00       	push   $0x8031c9
  80144b:	e8 a3 ee ff ff       	call   8002f3 <_panic>
		panic("panic in sys_page_unmap()\n");
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	68 1c 32 80 00       	push   $0x80321c
  801458:	6a 39                	push   $0x39
  80145a:	68 c9 31 80 00       	push   $0x8031c9
  80145f:	e8 8f ee ff ff       	call   8002f3 <_panic>

00801464 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80146d:	68 65 13 80 00       	push   $0x801365
  801472:	e8 d5 13 00 00       	call   80284c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801477:	b8 07 00 00 00       	mov    $0x7,%eax
  80147c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 27                	js     8014ac <fork+0x48>
  801485:	89 c6                	mov    %eax,%esi
  801487:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801489:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80148e:	75 48                	jne    8014d8 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801490:	e8 67 fa ff ff       	call   800efc <sys_getenvid>
  801495:	25 ff 03 00 00       	and    $0x3ff,%eax
  80149a:	c1 e0 07             	shl    $0x7,%eax
  80149d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014a2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014a7:	e9 90 00 00 00       	jmp    80153c <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	68 38 32 80 00       	push   $0x803238
  8014b4:	68 8c 00 00 00       	push   $0x8c
  8014b9:	68 c9 31 80 00       	push   $0x8031c9
  8014be:	e8 30 ee ff ff       	call   8002f3 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014c3:	89 f8                	mov    %edi,%eax
  8014c5:	e8 45 fd ff ff       	call   80120f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014d0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014d6:	74 26                	je     8014fe <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014d8:	89 d8                	mov    %ebx,%eax
  8014da:	c1 e8 16             	shr    $0x16,%eax
  8014dd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e4:	a8 01                	test   $0x1,%al
  8014e6:	74 e2                	je     8014ca <fork+0x66>
  8014e8:	89 da                	mov    %ebx,%edx
  8014ea:	c1 ea 0c             	shr    $0xc,%edx
  8014ed:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014f4:	83 e0 05             	and    $0x5,%eax
  8014f7:	83 f8 05             	cmp    $0x5,%eax
  8014fa:	75 ce                	jne    8014ca <fork+0x66>
  8014fc:	eb c5                	jmp    8014c3 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	6a 07                	push   $0x7
  801503:	68 00 f0 bf ee       	push   $0xeebff000
  801508:	56                   	push   %esi
  801509:	e8 2c fa ff ff       	call   800f3a <sys_page_alloc>
	if(ret < 0)
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	78 31                	js     801546 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	68 bb 28 80 00       	push   $0x8028bb
  80151d:	56                   	push   %esi
  80151e:	e8 62 fb ff ff       	call   801085 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 33                	js     80155d <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	6a 02                	push   $0x2
  80152f:	56                   	push   %esi
  801530:	e8 cc fa ff ff       	call   801001 <sys_env_set_status>
	if(ret < 0)
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 38                	js     801574 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80153c:	89 f0                	mov    %esi,%eax
  80153e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801541:	5b                   	pop    %ebx
  801542:	5e                   	pop    %esi
  801543:	5f                   	pop    %edi
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801546:	83 ec 04             	sub    $0x4,%esp
  801549:	68 e8 31 80 00       	push   $0x8031e8
  80154e:	68 98 00 00 00       	push   $0x98
  801553:	68 c9 31 80 00       	push   $0x8031c9
  801558:	e8 96 ed ff ff       	call   8002f3 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	68 5c 32 80 00       	push   $0x80325c
  801565:	68 9b 00 00 00       	push   $0x9b
  80156a:	68 c9 31 80 00       	push   $0x8031c9
  80156f:	e8 7f ed ff ff       	call   8002f3 <_panic>
		panic("panic in sys_env_set_status()\n");
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 84 32 80 00       	push   $0x803284
  80157c:	68 9e 00 00 00       	push   $0x9e
  801581:	68 c9 31 80 00       	push   $0x8031c9
  801586:	e8 68 ed ff ff       	call   8002f3 <_panic>

0080158b <sfork>:

// Challenge!
int
sfork(void)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	57                   	push   %edi
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801594:	68 65 13 80 00       	push   $0x801365
  801599:	e8 ae 12 00 00       	call   80284c <set_pgfault_handler>
  80159e:	b8 07 00 00 00       	mov    $0x7,%eax
  8015a3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 27                	js     8015d3 <sfork+0x48>
  8015ac:	89 c7                	mov    %eax,%edi
  8015ae:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015b0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015b5:	75 55                	jne    80160c <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015b7:	e8 40 f9 ff ff       	call   800efc <sys_getenvid>
  8015bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015c1:	c1 e0 07             	shl    $0x7,%eax
  8015c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015c9:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015ce:	e9 d4 00 00 00       	jmp    8016a7 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	68 38 32 80 00       	push   $0x803238
  8015db:	68 af 00 00 00       	push   $0xaf
  8015e0:	68 c9 31 80 00       	push   $0x8031c9
  8015e5:	e8 09 ed ff ff       	call   8002f3 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015ea:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015ef:	89 f0                	mov    %esi,%eax
  8015f1:	e8 19 fc ff ff       	call   80120f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015fc:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801602:	77 65                	ja     801669 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801604:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80160a:	74 de                	je     8015ea <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80160c:	89 d8                	mov    %ebx,%eax
  80160e:	c1 e8 16             	shr    $0x16,%eax
  801611:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801618:	a8 01                	test   $0x1,%al
  80161a:	74 da                	je     8015f6 <sfork+0x6b>
  80161c:	89 da                	mov    %ebx,%edx
  80161e:	c1 ea 0c             	shr    $0xc,%edx
  801621:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801628:	83 e0 05             	and    $0x5,%eax
  80162b:	83 f8 05             	cmp    $0x5,%eax
  80162e:	75 c6                	jne    8015f6 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801630:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801637:	c1 e2 0c             	shl    $0xc,%edx
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	83 e0 07             	and    $0x7,%eax
  801640:	50                   	push   %eax
  801641:	52                   	push   %edx
  801642:	56                   	push   %esi
  801643:	52                   	push   %edx
  801644:	6a 00                	push   $0x0
  801646:	e8 32 f9 ff ff       	call   800f7d <sys_page_map>
  80164b:	83 c4 20             	add    $0x20,%esp
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 a4                	je     8015f6 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	68 b3 31 80 00       	push   $0x8031b3
  80165a:	68 ba 00 00 00       	push   $0xba
  80165f:	68 c9 31 80 00       	push   $0x8031c9
  801664:	e8 8a ec ff ff       	call   8002f3 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	6a 07                	push   $0x7
  80166e:	68 00 f0 bf ee       	push   $0xeebff000
  801673:	57                   	push   %edi
  801674:	e8 c1 f8 ff ff       	call   800f3a <sys_page_alloc>
	if(ret < 0)
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 31                	js     8016b1 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801680:	83 ec 08             	sub    $0x8,%esp
  801683:	68 bb 28 80 00       	push   $0x8028bb
  801688:	57                   	push   %edi
  801689:	e8 f7 f9 ff ff       	call   801085 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 33                	js     8016c8 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	6a 02                	push   $0x2
  80169a:	57                   	push   %edi
  80169b:	e8 61 f9 ff ff       	call   801001 <sys_env_set_status>
	if(ret < 0)
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 38                	js     8016df <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016a7:	89 f8                	mov    %edi,%eax
  8016a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ac:	5b                   	pop    %ebx
  8016ad:	5e                   	pop    %esi
  8016ae:	5f                   	pop    %edi
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 e8 31 80 00       	push   $0x8031e8
  8016b9:	68 c0 00 00 00       	push   $0xc0
  8016be:	68 c9 31 80 00       	push   $0x8031c9
  8016c3:	e8 2b ec ff ff       	call   8002f3 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 5c 32 80 00       	push   $0x80325c
  8016d0:	68 c3 00 00 00       	push   $0xc3
  8016d5:	68 c9 31 80 00       	push   $0x8031c9
  8016da:	e8 14 ec ff ff       	call   8002f3 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	68 84 32 80 00       	push   $0x803284
  8016e7:	68 c6 00 00 00       	push   $0xc6
  8016ec:	68 c9 31 80 00       	push   $0x8031c9
  8016f1:	e8 fd eb ff ff       	call   8002f3 <_panic>

008016f6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	05 00 00 00 30       	add    $0x30000000,%eax
  801701:	c1 e8 0c             	shr    $0xc,%eax
}
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801711:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801716:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    

0080171d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801725:	89 c2                	mov    %eax,%edx
  801727:	c1 ea 16             	shr    $0x16,%edx
  80172a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801731:	f6 c2 01             	test   $0x1,%dl
  801734:	74 2d                	je     801763 <fd_alloc+0x46>
  801736:	89 c2                	mov    %eax,%edx
  801738:	c1 ea 0c             	shr    $0xc,%edx
  80173b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801742:	f6 c2 01             	test   $0x1,%dl
  801745:	74 1c                	je     801763 <fd_alloc+0x46>
  801747:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80174c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801751:	75 d2                	jne    801725 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80175c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801761:	eb 0a                	jmp    80176d <fd_alloc+0x50>
			*fd_store = fd;
  801763:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801766:	89 01                	mov    %eax,(%ecx)
			return 0;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176d:	5d                   	pop    %ebp
  80176e:	c3                   	ret    

0080176f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801775:	83 f8 1f             	cmp    $0x1f,%eax
  801778:	77 30                	ja     8017aa <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80177a:	c1 e0 0c             	shl    $0xc,%eax
  80177d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801782:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801788:	f6 c2 01             	test   $0x1,%dl
  80178b:	74 24                	je     8017b1 <fd_lookup+0x42>
  80178d:	89 c2                	mov    %eax,%edx
  80178f:	c1 ea 0c             	shr    $0xc,%edx
  801792:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801799:	f6 c2 01             	test   $0x1,%dl
  80179c:	74 1a                	je     8017b8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	89 02                	mov    %eax,(%edx)
	return 0;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    
		return -E_INVAL;
  8017aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017af:	eb f7                	jmp    8017a8 <fd_lookup+0x39>
		return -E_INVAL;
  8017b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b6:	eb f0                	jmp    8017a8 <fd_lookup+0x39>
  8017b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bd:	eb e9                	jmp    8017a8 <fd_lookup+0x39>

008017bf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017d2:	39 08                	cmp    %ecx,(%eax)
  8017d4:	74 38                	je     80180e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017d6:	83 c2 01             	add    $0x1,%edx
  8017d9:	8b 04 95 20 33 80 00 	mov    0x803320(,%edx,4),%eax
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	75 ee                	jne    8017d2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017e4:	a1 08 50 80 00       	mov    0x805008,%eax
  8017e9:	8b 40 48             	mov    0x48(%eax),%eax
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	51                   	push   %ecx
  8017f0:	50                   	push   %eax
  8017f1:	68 a4 32 80 00       	push   $0x8032a4
  8017f6:	e8 ee eb ff ff       	call   8003e9 <cprintf>
	*dev = 0;
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    
			*dev = devtab[i];
  80180e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801811:	89 01                	mov    %eax,(%ecx)
			return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb f2                	jmp    80180c <dev_lookup+0x4d>

0080181a <fd_close>:
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	57                   	push   %edi
  80181e:	56                   	push   %esi
  80181f:	53                   	push   %ebx
  801820:	83 ec 24             	sub    $0x24,%esp
  801823:	8b 75 08             	mov    0x8(%ebp),%esi
  801826:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801829:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80182c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80182d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801833:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801836:	50                   	push   %eax
  801837:	e8 33 ff ff ff       	call   80176f <fd_lookup>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 05                	js     80184a <fd_close+0x30>
	    || fd != fd2)
  801845:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801848:	74 16                	je     801860 <fd_close+0x46>
		return (must_exist ? r : 0);
  80184a:	89 f8                	mov    %edi,%eax
  80184c:	84 c0                	test   %al,%al
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	0f 44 d8             	cmove  %eax,%ebx
}
  801856:	89 d8                	mov    %ebx,%eax
  801858:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5f                   	pop    %edi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801866:	50                   	push   %eax
  801867:	ff 36                	pushl  (%esi)
  801869:	e8 51 ff ff ff       	call   8017bf <dev_lookup>
  80186e:	89 c3                	mov    %eax,%ebx
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	85 c0                	test   %eax,%eax
  801875:	78 1a                	js     801891 <fd_close+0x77>
		if (dev->dev_close)
  801877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80187d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801882:	85 c0                	test   %eax,%eax
  801884:	74 0b                	je     801891 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	56                   	push   %esi
  80188a:	ff d0                	call   *%eax
  80188c:	89 c3                	mov    %eax,%ebx
  80188e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	56                   	push   %esi
  801895:	6a 00                	push   $0x0
  801897:	e8 23 f7 ff ff       	call   800fbf <sys_page_unmap>
	return r;
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	eb b5                	jmp    801856 <fd_close+0x3c>

008018a1 <close>:

int
close(int fdnum)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018aa:	50                   	push   %eax
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	e8 bc fe ff ff       	call   80176f <fd_lookup>
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	79 02                	jns    8018bc <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    
		return fd_close(fd, 1);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	6a 01                	push   $0x1
  8018c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c4:	e8 51 ff ff ff       	call   80181a <fd_close>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	eb ec                	jmp    8018ba <close+0x19>

008018ce <close_all>:

void
close_all(void)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	53                   	push   %ebx
  8018d2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	53                   	push   %ebx
  8018de:	e8 be ff ff ff       	call   8018a1 <close>
	for (i = 0; i < MAXFD; i++)
  8018e3:	83 c3 01             	add    $0x1,%ebx
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	83 fb 20             	cmp    $0x20,%ebx
  8018ec:	75 ec                	jne    8018da <close_all+0xc>
}
  8018ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	57                   	push   %edi
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	e8 67 fe ff ff       	call   80176f <fd_lookup>
  801908:	89 c3                	mov    %eax,%ebx
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	0f 88 81 00 00 00    	js     801996 <dup+0xa3>
		return r;
	close(newfdnum);
  801915:	83 ec 0c             	sub    $0xc,%esp
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	e8 81 ff ff ff       	call   8018a1 <close>

	newfd = INDEX2FD(newfdnum);
  801920:	8b 75 0c             	mov    0xc(%ebp),%esi
  801923:	c1 e6 0c             	shl    $0xc,%esi
  801926:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80192c:	83 c4 04             	add    $0x4,%esp
  80192f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801932:	e8 cf fd ff ff       	call   801706 <fd2data>
  801937:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801939:	89 34 24             	mov    %esi,(%esp)
  80193c:	e8 c5 fd ff ff       	call   801706 <fd2data>
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801946:	89 d8                	mov    %ebx,%eax
  801948:	c1 e8 16             	shr    $0x16,%eax
  80194b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801952:	a8 01                	test   $0x1,%al
  801954:	74 11                	je     801967 <dup+0x74>
  801956:	89 d8                	mov    %ebx,%eax
  801958:	c1 e8 0c             	shr    $0xc,%eax
  80195b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801962:	f6 c2 01             	test   $0x1,%dl
  801965:	75 39                	jne    8019a0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801967:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80196a:	89 d0                	mov    %edx,%eax
  80196c:	c1 e8 0c             	shr    $0xc,%eax
  80196f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	25 07 0e 00 00       	and    $0xe07,%eax
  80197e:	50                   	push   %eax
  80197f:	56                   	push   %esi
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	6a 00                	push   $0x0
  801985:	e8 f3 f5 ff ff       	call   800f7d <sys_page_map>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 20             	add    $0x20,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 31                	js     8019c4 <dup+0xd1>
		goto err;

	return newfdnum;
  801993:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801996:	89 d8                	mov    %ebx,%eax
  801998:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5f                   	pop    %edi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	25 07 0e 00 00       	and    $0xe07,%eax
  8019af:	50                   	push   %eax
  8019b0:	57                   	push   %edi
  8019b1:	6a 00                	push   $0x0
  8019b3:	53                   	push   %ebx
  8019b4:	6a 00                	push   $0x0
  8019b6:	e8 c2 f5 ff ff       	call   800f7d <sys_page_map>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	83 c4 20             	add    $0x20,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	79 a3                	jns    801967 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	56                   	push   %esi
  8019c8:	6a 00                	push   $0x0
  8019ca:	e8 f0 f5 ff ff       	call   800fbf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019cf:	83 c4 08             	add    $0x8,%esp
  8019d2:	57                   	push   %edi
  8019d3:	6a 00                	push   $0x0
  8019d5:	e8 e5 f5 ff ff       	call   800fbf <sys_page_unmap>
	return r;
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	eb b7                	jmp    801996 <dup+0xa3>

008019df <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	53                   	push   %ebx
  8019e3:	83 ec 1c             	sub    $0x1c,%esp
  8019e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ec:	50                   	push   %eax
  8019ed:	53                   	push   %ebx
  8019ee:	e8 7c fd ff ff       	call   80176f <fd_lookup>
  8019f3:	83 c4 10             	add    $0x10,%esp
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 3f                	js     801a39 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a00:	50                   	push   %eax
  801a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a04:	ff 30                	pushl  (%eax)
  801a06:	e8 b4 fd ff ff       	call   8017bf <dev_lookup>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 27                	js     801a39 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a15:	8b 42 08             	mov    0x8(%edx),%eax
  801a18:	83 e0 03             	and    $0x3,%eax
  801a1b:	83 f8 01             	cmp    $0x1,%eax
  801a1e:	74 1e                	je     801a3e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a23:	8b 40 08             	mov    0x8(%eax),%eax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	74 35                	je     801a5f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	52                   	push   %edx
  801a34:	ff d0                	call   *%eax
  801a36:	83 c4 10             	add    $0x10,%esp
}
  801a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a3e:	a1 08 50 80 00       	mov    0x805008,%eax
  801a43:	8b 40 48             	mov    0x48(%eax),%eax
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	53                   	push   %ebx
  801a4a:	50                   	push   %eax
  801a4b:	68 e5 32 80 00       	push   $0x8032e5
  801a50:	e8 94 e9 ff ff       	call   8003e9 <cprintf>
		return -E_INVAL;
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5d:	eb da                	jmp    801a39 <read+0x5a>
		return -E_NOT_SUPP;
  801a5f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a64:	eb d3                	jmp    801a39 <read+0x5a>

00801a66 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 0c             	sub    $0xc,%esp
  801a6f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a72:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7a:	39 f3                	cmp    %esi,%ebx
  801a7c:	73 23                	jae    801aa1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	89 f0                	mov    %esi,%eax
  801a83:	29 d8                	sub    %ebx,%eax
  801a85:	50                   	push   %eax
  801a86:	89 d8                	mov    %ebx,%eax
  801a88:	03 45 0c             	add    0xc(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	57                   	push   %edi
  801a8d:	e8 4d ff ff ff       	call   8019df <read>
		if (m < 0)
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 06                	js     801a9f <readn+0x39>
			return m;
		if (m == 0)
  801a99:	74 06                	je     801aa1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a9b:	01 c3                	add    %eax,%ebx
  801a9d:	eb db                	jmp    801a7a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a9f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aa1:	89 d8                	mov    %ebx,%eax
  801aa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5f                   	pop    %edi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    

00801aab <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	53                   	push   %ebx
  801aaf:	83 ec 1c             	sub    $0x1c,%esp
  801ab2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab8:	50                   	push   %eax
  801ab9:	53                   	push   %ebx
  801aba:	e8 b0 fc ff ff       	call   80176f <fd_lookup>
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 3a                	js     801b00 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acc:	50                   	push   %eax
  801acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad0:	ff 30                	pushl  (%eax)
  801ad2:	e8 e8 fc ff ff       	call   8017bf <dev_lookup>
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 22                	js     801b00 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ae5:	74 1e                	je     801b05 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aea:	8b 52 0c             	mov    0xc(%edx),%edx
  801aed:	85 d2                	test   %edx,%edx
  801aef:	74 35                	je     801b26 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	ff 75 10             	pushl  0x10(%ebp)
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	50                   	push   %eax
  801afb:	ff d2                	call   *%edx
  801afd:	83 c4 10             	add    $0x10,%esp
}
  801b00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b05:	a1 08 50 80 00       	mov    0x805008,%eax
  801b0a:	8b 40 48             	mov    0x48(%eax),%eax
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	53                   	push   %ebx
  801b11:	50                   	push   %eax
  801b12:	68 01 33 80 00       	push   $0x803301
  801b17:	e8 cd e8 ff ff       	call   8003e9 <cprintf>
		return -E_INVAL;
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b24:	eb da                	jmp    801b00 <write+0x55>
		return -E_NOT_SUPP;
  801b26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b2b:	eb d3                	jmp    801b00 <write+0x55>

00801b2d <seek>:

int
seek(int fdnum, off_t offset)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b36:	50                   	push   %eax
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 30 fc ff ff       	call   80176f <fd_lookup>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	85 c0                	test   %eax,%eax
  801b44:	78 0e                	js     801b54 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 1c             	sub    $0x1c,%esp
  801b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b63:	50                   	push   %eax
  801b64:	53                   	push   %ebx
  801b65:	e8 05 fc ff ff       	call   80176f <fd_lookup>
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 37                	js     801ba8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b71:	83 ec 08             	sub    $0x8,%esp
  801b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b77:	50                   	push   %eax
  801b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7b:	ff 30                	pushl  (%eax)
  801b7d:	e8 3d fc ff ff       	call   8017bf <dev_lookup>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 1f                	js     801ba8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b90:	74 1b                	je     801bad <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b95:	8b 52 18             	mov    0x18(%edx),%edx
  801b98:	85 d2                	test   %edx,%edx
  801b9a:	74 32                	je     801bce <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	ff d2                	call   *%edx
  801ba5:	83 c4 10             	add    $0x10,%esp
}
  801ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bad:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bb2:	8b 40 48             	mov    0x48(%eax),%eax
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	53                   	push   %ebx
  801bb9:	50                   	push   %eax
  801bba:	68 c4 32 80 00       	push   $0x8032c4
  801bbf:	e8 25 e8 ff ff       	call   8003e9 <cprintf>
		return -E_INVAL;
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bcc:	eb da                	jmp    801ba8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd3:	eb d3                	jmp    801ba8 <ftruncate+0x52>

00801bd5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	53                   	push   %ebx
  801bd9:	83 ec 1c             	sub    $0x1c,%esp
  801bdc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be2:	50                   	push   %eax
  801be3:	ff 75 08             	pushl  0x8(%ebp)
  801be6:	e8 84 fb ff ff       	call   80176f <fd_lookup>
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 4b                	js     801c3d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bf2:	83 ec 08             	sub    $0x8,%esp
  801bf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf8:	50                   	push   %eax
  801bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfc:	ff 30                	pushl  (%eax)
  801bfe:	e8 bc fb ff ff       	call   8017bf <dev_lookup>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 33                	js     801c3d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c11:	74 2f                	je     801c42 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c13:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c16:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c1d:	00 00 00 
	stat->st_isdir = 0;
  801c20:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c27:	00 00 00 
	stat->st_dev = dev;
  801c2a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c30:	83 ec 08             	sub    $0x8,%esp
  801c33:	53                   	push   %ebx
  801c34:	ff 75 f0             	pushl  -0x10(%ebp)
  801c37:	ff 50 14             	call   *0x14(%eax)
  801c3a:	83 c4 10             	add    $0x10,%esp
}
  801c3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    
		return -E_NOT_SUPP;
  801c42:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c47:	eb f4                	jmp    801c3d <fstat+0x68>

00801c49 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	56                   	push   %esi
  801c4d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	6a 00                	push   $0x0
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	e8 22 02 00 00       	call   801e7d <open>
  801c5b:	89 c3                	mov    %eax,%ebx
  801c5d:	83 c4 10             	add    $0x10,%esp
  801c60:	85 c0                	test   %eax,%eax
  801c62:	78 1b                	js     801c7f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c64:	83 ec 08             	sub    $0x8,%esp
  801c67:	ff 75 0c             	pushl  0xc(%ebp)
  801c6a:	50                   	push   %eax
  801c6b:	e8 65 ff ff ff       	call   801bd5 <fstat>
  801c70:	89 c6                	mov    %eax,%esi
	close(fd);
  801c72:	89 1c 24             	mov    %ebx,(%esp)
  801c75:	e8 27 fc ff ff       	call   8018a1 <close>
	return r;
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	89 f3                	mov    %esi,%ebx
}
  801c7f:	89 d8                	mov    %ebx,%eax
  801c81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5e                   	pop    %esi
  801c86:	5d                   	pop    %ebp
  801c87:	c3                   	ret    

00801c88 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	56                   	push   %esi
  801c8c:	53                   	push   %ebx
  801c8d:	89 c6                	mov    %eax,%esi
  801c8f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c91:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c98:	74 27                	je     801cc1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c9a:	6a 07                	push   $0x7
  801c9c:	68 00 60 80 00       	push   $0x806000
  801ca1:	56                   	push   %esi
  801ca2:	ff 35 00 50 80 00    	pushl  0x805000
  801ca8:	e8 9d 0c 00 00       	call   80294a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cad:	83 c4 0c             	add    $0xc,%esp
  801cb0:	6a 00                	push   $0x0
  801cb2:	53                   	push   %ebx
  801cb3:	6a 00                	push   $0x0
  801cb5:	e8 27 0c 00 00       	call   8028e1 <ipc_recv>
}
  801cba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbd:	5b                   	pop    %ebx
  801cbe:	5e                   	pop    %esi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	6a 01                	push   $0x1
  801cc6:	e8 d7 0c 00 00       	call   8029a2 <ipc_find_env>
  801ccb:	a3 00 50 80 00       	mov    %eax,0x805000
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	eb c5                	jmp    801c9a <fsipc+0x12>

00801cd5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cee:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf3:	b8 02 00 00 00       	mov    $0x2,%eax
  801cf8:	e8 8b ff ff ff       	call   801c88 <fsipc>
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <devfile_flush>:
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0b:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d10:	ba 00 00 00 00       	mov    $0x0,%edx
  801d15:	b8 06 00 00 00       	mov    $0x6,%eax
  801d1a:	e8 69 ff ff ff       	call   801c88 <fsipc>
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <devfile_stat>:
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	53                   	push   %ebx
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d31:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d36:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3b:	b8 05 00 00 00       	mov    $0x5,%eax
  801d40:	e8 43 ff ff ff       	call   801c88 <fsipc>
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 2c                	js     801d75 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d49:	83 ec 08             	sub    $0x8,%esp
  801d4c:	68 00 60 80 00       	push   $0x806000
  801d51:	53                   	push   %ebx
  801d52:	e8 f1 ed ff ff       	call   800b48 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d57:	a1 80 60 80 00       	mov    0x806080,%eax
  801d5c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d62:	a1 84 60 80 00       	mov    0x806084,%eax
  801d67:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <devfile_write>:
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	53                   	push   %ebx
  801d7e:	83 ec 08             	sub    $0x8,%esp
  801d81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d8f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d95:	53                   	push   %ebx
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	68 08 60 80 00       	push   $0x806008
  801d9e:	e8 95 ef ff ff       	call   800d38 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	b8 04 00 00 00       	mov    $0x4,%eax
  801dad:	e8 d6 fe ff ff       	call   801c88 <fsipc>
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	85 c0                	test   %eax,%eax
  801db7:	78 0b                	js     801dc4 <devfile_write+0x4a>
	assert(r <= n);
  801db9:	39 d8                	cmp    %ebx,%eax
  801dbb:	77 0c                	ja     801dc9 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801dbd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dc2:	7f 1e                	jg     801de2 <devfile_write+0x68>
}
  801dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    
	assert(r <= n);
  801dc9:	68 34 33 80 00       	push   $0x803334
  801dce:	68 3b 33 80 00       	push   $0x80333b
  801dd3:	68 98 00 00 00       	push   $0x98
  801dd8:	68 50 33 80 00       	push   $0x803350
  801ddd:	e8 11 e5 ff ff       	call   8002f3 <_panic>
	assert(r <= PGSIZE);
  801de2:	68 5b 33 80 00       	push   $0x80335b
  801de7:	68 3b 33 80 00       	push   $0x80333b
  801dec:	68 99 00 00 00       	push   $0x99
  801df1:	68 50 33 80 00       	push   $0x803350
  801df6:	e8 f8 e4 ff ff       	call   8002f3 <_panic>

00801dfb <devfile_read>:
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	8b 40 0c             	mov    0xc(%eax),%eax
  801e09:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e0e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e14:	ba 00 00 00 00       	mov    $0x0,%edx
  801e19:	b8 03 00 00 00       	mov    $0x3,%eax
  801e1e:	e8 65 fe ff ff       	call   801c88 <fsipc>
  801e23:	89 c3                	mov    %eax,%ebx
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 1f                	js     801e48 <devfile_read+0x4d>
	assert(r <= n);
  801e29:	39 f0                	cmp    %esi,%eax
  801e2b:	77 24                	ja     801e51 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e2d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e32:	7f 33                	jg     801e67 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e34:	83 ec 04             	sub    $0x4,%esp
  801e37:	50                   	push   %eax
  801e38:	68 00 60 80 00       	push   $0x806000
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	e8 91 ee ff ff       	call   800cd6 <memmove>
	return r;
  801e45:	83 c4 10             	add    $0x10,%esp
}
  801e48:	89 d8                	mov    %ebx,%eax
  801e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    
	assert(r <= n);
  801e51:	68 34 33 80 00       	push   $0x803334
  801e56:	68 3b 33 80 00       	push   $0x80333b
  801e5b:	6a 7c                	push   $0x7c
  801e5d:	68 50 33 80 00       	push   $0x803350
  801e62:	e8 8c e4 ff ff       	call   8002f3 <_panic>
	assert(r <= PGSIZE);
  801e67:	68 5b 33 80 00       	push   $0x80335b
  801e6c:	68 3b 33 80 00       	push   $0x80333b
  801e71:	6a 7d                	push   $0x7d
  801e73:	68 50 33 80 00       	push   $0x803350
  801e78:	e8 76 e4 ff ff       	call   8002f3 <_panic>

00801e7d <open>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	56                   	push   %esi
  801e81:	53                   	push   %ebx
  801e82:	83 ec 1c             	sub    $0x1c,%esp
  801e85:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e88:	56                   	push   %esi
  801e89:	e8 81 ec ff ff       	call   800b0f <strlen>
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e96:	7f 6c                	jg     801f04 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9e:	50                   	push   %eax
  801e9f:	e8 79 f8 ff ff       	call   80171d <fd_alloc>
  801ea4:	89 c3                	mov    %eax,%ebx
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 3c                	js     801ee9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	56                   	push   %esi
  801eb1:	68 00 60 80 00       	push   $0x806000
  801eb6:	e8 8d ec ff ff       	call   800b48 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebe:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	e8 b8 fd ff ff       	call   801c88 <fsipc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	78 19                	js     801ef2 <open+0x75>
	return fd2num(fd);
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	ff 75 f4             	pushl  -0xc(%ebp)
  801edf:	e8 12 f8 ff ff       	call   8016f6 <fd2num>
  801ee4:	89 c3                	mov    %eax,%ebx
  801ee6:	83 c4 10             	add    $0x10,%esp
}
  801ee9:	89 d8                	mov    %ebx,%eax
  801eeb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    
		fd_close(fd, 0);
  801ef2:	83 ec 08             	sub    $0x8,%esp
  801ef5:	6a 00                	push   $0x0
  801ef7:	ff 75 f4             	pushl  -0xc(%ebp)
  801efa:	e8 1b f9 ff ff       	call   80181a <fd_close>
		return r;
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	eb e5                	jmp    801ee9 <open+0x6c>
		return -E_BAD_PATH;
  801f04:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f09:	eb de                	jmp    801ee9 <open+0x6c>

00801f0b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f11:	ba 00 00 00 00       	mov    $0x0,%edx
  801f16:	b8 08 00 00 00       	mov    $0x8,%eax
  801f1b:	e8 68 fd ff ff       	call   801c88 <fsipc>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f28:	68 67 33 80 00       	push   $0x803367
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	e8 13 ec ff ff       	call   800b48 <strcpy>
	return 0;
}
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <devsock_close>:
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	53                   	push   %ebx
  801f40:	83 ec 10             	sub    $0x10,%esp
  801f43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f46:	53                   	push   %ebx
  801f47:	e8 91 0a 00 00       	call   8029dd <pageref>
  801f4c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f4f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f54:	83 f8 01             	cmp    $0x1,%eax
  801f57:	74 07                	je     801f60 <devsock_close+0x24>
}
  801f59:	89 d0                	mov    %edx,%eax
  801f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	ff 73 0c             	pushl  0xc(%ebx)
  801f66:	e8 b9 02 00 00       	call   802224 <nsipc_close>
  801f6b:	89 c2                	mov    %eax,%edx
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	eb e7                	jmp    801f59 <devsock_close+0x1d>

00801f72 <devsock_write>:
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	ff 75 10             	pushl  0x10(%ebp)
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	ff 70 0c             	pushl  0xc(%eax)
  801f86:	e8 76 03 00 00       	call   802301 <nsipc_send>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <devsock_read>:
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	ff 75 10             	pushl  0x10(%ebp)
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	ff 70 0c             	pushl  0xc(%eax)
  801fa1:	e8 ef 02 00 00       	call   802295 <nsipc_recv>
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <fd2sockid>:
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fae:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fb1:	52                   	push   %edx
  801fb2:	50                   	push   %eax
  801fb3:	e8 b7 f7 ff ff       	call   80176f <fd_lookup>
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 10                	js     801fcf <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fc8:	39 08                	cmp    %ecx,(%eax)
  801fca:	75 05                	jne    801fd1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fcc:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    
		return -E_NOT_SUPP;
  801fd1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fd6:	eb f7                	jmp    801fcf <fd2sockid+0x27>

00801fd8 <alloc_sockfd>:
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	56                   	push   %esi
  801fdc:	53                   	push   %ebx
  801fdd:	83 ec 1c             	sub    $0x1c,%esp
  801fe0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fe2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe5:	50                   	push   %eax
  801fe6:	e8 32 f7 ff ff       	call   80171d <fd_alloc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 43                	js     802037 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 07 04 00 00       	push   $0x407
  801ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fff:	6a 00                	push   $0x0
  802001:	e8 34 ef ff ff       	call   800f3a <sys_page_alloc>
  802006:	89 c3                	mov    %eax,%ebx
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	85 c0                	test   %eax,%eax
  80200d:	78 28                	js     802037 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802018:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802024:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	50                   	push   %eax
  80202b:	e8 c6 f6 ff ff       	call   8016f6 <fd2num>
  802030:	89 c3                	mov    %eax,%ebx
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	eb 0c                	jmp    802043 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802037:	83 ec 0c             	sub    $0xc,%esp
  80203a:	56                   	push   %esi
  80203b:	e8 e4 01 00 00       	call   802224 <nsipc_close>
		return r;
  802040:	83 c4 10             	add    $0x10,%esp
}
  802043:	89 d8                	mov    %ebx,%eax
  802045:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802048:	5b                   	pop    %ebx
  802049:	5e                   	pop    %esi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    

0080204c <accept>:
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	e8 4e ff ff ff       	call   801fa8 <fd2sockid>
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 1b                	js     802079 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	ff 75 10             	pushl  0x10(%ebp)
  802064:	ff 75 0c             	pushl  0xc(%ebp)
  802067:	50                   	push   %eax
  802068:	e8 0e 01 00 00       	call   80217b <nsipc_accept>
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	85 c0                	test   %eax,%eax
  802072:	78 05                	js     802079 <accept+0x2d>
	return alloc_sockfd(r);
  802074:	e8 5f ff ff ff       	call   801fd8 <alloc_sockfd>
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <bind>:
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	e8 1f ff ff ff       	call   801fa8 <fd2sockid>
  802089:	85 c0                	test   %eax,%eax
  80208b:	78 12                	js     80209f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	ff 75 10             	pushl  0x10(%ebp)
  802093:	ff 75 0c             	pushl  0xc(%ebp)
  802096:	50                   	push   %eax
  802097:	e8 31 01 00 00       	call   8021cd <nsipc_bind>
  80209c:	83 c4 10             	add    $0x10,%esp
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <shutdown>:
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	e8 f9 fe ff ff       	call   801fa8 <fd2sockid>
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 0f                	js     8020c2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	ff 75 0c             	pushl  0xc(%ebp)
  8020b9:	50                   	push   %eax
  8020ba:	e8 43 01 00 00       	call   802202 <nsipc_shutdown>
  8020bf:	83 c4 10             	add    $0x10,%esp
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <connect>:
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	e8 d6 fe ff ff       	call   801fa8 <fd2sockid>
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	78 12                	js     8020e8 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	ff 75 10             	pushl  0x10(%ebp)
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	50                   	push   %eax
  8020e0:	e8 59 01 00 00       	call   80223e <nsipc_connect>
  8020e5:	83 c4 10             	add    $0x10,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <listen>:
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	e8 b0 fe ff ff       	call   801fa8 <fd2sockid>
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	78 0f                	js     80210b <listen+0x21>
	return nsipc_listen(r, backlog);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	50                   	push   %eax
  802103:	e8 6b 01 00 00       	call   802273 <nsipc_listen>
  802108:	83 c4 10             	add    $0x10,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <socket>:

int
socket(int domain, int type, int protocol)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	ff 75 08             	pushl  0x8(%ebp)
  80211c:	e8 3e 02 00 00       	call   80235f <nsipc_socket>
  802121:	83 c4 10             	add    $0x10,%esp
  802124:	85 c0                	test   %eax,%eax
  802126:	78 05                	js     80212d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802128:	e8 ab fe ff ff       	call   801fd8 <alloc_sockfd>
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	53                   	push   %ebx
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802138:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80213f:	74 26                	je     802167 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802141:	6a 07                	push   $0x7
  802143:	68 00 70 80 00       	push   $0x807000
  802148:	53                   	push   %ebx
  802149:	ff 35 04 50 80 00    	pushl  0x805004
  80214f:	e8 f6 07 00 00       	call   80294a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802154:	83 c4 0c             	add    $0xc,%esp
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	e8 7f 07 00 00       	call   8028e1 <ipc_recv>
}
  802162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802165:	c9                   	leave  
  802166:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	6a 02                	push   $0x2
  80216c:	e8 31 08 00 00       	call   8029a2 <ipc_find_env>
  802171:	a3 04 50 80 00       	mov    %eax,0x805004
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	eb c6                	jmp    802141 <nsipc+0x12>

0080217b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	56                   	push   %esi
  80217f:	53                   	push   %ebx
  802180:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80218b:	8b 06                	mov    (%esi),%eax
  80218d:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802192:	b8 01 00 00 00       	mov    $0x1,%eax
  802197:	e8 93 ff ff ff       	call   80212f <nsipc>
  80219c:	89 c3                	mov    %eax,%ebx
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	79 09                	jns    8021ab <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021a2:	89 d8                	mov    %ebx,%eax
  8021a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5d                   	pop    %ebp
  8021aa:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021ab:	83 ec 04             	sub    $0x4,%esp
  8021ae:	ff 35 10 70 80 00    	pushl  0x807010
  8021b4:	68 00 70 80 00       	push   $0x807000
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	e8 15 eb ff ff       	call   800cd6 <memmove>
		*addrlen = ret->ret_addrlen;
  8021c1:	a1 10 70 80 00       	mov    0x807010,%eax
  8021c6:	89 06                	mov    %eax,(%esi)
  8021c8:	83 c4 10             	add    $0x10,%esp
	return r;
  8021cb:	eb d5                	jmp    8021a2 <nsipc_accept+0x27>

008021cd <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	53                   	push   %ebx
  8021d1:	83 ec 08             	sub    $0x8,%esp
  8021d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021df:	53                   	push   %ebx
  8021e0:	ff 75 0c             	pushl  0xc(%ebp)
  8021e3:	68 04 70 80 00       	push   $0x807004
  8021e8:	e8 e9 ea ff ff       	call   800cd6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021ed:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021f3:	b8 02 00 00 00       	mov    $0x2,%eax
  8021f8:	e8 32 ff ff ff       	call   80212f <nsipc>
}
  8021fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802218:	b8 03 00 00 00       	mov    $0x3,%eax
  80221d:	e8 0d ff ff ff       	call   80212f <nsipc>
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <nsipc_close>:

int
nsipc_close(int s)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802232:	b8 04 00 00 00       	mov    $0x4,%eax
  802237:	e8 f3 fe ff ff       	call   80212f <nsipc>
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	53                   	push   %ebx
  802242:	83 ec 08             	sub    $0x8,%esp
  802245:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802250:	53                   	push   %ebx
  802251:	ff 75 0c             	pushl  0xc(%ebp)
  802254:	68 04 70 80 00       	push   $0x807004
  802259:	e8 78 ea ff ff       	call   800cd6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80225e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802264:	b8 05 00 00 00       	mov    $0x5,%eax
  802269:	e8 c1 fe ff ff       	call   80212f <nsipc>
}
  80226e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802281:	8b 45 0c             	mov    0xc(%ebp),%eax
  802284:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802289:	b8 06 00 00 00       	mov    $0x6,%eax
  80228e:	e8 9c fe ff ff       	call   80212f <nsipc>
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	56                   	push   %esi
  802299:	53                   	push   %ebx
  80229a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022a5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ae:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8022b8:	e8 72 fe ff ff       	call   80212f <nsipc>
  8022bd:	89 c3                	mov    %eax,%ebx
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	78 1f                	js     8022e2 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022c3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022c8:	7f 21                	jg     8022eb <nsipc_recv+0x56>
  8022ca:	39 c6                	cmp    %eax,%esi
  8022cc:	7c 1d                	jl     8022eb <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	50                   	push   %eax
  8022d2:	68 00 70 80 00       	push   $0x807000
  8022d7:	ff 75 0c             	pushl  0xc(%ebp)
  8022da:	e8 f7 e9 ff ff       	call   800cd6 <memmove>
  8022df:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022e2:	89 d8                	mov    %ebx,%eax
  8022e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e7:	5b                   	pop    %ebx
  8022e8:	5e                   	pop    %esi
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022eb:	68 73 33 80 00       	push   $0x803373
  8022f0:	68 3b 33 80 00       	push   $0x80333b
  8022f5:	6a 62                	push   $0x62
  8022f7:	68 88 33 80 00       	push   $0x803388
  8022fc:	e8 f2 df ff ff       	call   8002f3 <_panic>

00802301 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	53                   	push   %ebx
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802313:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802319:	7f 2e                	jg     802349 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80231b:	83 ec 04             	sub    $0x4,%esp
  80231e:	53                   	push   %ebx
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	68 0c 70 80 00       	push   $0x80700c
  802327:	e8 aa e9 ff ff       	call   800cd6 <memmove>
	nsipcbuf.send.req_size = size;
  80232c:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802332:	8b 45 14             	mov    0x14(%ebp),%eax
  802335:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80233a:	b8 08 00 00 00       	mov    $0x8,%eax
  80233f:	e8 eb fd ff ff       	call   80212f <nsipc>
}
  802344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802347:	c9                   	leave  
  802348:	c3                   	ret    
	assert(size < 1600);
  802349:	68 94 33 80 00       	push   $0x803394
  80234e:	68 3b 33 80 00       	push   $0x80333b
  802353:	6a 6d                	push   $0x6d
  802355:	68 88 33 80 00       	push   $0x803388
  80235a:	e8 94 df ff ff       	call   8002f3 <_panic>

0080235f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802375:	8b 45 10             	mov    0x10(%ebp),%eax
  802378:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80237d:	b8 09 00 00 00       	mov    $0x9,%eax
  802382:	e8 a8 fd ff ff       	call   80212f <nsipc>
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	56                   	push   %esi
  80238d:	53                   	push   %ebx
  80238e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	ff 75 08             	pushl  0x8(%ebp)
  802397:	e8 6a f3 ff ff       	call   801706 <fd2data>
  80239c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80239e:	83 c4 08             	add    $0x8,%esp
  8023a1:	68 a0 33 80 00       	push   $0x8033a0
  8023a6:	53                   	push   %ebx
  8023a7:	e8 9c e7 ff ff       	call   800b48 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023ac:	8b 46 04             	mov    0x4(%esi),%eax
  8023af:	2b 06                	sub    (%esi),%eax
  8023b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023b7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023be:	00 00 00 
	stat->st_dev = &devpipe;
  8023c1:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023c8:	40 80 00 
	return 0;
}
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5d                   	pop    %ebp
  8023d6:	c3                   	ret    

008023d7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	53                   	push   %ebx
  8023db:	83 ec 0c             	sub    $0xc,%esp
  8023de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023e1:	53                   	push   %ebx
  8023e2:	6a 00                	push   $0x0
  8023e4:	e8 d6 eb ff ff       	call   800fbf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023e9:	89 1c 24             	mov    %ebx,(%esp)
  8023ec:	e8 15 f3 ff ff       	call   801706 <fd2data>
  8023f1:	83 c4 08             	add    $0x8,%esp
  8023f4:	50                   	push   %eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	e8 c3 eb ff ff       	call   800fbf <sys_page_unmap>
}
  8023fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <_pipeisclosed>:
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	57                   	push   %edi
  802405:	56                   	push   %esi
  802406:	53                   	push   %ebx
  802407:	83 ec 1c             	sub    $0x1c,%esp
  80240a:	89 c7                	mov    %eax,%edi
  80240c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80240e:	a1 08 50 80 00       	mov    0x805008,%eax
  802413:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802416:	83 ec 0c             	sub    $0xc,%esp
  802419:	57                   	push   %edi
  80241a:	e8 be 05 00 00       	call   8029dd <pageref>
  80241f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802422:	89 34 24             	mov    %esi,(%esp)
  802425:	e8 b3 05 00 00       	call   8029dd <pageref>
		nn = thisenv->env_runs;
  80242a:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802430:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802433:	83 c4 10             	add    $0x10,%esp
  802436:	39 cb                	cmp    %ecx,%ebx
  802438:	74 1b                	je     802455 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80243a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80243d:	75 cf                	jne    80240e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80243f:	8b 42 58             	mov    0x58(%edx),%eax
  802442:	6a 01                	push   $0x1
  802444:	50                   	push   %eax
  802445:	53                   	push   %ebx
  802446:	68 a7 33 80 00       	push   $0x8033a7
  80244b:	e8 99 df ff ff       	call   8003e9 <cprintf>
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	eb b9                	jmp    80240e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802455:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802458:	0f 94 c0             	sete   %al
  80245b:	0f b6 c0             	movzbl %al,%eax
}
  80245e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <devpipe_write>:
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	57                   	push   %edi
  80246a:	56                   	push   %esi
  80246b:	53                   	push   %ebx
  80246c:	83 ec 28             	sub    $0x28,%esp
  80246f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802472:	56                   	push   %esi
  802473:	e8 8e f2 ff ff       	call   801706 <fd2data>
  802478:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	bf 00 00 00 00       	mov    $0x0,%edi
  802482:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802485:	74 4f                	je     8024d6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802487:	8b 43 04             	mov    0x4(%ebx),%eax
  80248a:	8b 0b                	mov    (%ebx),%ecx
  80248c:	8d 51 20             	lea    0x20(%ecx),%edx
  80248f:	39 d0                	cmp    %edx,%eax
  802491:	72 14                	jb     8024a7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802493:	89 da                	mov    %ebx,%edx
  802495:	89 f0                	mov    %esi,%eax
  802497:	e8 65 ff ff ff       	call   802401 <_pipeisclosed>
  80249c:	85 c0                	test   %eax,%eax
  80249e:	75 3b                	jne    8024db <devpipe_write+0x75>
			sys_yield();
  8024a0:	e8 76 ea ff ff       	call   800f1b <sys_yield>
  8024a5:	eb e0                	jmp    802487 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024b1:	89 c2                	mov    %eax,%edx
  8024b3:	c1 fa 1f             	sar    $0x1f,%edx
  8024b6:	89 d1                	mov    %edx,%ecx
  8024b8:	c1 e9 1b             	shr    $0x1b,%ecx
  8024bb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024be:	83 e2 1f             	and    $0x1f,%edx
  8024c1:	29 ca                	sub    %ecx,%edx
  8024c3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024cb:	83 c0 01             	add    $0x1,%eax
  8024ce:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024d1:	83 c7 01             	add    $0x1,%edi
  8024d4:	eb ac                	jmp    802482 <devpipe_write+0x1c>
	return i;
  8024d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d9:	eb 05                	jmp    8024e0 <devpipe_write+0x7a>
				return 0;
  8024db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e3:	5b                   	pop    %ebx
  8024e4:	5e                   	pop    %esi
  8024e5:	5f                   	pop    %edi
  8024e6:	5d                   	pop    %ebp
  8024e7:	c3                   	ret    

008024e8 <devpipe_read>:
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	57                   	push   %edi
  8024ec:	56                   	push   %esi
  8024ed:	53                   	push   %ebx
  8024ee:	83 ec 18             	sub    $0x18,%esp
  8024f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024f4:	57                   	push   %edi
  8024f5:	e8 0c f2 ff ff       	call   801706 <fd2data>
  8024fa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	be 00 00 00 00       	mov    $0x0,%esi
  802504:	3b 75 10             	cmp    0x10(%ebp),%esi
  802507:	75 14                	jne    80251d <devpipe_read+0x35>
	return i;
  802509:	8b 45 10             	mov    0x10(%ebp),%eax
  80250c:	eb 02                	jmp    802510 <devpipe_read+0x28>
				return i;
  80250e:	89 f0                	mov    %esi,%eax
}
  802510:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802513:	5b                   	pop    %ebx
  802514:	5e                   	pop    %esi
  802515:	5f                   	pop    %edi
  802516:	5d                   	pop    %ebp
  802517:	c3                   	ret    
			sys_yield();
  802518:	e8 fe e9 ff ff       	call   800f1b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80251d:	8b 03                	mov    (%ebx),%eax
  80251f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802522:	75 18                	jne    80253c <devpipe_read+0x54>
			if (i > 0)
  802524:	85 f6                	test   %esi,%esi
  802526:	75 e6                	jne    80250e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802528:	89 da                	mov    %ebx,%edx
  80252a:	89 f8                	mov    %edi,%eax
  80252c:	e8 d0 fe ff ff       	call   802401 <_pipeisclosed>
  802531:	85 c0                	test   %eax,%eax
  802533:	74 e3                	je     802518 <devpipe_read+0x30>
				return 0;
  802535:	b8 00 00 00 00       	mov    $0x0,%eax
  80253a:	eb d4                	jmp    802510 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80253c:	99                   	cltd   
  80253d:	c1 ea 1b             	shr    $0x1b,%edx
  802540:	01 d0                	add    %edx,%eax
  802542:	83 e0 1f             	and    $0x1f,%eax
  802545:	29 d0                	sub    %edx,%eax
  802547:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80254c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80254f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802552:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802555:	83 c6 01             	add    $0x1,%esi
  802558:	eb aa                	jmp    802504 <devpipe_read+0x1c>

0080255a <pipe>:
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	56                   	push   %esi
  80255e:	53                   	push   %ebx
  80255f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802565:	50                   	push   %eax
  802566:	e8 b2 f1 ff ff       	call   80171d <fd_alloc>
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	85 c0                	test   %eax,%eax
  802572:	0f 88 23 01 00 00    	js     80269b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	68 07 04 00 00       	push   $0x407
  802580:	ff 75 f4             	pushl  -0xc(%ebp)
  802583:	6a 00                	push   $0x0
  802585:	e8 b0 e9 ff ff       	call   800f3a <sys_page_alloc>
  80258a:	89 c3                	mov    %eax,%ebx
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	85 c0                	test   %eax,%eax
  802591:	0f 88 04 01 00 00    	js     80269b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802597:	83 ec 0c             	sub    $0xc,%esp
  80259a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80259d:	50                   	push   %eax
  80259e:	e8 7a f1 ff ff       	call   80171d <fd_alloc>
  8025a3:	89 c3                	mov    %eax,%ebx
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	0f 88 db 00 00 00    	js     80268b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 07 04 00 00       	push   $0x407
  8025b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8025bb:	6a 00                	push   $0x0
  8025bd:	e8 78 e9 ff ff       	call   800f3a <sys_page_alloc>
  8025c2:	89 c3                	mov    %eax,%ebx
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	0f 88 bc 00 00 00    	js     80268b <pipe+0x131>
	va = fd2data(fd0);
  8025cf:	83 ec 0c             	sub    $0xc,%esp
  8025d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d5:	e8 2c f1 ff ff       	call   801706 <fd2data>
  8025da:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025dc:	83 c4 0c             	add    $0xc,%esp
  8025df:	68 07 04 00 00       	push   $0x407
  8025e4:	50                   	push   %eax
  8025e5:	6a 00                	push   $0x0
  8025e7:	e8 4e e9 ff ff       	call   800f3a <sys_page_alloc>
  8025ec:	89 c3                	mov    %eax,%ebx
  8025ee:	83 c4 10             	add    $0x10,%esp
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	0f 88 82 00 00 00    	js     80267b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ff:	e8 02 f1 ff ff       	call   801706 <fd2data>
  802604:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80260b:	50                   	push   %eax
  80260c:	6a 00                	push   $0x0
  80260e:	56                   	push   %esi
  80260f:	6a 00                	push   $0x0
  802611:	e8 67 e9 ff ff       	call   800f7d <sys_page_map>
  802616:	89 c3                	mov    %eax,%ebx
  802618:	83 c4 20             	add    $0x20,%esp
  80261b:	85 c0                	test   %eax,%eax
  80261d:	78 4e                	js     80266d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80261f:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802627:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802633:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802636:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	ff 75 f4             	pushl  -0xc(%ebp)
  802648:	e8 a9 f0 ff ff       	call   8016f6 <fd2num>
  80264d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802650:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802652:	83 c4 04             	add    $0x4,%esp
  802655:	ff 75 f0             	pushl  -0x10(%ebp)
  802658:	e8 99 f0 ff ff       	call   8016f6 <fd2num>
  80265d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802660:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802663:	83 c4 10             	add    $0x10,%esp
  802666:	bb 00 00 00 00       	mov    $0x0,%ebx
  80266b:	eb 2e                	jmp    80269b <pipe+0x141>
	sys_page_unmap(0, va);
  80266d:	83 ec 08             	sub    $0x8,%esp
  802670:	56                   	push   %esi
  802671:	6a 00                	push   $0x0
  802673:	e8 47 e9 ff ff       	call   800fbf <sys_page_unmap>
  802678:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80267b:	83 ec 08             	sub    $0x8,%esp
  80267e:	ff 75 f0             	pushl  -0x10(%ebp)
  802681:	6a 00                	push   $0x0
  802683:	e8 37 e9 ff ff       	call   800fbf <sys_page_unmap>
  802688:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80268b:	83 ec 08             	sub    $0x8,%esp
  80268e:	ff 75 f4             	pushl  -0xc(%ebp)
  802691:	6a 00                	push   $0x0
  802693:	e8 27 e9 ff ff       	call   800fbf <sys_page_unmap>
  802698:	83 c4 10             	add    $0x10,%esp
}
  80269b:	89 d8                	mov    %ebx,%eax
  80269d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026a0:	5b                   	pop    %ebx
  8026a1:	5e                   	pop    %esi
  8026a2:	5d                   	pop    %ebp
  8026a3:	c3                   	ret    

008026a4 <pipeisclosed>:
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ad:	50                   	push   %eax
  8026ae:	ff 75 08             	pushl  0x8(%ebp)
  8026b1:	e8 b9 f0 ff ff       	call   80176f <fd_lookup>
  8026b6:	83 c4 10             	add    $0x10,%esp
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	78 18                	js     8026d5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c3:	e8 3e f0 ff ff       	call   801706 <fd2data>
	return _pipeisclosed(fd, p);
  8026c8:	89 c2                	mov    %eax,%edx
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	e8 2f fd ff ff       	call   802401 <_pipeisclosed>
  8026d2:	83 c4 10             	add    $0x10,%esp
}
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dc:	c3                   	ret    

008026dd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026e3:	68 bf 33 80 00       	push   $0x8033bf
  8026e8:	ff 75 0c             	pushl  0xc(%ebp)
  8026eb:	e8 58 e4 ff ff       	call   800b48 <strcpy>
	return 0;
}
  8026f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <devcons_write>:
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	57                   	push   %edi
  8026fb:	56                   	push   %esi
  8026fc:	53                   	push   %ebx
  8026fd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802703:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802708:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80270e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802711:	73 31                	jae    802744 <devcons_write+0x4d>
		m = n - tot;
  802713:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802716:	29 f3                	sub    %esi,%ebx
  802718:	83 fb 7f             	cmp    $0x7f,%ebx
  80271b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802720:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	53                   	push   %ebx
  802727:	89 f0                	mov    %esi,%eax
  802729:	03 45 0c             	add    0xc(%ebp),%eax
  80272c:	50                   	push   %eax
  80272d:	57                   	push   %edi
  80272e:	e8 a3 e5 ff ff       	call   800cd6 <memmove>
		sys_cputs(buf, m);
  802733:	83 c4 08             	add    $0x8,%esp
  802736:	53                   	push   %ebx
  802737:	57                   	push   %edi
  802738:	e8 41 e7 ff ff       	call   800e7e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80273d:	01 de                	add    %ebx,%esi
  80273f:	83 c4 10             	add    $0x10,%esp
  802742:	eb ca                	jmp    80270e <devcons_write+0x17>
}
  802744:	89 f0                	mov    %esi,%eax
  802746:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802749:	5b                   	pop    %ebx
  80274a:	5e                   	pop    %esi
  80274b:	5f                   	pop    %edi
  80274c:	5d                   	pop    %ebp
  80274d:	c3                   	ret    

0080274e <devcons_read>:
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 08             	sub    $0x8,%esp
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802759:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80275d:	74 21                	je     802780 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80275f:	e8 38 e7 ff ff       	call   800e9c <sys_cgetc>
  802764:	85 c0                	test   %eax,%eax
  802766:	75 07                	jne    80276f <devcons_read+0x21>
		sys_yield();
  802768:	e8 ae e7 ff ff       	call   800f1b <sys_yield>
  80276d:	eb f0                	jmp    80275f <devcons_read+0x11>
	if (c < 0)
  80276f:	78 0f                	js     802780 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802771:	83 f8 04             	cmp    $0x4,%eax
  802774:	74 0c                	je     802782 <devcons_read+0x34>
	*(char*)vbuf = c;
  802776:	8b 55 0c             	mov    0xc(%ebp),%edx
  802779:	88 02                	mov    %al,(%edx)
	return 1;
  80277b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    
		return 0;
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	eb f7                	jmp    802780 <devcons_read+0x32>

00802789 <cputchar>:
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802795:	6a 01                	push   $0x1
  802797:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80279a:	50                   	push   %eax
  80279b:	e8 de e6 ff ff       	call   800e7e <sys_cputs>
}
  8027a0:	83 c4 10             	add    $0x10,%esp
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <getchar>:
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027ab:	6a 01                	push   $0x1
  8027ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027b0:	50                   	push   %eax
  8027b1:	6a 00                	push   $0x0
  8027b3:	e8 27 f2 ff ff       	call   8019df <read>
	if (r < 0)
  8027b8:	83 c4 10             	add    $0x10,%esp
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	78 06                	js     8027c5 <getchar+0x20>
	if (r < 1)
  8027bf:	74 06                	je     8027c7 <getchar+0x22>
	return c;
  8027c1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027c5:	c9                   	leave  
  8027c6:	c3                   	ret    
		return -E_EOF;
  8027c7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027cc:	eb f7                	jmp    8027c5 <getchar+0x20>

008027ce <iscons>:
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
  8027d1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027d7:	50                   	push   %eax
  8027d8:	ff 75 08             	pushl  0x8(%ebp)
  8027db:	e8 8f ef ff ff       	call   80176f <fd_lookup>
  8027e0:	83 c4 10             	add    $0x10,%esp
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	78 11                	js     8027f8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027f0:	39 10                	cmp    %edx,(%eax)
  8027f2:	0f 94 c0             	sete   %al
  8027f5:	0f b6 c0             	movzbl %al,%eax
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <opencons>:
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802800:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802803:	50                   	push   %eax
  802804:	e8 14 ef ff ff       	call   80171d <fd_alloc>
  802809:	83 c4 10             	add    $0x10,%esp
  80280c:	85 c0                	test   %eax,%eax
  80280e:	78 3a                	js     80284a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802810:	83 ec 04             	sub    $0x4,%esp
  802813:	68 07 04 00 00       	push   $0x407
  802818:	ff 75 f4             	pushl  -0xc(%ebp)
  80281b:	6a 00                	push   $0x0
  80281d:	e8 18 e7 ff ff       	call   800f3a <sys_page_alloc>
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	85 c0                	test   %eax,%eax
  802827:	78 21                	js     80284a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802832:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80283e:	83 ec 0c             	sub    $0xc,%esp
  802841:	50                   	push   %eax
  802842:	e8 af ee ff ff       	call   8016f6 <fd2num>
  802847:	83 c4 10             	add    $0x10,%esp
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802852:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802859:	74 0a                	je     802865 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	6a 07                	push   $0x7
  80286a:	68 00 f0 bf ee       	push   $0xeebff000
  80286f:	6a 00                	push   $0x0
  802871:	e8 c4 e6 ff ff       	call   800f3a <sys_page_alloc>
		if(r < 0)
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	85 c0                	test   %eax,%eax
  80287b:	78 2a                	js     8028a7 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80287d:	83 ec 08             	sub    $0x8,%esp
  802880:	68 bb 28 80 00       	push   $0x8028bb
  802885:	6a 00                	push   $0x0
  802887:	e8 f9 e7 ff ff       	call   801085 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	85 c0                	test   %eax,%eax
  802891:	79 c8                	jns    80285b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 fc 33 80 00       	push   $0x8033fc
  80289b:	6a 25                	push   $0x25
  80289d:	68 38 34 80 00       	push   $0x803438
  8028a2:	e8 4c da ff ff       	call   8002f3 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	68 cc 33 80 00       	push   $0x8033cc
  8028af:	6a 22                	push   $0x22
  8028b1:	68 38 34 80 00       	push   $0x803438
  8028b6:	e8 38 da ff ff       	call   8002f3 <_panic>

008028bb <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028bb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028bc:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028c1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028c3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028c6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028ca:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028ce:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028d1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028d3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028d7:	83 c4 08             	add    $0x8,%esp
	popal
  8028da:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028db:	83 c4 04             	add    $0x4,%esp
	popfl
  8028de:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028df:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028e0:	c3                   	ret    

008028e1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	56                   	push   %esi
  8028e5:	53                   	push   %ebx
  8028e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8028e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8028ef:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028f1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028f6:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028f9:	83 ec 0c             	sub    $0xc,%esp
  8028fc:	50                   	push   %eax
  8028fd:	e8 e8 e7 ff ff       	call   8010ea <sys_ipc_recv>
	if(ret < 0){
  802902:	83 c4 10             	add    $0x10,%esp
  802905:	85 c0                	test   %eax,%eax
  802907:	78 2b                	js     802934 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802909:	85 f6                	test   %esi,%esi
  80290b:	74 0a                	je     802917 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80290d:	a1 08 50 80 00       	mov    0x805008,%eax
  802912:	8b 40 74             	mov    0x74(%eax),%eax
  802915:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802917:	85 db                	test   %ebx,%ebx
  802919:	74 0a                	je     802925 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80291b:	a1 08 50 80 00       	mov    0x805008,%eax
  802920:	8b 40 78             	mov    0x78(%eax),%eax
  802923:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802925:	a1 08 50 80 00       	mov    0x805008,%eax
  80292a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80292d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802930:	5b                   	pop    %ebx
  802931:	5e                   	pop    %esi
  802932:	5d                   	pop    %ebp
  802933:	c3                   	ret    
		if(from_env_store)
  802934:	85 f6                	test   %esi,%esi
  802936:	74 06                	je     80293e <ipc_recv+0x5d>
			*from_env_store = 0;
  802938:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80293e:	85 db                	test   %ebx,%ebx
  802940:	74 eb                	je     80292d <ipc_recv+0x4c>
			*perm_store = 0;
  802942:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802948:	eb e3                	jmp    80292d <ipc_recv+0x4c>

0080294a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	57                   	push   %edi
  80294e:	56                   	push   %esi
  80294f:	53                   	push   %ebx
  802950:	83 ec 0c             	sub    $0xc,%esp
  802953:	8b 7d 08             	mov    0x8(%ebp),%edi
  802956:	8b 75 0c             	mov    0xc(%ebp),%esi
  802959:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80295c:	85 db                	test   %ebx,%ebx
  80295e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802963:	0f 44 d8             	cmove  %eax,%ebx
  802966:	eb 05                	jmp    80296d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802968:	e8 ae e5 ff ff       	call   800f1b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80296d:	ff 75 14             	pushl  0x14(%ebp)
  802970:	53                   	push   %ebx
  802971:	56                   	push   %esi
  802972:	57                   	push   %edi
  802973:	e8 4f e7 ff ff       	call   8010c7 <sys_ipc_try_send>
  802978:	83 c4 10             	add    $0x10,%esp
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 1b                	je     80299a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80297f:	79 e7                	jns    802968 <ipc_send+0x1e>
  802981:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802984:	74 e2                	je     802968 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	68 46 34 80 00       	push   $0x803446
  80298e:	6a 4a                	push   $0x4a
  802990:	68 5b 34 80 00       	push   $0x80345b
  802995:	e8 59 d9 ff ff       	call   8002f3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80299a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80299d:	5b                   	pop    %ebx
  80299e:	5e                   	pop    %esi
  80299f:	5f                   	pop    %edi
  8029a0:	5d                   	pop    %ebp
  8029a1:	c3                   	ret    

008029a2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029a2:	55                   	push   %ebp
  8029a3:	89 e5                	mov    %esp,%ebp
  8029a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029ad:	89 c2                	mov    %eax,%edx
  8029af:	c1 e2 07             	shl    $0x7,%edx
  8029b2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029b8:	8b 52 50             	mov    0x50(%edx),%edx
  8029bb:	39 ca                	cmp    %ecx,%edx
  8029bd:	74 11                	je     8029d0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029bf:	83 c0 01             	add    $0x1,%eax
  8029c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029c7:	75 e4                	jne    8029ad <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ce:	eb 0b                	jmp    8029db <ipc_find_env+0x39>
			return envs[i].env_id;
  8029d0:	c1 e0 07             	shl    $0x7,%eax
  8029d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029d8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    

008029dd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
  8029e0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029e3:	89 d0                	mov    %edx,%eax
  8029e5:	c1 e8 16             	shr    $0x16,%eax
  8029e8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029f4:	f6 c1 01             	test   $0x1,%cl
  8029f7:	74 1d                	je     802a16 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029f9:	c1 ea 0c             	shr    $0xc,%edx
  8029fc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a03:	f6 c2 01             	test   $0x1,%dl
  802a06:	74 0e                	je     802a16 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a08:	c1 ea 0c             	shr    $0xc,%edx
  802a0b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a12:	ef 
  802a13:	0f b7 c0             	movzwl %ax,%eax
}
  802a16:	5d                   	pop    %ebp
  802a17:	c3                   	ret    
  802a18:	66 90                	xchg   %ax,%ax
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

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
