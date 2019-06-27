
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
  80002c:	e8 b8 01 00 00       	call   8001e9 <libmain>
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
  80003c:	68 a0 2c 80 00       	push   $0x802ca0
  800041:	e8 a8 03 00 00       	call   8003ee <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 34 25 00 00       	call   802585 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 74                	js     8000cc <umain+0x99>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 2c 14 00 00       	call   801489 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 7b                	js     8000de <umain+0xab>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	0f 84 87 00 00 00    	je     8000f0 <umain+0xbd>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800069:	89 fb                	mov    %edi,%ebx
  80006b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  800071:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  800077:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80007d:	8b 43 54             	mov    0x54(%ebx),%eax
  800080:	83 f8 02             	cmp    $0x2,%eax
  800083:	0f 85 e3 00 00 00    	jne    80016c <umain+0x139>
		if (pipeisclosed(p[0]) != 0) {
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 75 e0             	pushl  -0x20(%ebp)
  80008f:	e8 3b 26 00 00       	call   8026cf <pipeisclosed>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	85 c0                	test   %eax,%eax
  800099:	74 e2                	je     80007d <umain+0x4a>
			cprintf("\nRACE: pipe appears closed\n");
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	68 19 2d 80 00       	push   $0x802d19
  8000a3:	e8 46 03 00 00       	call   8003ee <cprintf>
			cprintf("in %s\n", __FUNCTION__);
  8000a8:	83 c4 08             	add    $0x8,%esp
  8000ab:	68 78 2d 80 00       	push   $0x802d78
  8000b0:	68 da 2d 80 00       	push   $0x802dda
  8000b5:	e8 34 03 00 00       	call   8003ee <cprintf>
			sys_env_destroy(r);
  8000ba:	89 3c 24             	mov    %edi,(%esp)
  8000bd:	e8 fe 0d 00 00       	call   800ec0 <sys_env_destroy>
			exit();
  8000c2:	e8 fd 01 00 00       	call   8002c4 <exit>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	eb b1                	jmp    80007d <umain+0x4a>
		panic("pipe: %e", r);
  8000cc:	50                   	push   %eax
  8000cd:	68 ee 2c 80 00       	push   $0x802cee
  8000d2:	6a 0d                	push   $0xd
  8000d4:	68 f7 2c 80 00       	push   $0x802cf7
  8000d9:	e8 1a 02 00 00       	call   8002f8 <_panic>
		panic("fork: %e", r);
  8000de:	50                   	push   %eax
  8000df:	68 0c 2d 80 00       	push   $0x802d0c
  8000e4:	6a 0f                	push   $0xf
  8000e6:	68 f7 2c 80 00       	push   $0x802cf7
  8000eb:	e8 08 02 00 00       	call   8002f8 <_panic>
		close(p[1]);
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 d1 17 00 00       	call   8018cc <close>
  8000fb:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000fe:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  800100:	be 67 66 66 66       	mov    $0x66666667,%esi
  800105:	eb 42                	jmp    800149 <umain+0x116>
				cprintf("%d.", i);
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	53                   	push   %ebx
  80010b:	68 15 2d 80 00       	push   $0x802d15
  800110:	e8 d9 02 00 00       	call   8003ee <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	6a 0a                	push   $0xa
  80011d:	ff 75 e0             	pushl  -0x20(%ebp)
  800120:	e8 f9 17 00 00       	call   80191e <dup>
			sys_yield();
  800125:	e8 f6 0d 00 00       	call   800f20 <sys_yield>
			close(10);
  80012a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800131:	e8 96 17 00 00       	call   8018cc <close>
			sys_yield();
  800136:	e8 e5 0d 00 00       	call   800f20 <sys_yield>
		for (i = 0; i < 200; i++) {
  80013b:	83 c3 01             	add    $0x1,%ebx
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800147:	74 19                	je     800162 <umain+0x12f>
			if (i % 10 == 0)
  800149:	89 d8                	mov    %ebx,%eax
  80014b:	f7 ee                	imul   %esi
  80014d:	c1 fa 02             	sar    $0x2,%edx
  800150:	89 d8                	mov    %ebx,%eax
  800152:	c1 f8 1f             	sar    $0x1f,%eax
  800155:	29 c2                	sub    %eax,%edx
  800157:	8d 04 92             	lea    (%edx,%edx,4),%eax
  80015a:	01 c0                	add    %eax,%eax
  80015c:	39 c3                	cmp    %eax,%ebx
  80015e:	75 b8                	jne    800118 <umain+0xe5>
  800160:	eb a5                	jmp    800107 <umain+0xd4>
		exit();
  800162:	e8 5d 01 00 00       	call   8002c4 <exit>
  800167:	e9 fd fe ff ff       	jmp    800069 <umain+0x36>
		}
	cprintf("child done with loop\n");
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 35 2d 80 00       	push   $0x802d35
  800174:	e8 75 02 00 00       	call   8003ee <cprintf>
	if (pipeisclosed(p[0]))
  800179:	83 c4 04             	add    $0x4,%esp
  80017c:	ff 75 e0             	pushl  -0x20(%ebp)
  80017f:	e8 4b 25 00 00       	call   8026cf <pipeisclosed>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	85 c0                	test   %eax,%eax
  800189:	75 38                	jne    8001c3 <umain+0x190>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	e8 00 16 00 00       	call   80179a <fd_lookup>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 36                	js     8001d7 <umain+0x1a4>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a7:	e8 85 15 00 00       	call   801731 <fd2data>
	cprintf("race didn't happen\n");
  8001ac:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8001b3:	e8 36 02 00 00       	call   8003ee <cprintf>
}
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001c3:	83 ec 04             	sub    $0x4,%esp
  8001c6:	68 c4 2c 80 00       	push   $0x802cc4
  8001cb:	6a 41                	push   $0x41
  8001cd:	68 f7 2c 80 00       	push   $0x802cf7
  8001d2:	e8 21 01 00 00       	call   8002f8 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001d7:	50                   	push   %eax
  8001d8:	68 4b 2d 80 00       	push   $0x802d4b
  8001dd:	6a 43                	push   $0x43
  8001df:	68 f7 2c 80 00       	push   $0x802cf7
  8001e4:	e8 0f 01 00 00       	call   8002f8 <_panic>

008001e9 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	57                   	push   %edi
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001f2:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001f9:	00 00 00 
	envid_t find = sys_getenvid();
  8001fc:	e8 00 0d 00 00       	call   800f01 <sys_getenvid>
  800201:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800207:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80020c:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
  800216:	eb 0b                	jmp    800223 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800218:	83 c2 01             	add    $0x1,%edx
  80021b:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800221:	74 23                	je     800246 <libmain+0x5d>
		if(envs[i].env_id == find)
  800223:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800229:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80022f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800232:	39 c1                	cmp    %eax,%ecx
  800234:	75 e2                	jne    800218 <libmain+0x2f>
  800236:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80023c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800242:	89 fe                	mov    %edi,%esi
  800244:	eb d2                	jmp    800218 <libmain+0x2f>
  800246:	89 f0                	mov    %esi,%eax
  800248:	84 c0                	test   %al,%al
  80024a:	74 06                	je     800252 <libmain+0x69>
  80024c:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800256:	7e 0a                	jle    800262 <libmain+0x79>
		binaryname = argv[0];
  800258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025b:	8b 00                	mov    (%eax),%eax
  80025d:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800262:	a1 08 50 80 00       	mov    0x805008,%eax
  800267:	8b 40 48             	mov    0x48(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 7e 2d 80 00       	push   $0x802d7e
  800273:	e8 76 01 00 00       	call   8003ee <cprintf>
	cprintf("before umain\n");
  800278:	c7 04 24 9c 2d 80 00 	movl   $0x802d9c,(%esp)
  80027f:	e8 6a 01 00 00       	call   8003ee <cprintf>
	// call user main routine
	umain(argc, argv);
  800284:	83 c4 08             	add    $0x8,%esp
  800287:	ff 75 0c             	pushl  0xc(%ebp)
  80028a:	ff 75 08             	pushl  0x8(%ebp)
  80028d:	e8 a1 fd ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800292:	c7 04 24 aa 2d 80 00 	movl   $0x802daa,(%esp)
  800299:	e8 50 01 00 00       	call   8003ee <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80029e:	a1 08 50 80 00       	mov    0x805008,%eax
  8002a3:	8b 40 48             	mov    0x48(%eax),%eax
  8002a6:	83 c4 08             	add    $0x8,%esp
  8002a9:	50                   	push   %eax
  8002aa:	68 b7 2d 80 00       	push   $0x802db7
  8002af:	e8 3a 01 00 00       	call   8003ee <cprintf>
	// exit gracefully
	exit();
  8002b4:	e8 0b 00 00 00       	call   8002c4 <exit>
}
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8002cf:	8b 40 48             	mov    0x48(%eax),%eax
  8002d2:	68 e4 2d 80 00       	push   $0x802de4
  8002d7:	50                   	push   %eax
  8002d8:	68 d6 2d 80 00       	push   $0x802dd6
  8002dd:	e8 0c 01 00 00       	call   8003ee <cprintf>
	close_all();
  8002e2:	e8 12 16 00 00       	call   8018f9 <close_all>
	sys_env_destroy(0);
  8002e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002ee:	e8 cd 0b 00 00       	call   800ec0 <sys_env_destroy>
}
  8002f3:	83 c4 10             	add    $0x10,%esp
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002fd:	a1 08 50 80 00       	mov    0x805008,%eax
  800302:	8b 40 48             	mov    0x48(%eax),%eax
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	68 10 2e 80 00       	push   $0x802e10
  80030d:	50                   	push   %eax
  80030e:	68 d6 2d 80 00       	push   $0x802dd6
  800313:	e8 d6 00 00 00       	call   8003ee <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800318:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80031b:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800321:	e8 db 0b 00 00       	call   800f01 <sys_getenvid>
  800326:	83 c4 04             	add    $0x4,%esp
  800329:	ff 75 0c             	pushl  0xc(%ebp)
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	56                   	push   %esi
  800330:	50                   	push   %eax
  800331:	68 ec 2d 80 00       	push   $0x802dec
  800336:	e8 b3 00 00 00       	call   8003ee <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033b:	83 c4 18             	add    $0x18,%esp
  80033e:	53                   	push   %ebx
  80033f:	ff 75 10             	pushl  0x10(%ebp)
  800342:	e8 56 00 00 00       	call   80039d <vcprintf>
	cprintf("\n");
  800347:	c7 04 24 9a 2d 80 00 	movl   $0x802d9a,(%esp)
  80034e:	e8 9b 00 00 00       	call   8003ee <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800356:	cc                   	int3   
  800357:	eb fd                	jmp    800356 <_panic+0x5e>

00800359 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	53                   	push   %ebx
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800363:	8b 13                	mov    (%ebx),%edx
  800365:	8d 42 01             	lea    0x1(%edx),%eax
  800368:	89 03                	mov    %eax,(%ebx)
  80036a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80036d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800371:	3d ff 00 00 00       	cmp    $0xff,%eax
  800376:	74 09                	je     800381 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800378:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80037c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037f:	c9                   	leave  
  800380:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	68 ff 00 00 00       	push   $0xff
  800389:	8d 43 08             	lea    0x8(%ebx),%eax
  80038c:	50                   	push   %eax
  80038d:	e8 f1 0a 00 00       	call   800e83 <sys_cputs>
		b->idx = 0;
  800392:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	eb db                	jmp    800378 <putch+0x1f>

0080039d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ad:	00 00 00 
	b.cnt = 0;
  8003b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c6:	50                   	push   %eax
  8003c7:	68 59 03 80 00       	push   $0x800359
  8003cc:	e8 4a 01 00 00       	call   80051b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003d1:	83 c4 08             	add    $0x8,%esp
  8003d4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003da:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003e0:	50                   	push   %eax
  8003e1:	e8 9d 0a 00 00       	call   800e83 <sys_cputs>

	return b.cnt;
}
  8003e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003f4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003f7:	50                   	push   %eax
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 9d ff ff ff       	call   80039d <vcprintf>
	va_end(ap);

	return cnt;
}
  800400:	c9                   	leave  
  800401:	c3                   	ret    

00800402 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	57                   	push   %edi
  800406:	56                   	push   %esi
  800407:	53                   	push   %ebx
  800408:	83 ec 1c             	sub    $0x1c,%esp
  80040b:	89 c6                	mov    %eax,%esi
  80040d:	89 d7                	mov    %edx,%edi
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 55 0c             	mov    0xc(%ebp),%edx
  800415:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800418:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80041b:	8b 45 10             	mov    0x10(%ebp),%eax
  80041e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800421:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800425:	74 2c                	je     800453 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800427:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800431:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800434:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800437:	39 c2                	cmp    %eax,%edx
  800439:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80043c:	73 43                	jae    800481 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80043e:	83 eb 01             	sub    $0x1,%ebx
  800441:	85 db                	test   %ebx,%ebx
  800443:	7e 6c                	jle    8004b1 <printnum+0xaf>
				putch(padc, putdat);
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	57                   	push   %edi
  800449:	ff 75 18             	pushl  0x18(%ebp)
  80044c:	ff d6                	call   *%esi
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	eb eb                	jmp    80043e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	6a 20                	push   $0x20
  800458:	6a 00                	push   $0x0
  80045a:	50                   	push   %eax
  80045b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045e:	ff 75 e0             	pushl  -0x20(%ebp)
  800461:	89 fa                	mov    %edi,%edx
  800463:	89 f0                	mov    %esi,%eax
  800465:	e8 98 ff ff ff       	call   800402 <printnum>
		while (--width > 0)
  80046a:	83 c4 20             	add    $0x20,%esp
  80046d:	83 eb 01             	sub    $0x1,%ebx
  800470:	85 db                	test   %ebx,%ebx
  800472:	7e 65                	jle    8004d9 <printnum+0xd7>
			putch(padc, putdat);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	57                   	push   %edi
  800478:	6a 20                	push   $0x20
  80047a:	ff d6                	call   *%esi
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	eb ec                	jmp    80046d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	ff 75 18             	pushl  0x18(%ebp)
  800487:	83 eb 01             	sub    $0x1,%ebx
  80048a:	53                   	push   %ebx
  80048b:	50                   	push   %eax
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 dc             	pushl  -0x24(%ebp)
  800492:	ff 75 d8             	pushl  -0x28(%ebp)
  800495:	ff 75 e4             	pushl  -0x1c(%ebp)
  800498:	ff 75 e0             	pushl  -0x20(%ebp)
  80049b:	e8 b0 25 00 00       	call   802a50 <__udivdi3>
  8004a0:	83 c4 18             	add    $0x18,%esp
  8004a3:	52                   	push   %edx
  8004a4:	50                   	push   %eax
  8004a5:	89 fa                	mov    %edi,%edx
  8004a7:	89 f0                	mov    %esi,%eax
  8004a9:	e8 54 ff ff ff       	call   800402 <printnum>
  8004ae:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	57                   	push   %edi
  8004b5:	83 ec 04             	sub    $0x4,%esp
  8004b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8004bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8004be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c4:	e8 97 26 00 00       	call   802b60 <__umoddi3>
  8004c9:	83 c4 14             	add    $0x14,%esp
  8004cc:	0f be 80 17 2e 80 00 	movsbl 0x802e17(%eax),%eax
  8004d3:	50                   	push   %eax
  8004d4:	ff d6                	call   *%esi
  8004d6:	83 c4 10             	add    $0x10,%esp
	}
}
  8004d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004dc:	5b                   	pop    %ebx
  8004dd:	5e                   	pop    %esi
  8004de:	5f                   	pop    %edi
  8004df:	5d                   	pop    %ebp
  8004e0:	c3                   	ret    

008004e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004eb:	8b 10                	mov    (%eax),%edx
  8004ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f0:	73 0a                	jae    8004fc <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f5:	89 08                	mov    %ecx,(%eax)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	88 02                	mov    %al,(%edx)
}
  8004fc:	5d                   	pop    %ebp
  8004fd:	c3                   	ret    

008004fe <printfmt>:
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800504:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800507:	50                   	push   %eax
  800508:	ff 75 10             	pushl  0x10(%ebp)
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 05 00 00 00       	call   80051b <vprintfmt>
}
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <vprintfmt>:
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	57                   	push   %edi
  80051f:	56                   	push   %esi
  800520:	53                   	push   %ebx
  800521:	83 ec 3c             	sub    $0x3c,%esp
  800524:	8b 75 08             	mov    0x8(%ebp),%esi
  800527:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80052d:	e9 32 04 00 00       	jmp    800964 <vprintfmt+0x449>
		padc = ' ';
  800532:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800536:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80053d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800544:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80054b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800552:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800559:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80055e:	8d 47 01             	lea    0x1(%edi),%eax
  800561:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800564:	0f b6 17             	movzbl (%edi),%edx
  800567:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056a:	3c 55                	cmp    $0x55,%al
  80056c:	0f 87 12 05 00 00    	ja     800a84 <vprintfmt+0x569>
  800572:	0f b6 c0             	movzbl %al,%eax
  800575:	ff 24 85 00 30 80 00 	jmp    *0x803000(,%eax,4)
  80057c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800583:	eb d9                	jmp    80055e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800585:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800588:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80058c:	eb d0                	jmp    80055e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80058e:	0f b6 d2             	movzbl %dl,%edx
  800591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800594:	b8 00 00 00 00       	mov    $0x0,%eax
  800599:	89 75 08             	mov    %esi,0x8(%ebp)
  80059c:	eb 03                	jmp    8005a1 <vprintfmt+0x86>
  80059e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005a1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005ab:	8d 72 d0             	lea    -0x30(%edx),%esi
  8005ae:	83 fe 09             	cmp    $0x9,%esi
  8005b1:	76 eb                	jbe    80059e <vprintfmt+0x83>
  8005b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b9:	eb 14                	jmp    8005cf <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d3:	79 89                	jns    80055e <vprintfmt+0x43>
				width = precision, precision = -1;
  8005d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005e2:	e9 77 ff ff ff       	jmp    80055e <vprintfmt+0x43>
  8005e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ea:	85 c0                	test   %eax,%eax
  8005ec:	0f 48 c1             	cmovs  %ecx,%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f5:	e9 64 ff ff ff       	jmp    80055e <vprintfmt+0x43>
  8005fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005fd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800604:	e9 55 ff ff ff       	jmp    80055e <vprintfmt+0x43>
			lflag++;
  800609:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800610:	e9 49 ff ff ff       	jmp    80055e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 78 04             	lea    0x4(%eax),%edi
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	ff 30                	pushl  (%eax)
  800621:	ff d6                	call   *%esi
			break;
  800623:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800626:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800629:	e9 33 03 00 00       	jmp    800961 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 78 04             	lea    0x4(%eax),%edi
  800634:	8b 00                	mov    (%eax),%eax
  800636:	99                   	cltd   
  800637:	31 d0                	xor    %edx,%eax
  800639:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063b:	83 f8 11             	cmp    $0x11,%eax
  80063e:	7f 23                	jg     800663 <vprintfmt+0x148>
  800640:	8b 14 85 60 31 80 00 	mov    0x803160(,%eax,4),%edx
  800647:	85 d2                	test   %edx,%edx
  800649:	74 18                	je     800663 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80064b:	52                   	push   %edx
  80064c:	68 6d 33 80 00       	push   $0x80336d
  800651:	53                   	push   %ebx
  800652:	56                   	push   %esi
  800653:	e8 a6 fe ff ff       	call   8004fe <printfmt>
  800658:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80065e:	e9 fe 02 00 00       	jmp    800961 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800663:	50                   	push   %eax
  800664:	68 2f 2e 80 00       	push   $0x802e2f
  800669:	53                   	push   %ebx
  80066a:	56                   	push   %esi
  80066b:	e8 8e fe ff ff       	call   8004fe <printfmt>
  800670:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800673:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800676:	e9 e6 02 00 00       	jmp    800961 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	83 c0 04             	add    $0x4,%eax
  800681:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800689:	85 c9                	test   %ecx,%ecx
  80068b:	b8 28 2e 80 00       	mov    $0x802e28,%eax
  800690:	0f 45 c1             	cmovne %ecx,%eax
  800693:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800696:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069a:	7e 06                	jle    8006a2 <vprintfmt+0x187>
  80069c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8006a0:	75 0d                	jne    8006af <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a5:	89 c7                	mov    %eax,%edi
  8006a7:	03 45 e0             	add    -0x20(%ebp),%eax
  8006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ad:	eb 53                	jmp    800702 <vprintfmt+0x1e7>
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b5:	50                   	push   %eax
  8006b6:	e8 71 04 00 00       	call   800b2c <strnlen>
  8006bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006be:	29 c1                	sub    %eax,%ecx
  8006c0:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006c8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	eb 0f                	jmp    8006e0 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006da:	83 ef 01             	sub    $0x1,%edi
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	85 ff                	test   %edi,%edi
  8006e2:	7f ed                	jg     8006d1 <vprintfmt+0x1b6>
  8006e4:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006e7:	85 c9                	test   %ecx,%ecx
  8006e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ee:	0f 49 c1             	cmovns %ecx,%eax
  8006f1:	29 c1                	sub    %eax,%ecx
  8006f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006f6:	eb aa                	jmp    8006a2 <vprintfmt+0x187>
					putch(ch, putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	52                   	push   %edx
  8006fd:	ff d6                	call   *%esi
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800705:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800707:	83 c7 01             	add    $0x1,%edi
  80070a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070e:	0f be d0             	movsbl %al,%edx
  800711:	85 d2                	test   %edx,%edx
  800713:	74 4b                	je     800760 <vprintfmt+0x245>
  800715:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800719:	78 06                	js     800721 <vprintfmt+0x206>
  80071b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80071f:	78 1e                	js     80073f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800721:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800725:	74 d1                	je     8006f8 <vprintfmt+0x1dd>
  800727:	0f be c0             	movsbl %al,%eax
  80072a:	83 e8 20             	sub    $0x20,%eax
  80072d:	83 f8 5e             	cmp    $0x5e,%eax
  800730:	76 c6                	jbe    8006f8 <vprintfmt+0x1dd>
					putch('?', putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	53                   	push   %ebx
  800736:	6a 3f                	push   $0x3f
  800738:	ff d6                	call   *%esi
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	eb c3                	jmp    800702 <vprintfmt+0x1e7>
  80073f:	89 cf                	mov    %ecx,%edi
  800741:	eb 0e                	jmp    800751 <vprintfmt+0x236>
				putch(' ', putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	53                   	push   %ebx
  800747:	6a 20                	push   $0x20
  800749:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80074b:	83 ef 01             	sub    $0x1,%edi
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	85 ff                	test   %edi,%edi
  800753:	7f ee                	jg     800743 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800755:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
  80075b:	e9 01 02 00 00       	jmp    800961 <vprintfmt+0x446>
  800760:	89 cf                	mov    %ecx,%edi
  800762:	eb ed                	jmp    800751 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800767:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80076e:	e9 eb fd ff ff       	jmp    80055e <vprintfmt+0x43>
	if (lflag >= 2)
  800773:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800777:	7f 21                	jg     80079a <vprintfmt+0x27f>
	else if (lflag)
  800779:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077d:	74 68                	je     8007e7 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800787:	89 c1                	mov    %eax,%ecx
  800789:	c1 f9 1f             	sar    $0x1f,%ecx
  80078c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
  800798:	eb 17                	jmp    8007b1 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 50 04             	mov    0x4(%eax),%edx
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 40 08             	lea    0x8(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8007b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007c1:	78 3f                	js     800802 <vprintfmt+0x2e7>
			base = 10;
  8007c3:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007c8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007cc:	0f 84 71 01 00 00    	je     800943 <vprintfmt+0x428>
				putch('+', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	6a 2b                	push   $0x2b
  8007d8:	ff d6                	call   *%esi
  8007da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e2:	e9 5c 01 00 00       	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ef:	89 c1                	mov    %eax,%ecx
  8007f1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007f4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8d 40 04             	lea    0x4(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	eb af                	jmp    8007b1 <vprintfmt+0x296>
				putch('-', putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	53                   	push   %ebx
  800806:	6a 2d                	push   $0x2d
  800808:	ff d6                	call   *%esi
				num = -(long long) num;
  80080a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80080d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800810:	f7 d8                	neg    %eax
  800812:	83 d2 00             	adc    $0x0,%edx
  800815:	f7 da                	neg    %edx
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800820:	b8 0a 00 00 00       	mov    $0xa,%eax
  800825:	e9 19 01 00 00       	jmp    800943 <vprintfmt+0x428>
	if (lflag >= 2)
  80082a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80082e:	7f 29                	jg     800859 <vprintfmt+0x33e>
	else if (lflag)
  800830:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800834:	74 44                	je     80087a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	ba 00 00 00 00       	mov    $0x0,%edx
  800840:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800843:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8d 40 04             	lea    0x4(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800854:	e9 ea 00 00 00       	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 50 04             	mov    0x4(%eax),%edx
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800864:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8d 40 08             	lea    0x8(%eax),%eax
  80086d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800870:	b8 0a 00 00 00       	mov    $0xa,%eax
  800875:	e9 c9 00 00 00       	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	8d 40 04             	lea    0x4(%eax),%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800893:	b8 0a 00 00 00       	mov    $0xa,%eax
  800898:	e9 a6 00 00 00       	jmp    800943 <vprintfmt+0x428>
			putch('0', putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	6a 30                	push   $0x30
  8008a3:	ff d6                	call   *%esi
	if (lflag >= 2)
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008ac:	7f 26                	jg     8008d4 <vprintfmt+0x3b9>
	else if (lflag)
  8008ae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008b2:	74 3e                	je     8008f2 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008cd:	b8 08 00 00 00       	mov    $0x8,%eax
  8008d2:	eb 6f                	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8b 50 04             	mov    0x4(%eax),%edx
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 08             	lea    0x8(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8008f0:	eb 51                	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8d 40 04             	lea    0x4(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80090b:	b8 08 00 00 00       	mov    $0x8,%eax
  800910:	eb 31                	jmp    800943 <vprintfmt+0x428>
			putch('0', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	53                   	push   %ebx
  800916:	6a 30                	push   $0x30
  800918:	ff d6                	call   *%esi
			putch('x', putdat);
  80091a:	83 c4 08             	add    $0x8,%esp
  80091d:	53                   	push   %ebx
  80091e:	6a 78                	push   $0x78
  800920:	ff d6                	call   *%esi
			num = (unsigned long long)
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
  80092c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800932:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8d 40 04             	lea    0x4(%eax),%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800943:	83 ec 0c             	sub    $0xc,%esp
  800946:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80094a:	52                   	push   %edx
  80094b:	ff 75 e0             	pushl  -0x20(%ebp)
  80094e:	50                   	push   %eax
  80094f:	ff 75 dc             	pushl  -0x24(%ebp)
  800952:	ff 75 d8             	pushl  -0x28(%ebp)
  800955:	89 da                	mov    %ebx,%edx
  800957:	89 f0                	mov    %esi,%eax
  800959:	e8 a4 fa ff ff       	call   800402 <printnum>
			break;
  80095e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800961:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800964:	83 c7 01             	add    $0x1,%edi
  800967:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80096b:	83 f8 25             	cmp    $0x25,%eax
  80096e:	0f 84 be fb ff ff    	je     800532 <vprintfmt+0x17>
			if (ch == '\0')
  800974:	85 c0                	test   %eax,%eax
  800976:	0f 84 28 01 00 00    	je     800aa4 <vprintfmt+0x589>
			putch(ch, putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	53                   	push   %ebx
  800980:	50                   	push   %eax
  800981:	ff d6                	call   *%esi
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	eb dc                	jmp    800964 <vprintfmt+0x449>
	if (lflag >= 2)
  800988:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80098c:	7f 26                	jg     8009b4 <vprintfmt+0x499>
	else if (lflag)
  80098e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800992:	74 41                	je     8009d5 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800994:	8b 45 14             	mov    0x14(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	ba 00 00 00 00       	mov    $0x0,%edx
  80099e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8d 40 04             	lea    0x4(%eax),%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8009b2:	eb 8f                	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8b 50 04             	mov    0x4(%eax),%edx
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	8d 40 08             	lea    0x8(%eax),%eax
  8009c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d0:	e9 6e ff ff ff       	jmp    800943 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	8b 00                	mov    (%eax),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	8d 40 04             	lea    0x4(%eax),%eax
  8009eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8009f3:	e9 4b ff ff ff       	jmp    800943 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fb:	83 c0 04             	add    $0x4,%eax
  8009fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 00                	mov    (%eax),%eax
  800a06:	85 c0                	test   %eax,%eax
  800a08:	74 14                	je     800a1e <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800a0a:	8b 13                	mov    (%ebx),%edx
  800a0c:	83 fa 7f             	cmp    $0x7f,%edx
  800a0f:	7f 37                	jg     800a48 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800a11:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800a13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
  800a19:	e9 43 ff ff ff       	jmp    800961 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a1e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a23:	bf 4d 2f 80 00       	mov    $0x802f4d,%edi
							putch(ch, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	53                   	push   %ebx
  800a2c:	50                   	push   %eax
  800a2d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a2f:	83 c7 01             	add    $0x1,%edi
  800a32:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	85 c0                	test   %eax,%eax
  800a3b:	75 eb                	jne    800a28 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a40:	89 45 14             	mov    %eax,0x14(%ebp)
  800a43:	e9 19 ff ff ff       	jmp    800961 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a48:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a4f:	bf 85 2f 80 00       	mov    $0x802f85,%edi
							putch(ch, putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	53                   	push   %ebx
  800a58:	50                   	push   %eax
  800a59:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a5b:	83 c7 01             	add    $0x1,%edi
  800a5e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	85 c0                	test   %eax,%eax
  800a67:	75 eb                	jne    800a54 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	e9 ed fe ff ff       	jmp    800961 <vprintfmt+0x446>
			putch(ch, putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	53                   	push   %ebx
  800a78:	6a 25                	push   $0x25
  800a7a:	ff d6                	call   *%esi
			break;
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	e9 dd fe ff ff       	jmp    800961 <vprintfmt+0x446>
			putch('%', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	53                   	push   %ebx
  800a88:	6a 25                	push   $0x25
  800a8a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 f8                	mov    %edi,%eax
  800a91:	eb 03                	jmp    800a96 <vprintfmt+0x57b>
  800a93:	83 e8 01             	sub    $0x1,%eax
  800a96:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a9a:	75 f7                	jne    800a93 <vprintfmt+0x578>
  800a9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a9f:	e9 bd fe ff ff       	jmp    800961 <vprintfmt+0x446>
}
  800aa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aa7:	5b                   	pop    %ebx
  800aa8:	5e                   	pop    %esi
  800aa9:	5f                   	pop    %edi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 18             	sub    $0x18,%esp
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ab8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800abb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800abf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 26                	je     800af3 <vsnprintf+0x47>
  800acd:	85 d2                	test   %edx,%edx
  800acf:	7e 22                	jle    800af3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ad1:	ff 75 14             	pushl  0x14(%ebp)
  800ad4:	ff 75 10             	pushl  0x10(%ebp)
  800ad7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ada:	50                   	push   %eax
  800adb:	68 e1 04 80 00       	push   $0x8004e1
  800ae0:	e8 36 fa ff ff       	call   80051b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aee:	83 c4 10             	add    $0x10,%esp
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    
		return -E_INVAL;
  800af3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800af8:	eb f7                	jmp    800af1 <vsnprintf+0x45>

00800afa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b00:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b03:	50                   	push   %eax
  800b04:	ff 75 10             	pushl  0x10(%ebp)
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 9a ff ff ff       	call   800aac <vsnprintf>
	va_end(ap);

	return rc;
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b23:	74 05                	je     800b2a <strlen+0x16>
		n++;
  800b25:	83 c0 01             	add    $0x1,%eax
  800b28:	eb f5                	jmp    800b1f <strlen+0xb>
	return n;
}
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	39 c2                	cmp    %eax,%edx
  800b3c:	74 0d                	je     800b4b <strnlen+0x1f>
  800b3e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b42:	74 05                	je     800b49 <strnlen+0x1d>
		n++;
  800b44:	83 c2 01             	add    $0x1,%edx
  800b47:	eb f1                	jmp    800b3a <strnlen+0xe>
  800b49:	89 d0                	mov    %edx,%eax
	return n;
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	53                   	push   %ebx
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b57:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b60:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b63:	83 c2 01             	add    $0x1,%edx
  800b66:	84 c9                	test   %cl,%cl
  800b68:	75 f2                	jne    800b5c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b6a:	5b                   	pop    %ebx
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	53                   	push   %ebx
  800b71:	83 ec 10             	sub    $0x10,%esp
  800b74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b77:	53                   	push   %ebx
  800b78:	e8 97 ff ff ff       	call   800b14 <strlen>
  800b7d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	01 d8                	add    %ebx,%eax
  800b85:	50                   	push   %eax
  800b86:	e8 c2 ff ff ff       	call   800b4d <strcpy>
	return dst;
}
  800b8b:	89 d8                	mov    %ebx,%eax
  800b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 c6                	mov    %eax,%esi
  800b9f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba2:	89 c2                	mov    %eax,%edx
  800ba4:	39 f2                	cmp    %esi,%edx
  800ba6:	74 11                	je     800bb9 <strncpy+0x27>
		*dst++ = *src;
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	0f b6 19             	movzbl (%ecx),%ebx
  800bae:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bb1:	80 fb 01             	cmp    $0x1,%bl
  800bb4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800bb7:	eb eb                	jmp    800ba4 <strncpy+0x12>
	}
	return ret;
}
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	8b 75 08             	mov    0x8(%ebp),%esi
  800bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc8:	8b 55 10             	mov    0x10(%ebp),%edx
  800bcb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bcd:	85 d2                	test   %edx,%edx
  800bcf:	74 21                	je     800bf2 <strlcpy+0x35>
  800bd1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bd5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	74 14                	je     800bef <strlcpy+0x32>
  800bdb:	0f b6 19             	movzbl (%ecx),%ebx
  800bde:	84 db                	test   %bl,%bl
  800be0:	74 0b                	je     800bed <strlcpy+0x30>
			*dst++ = *src++;
  800be2:	83 c1 01             	add    $0x1,%ecx
  800be5:	83 c2 01             	add    $0x1,%edx
  800be8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800beb:	eb ea                	jmp    800bd7 <strlcpy+0x1a>
  800bed:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf2:	29 f0                	sub    %esi,%eax
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c01:	0f b6 01             	movzbl (%ecx),%eax
  800c04:	84 c0                	test   %al,%al
  800c06:	74 0c                	je     800c14 <strcmp+0x1c>
  800c08:	3a 02                	cmp    (%edx),%al
  800c0a:	75 08                	jne    800c14 <strcmp+0x1c>
		p++, q++;
  800c0c:	83 c1 01             	add    $0x1,%ecx
  800c0f:	83 c2 01             	add    $0x1,%edx
  800c12:	eb ed                	jmp    800c01 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c14:	0f b6 c0             	movzbl %al,%eax
  800c17:	0f b6 12             	movzbl (%edx),%edx
  800c1a:	29 d0                	sub    %edx,%eax
}
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	53                   	push   %ebx
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 c3                	mov    %eax,%ebx
  800c2a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c2d:	eb 06                	jmp    800c35 <strncmp+0x17>
		n--, p++, q++;
  800c2f:	83 c0 01             	add    $0x1,%eax
  800c32:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c35:	39 d8                	cmp    %ebx,%eax
  800c37:	74 16                	je     800c4f <strncmp+0x31>
  800c39:	0f b6 08             	movzbl (%eax),%ecx
  800c3c:	84 c9                	test   %cl,%cl
  800c3e:	74 04                	je     800c44 <strncmp+0x26>
  800c40:	3a 0a                	cmp    (%edx),%cl
  800c42:	74 eb                	je     800c2f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c44:	0f b6 00             	movzbl (%eax),%eax
  800c47:	0f b6 12             	movzbl (%edx),%edx
  800c4a:	29 d0                	sub    %edx,%eax
}
  800c4c:	5b                   	pop    %ebx
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    
		return 0;
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	eb f6                	jmp    800c4c <strncmp+0x2e>

00800c56 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c60:	0f b6 10             	movzbl (%eax),%edx
  800c63:	84 d2                	test   %dl,%dl
  800c65:	74 09                	je     800c70 <strchr+0x1a>
		if (*s == c)
  800c67:	38 ca                	cmp    %cl,%dl
  800c69:	74 0a                	je     800c75 <strchr+0x1f>
	for (; *s; s++)
  800c6b:	83 c0 01             	add    $0x1,%eax
  800c6e:	eb f0                	jmp    800c60 <strchr+0xa>
			return (char *) s;
	return 0;
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c81:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c84:	38 ca                	cmp    %cl,%dl
  800c86:	74 09                	je     800c91 <strfind+0x1a>
  800c88:	84 d2                	test   %dl,%dl
  800c8a:	74 05                	je     800c91 <strfind+0x1a>
	for (; *s; s++)
  800c8c:	83 c0 01             	add    $0x1,%eax
  800c8f:	eb f0                	jmp    800c81 <strfind+0xa>
			break;
	return (char *) s;
}
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c9f:	85 c9                	test   %ecx,%ecx
  800ca1:	74 31                	je     800cd4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ca3:	89 f8                	mov    %edi,%eax
  800ca5:	09 c8                	or     %ecx,%eax
  800ca7:	a8 03                	test   $0x3,%al
  800ca9:	75 23                	jne    800cce <memset+0x3b>
		c &= 0xFF;
  800cab:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800caf:	89 d3                	mov    %edx,%ebx
  800cb1:	c1 e3 08             	shl    $0x8,%ebx
  800cb4:	89 d0                	mov    %edx,%eax
  800cb6:	c1 e0 18             	shl    $0x18,%eax
  800cb9:	89 d6                	mov    %edx,%esi
  800cbb:	c1 e6 10             	shl    $0x10,%esi
  800cbe:	09 f0                	or     %esi,%eax
  800cc0:	09 c2                	or     %eax,%edx
  800cc2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cc4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cc7:	89 d0                	mov    %edx,%eax
  800cc9:	fc                   	cld    
  800cca:	f3 ab                	rep stos %eax,%es:(%edi)
  800ccc:	eb 06                	jmp    800cd4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	fc                   	cld    
  800cd2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cd4:	89 f8                	mov    %edi,%eax
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce9:	39 c6                	cmp    %eax,%esi
  800ceb:	73 32                	jae    800d1f <memmove+0x44>
  800ced:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cf0:	39 c2                	cmp    %eax,%edx
  800cf2:	76 2b                	jbe    800d1f <memmove+0x44>
		s += n;
		d += n;
  800cf4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf7:	89 fe                	mov    %edi,%esi
  800cf9:	09 ce                	or     %ecx,%esi
  800cfb:	09 d6                	or     %edx,%esi
  800cfd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d03:	75 0e                	jne    800d13 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d05:	83 ef 04             	sub    $0x4,%edi
  800d08:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d0e:	fd                   	std    
  800d0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d11:	eb 09                	jmp    800d1c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d13:	83 ef 01             	sub    $0x1,%edi
  800d16:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d19:	fd                   	std    
  800d1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d1c:	fc                   	cld    
  800d1d:	eb 1a                	jmp    800d39 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d1f:	89 c2                	mov    %eax,%edx
  800d21:	09 ca                	or     %ecx,%edx
  800d23:	09 f2                	or     %esi,%edx
  800d25:	f6 c2 03             	test   $0x3,%dl
  800d28:	75 0a                	jne    800d34 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d2d:	89 c7                	mov    %eax,%edi
  800d2f:	fc                   	cld    
  800d30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d32:	eb 05                	jmp    800d39 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d34:	89 c7                	mov    %eax,%edi
  800d36:	fc                   	cld    
  800d37:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d43:	ff 75 10             	pushl  0x10(%ebp)
  800d46:	ff 75 0c             	pushl  0xc(%ebp)
  800d49:	ff 75 08             	pushl  0x8(%ebp)
  800d4c:	e8 8a ff ff ff       	call   800cdb <memmove>
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5e:	89 c6                	mov    %eax,%esi
  800d60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d63:	39 f0                	cmp    %esi,%eax
  800d65:	74 1c                	je     800d83 <memcmp+0x30>
		if (*s1 != *s2)
  800d67:	0f b6 08             	movzbl (%eax),%ecx
  800d6a:	0f b6 1a             	movzbl (%edx),%ebx
  800d6d:	38 d9                	cmp    %bl,%cl
  800d6f:	75 08                	jne    800d79 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d71:	83 c0 01             	add    $0x1,%eax
  800d74:	83 c2 01             	add    $0x1,%edx
  800d77:	eb ea                	jmp    800d63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d79:	0f b6 c1             	movzbl %cl,%eax
  800d7c:	0f b6 db             	movzbl %bl,%ebx
  800d7f:	29 d8                	sub    %ebx,%eax
  800d81:	eb 05                	jmp    800d88 <memcmp+0x35>
	}

	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d95:	89 c2                	mov    %eax,%edx
  800d97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d9a:	39 d0                	cmp    %edx,%eax
  800d9c:	73 09                	jae    800da7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d9e:	38 08                	cmp    %cl,(%eax)
  800da0:	74 05                	je     800da7 <memfind+0x1b>
	for (; s < ends; s++)
  800da2:	83 c0 01             	add    $0x1,%eax
  800da5:	eb f3                	jmp    800d9a <memfind+0xe>
			break;
	return (void *) s;
}
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db5:	eb 03                	jmp    800dba <strtol+0x11>
		s++;
  800db7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dba:	0f b6 01             	movzbl (%ecx),%eax
  800dbd:	3c 20                	cmp    $0x20,%al
  800dbf:	74 f6                	je     800db7 <strtol+0xe>
  800dc1:	3c 09                	cmp    $0x9,%al
  800dc3:	74 f2                	je     800db7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dc5:	3c 2b                	cmp    $0x2b,%al
  800dc7:	74 2a                	je     800df3 <strtol+0x4a>
	int neg = 0;
  800dc9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dce:	3c 2d                	cmp    $0x2d,%al
  800dd0:	74 2b                	je     800dfd <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dd8:	75 0f                	jne    800de9 <strtol+0x40>
  800dda:	80 39 30             	cmpb   $0x30,(%ecx)
  800ddd:	74 28                	je     800e07 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ddf:	85 db                	test   %ebx,%ebx
  800de1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de6:	0f 44 d8             	cmove  %eax,%ebx
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800df1:	eb 50                	jmp    800e43 <strtol+0x9a>
		s++;
  800df3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800df6:	bf 00 00 00 00       	mov    $0x0,%edi
  800dfb:	eb d5                	jmp    800dd2 <strtol+0x29>
		s++, neg = 1;
  800dfd:	83 c1 01             	add    $0x1,%ecx
  800e00:	bf 01 00 00 00       	mov    $0x1,%edi
  800e05:	eb cb                	jmp    800dd2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e07:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e0b:	74 0e                	je     800e1b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800e0d:	85 db                	test   %ebx,%ebx
  800e0f:	75 d8                	jne    800de9 <strtol+0x40>
		s++, base = 8;
  800e11:	83 c1 01             	add    $0x1,%ecx
  800e14:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e19:	eb ce                	jmp    800de9 <strtol+0x40>
		s += 2, base = 16;
  800e1b:	83 c1 02             	add    $0x2,%ecx
  800e1e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e23:	eb c4                	jmp    800de9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e25:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e28:	89 f3                	mov    %esi,%ebx
  800e2a:	80 fb 19             	cmp    $0x19,%bl
  800e2d:	77 29                	ja     800e58 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e2f:	0f be d2             	movsbl %dl,%edx
  800e32:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e38:	7d 30                	jge    800e6a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e3a:	83 c1 01             	add    $0x1,%ecx
  800e3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e41:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e43:	0f b6 11             	movzbl (%ecx),%edx
  800e46:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e49:	89 f3                	mov    %esi,%ebx
  800e4b:	80 fb 09             	cmp    $0x9,%bl
  800e4e:	77 d5                	ja     800e25 <strtol+0x7c>
			dig = *s - '0';
  800e50:	0f be d2             	movsbl %dl,%edx
  800e53:	83 ea 30             	sub    $0x30,%edx
  800e56:	eb dd                	jmp    800e35 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e58:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e5b:	89 f3                	mov    %esi,%ebx
  800e5d:	80 fb 19             	cmp    $0x19,%bl
  800e60:	77 08                	ja     800e6a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e62:	0f be d2             	movsbl %dl,%edx
  800e65:	83 ea 37             	sub    $0x37,%edx
  800e68:	eb cb                	jmp    800e35 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6e:	74 05                	je     800e75 <strtol+0xcc>
		*endptr = (char *) s;
  800e70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e73:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e75:	89 c2                	mov    %eax,%edx
  800e77:	f7 da                	neg    %edx
  800e79:	85 ff                	test   %edi,%edi
  800e7b:	0f 45 c2             	cmovne %edx,%eax
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e89:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	89 c3                	mov    %eax,%ebx
  800e96:	89 c7                	mov    %eax,%edi
  800e98:	89 c6                	mov    %eax,%esi
  800e9a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  800eac:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb1:	89 d1                	mov    %edx,%ecx
  800eb3:	89 d3                	mov    %edx,%ebx
  800eb5:	89 d7                	mov    %edx,%edi
  800eb7:	89 d6                	mov    %edx,%esi
  800eb9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ed6:	89 cb                	mov    %ecx,%ebx
  800ed8:	89 cf                	mov    %ecx,%edi
  800eda:	89 ce                	mov    %ecx,%esi
  800edc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7f 08                	jg     800eea <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	6a 03                	push   $0x3
  800ef0:	68 a8 31 80 00       	push   $0x8031a8
  800ef5:	6a 43                	push   $0x43
  800ef7:	68 c5 31 80 00       	push   $0x8031c5
  800efc:	e8 f7 f3 ff ff       	call   8002f8 <_panic>

00800f01 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f07:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0c:	b8 02 00 00 00       	mov    $0x2,%eax
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 d3                	mov    %edx,%ebx
  800f15:	89 d7                	mov    %edx,%edi
  800f17:	89 d6                	mov    %edx,%esi
  800f19:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_yield>:

void
sys_yield(void)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f26:	ba 00 00 00 00       	mov    $0x0,%edx
  800f2b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f30:	89 d1                	mov    %edx,%ecx
  800f32:	89 d3                	mov    %edx,%ebx
  800f34:	89 d7                	mov    %edx,%edi
  800f36:	89 d6                	mov    %edx,%esi
  800f38:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	be 00 00 00 00       	mov    $0x0,%esi
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f53:	b8 04 00 00 00       	mov    $0x4,%eax
  800f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5b:	89 f7                	mov    %esi,%edi
  800f5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7f 08                	jg     800f6b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800f6f:	6a 04                	push   $0x4
  800f71:	68 a8 31 80 00       	push   $0x8031a8
  800f76:	6a 43                	push   $0x43
  800f78:	68 c5 31 80 00       	push   $0x8031c5
  800f7d:	e8 76 f3 ff ff       	call   8002f8 <_panic>

00800f82 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
  800f88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	b8 05 00 00 00       	mov    $0x5,%eax
  800f96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800f9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa1:	85 c0                	test   %eax,%eax
  800fa3:	7f 08                	jg     800fad <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	50                   	push   %eax
  800fb1:	6a 05                	push   $0x5
  800fb3:	68 a8 31 80 00       	push   $0x8031a8
  800fb8:	6a 43                	push   $0x43
  800fba:	68 c5 31 80 00       	push   $0x8031c5
  800fbf:	e8 34 f3 ff ff       	call   8002f8 <_panic>

00800fc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
  800fca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	b8 06 00 00 00       	mov    $0x6,%eax
  800fdd:	89 df                	mov    %ebx,%edi
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	7f 08                	jg     800fef <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5f                   	pop    %edi
  800fed:	5d                   	pop    %ebp
  800fee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	50                   	push   %eax
  800ff3:	6a 06                	push   $0x6
  800ff5:	68 a8 31 80 00       	push   $0x8031a8
  800ffa:	6a 43                	push   $0x43
  800ffc:	68 c5 31 80 00       	push   $0x8031c5
  801001:	e8 f2 f2 ff ff       	call   8002f8 <_panic>

00801006 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	57                   	push   %edi
  80100a:	56                   	push   %esi
  80100b:	53                   	push   %ebx
  80100c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80100f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101a:	b8 08 00 00 00       	mov    $0x8,%eax
  80101f:	89 df                	mov    %ebx,%edi
  801021:	89 de                	mov    %ebx,%esi
  801023:	cd 30                	int    $0x30
	if(check && ret > 0)
  801025:	85 c0                	test   %eax,%eax
  801027:	7f 08                	jg     801031 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	50                   	push   %eax
  801035:	6a 08                	push   $0x8
  801037:	68 a8 31 80 00       	push   $0x8031a8
  80103c:	6a 43                	push   $0x43
  80103e:	68 c5 31 80 00       	push   $0x8031c5
  801043:	e8 b0 f2 ff ff       	call   8002f8 <_panic>

00801048 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	57                   	push   %edi
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
  80104e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105c:	b8 09 00 00 00       	mov    $0x9,%eax
  801061:	89 df                	mov    %ebx,%edi
  801063:	89 de                	mov    %ebx,%esi
  801065:	cd 30                	int    $0x30
	if(check && ret > 0)
  801067:	85 c0                	test   %eax,%eax
  801069:	7f 08                	jg     801073 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80106b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	50                   	push   %eax
  801077:	6a 09                	push   $0x9
  801079:	68 a8 31 80 00       	push   $0x8031a8
  80107e:	6a 43                	push   $0x43
  801080:	68 c5 31 80 00       	push   $0x8031c5
  801085:	e8 6e f2 ff ff       	call   8002f8 <_panic>

0080108a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
  801090:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801093:	bb 00 00 00 00       	mov    $0x0,%ebx
  801098:	8b 55 08             	mov    0x8(%ebp),%edx
  80109b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a3:	89 df                	mov    %ebx,%edi
  8010a5:	89 de                	mov    %ebx,%esi
  8010a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	7f 08                	jg     8010b5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b5:	83 ec 0c             	sub    $0xc,%esp
  8010b8:	50                   	push   %eax
  8010b9:	6a 0a                	push   $0xa
  8010bb:	68 a8 31 80 00       	push   $0x8031a8
  8010c0:	6a 43                	push   $0x43
  8010c2:	68 c5 31 80 00       	push   $0x8031c5
  8010c7:	e8 2c f2 ff ff       	call   8002f8 <_panic>

008010cc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010dd:	be 00 00 00 00       	mov    $0x0,%esi
  8010e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010ea:	5b                   	pop    %ebx
  8010eb:	5e                   	pop    %esi
  8010ec:	5f                   	pop    %edi
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	57                   	push   %edi
  8010f3:	56                   	push   %esi
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	b8 0d 00 00 00       	mov    $0xd,%eax
  801105:	89 cb                	mov    %ecx,%ebx
  801107:	89 cf                	mov    %ecx,%edi
  801109:	89 ce                	mov    %ecx,%esi
  80110b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110d:	85 c0                	test   %eax,%eax
  80110f:	7f 08                	jg     801119 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5f                   	pop    %edi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	50                   	push   %eax
  80111d:	6a 0d                	push   $0xd
  80111f:	68 a8 31 80 00       	push   $0x8031a8
  801124:	6a 43                	push   $0x43
  801126:	68 c5 31 80 00       	push   $0x8031c5
  80112b:	e8 c8 f1 ff ff       	call   8002f8 <_panic>

00801130 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	57                   	push   %edi
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
	asm volatile("int %1\n"
  801136:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801141:	b8 0e 00 00 00       	mov    $0xe,%eax
  801146:	89 df                	mov    %ebx,%edi
  801148:	89 de                	mov    %ebx,%esi
  80114a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
	asm volatile("int %1\n"
  801157:	b9 00 00 00 00       	mov    $0x0,%ecx
  80115c:	8b 55 08             	mov    0x8(%ebp),%edx
  80115f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801164:	89 cb                	mov    %ecx,%ebx
  801166:	89 cf                	mov    %ecx,%edi
  801168:	89 ce                	mov    %ecx,%esi
  80116a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80116c:	5b                   	pop    %ebx
  80116d:	5e                   	pop    %esi
  80116e:	5f                   	pop    %edi
  80116f:	5d                   	pop    %ebp
  801170:	c3                   	ret    

00801171 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
	asm volatile("int %1\n"
  801177:	ba 00 00 00 00       	mov    $0x0,%edx
  80117c:	b8 10 00 00 00       	mov    $0x10,%eax
  801181:	89 d1                	mov    %edx,%ecx
  801183:	89 d3                	mov    %edx,%ebx
  801185:	89 d7                	mov    %edx,%edi
  801187:	89 d6                	mov    %edx,%esi
  801189:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	57                   	push   %edi
  801194:	56                   	push   %esi
  801195:	53                   	push   %ebx
	asm volatile("int %1\n"
  801196:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119b:	8b 55 08             	mov    0x8(%ebp),%edx
  80119e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a1:	b8 11 00 00 00       	mov    $0x11,%eax
  8011a6:	89 df                	mov    %ebx,%edi
  8011a8:	89 de                	mov    %ebx,%esi
  8011aa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    

008011b1 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
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
  8011c2:	b8 12 00 00 00       	mov    $0x12,%eax
  8011c7:	89 df                	mov    %ebx,%edi
  8011c9:	89 de                	mov    %ebx,%esi
  8011cb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011cd:	5b                   	pop    %ebx
  8011ce:	5e                   	pop    %esi
  8011cf:	5f                   	pop    %edi
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    

008011d2 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	57                   	push   %edi
  8011d6:	56                   	push   %esi
  8011d7:	53                   	push   %ebx
  8011d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e6:	b8 13 00 00 00       	mov    $0x13,%eax
  8011eb:	89 df                	mov    %ebx,%edi
  8011ed:	89 de                	mov    %ebx,%esi
  8011ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	7f 08                	jg     8011fd <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f8:	5b                   	pop    %ebx
  8011f9:	5e                   	pop    %esi
  8011fa:	5f                   	pop    %edi
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fd:	83 ec 0c             	sub    $0xc,%esp
  801200:	50                   	push   %eax
  801201:	6a 13                	push   $0x13
  801203:	68 a8 31 80 00       	push   $0x8031a8
  801208:	6a 43                	push   $0x43
  80120a:	68 c5 31 80 00       	push   $0x8031c5
  80120f:	e8 e4 f0 ff ff       	call   8002f8 <_panic>

00801214 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	57                   	push   %edi
  801218:	56                   	push   %esi
  801219:	53                   	push   %ebx
	asm volatile("int %1\n"
  80121a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	b8 14 00 00 00       	mov    $0x14,%eax
  801227:	89 cb                	mov    %ecx,%ebx
  801229:	89 cf                	mov    %ecx,%edi
  80122b:	89 ce                	mov    %ecx,%esi
  80122d:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    

00801234 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	53                   	push   %ebx
  801238:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80123b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801242:	f6 c5 04             	test   $0x4,%ch
  801245:	75 45                	jne    80128c <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801247:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80124e:	83 e1 07             	and    $0x7,%ecx
  801251:	83 f9 07             	cmp    $0x7,%ecx
  801254:	74 6f                	je     8012c5 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801256:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80125d:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801263:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801269:	0f 84 b6 00 00 00    	je     801325 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80126f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801276:	83 e1 05             	and    $0x5,%ecx
  801279:	83 f9 05             	cmp    $0x5,%ecx
  80127c:	0f 84 d7 00 00 00    	je     801359 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
  801287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80128c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801293:	c1 e2 0c             	shl    $0xc,%edx
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80129f:	51                   	push   %ecx
  8012a0:	52                   	push   %edx
  8012a1:	50                   	push   %eax
  8012a2:	52                   	push   %edx
  8012a3:	6a 00                	push   $0x0
  8012a5:	e8 d8 fc ff ff       	call   800f82 <sys_page_map>
		if(r < 0)
  8012aa:	83 c4 20             	add    $0x20,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	79 d1                	jns    801282 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012b1:	83 ec 04             	sub    $0x4,%esp
  8012b4:	68 d3 31 80 00       	push   $0x8031d3
  8012b9:	6a 54                	push   $0x54
  8012bb:	68 e9 31 80 00       	push   $0x8031e9
  8012c0:	e8 33 f0 ff ff       	call   8002f8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012c5:	89 d3                	mov    %edx,%ebx
  8012c7:	c1 e3 0c             	shl    $0xc,%ebx
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	68 05 08 00 00       	push   $0x805
  8012d2:	53                   	push   %ebx
  8012d3:	50                   	push   %eax
  8012d4:	53                   	push   %ebx
  8012d5:	6a 00                	push   $0x0
  8012d7:	e8 a6 fc ff ff       	call   800f82 <sys_page_map>
		if(r < 0)
  8012dc:	83 c4 20             	add    $0x20,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	78 2e                	js     801311 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	68 05 08 00 00       	push   $0x805
  8012eb:	53                   	push   %ebx
  8012ec:	6a 00                	push   $0x0
  8012ee:	53                   	push   %ebx
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 8c fc ff ff       	call   800f82 <sys_page_map>
		if(r < 0)
  8012f6:	83 c4 20             	add    $0x20,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	79 85                	jns    801282 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	68 d3 31 80 00       	push   $0x8031d3
  801305:	6a 5f                	push   $0x5f
  801307:	68 e9 31 80 00       	push   $0x8031e9
  80130c:	e8 e7 ef ff ff       	call   8002f8 <_panic>
			panic("sys_page_map() panic\n");
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	68 d3 31 80 00       	push   $0x8031d3
  801319:	6a 5b                	push   $0x5b
  80131b:	68 e9 31 80 00       	push   $0x8031e9
  801320:	e8 d3 ef ff ff       	call   8002f8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801325:	c1 e2 0c             	shl    $0xc,%edx
  801328:	83 ec 0c             	sub    $0xc,%esp
  80132b:	68 05 08 00 00       	push   $0x805
  801330:	52                   	push   %edx
  801331:	50                   	push   %eax
  801332:	52                   	push   %edx
  801333:	6a 00                	push   $0x0
  801335:	e8 48 fc ff ff       	call   800f82 <sys_page_map>
		if(r < 0)
  80133a:	83 c4 20             	add    $0x20,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	0f 89 3d ff ff ff    	jns    801282 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	68 d3 31 80 00       	push   $0x8031d3
  80134d:	6a 66                	push   $0x66
  80134f:	68 e9 31 80 00       	push   $0x8031e9
  801354:	e8 9f ef ff ff       	call   8002f8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801359:	c1 e2 0c             	shl    $0xc,%edx
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	6a 05                	push   $0x5
  801361:	52                   	push   %edx
  801362:	50                   	push   %eax
  801363:	52                   	push   %edx
  801364:	6a 00                	push   $0x0
  801366:	e8 17 fc ff ff       	call   800f82 <sys_page_map>
		if(r < 0)
  80136b:	83 c4 20             	add    $0x20,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	0f 89 0c ff ff ff    	jns    801282 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	68 d3 31 80 00       	push   $0x8031d3
  80137e:	6a 6d                	push   $0x6d
  801380:	68 e9 31 80 00       	push   $0x8031e9
  801385:	e8 6e ef ff ff       	call   8002f8 <_panic>

0080138a <pgfault>:
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	83 ec 04             	sub    $0x4,%esp
  801391:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801394:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801396:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80139a:	0f 84 99 00 00 00    	je     801439 <pgfault+0xaf>
  8013a0:	89 c2                	mov    %eax,%edx
  8013a2:	c1 ea 16             	shr    $0x16,%edx
  8013a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ac:	f6 c2 01             	test   $0x1,%dl
  8013af:	0f 84 84 00 00 00    	je     801439 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8013b5:	89 c2                	mov    %eax,%edx
  8013b7:	c1 ea 0c             	shr    $0xc,%edx
  8013ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c1:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8013c7:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8013cd:	75 6a                	jne    801439 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8013cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d4:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	6a 07                	push   $0x7
  8013db:	68 00 f0 7f 00       	push   $0x7ff000
  8013e0:	6a 00                	push   $0x0
  8013e2:	e8 58 fb ff ff       	call   800f3f <sys_page_alloc>
	if(ret < 0)
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 5f                	js     80144d <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	68 00 10 00 00       	push   $0x1000
  8013f6:	53                   	push   %ebx
  8013f7:	68 00 f0 7f 00       	push   $0x7ff000
  8013fc:	e8 3c f9 ff ff       	call   800d3d <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801401:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801408:	53                   	push   %ebx
  801409:	6a 00                	push   $0x0
  80140b:	68 00 f0 7f 00       	push   $0x7ff000
  801410:	6a 00                	push   $0x0
  801412:	e8 6b fb ff ff       	call   800f82 <sys_page_map>
	if(ret < 0)
  801417:	83 c4 20             	add    $0x20,%esp
  80141a:	85 c0                	test   %eax,%eax
  80141c:	78 43                	js     801461 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	68 00 f0 7f 00       	push   $0x7ff000
  801426:	6a 00                	push   $0x0
  801428:	e8 97 fb ff ff       	call   800fc4 <sys_page_unmap>
	if(ret < 0)
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 41                	js     801475 <pgfault+0xeb>
}
  801434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801437:	c9                   	leave  
  801438:	c3                   	ret    
		panic("panic at pgfault()\n");
  801439:	83 ec 04             	sub    $0x4,%esp
  80143c:	68 f4 31 80 00       	push   $0x8031f4
  801441:	6a 26                	push   $0x26
  801443:	68 e9 31 80 00       	push   $0x8031e9
  801448:	e8 ab ee ff ff       	call   8002f8 <_panic>
		panic("panic in sys_page_alloc()\n");
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	68 08 32 80 00       	push   $0x803208
  801455:	6a 31                	push   $0x31
  801457:	68 e9 31 80 00       	push   $0x8031e9
  80145c:	e8 97 ee ff ff       	call   8002f8 <_panic>
		panic("panic in sys_page_map()\n");
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 23 32 80 00       	push   $0x803223
  801469:	6a 36                	push   $0x36
  80146b:	68 e9 31 80 00       	push   $0x8031e9
  801470:	e8 83 ee ff ff       	call   8002f8 <_panic>
		panic("panic in sys_page_unmap()\n");
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 3c 32 80 00       	push   $0x80323c
  80147d:	6a 39                	push   $0x39
  80147f:	68 e9 31 80 00       	push   $0x8031e9
  801484:	e8 6f ee ff ff       	call   8002f8 <_panic>

00801489 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	57                   	push   %edi
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
  80148f:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801492:	68 8a 13 80 00       	push   $0x80138a
  801497:	e8 db 13 00 00       	call   802877 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80149c:	b8 07 00 00 00       	mov    $0x7,%eax
  8014a1:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 2a                	js     8014d4 <fork+0x4b>
  8014aa:	89 c6                	mov    %eax,%esi
  8014ac:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ae:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014b3:	75 4b                	jne    801500 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014b5:	e8 47 fa ff ff       	call   800f01 <sys_getenvid>
  8014ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014bf:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8014c5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014ca:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014cf:	e9 90 00 00 00       	jmp    801564 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	68 58 32 80 00       	push   $0x803258
  8014dc:	68 8c 00 00 00       	push   $0x8c
  8014e1:	68 e9 31 80 00       	push   $0x8031e9
  8014e6:	e8 0d ee ff ff       	call   8002f8 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8014eb:	89 f8                	mov    %edi,%eax
  8014ed:	e8 42 fd ff ff       	call   801234 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014f8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014fe:	74 26                	je     801526 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801500:	89 d8                	mov    %ebx,%eax
  801502:	c1 e8 16             	shr    $0x16,%eax
  801505:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80150c:	a8 01                	test   $0x1,%al
  80150e:	74 e2                	je     8014f2 <fork+0x69>
  801510:	89 da                	mov    %ebx,%edx
  801512:	c1 ea 0c             	shr    $0xc,%edx
  801515:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80151c:	83 e0 05             	and    $0x5,%eax
  80151f:	83 f8 05             	cmp    $0x5,%eax
  801522:	75 ce                	jne    8014f2 <fork+0x69>
  801524:	eb c5                	jmp    8014eb <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	6a 07                	push   $0x7
  80152b:	68 00 f0 bf ee       	push   $0xeebff000
  801530:	56                   	push   %esi
  801531:	e8 09 fa ff ff       	call   800f3f <sys_page_alloc>
	if(ret < 0)
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	78 31                	js     80156e <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	68 e6 28 80 00       	push   $0x8028e6
  801545:	56                   	push   %esi
  801546:	e8 3f fb ff ff       	call   80108a <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	85 c0                	test   %eax,%eax
  801550:	78 33                	js     801585 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	6a 02                	push   $0x2
  801557:	56                   	push   %esi
  801558:	e8 a9 fa ff ff       	call   801006 <sys_env_set_status>
	if(ret < 0)
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 38                	js     80159c <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801564:	89 f0                	mov    %esi,%eax
  801566:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5f                   	pop    %edi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	68 08 32 80 00       	push   $0x803208
  801576:	68 98 00 00 00       	push   $0x98
  80157b:	68 e9 31 80 00       	push   $0x8031e9
  801580:	e8 73 ed ff ff       	call   8002f8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	68 7c 32 80 00       	push   $0x80327c
  80158d:	68 9b 00 00 00       	push   $0x9b
  801592:	68 e9 31 80 00       	push   $0x8031e9
  801597:	e8 5c ed ff ff       	call   8002f8 <_panic>
		panic("panic in sys_env_set_status()\n");
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	68 a4 32 80 00       	push   $0x8032a4
  8015a4:	68 9e 00 00 00       	push   $0x9e
  8015a9:	68 e9 31 80 00       	push   $0x8031e9
  8015ae:	e8 45 ed ff ff       	call   8002f8 <_panic>

008015b3 <sfork>:

// Challenge!
int
sfork(void)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	57                   	push   %edi
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8015bc:	68 8a 13 80 00       	push   $0x80138a
  8015c1:	e8 b1 12 00 00       	call   802877 <set_pgfault_handler>
  8015c6:	b8 07 00 00 00       	mov    $0x7,%eax
  8015cb:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 2a                	js     8015fe <sfork+0x4b>
  8015d4:	89 c7                	mov    %eax,%edi
  8015d6:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015d8:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8015dd:	75 58                	jne    801637 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8015df:	e8 1d f9 ff ff       	call   800f01 <sys_getenvid>
  8015e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015e9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015f4:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015f9:	e9 d4 00 00 00       	jmp    8016d2 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 58 32 80 00       	push   $0x803258
  801606:	68 af 00 00 00       	push   $0xaf
  80160b:	68 e9 31 80 00       	push   $0x8031e9
  801610:	e8 e3 ec ff ff       	call   8002f8 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801615:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80161a:	89 f0                	mov    %esi,%eax
  80161c:	e8 13 fc ff ff       	call   801234 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801621:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801627:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80162d:	77 65                	ja     801694 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80162f:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801635:	74 de                	je     801615 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801637:	89 d8                	mov    %ebx,%eax
  801639:	c1 e8 16             	shr    $0x16,%eax
  80163c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801643:	a8 01                	test   $0x1,%al
  801645:	74 da                	je     801621 <sfork+0x6e>
  801647:	89 da                	mov    %ebx,%edx
  801649:	c1 ea 0c             	shr    $0xc,%edx
  80164c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801653:	83 e0 05             	and    $0x5,%eax
  801656:	83 f8 05             	cmp    $0x5,%eax
  801659:	75 c6                	jne    801621 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80165b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801662:	c1 e2 0c             	shl    $0xc,%edx
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	83 e0 07             	and    $0x7,%eax
  80166b:	50                   	push   %eax
  80166c:	52                   	push   %edx
  80166d:	56                   	push   %esi
  80166e:	52                   	push   %edx
  80166f:	6a 00                	push   $0x0
  801671:	e8 0c f9 ff ff       	call   800f82 <sys_page_map>
  801676:	83 c4 20             	add    $0x20,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	74 a4                	je     801621 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	68 d3 31 80 00       	push   $0x8031d3
  801685:	68 ba 00 00 00       	push   $0xba
  80168a:	68 e9 31 80 00       	push   $0x8031e9
  80168f:	e8 64 ec ff ff       	call   8002f8 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	6a 07                	push   $0x7
  801699:	68 00 f0 bf ee       	push   $0xeebff000
  80169e:	57                   	push   %edi
  80169f:	e8 9b f8 ff ff       	call   800f3f <sys_page_alloc>
	if(ret < 0)
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 31                	js     8016dc <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8016ab:	83 ec 08             	sub    $0x8,%esp
  8016ae:	68 e6 28 80 00       	push   $0x8028e6
  8016b3:	57                   	push   %edi
  8016b4:	e8 d1 f9 ff ff       	call   80108a <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 33                	js     8016f3 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	6a 02                	push   $0x2
  8016c5:	57                   	push   %edi
  8016c6:	e8 3b f9 ff ff       	call   801006 <sys_env_set_status>
	if(ret < 0)
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	78 38                	js     80170a <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8016d2:	89 f8                	mov    %edi,%eax
  8016d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d7:	5b                   	pop    %ebx
  8016d8:	5e                   	pop    %esi
  8016d9:	5f                   	pop    %edi
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 08 32 80 00       	push   $0x803208
  8016e4:	68 c0 00 00 00       	push   $0xc0
  8016e9:	68 e9 31 80 00       	push   $0x8031e9
  8016ee:	e8 05 ec ff ff       	call   8002f8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	68 7c 32 80 00       	push   $0x80327c
  8016fb:	68 c3 00 00 00       	push   $0xc3
  801700:	68 e9 31 80 00       	push   $0x8031e9
  801705:	e8 ee eb ff ff       	call   8002f8 <_panic>
		panic("panic in sys_env_set_status()\n");
  80170a:	83 ec 04             	sub    $0x4,%esp
  80170d:	68 a4 32 80 00       	push   $0x8032a4
  801712:	68 c6 00 00 00       	push   $0xc6
  801717:	68 e9 31 80 00       	push   $0x8031e9
  80171c:	e8 d7 eb ff ff       	call   8002f8 <_panic>

00801721 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	05 00 00 00 30       	add    $0x30000000,%eax
  80172c:	c1 e8 0c             	shr    $0xc,%eax
}
  80172f:	5d                   	pop    %ebp
  801730:	c3                   	ret    

00801731 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80173c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801741:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    

00801748 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801750:	89 c2                	mov    %eax,%edx
  801752:	c1 ea 16             	shr    $0x16,%edx
  801755:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80175c:	f6 c2 01             	test   $0x1,%dl
  80175f:	74 2d                	je     80178e <fd_alloc+0x46>
  801761:	89 c2                	mov    %eax,%edx
  801763:	c1 ea 0c             	shr    $0xc,%edx
  801766:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80176d:	f6 c2 01             	test   $0x1,%dl
  801770:	74 1c                	je     80178e <fd_alloc+0x46>
  801772:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801777:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80177c:	75 d2                	jne    801750 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801787:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80178c:	eb 0a                	jmp    801798 <fd_alloc+0x50>
			*fd_store = fd;
  80178e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801791:	89 01                	mov    %eax,(%ecx)
			return 0;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017a0:	83 f8 1f             	cmp    $0x1f,%eax
  8017a3:	77 30                	ja     8017d5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017a5:	c1 e0 0c             	shl    $0xc,%eax
  8017a8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017ad:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017b3:	f6 c2 01             	test   $0x1,%dl
  8017b6:	74 24                	je     8017dc <fd_lookup+0x42>
  8017b8:	89 c2                	mov    %eax,%edx
  8017ba:	c1 ea 0c             	shr    $0xc,%edx
  8017bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c4:	f6 c2 01             	test   $0x1,%dl
  8017c7:	74 1a                	je     8017e3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	89 02                	mov    %eax,(%edx)
	return 0;
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    
		return -E_INVAL;
  8017d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017da:	eb f7                	jmp    8017d3 <fd_lookup+0x39>
		return -E_INVAL;
  8017dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e1:	eb f0                	jmp    8017d3 <fd_lookup+0x39>
  8017e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e8:	eb e9                	jmp    8017d3 <fd_lookup+0x39>

008017ea <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f8:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017fd:	39 08                	cmp    %ecx,(%eax)
  8017ff:	74 38                	je     801839 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801801:	83 c2 01             	add    $0x1,%edx
  801804:	8b 04 95 40 33 80 00 	mov    0x803340(,%edx,4),%eax
  80180b:	85 c0                	test   %eax,%eax
  80180d:	75 ee                	jne    8017fd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80180f:	a1 08 50 80 00       	mov    0x805008,%eax
  801814:	8b 40 48             	mov    0x48(%eax),%eax
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	51                   	push   %ecx
  80181b:	50                   	push   %eax
  80181c:	68 c4 32 80 00       	push   $0x8032c4
  801821:	e8 c8 eb ff ff       	call   8003ee <cprintf>
	*dev = 0;
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    
			*dev = devtab[i];
  801839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
  801843:	eb f2                	jmp    801837 <dev_lookup+0x4d>

00801845 <fd_close>:
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	57                   	push   %edi
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	83 ec 24             	sub    $0x24,%esp
  80184e:	8b 75 08             	mov    0x8(%ebp),%esi
  801851:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801854:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801857:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801858:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80185e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801861:	50                   	push   %eax
  801862:	e8 33 ff ff ff       	call   80179a <fd_lookup>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 05                	js     801875 <fd_close+0x30>
	    || fd != fd2)
  801870:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801873:	74 16                	je     80188b <fd_close+0x46>
		return (must_exist ? r : 0);
  801875:	89 f8                	mov    %edi,%eax
  801877:	84 c0                	test   %al,%al
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
  80187e:	0f 44 d8             	cmove  %eax,%ebx
}
  801881:	89 d8                	mov    %ebx,%eax
  801883:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801886:	5b                   	pop    %ebx
  801887:	5e                   	pop    %esi
  801888:	5f                   	pop    %edi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	ff 36                	pushl  (%esi)
  801894:	e8 51 ff ff ff       	call   8017ea <dev_lookup>
  801899:	89 c3                	mov    %eax,%ebx
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 1a                	js     8018bc <fd_close+0x77>
		if (dev->dev_close)
  8018a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018a8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	74 0b                	je     8018bc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018b1:	83 ec 0c             	sub    $0xc,%esp
  8018b4:	56                   	push   %esi
  8018b5:	ff d0                	call   *%eax
  8018b7:	89 c3                	mov    %eax,%ebx
  8018b9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	56                   	push   %esi
  8018c0:	6a 00                	push   $0x0
  8018c2:	e8 fd f6 ff ff       	call   800fc4 <sys_page_unmap>
	return r;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	eb b5                	jmp    801881 <fd_close+0x3c>

008018cc <close>:

int
close(int fdnum)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d5:	50                   	push   %eax
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	e8 bc fe ff ff       	call   80179a <fd_lookup>
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	79 02                	jns    8018e7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    
		return fd_close(fd, 1);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	6a 01                	push   $0x1
  8018ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ef:	e8 51 ff ff ff       	call   801845 <fd_close>
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	eb ec                	jmp    8018e5 <close+0x19>

008018f9 <close_all>:

void
close_all(void)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801900:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801905:	83 ec 0c             	sub    $0xc,%esp
  801908:	53                   	push   %ebx
  801909:	e8 be ff ff ff       	call   8018cc <close>
	for (i = 0; i < MAXFD; i++)
  80190e:	83 c3 01             	add    $0x1,%ebx
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	83 fb 20             	cmp    $0x20,%ebx
  801917:	75 ec                	jne    801905 <close_all+0xc>
}
  801919:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	57                   	push   %edi
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801927:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80192a:	50                   	push   %eax
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	e8 67 fe ff ff       	call   80179a <fd_lookup>
  801933:	89 c3                	mov    %eax,%ebx
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	0f 88 81 00 00 00    	js     8019c1 <dup+0xa3>
		return r;
	close(newfdnum);
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	e8 81 ff ff ff       	call   8018cc <close>

	newfd = INDEX2FD(newfdnum);
  80194b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80194e:	c1 e6 0c             	shl    $0xc,%esi
  801951:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801957:	83 c4 04             	add    $0x4,%esp
  80195a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80195d:	e8 cf fd ff ff       	call   801731 <fd2data>
  801962:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801964:	89 34 24             	mov    %esi,(%esp)
  801967:	e8 c5 fd ff ff       	call   801731 <fd2data>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801971:	89 d8                	mov    %ebx,%eax
  801973:	c1 e8 16             	shr    $0x16,%eax
  801976:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80197d:	a8 01                	test   $0x1,%al
  80197f:	74 11                	je     801992 <dup+0x74>
  801981:	89 d8                	mov    %ebx,%eax
  801983:	c1 e8 0c             	shr    $0xc,%eax
  801986:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80198d:	f6 c2 01             	test   $0x1,%dl
  801990:	75 39                	jne    8019cb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801992:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801995:	89 d0                	mov    %edx,%eax
  801997:	c1 e8 0c             	shr    $0xc,%eax
  80199a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8019a9:	50                   	push   %eax
  8019aa:	56                   	push   %esi
  8019ab:	6a 00                	push   $0x0
  8019ad:	52                   	push   %edx
  8019ae:	6a 00                	push   $0x0
  8019b0:	e8 cd f5 ff ff       	call   800f82 <sys_page_map>
  8019b5:	89 c3                	mov    %eax,%ebx
  8019b7:	83 c4 20             	add    $0x20,%esp
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 31                	js     8019ef <dup+0xd1>
		goto err;

	return newfdnum;
  8019be:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019c1:	89 d8                	mov    %ebx,%eax
  8019c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c6:	5b                   	pop    %ebx
  8019c7:	5e                   	pop    %esi
  8019c8:	5f                   	pop    %edi
  8019c9:	5d                   	pop    %ebp
  8019ca:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019d2:	83 ec 0c             	sub    $0xc,%esp
  8019d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8019da:	50                   	push   %eax
  8019db:	57                   	push   %edi
  8019dc:	6a 00                	push   $0x0
  8019de:	53                   	push   %ebx
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 9c f5 ff ff       	call   800f82 <sys_page_map>
  8019e6:	89 c3                	mov    %eax,%ebx
  8019e8:	83 c4 20             	add    $0x20,%esp
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	79 a3                	jns    801992 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	56                   	push   %esi
  8019f3:	6a 00                	push   $0x0
  8019f5:	e8 ca f5 ff ff       	call   800fc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019fa:	83 c4 08             	add    $0x8,%esp
  8019fd:	57                   	push   %edi
  8019fe:	6a 00                	push   $0x0
  801a00:	e8 bf f5 ff ff       	call   800fc4 <sys_page_unmap>
	return r;
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	eb b7                	jmp    8019c1 <dup+0xa3>

00801a0a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 1c             	sub    $0x1c,%esp
  801a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a14:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a17:	50                   	push   %eax
  801a18:	53                   	push   %ebx
  801a19:	e8 7c fd ff ff       	call   80179a <fd_lookup>
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 3f                	js     801a64 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2b:	50                   	push   %eax
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	ff 30                	pushl  (%eax)
  801a31:	e8 b4 fd ff ff       	call   8017ea <dev_lookup>
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 27                	js     801a64 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a40:	8b 42 08             	mov    0x8(%edx),%eax
  801a43:	83 e0 03             	and    $0x3,%eax
  801a46:	83 f8 01             	cmp    $0x1,%eax
  801a49:	74 1e                	je     801a69 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4e:	8b 40 08             	mov    0x8(%eax),%eax
  801a51:	85 c0                	test   %eax,%eax
  801a53:	74 35                	je     801a8a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	ff 75 10             	pushl  0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	52                   	push   %edx
  801a5f:	ff d0                	call   *%eax
  801a61:	83 c4 10             	add    $0x10,%esp
}
  801a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a69:	a1 08 50 80 00       	mov    0x805008,%eax
  801a6e:	8b 40 48             	mov    0x48(%eax),%eax
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	53                   	push   %ebx
  801a75:	50                   	push   %eax
  801a76:	68 05 33 80 00       	push   $0x803305
  801a7b:	e8 6e e9 ff ff       	call   8003ee <cprintf>
		return -E_INVAL;
  801a80:	83 c4 10             	add    $0x10,%esp
  801a83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a88:	eb da                	jmp    801a64 <read+0x5a>
		return -E_NOT_SUPP;
  801a8a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a8f:	eb d3                	jmp    801a64 <read+0x5a>

00801a91 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	57                   	push   %edi
  801a95:	56                   	push   %esi
  801a96:	53                   	push   %ebx
  801a97:	83 ec 0c             	sub    $0xc,%esp
  801a9a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa5:	39 f3                	cmp    %esi,%ebx
  801aa7:	73 23                	jae    801acc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	89 f0                	mov    %esi,%eax
  801aae:	29 d8                	sub    %ebx,%eax
  801ab0:	50                   	push   %eax
  801ab1:	89 d8                	mov    %ebx,%eax
  801ab3:	03 45 0c             	add    0xc(%ebp),%eax
  801ab6:	50                   	push   %eax
  801ab7:	57                   	push   %edi
  801ab8:	e8 4d ff ff ff       	call   801a0a <read>
		if (m < 0)
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 06                	js     801aca <readn+0x39>
			return m;
		if (m == 0)
  801ac4:	74 06                	je     801acc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ac6:	01 c3                	add    %eax,%ebx
  801ac8:	eb db                	jmp    801aa5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aca:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5f                   	pop    %edi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    

00801ad6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 1c             	sub    $0x1c,%esp
  801add:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae3:	50                   	push   %eax
  801ae4:	53                   	push   %ebx
  801ae5:	e8 b0 fc ff ff       	call   80179a <fd_lookup>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 3a                	js     801b2b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af7:	50                   	push   %eax
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	ff 30                	pushl  (%eax)
  801afd:	e8 e8 fc ff ff       	call   8017ea <dev_lookup>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 22                	js     801b2b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b10:	74 1e                	je     801b30 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b15:	8b 52 0c             	mov    0xc(%edx),%edx
  801b18:	85 d2                	test   %edx,%edx
  801b1a:	74 35                	je     801b51 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b1c:	83 ec 04             	sub    $0x4,%esp
  801b1f:	ff 75 10             	pushl  0x10(%ebp)
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	50                   	push   %eax
  801b26:	ff d2                	call   *%edx
  801b28:	83 c4 10             	add    $0x10,%esp
}
  801b2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b30:	a1 08 50 80 00       	mov    0x805008,%eax
  801b35:	8b 40 48             	mov    0x48(%eax),%eax
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	53                   	push   %ebx
  801b3c:	50                   	push   %eax
  801b3d:	68 21 33 80 00       	push   $0x803321
  801b42:	e8 a7 e8 ff ff       	call   8003ee <cprintf>
		return -E_INVAL;
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b4f:	eb da                	jmp    801b2b <write+0x55>
		return -E_NOT_SUPP;
  801b51:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b56:	eb d3                	jmp    801b2b <write+0x55>

00801b58 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b61:	50                   	push   %eax
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	e8 30 fc ff ff       	call   80179a <fd_lookup>
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 0e                	js     801b7f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b77:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	53                   	push   %ebx
  801b85:	83 ec 1c             	sub    $0x1c,%esp
  801b88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8e:	50                   	push   %eax
  801b8f:	53                   	push   %ebx
  801b90:	e8 05 fc ff ff       	call   80179a <fd_lookup>
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 37                	js     801bd3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba2:	50                   	push   %eax
  801ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba6:	ff 30                	pushl  (%eax)
  801ba8:	e8 3d fc ff ff       	call   8017ea <dev_lookup>
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	78 1f                	js     801bd3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bbb:	74 1b                	je     801bd8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc0:	8b 52 18             	mov    0x18(%edx),%edx
  801bc3:	85 d2                	test   %edx,%edx
  801bc5:	74 32                	je     801bf9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	ff d2                	call   *%edx
  801bd0:	83 c4 10             	add    $0x10,%esp
}
  801bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bd8:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bdd:	8b 40 48             	mov    0x48(%eax),%eax
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	53                   	push   %ebx
  801be4:	50                   	push   %eax
  801be5:	68 e4 32 80 00       	push   $0x8032e4
  801bea:	e8 ff e7 ff ff       	call   8003ee <cprintf>
		return -E_INVAL;
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf7:	eb da                	jmp    801bd3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bf9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bfe:	eb d3                	jmp    801bd3 <ftruncate+0x52>

00801c00 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c0d:	50                   	push   %eax
  801c0e:	ff 75 08             	pushl  0x8(%ebp)
  801c11:	e8 84 fb ff ff       	call   80179a <fd_lookup>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	78 4b                	js     801c68 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c1d:	83 ec 08             	sub    $0x8,%esp
  801c20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c23:	50                   	push   %eax
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	ff 30                	pushl  (%eax)
  801c29:	e8 bc fb ff ff       	call   8017ea <dev_lookup>
  801c2e:	83 c4 10             	add    $0x10,%esp
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 33                	js     801c68 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c38:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c3c:	74 2f                	je     801c6d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c3e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c41:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c48:	00 00 00 
	stat->st_isdir = 0;
  801c4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c52:	00 00 00 
	stat->st_dev = dev;
  801c55:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c5b:	83 ec 08             	sub    $0x8,%esp
  801c5e:	53                   	push   %ebx
  801c5f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c62:	ff 50 14             	call   *0x14(%eax)
  801c65:	83 c4 10             	add    $0x10,%esp
}
  801c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    
		return -E_NOT_SUPP;
  801c6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c72:	eb f4                	jmp    801c68 <fstat+0x68>

00801c74 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	56                   	push   %esi
  801c78:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	6a 00                	push   $0x0
  801c7e:	ff 75 08             	pushl  0x8(%ebp)
  801c81:	e8 22 02 00 00       	call   801ea8 <open>
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	78 1b                	js     801caa <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c8f:	83 ec 08             	sub    $0x8,%esp
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	e8 65 ff ff ff       	call   801c00 <fstat>
  801c9b:	89 c6                	mov    %eax,%esi
	close(fd);
  801c9d:	89 1c 24             	mov    %ebx,(%esp)
  801ca0:	e8 27 fc ff ff       	call   8018cc <close>
	return r;
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	89 f3                	mov    %esi,%ebx
}
  801caa:	89 d8                	mov    %ebx,%eax
  801cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    

00801cb3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	89 c6                	mov    %eax,%esi
  801cba:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cbc:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cc3:	74 27                	je     801cec <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cc5:	6a 07                	push   $0x7
  801cc7:	68 00 60 80 00       	push   $0x806000
  801ccc:	56                   	push   %esi
  801ccd:	ff 35 00 50 80 00    	pushl  0x805000
  801cd3:	e8 9d 0c 00 00       	call   802975 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cd8:	83 c4 0c             	add    $0xc,%esp
  801cdb:	6a 00                	push   $0x0
  801cdd:	53                   	push   %ebx
  801cde:	6a 00                	push   $0x0
  801ce0:	e8 27 0c 00 00       	call   80290c <ipc_recv>
}
  801ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce8:	5b                   	pop    %ebx
  801ce9:	5e                   	pop    %esi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801cec:	83 ec 0c             	sub    $0xc,%esp
  801cef:	6a 01                	push   $0x1
  801cf1:	e8 d7 0c 00 00       	call   8029cd <ipc_find_env>
  801cf6:	a3 00 50 80 00       	mov    %eax,0x805000
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	eb c5                	jmp    801cc5 <fsipc+0x12>

00801d00 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d14:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d19:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d23:	e8 8b ff ff ff       	call   801cb3 <fsipc>
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <devfile_flush>:
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	8b 40 0c             	mov    0xc(%eax),%eax
  801d36:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d40:	b8 06 00 00 00       	mov    $0x6,%eax
  801d45:	e8 69 ff ff ff       	call   801cb3 <fsipc>
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <devfile_stat>:
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d61:	ba 00 00 00 00       	mov    $0x0,%edx
  801d66:	b8 05 00 00 00       	mov    $0x5,%eax
  801d6b:	e8 43 ff ff ff       	call   801cb3 <fsipc>
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 2c                	js     801da0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d74:	83 ec 08             	sub    $0x8,%esp
  801d77:	68 00 60 80 00       	push   $0x806000
  801d7c:	53                   	push   %ebx
  801d7d:	e8 cb ed ff ff       	call   800b4d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d82:	a1 80 60 80 00       	mov    0x806080,%eax
  801d87:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d8d:	a1 84 60 80 00       	mov    0x806084,%eax
  801d92:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <devfile_write>:
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	53                   	push   %ebx
  801da9:	83 ec 08             	sub    $0x8,%esp
  801dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8b 40 0c             	mov    0xc(%eax),%eax
  801db5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dba:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801dc0:	53                   	push   %ebx
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	68 08 60 80 00       	push   $0x806008
  801dc9:	e8 6f ef ff ff       	call   800d3d <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801dce:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd3:	b8 04 00 00 00       	mov    $0x4,%eax
  801dd8:	e8 d6 fe ff ff       	call   801cb3 <fsipc>
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 0b                	js     801def <devfile_write+0x4a>
	assert(r <= n);
  801de4:	39 d8                	cmp    %ebx,%eax
  801de6:	77 0c                	ja     801df4 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801de8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ded:	7f 1e                	jg     801e0d <devfile_write+0x68>
}
  801def:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    
	assert(r <= n);
  801df4:	68 54 33 80 00       	push   $0x803354
  801df9:	68 5b 33 80 00       	push   $0x80335b
  801dfe:	68 98 00 00 00       	push   $0x98
  801e03:	68 70 33 80 00       	push   $0x803370
  801e08:	e8 eb e4 ff ff       	call   8002f8 <_panic>
	assert(r <= PGSIZE);
  801e0d:	68 7b 33 80 00       	push   $0x80337b
  801e12:	68 5b 33 80 00       	push   $0x80335b
  801e17:	68 99 00 00 00       	push   $0x99
  801e1c:	68 70 33 80 00       	push   $0x803370
  801e21:	e8 d2 e4 ff ff       	call   8002f8 <_panic>

00801e26 <devfile_read>:
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	8b 40 0c             	mov    0xc(%eax),%eax
  801e34:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e39:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e44:	b8 03 00 00 00       	mov    $0x3,%eax
  801e49:	e8 65 fe ff ff       	call   801cb3 <fsipc>
  801e4e:	89 c3                	mov    %eax,%ebx
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 1f                	js     801e73 <devfile_read+0x4d>
	assert(r <= n);
  801e54:	39 f0                	cmp    %esi,%eax
  801e56:	77 24                	ja     801e7c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e58:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e5d:	7f 33                	jg     801e92 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	50                   	push   %eax
  801e63:	68 00 60 80 00       	push   $0x806000
  801e68:	ff 75 0c             	pushl  0xc(%ebp)
  801e6b:	e8 6b ee ff ff       	call   800cdb <memmove>
	return r;
  801e70:	83 c4 10             	add    $0x10,%esp
}
  801e73:	89 d8                	mov    %ebx,%eax
  801e75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5e                   	pop    %esi
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    
	assert(r <= n);
  801e7c:	68 54 33 80 00       	push   $0x803354
  801e81:	68 5b 33 80 00       	push   $0x80335b
  801e86:	6a 7c                	push   $0x7c
  801e88:	68 70 33 80 00       	push   $0x803370
  801e8d:	e8 66 e4 ff ff       	call   8002f8 <_panic>
	assert(r <= PGSIZE);
  801e92:	68 7b 33 80 00       	push   $0x80337b
  801e97:	68 5b 33 80 00       	push   $0x80335b
  801e9c:	6a 7d                	push   $0x7d
  801e9e:	68 70 33 80 00       	push   $0x803370
  801ea3:	e8 50 e4 ff ff       	call   8002f8 <_panic>

00801ea8 <open>:
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	83 ec 1c             	sub    $0x1c,%esp
  801eb0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801eb3:	56                   	push   %esi
  801eb4:	e8 5b ec ff ff       	call   800b14 <strlen>
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ec1:	7f 6c                	jg     801f2f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec9:	50                   	push   %eax
  801eca:	e8 79 f8 ff ff       	call   801748 <fd_alloc>
  801ecf:	89 c3                	mov    %eax,%ebx
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 3c                	js     801f14 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	56                   	push   %esi
  801edc:	68 00 60 80 00       	push   $0x806000
  801ee1:	e8 67 ec ff ff       	call   800b4d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee9:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef6:	e8 b8 fd ff ff       	call   801cb3 <fsipc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	78 19                	js     801f1d <open+0x75>
	return fd2num(fd);
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0a:	e8 12 f8 ff ff       	call   801721 <fd2num>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	83 c4 10             	add    $0x10,%esp
}
  801f14:	89 d8                	mov    %ebx,%eax
  801f16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f19:	5b                   	pop    %ebx
  801f1a:	5e                   	pop    %esi
  801f1b:	5d                   	pop    %ebp
  801f1c:	c3                   	ret    
		fd_close(fd, 0);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	6a 00                	push   $0x0
  801f22:	ff 75 f4             	pushl  -0xc(%ebp)
  801f25:	e8 1b f9 ff ff       	call   801845 <fd_close>
		return r;
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	eb e5                	jmp    801f14 <open+0x6c>
		return -E_BAD_PATH;
  801f2f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f34:	eb de                	jmp    801f14 <open+0x6c>

00801f36 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f41:	b8 08 00 00 00       	mov    $0x8,%eax
  801f46:	e8 68 fd ff ff       	call   801cb3 <fsipc>
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f53:	68 87 33 80 00       	push   $0x803387
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	e8 ed eb ff ff       	call   800b4d <strcpy>
	return 0;
}
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <devsock_close>:
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	53                   	push   %ebx
  801f6b:	83 ec 10             	sub    $0x10,%esp
  801f6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f71:	53                   	push   %ebx
  801f72:	e8 95 0a 00 00       	call   802a0c <pageref>
  801f77:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f7a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f7f:	83 f8 01             	cmp    $0x1,%eax
  801f82:	74 07                	je     801f8b <devsock_close+0x24>
}
  801f84:	89 d0                	mov    %edx,%eax
  801f86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f8b:	83 ec 0c             	sub    $0xc,%esp
  801f8e:	ff 73 0c             	pushl  0xc(%ebx)
  801f91:	e8 b9 02 00 00       	call   80224f <nsipc_close>
  801f96:	89 c2                	mov    %eax,%edx
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	eb e7                	jmp    801f84 <devsock_close+0x1d>

00801f9d <devsock_write>:
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fa3:	6a 00                	push   $0x0
  801fa5:	ff 75 10             	pushl  0x10(%ebp)
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	ff 70 0c             	pushl  0xc(%eax)
  801fb1:	e8 76 03 00 00       	call   80232c <nsipc_send>
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <devsock_read>:
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	ff 75 10             	pushl  0x10(%ebp)
  801fc3:	ff 75 0c             	pushl  0xc(%ebp)
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	ff 70 0c             	pushl  0xc(%eax)
  801fcc:	e8 ef 02 00 00       	call   8022c0 <nsipc_recv>
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <fd2sockid>:
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fd9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fdc:	52                   	push   %edx
  801fdd:	50                   	push   %eax
  801fde:	e8 b7 f7 ff ff       	call   80179a <fd_lookup>
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 10                	js     801ffa <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ff3:	39 08                	cmp    %ecx,(%eax)
  801ff5:	75 05                	jne    801ffc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ff7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    
		return -E_NOT_SUPP;
  801ffc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802001:	eb f7                	jmp    801ffa <fd2sockid+0x27>

00802003 <alloc_sockfd>:
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	83 ec 1c             	sub    $0x1c,%esp
  80200b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80200d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802010:	50                   	push   %eax
  802011:	e8 32 f7 ff ff       	call   801748 <fd_alloc>
  802016:	89 c3                	mov    %eax,%ebx
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	85 c0                	test   %eax,%eax
  80201d:	78 43                	js     802062 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	68 07 04 00 00       	push   $0x407
  802027:	ff 75 f4             	pushl  -0xc(%ebp)
  80202a:	6a 00                	push   $0x0
  80202c:	e8 0e ef ff ff       	call   800f3f <sys_page_alloc>
  802031:	89 c3                	mov    %eax,%ebx
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	85 c0                	test   %eax,%eax
  802038:	78 28                	js     802062 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802043:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80204f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	50                   	push   %eax
  802056:	e8 c6 f6 ff ff       	call   801721 <fd2num>
  80205b:	89 c3                	mov    %eax,%ebx
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	eb 0c                	jmp    80206e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	56                   	push   %esi
  802066:	e8 e4 01 00 00       	call   80224f <nsipc_close>
		return r;
  80206b:	83 c4 10             	add    $0x10,%esp
}
  80206e:	89 d8                	mov    %ebx,%eax
  802070:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    

00802077 <accept>:
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	e8 4e ff ff ff       	call   801fd3 <fd2sockid>
  802085:	85 c0                	test   %eax,%eax
  802087:	78 1b                	js     8020a4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	ff 75 10             	pushl  0x10(%ebp)
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	50                   	push   %eax
  802093:	e8 0e 01 00 00       	call   8021a6 <nsipc_accept>
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 05                	js     8020a4 <accept+0x2d>
	return alloc_sockfd(r);
  80209f:	e8 5f ff ff ff       	call   802003 <alloc_sockfd>
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <bind>:
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	e8 1f ff ff ff       	call   801fd3 <fd2sockid>
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 12                	js     8020ca <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	ff 75 10             	pushl  0x10(%ebp)
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	50                   	push   %eax
  8020c2:	e8 31 01 00 00       	call   8021f8 <nsipc_bind>
  8020c7:	83 c4 10             	add    $0x10,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <shutdown>:
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	e8 f9 fe ff ff       	call   801fd3 <fd2sockid>
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 0f                	js     8020ed <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020de:	83 ec 08             	sub    $0x8,%esp
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	50                   	push   %eax
  8020e5:	e8 43 01 00 00       	call   80222d <nsipc_shutdown>
  8020ea:	83 c4 10             	add    $0x10,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <connect>:
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	e8 d6 fe ff ff       	call   801fd3 <fd2sockid>
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	78 12                	js     802113 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	ff 75 10             	pushl  0x10(%ebp)
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	50                   	push   %eax
  80210b:	e8 59 01 00 00       	call   802269 <nsipc_connect>
  802110:	83 c4 10             	add    $0x10,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <listen>:
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	e8 b0 fe ff ff       	call   801fd3 <fd2sockid>
  802123:	85 c0                	test   %eax,%eax
  802125:	78 0f                	js     802136 <listen+0x21>
	return nsipc_listen(r, backlog);
  802127:	83 ec 08             	sub    $0x8,%esp
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	50                   	push   %eax
  80212e:	e8 6b 01 00 00       	call   80229e <nsipc_listen>
  802133:	83 c4 10             	add    $0x10,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <socket>:

int
socket(int domain, int type, int protocol)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80213e:	ff 75 10             	pushl  0x10(%ebp)
  802141:	ff 75 0c             	pushl  0xc(%ebp)
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	e8 3e 02 00 00       	call   80238a <nsipc_socket>
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 05                	js     802158 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802153:	e8 ab fe ff ff       	call   802003 <alloc_sockfd>
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	53                   	push   %ebx
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802163:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80216a:	74 26                	je     802192 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80216c:	6a 07                	push   $0x7
  80216e:	68 00 70 80 00       	push   $0x807000
  802173:	53                   	push   %ebx
  802174:	ff 35 04 50 80 00    	pushl  0x805004
  80217a:	e8 f6 07 00 00       	call   802975 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80217f:	83 c4 0c             	add    $0xc,%esp
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	e8 7f 07 00 00       	call   80290c <ipc_recv>
}
  80218d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802190:	c9                   	leave  
  802191:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802192:	83 ec 0c             	sub    $0xc,%esp
  802195:	6a 02                	push   $0x2
  802197:	e8 31 08 00 00       	call   8029cd <ipc_find_env>
  80219c:	a3 04 50 80 00       	mov    %eax,0x805004
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	eb c6                	jmp    80216c <nsipc+0x12>

008021a6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	56                   	push   %esi
  8021aa:	53                   	push   %ebx
  8021ab:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021b6:	8b 06                	mov    (%esi),%eax
  8021b8:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c2:	e8 93 ff ff ff       	call   80215a <nsipc>
  8021c7:	89 c3                	mov    %eax,%ebx
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	79 09                	jns    8021d6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021cd:	89 d8                	mov    %ebx,%eax
  8021cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d2:	5b                   	pop    %ebx
  8021d3:	5e                   	pop    %esi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	ff 35 10 70 80 00    	pushl  0x807010
  8021df:	68 00 70 80 00       	push   $0x807000
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	e8 ef ea ff ff       	call   800cdb <memmove>
		*addrlen = ret->ret_addrlen;
  8021ec:	a1 10 70 80 00       	mov    0x807010,%eax
  8021f1:	89 06                	mov    %eax,(%esi)
  8021f3:	83 c4 10             	add    $0x10,%esp
	return r;
  8021f6:	eb d5                	jmp    8021cd <nsipc_accept+0x27>

008021f8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	53                   	push   %ebx
  8021fc:	83 ec 08             	sub    $0x8,%esp
  8021ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80220a:	53                   	push   %ebx
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	68 04 70 80 00       	push   $0x807004
  802213:	e8 c3 ea ff ff       	call   800cdb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802218:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80221e:	b8 02 00 00 00       	mov    $0x2,%eax
  802223:	e8 32 ff ff ff       	call   80215a <nsipc>
}
  802228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80223b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802243:	b8 03 00 00 00       	mov    $0x3,%eax
  802248:	e8 0d ff ff ff       	call   80215a <nsipc>
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <nsipc_close>:

int
nsipc_close(int s)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80225d:	b8 04 00 00 00       	mov    $0x4,%eax
  802262:	e8 f3 fe ff ff       	call   80215a <nsipc>
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	53                   	push   %ebx
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80227b:	53                   	push   %ebx
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	68 04 70 80 00       	push   $0x807004
  802284:	e8 52 ea ff ff       	call   800cdb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802289:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80228f:	b8 05 00 00 00       	mov    $0x5,%eax
  802294:	e8 c1 fe ff ff       	call   80215a <nsipc>
}
  802299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022af:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022b4:	b8 06 00 00 00       	mov    $0x6,%eax
  8022b9:	e8 9c fe ff ff       	call   80215a <nsipc>
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022d0:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022de:	b8 07 00 00 00       	mov    $0x7,%eax
  8022e3:	e8 72 fe ff ff       	call   80215a <nsipc>
  8022e8:	89 c3                	mov    %eax,%ebx
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	78 1f                	js     80230d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022ee:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022f3:	7f 21                	jg     802316 <nsipc_recv+0x56>
  8022f5:	39 c6                	cmp    %eax,%esi
  8022f7:	7c 1d                	jl     802316 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	50                   	push   %eax
  8022fd:	68 00 70 80 00       	push   $0x807000
  802302:	ff 75 0c             	pushl  0xc(%ebp)
  802305:	e8 d1 e9 ff ff       	call   800cdb <memmove>
  80230a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80230d:	89 d8                	mov    %ebx,%eax
  80230f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802312:	5b                   	pop    %ebx
  802313:	5e                   	pop    %esi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802316:	68 93 33 80 00       	push   $0x803393
  80231b:	68 5b 33 80 00       	push   $0x80335b
  802320:	6a 62                	push   $0x62
  802322:	68 a8 33 80 00       	push   $0x8033a8
  802327:	e8 cc df ff ff       	call   8002f8 <_panic>

0080232c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	53                   	push   %ebx
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80233e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802344:	7f 2e                	jg     802374 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	53                   	push   %ebx
  80234a:	ff 75 0c             	pushl  0xc(%ebp)
  80234d:	68 0c 70 80 00       	push   $0x80700c
  802352:	e8 84 e9 ff ff       	call   800cdb <memmove>
	nsipcbuf.send.req_size = size;
  802357:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80235d:	8b 45 14             	mov    0x14(%ebp),%eax
  802360:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802365:	b8 08 00 00 00       	mov    $0x8,%eax
  80236a:	e8 eb fd ff ff       	call   80215a <nsipc>
}
  80236f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802372:	c9                   	leave  
  802373:	c3                   	ret    
	assert(size < 1600);
  802374:	68 b4 33 80 00       	push   $0x8033b4
  802379:	68 5b 33 80 00       	push   $0x80335b
  80237e:	6a 6d                	push   $0x6d
  802380:	68 a8 33 80 00       	push   $0x8033a8
  802385:	e8 6e df ff ff       	call   8002f8 <_panic>

0080238a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023a8:	b8 09 00 00 00       	mov    $0x9,%eax
  8023ad:	e8 a8 fd ff ff       	call   80215a <nsipc>
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	56                   	push   %esi
  8023b8:	53                   	push   %ebx
  8023b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023bc:	83 ec 0c             	sub    $0xc,%esp
  8023bf:	ff 75 08             	pushl  0x8(%ebp)
  8023c2:	e8 6a f3 ff ff       	call   801731 <fd2data>
  8023c7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023c9:	83 c4 08             	add    $0x8,%esp
  8023cc:	68 c0 33 80 00       	push   $0x8033c0
  8023d1:	53                   	push   %ebx
  8023d2:	e8 76 e7 ff ff       	call   800b4d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023d7:	8b 46 04             	mov    0x4(%esi),%eax
  8023da:	2b 06                	sub    (%esi),%eax
  8023dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023e9:	00 00 00 
	stat->st_dev = &devpipe;
  8023ec:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023f3:	40 80 00 
	return 0;
}
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fe:	5b                   	pop    %ebx
  8023ff:	5e                   	pop    %esi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    

00802402 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	53                   	push   %ebx
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80240c:	53                   	push   %ebx
  80240d:	6a 00                	push   $0x0
  80240f:	e8 b0 eb ff ff       	call   800fc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802414:	89 1c 24             	mov    %ebx,(%esp)
  802417:	e8 15 f3 ff ff       	call   801731 <fd2data>
  80241c:	83 c4 08             	add    $0x8,%esp
  80241f:	50                   	push   %eax
  802420:	6a 00                	push   $0x0
  802422:	e8 9d eb ff ff       	call   800fc4 <sys_page_unmap>
}
  802427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <_pipeisclosed>:
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	57                   	push   %edi
  802430:	56                   	push   %esi
  802431:	53                   	push   %ebx
  802432:	83 ec 1c             	sub    $0x1c,%esp
  802435:	89 c7                	mov    %eax,%edi
  802437:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802439:	a1 08 50 80 00       	mov    0x805008,%eax
  80243e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	57                   	push   %edi
  802445:	e8 c2 05 00 00       	call   802a0c <pageref>
  80244a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80244d:	89 34 24             	mov    %esi,(%esp)
  802450:	e8 b7 05 00 00       	call   802a0c <pageref>
		nn = thisenv->env_runs;
  802455:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80245b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	39 cb                	cmp    %ecx,%ebx
  802463:	74 1b                	je     802480 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802465:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802468:	75 cf                	jne    802439 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80246a:	8b 42 58             	mov    0x58(%edx),%eax
  80246d:	6a 01                	push   $0x1
  80246f:	50                   	push   %eax
  802470:	53                   	push   %ebx
  802471:	68 c7 33 80 00       	push   $0x8033c7
  802476:	e8 73 df ff ff       	call   8003ee <cprintf>
  80247b:	83 c4 10             	add    $0x10,%esp
  80247e:	eb b9                	jmp    802439 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802480:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802483:	0f 94 c0             	sete   %al
  802486:	0f b6 c0             	movzbl %al,%eax
}
  802489:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    

00802491 <devpipe_write>:
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	57                   	push   %edi
  802495:	56                   	push   %esi
  802496:	53                   	push   %ebx
  802497:	83 ec 28             	sub    $0x28,%esp
  80249a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80249d:	56                   	push   %esi
  80249e:	e8 8e f2 ff ff       	call   801731 <fd2data>
  8024a3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ad:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024b0:	74 4f                	je     802501 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024b2:	8b 43 04             	mov    0x4(%ebx),%eax
  8024b5:	8b 0b                	mov    (%ebx),%ecx
  8024b7:	8d 51 20             	lea    0x20(%ecx),%edx
  8024ba:	39 d0                	cmp    %edx,%eax
  8024bc:	72 14                	jb     8024d2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024be:	89 da                	mov    %ebx,%edx
  8024c0:	89 f0                	mov    %esi,%eax
  8024c2:	e8 65 ff ff ff       	call   80242c <_pipeisclosed>
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 3b                	jne    802506 <devpipe_write+0x75>
			sys_yield();
  8024cb:	e8 50 ea ff ff       	call   800f20 <sys_yield>
  8024d0:	eb e0                	jmp    8024b2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024d9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024dc:	89 c2                	mov    %eax,%edx
  8024de:	c1 fa 1f             	sar    $0x1f,%edx
  8024e1:	89 d1                	mov    %edx,%ecx
  8024e3:	c1 e9 1b             	shr    $0x1b,%ecx
  8024e6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024e9:	83 e2 1f             	and    $0x1f,%edx
  8024ec:	29 ca                	sub    %ecx,%edx
  8024ee:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024f2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024f6:	83 c0 01             	add    $0x1,%eax
  8024f9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024fc:	83 c7 01             	add    $0x1,%edi
  8024ff:	eb ac                	jmp    8024ad <devpipe_write+0x1c>
	return i;
  802501:	8b 45 10             	mov    0x10(%ebp),%eax
  802504:	eb 05                	jmp    80250b <devpipe_write+0x7a>
				return 0;
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80250e:	5b                   	pop    %ebx
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    

00802513 <devpipe_read>:
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	57                   	push   %edi
  802517:	56                   	push   %esi
  802518:	53                   	push   %ebx
  802519:	83 ec 18             	sub    $0x18,%esp
  80251c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80251f:	57                   	push   %edi
  802520:	e8 0c f2 ff ff       	call   801731 <fd2data>
  802525:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802527:	83 c4 10             	add    $0x10,%esp
  80252a:	be 00 00 00 00       	mov    $0x0,%esi
  80252f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802532:	75 14                	jne    802548 <devpipe_read+0x35>
	return i;
  802534:	8b 45 10             	mov    0x10(%ebp),%eax
  802537:	eb 02                	jmp    80253b <devpipe_read+0x28>
				return i;
  802539:	89 f0                	mov    %esi,%eax
}
  80253b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80253e:	5b                   	pop    %ebx
  80253f:	5e                   	pop    %esi
  802540:	5f                   	pop    %edi
  802541:	5d                   	pop    %ebp
  802542:	c3                   	ret    
			sys_yield();
  802543:	e8 d8 e9 ff ff       	call   800f20 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802548:	8b 03                	mov    (%ebx),%eax
  80254a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80254d:	75 18                	jne    802567 <devpipe_read+0x54>
			if (i > 0)
  80254f:	85 f6                	test   %esi,%esi
  802551:	75 e6                	jne    802539 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802553:	89 da                	mov    %ebx,%edx
  802555:	89 f8                	mov    %edi,%eax
  802557:	e8 d0 fe ff ff       	call   80242c <_pipeisclosed>
  80255c:	85 c0                	test   %eax,%eax
  80255e:	74 e3                	je     802543 <devpipe_read+0x30>
				return 0;
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
  802565:	eb d4                	jmp    80253b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802567:	99                   	cltd   
  802568:	c1 ea 1b             	shr    $0x1b,%edx
  80256b:	01 d0                	add    %edx,%eax
  80256d:	83 e0 1f             	and    $0x1f,%eax
  802570:	29 d0                	sub    %edx,%eax
  802572:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802577:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80257a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80257d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802580:	83 c6 01             	add    $0x1,%esi
  802583:	eb aa                	jmp    80252f <devpipe_read+0x1c>

00802585 <pipe>:
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	56                   	push   %esi
  802589:	53                   	push   %ebx
  80258a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80258d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802590:	50                   	push   %eax
  802591:	e8 b2 f1 ff ff       	call   801748 <fd_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	0f 88 23 01 00 00    	js     8026c6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 07 04 00 00       	push   $0x407
  8025ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ae:	6a 00                	push   $0x0
  8025b0:	e8 8a e9 ff ff       	call   800f3f <sys_page_alloc>
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 88 04 01 00 00    	js     8026c6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025c8:	50                   	push   %eax
  8025c9:	e8 7a f1 ff ff       	call   801748 <fd_alloc>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	83 c4 10             	add    $0x10,%esp
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	0f 88 db 00 00 00    	js     8026b6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	68 07 04 00 00       	push   $0x407
  8025e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e6:	6a 00                	push   $0x0
  8025e8:	e8 52 e9 ff ff       	call   800f3f <sys_page_alloc>
  8025ed:	89 c3                	mov    %eax,%ebx
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	0f 88 bc 00 00 00    	js     8026b6 <pipe+0x131>
	va = fd2data(fd0);
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802600:	e8 2c f1 ff ff       	call   801731 <fd2data>
  802605:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802607:	83 c4 0c             	add    $0xc,%esp
  80260a:	68 07 04 00 00       	push   $0x407
  80260f:	50                   	push   %eax
  802610:	6a 00                	push   $0x0
  802612:	e8 28 e9 ff ff       	call   800f3f <sys_page_alloc>
  802617:	89 c3                	mov    %eax,%ebx
  802619:	83 c4 10             	add    $0x10,%esp
  80261c:	85 c0                	test   %eax,%eax
  80261e:	0f 88 82 00 00 00    	js     8026a6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802624:	83 ec 0c             	sub    $0xc,%esp
  802627:	ff 75 f0             	pushl  -0x10(%ebp)
  80262a:	e8 02 f1 ff ff       	call   801731 <fd2data>
  80262f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802636:	50                   	push   %eax
  802637:	6a 00                	push   $0x0
  802639:	56                   	push   %esi
  80263a:	6a 00                	push   $0x0
  80263c:	e8 41 e9 ff ff       	call   800f82 <sys_page_map>
  802641:	89 c3                	mov    %eax,%ebx
  802643:	83 c4 20             	add    $0x20,%esp
  802646:	85 c0                	test   %eax,%eax
  802648:	78 4e                	js     802698 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80264a:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80264f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802652:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802657:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80265e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802661:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802666:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80266d:	83 ec 0c             	sub    $0xc,%esp
  802670:	ff 75 f4             	pushl  -0xc(%ebp)
  802673:	e8 a9 f0 ff ff       	call   801721 <fd2num>
  802678:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80267b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80267d:	83 c4 04             	add    $0x4,%esp
  802680:	ff 75 f0             	pushl  -0x10(%ebp)
  802683:	e8 99 f0 ff ff       	call   801721 <fd2num>
  802688:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80268e:	83 c4 10             	add    $0x10,%esp
  802691:	bb 00 00 00 00       	mov    $0x0,%ebx
  802696:	eb 2e                	jmp    8026c6 <pipe+0x141>
	sys_page_unmap(0, va);
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	56                   	push   %esi
  80269c:	6a 00                	push   $0x0
  80269e:	e8 21 e9 ff ff       	call   800fc4 <sys_page_unmap>
  8026a3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026a6:	83 ec 08             	sub    $0x8,%esp
  8026a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ac:	6a 00                	push   $0x0
  8026ae:	e8 11 e9 ff ff       	call   800fc4 <sys_page_unmap>
  8026b3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026b6:	83 ec 08             	sub    $0x8,%esp
  8026b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bc:	6a 00                	push   $0x0
  8026be:	e8 01 e9 ff ff       	call   800fc4 <sys_page_unmap>
  8026c3:	83 c4 10             	add    $0x10,%esp
}
  8026c6:	89 d8                	mov    %ebx,%eax
  8026c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026cb:	5b                   	pop    %ebx
  8026cc:	5e                   	pop    %esi
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    

008026cf <pipeisclosed>:
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d8:	50                   	push   %eax
  8026d9:	ff 75 08             	pushl  0x8(%ebp)
  8026dc:	e8 b9 f0 ff ff       	call   80179a <fd_lookup>
  8026e1:	83 c4 10             	add    $0x10,%esp
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	78 18                	js     802700 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ee:	e8 3e f0 ff ff       	call   801731 <fd2data>
	return _pipeisclosed(fd, p);
  8026f3:	89 c2                	mov    %eax,%edx
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	e8 2f fd ff ff       	call   80242c <_pipeisclosed>
  8026fd:	83 c4 10             	add    $0x10,%esp
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802702:	b8 00 00 00 00       	mov    $0x0,%eax
  802707:	c3                   	ret    

00802708 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80270e:	68 df 33 80 00       	push   $0x8033df
  802713:	ff 75 0c             	pushl  0xc(%ebp)
  802716:	e8 32 e4 ff ff       	call   800b4d <strcpy>
	return 0;
}
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <devcons_write>:
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80272e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802733:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802739:	3b 75 10             	cmp    0x10(%ebp),%esi
  80273c:	73 31                	jae    80276f <devcons_write+0x4d>
		m = n - tot;
  80273e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802741:	29 f3                	sub    %esi,%ebx
  802743:	83 fb 7f             	cmp    $0x7f,%ebx
  802746:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80274b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80274e:	83 ec 04             	sub    $0x4,%esp
  802751:	53                   	push   %ebx
  802752:	89 f0                	mov    %esi,%eax
  802754:	03 45 0c             	add    0xc(%ebp),%eax
  802757:	50                   	push   %eax
  802758:	57                   	push   %edi
  802759:	e8 7d e5 ff ff       	call   800cdb <memmove>
		sys_cputs(buf, m);
  80275e:	83 c4 08             	add    $0x8,%esp
  802761:	53                   	push   %ebx
  802762:	57                   	push   %edi
  802763:	e8 1b e7 ff ff       	call   800e83 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802768:	01 de                	add    %ebx,%esi
  80276a:	83 c4 10             	add    $0x10,%esp
  80276d:	eb ca                	jmp    802739 <devcons_write+0x17>
}
  80276f:	89 f0                	mov    %esi,%eax
  802771:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802774:	5b                   	pop    %ebx
  802775:	5e                   	pop    %esi
  802776:	5f                   	pop    %edi
  802777:	5d                   	pop    %ebp
  802778:	c3                   	ret    

00802779 <devcons_read>:
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 08             	sub    $0x8,%esp
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802784:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802788:	74 21                	je     8027ab <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80278a:	e8 12 e7 ff ff       	call   800ea1 <sys_cgetc>
  80278f:	85 c0                	test   %eax,%eax
  802791:	75 07                	jne    80279a <devcons_read+0x21>
		sys_yield();
  802793:	e8 88 e7 ff ff       	call   800f20 <sys_yield>
  802798:	eb f0                	jmp    80278a <devcons_read+0x11>
	if (c < 0)
  80279a:	78 0f                	js     8027ab <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80279c:	83 f8 04             	cmp    $0x4,%eax
  80279f:	74 0c                	je     8027ad <devcons_read+0x34>
	*(char*)vbuf = c;
  8027a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a4:	88 02                	mov    %al,(%edx)
	return 1;
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    
		return 0;
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b2:	eb f7                	jmp    8027ab <devcons_read+0x32>

008027b4 <cputchar>:
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027c0:	6a 01                	push   $0x1
  8027c2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027c5:	50                   	push   %eax
  8027c6:	e8 b8 e6 ff ff       	call   800e83 <sys_cputs>
}
  8027cb:	83 c4 10             	add    $0x10,%esp
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <getchar>:
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027d6:	6a 01                	push   $0x1
  8027d8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027db:	50                   	push   %eax
  8027dc:	6a 00                	push   $0x0
  8027de:	e8 27 f2 ff ff       	call   801a0a <read>
	if (r < 0)
  8027e3:	83 c4 10             	add    $0x10,%esp
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	78 06                	js     8027f0 <getchar+0x20>
	if (r < 1)
  8027ea:	74 06                	je     8027f2 <getchar+0x22>
	return c;
  8027ec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    
		return -E_EOF;
  8027f2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027f7:	eb f7                	jmp    8027f0 <getchar+0x20>

008027f9 <iscons>:
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802802:	50                   	push   %eax
  802803:	ff 75 08             	pushl  0x8(%ebp)
  802806:	e8 8f ef ff ff       	call   80179a <fd_lookup>
  80280b:	83 c4 10             	add    $0x10,%esp
  80280e:	85 c0                	test   %eax,%eax
  802810:	78 11                	js     802823 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80281b:	39 10                	cmp    %edx,(%eax)
  80281d:	0f 94 c0             	sete   %al
  802820:	0f b6 c0             	movzbl %al,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <opencons>:
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80282b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282e:	50                   	push   %eax
  80282f:	e8 14 ef ff ff       	call   801748 <fd_alloc>
  802834:	83 c4 10             	add    $0x10,%esp
  802837:	85 c0                	test   %eax,%eax
  802839:	78 3a                	js     802875 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	68 07 04 00 00       	push   $0x407
  802843:	ff 75 f4             	pushl  -0xc(%ebp)
  802846:	6a 00                	push   $0x0
  802848:	e8 f2 e6 ff ff       	call   800f3f <sys_page_alloc>
  80284d:	83 c4 10             	add    $0x10,%esp
  802850:	85 c0                	test   %eax,%eax
  802852:	78 21                	js     802875 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80285d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802869:	83 ec 0c             	sub    $0xc,%esp
  80286c:	50                   	push   %eax
  80286d:	e8 af ee ff ff       	call   801721 <fd2num>
  802872:	83 c4 10             	add    $0x10,%esp
}
  802875:	c9                   	leave  
  802876:	c3                   	ret    

00802877 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80287d:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802884:	74 0a                	je     802890 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	6a 07                	push   $0x7
  802895:	68 00 f0 bf ee       	push   $0xeebff000
  80289a:	6a 00                	push   $0x0
  80289c:	e8 9e e6 ff ff       	call   800f3f <sys_page_alloc>
		if(r < 0)
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	78 2a                	js     8028d2 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028a8:	83 ec 08             	sub    $0x8,%esp
  8028ab:	68 e6 28 80 00       	push   $0x8028e6
  8028b0:	6a 00                	push   $0x0
  8028b2:	e8 d3 e7 ff ff       	call   80108a <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028b7:	83 c4 10             	add    $0x10,%esp
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	79 c8                	jns    802886 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028be:	83 ec 04             	sub    $0x4,%esp
  8028c1:	68 1c 34 80 00       	push   $0x80341c
  8028c6:	6a 25                	push   $0x25
  8028c8:	68 58 34 80 00       	push   $0x803458
  8028cd:	e8 26 da ff ff       	call   8002f8 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 ec 33 80 00       	push   $0x8033ec
  8028da:	6a 22                	push   $0x22
  8028dc:	68 58 34 80 00       	push   $0x803458
  8028e1:	e8 12 da ff ff       	call   8002f8 <_panic>

008028e6 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028e6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028e7:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028ec:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028ee:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028f1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028f5:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028f9:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028fc:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028fe:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802902:	83 c4 08             	add    $0x8,%esp
	popal
  802905:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802906:	83 c4 04             	add    $0x4,%esp
	popfl
  802909:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80290a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80290b:	c3                   	ret    

0080290c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
  80290f:	56                   	push   %esi
  802910:	53                   	push   %ebx
  802911:	8b 75 08             	mov    0x8(%ebp),%esi
  802914:	8b 45 0c             	mov    0xc(%ebp),%eax
  802917:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80291a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80291c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802921:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802924:	83 ec 0c             	sub    $0xc,%esp
  802927:	50                   	push   %eax
  802928:	e8 c2 e7 ff ff       	call   8010ef <sys_ipc_recv>
	if(ret < 0){
  80292d:	83 c4 10             	add    $0x10,%esp
  802930:	85 c0                	test   %eax,%eax
  802932:	78 2b                	js     80295f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802934:	85 f6                	test   %esi,%esi
  802936:	74 0a                	je     802942 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802938:	a1 08 50 80 00       	mov    0x805008,%eax
  80293d:	8b 40 78             	mov    0x78(%eax),%eax
  802940:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802942:	85 db                	test   %ebx,%ebx
  802944:	74 0a                	je     802950 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802946:	a1 08 50 80 00       	mov    0x805008,%eax
  80294b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80294e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802950:	a1 08 50 80 00       	mov    0x805008,%eax
  802955:	8b 40 74             	mov    0x74(%eax),%eax
}
  802958:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80295b:	5b                   	pop    %ebx
  80295c:	5e                   	pop    %esi
  80295d:	5d                   	pop    %ebp
  80295e:	c3                   	ret    
		if(from_env_store)
  80295f:	85 f6                	test   %esi,%esi
  802961:	74 06                	je     802969 <ipc_recv+0x5d>
			*from_env_store = 0;
  802963:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802969:	85 db                	test   %ebx,%ebx
  80296b:	74 eb                	je     802958 <ipc_recv+0x4c>
			*perm_store = 0;
  80296d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802973:	eb e3                	jmp    802958 <ipc_recv+0x4c>

00802975 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	57                   	push   %edi
  802979:	56                   	push   %esi
  80297a:	53                   	push   %ebx
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802981:	8b 75 0c             	mov    0xc(%ebp),%esi
  802984:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802987:	85 db                	test   %ebx,%ebx
  802989:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80298e:	0f 44 d8             	cmove  %eax,%ebx
  802991:	eb 05                	jmp    802998 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802993:	e8 88 e5 ff ff       	call   800f20 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802998:	ff 75 14             	pushl  0x14(%ebp)
  80299b:	53                   	push   %ebx
  80299c:	56                   	push   %esi
  80299d:	57                   	push   %edi
  80299e:	e8 29 e7 ff ff       	call   8010cc <sys_ipc_try_send>
  8029a3:	83 c4 10             	add    $0x10,%esp
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 1b                	je     8029c5 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8029aa:	79 e7                	jns    802993 <ipc_send+0x1e>
  8029ac:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029af:	74 e2                	je     802993 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8029b1:	83 ec 04             	sub    $0x4,%esp
  8029b4:	68 66 34 80 00       	push   $0x803466
  8029b9:	6a 46                	push   $0x46
  8029bb:	68 7b 34 80 00       	push   $0x80347b
  8029c0:	e8 33 d9 ff ff       	call   8002f8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029c8:	5b                   	pop    %ebx
  8029c9:	5e                   	pop    %esi
  8029ca:	5f                   	pop    %edi
  8029cb:	5d                   	pop    %ebp
  8029cc:	c3                   	ret    

008029cd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
  8029d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029d3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029d8:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8029de:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029e4:	8b 52 50             	mov    0x50(%edx),%edx
  8029e7:	39 ca                	cmp    %ecx,%edx
  8029e9:	74 11                	je     8029fc <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8029eb:	83 c0 01             	add    $0x1,%eax
  8029ee:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029f3:	75 e3                	jne    8029d8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fa:	eb 0e                	jmp    802a0a <ipc_find_env+0x3d>
			return envs[i].env_id;
  8029fc:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802a02:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a07:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a0a:	5d                   	pop    %ebp
  802a0b:	c3                   	ret    

00802a0c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
  802a0f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a12:	89 d0                	mov    %edx,%eax
  802a14:	c1 e8 16             	shr    $0x16,%eax
  802a17:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a23:	f6 c1 01             	test   $0x1,%cl
  802a26:	74 1d                	je     802a45 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a28:	c1 ea 0c             	shr    $0xc,%edx
  802a2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a32:	f6 c2 01             	test   $0x1,%dl
  802a35:	74 0e                	je     802a45 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a37:	c1 ea 0c             	shr    $0xc,%edx
  802a3a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a41:	ef 
  802a42:	0f b7 c0             	movzwl %ax,%eax
}
  802a45:	5d                   	pop    %ebp
  802a46:	c3                   	ret    
  802a47:	66 90                	xchg   %ax,%ax
  802a49:	66 90                	xchg   %ax,%ax
  802a4b:	66 90                	xchg   %ax,%ax
  802a4d:	66 90                	xchg   %ax,%ax
  802a4f:	90                   	nop

00802a50 <__udivdi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	53                   	push   %ebx
  802a54:	83 ec 1c             	sub    $0x1c,%esp
  802a57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a67:	85 d2                	test   %edx,%edx
  802a69:	75 4d                	jne    802ab8 <__udivdi3+0x68>
  802a6b:	39 f3                	cmp    %esi,%ebx
  802a6d:	76 19                	jbe    802a88 <__udivdi3+0x38>
  802a6f:	31 ff                	xor    %edi,%edi
  802a71:	89 e8                	mov    %ebp,%eax
  802a73:	89 f2                	mov    %esi,%edx
  802a75:	f7 f3                	div    %ebx
  802a77:	89 fa                	mov    %edi,%edx
  802a79:	83 c4 1c             	add    $0x1c,%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5f                   	pop    %edi
  802a7f:	5d                   	pop    %ebp
  802a80:	c3                   	ret    
  802a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a88:	89 d9                	mov    %ebx,%ecx
  802a8a:	85 db                	test   %ebx,%ebx
  802a8c:	75 0b                	jne    802a99 <__udivdi3+0x49>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f3                	div    %ebx
  802a97:	89 c1                	mov    %eax,%ecx
  802a99:	31 d2                	xor    %edx,%edx
  802a9b:	89 f0                	mov    %esi,%eax
  802a9d:	f7 f1                	div    %ecx
  802a9f:	89 c6                	mov    %eax,%esi
  802aa1:	89 e8                	mov    %ebp,%eax
  802aa3:	89 f7                	mov    %esi,%edi
  802aa5:	f7 f1                	div    %ecx
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	39 f2                	cmp    %esi,%edx
  802aba:	77 1c                	ja     802ad8 <__udivdi3+0x88>
  802abc:	0f bd fa             	bsr    %edx,%edi
  802abf:	83 f7 1f             	xor    $0x1f,%edi
  802ac2:	75 2c                	jne    802af0 <__udivdi3+0xa0>
  802ac4:	39 f2                	cmp    %esi,%edx
  802ac6:	72 06                	jb     802ace <__udivdi3+0x7e>
  802ac8:	31 c0                	xor    %eax,%eax
  802aca:	39 eb                	cmp    %ebp,%ebx
  802acc:	77 a9                	ja     802a77 <__udivdi3+0x27>
  802ace:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad3:	eb a2                	jmp    802a77 <__udivdi3+0x27>
  802ad5:	8d 76 00             	lea    0x0(%esi),%esi
  802ad8:	31 ff                	xor    %edi,%edi
  802ada:	31 c0                	xor    %eax,%eax
  802adc:	89 fa                	mov    %edi,%edx
  802ade:	83 c4 1c             	add    $0x1c,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5f                   	pop    %edi
  802ae4:	5d                   	pop    %ebp
  802ae5:	c3                   	ret    
  802ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aed:	8d 76 00             	lea    0x0(%esi),%esi
  802af0:	89 f9                	mov    %edi,%ecx
  802af2:	b8 20 00 00 00       	mov    $0x20,%eax
  802af7:	29 f8                	sub    %edi,%eax
  802af9:	d3 e2                	shl    %cl,%edx
  802afb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802aff:	89 c1                	mov    %eax,%ecx
  802b01:	89 da                	mov    %ebx,%edx
  802b03:	d3 ea                	shr    %cl,%edx
  802b05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b09:	09 d1                	or     %edx,%ecx
  802b0b:	89 f2                	mov    %esi,%edx
  802b0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b11:	89 f9                	mov    %edi,%ecx
  802b13:	d3 e3                	shl    %cl,%ebx
  802b15:	89 c1                	mov    %eax,%ecx
  802b17:	d3 ea                	shr    %cl,%edx
  802b19:	89 f9                	mov    %edi,%ecx
  802b1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b1f:	89 eb                	mov    %ebp,%ebx
  802b21:	d3 e6                	shl    %cl,%esi
  802b23:	89 c1                	mov    %eax,%ecx
  802b25:	d3 eb                	shr    %cl,%ebx
  802b27:	09 de                	or     %ebx,%esi
  802b29:	89 f0                	mov    %esi,%eax
  802b2b:	f7 74 24 08          	divl   0x8(%esp)
  802b2f:	89 d6                	mov    %edx,%esi
  802b31:	89 c3                	mov    %eax,%ebx
  802b33:	f7 64 24 0c          	mull   0xc(%esp)
  802b37:	39 d6                	cmp    %edx,%esi
  802b39:	72 15                	jb     802b50 <__udivdi3+0x100>
  802b3b:	89 f9                	mov    %edi,%ecx
  802b3d:	d3 e5                	shl    %cl,%ebp
  802b3f:	39 c5                	cmp    %eax,%ebp
  802b41:	73 04                	jae    802b47 <__udivdi3+0xf7>
  802b43:	39 d6                	cmp    %edx,%esi
  802b45:	74 09                	je     802b50 <__udivdi3+0x100>
  802b47:	89 d8                	mov    %ebx,%eax
  802b49:	31 ff                	xor    %edi,%edi
  802b4b:	e9 27 ff ff ff       	jmp    802a77 <__udivdi3+0x27>
  802b50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b53:	31 ff                	xor    %edi,%edi
  802b55:	e9 1d ff ff ff       	jmp    802a77 <__udivdi3+0x27>
  802b5a:	66 90                	xchg   %ax,%ax
  802b5c:	66 90                	xchg   %ax,%ax
  802b5e:	66 90                	xchg   %ax,%ax

00802b60 <__umoddi3>:
  802b60:	55                   	push   %ebp
  802b61:	57                   	push   %edi
  802b62:	56                   	push   %esi
  802b63:	53                   	push   %ebx
  802b64:	83 ec 1c             	sub    $0x1c,%esp
  802b67:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b77:	89 da                	mov    %ebx,%edx
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	75 43                	jne    802bc0 <__umoddi3+0x60>
  802b7d:	39 df                	cmp    %ebx,%edi
  802b7f:	76 17                	jbe    802b98 <__umoddi3+0x38>
  802b81:	89 f0                	mov    %esi,%eax
  802b83:	f7 f7                	div    %edi
  802b85:	89 d0                	mov    %edx,%eax
  802b87:	31 d2                	xor    %edx,%edx
  802b89:	83 c4 1c             	add    $0x1c,%esp
  802b8c:	5b                   	pop    %ebx
  802b8d:	5e                   	pop    %esi
  802b8e:	5f                   	pop    %edi
  802b8f:	5d                   	pop    %ebp
  802b90:	c3                   	ret    
  802b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b98:	89 fd                	mov    %edi,%ebp
  802b9a:	85 ff                	test   %edi,%edi
  802b9c:	75 0b                	jne    802ba9 <__umoddi3+0x49>
  802b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba3:	31 d2                	xor    %edx,%edx
  802ba5:	f7 f7                	div    %edi
  802ba7:	89 c5                	mov    %eax,%ebp
  802ba9:	89 d8                	mov    %ebx,%eax
  802bab:	31 d2                	xor    %edx,%edx
  802bad:	f7 f5                	div    %ebp
  802baf:	89 f0                	mov    %esi,%eax
  802bb1:	f7 f5                	div    %ebp
  802bb3:	89 d0                	mov    %edx,%eax
  802bb5:	eb d0                	jmp    802b87 <__umoddi3+0x27>
  802bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bbe:	66 90                	xchg   %ax,%ax
  802bc0:	89 f1                	mov    %esi,%ecx
  802bc2:	39 d8                	cmp    %ebx,%eax
  802bc4:	76 0a                	jbe    802bd0 <__umoddi3+0x70>
  802bc6:	89 f0                	mov    %esi,%eax
  802bc8:	83 c4 1c             	add    $0x1c,%esp
  802bcb:	5b                   	pop    %ebx
  802bcc:	5e                   	pop    %esi
  802bcd:	5f                   	pop    %edi
  802bce:	5d                   	pop    %ebp
  802bcf:	c3                   	ret    
  802bd0:	0f bd e8             	bsr    %eax,%ebp
  802bd3:	83 f5 1f             	xor    $0x1f,%ebp
  802bd6:	75 20                	jne    802bf8 <__umoddi3+0x98>
  802bd8:	39 d8                	cmp    %ebx,%eax
  802bda:	0f 82 b0 00 00 00    	jb     802c90 <__umoddi3+0x130>
  802be0:	39 f7                	cmp    %esi,%edi
  802be2:	0f 86 a8 00 00 00    	jbe    802c90 <__umoddi3+0x130>
  802be8:	89 c8                	mov    %ecx,%eax
  802bea:	83 c4 1c             	add    $0x1c,%esp
  802bed:	5b                   	pop    %ebx
  802bee:	5e                   	pop    %esi
  802bef:	5f                   	pop    %edi
  802bf0:	5d                   	pop    %ebp
  802bf1:	c3                   	ret    
  802bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bf8:	89 e9                	mov    %ebp,%ecx
  802bfa:	ba 20 00 00 00       	mov    $0x20,%edx
  802bff:	29 ea                	sub    %ebp,%edx
  802c01:	d3 e0                	shl    %cl,%eax
  802c03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c07:	89 d1                	mov    %edx,%ecx
  802c09:	89 f8                	mov    %edi,%eax
  802c0b:	d3 e8                	shr    %cl,%eax
  802c0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802c11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c19:	09 c1                	or     %eax,%ecx
  802c1b:	89 d8                	mov    %ebx,%eax
  802c1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c21:	89 e9                	mov    %ebp,%ecx
  802c23:	d3 e7                	shl    %cl,%edi
  802c25:	89 d1                	mov    %edx,%ecx
  802c27:	d3 e8                	shr    %cl,%eax
  802c29:	89 e9                	mov    %ebp,%ecx
  802c2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c2f:	d3 e3                	shl    %cl,%ebx
  802c31:	89 c7                	mov    %eax,%edi
  802c33:	89 d1                	mov    %edx,%ecx
  802c35:	89 f0                	mov    %esi,%eax
  802c37:	d3 e8                	shr    %cl,%eax
  802c39:	89 e9                	mov    %ebp,%ecx
  802c3b:	89 fa                	mov    %edi,%edx
  802c3d:	d3 e6                	shl    %cl,%esi
  802c3f:	09 d8                	or     %ebx,%eax
  802c41:	f7 74 24 08          	divl   0x8(%esp)
  802c45:	89 d1                	mov    %edx,%ecx
  802c47:	89 f3                	mov    %esi,%ebx
  802c49:	f7 64 24 0c          	mull   0xc(%esp)
  802c4d:	89 c6                	mov    %eax,%esi
  802c4f:	89 d7                	mov    %edx,%edi
  802c51:	39 d1                	cmp    %edx,%ecx
  802c53:	72 06                	jb     802c5b <__umoddi3+0xfb>
  802c55:	75 10                	jne    802c67 <__umoddi3+0x107>
  802c57:	39 c3                	cmp    %eax,%ebx
  802c59:	73 0c                	jae    802c67 <__umoddi3+0x107>
  802c5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c63:	89 d7                	mov    %edx,%edi
  802c65:	89 c6                	mov    %eax,%esi
  802c67:	89 ca                	mov    %ecx,%edx
  802c69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c6e:	29 f3                	sub    %esi,%ebx
  802c70:	19 fa                	sbb    %edi,%edx
  802c72:	89 d0                	mov    %edx,%eax
  802c74:	d3 e0                	shl    %cl,%eax
  802c76:	89 e9                	mov    %ebp,%ecx
  802c78:	d3 eb                	shr    %cl,%ebx
  802c7a:	d3 ea                	shr    %cl,%edx
  802c7c:	09 d8                	or     %ebx,%eax
  802c7e:	83 c4 1c             	add    $0x1c,%esp
  802c81:	5b                   	pop    %ebx
  802c82:	5e                   	pop    %esi
  802c83:	5f                   	pop    %edi
  802c84:	5d                   	pop    %ebp
  802c85:	c3                   	ret    
  802c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c8d:	8d 76 00             	lea    0x0(%esi),%esi
  802c90:	89 da                	mov    %ebx,%edx
  802c92:	29 fe                	sub    %edi,%esi
  802c94:	19 c2                	sbb    %eax,%edx
  802c96:	89 f1                	mov    %esi,%ecx
  802c98:	89 c8                	mov    %ecx,%eax
  802c9a:	e9 4b ff ff ff       	jmp    802bea <__umoddi3+0x8a>
