
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 43                	jmp    800086 <num+0x53>
		if (bol) {
			printf("%5d ", ++line);
  800043:	a1 00 40 80 00       	mov    0x804000,%eax
  800048:	83 c0 01             	add    $0x1,%eax
  80004b:	a3 00 40 80 00       	mov    %eax,0x804000
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	50                   	push   %eax
  800054:	68 e0 27 80 00       	push   $0x8027e0
  800059:	e8 98 1a 00 00       	call   801af6 <printf>
			bol = 0;
  80005e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800065:	00 00 00 
  800068:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	6a 01                	push   $0x1
  800070:	53                   	push   %ebx
  800071:	6a 01                	push   $0x1
  800073:	e8 09 15 00 00       	call   801581 <write>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 f8 01             	cmp    $0x1,%eax
  80007e:	75 24                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800080:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800084:	74 36                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	53                   	push   %ebx
  80008c:	56                   	push   %esi
  80008d:	e8 23 14 00 00       	call   8014b5 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7e 2f                	jle    8000c8 <num+0x95>
		if (bol) {
  800099:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a0:	74 c9                	je     80006b <num+0x38>
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 e5 27 80 00       	push   $0x8027e5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 00 28 80 00       	push   $0x802800
  8000b7:	e8 d4 01 00 00       	call   800290 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb be                	jmp    800086 <num+0x53>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 0b 28 80 00       	push   $0x80280b
  8000dd:	6a 18                	push   $0x18
  8000df:	68 00 28 80 00       	push   $0x802800
  8000e4:	e8 a7 01 00 00       	call   800290 <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 20 	movl   $0x802820,0x803004
  8000f9:	28 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 46                	je     800148 <umain+0x5f>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 48                	jge    80015a <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 32 18 00 00       	call   801953 <open>
  800121:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	78 3d                	js     800167 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	50                   	push   %eax
  800130:	e8 fe fe ff ff       	call   800033 <num>
				close(f);
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 3a 12 00 00       	call   801377 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 24 28 80 00       	push   $0x802824
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 fd 00 00 00       	call   80025c <exit>
}
  80015f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	pushl  (%eax)
  800170:	68 2c 28 80 00       	push   $0x80282c
  800175:	6a 27                	push   $0x27
  800177:	68 00 28 80 00       	push   $0x802800
  80017c:	e8 0f 01 00 00       	call   800290 <_panic>

00800181 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80018a:	c7 05 0c 40 80 00 00 	movl   $0x0,0x80400c
  800191:	00 00 00 
	envid_t find = sys_getenvid();
  800194:	e8 00 0d 00 00       	call   800e99 <sys_getenvid>
  800199:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001a4:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ae:	eb 0b                	jmp    8001bb <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001b0:	83 c2 01             	add    $0x1,%edx
  8001b3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001b9:	74 23                	je     8001de <libmain+0x5d>
		if(envs[i].env_id == find)
  8001bb:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8001c1:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001c7:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001ca:	39 c1                	cmp    %eax,%ecx
  8001cc:	75 e2                	jne    8001b0 <libmain+0x2f>
  8001ce:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8001d4:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001da:	89 fe                	mov    %edi,%esi
  8001dc:	eb d2                	jmp    8001b0 <libmain+0x2f>
  8001de:	89 f0                	mov    %esi,%eax
  8001e0:	84 c0                	test   %al,%al
  8001e2:	74 06                	je     8001ea <libmain+0x69>
  8001e4:	89 1d 0c 40 80 00    	mov    %ebx,0x80400c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ee:	7e 0a                	jle    8001fa <libmain+0x79>
		binaryname = argv[0];
  8001f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f3:	8b 00                	mov    (%eax),%eax
  8001f5:	a3 04 30 80 00       	mov    %eax,0x803004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001fa:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8001ff:	8b 40 48             	mov    0x48(%eax),%eax
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	50                   	push   %eax
  800206:	68 3e 28 80 00       	push   $0x80283e
  80020b:	e8 76 01 00 00       	call   800386 <cprintf>
	cprintf("before umain\n");
  800210:	c7 04 24 5c 28 80 00 	movl   $0x80285c,(%esp)
  800217:	e8 6a 01 00 00       	call   800386 <cprintf>
	// call user main routine
	umain(argc, argv);
  80021c:	83 c4 08             	add    $0x8,%esp
  80021f:	ff 75 0c             	pushl  0xc(%ebp)
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	e8 bf fe ff ff       	call   8000e9 <umain>
	cprintf("after umain\n");
  80022a:	c7 04 24 6a 28 80 00 	movl   $0x80286a,(%esp)
  800231:	e8 50 01 00 00       	call   800386 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800236:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80023b:	8b 40 48             	mov    0x48(%eax),%eax
  80023e:	83 c4 08             	add    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 77 28 80 00       	push   $0x802877
  800247:	e8 3a 01 00 00       	call   800386 <cprintf>
	// exit gracefully
	exit();
  80024c:	e8 0b 00 00 00       	call   80025c <exit>
}
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800257:	5b                   	pop    %ebx
  800258:	5e                   	pop    %esi
  800259:	5f                   	pop    %edi
  80025a:	5d                   	pop    %ebp
  80025b:	c3                   	ret    

0080025c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800262:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800267:	8b 40 48             	mov    0x48(%eax),%eax
  80026a:	68 a4 28 80 00       	push   $0x8028a4
  80026f:	50                   	push   %eax
  800270:	68 96 28 80 00       	push   $0x802896
  800275:	e8 0c 01 00 00       	call   800386 <cprintf>
	close_all();
  80027a:	e8 25 11 00 00       	call   8013a4 <close_all>
	sys_env_destroy(0);
  80027f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800286:	e8 cd 0b 00 00       	call   800e58 <sys_env_destroy>
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800295:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80029a:	8b 40 48             	mov    0x48(%eax),%eax
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	68 d0 28 80 00       	push   $0x8028d0
  8002a5:	50                   	push   %eax
  8002a6:	68 96 28 80 00       	push   $0x802896
  8002ab:	e8 d6 00 00 00       	call   800386 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002b0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b3:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8002b9:	e8 db 0b 00 00       	call   800e99 <sys_getenvid>
  8002be:	83 c4 04             	add    $0x4,%esp
  8002c1:	ff 75 0c             	pushl  0xc(%ebp)
  8002c4:	ff 75 08             	pushl  0x8(%ebp)
  8002c7:	56                   	push   %esi
  8002c8:	50                   	push   %eax
  8002c9:	68 ac 28 80 00       	push   $0x8028ac
  8002ce:	e8 b3 00 00 00       	call   800386 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d3:	83 c4 18             	add    $0x18,%esp
  8002d6:	53                   	push   %ebx
  8002d7:	ff 75 10             	pushl  0x10(%ebp)
  8002da:	e8 56 00 00 00       	call   800335 <vcprintf>
	cprintf("\n");
  8002df:	c7 04 24 5a 28 80 00 	movl   $0x80285a,(%esp)
  8002e6:	e8 9b 00 00 00       	call   800386 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ee:	cc                   	int3   
  8002ef:	eb fd                	jmp    8002ee <_panic+0x5e>

008002f1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	53                   	push   %ebx
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002fb:	8b 13                	mov    (%ebx),%edx
  8002fd:	8d 42 01             	lea    0x1(%edx),%eax
  800300:	89 03                	mov    %eax,(%ebx)
  800302:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800305:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800309:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030e:	74 09                	je     800319 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800310:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800314:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800317:	c9                   	leave  
  800318:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	68 ff 00 00 00       	push   $0xff
  800321:	8d 43 08             	lea    0x8(%ebx),%eax
  800324:	50                   	push   %eax
  800325:	e8 f1 0a 00 00       	call   800e1b <sys_cputs>
		b->idx = 0;
  80032a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800330:	83 c4 10             	add    $0x10,%esp
  800333:	eb db                	jmp    800310 <putch+0x1f>

00800335 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80033e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800345:	00 00 00 
	b.cnt = 0;
  800348:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800352:	ff 75 0c             	pushl  0xc(%ebp)
  800355:	ff 75 08             	pushl  0x8(%ebp)
  800358:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035e:	50                   	push   %eax
  80035f:	68 f1 02 80 00       	push   $0x8002f1
  800364:	e8 4a 01 00 00       	call   8004b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800369:	83 c4 08             	add    $0x8,%esp
  80036c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800372:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800378:	50                   	push   %eax
  800379:	e8 9d 0a 00 00       	call   800e1b <sys_cputs>

	return b.cnt;
}
  80037e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80038c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038f:	50                   	push   %eax
  800390:	ff 75 08             	pushl  0x8(%ebp)
  800393:	e8 9d ff ff ff       	call   800335 <vcprintf>
	va_end(ap);

	return cnt;
}
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	57                   	push   %edi
  80039e:	56                   	push   %esi
  80039f:	53                   	push   %ebx
  8003a0:	83 ec 1c             	sub    $0x1c,%esp
  8003a3:	89 c6                	mov    %eax,%esi
  8003a5:	89 d7                	mov    %edx,%edi
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003b9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003bd:	74 2c                	je     8003eb <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003cc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003cf:	39 c2                	cmp    %eax,%edx
  8003d1:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003d4:	73 43                	jae    800419 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003d6:	83 eb 01             	sub    $0x1,%ebx
  8003d9:	85 db                	test   %ebx,%ebx
  8003db:	7e 6c                	jle    800449 <printnum+0xaf>
				putch(padc, putdat);
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	57                   	push   %edi
  8003e1:	ff 75 18             	pushl  0x18(%ebp)
  8003e4:	ff d6                	call   *%esi
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	eb eb                	jmp    8003d6 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	6a 20                	push   $0x20
  8003f0:	6a 00                	push   $0x0
  8003f2:	50                   	push   %eax
  8003f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f9:	89 fa                	mov    %edi,%edx
  8003fb:	89 f0                	mov    %esi,%eax
  8003fd:	e8 98 ff ff ff       	call   80039a <printnum>
		while (--width > 0)
  800402:	83 c4 20             	add    $0x20,%esp
  800405:	83 eb 01             	sub    $0x1,%ebx
  800408:	85 db                	test   %ebx,%ebx
  80040a:	7e 65                	jle    800471 <printnum+0xd7>
			putch(padc, putdat);
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	57                   	push   %edi
  800410:	6a 20                	push   $0x20
  800412:	ff d6                	call   *%esi
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb ec                	jmp    800405 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	ff 75 18             	pushl  0x18(%ebp)
  80041f:	83 eb 01             	sub    $0x1,%ebx
  800422:	53                   	push   %ebx
  800423:	50                   	push   %eax
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	ff 75 dc             	pushl  -0x24(%ebp)
  80042a:	ff 75 d8             	pushl  -0x28(%ebp)
  80042d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800430:	ff 75 e0             	pushl  -0x20(%ebp)
  800433:	e8 48 21 00 00       	call   802580 <__udivdi3>
  800438:	83 c4 18             	add    $0x18,%esp
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	89 fa                	mov    %edi,%edx
  80043f:	89 f0                	mov    %esi,%eax
  800441:	e8 54 ff ff ff       	call   80039a <printnum>
  800446:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	57                   	push   %edi
  80044d:	83 ec 04             	sub    $0x4,%esp
  800450:	ff 75 dc             	pushl  -0x24(%ebp)
  800453:	ff 75 d8             	pushl  -0x28(%ebp)
  800456:	ff 75 e4             	pushl  -0x1c(%ebp)
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	e8 2f 22 00 00       	call   802690 <__umoddi3>
  800461:	83 c4 14             	add    $0x14,%esp
  800464:	0f be 80 d7 28 80 00 	movsbl 0x8028d7(%eax),%eax
  80046b:	50                   	push   %eax
  80046c:	ff d6                	call   *%esi
  80046e:	83 c4 10             	add    $0x10,%esp
	}
}
  800471:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800474:	5b                   	pop    %ebx
  800475:	5e                   	pop    %esi
  800476:	5f                   	pop    %edi
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80047f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800483:	8b 10                	mov    (%eax),%edx
  800485:	3b 50 04             	cmp    0x4(%eax),%edx
  800488:	73 0a                	jae    800494 <sprintputch+0x1b>
		*b->buf++ = ch;
  80048a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80048d:	89 08                	mov    %ecx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	88 02                	mov    %al,(%edx)
}
  800494:	5d                   	pop    %ebp
  800495:	c3                   	ret    

00800496 <printfmt>:
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80049c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80049f:	50                   	push   %eax
  8004a0:	ff 75 10             	pushl  0x10(%ebp)
  8004a3:	ff 75 0c             	pushl  0xc(%ebp)
  8004a6:	ff 75 08             	pushl  0x8(%ebp)
  8004a9:	e8 05 00 00 00       	call   8004b3 <vprintfmt>
}
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <vprintfmt>:
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	57                   	push   %edi
  8004b7:	56                   	push   %esi
  8004b8:	53                   	push   %ebx
  8004b9:	83 ec 3c             	sub    $0x3c,%esp
  8004bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004c5:	e9 32 04 00 00       	jmp    8008fc <vprintfmt+0x449>
		padc = ' ';
  8004ca:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004ce:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004d5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004ea:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004f1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8d 47 01             	lea    0x1(%edi),%eax
  8004f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fc:	0f b6 17             	movzbl (%edi),%edx
  8004ff:	8d 42 dd             	lea    -0x23(%edx),%eax
  800502:	3c 55                	cmp    $0x55,%al
  800504:	0f 87 12 05 00 00    	ja     800a1c <vprintfmt+0x569>
  80050a:	0f b6 c0             	movzbl %al,%eax
  80050d:	ff 24 85 c0 2a 80 00 	jmp    *0x802ac0(,%eax,4)
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800517:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80051b:	eb d9                	jmp    8004f6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80051d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800520:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800524:	eb d0                	jmp    8004f6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800526:	0f b6 d2             	movzbl %dl,%edx
  800529:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80052c:	b8 00 00 00 00       	mov    $0x0,%eax
  800531:	89 75 08             	mov    %esi,0x8(%ebp)
  800534:	eb 03                	jmp    800539 <vprintfmt+0x86>
  800536:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800539:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80053c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800540:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800543:	8d 72 d0             	lea    -0x30(%edx),%esi
  800546:	83 fe 09             	cmp    $0x9,%esi
  800549:	76 eb                	jbe    800536 <vprintfmt+0x83>
  80054b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054e:	8b 75 08             	mov    0x8(%ebp),%esi
  800551:	eb 14                	jmp    800567 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8d 40 04             	lea    0x4(%eax),%eax
  800561:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800567:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056b:	79 89                	jns    8004f6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800573:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80057a:	e9 77 ff ff ff       	jmp    8004f6 <vprintfmt+0x43>
  80057f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800582:	85 c0                	test   %eax,%eax
  800584:	0f 48 c1             	cmovs  %ecx,%eax
  800587:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058d:	e9 64 ff ff ff       	jmp    8004f6 <vprintfmt+0x43>
  800592:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800595:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80059c:	e9 55 ff ff ff       	jmp    8004f6 <vprintfmt+0x43>
			lflag++;
  8005a1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005a8:	e9 49 ff ff ff       	jmp    8004f6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 78 04             	lea    0x4(%eax),%edi
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	53                   	push   %ebx
  8005b7:	ff 30                	pushl  (%eax)
  8005b9:	ff d6                	call   *%esi
			break;
  8005bb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005be:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005c1:	e9 33 03 00 00       	jmp    8008f9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 78 04             	lea    0x4(%eax),%edi
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	99                   	cltd   
  8005cf:	31 d0                	xor    %edx,%eax
  8005d1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005d3:	83 f8 11             	cmp    $0x11,%eax
  8005d6:	7f 23                	jg     8005fb <vprintfmt+0x148>
  8005d8:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  8005df:	85 d2                	test   %edx,%edx
  8005e1:	74 18                	je     8005fb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005e3:	52                   	push   %edx
  8005e4:	68 41 2d 80 00       	push   $0x802d41
  8005e9:	53                   	push   %ebx
  8005ea:	56                   	push   %esi
  8005eb:	e8 a6 fe ff ff       	call   800496 <printfmt>
  8005f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005f6:	e9 fe 02 00 00       	jmp    8008f9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005fb:	50                   	push   %eax
  8005fc:	68 ef 28 80 00       	push   $0x8028ef
  800601:	53                   	push   %ebx
  800602:	56                   	push   %esi
  800603:	e8 8e fe ff ff       	call   800496 <printfmt>
  800608:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80060b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80060e:	e9 e6 02 00 00       	jmp    8008f9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 c0 04             	add    $0x4,%eax
  800619:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800621:	85 c9                	test   %ecx,%ecx
  800623:	b8 e8 28 80 00       	mov    $0x8028e8,%eax
  800628:	0f 45 c1             	cmovne %ecx,%eax
  80062b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80062e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800632:	7e 06                	jle    80063a <vprintfmt+0x187>
  800634:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800638:	75 0d                	jne    800647 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80063a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80063d:	89 c7                	mov    %eax,%edi
  80063f:	03 45 e0             	add    -0x20(%ebp),%eax
  800642:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800645:	eb 53                	jmp    80069a <vprintfmt+0x1e7>
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	ff 75 d8             	pushl  -0x28(%ebp)
  80064d:	50                   	push   %eax
  80064e:	e8 71 04 00 00       	call   800ac4 <strnlen>
  800653:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800656:	29 c1                	sub    %eax,%ecx
  800658:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800660:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800664:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800667:	eb 0f                	jmp    800678 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	53                   	push   %ebx
  80066d:	ff 75 e0             	pushl  -0x20(%ebp)
  800670:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800672:	83 ef 01             	sub    $0x1,%edi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	85 ff                	test   %edi,%edi
  80067a:	7f ed                	jg     800669 <vprintfmt+0x1b6>
  80067c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80067f:	85 c9                	test   %ecx,%ecx
  800681:	b8 00 00 00 00       	mov    $0x0,%eax
  800686:	0f 49 c1             	cmovns %ecx,%eax
  800689:	29 c1                	sub    %eax,%ecx
  80068b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80068e:	eb aa                	jmp    80063a <vprintfmt+0x187>
					putch(ch, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	52                   	push   %edx
  800695:	ff d6                	call   *%esi
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069f:	83 c7 01             	add    $0x1,%edi
  8006a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a6:	0f be d0             	movsbl %al,%edx
  8006a9:	85 d2                	test   %edx,%edx
  8006ab:	74 4b                	je     8006f8 <vprintfmt+0x245>
  8006ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006b1:	78 06                	js     8006b9 <vprintfmt+0x206>
  8006b3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006b7:	78 1e                	js     8006d7 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006bd:	74 d1                	je     800690 <vprintfmt+0x1dd>
  8006bf:	0f be c0             	movsbl %al,%eax
  8006c2:	83 e8 20             	sub    $0x20,%eax
  8006c5:	83 f8 5e             	cmp    $0x5e,%eax
  8006c8:	76 c6                	jbe    800690 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	6a 3f                	push   $0x3f
  8006d0:	ff d6                	call   *%esi
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	eb c3                	jmp    80069a <vprintfmt+0x1e7>
  8006d7:	89 cf                	mov    %ecx,%edi
  8006d9:	eb 0e                	jmp    8006e9 <vprintfmt+0x236>
				putch(' ', putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 20                	push   $0x20
  8006e1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006e3:	83 ef 01             	sub    $0x1,%edi
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	85 ff                	test   %edi,%edi
  8006eb:	7f ee                	jg     8006db <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	e9 01 02 00 00       	jmp    8008f9 <vprintfmt+0x446>
  8006f8:	89 cf                	mov    %ecx,%edi
  8006fa:	eb ed                	jmp    8006e9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006ff:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800706:	e9 eb fd ff ff       	jmp    8004f6 <vprintfmt+0x43>
	if (lflag >= 2)
  80070b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070f:	7f 21                	jg     800732 <vprintfmt+0x27f>
	else if (lflag)
  800711:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800715:	74 68                	je     80077f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80071f:	89 c1                	mov    %eax,%ecx
  800721:	c1 f9 1f             	sar    $0x1f,%ecx
  800724:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
  800730:	eb 17                	jmp    800749 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 50 04             	mov    0x4(%eax),%edx
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8d 40 08             	lea    0x8(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800749:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80074c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80074f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800752:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800755:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800759:	78 3f                	js     80079a <vprintfmt+0x2e7>
			base = 10;
  80075b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800760:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800764:	0f 84 71 01 00 00    	je     8008db <vprintfmt+0x428>
				putch('+', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 2b                	push   $0x2b
  800770:	ff d6                	call   *%esi
  800772:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800775:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077a:	e9 5c 01 00 00       	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800787:	89 c1                	mov    %eax,%ecx
  800789:	c1 f9 1f             	sar    $0x1f,%ecx
  80078c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
  800798:	eb af                	jmp    800749 <vprintfmt+0x296>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	6a 2d                	push   $0x2d
  8007a0:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a8:	f7 d8                	neg    %eax
  8007aa:	83 d2 00             	adc    $0x0,%edx
  8007ad:	f7 da                	neg    %edx
  8007af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bd:	e9 19 01 00 00       	jmp    8008db <vprintfmt+0x428>
	if (lflag >= 2)
  8007c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c6:	7f 29                	jg     8007f1 <vprintfmt+0x33e>
	else if (lflag)
  8007c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007cc:	74 44                	je     800812 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ec:	e9 ea 00 00 00       	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 50 04             	mov    0x4(%eax),%edx
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8d 40 08             	lea    0x8(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	e9 c9 00 00 00       	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8d 40 04             	lea    0x4(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800830:	e9 a6 00 00 00       	jmp    8008db <vprintfmt+0x428>
			putch('0', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	6a 30                	push   $0x30
  80083b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800844:	7f 26                	jg     80086c <vprintfmt+0x3b9>
	else if (lflag)
  800846:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80084a:	74 3e                	je     80088a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	ba 00 00 00 00       	mov    $0x0,%edx
  800856:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800859:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 40 04             	lea    0x4(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800865:	b8 08 00 00 00       	mov    $0x8,%eax
  80086a:	eb 6f                	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800877:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 08             	lea    0x8(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800883:	b8 08 00 00 00       	mov    $0x8,%eax
  800888:	eb 51                	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	ba 00 00 00 00       	mov    $0x0,%edx
  800894:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800897:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8d 40 04             	lea    0x4(%eax),%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a8:	eb 31                	jmp    8008db <vprintfmt+0x428>
			putch('0', putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	53                   	push   %ebx
  8008ae:	6a 30                	push   $0x30
  8008b0:	ff d6                	call   *%esi
			putch('x', putdat);
  8008b2:	83 c4 08             	add    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	6a 78                	push   $0x78
  8008b8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008ca:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008db:	83 ec 0c             	sub    $0xc,%esp
  8008de:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008e2:	52                   	push   %edx
  8008e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e6:	50                   	push   %eax
  8008e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8008ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ed:	89 da                	mov    %ebx,%edx
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	e8 a4 fa ff ff       	call   80039a <printnum>
			break;
  8008f6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fc:	83 c7 01             	add    $0x1,%edi
  8008ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800903:	83 f8 25             	cmp    $0x25,%eax
  800906:	0f 84 be fb ff ff    	je     8004ca <vprintfmt+0x17>
			if (ch == '\0')
  80090c:	85 c0                	test   %eax,%eax
  80090e:	0f 84 28 01 00 00    	je     800a3c <vprintfmt+0x589>
			putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	50                   	push   %eax
  800919:	ff d6                	call   *%esi
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	eb dc                	jmp    8008fc <vprintfmt+0x449>
	if (lflag >= 2)
  800920:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800924:	7f 26                	jg     80094c <vprintfmt+0x499>
	else if (lflag)
  800926:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80092a:	74 41                	je     80096d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	ba 00 00 00 00       	mov    $0x0,%edx
  800936:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800939:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800945:	b8 10 00 00 00       	mov    $0x10,%eax
  80094a:	eb 8f                	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 50 04             	mov    0x4(%eax),%edx
  800952:	8b 00                	mov    (%eax),%eax
  800954:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800957:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8d 40 08             	lea    0x8(%eax),%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800963:	b8 10 00 00 00       	mov    $0x10,%eax
  800968:	e9 6e ff ff ff       	jmp    8008db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8d 40 04             	lea    0x4(%eax),%eax
  800983:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800986:	b8 10 00 00 00       	mov    $0x10,%eax
  80098b:	e9 4b ff ff ff       	jmp    8008db <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	74 14                	je     8009b6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009a2:	8b 13                	mov    (%ebx),%edx
  8009a4:	83 fa 7f             	cmp    $0x7f,%edx
  8009a7:	7f 37                	jg     8009e0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009a9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b1:	e9 43 ff ff ff       	jmp    8008f9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009bb:	bf 0d 2a 80 00       	mov    $0x802a0d,%edi
							putch(ch, putdat);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	53                   	push   %ebx
  8009c4:	50                   	push   %eax
  8009c5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009c7:	83 c7 01             	add    $0x1,%edi
  8009ca:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	85 c0                	test   %eax,%eax
  8009d3:	75 eb                	jne    8009c0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009db:	e9 19 ff ff ff       	jmp    8008f9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009e0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009e7:	bf 45 2a 80 00       	mov    $0x802a45,%edi
							putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	53                   	push   %ebx
  8009f0:	50                   	push   %eax
  8009f1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009f3:	83 c7 01             	add    $0x1,%edi
  8009f6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	85 c0                	test   %eax,%eax
  8009ff:	75 eb                	jne    8009ec <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	e9 ed fe ff ff       	jmp    8008f9 <vprintfmt+0x446>
			putch(ch, putdat);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	53                   	push   %ebx
  800a10:	6a 25                	push   $0x25
  800a12:	ff d6                	call   *%esi
			break;
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	e9 dd fe ff ff       	jmp    8008f9 <vprintfmt+0x446>
			putch('%', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	53                   	push   %ebx
  800a20:	6a 25                	push   $0x25
  800a22:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a24:	83 c4 10             	add    $0x10,%esp
  800a27:	89 f8                	mov    %edi,%eax
  800a29:	eb 03                	jmp    800a2e <vprintfmt+0x57b>
  800a2b:	83 e8 01             	sub    $0x1,%eax
  800a2e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a32:	75 f7                	jne    800a2b <vprintfmt+0x578>
  800a34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a37:	e9 bd fe ff ff       	jmp    8008f9 <vprintfmt+0x446>
}
  800a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 18             	sub    $0x18,%esp
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a53:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a57:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a61:	85 c0                	test   %eax,%eax
  800a63:	74 26                	je     800a8b <vsnprintf+0x47>
  800a65:	85 d2                	test   %edx,%edx
  800a67:	7e 22                	jle    800a8b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a69:	ff 75 14             	pushl  0x14(%ebp)
  800a6c:	ff 75 10             	pushl  0x10(%ebp)
  800a6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a72:	50                   	push   %eax
  800a73:	68 79 04 80 00       	push   $0x800479
  800a78:	e8 36 fa ff ff       	call   8004b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a86:	83 c4 10             	add    $0x10,%esp
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    
		return -E_INVAL;
  800a8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a90:	eb f7                	jmp    800a89 <vsnprintf+0x45>

00800a92 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a98:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a9b:	50                   	push   %eax
  800a9c:	ff 75 10             	pushl  0x10(%ebp)
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	ff 75 08             	pushl  0x8(%ebp)
  800aa5:	e8 9a ff ff ff       	call   800a44 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800abb:	74 05                	je     800ac2 <strlen+0x16>
		n++;
  800abd:	83 c0 01             	add    $0x1,%eax
  800ac0:	eb f5                	jmp    800ab7 <strlen+0xb>
	return n;
}
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800acd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad2:	39 c2                	cmp    %eax,%edx
  800ad4:	74 0d                	je     800ae3 <strnlen+0x1f>
  800ad6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ada:	74 05                	je     800ae1 <strnlen+0x1d>
		n++;
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	eb f1                	jmp    800ad2 <strnlen+0xe>
  800ae1:	89 d0                	mov    %edx,%eax
	return n;
}
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	53                   	push   %ebx
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aef:	ba 00 00 00 00       	mov    $0x0,%edx
  800af4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800af8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800afb:	83 c2 01             	add    $0x1,%edx
  800afe:	84 c9                	test   %cl,%cl
  800b00:	75 f2                	jne    800af4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b02:	5b                   	pop    %ebx
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	53                   	push   %ebx
  800b09:	83 ec 10             	sub    $0x10,%esp
  800b0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b0f:	53                   	push   %ebx
  800b10:	e8 97 ff ff ff       	call   800aac <strlen>
  800b15:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	01 d8                	add    %ebx,%eax
  800b1d:	50                   	push   %eax
  800b1e:	e8 c2 ff ff ff       	call   800ae5 <strcpy>
	return dst;
}
  800b23:	89 d8                	mov    %ebx,%eax
  800b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b35:	89 c6                	mov    %eax,%esi
  800b37:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b3a:	89 c2                	mov    %eax,%edx
  800b3c:	39 f2                	cmp    %esi,%edx
  800b3e:	74 11                	je     800b51 <strncpy+0x27>
		*dst++ = *src;
  800b40:	83 c2 01             	add    $0x1,%edx
  800b43:	0f b6 19             	movzbl (%ecx),%ebx
  800b46:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b49:	80 fb 01             	cmp    $0x1,%bl
  800b4c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b4f:	eb eb                	jmp    800b3c <strncpy+0x12>
	}
	return ret;
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	8b 55 10             	mov    0x10(%ebp),%edx
  800b63:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b65:	85 d2                	test   %edx,%edx
  800b67:	74 21                	je     800b8a <strlcpy+0x35>
  800b69:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b6d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b6f:	39 c2                	cmp    %eax,%edx
  800b71:	74 14                	je     800b87 <strlcpy+0x32>
  800b73:	0f b6 19             	movzbl (%ecx),%ebx
  800b76:	84 db                	test   %bl,%bl
  800b78:	74 0b                	je     800b85 <strlcpy+0x30>
			*dst++ = *src++;
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	83 c2 01             	add    $0x1,%edx
  800b80:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b83:	eb ea                	jmp    800b6f <strlcpy+0x1a>
  800b85:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b8a:	29 f0                	sub    %esi,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b99:	0f b6 01             	movzbl (%ecx),%eax
  800b9c:	84 c0                	test   %al,%al
  800b9e:	74 0c                	je     800bac <strcmp+0x1c>
  800ba0:	3a 02                	cmp    (%edx),%al
  800ba2:	75 08                	jne    800bac <strcmp+0x1c>
		p++, q++;
  800ba4:	83 c1 01             	add    $0x1,%ecx
  800ba7:	83 c2 01             	add    $0x1,%edx
  800baa:	eb ed                	jmp    800b99 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bac:	0f b6 c0             	movzbl %al,%eax
  800baf:	0f b6 12             	movzbl (%edx),%edx
  800bb2:	29 d0                	sub    %edx,%eax
}
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	89 c3                	mov    %eax,%ebx
  800bc2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc5:	eb 06                	jmp    800bcd <strncmp+0x17>
		n--, p++, q++;
  800bc7:	83 c0 01             	add    $0x1,%eax
  800bca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bcd:	39 d8                	cmp    %ebx,%eax
  800bcf:	74 16                	je     800be7 <strncmp+0x31>
  800bd1:	0f b6 08             	movzbl (%eax),%ecx
  800bd4:	84 c9                	test   %cl,%cl
  800bd6:	74 04                	je     800bdc <strncmp+0x26>
  800bd8:	3a 0a                	cmp    (%edx),%cl
  800bda:	74 eb                	je     800bc7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bdc:	0f b6 00             	movzbl (%eax),%eax
  800bdf:	0f b6 12             	movzbl (%edx),%edx
  800be2:	29 d0                	sub    %edx,%eax
}
  800be4:	5b                   	pop    %ebx
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    
		return 0;
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bec:	eb f6                	jmp    800be4 <strncmp+0x2e>

00800bee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf8:	0f b6 10             	movzbl (%eax),%edx
  800bfb:	84 d2                	test   %dl,%dl
  800bfd:	74 09                	je     800c08 <strchr+0x1a>
		if (*s == c)
  800bff:	38 ca                	cmp    %cl,%dl
  800c01:	74 0a                	je     800c0d <strchr+0x1f>
	for (; *s; s++)
  800c03:	83 c0 01             	add    $0x1,%eax
  800c06:	eb f0                	jmp    800bf8 <strchr+0xa>
			return (char *) s;
	return 0;
  800c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c1c:	38 ca                	cmp    %cl,%dl
  800c1e:	74 09                	je     800c29 <strfind+0x1a>
  800c20:	84 d2                	test   %dl,%dl
  800c22:	74 05                	je     800c29 <strfind+0x1a>
	for (; *s; s++)
  800c24:	83 c0 01             	add    $0x1,%eax
  800c27:	eb f0                	jmp    800c19 <strfind+0xa>
			break;
	return (char *) s;
}
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c37:	85 c9                	test   %ecx,%ecx
  800c39:	74 31                	je     800c6c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c3b:	89 f8                	mov    %edi,%eax
  800c3d:	09 c8                	or     %ecx,%eax
  800c3f:	a8 03                	test   $0x3,%al
  800c41:	75 23                	jne    800c66 <memset+0x3b>
		c &= 0xFF;
  800c43:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	c1 e3 08             	shl    $0x8,%ebx
  800c4c:	89 d0                	mov    %edx,%eax
  800c4e:	c1 e0 18             	shl    $0x18,%eax
  800c51:	89 d6                	mov    %edx,%esi
  800c53:	c1 e6 10             	shl    $0x10,%esi
  800c56:	09 f0                	or     %esi,%eax
  800c58:	09 c2                	or     %eax,%edx
  800c5a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c5c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c5f:	89 d0                	mov    %edx,%eax
  800c61:	fc                   	cld    
  800c62:	f3 ab                	rep stos %eax,%es:(%edi)
  800c64:	eb 06                	jmp    800c6c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	fc                   	cld    
  800c6a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c6c:	89 f8                	mov    %edi,%eax
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c81:	39 c6                	cmp    %eax,%esi
  800c83:	73 32                	jae    800cb7 <memmove+0x44>
  800c85:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c88:	39 c2                	cmp    %eax,%edx
  800c8a:	76 2b                	jbe    800cb7 <memmove+0x44>
		s += n;
		d += n;
  800c8c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8f:	89 fe                	mov    %edi,%esi
  800c91:	09 ce                	or     %ecx,%esi
  800c93:	09 d6                	or     %edx,%esi
  800c95:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c9b:	75 0e                	jne    800cab <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c9d:	83 ef 04             	sub    $0x4,%edi
  800ca0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ca3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca6:	fd                   	std    
  800ca7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca9:	eb 09                	jmp    800cb4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cab:	83 ef 01             	sub    $0x1,%edi
  800cae:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cb1:	fd                   	std    
  800cb2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb4:	fc                   	cld    
  800cb5:	eb 1a                	jmp    800cd1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb7:	89 c2                	mov    %eax,%edx
  800cb9:	09 ca                	or     %ecx,%edx
  800cbb:	09 f2                	or     %esi,%edx
  800cbd:	f6 c2 03             	test   $0x3,%dl
  800cc0:	75 0a                	jne    800ccc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cc2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cc5:	89 c7                	mov    %eax,%edi
  800cc7:	fc                   	cld    
  800cc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cca:	eb 05                	jmp    800cd1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ccc:	89 c7                	mov    %eax,%edi
  800cce:	fc                   	cld    
  800ccf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cdb:	ff 75 10             	pushl  0x10(%ebp)
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	e8 8a ff ff ff       	call   800c73 <memmove>
}
  800ce9:	c9                   	leave  
  800cea:	c3                   	ret    

00800ceb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf6:	89 c6                	mov    %eax,%esi
  800cf8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cfb:	39 f0                	cmp    %esi,%eax
  800cfd:	74 1c                	je     800d1b <memcmp+0x30>
		if (*s1 != *s2)
  800cff:	0f b6 08             	movzbl (%eax),%ecx
  800d02:	0f b6 1a             	movzbl (%edx),%ebx
  800d05:	38 d9                	cmp    %bl,%cl
  800d07:	75 08                	jne    800d11 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d09:	83 c0 01             	add    $0x1,%eax
  800d0c:	83 c2 01             	add    $0x1,%edx
  800d0f:	eb ea                	jmp    800cfb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d11:	0f b6 c1             	movzbl %cl,%eax
  800d14:	0f b6 db             	movzbl %bl,%ebx
  800d17:	29 d8                	sub    %ebx,%eax
  800d19:	eb 05                	jmp    800d20 <memcmp+0x35>
	}

	return 0;
  800d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d32:	39 d0                	cmp    %edx,%eax
  800d34:	73 09                	jae    800d3f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d36:	38 08                	cmp    %cl,(%eax)
  800d38:	74 05                	je     800d3f <memfind+0x1b>
	for (; s < ends; s++)
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	eb f3                	jmp    800d32 <memfind+0xe>
			break;
	return (void *) s;
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4d:	eb 03                	jmp    800d52 <strtol+0x11>
		s++;
  800d4f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d52:	0f b6 01             	movzbl (%ecx),%eax
  800d55:	3c 20                	cmp    $0x20,%al
  800d57:	74 f6                	je     800d4f <strtol+0xe>
  800d59:	3c 09                	cmp    $0x9,%al
  800d5b:	74 f2                	je     800d4f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d5d:	3c 2b                	cmp    $0x2b,%al
  800d5f:	74 2a                	je     800d8b <strtol+0x4a>
	int neg = 0;
  800d61:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d66:	3c 2d                	cmp    $0x2d,%al
  800d68:	74 2b                	je     800d95 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d6a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d70:	75 0f                	jne    800d81 <strtol+0x40>
  800d72:	80 39 30             	cmpb   $0x30,(%ecx)
  800d75:	74 28                	je     800d9f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d77:	85 db                	test   %ebx,%ebx
  800d79:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7e:	0f 44 d8             	cmove  %eax,%ebx
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
  800d86:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d89:	eb 50                	jmp    800ddb <strtol+0x9a>
		s++;
  800d8b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d93:	eb d5                	jmp    800d6a <strtol+0x29>
		s++, neg = 1;
  800d95:	83 c1 01             	add    $0x1,%ecx
  800d98:	bf 01 00 00 00       	mov    $0x1,%edi
  800d9d:	eb cb                	jmp    800d6a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800da3:	74 0e                	je     800db3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800da5:	85 db                	test   %ebx,%ebx
  800da7:	75 d8                	jne    800d81 <strtol+0x40>
		s++, base = 8;
  800da9:	83 c1 01             	add    $0x1,%ecx
  800dac:	bb 08 00 00 00       	mov    $0x8,%ebx
  800db1:	eb ce                	jmp    800d81 <strtol+0x40>
		s += 2, base = 16;
  800db3:	83 c1 02             	add    $0x2,%ecx
  800db6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dbb:	eb c4                	jmp    800d81 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dbd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dc0:	89 f3                	mov    %esi,%ebx
  800dc2:	80 fb 19             	cmp    $0x19,%bl
  800dc5:	77 29                	ja     800df0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dc7:	0f be d2             	movsbl %dl,%edx
  800dca:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dcd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dd0:	7d 30                	jge    800e02 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dd2:	83 c1 01             	add    $0x1,%ecx
  800dd5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ddb:	0f b6 11             	movzbl (%ecx),%edx
  800dde:	8d 72 d0             	lea    -0x30(%edx),%esi
  800de1:	89 f3                	mov    %esi,%ebx
  800de3:	80 fb 09             	cmp    $0x9,%bl
  800de6:	77 d5                	ja     800dbd <strtol+0x7c>
			dig = *s - '0';
  800de8:	0f be d2             	movsbl %dl,%edx
  800deb:	83 ea 30             	sub    $0x30,%edx
  800dee:	eb dd                	jmp    800dcd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800df0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800df3:	89 f3                	mov    %esi,%ebx
  800df5:	80 fb 19             	cmp    $0x19,%bl
  800df8:	77 08                	ja     800e02 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dfa:	0f be d2             	movsbl %dl,%edx
  800dfd:	83 ea 37             	sub    $0x37,%edx
  800e00:	eb cb                	jmp    800dcd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e06:	74 05                	je     800e0d <strtol+0xcc>
		*endptr = (char *) s;
  800e08:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e0b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	f7 da                	neg    %edx
  800e11:	85 ff                	test   %edi,%edi
  800e13:	0f 45 c2             	cmovne %edx,%eax
}
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e21:	b8 00 00 00 00       	mov    $0x0,%eax
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2c:	89 c3                	mov    %eax,%ebx
  800e2e:	89 c7                	mov    %eax,%edi
  800e30:	89 c6                	mov    %eax,%esi
  800e32:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	b8 01 00 00 00       	mov    $0x1,%eax
  800e49:	89 d1                	mov    %edx,%ecx
  800e4b:	89 d3                	mov    %edx,%ebx
  800e4d:	89 d7                	mov    %edx,%edi
  800e4f:	89 d6                	mov    %edx,%esi
  800e51:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
  800e5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	b8 03 00 00 00       	mov    $0x3,%eax
  800e6e:	89 cb                	mov    %ecx,%ebx
  800e70:	89 cf                	mov    %ecx,%edi
  800e72:	89 ce                	mov    %ecx,%esi
  800e74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	7f 08                	jg     800e82 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	50                   	push   %eax
  800e86:	6a 03                	push   $0x3
  800e88:	68 68 2c 80 00       	push   $0x802c68
  800e8d:	6a 43                	push   $0x43
  800e8f:	68 85 2c 80 00       	push   $0x802c85
  800e94:	e8 f7 f3 ff ff       	call   800290 <_panic>

00800e99 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea4:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea9:	89 d1                	mov    %edx,%ecx
  800eab:	89 d3                	mov    %edx,%ebx
  800ead:	89 d7                	mov    %edx,%edi
  800eaf:	89 d6                	mov    %edx,%esi
  800eb1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <sys_yield>:

void
sys_yield(void)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec8:	89 d1                	mov    %edx,%ecx
  800eca:	89 d3                	mov    %edx,%ebx
  800ecc:	89 d7                	mov    %edx,%edi
  800ece:	89 d6                	mov    %edx,%esi
  800ed0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    

00800ed7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee0:	be 00 00 00 00       	mov    $0x0,%esi
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	b8 04 00 00 00       	mov    $0x4,%eax
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	89 f7                	mov    %esi,%edi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 04                	push   $0x4
  800f09:	68 68 2c 80 00       	push   $0x802c68
  800f0e:	6a 43                	push   $0x43
  800f10:	68 85 2c 80 00       	push   $0x802c85
  800f15:	e8 76 f3 ff ff       	call   800290 <_panic>

00800f1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	b8 05 00 00 00       	mov    $0x5,%eax
  800f2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f34:	8b 75 18             	mov    0x18(%ebp),%esi
  800f37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7f 08                	jg     800f45 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	50                   	push   %eax
  800f49:	6a 05                	push   $0x5
  800f4b:	68 68 2c 80 00       	push   $0x802c68
  800f50:	6a 43                	push   $0x43
  800f52:	68 85 2c 80 00       	push   $0x802c85
  800f57:	e8 34 f3 ff ff       	call   800290 <_panic>

00800f5c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	b8 06 00 00 00       	mov    $0x6,%eax
  800f75:	89 df                	mov    %ebx,%edi
  800f77:	89 de                	mov    %ebx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 06                	push   $0x6
  800f8d:	68 68 2c 80 00       	push   $0x802c68
  800f92:	6a 43                	push   $0x43
  800f94:	68 85 2c 80 00       	push   $0x802c85
  800f99:	e8 f2 f2 ff ff       	call   800290 <_panic>

00800f9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7f 08                	jg     800fc9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	50                   	push   %eax
  800fcd:	6a 08                	push   $0x8
  800fcf:	68 68 2c 80 00       	push   $0x802c68
  800fd4:	6a 43                	push   $0x43
  800fd6:	68 85 2c 80 00       	push   $0x802c85
  800fdb:	e8 b0 f2 ff ff       	call   800290 <_panic>

00800fe0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
  800fe6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff9:	89 df                	mov    %ebx,%edi
  800ffb:	89 de                	mov    %ebx,%esi
  800ffd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fff:	85 c0                	test   %eax,%eax
  801001:	7f 08                	jg     80100b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	50                   	push   %eax
  80100f:	6a 09                	push   $0x9
  801011:	68 68 2c 80 00       	push   $0x802c68
  801016:	6a 43                	push   $0x43
  801018:	68 85 2c 80 00       	push   $0x802c85
  80101d:	e8 6e f2 ff ff       	call   800290 <_panic>

00801022 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
  801028:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	b8 0a 00 00 00       	mov    $0xa,%eax
  80103b:	89 df                	mov    %ebx,%edi
  80103d:	89 de                	mov    %ebx,%esi
  80103f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801041:	85 c0                	test   %eax,%eax
  801043:	7f 08                	jg     80104d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801045:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	50                   	push   %eax
  801051:	6a 0a                	push   $0xa
  801053:	68 68 2c 80 00       	push   $0x802c68
  801058:	6a 43                	push   $0x43
  80105a:	68 85 2c 80 00       	push   $0x802c85
  80105f:	e8 2c f2 ff ff       	call   800290 <_panic>

00801064 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106a:	8b 55 08             	mov    0x8(%ebp),%edx
  80106d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801070:	b8 0c 00 00 00       	mov    $0xc,%eax
  801075:	be 00 00 00 00       	mov    $0x0,%esi
  80107a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80107d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801080:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5f                   	pop    %edi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	57                   	push   %edi
  80108b:	56                   	push   %esi
  80108c:	53                   	push   %ebx
  80108d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801090:	b9 00 00 00 00       	mov    $0x0,%ecx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	b8 0d 00 00 00       	mov    $0xd,%eax
  80109d:	89 cb                	mov    %ecx,%ebx
  80109f:	89 cf                	mov    %ecx,%edi
  8010a1:	89 ce                	mov    %ecx,%esi
  8010a3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	7f 08                	jg     8010b1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b1:	83 ec 0c             	sub    $0xc,%esp
  8010b4:	50                   	push   %eax
  8010b5:	6a 0d                	push   $0xd
  8010b7:	68 68 2c 80 00       	push   $0x802c68
  8010bc:	6a 43                	push   $0x43
  8010be:	68 85 2c 80 00       	push   $0x802c85
  8010c3:	e8 c8 f1 ff ff       	call   800290 <_panic>

008010c8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	57                   	push   %edi
  8010cc:	56                   	push   %esi
  8010cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5f                   	pop    %edi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010fc:	89 cb                	mov    %ecx,%ebx
  8010fe:	89 cf                	mov    %ecx,%edi
  801100:	89 ce                	mov    %ecx,%esi
  801102:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	57                   	push   %edi
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110f:	ba 00 00 00 00       	mov    $0x0,%edx
  801114:	b8 10 00 00 00       	mov    $0x10,%eax
  801119:	89 d1                	mov    %edx,%ecx
  80111b:	89 d3                	mov    %edx,%ebx
  80111d:	89 d7                	mov    %edx,%edi
  80111f:	89 d6                	mov    %edx,%esi
  801121:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801139:	b8 11 00 00 00       	mov    $0x11,%eax
  80113e:	89 df                	mov    %ebx,%edi
  801140:	89 de                	mov    %ebx,%esi
  801142:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	57                   	push   %edi
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115a:	b8 12 00 00 00       	mov    $0x12,%eax
  80115f:	89 df                	mov    %ebx,%edi
  801161:	89 de                	mov    %ebx,%esi
  801163:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801165:	5b                   	pop    %ebx
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	57                   	push   %edi
  80116e:	56                   	push   %esi
  80116f:	53                   	push   %ebx
  801170:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801173:	bb 00 00 00 00       	mov    $0x0,%ebx
  801178:	8b 55 08             	mov    0x8(%ebp),%edx
  80117b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117e:	b8 13 00 00 00       	mov    $0x13,%eax
  801183:	89 df                	mov    %ebx,%edi
  801185:	89 de                	mov    %ebx,%esi
  801187:	cd 30                	int    $0x30
	if(check && ret > 0)
  801189:	85 c0                	test   %eax,%eax
  80118b:	7f 08                	jg     801195 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80118d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801190:	5b                   	pop    %ebx
  801191:	5e                   	pop    %esi
  801192:	5f                   	pop    %edi
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	50                   	push   %eax
  801199:	6a 13                	push   $0x13
  80119b:	68 68 2c 80 00       	push   $0x802c68
  8011a0:	6a 43                	push   $0x43
  8011a2:	68 85 2c 80 00       	push   $0x802c85
  8011a7:	e8 e4 f0 ff ff       	call   800290 <_panic>

008011ac <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ba:	b8 14 00 00 00       	mov    $0x14,%eax
  8011bf:	89 cb                	mov    %ecx,%ebx
  8011c1:	89 cf                	mov    %ecx,%edi
  8011c3:	89 ce                	mov    %ecx,%esi
  8011c5:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	05 00 00 00 30       	add    $0x30000000,%eax
  8011d7:	c1 e8 0c             	shr    $0xc,%eax
}
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	c1 ea 16             	shr    $0x16,%edx
  801200:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801207:	f6 c2 01             	test   $0x1,%dl
  80120a:	74 2d                	je     801239 <fd_alloc+0x46>
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	c1 ea 0c             	shr    $0xc,%edx
  801211:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801218:	f6 c2 01             	test   $0x1,%dl
  80121b:	74 1c                	je     801239 <fd_alloc+0x46>
  80121d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801222:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801227:	75 d2                	jne    8011fb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801232:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801237:	eb 0a                	jmp    801243 <fd_alloc+0x50>
			*fd_store = fd;
  801239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801243:	5d                   	pop    %ebp
  801244:	c3                   	ret    

00801245 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80124b:	83 f8 1f             	cmp    $0x1f,%eax
  80124e:	77 30                	ja     801280 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801250:	c1 e0 0c             	shl    $0xc,%eax
  801253:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801258:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80125e:	f6 c2 01             	test   $0x1,%dl
  801261:	74 24                	je     801287 <fd_lookup+0x42>
  801263:	89 c2                	mov    %eax,%edx
  801265:	c1 ea 0c             	shr    $0xc,%edx
  801268:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126f:	f6 c2 01             	test   $0x1,%dl
  801272:	74 1a                	je     80128e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	89 02                	mov    %eax,(%edx)
	return 0;
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    
		return -E_INVAL;
  801280:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801285:	eb f7                	jmp    80127e <fd_lookup+0x39>
		return -E_INVAL;
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128c:	eb f0                	jmp    80127e <fd_lookup+0x39>
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801293:	eb e9                	jmp    80127e <fd_lookup+0x39>

00801295 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 08             	sub    $0x8,%esp
  80129b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80129e:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a3:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a8:	39 08                	cmp    %ecx,(%eax)
  8012aa:	74 38                	je     8012e4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012ac:	83 c2 01             	add    $0x1,%edx
  8012af:	8b 04 95 14 2d 80 00 	mov    0x802d14(,%edx,4),%eax
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 ee                	jne    8012a8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012ba:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012bf:	8b 40 48             	mov    0x48(%eax),%eax
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	51                   	push   %ecx
  8012c6:	50                   	push   %eax
  8012c7:	68 94 2c 80 00       	push   $0x802c94
  8012cc:	e8 b5 f0 ff ff       	call   800386 <cprintf>
	*dev = 0;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012da:	83 c4 10             	add    $0x10,%esp
  8012dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    
			*dev = devtab[i];
  8012e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ee:	eb f2                	jmp    8012e2 <dev_lookup+0x4d>

008012f0 <fd_close>:
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	57                   	push   %edi
  8012f4:	56                   	push   %esi
  8012f5:	53                   	push   %ebx
  8012f6:	83 ec 24             	sub    $0x24,%esp
  8012f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8012fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801302:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801303:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801309:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130c:	50                   	push   %eax
  80130d:	e8 33 ff ff ff       	call   801245 <fd_lookup>
  801312:	89 c3                	mov    %eax,%ebx
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 05                	js     801320 <fd_close+0x30>
	    || fd != fd2)
  80131b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80131e:	74 16                	je     801336 <fd_close+0x46>
		return (must_exist ? r : 0);
  801320:	89 f8                	mov    %edi,%eax
  801322:	84 c0                	test   %al,%al
  801324:	b8 00 00 00 00       	mov    $0x0,%eax
  801329:	0f 44 d8             	cmove  %eax,%ebx
}
  80132c:	89 d8                	mov    %ebx,%eax
  80132e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5f                   	pop    %edi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	ff 36                	pushl  (%esi)
  80133f:	e8 51 ff ff ff       	call   801295 <dev_lookup>
  801344:	89 c3                	mov    %eax,%ebx
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 1a                	js     801367 <fd_close+0x77>
		if (dev->dev_close)
  80134d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801350:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801353:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 0b                	je     801367 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	56                   	push   %esi
  801360:	ff d0                	call   *%eax
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	56                   	push   %esi
  80136b:	6a 00                	push   $0x0
  80136d:	e8 ea fb ff ff       	call   800f5c <sys_page_unmap>
	return r;
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	eb b5                	jmp    80132c <fd_close+0x3c>

00801377 <close>:

int
close(int fdnum)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801380:	50                   	push   %eax
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 bc fe ff ff       	call   801245 <fd_lookup>
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	79 02                	jns    801392 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801390:	c9                   	leave  
  801391:	c3                   	ret    
		return fd_close(fd, 1);
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	6a 01                	push   $0x1
  801397:	ff 75 f4             	pushl  -0xc(%ebp)
  80139a:	e8 51 ff ff ff       	call   8012f0 <fd_close>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	eb ec                	jmp    801390 <close+0x19>

008013a4 <close_all>:

void
close_all(void)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	53                   	push   %ebx
  8013a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b0:	83 ec 0c             	sub    $0xc,%esp
  8013b3:	53                   	push   %ebx
  8013b4:	e8 be ff ff ff       	call   801377 <close>
	for (i = 0; i < MAXFD; i++)
  8013b9:	83 c3 01             	add    $0x1,%ebx
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	83 fb 20             	cmp    $0x20,%ebx
  8013c2:	75 ec                	jne    8013b0 <close_all+0xc>
}
  8013c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	57                   	push   %edi
  8013cd:	56                   	push   %esi
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d5:	50                   	push   %eax
  8013d6:	ff 75 08             	pushl  0x8(%ebp)
  8013d9:	e8 67 fe ff ff       	call   801245 <fd_lookup>
  8013de:	89 c3                	mov    %eax,%ebx
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	0f 88 81 00 00 00    	js     80146c <dup+0xa3>
		return r;
	close(newfdnum);
  8013eb:	83 ec 0c             	sub    $0xc,%esp
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	e8 81 ff ff ff       	call   801377 <close>

	newfd = INDEX2FD(newfdnum);
  8013f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013f9:	c1 e6 0c             	shl    $0xc,%esi
  8013fc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801402:	83 c4 04             	add    $0x4,%esp
  801405:	ff 75 e4             	pushl  -0x1c(%ebp)
  801408:	e8 cf fd ff ff       	call   8011dc <fd2data>
  80140d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80140f:	89 34 24             	mov    %esi,(%esp)
  801412:	e8 c5 fd ff ff       	call   8011dc <fd2data>
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80141c:	89 d8                	mov    %ebx,%eax
  80141e:	c1 e8 16             	shr    $0x16,%eax
  801421:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801428:	a8 01                	test   $0x1,%al
  80142a:	74 11                	je     80143d <dup+0x74>
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	c1 e8 0c             	shr    $0xc,%eax
  801431:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801438:	f6 c2 01             	test   $0x1,%dl
  80143b:	75 39                	jne    801476 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80143d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801440:	89 d0                	mov    %edx,%eax
  801442:	c1 e8 0c             	shr    $0xc,%eax
  801445:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80144c:	83 ec 0c             	sub    $0xc,%esp
  80144f:	25 07 0e 00 00       	and    $0xe07,%eax
  801454:	50                   	push   %eax
  801455:	56                   	push   %esi
  801456:	6a 00                	push   $0x0
  801458:	52                   	push   %edx
  801459:	6a 00                	push   $0x0
  80145b:	e8 ba fa ff ff       	call   800f1a <sys_page_map>
  801460:	89 c3                	mov    %eax,%ebx
  801462:	83 c4 20             	add    $0x20,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	78 31                	js     80149a <dup+0xd1>
		goto err;

	return newfdnum;
  801469:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801476:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147d:	83 ec 0c             	sub    $0xc,%esp
  801480:	25 07 0e 00 00       	and    $0xe07,%eax
  801485:	50                   	push   %eax
  801486:	57                   	push   %edi
  801487:	6a 00                	push   $0x0
  801489:	53                   	push   %ebx
  80148a:	6a 00                	push   $0x0
  80148c:	e8 89 fa ff ff       	call   800f1a <sys_page_map>
  801491:	89 c3                	mov    %eax,%ebx
  801493:	83 c4 20             	add    $0x20,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	79 a3                	jns    80143d <dup+0x74>
	sys_page_unmap(0, newfd);
  80149a:	83 ec 08             	sub    $0x8,%esp
  80149d:	56                   	push   %esi
  80149e:	6a 00                	push   $0x0
  8014a0:	e8 b7 fa ff ff       	call   800f5c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	57                   	push   %edi
  8014a9:	6a 00                	push   $0x0
  8014ab:	e8 ac fa ff ff       	call   800f5c <sys_page_unmap>
	return r;
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	eb b7                	jmp    80146c <dup+0xa3>

008014b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 1c             	sub    $0x1c,%esp
  8014bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c2:	50                   	push   %eax
  8014c3:	53                   	push   %ebx
  8014c4:	e8 7c fd ff ff       	call   801245 <fd_lookup>
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 3f                	js     80150f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d0:	83 ec 08             	sub    $0x8,%esp
  8014d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	ff 30                	pushl  (%eax)
  8014dc:	e8 b4 fd ff ff       	call   801295 <dev_lookup>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 27                	js     80150f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014eb:	8b 42 08             	mov    0x8(%edx),%eax
  8014ee:	83 e0 03             	and    $0x3,%eax
  8014f1:	83 f8 01             	cmp    $0x1,%eax
  8014f4:	74 1e                	je     801514 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f9:	8b 40 08             	mov    0x8(%eax),%eax
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	74 35                	je     801535 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	ff 75 10             	pushl  0x10(%ebp)
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	52                   	push   %edx
  80150a:	ff d0                	call   *%eax
  80150c:	83 c4 10             	add    $0x10,%esp
}
  80150f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801512:	c9                   	leave  
  801513:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801514:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801519:	8b 40 48             	mov    0x48(%eax),%eax
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	53                   	push   %ebx
  801520:	50                   	push   %eax
  801521:	68 d8 2c 80 00       	push   $0x802cd8
  801526:	e8 5b ee ff ff       	call   800386 <cprintf>
		return -E_INVAL;
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801533:	eb da                	jmp    80150f <read+0x5a>
		return -E_NOT_SUPP;
  801535:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153a:	eb d3                	jmp    80150f <read+0x5a>

0080153c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	57                   	push   %edi
  801540:	56                   	push   %esi
  801541:	53                   	push   %ebx
  801542:	83 ec 0c             	sub    $0xc,%esp
  801545:	8b 7d 08             	mov    0x8(%ebp),%edi
  801548:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80154b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801550:	39 f3                	cmp    %esi,%ebx
  801552:	73 23                	jae    801577 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	89 f0                	mov    %esi,%eax
  801559:	29 d8                	sub    %ebx,%eax
  80155b:	50                   	push   %eax
  80155c:	89 d8                	mov    %ebx,%eax
  80155e:	03 45 0c             	add    0xc(%ebp),%eax
  801561:	50                   	push   %eax
  801562:	57                   	push   %edi
  801563:	e8 4d ff ff ff       	call   8014b5 <read>
		if (m < 0)
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 06                	js     801575 <readn+0x39>
			return m;
		if (m == 0)
  80156f:	74 06                	je     801577 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801571:	01 c3                	add    %eax,%ebx
  801573:	eb db                	jmp    801550 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801575:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801577:	89 d8                	mov    %ebx,%eax
  801579:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157c:	5b                   	pop    %ebx
  80157d:	5e                   	pop    %esi
  80157e:	5f                   	pop    %edi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	53                   	push   %ebx
  801585:	83 ec 1c             	sub    $0x1c,%esp
  801588:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158e:	50                   	push   %eax
  80158f:	53                   	push   %ebx
  801590:	e8 b0 fc ff ff       	call   801245 <fd_lookup>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	78 3a                	js     8015d6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a2:	50                   	push   %eax
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	ff 30                	pushl  (%eax)
  8015a8:	e8 e8 fc ff ff       	call   801295 <dev_lookup>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 22                	js     8015d6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015bb:	74 1e                	je     8015db <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c0:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c3:	85 d2                	test   %edx,%edx
  8015c5:	74 35                	je     8015fc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	ff 75 10             	pushl  0x10(%ebp)
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	50                   	push   %eax
  8015d1:	ff d2                	call   *%edx
  8015d3:	83 c4 10             	add    $0x10,%esp
}
  8015d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015db:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015e0:	8b 40 48             	mov    0x48(%eax),%eax
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	53                   	push   %ebx
  8015e7:	50                   	push   %eax
  8015e8:	68 f4 2c 80 00       	push   $0x802cf4
  8015ed:	e8 94 ed ff ff       	call   800386 <cprintf>
		return -E_INVAL;
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fa:	eb da                	jmp    8015d6 <write+0x55>
		return -E_NOT_SUPP;
  8015fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801601:	eb d3                	jmp    8015d6 <write+0x55>

00801603 <seek>:

int
seek(int fdnum, off_t offset)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 30 fc ff ff       	call   801245 <fd_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 0e                	js     80162a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801622:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	53                   	push   %ebx
  801630:	83 ec 1c             	sub    $0x1c,%esp
  801633:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801636:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	53                   	push   %ebx
  80163b:	e8 05 fc ff ff       	call   801245 <fd_lookup>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	78 37                	js     80167e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164d:	50                   	push   %eax
  80164e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801651:	ff 30                	pushl  (%eax)
  801653:	e8 3d fc ff ff       	call   801295 <dev_lookup>
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	85 c0                	test   %eax,%eax
  80165d:	78 1f                	js     80167e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801666:	74 1b                	je     801683 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166b:	8b 52 18             	mov    0x18(%edx),%edx
  80166e:	85 d2                	test   %edx,%edx
  801670:	74 32                	je     8016a4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	ff 75 0c             	pushl  0xc(%ebp)
  801678:	50                   	push   %eax
  801679:	ff d2                	call   *%edx
  80167b:	83 c4 10             	add    $0x10,%esp
}
  80167e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801681:	c9                   	leave  
  801682:	c3                   	ret    
			thisenv->env_id, fdnum);
  801683:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801688:	8b 40 48             	mov    0x48(%eax),%eax
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	53                   	push   %ebx
  80168f:	50                   	push   %eax
  801690:	68 b4 2c 80 00       	push   $0x802cb4
  801695:	e8 ec ec ff ff       	call   800386 <cprintf>
		return -E_INVAL;
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a2:	eb da                	jmp    80167e <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a9:	eb d3                	jmp    80167e <ftruncate+0x52>

008016ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 1c             	sub    $0x1c,%esp
  8016b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b8:	50                   	push   %eax
  8016b9:	ff 75 08             	pushl  0x8(%ebp)
  8016bc:	e8 84 fb ff ff       	call   801245 <fd_lookup>
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 4b                	js     801713 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ce:	50                   	push   %eax
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d2:	ff 30                	pushl  (%eax)
  8016d4:	e8 bc fb ff ff       	call   801295 <dev_lookup>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 33                	js     801713 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e7:	74 2f                	je     801718 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f3:	00 00 00 
	stat->st_isdir = 0;
  8016f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fd:	00 00 00 
	stat->st_dev = dev;
  801700:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	53                   	push   %ebx
  80170a:	ff 75 f0             	pushl  -0x10(%ebp)
  80170d:	ff 50 14             	call   *0x14(%eax)
  801710:	83 c4 10             	add    $0x10,%esp
}
  801713:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801716:	c9                   	leave  
  801717:	c3                   	ret    
		return -E_NOT_SUPP;
  801718:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171d:	eb f4                	jmp    801713 <fstat+0x68>

0080171f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	56                   	push   %esi
  801723:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	6a 00                	push   $0x0
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	e8 22 02 00 00       	call   801953 <open>
  801731:	89 c3                	mov    %eax,%ebx
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	85 c0                	test   %eax,%eax
  801738:	78 1b                	js     801755 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 0c             	pushl  0xc(%ebp)
  801740:	50                   	push   %eax
  801741:	e8 65 ff ff ff       	call   8016ab <fstat>
  801746:	89 c6                	mov    %eax,%esi
	close(fd);
  801748:	89 1c 24             	mov    %ebx,(%esp)
  80174b:	e8 27 fc ff ff       	call   801377 <close>
	return r;
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	89 f3                	mov    %esi,%ebx
}
  801755:	89 d8                	mov    %ebx,%eax
  801757:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5d                   	pop    %ebp
  80175d:	c3                   	ret    

0080175e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	56                   	push   %esi
  801762:	53                   	push   %ebx
  801763:	89 c6                	mov    %eax,%esi
  801765:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801767:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80176e:	74 27                	je     801797 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801770:	6a 07                	push   $0x7
  801772:	68 00 50 80 00       	push   $0x805000
  801777:	56                   	push   %esi
  801778:	ff 35 04 40 80 00    	pushl  0x804004
  80177e:	e8 1c 0d 00 00       	call   80249f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801783:	83 c4 0c             	add    $0xc,%esp
  801786:	6a 00                	push   $0x0
  801788:	53                   	push   %ebx
  801789:	6a 00                	push   $0x0
  80178b:	e8 a6 0c 00 00       	call   802436 <ipc_recv>
}
  801790:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801797:	83 ec 0c             	sub    $0xc,%esp
  80179a:	6a 01                	push   $0x1
  80179c:	e8 56 0d 00 00       	call   8024f7 <ipc_find_env>
  8017a1:	a3 04 40 80 00       	mov    %eax,0x804004
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	eb c5                	jmp    801770 <fsipc+0x12>

008017ab <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ce:	e8 8b ff ff ff       	call   80175e <fsipc>
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_flush>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f0:	e8 69 ff ff ff       	call   80175e <fsipc>
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <devfile_stat>:
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	53                   	push   %ebx
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8b 40 0c             	mov    0xc(%eax),%eax
  801807:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80180c:	ba 00 00 00 00       	mov    $0x0,%edx
  801811:	b8 05 00 00 00       	mov    $0x5,%eax
  801816:	e8 43 ff ff ff       	call   80175e <fsipc>
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 2c                	js     80184b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	68 00 50 80 00       	push   $0x805000
  801827:	53                   	push   %ebx
  801828:	e8 b8 f2 ff ff       	call   800ae5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80182d:	a1 80 50 80 00       	mov    0x805080,%eax
  801832:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801838:	a1 84 50 80 00       	mov    0x805084,%eax
  80183d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <devfile_write>:
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	53                   	push   %ebx
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8b 40 0c             	mov    0xc(%eax),%eax
  801860:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801865:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80186b:	53                   	push   %ebx
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	68 08 50 80 00       	push   $0x805008
  801874:	e8 5c f4 ff ff       	call   800cd5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
  80187e:	b8 04 00 00 00       	mov    $0x4,%eax
  801883:	e8 d6 fe ff ff       	call   80175e <fsipc>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 0b                	js     80189a <devfile_write+0x4a>
	assert(r <= n);
  80188f:	39 d8                	cmp    %ebx,%eax
  801891:	77 0c                	ja     80189f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801893:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801898:	7f 1e                	jg     8018b8 <devfile_write+0x68>
}
  80189a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    
	assert(r <= n);
  80189f:	68 28 2d 80 00       	push   $0x802d28
  8018a4:	68 2f 2d 80 00       	push   $0x802d2f
  8018a9:	68 98 00 00 00       	push   $0x98
  8018ae:	68 44 2d 80 00       	push   $0x802d44
  8018b3:	e8 d8 e9 ff ff       	call   800290 <_panic>
	assert(r <= PGSIZE);
  8018b8:	68 4f 2d 80 00       	push   $0x802d4f
  8018bd:	68 2f 2d 80 00       	push   $0x802d2f
  8018c2:	68 99 00 00 00       	push   $0x99
  8018c7:	68 44 2d 80 00       	push   $0x802d44
  8018cc:	e8 bf e9 ff ff       	call   800290 <_panic>

008018d1 <devfile_read>:
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
  8018d6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018e4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8018f4:	e8 65 fe ff ff       	call   80175e <fsipc>
  8018f9:	89 c3                	mov    %eax,%ebx
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 1f                	js     80191e <devfile_read+0x4d>
	assert(r <= n);
  8018ff:	39 f0                	cmp    %esi,%eax
  801901:	77 24                	ja     801927 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801903:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801908:	7f 33                	jg     80193d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	50                   	push   %eax
  80190e:	68 00 50 80 00       	push   $0x805000
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	e8 58 f3 ff ff       	call   800c73 <memmove>
	return r;
  80191b:	83 c4 10             	add    $0x10,%esp
}
  80191e:	89 d8                	mov    %ebx,%eax
  801920:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    
	assert(r <= n);
  801927:	68 28 2d 80 00       	push   $0x802d28
  80192c:	68 2f 2d 80 00       	push   $0x802d2f
  801931:	6a 7c                	push   $0x7c
  801933:	68 44 2d 80 00       	push   $0x802d44
  801938:	e8 53 e9 ff ff       	call   800290 <_panic>
	assert(r <= PGSIZE);
  80193d:	68 4f 2d 80 00       	push   $0x802d4f
  801942:	68 2f 2d 80 00       	push   $0x802d2f
  801947:	6a 7d                	push   $0x7d
  801949:	68 44 2d 80 00       	push   $0x802d44
  80194e:	e8 3d e9 ff ff       	call   800290 <_panic>

00801953 <open>:
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	56                   	push   %esi
  801957:	53                   	push   %ebx
  801958:	83 ec 1c             	sub    $0x1c,%esp
  80195b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80195e:	56                   	push   %esi
  80195f:	e8 48 f1 ff ff       	call   800aac <strlen>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80196c:	7f 6c                	jg     8019da <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801974:	50                   	push   %eax
  801975:	e8 79 f8 ff ff       	call   8011f3 <fd_alloc>
  80197a:	89 c3                	mov    %eax,%ebx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 3c                	js     8019bf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	56                   	push   %esi
  801987:	68 00 50 80 00       	push   $0x805000
  80198c:	e8 54 f1 ff ff       	call   800ae5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801999:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199c:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a1:	e8 b8 fd ff ff       	call   80175e <fsipc>
  8019a6:	89 c3                	mov    %eax,%ebx
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 19                	js     8019c8 <open+0x75>
	return fd2num(fd);
  8019af:	83 ec 0c             	sub    $0xc,%esp
  8019b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b5:	e8 12 f8 ff ff       	call   8011cc <fd2num>
  8019ba:	89 c3                	mov    %eax,%ebx
  8019bc:	83 c4 10             	add    $0x10,%esp
}
  8019bf:	89 d8                	mov    %ebx,%eax
  8019c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c4:	5b                   	pop    %ebx
  8019c5:	5e                   	pop    %esi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
		fd_close(fd, 0);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d0:	e8 1b f9 ff ff       	call   8012f0 <fd_close>
		return r;
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	eb e5                	jmp    8019bf <open+0x6c>
		return -E_BAD_PATH;
  8019da:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019df:	eb de                	jmp    8019bf <open+0x6c>

008019e1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f1:	e8 68 fd ff ff       	call   80175e <fsipc>
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019f8:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019fc:	7f 01                	jg     8019ff <writebuf+0x7>
  8019fe:	c3                   	ret    
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	53                   	push   %ebx
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a08:	ff 70 04             	pushl  0x4(%eax)
  801a0b:	8d 40 10             	lea    0x10(%eax),%eax
  801a0e:	50                   	push   %eax
  801a0f:	ff 33                	pushl  (%ebx)
  801a11:	e8 6b fb ff ff       	call   801581 <write>
		if (result > 0)
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	7e 03                	jle    801a20 <writebuf+0x28>
			b->result += result;
  801a1d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a20:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a23:	74 0d                	je     801a32 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a25:	85 c0                	test   %eax,%eax
  801a27:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2c:	0f 4f c2             	cmovg  %edx,%eax
  801a2f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <putch>:

static void
putch(int ch, void *thunk)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a41:	8b 53 04             	mov    0x4(%ebx),%edx
  801a44:	8d 42 01             	lea    0x1(%edx),%eax
  801a47:	89 43 04             	mov    %eax,0x4(%ebx)
  801a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a51:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a56:	74 06                	je     801a5e <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a58:	83 c4 04             	add    $0x4,%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    
		writebuf(b);
  801a5e:	89 d8                	mov    %ebx,%eax
  801a60:	e8 93 ff ff ff       	call   8019f8 <writebuf>
		b->idx = 0;
  801a65:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a6c:	eb ea                	jmp    801a58 <putch+0x21>

00801a6e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a80:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a87:	00 00 00 
	b.result = 0;
  801a8a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a91:	00 00 00 
	b.error = 1;
  801a94:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a9b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a9e:	ff 75 10             	pushl  0x10(%ebp)
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801aaa:	50                   	push   %eax
  801aab:	68 37 1a 80 00       	push   $0x801a37
  801ab0:	e8 fe e9 ff ff       	call   8004b3 <vprintfmt>
	if (b.idx > 0)
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801abf:	7f 11                	jg     801ad2 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801ac1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    
		writebuf(&b);
  801ad2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ad8:	e8 1b ff ff ff       	call   8019f8 <writebuf>
  801add:	eb e2                	jmp    801ac1 <vfprintf+0x53>

00801adf <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ae5:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ae8:	50                   	push   %eax
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	e8 7a ff ff ff       	call   801a6e <vfprintf>
	va_end(ap);

	return cnt;
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <printf>:

int
printf(const char *fmt, ...)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801afc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801aff:	50                   	push   %eax
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 01                	push   $0x1
  801b05:	e8 64 ff ff ff       	call   801a6e <vfprintf>
	va_end(ap);

	return cnt;
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b12:	68 5b 2d 80 00       	push   $0x802d5b
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	e8 c6 ef ff ff       	call   800ae5 <strcpy>
	return 0;
}
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <devsock_close>:
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	53                   	push   %ebx
  801b2a:	83 ec 10             	sub    $0x10,%esp
  801b2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b30:	53                   	push   %ebx
  801b31:	e8 00 0a 00 00       	call   802536 <pageref>
  801b36:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b39:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b3e:	83 f8 01             	cmp    $0x1,%eax
  801b41:	74 07                	je     801b4a <devsock_close+0x24>
}
  801b43:	89 d0                	mov    %edx,%eax
  801b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	ff 73 0c             	pushl  0xc(%ebx)
  801b50:	e8 b9 02 00 00       	call   801e0e <nsipc_close>
  801b55:	89 c2                	mov    %eax,%edx
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	eb e7                	jmp    801b43 <devsock_close+0x1d>

00801b5c <devsock_write>:
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 10             	pushl  0x10(%ebp)
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	ff 70 0c             	pushl  0xc(%eax)
  801b70:	e8 76 03 00 00       	call   801eeb <nsipc_send>
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <devsock_read>:
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 10             	pushl  0x10(%ebp)
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	ff 70 0c             	pushl  0xc(%eax)
  801b8b:	e8 ef 02 00 00       	call   801e7f <nsipc_recv>
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <fd2sockid>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b98:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	e8 a3 f6 ff ff       	call   801245 <fd_lookup>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 10                	js     801bb9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bac:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801bb2:	39 08                	cmp    %ecx,(%eax)
  801bb4:	75 05                	jne    801bbb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bb6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    
		return -E_NOT_SUPP;
  801bbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc0:	eb f7                	jmp    801bb9 <fd2sockid+0x27>

00801bc2 <alloc_sockfd>:
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 1c             	sub    $0x1c,%esp
  801bca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcf:	50                   	push   %eax
  801bd0:	e8 1e f6 ff ff       	call   8011f3 <fd_alloc>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 43                	js     801c21 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	68 07 04 00 00       	push   $0x407
  801be6:	ff 75 f4             	pushl  -0xc(%ebp)
  801be9:	6a 00                	push   $0x0
  801beb:	e8 e7 f2 ff ff       	call   800ed7 <sys_page_alloc>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 28                	js     801c21 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfc:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801c02:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c0e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	50                   	push   %eax
  801c15:	e8 b2 f5 ff ff       	call   8011cc <fd2num>
  801c1a:	89 c3                	mov    %eax,%ebx
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	eb 0c                	jmp    801c2d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c21:	83 ec 0c             	sub    $0xc,%esp
  801c24:	56                   	push   %esi
  801c25:	e8 e4 01 00 00       	call   801e0e <nsipc_close>
		return r;
  801c2a:	83 c4 10             	add    $0x10,%esp
}
  801c2d:	89 d8                	mov    %ebx,%eax
  801c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c32:	5b                   	pop    %ebx
  801c33:	5e                   	pop    %esi
  801c34:	5d                   	pop    %ebp
  801c35:	c3                   	ret    

00801c36 <accept>:
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	e8 4e ff ff ff       	call   801b92 <fd2sockid>
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 1b                	js     801c63 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	ff 75 10             	pushl  0x10(%ebp)
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	50                   	push   %eax
  801c52:	e8 0e 01 00 00       	call   801d65 <nsipc_accept>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 05                	js     801c63 <accept+0x2d>
	return alloc_sockfd(r);
  801c5e:	e8 5f ff ff ff       	call   801bc2 <alloc_sockfd>
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <bind>:
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	e8 1f ff ff ff       	call   801b92 <fd2sockid>
  801c73:	85 c0                	test   %eax,%eax
  801c75:	78 12                	js     801c89 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	ff 75 10             	pushl  0x10(%ebp)
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	50                   	push   %eax
  801c81:	e8 31 01 00 00       	call   801db7 <nsipc_bind>
  801c86:	83 c4 10             	add    $0x10,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <shutdown>:
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	e8 f9 fe ff ff       	call   801b92 <fd2sockid>
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 0f                	js     801cac <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	50                   	push   %eax
  801ca4:	e8 43 01 00 00       	call   801dec <nsipc_shutdown>
  801ca9:	83 c4 10             	add    $0x10,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <connect>:
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	e8 d6 fe ff ff       	call   801b92 <fd2sockid>
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 12                	js     801cd2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	ff 75 10             	pushl  0x10(%ebp)
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	50                   	push   %eax
  801cca:	e8 59 01 00 00       	call   801e28 <nsipc_connect>
  801ccf:	83 c4 10             	add    $0x10,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <listen>:
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	e8 b0 fe ff ff       	call   801b92 <fd2sockid>
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 0f                	js     801cf5 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	50                   	push   %eax
  801ced:	e8 6b 01 00 00       	call   801e5d <nsipc_listen>
  801cf2:	83 c4 10             	add    $0x10,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cfd:	ff 75 10             	pushl  0x10(%ebp)
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	e8 3e 02 00 00       	call   801f49 <nsipc_socket>
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 05                	js     801d17 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d12:	e8 ab fe ff ff       	call   801bc2 <alloc_sockfd>
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	53                   	push   %ebx
  801d1d:	83 ec 04             	sub    $0x4,%esp
  801d20:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d22:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801d29:	74 26                	je     801d51 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d2b:	6a 07                	push   $0x7
  801d2d:	68 00 60 80 00       	push   $0x806000
  801d32:	53                   	push   %ebx
  801d33:	ff 35 08 40 80 00    	pushl  0x804008
  801d39:	e8 61 07 00 00       	call   80249f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d3e:	83 c4 0c             	add    $0xc,%esp
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	e8 ea 06 00 00       	call   802436 <ipc_recv>
}
  801d4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	6a 02                	push   $0x2
  801d56:	e8 9c 07 00 00       	call   8024f7 <ipc_find_env>
  801d5b:	a3 08 40 80 00       	mov    %eax,0x804008
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	eb c6                	jmp    801d2b <nsipc+0x12>

00801d65 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	56                   	push   %esi
  801d69:	53                   	push   %ebx
  801d6a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d75:	8b 06                	mov    (%esi),%eax
  801d77:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d81:	e8 93 ff ff ff       	call   801d19 <nsipc>
  801d86:	89 c3                	mov    %eax,%ebx
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	79 09                	jns    801d95 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	ff 35 10 60 80 00    	pushl  0x806010
  801d9e:	68 00 60 80 00       	push   $0x806000
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	e8 c8 ee ff ff       	call   800c73 <memmove>
		*addrlen = ret->ret_addrlen;
  801dab:	a1 10 60 80 00       	mov    0x806010,%eax
  801db0:	89 06                	mov    %eax,(%esi)
  801db2:	83 c4 10             	add    $0x10,%esp
	return r;
  801db5:	eb d5                	jmp    801d8c <nsipc_accept+0x27>

00801db7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	53                   	push   %ebx
  801dbb:	83 ec 08             	sub    $0x8,%esp
  801dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dc9:	53                   	push   %ebx
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	68 04 60 80 00       	push   $0x806004
  801dd2:	e8 9c ee ff ff       	call   800c73 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dd7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ddd:	b8 02 00 00 00       	mov    $0x2,%eax
  801de2:	e8 32 ff ff ff       	call   801d19 <nsipc>
}
  801de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e02:	b8 03 00 00 00       	mov    $0x3,%eax
  801e07:	e8 0d ff ff ff       	call   801d19 <nsipc>
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <nsipc_close>:

int
nsipc_close(int s)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e1c:	b8 04 00 00 00       	mov    $0x4,%eax
  801e21:	e8 f3 fe ff ff       	call   801d19 <nsipc>
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	53                   	push   %ebx
  801e2c:	83 ec 08             	sub    $0x8,%esp
  801e2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e3a:	53                   	push   %ebx
  801e3b:	ff 75 0c             	pushl  0xc(%ebp)
  801e3e:	68 04 60 80 00       	push   $0x806004
  801e43:	e8 2b ee ff ff       	call   800c73 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e48:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e4e:	b8 05 00 00 00       	mov    $0x5,%eax
  801e53:	e8 c1 fe ff ff       	call   801d19 <nsipc>
}
  801e58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e73:	b8 06 00 00 00       	mov    $0x6,%eax
  801e78:	e8 9c fe ff ff       	call   801d19 <nsipc>
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e8f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e95:	8b 45 14             	mov    0x14(%ebp),%eax
  801e98:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e9d:	b8 07 00 00 00       	mov    $0x7,%eax
  801ea2:	e8 72 fe ff ff       	call   801d19 <nsipc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 1f                	js     801ecc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ead:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801eb2:	7f 21                	jg     801ed5 <nsipc_recv+0x56>
  801eb4:	39 c6                	cmp    %eax,%esi
  801eb6:	7c 1d                	jl     801ed5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	50                   	push   %eax
  801ebc:	68 00 60 80 00       	push   $0x806000
  801ec1:	ff 75 0c             	pushl  0xc(%ebp)
  801ec4:	e8 aa ed ff ff       	call   800c73 <memmove>
  801ec9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ecc:	89 d8                	mov    %ebx,%eax
  801ece:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ed5:	68 67 2d 80 00       	push   $0x802d67
  801eda:	68 2f 2d 80 00       	push   $0x802d2f
  801edf:	6a 62                	push   $0x62
  801ee1:	68 7c 2d 80 00       	push   $0x802d7c
  801ee6:	e8 a5 e3 ff ff       	call   800290 <_panic>

00801eeb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	53                   	push   %ebx
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801efd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f03:	7f 2e                	jg     801f33 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	53                   	push   %ebx
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	68 0c 60 80 00       	push   $0x80600c
  801f11:	e8 5d ed ff ff       	call   800c73 <memmove>
	nsipcbuf.send.req_size = size;
  801f16:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f24:	b8 08 00 00 00       	mov    $0x8,%eax
  801f29:	e8 eb fd ff ff       	call   801d19 <nsipc>
}
  801f2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    
	assert(size < 1600);
  801f33:	68 88 2d 80 00       	push   $0x802d88
  801f38:	68 2f 2d 80 00       	push   $0x802d2f
  801f3d:	6a 6d                	push   $0x6d
  801f3f:	68 7c 2d 80 00       	push   $0x802d7c
  801f44:	e8 47 e3 ff ff       	call   800290 <_panic>

00801f49 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f62:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f67:	b8 09 00 00 00       	mov    $0x9,%eax
  801f6c:	e8 a8 fd ff ff       	call   801d19 <nsipc>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	e8 56 f2 ff ff       	call   8011dc <fd2data>
  801f86:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f88:	83 c4 08             	add    $0x8,%esp
  801f8b:	68 94 2d 80 00       	push   $0x802d94
  801f90:	53                   	push   %ebx
  801f91:	e8 4f eb ff ff       	call   800ae5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f96:	8b 46 04             	mov    0x4(%esi),%eax
  801f99:	2b 06                	sub    (%esi),%eax
  801f9b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fa1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fa8:	00 00 00 
	stat->st_dev = &devpipe;
  801fab:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801fb2:	30 80 00 
	return 0;
}
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fcb:	53                   	push   %ebx
  801fcc:	6a 00                	push   $0x0
  801fce:	e8 89 ef ff ff       	call   800f5c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd3:	89 1c 24             	mov    %ebx,(%esp)
  801fd6:	e8 01 f2 ff ff       	call   8011dc <fd2data>
  801fdb:	83 c4 08             	add    $0x8,%esp
  801fde:	50                   	push   %eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	e8 76 ef ff ff       	call   800f5c <sys_page_unmap>
}
  801fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <_pipeisclosed>:
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	57                   	push   %edi
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 1c             	sub    $0x1c,%esp
  801ff4:	89 c7                	mov    %eax,%edi
  801ff6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ff8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801ffd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	57                   	push   %edi
  802004:	e8 2d 05 00 00       	call   802536 <pageref>
  802009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80200c:	89 34 24             	mov    %esi,(%esp)
  80200f:	e8 22 05 00 00       	call   802536 <pageref>
		nn = thisenv->env_runs;
  802014:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80201a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	39 cb                	cmp    %ecx,%ebx
  802022:	74 1b                	je     80203f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802024:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802027:	75 cf                	jne    801ff8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802029:	8b 42 58             	mov    0x58(%edx),%eax
  80202c:	6a 01                	push   $0x1
  80202e:	50                   	push   %eax
  80202f:	53                   	push   %ebx
  802030:	68 9b 2d 80 00       	push   $0x802d9b
  802035:	e8 4c e3 ff ff       	call   800386 <cprintf>
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	eb b9                	jmp    801ff8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80203f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802042:	0f 94 c0             	sete   %al
  802045:	0f b6 c0             	movzbl %al,%eax
}
  802048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <devpipe_write>:
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	57                   	push   %edi
  802054:	56                   	push   %esi
  802055:	53                   	push   %ebx
  802056:	83 ec 28             	sub    $0x28,%esp
  802059:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80205c:	56                   	push   %esi
  80205d:	e8 7a f1 ff ff       	call   8011dc <fd2data>
  802062:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	bf 00 00 00 00       	mov    $0x0,%edi
  80206c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80206f:	74 4f                	je     8020c0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802071:	8b 43 04             	mov    0x4(%ebx),%eax
  802074:	8b 0b                	mov    (%ebx),%ecx
  802076:	8d 51 20             	lea    0x20(%ecx),%edx
  802079:	39 d0                	cmp    %edx,%eax
  80207b:	72 14                	jb     802091 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80207d:	89 da                	mov    %ebx,%edx
  80207f:	89 f0                	mov    %esi,%eax
  802081:	e8 65 ff ff ff       	call   801feb <_pipeisclosed>
  802086:	85 c0                	test   %eax,%eax
  802088:	75 3b                	jne    8020c5 <devpipe_write+0x75>
			sys_yield();
  80208a:	e8 29 ee ff ff       	call   800eb8 <sys_yield>
  80208f:	eb e0                	jmp    802071 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802091:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802094:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802098:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80209b:	89 c2                	mov    %eax,%edx
  80209d:	c1 fa 1f             	sar    $0x1f,%edx
  8020a0:	89 d1                	mov    %edx,%ecx
  8020a2:	c1 e9 1b             	shr    $0x1b,%ecx
  8020a5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020a8:	83 e2 1f             	and    $0x1f,%edx
  8020ab:	29 ca                	sub    %ecx,%edx
  8020ad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020b5:	83 c0 01             	add    $0x1,%eax
  8020b8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020bb:	83 c7 01             	add    $0x1,%edi
  8020be:	eb ac                	jmp    80206c <devpipe_write+0x1c>
	return i;
  8020c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c3:	eb 05                	jmp    8020ca <devpipe_write+0x7a>
				return 0;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5e                   	pop    %esi
  8020cf:	5f                   	pop    %edi
  8020d0:	5d                   	pop    %ebp
  8020d1:	c3                   	ret    

008020d2 <devpipe_read>:
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	57                   	push   %edi
  8020d6:	56                   	push   %esi
  8020d7:	53                   	push   %ebx
  8020d8:	83 ec 18             	sub    $0x18,%esp
  8020db:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020de:	57                   	push   %edi
  8020df:	e8 f8 f0 ff ff       	call   8011dc <fd2data>
  8020e4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020e6:	83 c4 10             	add    $0x10,%esp
  8020e9:	be 00 00 00 00       	mov    $0x0,%esi
  8020ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f1:	75 14                	jne    802107 <devpipe_read+0x35>
	return i;
  8020f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f6:	eb 02                	jmp    8020fa <devpipe_read+0x28>
				return i;
  8020f8:	89 f0                	mov    %esi,%eax
}
  8020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fd:	5b                   	pop    %ebx
  8020fe:	5e                   	pop    %esi
  8020ff:	5f                   	pop    %edi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    
			sys_yield();
  802102:	e8 b1 ed ff ff       	call   800eb8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802107:	8b 03                	mov    (%ebx),%eax
  802109:	3b 43 04             	cmp    0x4(%ebx),%eax
  80210c:	75 18                	jne    802126 <devpipe_read+0x54>
			if (i > 0)
  80210e:	85 f6                	test   %esi,%esi
  802110:	75 e6                	jne    8020f8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802112:	89 da                	mov    %ebx,%edx
  802114:	89 f8                	mov    %edi,%eax
  802116:	e8 d0 fe ff ff       	call   801feb <_pipeisclosed>
  80211b:	85 c0                	test   %eax,%eax
  80211d:	74 e3                	je     802102 <devpipe_read+0x30>
				return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	eb d4                	jmp    8020fa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802126:	99                   	cltd   
  802127:	c1 ea 1b             	shr    $0x1b,%edx
  80212a:	01 d0                	add    %edx,%eax
  80212c:	83 e0 1f             	and    $0x1f,%eax
  80212f:	29 d0                	sub    %edx,%eax
  802131:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802139:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80213c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80213f:	83 c6 01             	add    $0x1,%esi
  802142:	eb aa                	jmp    8020ee <devpipe_read+0x1c>

00802144 <pipe>:
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80214c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214f:	50                   	push   %eax
  802150:	e8 9e f0 ff ff       	call   8011f3 <fd_alloc>
  802155:	89 c3                	mov    %eax,%ebx
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	85 c0                	test   %eax,%eax
  80215c:	0f 88 23 01 00 00    	js     802285 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802162:	83 ec 04             	sub    $0x4,%esp
  802165:	68 07 04 00 00       	push   $0x407
  80216a:	ff 75 f4             	pushl  -0xc(%ebp)
  80216d:	6a 00                	push   $0x0
  80216f:	e8 63 ed ff ff       	call   800ed7 <sys_page_alloc>
  802174:	89 c3                	mov    %eax,%ebx
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	85 c0                	test   %eax,%eax
  80217b:	0f 88 04 01 00 00    	js     802285 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802187:	50                   	push   %eax
  802188:	e8 66 f0 ff ff       	call   8011f3 <fd_alloc>
  80218d:	89 c3                	mov    %eax,%ebx
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	85 c0                	test   %eax,%eax
  802194:	0f 88 db 00 00 00    	js     802275 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 07 04 00 00       	push   $0x407
  8021a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a5:	6a 00                	push   $0x0
  8021a7:	e8 2b ed ff ff       	call   800ed7 <sys_page_alloc>
  8021ac:	89 c3                	mov    %eax,%ebx
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	0f 88 bc 00 00 00    	js     802275 <pipe+0x131>
	va = fd2data(fd0);
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bf:	e8 18 f0 ff ff       	call   8011dc <fd2data>
  8021c4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c6:	83 c4 0c             	add    $0xc,%esp
  8021c9:	68 07 04 00 00       	push   $0x407
  8021ce:	50                   	push   %eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	e8 01 ed ff ff       	call   800ed7 <sys_page_alloc>
  8021d6:	89 c3                	mov    %eax,%ebx
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	0f 88 82 00 00 00    	js     802265 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8021e9:	e8 ee ef ff ff       	call   8011dc <fd2data>
  8021ee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021f5:	50                   	push   %eax
  8021f6:	6a 00                	push   $0x0
  8021f8:	56                   	push   %esi
  8021f9:	6a 00                	push   $0x0
  8021fb:	e8 1a ed ff ff       	call   800f1a <sys_page_map>
  802200:	89 c3                	mov    %eax,%ebx
  802202:	83 c4 20             	add    $0x20,%esp
  802205:	85 c0                	test   %eax,%eax
  802207:	78 4e                	js     802257 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802209:	a1 40 30 80 00       	mov    0x803040,%eax
  80220e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802211:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802216:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80221d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802220:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	ff 75 f4             	pushl  -0xc(%ebp)
  802232:	e8 95 ef ff ff       	call   8011cc <fd2num>
  802237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80223c:	83 c4 04             	add    $0x4,%esp
  80223f:	ff 75 f0             	pushl  -0x10(%ebp)
  802242:	e8 85 ef ff ff       	call   8011cc <fd2num>
  802247:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80224a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	bb 00 00 00 00       	mov    $0x0,%ebx
  802255:	eb 2e                	jmp    802285 <pipe+0x141>
	sys_page_unmap(0, va);
  802257:	83 ec 08             	sub    $0x8,%esp
  80225a:	56                   	push   %esi
  80225b:	6a 00                	push   $0x0
  80225d:	e8 fa ec ff ff       	call   800f5c <sys_page_unmap>
  802262:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802265:	83 ec 08             	sub    $0x8,%esp
  802268:	ff 75 f0             	pushl  -0x10(%ebp)
  80226b:	6a 00                	push   $0x0
  80226d:	e8 ea ec ff ff       	call   800f5c <sys_page_unmap>
  802272:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802275:	83 ec 08             	sub    $0x8,%esp
  802278:	ff 75 f4             	pushl  -0xc(%ebp)
  80227b:	6a 00                	push   $0x0
  80227d:	e8 da ec ff ff       	call   800f5c <sys_page_unmap>
  802282:	83 c4 10             	add    $0x10,%esp
}
  802285:	89 d8                	mov    %ebx,%eax
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <pipeisclosed>:
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802294:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802297:	50                   	push   %eax
  802298:	ff 75 08             	pushl  0x8(%ebp)
  80229b:	e8 a5 ef ff ff       	call   801245 <fd_lookup>
  8022a0:	83 c4 10             	add    $0x10,%esp
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	78 18                	js     8022bf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022a7:	83 ec 0c             	sub    $0xc,%esp
  8022aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ad:	e8 2a ef ff ff       	call   8011dc <fd2data>
	return _pipeisclosed(fd, p);
  8022b2:	89 c2                	mov    %eax,%edx
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	e8 2f fd ff ff       	call   801feb <_pipeisclosed>
  8022bc:	83 c4 10             	add    $0x10,%esp
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	c3                   	ret    

008022c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022cd:	68 b3 2d 80 00       	push   $0x802db3
  8022d2:	ff 75 0c             	pushl  0xc(%ebp)
  8022d5:	e8 0b e8 ff ff       	call   800ae5 <strcpy>
	return 0;
}
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <devcons_write>:
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	57                   	push   %edi
  8022e5:	56                   	push   %esi
  8022e6:	53                   	push   %ebx
  8022e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022fb:	73 31                	jae    80232e <devcons_write+0x4d>
		m = n - tot;
  8022fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802300:	29 f3                	sub    %esi,%ebx
  802302:	83 fb 7f             	cmp    $0x7f,%ebx
  802305:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80230a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	53                   	push   %ebx
  802311:	89 f0                	mov    %esi,%eax
  802313:	03 45 0c             	add    0xc(%ebp),%eax
  802316:	50                   	push   %eax
  802317:	57                   	push   %edi
  802318:	e8 56 e9 ff ff       	call   800c73 <memmove>
		sys_cputs(buf, m);
  80231d:	83 c4 08             	add    $0x8,%esp
  802320:	53                   	push   %ebx
  802321:	57                   	push   %edi
  802322:	e8 f4 ea ff ff       	call   800e1b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802327:	01 de                	add    %ebx,%esi
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	eb ca                	jmp    8022f8 <devcons_write+0x17>
}
  80232e:	89 f0                	mov    %esi,%eax
  802330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802333:	5b                   	pop    %ebx
  802334:	5e                   	pop    %esi
  802335:	5f                   	pop    %edi
  802336:	5d                   	pop    %ebp
  802337:	c3                   	ret    

00802338 <devcons_read>:
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 08             	sub    $0x8,%esp
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802343:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802347:	74 21                	je     80236a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802349:	e8 eb ea ff ff       	call   800e39 <sys_cgetc>
  80234e:	85 c0                	test   %eax,%eax
  802350:	75 07                	jne    802359 <devcons_read+0x21>
		sys_yield();
  802352:	e8 61 eb ff ff       	call   800eb8 <sys_yield>
  802357:	eb f0                	jmp    802349 <devcons_read+0x11>
	if (c < 0)
  802359:	78 0f                	js     80236a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80235b:	83 f8 04             	cmp    $0x4,%eax
  80235e:	74 0c                	je     80236c <devcons_read+0x34>
	*(char*)vbuf = c;
  802360:	8b 55 0c             	mov    0xc(%ebp),%edx
  802363:	88 02                	mov    %al,(%edx)
	return 1;
  802365:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    
		return 0;
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	eb f7                	jmp    80236a <devcons_read+0x32>

00802373 <cputchar>:
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80237f:	6a 01                	push   $0x1
  802381:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802384:	50                   	push   %eax
  802385:	e8 91 ea ff ff       	call   800e1b <sys_cputs>
}
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <getchar>:
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802395:	6a 01                	push   $0x1
  802397:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80239a:	50                   	push   %eax
  80239b:	6a 00                	push   $0x0
  80239d:	e8 13 f1 ff ff       	call   8014b5 <read>
	if (r < 0)
  8023a2:	83 c4 10             	add    $0x10,%esp
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	78 06                	js     8023af <getchar+0x20>
	if (r < 1)
  8023a9:	74 06                	je     8023b1 <getchar+0x22>
	return c;
  8023ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    
		return -E_EOF;
  8023b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023b6:	eb f7                	jmp    8023af <getchar+0x20>

008023b8 <iscons>:
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c1:	50                   	push   %eax
  8023c2:	ff 75 08             	pushl  0x8(%ebp)
  8023c5:	e8 7b ee ff ff       	call   801245 <fd_lookup>
  8023ca:	83 c4 10             	add    $0x10,%esp
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	78 11                	js     8023e2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8023da:	39 10                	cmp    %edx,(%eax)
  8023dc:	0f 94 c0             	sete   %al
  8023df:	0f b6 c0             	movzbl %al,%eax
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <opencons>:
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ed:	50                   	push   %eax
  8023ee:	e8 00 ee ff ff       	call   8011f3 <fd_alloc>
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	78 3a                	js     802434 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	68 07 04 00 00       	push   $0x407
  802402:	ff 75 f4             	pushl  -0xc(%ebp)
  802405:	6a 00                	push   $0x0
  802407:	e8 cb ea ff ff       	call   800ed7 <sys_page_alloc>
  80240c:	83 c4 10             	add    $0x10,%esp
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 21                	js     802434 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80241c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802428:	83 ec 0c             	sub    $0xc,%esp
  80242b:	50                   	push   %eax
  80242c:	e8 9b ed ff ff       	call   8011cc <fd2num>
  802431:	83 c4 10             	add    $0x10,%esp
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	56                   	push   %esi
  80243a:	53                   	push   %ebx
  80243b:	8b 75 08             	mov    0x8(%ebp),%esi
  80243e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802441:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802444:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802446:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80244b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80244e:	83 ec 0c             	sub    $0xc,%esp
  802451:	50                   	push   %eax
  802452:	e8 30 ec ff ff       	call   801087 <sys_ipc_recv>
	if(ret < 0){
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	85 c0                	test   %eax,%eax
  80245c:	78 2b                	js     802489 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80245e:	85 f6                	test   %esi,%esi
  802460:	74 0a                	je     80246c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802462:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802467:	8b 40 78             	mov    0x78(%eax),%eax
  80246a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80246c:	85 db                	test   %ebx,%ebx
  80246e:	74 0a                	je     80247a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802470:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802475:	8b 40 7c             	mov    0x7c(%eax),%eax
  802478:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80247a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80247f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802482:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802485:	5b                   	pop    %ebx
  802486:	5e                   	pop    %esi
  802487:	5d                   	pop    %ebp
  802488:	c3                   	ret    
		if(from_env_store)
  802489:	85 f6                	test   %esi,%esi
  80248b:	74 06                	je     802493 <ipc_recv+0x5d>
			*from_env_store = 0;
  80248d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802493:	85 db                	test   %ebx,%ebx
  802495:	74 eb                	je     802482 <ipc_recv+0x4c>
			*perm_store = 0;
  802497:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80249d:	eb e3                	jmp    802482 <ipc_recv+0x4c>

0080249f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	57                   	push   %edi
  8024a3:	56                   	push   %esi
  8024a4:	53                   	push   %ebx
  8024a5:	83 ec 0c             	sub    $0xc,%esp
  8024a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8024b1:	85 db                	test   %ebx,%ebx
  8024b3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024b8:	0f 44 d8             	cmove  %eax,%ebx
  8024bb:	eb 05                	jmp    8024c2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8024bd:	e8 f6 e9 ff ff       	call   800eb8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8024c2:	ff 75 14             	pushl  0x14(%ebp)
  8024c5:	53                   	push   %ebx
  8024c6:	56                   	push   %esi
  8024c7:	57                   	push   %edi
  8024c8:	e8 97 eb ff ff       	call   801064 <sys_ipc_try_send>
  8024cd:	83 c4 10             	add    $0x10,%esp
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	74 1b                	je     8024ef <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8024d4:	79 e7                	jns    8024bd <ipc_send+0x1e>
  8024d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024d9:	74 e2                	je     8024bd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 bf 2d 80 00       	push   $0x802dbf
  8024e3:	6a 46                	push   $0x46
  8024e5:	68 d4 2d 80 00       	push   $0x802dd4
  8024ea:	e8 a1 dd ff ff       	call   800290 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8024ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f2:	5b                   	pop    %ebx
  8024f3:	5e                   	pop    %esi
  8024f4:	5f                   	pop    %edi
  8024f5:	5d                   	pop    %ebp
  8024f6:	c3                   	ret    

008024f7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024fd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802502:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802508:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80250e:	8b 52 50             	mov    0x50(%edx),%edx
  802511:	39 ca                	cmp    %ecx,%edx
  802513:	74 11                	je     802526 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802515:	83 c0 01             	add    $0x1,%eax
  802518:	3d 00 04 00 00       	cmp    $0x400,%eax
  80251d:	75 e3                	jne    802502 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	eb 0e                	jmp    802534 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802526:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80252c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802531:	8b 40 48             	mov    0x48(%eax),%eax
}
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    

00802536 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80253c:	89 d0                	mov    %edx,%eax
  80253e:	c1 e8 16             	shr    $0x16,%eax
  802541:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80254d:	f6 c1 01             	test   $0x1,%cl
  802550:	74 1d                	je     80256f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802552:	c1 ea 0c             	shr    $0xc,%edx
  802555:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80255c:	f6 c2 01             	test   $0x1,%dl
  80255f:	74 0e                	je     80256f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802561:	c1 ea 0c             	shr    $0xc,%edx
  802564:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80256b:	ef 
  80256c:	0f b7 c0             	movzwl %ax,%eax
}
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	66 90                	xchg   %ax,%ax
  802573:	66 90                	xchg   %ax,%ax
  802575:	66 90                	xchg   %ax,%ax
  802577:	66 90                	xchg   %ax,%ax
  802579:	66 90                	xchg   %ax,%ax
  80257b:	66 90                	xchg   %ax,%ax
  80257d:	66 90                	xchg   %ax,%ax
  80257f:	90                   	nop

00802580 <__udivdi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	53                   	push   %ebx
  802584:	83 ec 1c             	sub    $0x1c,%esp
  802587:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80258b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80258f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802593:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802597:	85 d2                	test   %edx,%edx
  802599:	75 4d                	jne    8025e8 <__udivdi3+0x68>
  80259b:	39 f3                	cmp    %esi,%ebx
  80259d:	76 19                	jbe    8025b8 <__udivdi3+0x38>
  80259f:	31 ff                	xor    %edi,%edi
  8025a1:	89 e8                	mov    %ebp,%eax
  8025a3:	89 f2                	mov    %esi,%edx
  8025a5:	f7 f3                	div    %ebx
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	83 c4 1c             	add    $0x1c,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5e                   	pop    %esi
  8025ae:	5f                   	pop    %edi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
  8025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	89 d9                	mov    %ebx,%ecx
  8025ba:	85 db                	test   %ebx,%ebx
  8025bc:	75 0b                	jne    8025c9 <__udivdi3+0x49>
  8025be:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c3:	31 d2                	xor    %edx,%edx
  8025c5:	f7 f3                	div    %ebx
  8025c7:	89 c1                	mov    %eax,%ecx
  8025c9:	31 d2                	xor    %edx,%edx
  8025cb:	89 f0                	mov    %esi,%eax
  8025cd:	f7 f1                	div    %ecx
  8025cf:	89 c6                	mov    %eax,%esi
  8025d1:	89 e8                	mov    %ebp,%eax
  8025d3:	89 f7                	mov    %esi,%edi
  8025d5:	f7 f1                	div    %ecx
  8025d7:	89 fa                	mov    %edi,%edx
  8025d9:	83 c4 1c             	add    $0x1c,%esp
  8025dc:	5b                   	pop    %ebx
  8025dd:	5e                   	pop    %esi
  8025de:	5f                   	pop    %edi
  8025df:	5d                   	pop    %ebp
  8025e0:	c3                   	ret    
  8025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	39 f2                	cmp    %esi,%edx
  8025ea:	77 1c                	ja     802608 <__udivdi3+0x88>
  8025ec:	0f bd fa             	bsr    %edx,%edi
  8025ef:	83 f7 1f             	xor    $0x1f,%edi
  8025f2:	75 2c                	jne    802620 <__udivdi3+0xa0>
  8025f4:	39 f2                	cmp    %esi,%edx
  8025f6:	72 06                	jb     8025fe <__udivdi3+0x7e>
  8025f8:	31 c0                	xor    %eax,%eax
  8025fa:	39 eb                	cmp    %ebp,%ebx
  8025fc:	77 a9                	ja     8025a7 <__udivdi3+0x27>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	eb a2                	jmp    8025a7 <__udivdi3+0x27>
  802605:	8d 76 00             	lea    0x0(%esi),%esi
  802608:	31 ff                	xor    %edi,%edi
  80260a:	31 c0                	xor    %eax,%eax
  80260c:	89 fa                	mov    %edi,%edx
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261d:	8d 76 00             	lea    0x0(%esi),%esi
  802620:	89 f9                	mov    %edi,%ecx
  802622:	b8 20 00 00 00       	mov    $0x20,%eax
  802627:	29 f8                	sub    %edi,%eax
  802629:	d3 e2                	shl    %cl,%edx
  80262b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80262f:	89 c1                	mov    %eax,%ecx
  802631:	89 da                	mov    %ebx,%edx
  802633:	d3 ea                	shr    %cl,%edx
  802635:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802639:	09 d1                	or     %edx,%ecx
  80263b:	89 f2                	mov    %esi,%edx
  80263d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802641:	89 f9                	mov    %edi,%ecx
  802643:	d3 e3                	shl    %cl,%ebx
  802645:	89 c1                	mov    %eax,%ecx
  802647:	d3 ea                	shr    %cl,%edx
  802649:	89 f9                	mov    %edi,%ecx
  80264b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80264f:	89 eb                	mov    %ebp,%ebx
  802651:	d3 e6                	shl    %cl,%esi
  802653:	89 c1                	mov    %eax,%ecx
  802655:	d3 eb                	shr    %cl,%ebx
  802657:	09 de                	or     %ebx,%esi
  802659:	89 f0                	mov    %esi,%eax
  80265b:	f7 74 24 08          	divl   0x8(%esp)
  80265f:	89 d6                	mov    %edx,%esi
  802661:	89 c3                	mov    %eax,%ebx
  802663:	f7 64 24 0c          	mull   0xc(%esp)
  802667:	39 d6                	cmp    %edx,%esi
  802669:	72 15                	jb     802680 <__udivdi3+0x100>
  80266b:	89 f9                	mov    %edi,%ecx
  80266d:	d3 e5                	shl    %cl,%ebp
  80266f:	39 c5                	cmp    %eax,%ebp
  802671:	73 04                	jae    802677 <__udivdi3+0xf7>
  802673:	39 d6                	cmp    %edx,%esi
  802675:	74 09                	je     802680 <__udivdi3+0x100>
  802677:	89 d8                	mov    %ebx,%eax
  802679:	31 ff                	xor    %edi,%edi
  80267b:	e9 27 ff ff ff       	jmp    8025a7 <__udivdi3+0x27>
  802680:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802683:	31 ff                	xor    %edi,%edi
  802685:	e9 1d ff ff ff       	jmp    8025a7 <__udivdi3+0x27>
  80268a:	66 90                	xchg   %ax,%ax
  80268c:	66 90                	xchg   %ax,%ax
  80268e:	66 90                	xchg   %ax,%ax

00802690 <__umoddi3>:
  802690:	55                   	push   %ebp
  802691:	57                   	push   %edi
  802692:	56                   	push   %esi
  802693:	53                   	push   %ebx
  802694:	83 ec 1c             	sub    $0x1c,%esp
  802697:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80269b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80269f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026a7:	89 da                	mov    %ebx,%edx
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	75 43                	jne    8026f0 <__umoddi3+0x60>
  8026ad:	39 df                	cmp    %ebx,%edi
  8026af:	76 17                	jbe    8026c8 <__umoddi3+0x38>
  8026b1:	89 f0                	mov    %esi,%eax
  8026b3:	f7 f7                	div    %edi
  8026b5:	89 d0                	mov    %edx,%eax
  8026b7:	31 d2                	xor    %edx,%edx
  8026b9:	83 c4 1c             	add    $0x1c,%esp
  8026bc:	5b                   	pop    %ebx
  8026bd:	5e                   	pop    %esi
  8026be:	5f                   	pop    %edi
  8026bf:	5d                   	pop    %ebp
  8026c0:	c3                   	ret    
  8026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	89 fd                	mov    %edi,%ebp
  8026ca:	85 ff                	test   %edi,%edi
  8026cc:	75 0b                	jne    8026d9 <__umoddi3+0x49>
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	31 d2                	xor    %edx,%edx
  8026d5:	f7 f7                	div    %edi
  8026d7:	89 c5                	mov    %eax,%ebp
  8026d9:	89 d8                	mov    %ebx,%eax
  8026db:	31 d2                	xor    %edx,%edx
  8026dd:	f7 f5                	div    %ebp
  8026df:	89 f0                	mov    %esi,%eax
  8026e1:	f7 f5                	div    %ebp
  8026e3:	89 d0                	mov    %edx,%eax
  8026e5:	eb d0                	jmp    8026b7 <__umoddi3+0x27>
  8026e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ee:	66 90                	xchg   %ax,%ax
  8026f0:	89 f1                	mov    %esi,%ecx
  8026f2:	39 d8                	cmp    %ebx,%eax
  8026f4:	76 0a                	jbe    802700 <__umoddi3+0x70>
  8026f6:	89 f0                	mov    %esi,%eax
  8026f8:	83 c4 1c             	add    $0x1c,%esp
  8026fb:	5b                   	pop    %ebx
  8026fc:	5e                   	pop    %esi
  8026fd:	5f                   	pop    %edi
  8026fe:	5d                   	pop    %ebp
  8026ff:	c3                   	ret    
  802700:	0f bd e8             	bsr    %eax,%ebp
  802703:	83 f5 1f             	xor    $0x1f,%ebp
  802706:	75 20                	jne    802728 <__umoddi3+0x98>
  802708:	39 d8                	cmp    %ebx,%eax
  80270a:	0f 82 b0 00 00 00    	jb     8027c0 <__umoddi3+0x130>
  802710:	39 f7                	cmp    %esi,%edi
  802712:	0f 86 a8 00 00 00    	jbe    8027c0 <__umoddi3+0x130>
  802718:	89 c8                	mov    %ecx,%eax
  80271a:	83 c4 1c             	add    $0x1c,%esp
  80271d:	5b                   	pop    %ebx
  80271e:	5e                   	pop    %esi
  80271f:	5f                   	pop    %edi
  802720:	5d                   	pop    %ebp
  802721:	c3                   	ret    
  802722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802728:	89 e9                	mov    %ebp,%ecx
  80272a:	ba 20 00 00 00       	mov    $0x20,%edx
  80272f:	29 ea                	sub    %ebp,%edx
  802731:	d3 e0                	shl    %cl,%eax
  802733:	89 44 24 08          	mov    %eax,0x8(%esp)
  802737:	89 d1                	mov    %edx,%ecx
  802739:	89 f8                	mov    %edi,%eax
  80273b:	d3 e8                	shr    %cl,%eax
  80273d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802741:	89 54 24 04          	mov    %edx,0x4(%esp)
  802745:	8b 54 24 04          	mov    0x4(%esp),%edx
  802749:	09 c1                	or     %eax,%ecx
  80274b:	89 d8                	mov    %ebx,%eax
  80274d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802751:	89 e9                	mov    %ebp,%ecx
  802753:	d3 e7                	shl    %cl,%edi
  802755:	89 d1                	mov    %edx,%ecx
  802757:	d3 e8                	shr    %cl,%eax
  802759:	89 e9                	mov    %ebp,%ecx
  80275b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80275f:	d3 e3                	shl    %cl,%ebx
  802761:	89 c7                	mov    %eax,%edi
  802763:	89 d1                	mov    %edx,%ecx
  802765:	89 f0                	mov    %esi,%eax
  802767:	d3 e8                	shr    %cl,%eax
  802769:	89 e9                	mov    %ebp,%ecx
  80276b:	89 fa                	mov    %edi,%edx
  80276d:	d3 e6                	shl    %cl,%esi
  80276f:	09 d8                	or     %ebx,%eax
  802771:	f7 74 24 08          	divl   0x8(%esp)
  802775:	89 d1                	mov    %edx,%ecx
  802777:	89 f3                	mov    %esi,%ebx
  802779:	f7 64 24 0c          	mull   0xc(%esp)
  80277d:	89 c6                	mov    %eax,%esi
  80277f:	89 d7                	mov    %edx,%edi
  802781:	39 d1                	cmp    %edx,%ecx
  802783:	72 06                	jb     80278b <__umoddi3+0xfb>
  802785:	75 10                	jne    802797 <__umoddi3+0x107>
  802787:	39 c3                	cmp    %eax,%ebx
  802789:	73 0c                	jae    802797 <__umoddi3+0x107>
  80278b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80278f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802793:	89 d7                	mov    %edx,%edi
  802795:	89 c6                	mov    %eax,%esi
  802797:	89 ca                	mov    %ecx,%edx
  802799:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80279e:	29 f3                	sub    %esi,%ebx
  8027a0:	19 fa                	sbb    %edi,%edx
  8027a2:	89 d0                	mov    %edx,%eax
  8027a4:	d3 e0                	shl    %cl,%eax
  8027a6:	89 e9                	mov    %ebp,%ecx
  8027a8:	d3 eb                	shr    %cl,%ebx
  8027aa:	d3 ea                	shr    %cl,%edx
  8027ac:	09 d8                	or     %ebx,%eax
  8027ae:	83 c4 1c             	add    $0x1c,%esp
  8027b1:	5b                   	pop    %ebx
  8027b2:	5e                   	pop    %esi
  8027b3:	5f                   	pop    %edi
  8027b4:	5d                   	pop    %ebp
  8027b5:	c3                   	ret    
  8027b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027bd:	8d 76 00             	lea    0x0(%esi),%esi
  8027c0:	89 da                	mov    %ebx,%edx
  8027c2:	29 fe                	sub    %edi,%esi
  8027c4:	19 c2                	sbb    %eax,%edx
  8027c6:	89 f1                	mov    %esi,%ecx
  8027c8:	89 c8                	mov    %ecx,%eax
  8027ca:	e9 4b ff ff ff       	jmp    80271a <__umoddi3+0x8a>
