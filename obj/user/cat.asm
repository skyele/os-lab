
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 13 14 00 00       	call   801461 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 c6 14 00 00       	call   80152d <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 80 27 80 00       	push   $0x802780
  80007a:	6a 0d                	push   $0xd
  80007c:	68 9b 27 80 00       	push   $0x80279b
  800081:	e8 b6 01 00 00       	call   80023c <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	pushl  0xc(%ebp)
  800096:	68 a6 27 80 00       	push   $0x8027a6
  80009b:	6a 0f                	push   $0xf
  80009d:	68 9b 27 80 00       	push   $0x80279b
  8000a2:	e8 95 01 00 00       	call   80023c <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 bb 	movl   $0x8027bb,0x803000
  8000ba:	27 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 bf 27 80 00       	push   $0x8027bf
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e9:	68 c7 27 80 00       	push   $0x8027c7
  8000ee:	e8 af 19 00 00       	call   801aa2 <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 f4 17 00 00       	call   8018ff <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 fb 11 00 00       	call   801323 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
  800133:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800136:	c7 05 20 60 80 00 00 	movl   $0x0,0x806020
  80013d:	00 00 00 
	envid_t find = sys_getenvid();
  800140:	e8 00 0d 00 00       	call   800e45 <sys_getenvid>
  800145:	8b 1d 20 60 80 00    	mov    0x806020,%ebx
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800150:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800155:	bf 01 00 00 00       	mov    $0x1,%edi
  80015a:	eb 0b                	jmp    800167 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80015c:	83 c2 01             	add    $0x1,%edx
  80015f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800165:	74 23                	je     80018a <libmain+0x5d>
		if(envs[i].env_id == find)
  800167:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80016d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800173:	8b 49 48             	mov    0x48(%ecx),%ecx
  800176:	39 c1                	cmp    %eax,%ecx
  800178:	75 e2                	jne    80015c <libmain+0x2f>
  80017a:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800180:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800186:	89 fe                	mov    %edi,%esi
  800188:	eb d2                	jmp    80015c <libmain+0x2f>
  80018a:	89 f0                	mov    %esi,%eax
  80018c:	84 c0                	test   %al,%al
  80018e:	74 06                	je     800196 <libmain+0x69>
  800190:	89 1d 20 60 80 00    	mov    %ebx,0x806020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x79>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8001ab:	8b 40 48             	mov    0x48(%eax),%eax
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	50                   	push   %eax
  8001b2:	68 da 27 80 00       	push   $0x8027da
  8001b7:	e8 76 01 00 00       	call   800332 <cprintf>
	cprintf("before umain\n");
  8001bc:	c7 04 24 f8 27 80 00 	movl   $0x8027f8,(%esp)
  8001c3:	e8 6a 01 00 00       	call   800332 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001c8:	83 c4 08             	add    $0x8,%esp
  8001cb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ce:	ff 75 08             	pushl  0x8(%ebp)
  8001d1:	e8 d1 fe ff ff       	call   8000a7 <umain>
	cprintf("after umain\n");
  8001d6:	c7 04 24 06 28 80 00 	movl   $0x802806,(%esp)
  8001dd:	e8 50 01 00 00       	call   800332 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001e2:	a1 20 60 80 00       	mov    0x806020,%eax
  8001e7:	8b 40 48             	mov    0x48(%eax),%eax
  8001ea:	83 c4 08             	add    $0x8,%esp
  8001ed:	50                   	push   %eax
  8001ee:	68 13 28 80 00       	push   $0x802813
  8001f3:	e8 3a 01 00 00       	call   800332 <cprintf>
	// exit gracefully
	exit();
  8001f8:	e8 0b 00 00 00       	call   800208 <exit>
}
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80020e:	a1 20 60 80 00       	mov    0x806020,%eax
  800213:	8b 40 48             	mov    0x48(%eax),%eax
  800216:	68 40 28 80 00       	push   $0x802840
  80021b:	50                   	push   %eax
  80021c:	68 32 28 80 00       	push   $0x802832
  800221:	e8 0c 01 00 00       	call   800332 <cprintf>
	close_all();
  800226:	e8 25 11 00 00       	call   801350 <close_all>
	sys_env_destroy(0);
  80022b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800232:	e8 cd 0b 00 00       	call   800e04 <sys_env_destroy>
}
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	56                   	push   %esi
  800240:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800241:	a1 20 60 80 00       	mov    0x806020,%eax
  800246:	8b 40 48             	mov    0x48(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	68 6c 28 80 00       	push   $0x80286c
  800251:	50                   	push   %eax
  800252:	68 32 28 80 00       	push   $0x802832
  800257:	e8 d6 00 00 00       	call   800332 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80025c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80025f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800265:	e8 db 0b 00 00       	call   800e45 <sys_getenvid>
  80026a:	83 c4 04             	add    $0x4,%esp
  80026d:	ff 75 0c             	pushl  0xc(%ebp)
  800270:	ff 75 08             	pushl  0x8(%ebp)
  800273:	56                   	push   %esi
  800274:	50                   	push   %eax
  800275:	68 48 28 80 00       	push   $0x802848
  80027a:	e8 b3 00 00 00       	call   800332 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80027f:	83 c4 18             	add    $0x18,%esp
  800282:	53                   	push   %ebx
  800283:	ff 75 10             	pushl  0x10(%ebp)
  800286:	e8 56 00 00 00       	call   8002e1 <vcprintf>
	cprintf("\n");
  80028b:	c7 04 24 f6 27 80 00 	movl   $0x8027f6,(%esp)
  800292:	e8 9b 00 00 00       	call   800332 <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029a:	cc                   	int3   
  80029b:	eb fd                	jmp    80029a <_panic+0x5e>

0080029d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	53                   	push   %ebx
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a7:	8b 13                	mov    (%ebx),%edx
  8002a9:	8d 42 01             	lea    0x1(%edx),%eax
  8002ac:	89 03                	mov    %eax,(%ebx)
  8002ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ba:	74 09                	je     8002c5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002bc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	68 ff 00 00 00       	push   $0xff
  8002cd:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d0:	50                   	push   %eax
  8002d1:	e8 f1 0a 00 00       	call   800dc7 <sys_cputs>
		b->idx = 0;
  8002d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	eb db                	jmp    8002bc <putch+0x1f>

008002e1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f1:	00 00 00 
	b.cnt = 0;
  8002f4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002fe:	ff 75 0c             	pushl  0xc(%ebp)
  800301:	ff 75 08             	pushl  0x8(%ebp)
  800304:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030a:	50                   	push   %eax
  80030b:	68 9d 02 80 00       	push   $0x80029d
  800310:	e8 4a 01 00 00       	call   80045f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800315:	83 c4 08             	add    $0x8,%esp
  800318:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80031e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800324:	50                   	push   %eax
  800325:	e8 9d 0a 00 00       	call   800dc7 <sys_cputs>

	return b.cnt;
}
  80032a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800338:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80033b:	50                   	push   %eax
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 9d ff ff ff       	call   8002e1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
  80034c:	83 ec 1c             	sub    $0x1c,%esp
  80034f:	89 c6                	mov    %eax,%esi
  800351:	89 d7                	mov    %edx,%edi
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	8b 55 0c             	mov    0xc(%ebp),%edx
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80035f:	8b 45 10             	mov    0x10(%ebp),%eax
  800362:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800365:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800369:	74 2c                	je     800397 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80036b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800375:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800378:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80037b:	39 c2                	cmp    %eax,%edx
  80037d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800380:	73 43                	jae    8003c5 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800382:	83 eb 01             	sub    $0x1,%ebx
  800385:	85 db                	test   %ebx,%ebx
  800387:	7e 6c                	jle    8003f5 <printnum+0xaf>
				putch(padc, putdat);
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	57                   	push   %edi
  80038d:	ff 75 18             	pushl  0x18(%ebp)
  800390:	ff d6                	call   *%esi
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	eb eb                	jmp    800382 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800397:	83 ec 0c             	sub    $0xc,%esp
  80039a:	6a 20                	push   $0x20
  80039c:	6a 00                	push   $0x0
  80039e:	50                   	push   %eax
  80039f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a5:	89 fa                	mov    %edi,%edx
  8003a7:	89 f0                	mov    %esi,%eax
  8003a9:	e8 98 ff ff ff       	call   800346 <printnum>
		while (--width > 0)
  8003ae:	83 c4 20             	add    $0x20,%esp
  8003b1:	83 eb 01             	sub    $0x1,%ebx
  8003b4:	85 db                	test   %ebx,%ebx
  8003b6:	7e 65                	jle    80041d <printnum+0xd7>
			putch(padc, putdat);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	57                   	push   %edi
  8003bc:	6a 20                	push   $0x20
  8003be:	ff d6                	call   *%esi
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	eb ec                	jmp    8003b1 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c5:	83 ec 0c             	sub    $0xc,%esp
  8003c8:	ff 75 18             	pushl  0x18(%ebp)
  8003cb:	83 eb 01             	sub    $0x1,%ebx
  8003ce:	53                   	push   %ebx
  8003cf:	50                   	push   %eax
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003df:	e8 3c 21 00 00       	call   802520 <__udivdi3>
  8003e4:	83 c4 18             	add    $0x18,%esp
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	89 fa                	mov    %edi,%edx
  8003eb:	89 f0                	mov    %esi,%eax
  8003ed:	e8 54 ff ff ff       	call   800346 <printnum>
  8003f2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	57                   	push   %edi
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800402:	ff 75 e4             	pushl  -0x1c(%ebp)
  800405:	ff 75 e0             	pushl  -0x20(%ebp)
  800408:	e8 23 22 00 00       	call   802630 <__umoddi3>
  80040d:	83 c4 14             	add    $0x14,%esp
  800410:	0f be 80 73 28 80 00 	movsbl 0x802873(%eax),%eax
  800417:	50                   	push   %eax
  800418:	ff d6                	call   *%esi
  80041a:	83 c4 10             	add    $0x10,%esp
	}
}
  80041d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800420:	5b                   	pop    %ebx
  800421:	5e                   	pop    %esi
  800422:	5f                   	pop    %edi
  800423:	5d                   	pop    %ebp
  800424:	c3                   	ret    

00800425 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80042b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042f:	8b 10                	mov    (%eax),%edx
  800431:	3b 50 04             	cmp    0x4(%eax),%edx
  800434:	73 0a                	jae    800440 <sprintputch+0x1b>
		*b->buf++ = ch;
  800436:	8d 4a 01             	lea    0x1(%edx),%ecx
  800439:	89 08                	mov    %ecx,(%eax)
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	88 02                	mov    %al,(%edx)
}
  800440:	5d                   	pop    %ebp
  800441:	c3                   	ret    

00800442 <printfmt>:
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800448:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80044b:	50                   	push   %eax
  80044c:	ff 75 10             	pushl  0x10(%ebp)
  80044f:	ff 75 0c             	pushl  0xc(%ebp)
  800452:	ff 75 08             	pushl  0x8(%ebp)
  800455:	e8 05 00 00 00       	call   80045f <vprintfmt>
}
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <vprintfmt>:
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	57                   	push   %edi
  800463:	56                   	push   %esi
  800464:	53                   	push   %ebx
  800465:	83 ec 3c             	sub    $0x3c,%esp
  800468:	8b 75 08             	mov    0x8(%ebp),%esi
  80046b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800471:	e9 32 04 00 00       	jmp    8008a8 <vprintfmt+0x449>
		padc = ' ';
  800476:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80047a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800481:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800488:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80048f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800496:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80049d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8d 47 01             	lea    0x1(%edi),%eax
  8004a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a8:	0f b6 17             	movzbl (%edi),%edx
  8004ab:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ae:	3c 55                	cmp    $0x55,%al
  8004b0:	0f 87 12 05 00 00    	ja     8009c8 <vprintfmt+0x569>
  8004b6:	0f b6 c0             	movzbl %al,%eax
  8004b9:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c3:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004c7:	eb d9                	jmp    8004a2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004cc:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004d0:	eb d0                	jmp    8004a2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	0f b6 d2             	movzbl %dl,%edx
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e0:	eb 03                	jmp    8004e5 <vprintfmt+0x86>
  8004e2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ec:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ef:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004f2:	83 fe 09             	cmp    $0x9,%esi
  8004f5:	76 eb                	jbe    8004e2 <vprintfmt+0x83>
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fd:	eb 14                	jmp    800513 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 40 04             	lea    0x4(%eax),%eax
  80050d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800513:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800517:	79 89                	jns    8004a2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800526:	e9 77 ff ff ff       	jmp    8004a2 <vprintfmt+0x43>
  80052b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	0f 48 c1             	cmovs  %ecx,%eax
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800536:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800539:	e9 64 ff ff ff       	jmp    8004a2 <vprintfmt+0x43>
  80053e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800541:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800548:	e9 55 ff ff ff       	jmp    8004a2 <vprintfmt+0x43>
			lflag++;
  80054d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800551:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800554:	e9 49 ff ff ff       	jmp    8004a2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 78 04             	lea    0x4(%eax),%edi
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	ff 30                	pushl  (%eax)
  800565:	ff d6                	call   *%esi
			break;
  800567:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056d:	e9 33 03 00 00       	jmp    8008a5 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8d 78 04             	lea    0x4(%eax),%edi
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	99                   	cltd   
  80057b:	31 d0                	xor    %edx,%eax
  80057d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057f:	83 f8 11             	cmp    $0x11,%eax
  800582:	7f 23                	jg     8005a7 <vprintfmt+0x148>
  800584:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  80058b:	85 d2                	test   %edx,%edx
  80058d:	74 18                	je     8005a7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80058f:	52                   	push   %edx
  800590:	68 e1 2c 80 00       	push   $0x802ce1
  800595:	53                   	push   %ebx
  800596:	56                   	push   %esi
  800597:	e8 a6 fe ff ff       	call   800442 <printfmt>
  80059c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059f:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a2:	e9 fe 02 00 00       	jmp    8008a5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005a7:	50                   	push   %eax
  8005a8:	68 8b 28 80 00       	push   $0x80288b
  8005ad:	53                   	push   %ebx
  8005ae:	56                   	push   %esi
  8005af:	e8 8e fe ff ff       	call   800442 <printfmt>
  8005b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ba:	e9 e6 02 00 00       	jmp    8008a5 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	83 c0 04             	add    $0x4,%eax
  8005c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	b8 84 28 80 00       	mov    $0x802884,%eax
  8005d4:	0f 45 c1             	cmovne %ecx,%eax
  8005d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005de:	7e 06                	jle    8005e6 <vprintfmt+0x187>
  8005e0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005e4:	75 0d                	jne    8005f3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e9:	89 c7                	mov    %eax,%edi
  8005eb:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f1:	eb 53                	jmp    800646 <vprintfmt+0x1e7>
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	e8 71 04 00 00       	call   800a70 <strnlen>
  8005ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800602:	29 c1                	sub    %eax,%ecx
  800604:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80060c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800610:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	eb 0f                	jmp    800624 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	ff 75 e0             	pushl  -0x20(%ebp)
  80061c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	83 ef 01             	sub    $0x1,%edi
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	85 ff                	test   %edi,%edi
  800626:	7f ed                	jg     800615 <vprintfmt+0x1b6>
  800628:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80062b:	85 c9                	test   %ecx,%ecx
  80062d:	b8 00 00 00 00       	mov    $0x0,%eax
  800632:	0f 49 c1             	cmovns %ecx,%eax
  800635:	29 c1                	sub    %eax,%ecx
  800637:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80063a:	eb aa                	jmp    8005e6 <vprintfmt+0x187>
					putch(ch, putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	52                   	push   %edx
  800641:	ff d6                	call   *%esi
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800649:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064b:	83 c7 01             	add    $0x1,%edi
  80064e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800652:	0f be d0             	movsbl %al,%edx
  800655:	85 d2                	test   %edx,%edx
  800657:	74 4b                	je     8006a4 <vprintfmt+0x245>
  800659:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065d:	78 06                	js     800665 <vprintfmt+0x206>
  80065f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800663:	78 1e                	js     800683 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800665:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800669:	74 d1                	je     80063c <vprintfmt+0x1dd>
  80066b:	0f be c0             	movsbl %al,%eax
  80066e:	83 e8 20             	sub    $0x20,%eax
  800671:	83 f8 5e             	cmp    $0x5e,%eax
  800674:	76 c6                	jbe    80063c <vprintfmt+0x1dd>
					putch('?', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 3f                	push   $0x3f
  80067c:	ff d6                	call   *%esi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	eb c3                	jmp    800646 <vprintfmt+0x1e7>
  800683:	89 cf                	mov    %ecx,%edi
  800685:	eb 0e                	jmp    800695 <vprintfmt+0x236>
				putch(' ', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	6a 20                	push   $0x20
  80068d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80068f:	83 ef 01             	sub    $0x1,%edi
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	85 ff                	test   %edi,%edi
  800697:	7f ee                	jg     800687 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	e9 01 02 00 00       	jmp    8008a5 <vprintfmt+0x446>
  8006a4:	89 cf                	mov    %ecx,%edi
  8006a6:	eb ed                	jmp    800695 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006ab:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006b2:	e9 eb fd ff ff       	jmp    8004a2 <vprintfmt+0x43>
	if (lflag >= 2)
  8006b7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006bb:	7f 21                	jg     8006de <vprintfmt+0x27f>
	else if (lflag)
  8006bd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c1:	74 68                	je     80072b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006dc:	eb 17                	jmp    8006f5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 50 04             	mov    0x4(%eax),%edx
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 40 08             	lea    0x8(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800701:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800705:	78 3f                	js     800746 <vprintfmt+0x2e7>
			base = 10;
  800707:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80070c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800710:	0f 84 71 01 00 00    	je     800887 <vprintfmt+0x428>
				putch('+', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 2b                	push   $0x2b
  80071c:	ff d6                	call   *%esi
  80071e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800721:	b8 0a 00 00 00       	mov    $0xa,%eax
  800726:	e9 5c 01 00 00       	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800733:	89 c1                	mov    %eax,%ecx
  800735:	c1 f9 1f             	sar    $0x1f,%ecx
  800738:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
  800744:	eb af                	jmp    8006f5 <vprintfmt+0x296>
				putch('-', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 2d                	push   $0x2d
  80074c:	ff d6                	call   *%esi
				num = -(long long) num;
  80074e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800751:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800754:	f7 d8                	neg    %eax
  800756:	83 d2 00             	adc    $0x0,%edx
  800759:	f7 da                	neg    %edx
  80075b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800761:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800764:	b8 0a 00 00 00       	mov    $0xa,%eax
  800769:	e9 19 01 00 00       	jmp    800887 <vprintfmt+0x428>
	if (lflag >= 2)
  80076e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800772:	7f 29                	jg     80079d <vprintfmt+0x33e>
	else if (lflag)
  800774:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800778:	74 44                	je     8007be <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800793:	b8 0a 00 00 00       	mov    $0xa,%eax
  800798:	e9 ea 00 00 00       	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 50 04             	mov    0x4(%eax),%edx
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 08             	lea    0x8(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b9:	e9 c9 00 00 00       	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007dc:	e9 a6 00 00 00       	jmp    800887 <vprintfmt+0x428>
			putch('0', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	6a 30                	push   $0x30
  8007e7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f0:	7f 26                	jg     800818 <vprintfmt+0x3b9>
	else if (lflag)
  8007f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f6:	74 3e                	je     800836 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 40 04             	lea    0x4(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800811:	b8 08 00 00 00       	mov    $0x8,%eax
  800816:	eb 6f                	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8b 50 04             	mov    0x4(%eax),%edx
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800823:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 08             	lea    0x8(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082f:	b8 08 00 00 00       	mov    $0x8,%eax
  800834:	eb 51                	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	ba 00 00 00 00       	mov    $0x0,%edx
  800840:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800843:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8d 40 04             	lea    0x4(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084f:	b8 08 00 00 00       	mov    $0x8,%eax
  800854:	eb 31                	jmp    800887 <vprintfmt+0x428>
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	53                   	push   %ebx
  80085a:	6a 30                	push   $0x30
  80085c:	ff d6                	call   *%esi
			putch('x', putdat);
  80085e:	83 c4 08             	add    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	6a 78                	push   $0x78
  800864:	ff d6                	call   *%esi
			num = (unsigned long long)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800873:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800876:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8d 40 04             	lea    0x4(%eax),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800882:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800887:	83 ec 0c             	sub    $0xc,%esp
  80088a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80088e:	52                   	push   %edx
  80088f:	ff 75 e0             	pushl  -0x20(%ebp)
  800892:	50                   	push   %eax
  800893:	ff 75 dc             	pushl  -0x24(%ebp)
  800896:	ff 75 d8             	pushl  -0x28(%ebp)
  800899:	89 da                	mov    %ebx,%edx
  80089b:	89 f0                	mov    %esi,%eax
  80089d:	e8 a4 fa ff ff       	call   800346 <printnum>
			break;
  8008a2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a8:	83 c7 01             	add    $0x1,%edi
  8008ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008af:	83 f8 25             	cmp    $0x25,%eax
  8008b2:	0f 84 be fb ff ff    	je     800476 <vprintfmt+0x17>
			if (ch == '\0')
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	0f 84 28 01 00 00    	je     8009e8 <vprintfmt+0x589>
			putch(ch, putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	53                   	push   %ebx
  8008c4:	50                   	push   %eax
  8008c5:	ff d6                	call   *%esi
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	eb dc                	jmp    8008a8 <vprintfmt+0x449>
	if (lflag >= 2)
  8008cc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008d0:	7f 26                	jg     8008f8 <vprintfmt+0x499>
	else if (lflag)
  8008d2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008d6:	74 41                	je     800919 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	8d 40 04             	lea    0x4(%eax),%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f1:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f6:	eb 8f                	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	8b 50 04             	mov    0x4(%eax),%edx
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800903:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	8d 40 08             	lea    0x8(%eax),%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090f:	b8 10 00 00 00       	mov    $0x10,%eax
  800914:	e9 6e ff ff ff       	jmp    800887 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	ba 00 00 00 00       	mov    $0x0,%edx
  800923:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800926:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	8d 40 04             	lea    0x4(%eax),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800932:	b8 10 00 00 00       	mov    $0x10,%eax
  800937:	e9 4b ff ff ff       	jmp    800887 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	83 c0 04             	add    $0x4,%eax
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	85 c0                	test   %eax,%eax
  80094c:	74 14                	je     800962 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80094e:	8b 13                	mov    (%ebx),%edx
  800950:	83 fa 7f             	cmp    $0x7f,%edx
  800953:	7f 37                	jg     80098c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800955:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800957:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	e9 43 ff ff ff       	jmp    8008a5 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800962:	b8 0a 00 00 00       	mov    $0xa,%eax
  800967:	bf a9 29 80 00       	mov    $0x8029a9,%edi
							putch(ch, putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	50                   	push   %eax
  800971:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800973:	83 c7 01             	add    $0x1,%edi
  800976:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	85 c0                	test   %eax,%eax
  80097f:	75 eb                	jne    80096c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800981:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
  800987:	e9 19 ff ff ff       	jmp    8008a5 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80098c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80098e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800993:	bf e1 29 80 00       	mov    $0x8029e1,%edi
							putch(ch, putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	53                   	push   %ebx
  80099c:	50                   	push   %eax
  80099d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80099f:	83 c7 01             	add    $0x1,%edi
  8009a2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	85 c0                	test   %eax,%eax
  8009ab:	75 eb                	jne    800998 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	e9 ed fe ff ff       	jmp    8008a5 <vprintfmt+0x446>
			putch(ch, putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	53                   	push   %ebx
  8009bc:	6a 25                	push   $0x25
  8009be:	ff d6                	call   *%esi
			break;
  8009c0:	83 c4 10             	add    $0x10,%esp
  8009c3:	e9 dd fe ff ff       	jmp    8008a5 <vprintfmt+0x446>
			putch('%', putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	53                   	push   %ebx
  8009cc:	6a 25                	push   $0x25
  8009ce:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	eb 03                	jmp    8009da <vprintfmt+0x57b>
  8009d7:	83 e8 01             	sub    $0x1,%eax
  8009da:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009de:	75 f7                	jne    8009d7 <vprintfmt+0x578>
  8009e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e3:	e9 bd fe ff ff       	jmp    8008a5 <vprintfmt+0x446>
}
  8009e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5f                   	pop    %edi
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 18             	sub    $0x18,%esp
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ff:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a03:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0d:	85 c0                	test   %eax,%eax
  800a0f:	74 26                	je     800a37 <vsnprintf+0x47>
  800a11:	85 d2                	test   %edx,%edx
  800a13:	7e 22                	jle    800a37 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a15:	ff 75 14             	pushl  0x14(%ebp)
  800a18:	ff 75 10             	pushl  0x10(%ebp)
  800a1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1e:	50                   	push   %eax
  800a1f:	68 25 04 80 00       	push   $0x800425
  800a24:	e8 36 fa ff ff       	call   80045f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a32:	83 c4 10             	add    $0x10,%esp
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    
		return -E_INVAL;
  800a37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a3c:	eb f7                	jmp    800a35 <vsnprintf+0x45>

00800a3e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a44:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a47:	50                   	push   %eax
  800a48:	ff 75 10             	pushl  0x10(%ebp)
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	ff 75 08             	pushl  0x8(%ebp)
  800a51:	e8 9a ff ff ff       	call   8009f0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a67:	74 05                	je     800a6e <strlen+0x16>
		n++;
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	eb f5                	jmp    800a63 <strlen+0xb>
	return n;
}
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a76:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a79:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7e:	39 c2                	cmp    %eax,%edx
  800a80:	74 0d                	je     800a8f <strnlen+0x1f>
  800a82:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a86:	74 05                	je     800a8d <strnlen+0x1d>
		n++;
  800a88:	83 c2 01             	add    $0x1,%edx
  800a8b:	eb f1                	jmp    800a7e <strnlen+0xe>
  800a8d:	89 d0                	mov    %edx,%eax
	return n;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aa4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aa7:	83 c2 01             	add    $0x1,%edx
  800aaa:	84 c9                	test   %cl,%cl
  800aac:	75 f2                	jne    800aa0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aae:	5b                   	pop    %ebx
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	53                   	push   %ebx
  800ab5:	83 ec 10             	sub    $0x10,%esp
  800ab8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800abb:	53                   	push   %ebx
  800abc:	e8 97 ff ff ff       	call   800a58 <strlen>
  800ac1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	01 d8                	add    %ebx,%eax
  800ac9:	50                   	push   %eax
  800aca:	e8 c2 ff ff ff       	call   800a91 <strcpy>
	return dst;
}
  800acf:	89 d8                	mov    %ebx,%eax
  800ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	56                   	push   %esi
  800ada:	53                   	push   %ebx
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae1:	89 c6                	mov    %eax,%esi
  800ae3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	39 f2                	cmp    %esi,%edx
  800aea:	74 11                	je     800afd <strncpy+0x27>
		*dst++ = *src;
  800aec:	83 c2 01             	add    $0x1,%edx
  800aef:	0f b6 19             	movzbl (%ecx),%ebx
  800af2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af5:	80 fb 01             	cmp    $0x1,%bl
  800af8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800afb:	eb eb                	jmp    800ae8 <strncpy+0x12>
	}
	return ret;
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	8b 75 08             	mov    0x8(%ebp),%esi
  800b09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0c:	8b 55 10             	mov    0x10(%ebp),%edx
  800b0f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b11:	85 d2                	test   %edx,%edx
  800b13:	74 21                	je     800b36 <strlcpy+0x35>
  800b15:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b19:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b1b:	39 c2                	cmp    %eax,%edx
  800b1d:	74 14                	je     800b33 <strlcpy+0x32>
  800b1f:	0f b6 19             	movzbl (%ecx),%ebx
  800b22:	84 db                	test   %bl,%bl
  800b24:	74 0b                	je     800b31 <strlcpy+0x30>
			*dst++ = *src++;
  800b26:	83 c1 01             	add    $0x1,%ecx
  800b29:	83 c2 01             	add    $0x1,%edx
  800b2c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b2f:	eb ea                	jmp    800b1b <strlcpy+0x1a>
  800b31:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b33:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b36:	29 f0                	sub    %esi,%eax
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b45:	0f b6 01             	movzbl (%ecx),%eax
  800b48:	84 c0                	test   %al,%al
  800b4a:	74 0c                	je     800b58 <strcmp+0x1c>
  800b4c:	3a 02                	cmp    (%edx),%al
  800b4e:	75 08                	jne    800b58 <strcmp+0x1c>
		p++, q++;
  800b50:	83 c1 01             	add    $0x1,%ecx
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	eb ed                	jmp    800b45 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b58:	0f b6 c0             	movzbl %al,%eax
  800b5b:	0f b6 12             	movzbl (%edx),%edx
  800b5e:	29 d0                	sub    %edx,%eax
}
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	53                   	push   %ebx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 c3                	mov    %eax,%ebx
  800b6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b71:	eb 06                	jmp    800b79 <strncmp+0x17>
		n--, p++, q++;
  800b73:	83 c0 01             	add    $0x1,%eax
  800b76:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b79:	39 d8                	cmp    %ebx,%eax
  800b7b:	74 16                	je     800b93 <strncmp+0x31>
  800b7d:	0f b6 08             	movzbl (%eax),%ecx
  800b80:	84 c9                	test   %cl,%cl
  800b82:	74 04                	je     800b88 <strncmp+0x26>
  800b84:	3a 0a                	cmp    (%edx),%cl
  800b86:	74 eb                	je     800b73 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b88:	0f b6 00             	movzbl (%eax),%eax
  800b8b:	0f b6 12             	movzbl (%edx),%edx
  800b8e:	29 d0                	sub    %edx,%eax
}
  800b90:	5b                   	pop    %ebx
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    
		return 0;
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
  800b98:	eb f6                	jmp    800b90 <strncmp+0x2e>

00800b9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba4:	0f b6 10             	movzbl (%eax),%edx
  800ba7:	84 d2                	test   %dl,%dl
  800ba9:	74 09                	je     800bb4 <strchr+0x1a>
		if (*s == c)
  800bab:	38 ca                	cmp    %cl,%dl
  800bad:	74 0a                	je     800bb9 <strchr+0x1f>
	for (; *s; s++)
  800baf:	83 c0 01             	add    $0x1,%eax
  800bb2:	eb f0                	jmp    800ba4 <strchr+0xa>
			return (char *) s;
	return 0;
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bc8:	38 ca                	cmp    %cl,%dl
  800bca:	74 09                	je     800bd5 <strfind+0x1a>
  800bcc:	84 d2                	test   %dl,%dl
  800bce:	74 05                	je     800bd5 <strfind+0x1a>
	for (; *s; s++)
  800bd0:	83 c0 01             	add    $0x1,%eax
  800bd3:	eb f0                	jmp    800bc5 <strfind+0xa>
			break;
	return (char *) s;
}
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800be3:	85 c9                	test   %ecx,%ecx
  800be5:	74 31                	je     800c18 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800be7:	89 f8                	mov    %edi,%eax
  800be9:	09 c8                	or     %ecx,%eax
  800beb:	a8 03                	test   $0x3,%al
  800bed:	75 23                	jne    800c12 <memset+0x3b>
		c &= 0xFF;
  800bef:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bf3:	89 d3                	mov    %edx,%ebx
  800bf5:	c1 e3 08             	shl    $0x8,%ebx
  800bf8:	89 d0                	mov    %edx,%eax
  800bfa:	c1 e0 18             	shl    $0x18,%eax
  800bfd:	89 d6                	mov    %edx,%esi
  800bff:	c1 e6 10             	shl    $0x10,%esi
  800c02:	09 f0                	or     %esi,%eax
  800c04:	09 c2                	or     %eax,%edx
  800c06:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c08:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c0b:	89 d0                	mov    %edx,%eax
  800c0d:	fc                   	cld    
  800c0e:	f3 ab                	rep stos %eax,%es:(%edi)
  800c10:	eb 06                	jmp    800c18 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	fc                   	cld    
  800c16:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c18:	89 f8                	mov    %edi,%eax
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c2d:	39 c6                	cmp    %eax,%esi
  800c2f:	73 32                	jae    800c63 <memmove+0x44>
  800c31:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c34:	39 c2                	cmp    %eax,%edx
  800c36:	76 2b                	jbe    800c63 <memmove+0x44>
		s += n;
		d += n;
  800c38:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c3b:	89 fe                	mov    %edi,%esi
  800c3d:	09 ce                	or     %ecx,%esi
  800c3f:	09 d6                	or     %edx,%esi
  800c41:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c47:	75 0e                	jne    800c57 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c49:	83 ef 04             	sub    $0x4,%edi
  800c4c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c4f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c52:	fd                   	std    
  800c53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c55:	eb 09                	jmp    800c60 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c57:	83 ef 01             	sub    $0x1,%edi
  800c5a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c5d:	fd                   	std    
  800c5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c60:	fc                   	cld    
  800c61:	eb 1a                	jmp    800c7d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c63:	89 c2                	mov    %eax,%edx
  800c65:	09 ca                	or     %ecx,%edx
  800c67:	09 f2                	or     %esi,%edx
  800c69:	f6 c2 03             	test   $0x3,%dl
  800c6c:	75 0a                	jne    800c78 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c6e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c71:	89 c7                	mov    %eax,%edi
  800c73:	fc                   	cld    
  800c74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c76:	eb 05                	jmp    800c7d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c78:	89 c7                	mov    %eax,%edi
  800c7a:	fc                   	cld    
  800c7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c87:	ff 75 10             	pushl  0x10(%ebp)
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 8a ff ff ff       	call   800c1f <memmove>
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	89 c6                	mov    %eax,%esi
  800ca4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca7:	39 f0                	cmp    %esi,%eax
  800ca9:	74 1c                	je     800cc7 <memcmp+0x30>
		if (*s1 != *s2)
  800cab:	0f b6 08             	movzbl (%eax),%ecx
  800cae:	0f b6 1a             	movzbl (%edx),%ebx
  800cb1:	38 d9                	cmp    %bl,%cl
  800cb3:	75 08                	jne    800cbd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cb5:	83 c0 01             	add    $0x1,%eax
  800cb8:	83 c2 01             	add    $0x1,%edx
  800cbb:	eb ea                	jmp    800ca7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cbd:	0f b6 c1             	movzbl %cl,%eax
  800cc0:	0f b6 db             	movzbl %bl,%ebx
  800cc3:	29 d8                	sub    %ebx,%eax
  800cc5:	eb 05                	jmp    800ccc <memcmp+0x35>
	}

	return 0;
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cd9:	89 c2                	mov    %eax,%edx
  800cdb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cde:	39 d0                	cmp    %edx,%eax
  800ce0:	73 09                	jae    800ceb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce2:	38 08                	cmp    %cl,(%eax)
  800ce4:	74 05                	je     800ceb <memfind+0x1b>
	for (; s < ends; s++)
  800ce6:	83 c0 01             	add    $0x1,%eax
  800ce9:	eb f3                	jmp    800cde <memfind+0xe>
			break;
	return (void *) s;
}
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf9:	eb 03                	jmp    800cfe <strtol+0x11>
		s++;
  800cfb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cfe:	0f b6 01             	movzbl (%ecx),%eax
  800d01:	3c 20                	cmp    $0x20,%al
  800d03:	74 f6                	je     800cfb <strtol+0xe>
  800d05:	3c 09                	cmp    $0x9,%al
  800d07:	74 f2                	je     800cfb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d09:	3c 2b                	cmp    $0x2b,%al
  800d0b:	74 2a                	je     800d37 <strtol+0x4a>
	int neg = 0;
  800d0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d12:	3c 2d                	cmp    $0x2d,%al
  800d14:	74 2b                	je     800d41 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d1c:	75 0f                	jne    800d2d <strtol+0x40>
  800d1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800d21:	74 28                	je     800d4b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d23:	85 db                	test   %ebx,%ebx
  800d25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2a:	0f 44 d8             	cmove  %eax,%ebx
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d35:	eb 50                	jmp    800d87 <strtol+0x9a>
		s++;
  800d37:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3f:	eb d5                	jmp    800d16 <strtol+0x29>
		s++, neg = 1;
  800d41:	83 c1 01             	add    $0x1,%ecx
  800d44:	bf 01 00 00 00       	mov    $0x1,%edi
  800d49:	eb cb                	jmp    800d16 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d4f:	74 0e                	je     800d5f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d51:	85 db                	test   %ebx,%ebx
  800d53:	75 d8                	jne    800d2d <strtol+0x40>
		s++, base = 8;
  800d55:	83 c1 01             	add    $0x1,%ecx
  800d58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d5d:	eb ce                	jmp    800d2d <strtol+0x40>
		s += 2, base = 16;
  800d5f:	83 c1 02             	add    $0x2,%ecx
  800d62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d67:	eb c4                	jmp    800d2d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d69:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6c:	89 f3                	mov    %esi,%ebx
  800d6e:	80 fb 19             	cmp    $0x19,%bl
  800d71:	77 29                	ja     800d9c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d73:	0f be d2             	movsbl %dl,%edx
  800d76:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d79:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d7c:	7d 30                	jge    800dae <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d7e:	83 c1 01             	add    $0x1,%ecx
  800d81:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d85:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d87:	0f b6 11             	movzbl (%ecx),%edx
  800d8a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d8d:	89 f3                	mov    %esi,%ebx
  800d8f:	80 fb 09             	cmp    $0x9,%bl
  800d92:	77 d5                	ja     800d69 <strtol+0x7c>
			dig = *s - '0';
  800d94:	0f be d2             	movsbl %dl,%edx
  800d97:	83 ea 30             	sub    $0x30,%edx
  800d9a:	eb dd                	jmp    800d79 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d9c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d9f:	89 f3                	mov    %esi,%ebx
  800da1:	80 fb 19             	cmp    $0x19,%bl
  800da4:	77 08                	ja     800dae <strtol+0xc1>
			dig = *s - 'A' + 10;
  800da6:	0f be d2             	movsbl %dl,%edx
  800da9:	83 ea 37             	sub    $0x37,%edx
  800dac:	eb cb                	jmp    800d79 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db2:	74 05                	je     800db9 <strtol+0xcc>
		*endptr = (char *) s;
  800db4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800db9:	89 c2                	mov    %eax,%edx
  800dbb:	f7 da                	neg    %edx
  800dbd:	85 ff                	test   %edi,%edi
  800dbf:	0f 45 c2             	cmovne %edx,%eax
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	89 c3                	mov    %eax,%ebx
  800dda:	89 c7                	mov    %eax,%edi
  800ddc:	89 c6                	mov    %eax,%esi
  800dde:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800deb:	ba 00 00 00 00       	mov    $0x0,%edx
  800df0:	b8 01 00 00 00       	mov    $0x1,%eax
  800df5:	89 d1                	mov    %edx,%ecx
  800df7:	89 d3                	mov    %edx,%ebx
  800df9:	89 d7                	mov    %edx,%edi
  800dfb:	89 d6                	mov    %edx,%esi
  800dfd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	b8 03 00 00 00       	mov    $0x3,%eax
  800e1a:	89 cb                	mov    %ecx,%ebx
  800e1c:	89 cf                	mov    %ecx,%edi
  800e1e:	89 ce                	mov    %ecx,%esi
  800e20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7f 08                	jg     800e2e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	6a 03                	push   $0x3
  800e34:	68 08 2c 80 00       	push   $0x802c08
  800e39:	6a 43                	push   $0x43
  800e3b:	68 25 2c 80 00       	push   $0x802c25
  800e40:	e8 f7 f3 ff ff       	call   80023c <_panic>

00800e45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e50:	b8 02 00 00 00       	mov    $0x2,%eax
  800e55:	89 d1                	mov    %edx,%ecx
  800e57:	89 d3                	mov    %edx,%ebx
  800e59:	89 d7                	mov    %edx,%edi
  800e5b:	89 d6                	mov    %edx,%esi
  800e5d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_yield>:

void
sys_yield(void)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e74:	89 d1                	mov    %edx,%ecx
  800e76:	89 d3                	mov    %edx,%ebx
  800e78:	89 d7                	mov    %edx,%edi
  800e7a:	89 d6                	mov    %edx,%esi
  800e7c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8c:	be 00 00 00 00       	mov    $0x0,%esi
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e97:	b8 04 00 00 00       	mov    $0x4,%eax
  800e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9f:	89 f7                	mov    %esi,%edi
  800ea1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	7f 08                	jg     800eaf <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaf:	83 ec 0c             	sub    $0xc,%esp
  800eb2:	50                   	push   %eax
  800eb3:	6a 04                	push   $0x4
  800eb5:	68 08 2c 80 00       	push   $0x802c08
  800eba:	6a 43                	push   $0x43
  800ebc:	68 25 2c 80 00       	push   $0x802c25
  800ec1:	e8 76 f3 ff ff       	call   80023c <_panic>

00800ec6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	57                   	push   %edi
  800eca:	56                   	push   %esi
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed5:	b8 05 00 00 00       	mov    $0x5,%eax
  800eda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee0:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	7f 08                	jg     800ef1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	50                   	push   %eax
  800ef5:	6a 05                	push   $0x5
  800ef7:	68 08 2c 80 00       	push   $0x802c08
  800efc:	6a 43                	push   $0x43
  800efe:	68 25 2c 80 00       	push   $0x802c25
  800f03:	e8 34 f3 ff ff       	call   80023c <_panic>

00800f08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	b8 06 00 00 00       	mov    $0x6,%eax
  800f21:	89 df                	mov    %ebx,%edi
  800f23:	89 de                	mov    %ebx,%esi
  800f25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7f 08                	jg     800f33 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	50                   	push   %eax
  800f37:	6a 06                	push   $0x6
  800f39:	68 08 2c 80 00       	push   $0x802c08
  800f3e:	6a 43                	push   $0x43
  800f40:	68 25 2c 80 00       	push   $0x802c25
  800f45:	e8 f2 f2 ff ff       	call   80023c <_panic>

00800f4a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5e:	b8 08 00 00 00       	mov    $0x8,%eax
  800f63:	89 df                	mov    %ebx,%edi
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	7f 08                	jg     800f75 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	50                   	push   %eax
  800f79:	6a 08                	push   $0x8
  800f7b:	68 08 2c 80 00       	push   $0x802c08
  800f80:	6a 43                	push   $0x43
  800f82:	68 25 2c 80 00       	push   $0x802c25
  800f87:	e8 b0 f2 ff ff       	call   80023c <_panic>

00800f8c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
  800f92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa5:	89 df                	mov    %ebx,%edi
  800fa7:	89 de                	mov    %ebx,%esi
  800fa9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	7f 08                	jg     800fb7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb7:	83 ec 0c             	sub    $0xc,%esp
  800fba:	50                   	push   %eax
  800fbb:	6a 09                	push   $0x9
  800fbd:	68 08 2c 80 00       	push   $0x802c08
  800fc2:	6a 43                	push   $0x43
  800fc4:	68 25 2c 80 00       	push   $0x802c25
  800fc9:	e8 6e f2 ff ff       	call   80023c <_panic>

00800fce <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe7:	89 df                	mov    %ebx,%edi
  800fe9:	89 de                	mov    %ebx,%esi
  800feb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	7f 08                	jg     800ff9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	50                   	push   %eax
  800ffd:	6a 0a                	push   $0xa
  800fff:	68 08 2c 80 00       	push   $0x802c08
  801004:	6a 43                	push   $0x43
  801006:	68 25 2c 80 00       	push   $0x802c25
  80100b:	e8 2c f2 ff ff       	call   80023c <_panic>

00801010 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
	asm volatile("int %1\n"
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801021:	be 00 00 00 00       	mov    $0x0,%esi
  801026:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801029:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	b8 0d 00 00 00       	mov    $0xd,%eax
  801049:	89 cb                	mov    %ecx,%ebx
  80104b:	89 cf                	mov    %ecx,%edi
  80104d:	89 ce                	mov    %ecx,%esi
  80104f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801051:	85 c0                	test   %eax,%eax
  801053:	7f 08                	jg     80105d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801055:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	50                   	push   %eax
  801061:	6a 0d                	push   $0xd
  801063:	68 08 2c 80 00       	push   $0x802c08
  801068:	6a 43                	push   $0x43
  80106a:	68 25 2c 80 00       	push   $0x802c25
  80106f:	e8 c8 f1 ff ff       	call   80023c <_panic>

00801074 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	57                   	push   %edi
  801078:	56                   	push   %esi
  801079:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107f:	8b 55 08             	mov    0x8(%ebp),%edx
  801082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801085:	b8 0e 00 00 00       	mov    $0xe,%eax
  80108a:	89 df                	mov    %ebx,%edi
  80108c:	89 de                	mov    %ebx,%esi
  80108e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	57                   	push   %edi
  801099:	56                   	push   %esi
  80109a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a3:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010a8:	89 cb                	mov    %ecx,%ebx
  8010aa:	89 cf                	mov    %ecx,%edi
  8010ac:	89 ce                	mov    %ecx,%esi
  8010ae:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c0:	b8 10 00 00 00       	mov    $0x10,%eax
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 d3                	mov    %edx,%ebx
  8010c9:	89 d7                	mov    %edx,%edi
  8010cb:	89 d6                	mov    %edx,%esi
  8010cd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010cf:	5b                   	pop    %ebx
  8010d0:	5e                   	pop    %esi
  8010d1:	5f                   	pop    %edi
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010df:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e5:	b8 11 00 00 00       	mov    $0x11,%eax
  8010ea:	89 df                	mov    %ebx,%edi
  8010ec:	89 de                	mov    %ebx,%esi
  8010ee:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801106:	b8 12 00 00 00       	mov    $0x12,%eax
  80110b:	89 df                	mov    %ebx,%edi
  80110d:	89 de                	mov    %ebx,%esi
  80110f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    

00801116 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
  80111c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80111f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801124:	8b 55 08             	mov    0x8(%ebp),%edx
  801127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112a:	b8 13 00 00 00       	mov    $0x13,%eax
  80112f:	89 df                	mov    %ebx,%edi
  801131:	89 de                	mov    %ebx,%esi
  801133:	cd 30                	int    $0x30
	if(check && ret > 0)
  801135:	85 c0                	test   %eax,%eax
  801137:	7f 08                	jg     801141 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801139:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	50                   	push   %eax
  801145:	6a 13                	push   $0x13
  801147:	68 08 2c 80 00       	push   $0x802c08
  80114c:	6a 43                	push   $0x43
  80114e:	68 25 2c 80 00       	push   $0x802c25
  801153:	e8 e4 f0 ff ff       	call   80023c <_panic>

00801158 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	b8 14 00 00 00       	mov    $0x14,%eax
  80116b:	89 cb                	mov    %ecx,%ebx
  80116d:	89 cf                	mov    %ecx,%edi
  80116f:	89 ce                	mov    %ecx,%esi
  801171:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801173:	5b                   	pop    %ebx
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	05 00 00 00 30       	add    $0x30000000,%eax
  801183:	c1 e8 0c             	shr    $0xc,%eax
}
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801193:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801198:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a7:	89 c2                	mov    %eax,%edx
  8011a9:	c1 ea 16             	shr    $0x16,%edx
  8011ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b3:	f6 c2 01             	test   $0x1,%dl
  8011b6:	74 2d                	je     8011e5 <fd_alloc+0x46>
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	c1 ea 0c             	shr    $0xc,%edx
  8011bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c4:	f6 c2 01             	test   $0x1,%dl
  8011c7:	74 1c                	je     8011e5 <fd_alloc+0x46>
  8011c9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011ce:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d3:	75 d2                	jne    8011a7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011de:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e3:	eb 0a                	jmp    8011ef <fd_alloc+0x50>
			*fd_store = fd;
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011f7:	83 f8 1f             	cmp    $0x1f,%eax
  8011fa:	77 30                	ja     80122c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011fc:	c1 e0 0c             	shl    $0xc,%eax
  8011ff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801204:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80120a:	f6 c2 01             	test   $0x1,%dl
  80120d:	74 24                	je     801233 <fd_lookup+0x42>
  80120f:	89 c2                	mov    %eax,%edx
  801211:	c1 ea 0c             	shr    $0xc,%edx
  801214:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121b:	f6 c2 01             	test   $0x1,%dl
  80121e:	74 1a                	je     80123a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801220:	8b 55 0c             	mov    0xc(%ebp),%edx
  801223:	89 02                	mov    %eax,(%edx)
	return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    
		return -E_INVAL;
  80122c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801231:	eb f7                	jmp    80122a <fd_lookup+0x39>
		return -E_INVAL;
  801233:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801238:	eb f0                	jmp    80122a <fd_lookup+0x39>
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123f:	eb e9                	jmp    80122a <fd_lookup+0x39>

00801241 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80124a:	ba 00 00 00 00       	mov    $0x0,%edx
  80124f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801254:	39 08                	cmp    %ecx,(%eax)
  801256:	74 38                	je     801290 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801258:	83 c2 01             	add    $0x1,%edx
  80125b:	8b 04 95 b4 2c 80 00 	mov    0x802cb4(,%edx,4),%eax
  801262:	85 c0                	test   %eax,%eax
  801264:	75 ee                	jne    801254 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801266:	a1 20 60 80 00       	mov    0x806020,%eax
  80126b:	8b 40 48             	mov    0x48(%eax),%eax
  80126e:	83 ec 04             	sub    $0x4,%esp
  801271:	51                   	push   %ecx
  801272:	50                   	push   %eax
  801273:	68 34 2c 80 00       	push   $0x802c34
  801278:	e8 b5 f0 ff ff       	call   800332 <cprintf>
	*dev = 0;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    
			*dev = devtab[i];
  801290:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801293:	89 01                	mov    %eax,(%ecx)
			return 0;
  801295:	b8 00 00 00 00       	mov    $0x0,%eax
  80129a:	eb f2                	jmp    80128e <dev_lookup+0x4d>

0080129c <fd_close>:
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 24             	sub    $0x24,%esp
  8012a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ae:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012af:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012b5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b8:	50                   	push   %eax
  8012b9:	e8 33 ff ff ff       	call   8011f1 <fd_lookup>
  8012be:	89 c3                	mov    %eax,%ebx
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	78 05                	js     8012cc <fd_close+0x30>
	    || fd != fd2)
  8012c7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012ca:	74 16                	je     8012e2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012cc:	89 f8                	mov    %edi,%eax
  8012ce:	84 c0                	test   %al,%al
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d5:	0f 44 d8             	cmove  %eax,%ebx
}
  8012d8:	89 d8                	mov    %ebx,%eax
  8012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5f                   	pop    %edi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012e8:	50                   	push   %eax
  8012e9:	ff 36                	pushl  (%esi)
  8012eb:	e8 51 ff ff ff       	call   801241 <dev_lookup>
  8012f0:	89 c3                	mov    %eax,%ebx
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 1a                	js     801313 <fd_close+0x77>
		if (dev->dev_close)
  8012f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012fc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801304:	85 c0                	test   %eax,%eax
  801306:	74 0b                	je     801313 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	56                   	push   %esi
  80130c:	ff d0                	call   *%eax
  80130e:	89 c3                	mov    %eax,%ebx
  801310:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801313:	83 ec 08             	sub    $0x8,%esp
  801316:	56                   	push   %esi
  801317:	6a 00                	push   $0x0
  801319:	e8 ea fb ff ff       	call   800f08 <sys_page_unmap>
	return r;
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	eb b5                	jmp    8012d8 <fd_close+0x3c>

00801323 <close>:

int
close(int fdnum)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801329:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	ff 75 08             	pushl  0x8(%ebp)
  801330:	e8 bc fe ff ff       	call   8011f1 <fd_lookup>
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	79 02                	jns    80133e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    
		return fd_close(fd, 1);
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	6a 01                	push   $0x1
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	e8 51 ff ff ff       	call   80129c <fd_close>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	eb ec                	jmp    80133c <close+0x19>

00801350 <close_all>:

void
close_all(void)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	53                   	push   %ebx
  801354:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801357:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	53                   	push   %ebx
  801360:	e8 be ff ff ff       	call   801323 <close>
	for (i = 0; i < MAXFD; i++)
  801365:	83 c3 01             	add    $0x1,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	83 fb 20             	cmp    $0x20,%ebx
  80136e:	75 ec                	jne    80135c <close_all+0xc>
}
  801370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	57                   	push   %edi
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80137e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801381:	50                   	push   %eax
  801382:	ff 75 08             	pushl  0x8(%ebp)
  801385:	e8 67 fe ff ff       	call   8011f1 <fd_lookup>
  80138a:	89 c3                	mov    %eax,%ebx
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	0f 88 81 00 00 00    	js     801418 <dup+0xa3>
		return r;
	close(newfdnum);
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	ff 75 0c             	pushl  0xc(%ebp)
  80139d:	e8 81 ff ff ff       	call   801323 <close>

	newfd = INDEX2FD(newfdnum);
  8013a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013a5:	c1 e6 0c             	shl    $0xc,%esi
  8013a8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013ae:	83 c4 04             	add    $0x4,%esp
  8013b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b4:	e8 cf fd ff ff       	call   801188 <fd2data>
  8013b9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013bb:	89 34 24             	mov    %esi,(%esp)
  8013be:	e8 c5 fd ff ff       	call   801188 <fd2data>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013c8:	89 d8                	mov    %ebx,%eax
  8013ca:	c1 e8 16             	shr    $0x16,%eax
  8013cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d4:	a8 01                	test   $0x1,%al
  8013d6:	74 11                	je     8013e9 <dup+0x74>
  8013d8:	89 d8                	mov    %ebx,%eax
  8013da:	c1 e8 0c             	shr    $0xc,%eax
  8013dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e4:	f6 c2 01             	test   $0x1,%dl
  8013e7:	75 39                	jne    801422 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ec:	89 d0                	mov    %edx,%eax
  8013ee:	c1 e8 0c             	shr    $0xc,%eax
  8013f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	25 07 0e 00 00       	and    $0xe07,%eax
  801400:	50                   	push   %eax
  801401:	56                   	push   %esi
  801402:	6a 00                	push   $0x0
  801404:	52                   	push   %edx
  801405:	6a 00                	push   $0x0
  801407:	e8 ba fa ff ff       	call   800ec6 <sys_page_map>
  80140c:	89 c3                	mov    %eax,%ebx
  80140e:	83 c4 20             	add    $0x20,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	78 31                	js     801446 <dup+0xd1>
		goto err;

	return newfdnum;
  801415:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801418:	89 d8                	mov    %ebx,%eax
  80141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141d:	5b                   	pop    %ebx
  80141e:	5e                   	pop    %esi
  80141f:	5f                   	pop    %edi
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801422:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801429:	83 ec 0c             	sub    $0xc,%esp
  80142c:	25 07 0e 00 00       	and    $0xe07,%eax
  801431:	50                   	push   %eax
  801432:	57                   	push   %edi
  801433:	6a 00                	push   $0x0
  801435:	53                   	push   %ebx
  801436:	6a 00                	push   $0x0
  801438:	e8 89 fa ff ff       	call   800ec6 <sys_page_map>
  80143d:	89 c3                	mov    %eax,%ebx
  80143f:	83 c4 20             	add    $0x20,%esp
  801442:	85 c0                	test   %eax,%eax
  801444:	79 a3                	jns    8013e9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	56                   	push   %esi
  80144a:	6a 00                	push   $0x0
  80144c:	e8 b7 fa ff ff       	call   800f08 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801451:	83 c4 08             	add    $0x8,%esp
  801454:	57                   	push   %edi
  801455:	6a 00                	push   $0x0
  801457:	e8 ac fa ff ff       	call   800f08 <sys_page_unmap>
	return r;
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	eb b7                	jmp    801418 <dup+0xa3>

00801461 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	53                   	push   %ebx
  801465:	83 ec 1c             	sub    $0x1c,%esp
  801468:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	53                   	push   %ebx
  801470:	e8 7c fd ff ff       	call   8011f1 <fd_lookup>
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 3f                	js     8014bb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801486:	ff 30                	pushl  (%eax)
  801488:	e8 b4 fd ff ff       	call   801241 <dev_lookup>
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	85 c0                	test   %eax,%eax
  801492:	78 27                	js     8014bb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801494:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801497:	8b 42 08             	mov    0x8(%edx),%eax
  80149a:	83 e0 03             	and    $0x3,%eax
  80149d:	83 f8 01             	cmp    $0x1,%eax
  8014a0:	74 1e                	je     8014c0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a5:	8b 40 08             	mov    0x8(%eax),%eax
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 35                	je     8014e1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	ff 75 10             	pushl  0x10(%ebp)
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	52                   	push   %edx
  8014b6:	ff d0                	call   *%eax
  8014b8:	83 c4 10             	add    $0x10,%esp
}
  8014bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8014c5:	8b 40 48             	mov    0x48(%eax),%eax
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	53                   	push   %ebx
  8014cc:	50                   	push   %eax
  8014cd:	68 78 2c 80 00       	push   $0x802c78
  8014d2:	e8 5b ee ff ff       	call   800332 <cprintf>
		return -E_INVAL;
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014df:	eb da                	jmp    8014bb <read+0x5a>
		return -E_NOT_SUPP;
  8014e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e6:	eb d3                	jmp    8014bb <read+0x5a>

008014e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	57                   	push   %edi
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fc:	39 f3                	cmp    %esi,%ebx
  8014fe:	73 23                	jae    801523 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	89 f0                	mov    %esi,%eax
  801505:	29 d8                	sub    %ebx,%eax
  801507:	50                   	push   %eax
  801508:	89 d8                	mov    %ebx,%eax
  80150a:	03 45 0c             	add    0xc(%ebp),%eax
  80150d:	50                   	push   %eax
  80150e:	57                   	push   %edi
  80150f:	e8 4d ff ff ff       	call   801461 <read>
		if (m < 0)
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 06                	js     801521 <readn+0x39>
			return m;
		if (m == 0)
  80151b:	74 06                	je     801523 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80151d:	01 c3                	add    %eax,%ebx
  80151f:	eb db                	jmp    8014fc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801521:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801523:	89 d8                	mov    %ebx,%eax
  801525:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801528:	5b                   	pop    %ebx
  801529:	5e                   	pop    %esi
  80152a:	5f                   	pop    %edi
  80152b:	5d                   	pop    %ebp
  80152c:	c3                   	ret    

0080152d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	53                   	push   %ebx
  801531:	83 ec 1c             	sub    $0x1c,%esp
  801534:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801537:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153a:	50                   	push   %eax
  80153b:	53                   	push   %ebx
  80153c:	e8 b0 fc ff ff       	call   8011f1 <fd_lookup>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	85 c0                	test   %eax,%eax
  801546:	78 3a                	js     801582 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801548:	83 ec 08             	sub    $0x8,%esp
  80154b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154e:	50                   	push   %eax
  80154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801552:	ff 30                	pushl  (%eax)
  801554:	e8 e8 fc ff ff       	call   801241 <dev_lookup>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 22                	js     801582 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801567:	74 1e                	je     801587 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156c:	8b 52 0c             	mov    0xc(%edx),%edx
  80156f:	85 d2                	test   %edx,%edx
  801571:	74 35                	je     8015a8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	ff 75 10             	pushl  0x10(%ebp)
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	50                   	push   %eax
  80157d:	ff d2                	call   *%edx
  80157f:	83 c4 10             	add    $0x10,%esp
}
  801582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801585:	c9                   	leave  
  801586:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801587:	a1 20 60 80 00       	mov    0x806020,%eax
  80158c:	8b 40 48             	mov    0x48(%eax),%eax
  80158f:	83 ec 04             	sub    $0x4,%esp
  801592:	53                   	push   %ebx
  801593:	50                   	push   %eax
  801594:	68 94 2c 80 00       	push   $0x802c94
  801599:	e8 94 ed ff ff       	call   800332 <cprintf>
		return -E_INVAL;
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a6:	eb da                	jmp    801582 <write+0x55>
		return -E_NOT_SUPP;
  8015a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ad:	eb d3                	jmp    801582 <write+0x55>

008015af <seek>:

int
seek(int fdnum, off_t offset)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b8:	50                   	push   %eax
  8015b9:	ff 75 08             	pushl  0x8(%ebp)
  8015bc:	e8 30 fc ff ff       	call   8011f1 <fd_lookup>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 0e                	js     8015d6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 1c             	sub    $0x1c,%esp
  8015df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e5:	50                   	push   %eax
  8015e6:	53                   	push   %ebx
  8015e7:	e8 05 fc ff ff       	call   8011f1 <fd_lookup>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 37                	js     80162a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fd:	ff 30                	pushl  (%eax)
  8015ff:	e8 3d fc ff ff       	call   801241 <dev_lookup>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 1f                	js     80162a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801612:	74 1b                	je     80162f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801614:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801617:	8b 52 18             	mov    0x18(%edx),%edx
  80161a:	85 d2                	test   %edx,%edx
  80161c:	74 32                	je     801650 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	50                   	push   %eax
  801625:	ff d2                	call   *%edx
  801627:	83 c4 10             	add    $0x10,%esp
}
  80162a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80162f:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801634:	8b 40 48             	mov    0x48(%eax),%eax
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	53                   	push   %ebx
  80163b:	50                   	push   %eax
  80163c:	68 54 2c 80 00       	push   $0x802c54
  801641:	e8 ec ec ff ff       	call   800332 <cprintf>
		return -E_INVAL;
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164e:	eb da                	jmp    80162a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801650:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801655:	eb d3                	jmp    80162a <ftruncate+0x52>

00801657 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	53                   	push   %ebx
  80165b:	83 ec 1c             	sub    $0x1c,%esp
  80165e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801661:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801664:	50                   	push   %eax
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 84 fb ff ff       	call   8011f1 <fd_lookup>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	78 4b                	js     8016bf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	ff 30                	pushl  (%eax)
  801680:	e8 bc fb ff ff       	call   801241 <dev_lookup>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	85 c0                	test   %eax,%eax
  80168a:	78 33                	js     8016bf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801693:	74 2f                	je     8016c4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801695:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801698:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80169f:	00 00 00 
	stat->st_isdir = 0;
  8016a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a9:	00 00 00 
	stat->st_dev = dev;
  8016ac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	53                   	push   %ebx
  8016b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b9:	ff 50 14             	call   *0x14(%eax)
  8016bc:	83 c4 10             	add    $0x10,%esp
}
  8016bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c9:	eb f4                	jmp    8016bf <fstat+0x68>

008016cb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	6a 00                	push   $0x0
  8016d5:	ff 75 08             	pushl  0x8(%ebp)
  8016d8:	e8 22 02 00 00       	call   8018ff <open>
  8016dd:	89 c3                	mov    %eax,%ebx
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	78 1b                	js     801701 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	50                   	push   %eax
  8016ed:	e8 65 ff ff ff       	call   801657 <fstat>
  8016f2:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f4:	89 1c 24             	mov    %ebx,(%esp)
  8016f7:	e8 27 fc ff ff       	call   801323 <close>
	return r;
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	89 f3                	mov    %esi,%ebx
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	56                   	push   %esi
  80170e:	53                   	push   %ebx
  80170f:	89 c6                	mov    %eax,%esi
  801711:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801713:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80171a:	74 27                	je     801743 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80171c:	6a 07                	push   $0x7
  80171e:	68 00 70 80 00       	push   $0x807000
  801723:	56                   	push   %esi
  801724:	ff 35 00 40 80 00    	pushl  0x804000
  80172a:	e8 1c 0d 00 00       	call   80244b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80172f:	83 c4 0c             	add    $0xc,%esp
  801732:	6a 00                	push   $0x0
  801734:	53                   	push   %ebx
  801735:	6a 00                	push   $0x0
  801737:	e8 a6 0c 00 00       	call   8023e2 <ipc_recv>
}
  80173c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	6a 01                	push   $0x1
  801748:	e8 56 0d 00 00       	call   8024a3 <ipc_find_env>
  80174d:	a3 00 40 80 00       	mov    %eax,0x804000
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	eb c5                	jmp    80171c <fsipc+0x12>

00801757 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8b 40 0c             	mov    0xc(%eax),%eax
  801763:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176b:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801770:	ba 00 00 00 00       	mov    $0x0,%edx
  801775:	b8 02 00 00 00       	mov    $0x2,%eax
  80177a:	e8 8b ff ff ff       	call   80170a <fsipc>
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <devfile_flush>:
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8b 40 0c             	mov    0xc(%eax),%eax
  80178d:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801792:	ba 00 00 00 00       	mov    $0x0,%edx
  801797:	b8 06 00 00 00       	mov    $0x6,%eax
  80179c:	e8 69 ff ff ff       	call   80170a <fsipc>
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <devfile_stat>:
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b3:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c2:	e8 43 ff ff ff       	call   80170a <fsipc>
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 2c                	js     8017f7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	68 00 70 80 00       	push   $0x807000
  8017d3:	53                   	push   %ebx
  8017d4:	e8 b8 f2 ff ff       	call   800a91 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017d9:	a1 80 70 80 00       	mov    0x807080,%eax
  8017de:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017e4:	a1 84 70 80 00       	mov    0x807084,%eax
  8017e9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <devfile_write>:
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	53                   	push   %ebx
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8b 40 0c             	mov    0xc(%eax),%eax
  80180c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  801811:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801817:	53                   	push   %ebx
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	68 08 70 80 00       	push   $0x807008
  801820:	e8 5c f4 ff ff       	call   800c81 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801825:	ba 00 00 00 00       	mov    $0x0,%edx
  80182a:	b8 04 00 00 00       	mov    $0x4,%eax
  80182f:	e8 d6 fe ff ff       	call   80170a <fsipc>
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 0b                	js     801846 <devfile_write+0x4a>
	assert(r <= n);
  80183b:	39 d8                	cmp    %ebx,%eax
  80183d:	77 0c                	ja     80184b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80183f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801844:	7f 1e                	jg     801864 <devfile_write+0x68>
}
  801846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801849:	c9                   	leave  
  80184a:	c3                   	ret    
	assert(r <= n);
  80184b:	68 c8 2c 80 00       	push   $0x802cc8
  801850:	68 cf 2c 80 00       	push   $0x802ccf
  801855:	68 98 00 00 00       	push   $0x98
  80185a:	68 e4 2c 80 00       	push   $0x802ce4
  80185f:	e8 d8 e9 ff ff       	call   80023c <_panic>
	assert(r <= PGSIZE);
  801864:	68 ef 2c 80 00       	push   $0x802cef
  801869:	68 cf 2c 80 00       	push   $0x802ccf
  80186e:	68 99 00 00 00       	push   $0x99
  801873:	68 e4 2c 80 00       	push   $0x802ce4
  801878:	e8 bf e9 ff ff       	call   80023c <_panic>

0080187d <devfile_read>:
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
  801882:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8b 40 0c             	mov    0xc(%eax),%eax
  80188b:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801890:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801896:	ba 00 00 00 00       	mov    $0x0,%edx
  80189b:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a0:	e8 65 fe ff ff       	call   80170a <fsipc>
  8018a5:	89 c3                	mov    %eax,%ebx
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 1f                	js     8018ca <devfile_read+0x4d>
	assert(r <= n);
  8018ab:	39 f0                	cmp    %esi,%eax
  8018ad:	77 24                	ja     8018d3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018af:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018b4:	7f 33                	jg     8018e9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	50                   	push   %eax
  8018ba:	68 00 70 80 00       	push   $0x807000
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	e8 58 f3 ff ff       	call   800c1f <memmove>
	return r;
  8018c7:	83 c4 10             	add    $0x10,%esp
}
  8018ca:	89 d8                	mov    %ebx,%eax
  8018cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    
	assert(r <= n);
  8018d3:	68 c8 2c 80 00       	push   $0x802cc8
  8018d8:	68 cf 2c 80 00       	push   $0x802ccf
  8018dd:	6a 7c                	push   $0x7c
  8018df:	68 e4 2c 80 00       	push   $0x802ce4
  8018e4:	e8 53 e9 ff ff       	call   80023c <_panic>
	assert(r <= PGSIZE);
  8018e9:	68 ef 2c 80 00       	push   $0x802cef
  8018ee:	68 cf 2c 80 00       	push   $0x802ccf
  8018f3:	6a 7d                	push   $0x7d
  8018f5:	68 e4 2c 80 00       	push   $0x802ce4
  8018fa:	e8 3d e9 ff ff       	call   80023c <_panic>

008018ff <open>:
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 1c             	sub    $0x1c,%esp
  801907:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80190a:	56                   	push   %esi
  80190b:	e8 48 f1 ff ff       	call   800a58 <strlen>
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801918:	7f 6c                	jg     801986 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801920:	50                   	push   %eax
  801921:	e8 79 f8 ff ff       	call   80119f <fd_alloc>
  801926:	89 c3                	mov    %eax,%ebx
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 3c                	js     80196b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	56                   	push   %esi
  801933:	68 00 70 80 00       	push   $0x807000
  801938:	e8 54 f1 ff ff       	call   800a91 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801948:	b8 01 00 00 00       	mov    $0x1,%eax
  80194d:	e8 b8 fd ff ff       	call   80170a <fsipc>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	78 19                	js     801974 <open+0x75>
	return fd2num(fd);
  80195b:	83 ec 0c             	sub    $0xc,%esp
  80195e:	ff 75 f4             	pushl  -0xc(%ebp)
  801961:	e8 12 f8 ff ff       	call   801178 <fd2num>
  801966:	89 c3                	mov    %eax,%ebx
  801968:	83 c4 10             	add    $0x10,%esp
}
  80196b:	89 d8                	mov    %ebx,%eax
  80196d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    
		fd_close(fd, 0);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	6a 00                	push   $0x0
  801979:	ff 75 f4             	pushl  -0xc(%ebp)
  80197c:	e8 1b f9 ff ff       	call   80129c <fd_close>
		return r;
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	eb e5                	jmp    80196b <open+0x6c>
		return -E_BAD_PATH;
  801986:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80198b:	eb de                	jmp    80196b <open+0x6c>

0080198d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801993:	ba 00 00 00 00       	mov    $0x0,%edx
  801998:	b8 08 00 00 00       	mov    $0x8,%eax
  80199d:	e8 68 fd ff ff       	call   80170a <fsipc>
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019a4:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019a8:	7f 01                	jg     8019ab <writebuf+0x7>
  8019aa:	c3                   	ret    
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 08             	sub    $0x8,%esp
  8019b2:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019b4:	ff 70 04             	pushl  0x4(%eax)
  8019b7:	8d 40 10             	lea    0x10(%eax),%eax
  8019ba:	50                   	push   %eax
  8019bb:	ff 33                	pushl  (%ebx)
  8019bd:	e8 6b fb ff ff       	call   80152d <write>
		if (result > 0)
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	7e 03                	jle    8019cc <writebuf+0x28>
			b->result += result;
  8019c9:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019cc:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019cf:	74 0d                	je     8019de <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d8:	0f 4f c2             	cmovg  %edx,%eax
  8019db:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <putch>:

static void
putch(int ch, void *thunk)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019ed:	8b 53 04             	mov    0x4(%ebx),%edx
  8019f0:	8d 42 01             	lea    0x1(%edx),%eax
  8019f3:	89 43 04             	mov    %eax,0x4(%ebx)
  8019f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f9:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019fd:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a02:	74 06                	je     801a0a <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a04:	83 c4 04             	add    $0x4,%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
		writebuf(b);
  801a0a:	89 d8                	mov    %ebx,%eax
  801a0c:	e8 93 ff ff ff       	call   8019a4 <writebuf>
		b->idx = 0;
  801a11:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a18:	eb ea                	jmp    801a04 <putch+0x21>

00801a1a <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a2c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a33:	00 00 00 
	b.result = 0;
  801a36:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a3d:	00 00 00 
	b.error = 1;
  801a40:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a47:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a4a:	ff 75 10             	pushl  0x10(%ebp)
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a56:	50                   	push   %eax
  801a57:	68 e3 19 80 00       	push   $0x8019e3
  801a5c:	e8 fe e9 ff ff       	call   80045f <vprintfmt>
	if (b.idx > 0)
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a6b:	7f 11                	jg     801a7e <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a6d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a73:	85 c0                	test   %eax,%eax
  801a75:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    
		writebuf(&b);
  801a7e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a84:	e8 1b ff ff ff       	call   8019a4 <writebuf>
  801a89:	eb e2                	jmp    801a6d <vfprintf+0x53>

00801a8b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a91:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a94:	50                   	push   %eax
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	ff 75 08             	pushl  0x8(%ebp)
  801a9b:	e8 7a ff ff ff       	call   801a1a <vfprintf>
	va_end(ap);

	return cnt;
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <printf>:

int
printf(const char *fmt, ...)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801aab:	50                   	push   %eax
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 01                	push   $0x1
  801ab1:	e8 64 ff ff ff       	call   801a1a <vfprintf>
	va_end(ap);

	return cnt;
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801abe:	68 fb 2c 80 00       	push   $0x802cfb
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	e8 c6 ef ff ff       	call   800a91 <strcpy>
	return 0;
}
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <devsock_close>:
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 10             	sub    $0x10,%esp
  801ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801adc:	53                   	push   %ebx
  801add:	e8 00 0a 00 00       	call   8024e2 <pageref>
  801ae2:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ae5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801aea:	83 f8 01             	cmp    $0x1,%eax
  801aed:	74 07                	je     801af6 <devsock_close+0x24>
}
  801aef:	89 d0                	mov    %edx,%eax
  801af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801af6:	83 ec 0c             	sub    $0xc,%esp
  801af9:	ff 73 0c             	pushl  0xc(%ebx)
  801afc:	e8 b9 02 00 00       	call   801dba <nsipc_close>
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	eb e7                	jmp    801aef <devsock_close+0x1d>

00801b08 <devsock_write>:
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 10             	pushl  0x10(%ebp)
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	ff 70 0c             	pushl  0xc(%eax)
  801b1c:	e8 76 03 00 00       	call   801e97 <nsipc_send>
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <devsock_read>:
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 10             	pushl  0x10(%ebp)
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	ff 70 0c             	pushl  0xc(%eax)
  801b37:	e8 ef 02 00 00       	call   801e2b <nsipc_recv>
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <fd2sockid>:
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b44:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b47:	52                   	push   %edx
  801b48:	50                   	push   %eax
  801b49:	e8 a3 f6 ff ff       	call   8011f1 <fd_lookup>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 10                	js     801b65 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b58:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b5e:	39 08                	cmp    %ecx,(%eax)
  801b60:	75 05                	jne    801b67 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b62:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    
		return -E_NOT_SUPP;
  801b67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6c:	eb f7                	jmp    801b65 <fd2sockid+0x27>

00801b6e <alloc_sockfd>:
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	83 ec 1c             	sub    $0x1c,%esp
  801b76:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7b:	50                   	push   %eax
  801b7c:	e8 1e f6 ff ff       	call   80119f <fd_alloc>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 43                	js     801bcd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	68 07 04 00 00       	push   $0x407
  801b92:	ff 75 f4             	pushl  -0xc(%ebp)
  801b95:	6a 00                	push   $0x0
  801b97:	e8 e7 f2 ff ff       	call   800e83 <sys_page_alloc>
  801b9c:	89 c3                	mov    %eax,%ebx
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	78 28                	js     801bcd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bae:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bba:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	50                   	push   %eax
  801bc1:	e8 b2 f5 ff ff       	call   801178 <fd2num>
  801bc6:	89 c3                	mov    %eax,%ebx
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	eb 0c                	jmp    801bd9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bcd:	83 ec 0c             	sub    $0xc,%esp
  801bd0:	56                   	push   %esi
  801bd1:	e8 e4 01 00 00       	call   801dba <nsipc_close>
		return r;
  801bd6:	83 c4 10             	add    $0x10,%esp
}
  801bd9:	89 d8                	mov    %ebx,%eax
  801bdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5d                   	pop    %ebp
  801be1:	c3                   	ret    

00801be2 <accept>:
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	e8 4e ff ff ff       	call   801b3e <fd2sockid>
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 1b                	js     801c0f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	ff 75 10             	pushl  0x10(%ebp)
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	50                   	push   %eax
  801bfe:	e8 0e 01 00 00       	call   801d11 <nsipc_accept>
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 05                	js     801c0f <accept+0x2d>
	return alloc_sockfd(r);
  801c0a:	e8 5f ff ff ff       	call   801b6e <alloc_sockfd>
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <bind>:
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	e8 1f ff ff ff       	call   801b3e <fd2sockid>
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 12                	js     801c35 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	ff 75 10             	pushl  0x10(%ebp)
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	50                   	push   %eax
  801c2d:	e8 31 01 00 00       	call   801d63 <nsipc_bind>
  801c32:	83 c4 10             	add    $0x10,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <shutdown>:
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	e8 f9 fe ff ff       	call   801b3e <fd2sockid>
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 0f                	js     801c58 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	50                   	push   %eax
  801c50:	e8 43 01 00 00       	call   801d98 <nsipc_shutdown>
  801c55:	83 c4 10             	add    $0x10,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <connect>:
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	e8 d6 fe ff ff       	call   801b3e <fd2sockid>
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	78 12                	js     801c7e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	ff 75 10             	pushl  0x10(%ebp)
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	50                   	push   %eax
  801c76:	e8 59 01 00 00       	call   801dd4 <nsipc_connect>
  801c7b:	83 c4 10             	add    $0x10,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <listen>:
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	e8 b0 fe ff ff       	call   801b3e <fd2sockid>
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 0f                	js     801ca1 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c92:	83 ec 08             	sub    $0x8,%esp
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	50                   	push   %eax
  801c99:	e8 6b 01 00 00       	call   801e09 <nsipc_listen>
  801c9e:	83 c4 10             	add    $0x10,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ca9:	ff 75 10             	pushl  0x10(%ebp)
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	ff 75 08             	pushl  0x8(%ebp)
  801cb2:	e8 3e 02 00 00       	call   801ef5 <nsipc_socket>
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 05                	js     801cc3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cbe:	e8 ab fe ff ff       	call   801b6e <alloc_sockfd>
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	53                   	push   %ebx
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cce:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801cd5:	74 26                	je     801cfd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cd7:	6a 07                	push   $0x7
  801cd9:	68 00 80 80 00       	push   $0x808000
  801cde:	53                   	push   %ebx
  801cdf:	ff 35 04 40 80 00    	pushl  0x804004
  801ce5:	e8 61 07 00 00       	call   80244b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cea:	83 c4 0c             	add    $0xc,%esp
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	e8 ea 06 00 00       	call   8023e2 <ipc_recv>
}
  801cf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	6a 02                	push   $0x2
  801d02:	e8 9c 07 00 00       	call   8024a3 <ipc_find_env>
  801d07:	a3 04 40 80 00       	mov    %eax,0x804004
  801d0c:	83 c4 10             	add    $0x10,%esp
  801d0f:	eb c6                	jmp    801cd7 <nsipc+0x12>

00801d11 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	56                   	push   %esi
  801d15:	53                   	push   %ebx
  801d16:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d21:	8b 06                	mov    (%esi),%eax
  801d23:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d28:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2d:	e8 93 ff ff ff       	call   801cc5 <nsipc>
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	85 c0                	test   %eax,%eax
  801d36:	79 09                	jns    801d41 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3d:	5b                   	pop    %ebx
  801d3e:	5e                   	pop    %esi
  801d3f:	5d                   	pop    %ebp
  801d40:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	ff 35 10 80 80 00    	pushl  0x808010
  801d4a:	68 00 80 80 00       	push   $0x808000
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	e8 c8 ee ff ff       	call   800c1f <memmove>
		*addrlen = ret->ret_addrlen;
  801d57:	a1 10 80 80 00       	mov    0x808010,%eax
  801d5c:	89 06                	mov    %eax,(%esi)
  801d5e:	83 c4 10             	add    $0x10,%esp
	return r;
  801d61:	eb d5                	jmp    801d38 <nsipc_accept+0x27>

00801d63 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 08             	sub    $0x8,%esp
  801d6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d75:	53                   	push   %ebx
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	68 04 80 80 00       	push   $0x808004
  801d7e:	e8 9c ee ff ff       	call   800c1f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d83:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801d89:	b8 02 00 00 00       	mov    $0x2,%eax
  801d8e:	e8 32 ff ff ff       	call   801cc5 <nsipc>
}
  801d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801dae:	b8 03 00 00 00       	mov    $0x3,%eax
  801db3:	e8 0d ff ff ff       	call   801cc5 <nsipc>
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <nsipc_close>:

int
nsipc_close(int s)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801dc8:	b8 04 00 00 00       	mov    $0x4,%eax
  801dcd:	e8 f3 fe ff ff       	call   801cc5 <nsipc>
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801de6:	53                   	push   %ebx
  801de7:	ff 75 0c             	pushl  0xc(%ebp)
  801dea:	68 04 80 80 00       	push   $0x808004
  801def:	e8 2b ee ff ff       	call   800c1f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801df4:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801dfa:	b8 05 00 00 00       	mov    $0x5,%eax
  801dff:	e8 c1 fe ff ff       	call   801cc5 <nsipc>
}
  801e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801e1f:	b8 06 00 00 00       	mov    $0x6,%eax
  801e24:	e8 9c fe ff ff       	call   801cc5 <nsipc>
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801e3b:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801e41:	8b 45 14             	mov    0x14(%ebp),%eax
  801e44:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e49:	b8 07 00 00 00       	mov    $0x7,%eax
  801e4e:	e8 72 fe ff ff       	call   801cc5 <nsipc>
  801e53:	89 c3                	mov    %eax,%ebx
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 1f                	js     801e78 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e59:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e5e:	7f 21                	jg     801e81 <nsipc_recv+0x56>
  801e60:	39 c6                	cmp    %eax,%esi
  801e62:	7c 1d                	jl     801e81 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	50                   	push   %eax
  801e68:	68 00 80 80 00       	push   $0x808000
  801e6d:	ff 75 0c             	pushl  0xc(%ebp)
  801e70:	e8 aa ed ff ff       	call   800c1f <memmove>
  801e75:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e78:	89 d8                	mov    %ebx,%eax
  801e7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5e                   	pop    %esi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e81:	68 07 2d 80 00       	push   $0x802d07
  801e86:	68 cf 2c 80 00       	push   $0x802ccf
  801e8b:	6a 62                	push   $0x62
  801e8d:	68 1c 2d 80 00       	push   $0x802d1c
  801e92:	e8 a5 e3 ff ff       	call   80023c <_panic>

00801e97 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801ea9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801eaf:	7f 2e                	jg     801edf <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	53                   	push   %ebx
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	68 0c 80 80 00       	push   $0x80800c
  801ebd:	e8 5d ed ff ff       	call   800c1f <memmove>
	nsipcbuf.send.req_size = size;
  801ec2:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801ec8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecb:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801ed0:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed5:	e8 eb fd ff ff       	call   801cc5 <nsipc>
}
  801eda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    
	assert(size < 1600);
  801edf:	68 28 2d 80 00       	push   $0x802d28
  801ee4:	68 cf 2c 80 00       	push   $0x802ccf
  801ee9:	6a 6d                	push   $0x6d
  801eeb:	68 1c 2d 80 00       	push   $0x802d1c
  801ef0:	e8 47 e3 ff ff       	call   80023c <_panic>

00801ef5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f06:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801f13:	b8 09 00 00 00       	mov    $0x9,%eax
  801f18:	e8 a8 fd ff ff       	call   801cc5 <nsipc>
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	e8 56 f2 ff ff       	call   801188 <fd2data>
  801f32:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f34:	83 c4 08             	add    $0x8,%esp
  801f37:	68 34 2d 80 00       	push   $0x802d34
  801f3c:	53                   	push   %ebx
  801f3d:	e8 4f eb ff ff       	call   800a91 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f42:	8b 46 04             	mov    0x4(%esi),%eax
  801f45:	2b 06                	sub    (%esi),%eax
  801f47:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f4d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f54:	00 00 00 
	stat->st_dev = &devpipe;
  801f57:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f5e:	30 80 00 
	return 0;
}
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f69:	5b                   	pop    %ebx
  801f6a:	5e                   	pop    %esi
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    

00801f6d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	53                   	push   %ebx
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f77:	53                   	push   %ebx
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 89 ef ff ff       	call   800f08 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f7f:	89 1c 24             	mov    %ebx,(%esp)
  801f82:	e8 01 f2 ff ff       	call   801188 <fd2data>
  801f87:	83 c4 08             	add    $0x8,%esp
  801f8a:	50                   	push   %eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	e8 76 ef ff ff       	call   800f08 <sys_page_unmap>
}
  801f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <_pipeisclosed>:
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	57                   	push   %edi
  801f9b:	56                   	push   %esi
  801f9c:	53                   	push   %ebx
  801f9d:	83 ec 1c             	sub    $0x1c,%esp
  801fa0:	89 c7                	mov    %eax,%edi
  801fa2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fa4:	a1 20 60 80 00       	mov    0x806020,%eax
  801fa9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	57                   	push   %edi
  801fb0:	e8 2d 05 00 00       	call   8024e2 <pageref>
  801fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fb8:	89 34 24             	mov    %esi,(%esp)
  801fbb:	e8 22 05 00 00       	call   8024e2 <pageref>
		nn = thisenv->env_runs;
  801fc0:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801fc6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fc9:	83 c4 10             	add    $0x10,%esp
  801fcc:	39 cb                	cmp    %ecx,%ebx
  801fce:	74 1b                	je     801feb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fd0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fd3:	75 cf                	jne    801fa4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fd5:	8b 42 58             	mov    0x58(%edx),%eax
  801fd8:	6a 01                	push   $0x1
  801fda:	50                   	push   %eax
  801fdb:	53                   	push   %ebx
  801fdc:	68 3b 2d 80 00       	push   $0x802d3b
  801fe1:	e8 4c e3 ff ff       	call   800332 <cprintf>
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	eb b9                	jmp    801fa4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801feb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fee:	0f 94 c0             	sete   %al
  801ff1:	0f b6 c0             	movzbl %al,%eax
}
  801ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5f                   	pop    %edi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    

00801ffc <devpipe_write>:
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	57                   	push   %edi
  802000:	56                   	push   %esi
  802001:	53                   	push   %ebx
  802002:	83 ec 28             	sub    $0x28,%esp
  802005:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802008:	56                   	push   %esi
  802009:	e8 7a f1 ff ff       	call   801188 <fd2data>
  80200e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	bf 00 00 00 00       	mov    $0x0,%edi
  802018:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80201b:	74 4f                	je     80206c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80201d:	8b 43 04             	mov    0x4(%ebx),%eax
  802020:	8b 0b                	mov    (%ebx),%ecx
  802022:	8d 51 20             	lea    0x20(%ecx),%edx
  802025:	39 d0                	cmp    %edx,%eax
  802027:	72 14                	jb     80203d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802029:	89 da                	mov    %ebx,%edx
  80202b:	89 f0                	mov    %esi,%eax
  80202d:	e8 65 ff ff ff       	call   801f97 <_pipeisclosed>
  802032:	85 c0                	test   %eax,%eax
  802034:	75 3b                	jne    802071 <devpipe_write+0x75>
			sys_yield();
  802036:	e8 29 ee ff ff       	call   800e64 <sys_yield>
  80203b:	eb e0                	jmp    80201d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80203d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802040:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802044:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802047:	89 c2                	mov    %eax,%edx
  802049:	c1 fa 1f             	sar    $0x1f,%edx
  80204c:	89 d1                	mov    %edx,%ecx
  80204e:	c1 e9 1b             	shr    $0x1b,%ecx
  802051:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802054:	83 e2 1f             	and    $0x1f,%edx
  802057:	29 ca                	sub    %ecx,%edx
  802059:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80205d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802061:	83 c0 01             	add    $0x1,%eax
  802064:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802067:	83 c7 01             	add    $0x1,%edi
  80206a:	eb ac                	jmp    802018 <devpipe_write+0x1c>
	return i;
  80206c:	8b 45 10             	mov    0x10(%ebp),%eax
  80206f:	eb 05                	jmp    802076 <devpipe_write+0x7a>
				return 0;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5f                   	pop    %edi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <devpipe_read>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 18             	sub    $0x18,%esp
  802087:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80208a:	57                   	push   %edi
  80208b:	e8 f8 f0 ff ff       	call   801188 <fd2data>
  802090:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	be 00 00 00 00       	mov    $0x0,%esi
  80209a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80209d:	75 14                	jne    8020b3 <devpipe_read+0x35>
	return i;
  80209f:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a2:	eb 02                	jmp    8020a6 <devpipe_read+0x28>
				return i;
  8020a4:	89 f0                	mov    %esi,%eax
}
  8020a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a9:	5b                   	pop    %ebx
  8020aa:	5e                   	pop    %esi
  8020ab:	5f                   	pop    %edi
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    
			sys_yield();
  8020ae:	e8 b1 ed ff ff       	call   800e64 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020b3:	8b 03                	mov    (%ebx),%eax
  8020b5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020b8:	75 18                	jne    8020d2 <devpipe_read+0x54>
			if (i > 0)
  8020ba:	85 f6                	test   %esi,%esi
  8020bc:	75 e6                	jne    8020a4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8020be:	89 da                	mov    %ebx,%edx
  8020c0:	89 f8                	mov    %edi,%eax
  8020c2:	e8 d0 fe ff ff       	call   801f97 <_pipeisclosed>
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	74 e3                	je     8020ae <devpipe_read+0x30>
				return 0;
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	eb d4                	jmp    8020a6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020d2:	99                   	cltd   
  8020d3:	c1 ea 1b             	shr    $0x1b,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	83 e0 1f             	and    $0x1f,%eax
  8020db:	29 d0                	sub    %edx,%eax
  8020dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020e8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020eb:	83 c6 01             	add    $0x1,%esi
  8020ee:	eb aa                	jmp    80209a <devpipe_read+0x1c>

008020f0 <pipe>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	56                   	push   %esi
  8020f4:	53                   	push   %ebx
  8020f5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fb:	50                   	push   %eax
  8020fc:	e8 9e f0 ff ff       	call   80119f <fd_alloc>
  802101:	89 c3                	mov    %eax,%ebx
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	0f 88 23 01 00 00    	js     802231 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	68 07 04 00 00       	push   $0x407
  802116:	ff 75 f4             	pushl  -0xc(%ebp)
  802119:	6a 00                	push   $0x0
  80211b:	e8 63 ed ff ff       	call   800e83 <sys_page_alloc>
  802120:	89 c3                	mov    %eax,%ebx
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 88 04 01 00 00    	js     802231 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802133:	50                   	push   %eax
  802134:	e8 66 f0 ff ff       	call   80119f <fd_alloc>
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	85 c0                	test   %eax,%eax
  802140:	0f 88 db 00 00 00    	js     802221 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802146:	83 ec 04             	sub    $0x4,%esp
  802149:	68 07 04 00 00       	push   $0x407
  80214e:	ff 75 f0             	pushl  -0x10(%ebp)
  802151:	6a 00                	push   $0x0
  802153:	e8 2b ed ff ff       	call   800e83 <sys_page_alloc>
  802158:	89 c3                	mov    %eax,%ebx
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	85 c0                	test   %eax,%eax
  80215f:	0f 88 bc 00 00 00    	js     802221 <pipe+0x131>
	va = fd2data(fd0);
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	ff 75 f4             	pushl  -0xc(%ebp)
  80216b:	e8 18 f0 ff ff       	call   801188 <fd2data>
  802170:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802172:	83 c4 0c             	add    $0xc,%esp
  802175:	68 07 04 00 00       	push   $0x407
  80217a:	50                   	push   %eax
  80217b:	6a 00                	push   $0x0
  80217d:	e8 01 ed ff ff       	call   800e83 <sys_page_alloc>
  802182:	89 c3                	mov    %eax,%ebx
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	85 c0                	test   %eax,%eax
  802189:	0f 88 82 00 00 00    	js     802211 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	ff 75 f0             	pushl  -0x10(%ebp)
  802195:	e8 ee ef ff ff       	call   801188 <fd2data>
  80219a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021a1:	50                   	push   %eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	56                   	push   %esi
  8021a5:	6a 00                	push   $0x0
  8021a7:	e8 1a ed ff ff       	call   800ec6 <sys_page_map>
  8021ac:	89 c3                	mov    %eax,%ebx
  8021ae:	83 c4 20             	add    $0x20,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	78 4e                	js     802203 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8021b5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8021ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021cc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	ff 75 f4             	pushl  -0xc(%ebp)
  8021de:	e8 95 ef ff ff       	call   801178 <fd2num>
  8021e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021e8:	83 c4 04             	add    $0x4,%esp
  8021eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ee:	e8 85 ef ff ff       	call   801178 <fd2num>
  8021f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  802201:	eb 2e                	jmp    802231 <pipe+0x141>
	sys_page_unmap(0, va);
  802203:	83 ec 08             	sub    $0x8,%esp
  802206:	56                   	push   %esi
  802207:	6a 00                	push   $0x0
  802209:	e8 fa ec ff ff       	call   800f08 <sys_page_unmap>
  80220e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802211:	83 ec 08             	sub    $0x8,%esp
  802214:	ff 75 f0             	pushl  -0x10(%ebp)
  802217:	6a 00                	push   $0x0
  802219:	e8 ea ec ff ff       	call   800f08 <sys_page_unmap>
  80221e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802221:	83 ec 08             	sub    $0x8,%esp
  802224:	ff 75 f4             	pushl  -0xc(%ebp)
  802227:	6a 00                	push   $0x0
  802229:	e8 da ec ff ff       	call   800f08 <sys_page_unmap>
  80222e:	83 c4 10             	add    $0x10,%esp
}
  802231:	89 d8                	mov    %ebx,%eax
  802233:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802236:	5b                   	pop    %ebx
  802237:	5e                   	pop    %esi
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    

0080223a <pipeisclosed>:
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802240:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802243:	50                   	push   %eax
  802244:	ff 75 08             	pushl  0x8(%ebp)
  802247:	e8 a5 ef ff ff       	call   8011f1 <fd_lookup>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 18                	js     80226b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	ff 75 f4             	pushl  -0xc(%ebp)
  802259:	e8 2a ef ff ff       	call   801188 <fd2data>
	return _pipeisclosed(fd, p);
  80225e:	89 c2                	mov    %eax,%edx
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	e8 2f fd ff ff       	call   801f97 <_pipeisclosed>
  802268:	83 c4 10             	add    $0x10,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
  802272:	c3                   	ret    

00802273 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802279:	68 53 2d 80 00       	push   $0x802d53
  80227e:	ff 75 0c             	pushl  0xc(%ebp)
  802281:	e8 0b e8 ff ff       	call   800a91 <strcpy>
	return 0;
}
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <devcons_write>:
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	57                   	push   %edi
  802291:	56                   	push   %esi
  802292:	53                   	push   %ebx
  802293:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802299:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80229e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a7:	73 31                	jae    8022da <devcons_write+0x4d>
		m = n - tot;
  8022a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ac:	29 f3                	sub    %esi,%ebx
  8022ae:	83 fb 7f             	cmp    $0x7f,%ebx
  8022b1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022b6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	53                   	push   %ebx
  8022bd:	89 f0                	mov    %esi,%eax
  8022bf:	03 45 0c             	add    0xc(%ebp),%eax
  8022c2:	50                   	push   %eax
  8022c3:	57                   	push   %edi
  8022c4:	e8 56 e9 ff ff       	call   800c1f <memmove>
		sys_cputs(buf, m);
  8022c9:	83 c4 08             	add    $0x8,%esp
  8022cc:	53                   	push   %ebx
  8022cd:	57                   	push   %edi
  8022ce:	e8 f4 ea ff ff       	call   800dc7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022d3:	01 de                	add    %ebx,%esi
  8022d5:	83 c4 10             	add    $0x10,%esp
  8022d8:	eb ca                	jmp    8022a4 <devcons_write+0x17>
}
  8022da:	89 f0                	mov    %esi,%eax
  8022dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    

008022e4 <devcons_read>:
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 08             	sub    $0x8,%esp
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f3:	74 21                	je     802316 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022f5:	e8 eb ea ff ff       	call   800de5 <sys_cgetc>
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	75 07                	jne    802305 <devcons_read+0x21>
		sys_yield();
  8022fe:	e8 61 eb ff ff       	call   800e64 <sys_yield>
  802303:	eb f0                	jmp    8022f5 <devcons_read+0x11>
	if (c < 0)
  802305:	78 0f                	js     802316 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802307:	83 f8 04             	cmp    $0x4,%eax
  80230a:	74 0c                	je     802318 <devcons_read+0x34>
	*(char*)vbuf = c;
  80230c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230f:	88 02                	mov    %al,(%edx)
	return 1;
  802311:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    
		return 0;
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
  80231d:	eb f7                	jmp    802316 <devcons_read+0x32>

0080231f <cputchar>:
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80232b:	6a 01                	push   $0x1
  80232d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802330:	50                   	push   %eax
  802331:	e8 91 ea ff ff       	call   800dc7 <sys_cputs>
}
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <getchar>:
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802341:	6a 01                	push   $0x1
  802343:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802346:	50                   	push   %eax
  802347:	6a 00                	push   $0x0
  802349:	e8 13 f1 ff ff       	call   801461 <read>
	if (r < 0)
  80234e:	83 c4 10             	add    $0x10,%esp
  802351:	85 c0                	test   %eax,%eax
  802353:	78 06                	js     80235b <getchar+0x20>
	if (r < 1)
  802355:	74 06                	je     80235d <getchar+0x22>
	return c;
  802357:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    
		return -E_EOF;
  80235d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802362:	eb f7                	jmp    80235b <getchar+0x20>

00802364 <iscons>:
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80236a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236d:	50                   	push   %eax
  80236e:	ff 75 08             	pushl  0x8(%ebp)
  802371:	e8 7b ee ff ff       	call   8011f1 <fd_lookup>
  802376:	83 c4 10             	add    $0x10,%esp
  802379:	85 c0                	test   %eax,%eax
  80237b:	78 11                	js     80238e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802386:	39 10                	cmp    %edx,(%eax)
  802388:	0f 94 c0             	sete   %al
  80238b:	0f b6 c0             	movzbl %al,%eax
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <opencons>:
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802396:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802399:	50                   	push   %eax
  80239a:	e8 00 ee ff ff       	call   80119f <fd_alloc>
  80239f:	83 c4 10             	add    $0x10,%esp
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	78 3a                	js     8023e0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 07 04 00 00       	push   $0x407
  8023ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b1:	6a 00                	push   $0x0
  8023b3:	e8 cb ea ff ff       	call   800e83 <sys_page_alloc>
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	78 21                	js     8023e0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023d4:	83 ec 0c             	sub    $0xc,%esp
  8023d7:	50                   	push   %eax
  8023d8:	e8 9b ed ff ff       	call   801178 <fd2num>
  8023dd:	83 c4 10             	add    $0x10,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	56                   	push   %esi
  8023e6:	53                   	push   %ebx
  8023e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8023ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8023f0:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023f2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023f7:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023fa:	83 ec 0c             	sub    $0xc,%esp
  8023fd:	50                   	push   %eax
  8023fe:	e8 30 ec ff ff       	call   801033 <sys_ipc_recv>
	if(ret < 0){
  802403:	83 c4 10             	add    $0x10,%esp
  802406:	85 c0                	test   %eax,%eax
  802408:	78 2b                	js     802435 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80240a:	85 f6                	test   %esi,%esi
  80240c:	74 0a                	je     802418 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80240e:	a1 20 60 80 00       	mov    0x806020,%eax
  802413:	8b 40 78             	mov    0x78(%eax),%eax
  802416:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802418:	85 db                	test   %ebx,%ebx
  80241a:	74 0a                	je     802426 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80241c:	a1 20 60 80 00       	mov    0x806020,%eax
  802421:	8b 40 7c             	mov    0x7c(%eax),%eax
  802424:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802426:	a1 20 60 80 00       	mov    0x806020,%eax
  80242b:	8b 40 74             	mov    0x74(%eax),%eax
}
  80242e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    
		if(from_env_store)
  802435:	85 f6                	test   %esi,%esi
  802437:	74 06                	je     80243f <ipc_recv+0x5d>
			*from_env_store = 0;
  802439:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80243f:	85 db                	test   %ebx,%ebx
  802441:	74 eb                	je     80242e <ipc_recv+0x4c>
			*perm_store = 0;
  802443:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802449:	eb e3                	jmp    80242e <ipc_recv+0x4c>

0080244b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	57                   	push   %edi
  80244f:	56                   	push   %esi
  802450:	53                   	push   %ebx
  802451:	83 ec 0c             	sub    $0xc,%esp
  802454:	8b 7d 08             	mov    0x8(%ebp),%edi
  802457:	8b 75 0c             	mov    0xc(%ebp),%esi
  80245a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80245d:	85 db                	test   %ebx,%ebx
  80245f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802464:	0f 44 d8             	cmove  %eax,%ebx
  802467:	eb 05                	jmp    80246e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802469:	e8 f6 e9 ff ff       	call   800e64 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80246e:	ff 75 14             	pushl  0x14(%ebp)
  802471:	53                   	push   %ebx
  802472:	56                   	push   %esi
  802473:	57                   	push   %edi
  802474:	e8 97 eb ff ff       	call   801010 <sys_ipc_try_send>
  802479:	83 c4 10             	add    $0x10,%esp
  80247c:	85 c0                	test   %eax,%eax
  80247e:	74 1b                	je     80249b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802480:	79 e7                	jns    802469 <ipc_send+0x1e>
  802482:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802485:	74 e2                	je     802469 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	68 5f 2d 80 00       	push   $0x802d5f
  80248f:	6a 46                	push   $0x46
  802491:	68 74 2d 80 00       	push   $0x802d74
  802496:	e8 a1 dd ff ff       	call   80023c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80249b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249e:	5b                   	pop    %ebx
  80249f:	5e                   	pop    %esi
  8024a0:	5f                   	pop    %edi
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    

008024a3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024a9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024ae:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8024b4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024ba:	8b 52 50             	mov    0x50(%edx),%edx
  8024bd:	39 ca                	cmp    %ecx,%edx
  8024bf:	74 11                	je     8024d2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8024c1:	83 c0 01             	add    $0x1,%eax
  8024c4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024c9:	75 e3                	jne    8024ae <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d0:	eb 0e                	jmp    8024e0 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8024d2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8024d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024dd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    

008024e2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024e8:	89 d0                	mov    %edx,%eax
  8024ea:	c1 e8 16             	shr    $0x16,%eax
  8024ed:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024f9:	f6 c1 01             	test   $0x1,%cl
  8024fc:	74 1d                	je     80251b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024fe:	c1 ea 0c             	shr    $0xc,%edx
  802501:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802508:	f6 c2 01             	test   $0x1,%dl
  80250b:	74 0e                	je     80251b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80250d:	c1 ea 0c             	shr    $0xc,%edx
  802510:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802517:	ef 
  802518:	0f b7 c0             	movzwl %ax,%eax
}
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	66 90                	xchg   %ax,%ax
  80251f:	90                   	nop

00802520 <__udivdi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80252b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80252f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802533:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802537:	85 d2                	test   %edx,%edx
  802539:	75 4d                	jne    802588 <__udivdi3+0x68>
  80253b:	39 f3                	cmp    %esi,%ebx
  80253d:	76 19                	jbe    802558 <__udivdi3+0x38>
  80253f:	31 ff                	xor    %edi,%edi
  802541:	89 e8                	mov    %ebp,%eax
  802543:	89 f2                	mov    %esi,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 fa                	mov    %edi,%edx
  802549:	83 c4 1c             	add    $0x1c,%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5f                   	pop    %edi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 d9                	mov    %ebx,%ecx
  80255a:	85 db                	test   %ebx,%ebx
  80255c:	75 0b                	jne    802569 <__udivdi3+0x49>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f3                	div    %ebx
  802567:	89 c1                	mov    %eax,%ecx
  802569:	31 d2                	xor    %edx,%edx
  80256b:	89 f0                	mov    %esi,%eax
  80256d:	f7 f1                	div    %ecx
  80256f:	89 c6                	mov    %eax,%esi
  802571:	89 e8                	mov    %ebp,%eax
  802573:	89 f7                	mov    %esi,%edi
  802575:	f7 f1                	div    %ecx
  802577:	89 fa                	mov    %edi,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	39 f2                	cmp    %esi,%edx
  80258a:	77 1c                	ja     8025a8 <__udivdi3+0x88>
  80258c:	0f bd fa             	bsr    %edx,%edi
  80258f:	83 f7 1f             	xor    $0x1f,%edi
  802592:	75 2c                	jne    8025c0 <__udivdi3+0xa0>
  802594:	39 f2                	cmp    %esi,%edx
  802596:	72 06                	jb     80259e <__udivdi3+0x7e>
  802598:	31 c0                	xor    %eax,%eax
  80259a:	39 eb                	cmp    %ebp,%ebx
  80259c:	77 a9                	ja     802547 <__udivdi3+0x27>
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	eb a2                	jmp    802547 <__udivdi3+0x27>
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	31 ff                	xor    %edi,%edi
  8025aa:	31 c0                	xor    %eax,%eax
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025bd:	8d 76 00             	lea    0x0(%esi),%esi
  8025c0:	89 f9                	mov    %edi,%ecx
  8025c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025c7:	29 f8                	sub    %edi,%eax
  8025c9:	d3 e2                	shl    %cl,%edx
  8025cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025cf:	89 c1                	mov    %eax,%ecx
  8025d1:	89 da                	mov    %ebx,%edx
  8025d3:	d3 ea                	shr    %cl,%edx
  8025d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025d9:	09 d1                	or     %edx,%ecx
  8025db:	89 f2                	mov    %esi,%edx
  8025dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e1:	89 f9                	mov    %edi,%ecx
  8025e3:	d3 e3                	shl    %cl,%ebx
  8025e5:	89 c1                	mov    %eax,%ecx
  8025e7:	d3 ea                	shr    %cl,%edx
  8025e9:	89 f9                	mov    %edi,%ecx
  8025eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025ef:	89 eb                	mov    %ebp,%ebx
  8025f1:	d3 e6                	shl    %cl,%esi
  8025f3:	89 c1                	mov    %eax,%ecx
  8025f5:	d3 eb                	shr    %cl,%ebx
  8025f7:	09 de                	or     %ebx,%esi
  8025f9:	89 f0                	mov    %esi,%eax
  8025fb:	f7 74 24 08          	divl   0x8(%esp)
  8025ff:	89 d6                	mov    %edx,%esi
  802601:	89 c3                	mov    %eax,%ebx
  802603:	f7 64 24 0c          	mull   0xc(%esp)
  802607:	39 d6                	cmp    %edx,%esi
  802609:	72 15                	jb     802620 <__udivdi3+0x100>
  80260b:	89 f9                	mov    %edi,%ecx
  80260d:	d3 e5                	shl    %cl,%ebp
  80260f:	39 c5                	cmp    %eax,%ebp
  802611:	73 04                	jae    802617 <__udivdi3+0xf7>
  802613:	39 d6                	cmp    %edx,%esi
  802615:	74 09                	je     802620 <__udivdi3+0x100>
  802617:	89 d8                	mov    %ebx,%eax
  802619:	31 ff                	xor    %edi,%edi
  80261b:	e9 27 ff ff ff       	jmp    802547 <__udivdi3+0x27>
  802620:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802623:	31 ff                	xor    %edi,%edi
  802625:	e9 1d ff ff ff       	jmp    802547 <__udivdi3+0x27>
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80263b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80263f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802647:	89 da                	mov    %ebx,%edx
  802649:	85 c0                	test   %eax,%eax
  80264b:	75 43                	jne    802690 <__umoddi3+0x60>
  80264d:	39 df                	cmp    %ebx,%edi
  80264f:	76 17                	jbe    802668 <__umoddi3+0x38>
  802651:	89 f0                	mov    %esi,%eax
  802653:	f7 f7                	div    %edi
  802655:	89 d0                	mov    %edx,%eax
  802657:	31 d2                	xor    %edx,%edx
  802659:	83 c4 1c             	add    $0x1c,%esp
  80265c:	5b                   	pop    %ebx
  80265d:	5e                   	pop    %esi
  80265e:	5f                   	pop    %edi
  80265f:	5d                   	pop    %ebp
  802660:	c3                   	ret    
  802661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802668:	89 fd                	mov    %edi,%ebp
  80266a:	85 ff                	test   %edi,%edi
  80266c:	75 0b                	jne    802679 <__umoddi3+0x49>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f7                	div    %edi
  802677:	89 c5                	mov    %eax,%ebp
  802679:	89 d8                	mov    %ebx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f5                	div    %ebp
  80267f:	89 f0                	mov    %esi,%eax
  802681:	f7 f5                	div    %ebp
  802683:	89 d0                	mov    %edx,%eax
  802685:	eb d0                	jmp    802657 <__umoddi3+0x27>
  802687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80268e:	66 90                	xchg   %ax,%ax
  802690:	89 f1                	mov    %esi,%ecx
  802692:	39 d8                	cmp    %ebx,%eax
  802694:	76 0a                	jbe    8026a0 <__umoddi3+0x70>
  802696:	89 f0                	mov    %esi,%eax
  802698:	83 c4 1c             	add    $0x1c,%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5e                   	pop    %esi
  80269d:	5f                   	pop    %edi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    
  8026a0:	0f bd e8             	bsr    %eax,%ebp
  8026a3:	83 f5 1f             	xor    $0x1f,%ebp
  8026a6:	75 20                	jne    8026c8 <__umoddi3+0x98>
  8026a8:	39 d8                	cmp    %ebx,%eax
  8026aa:	0f 82 b0 00 00 00    	jb     802760 <__umoddi3+0x130>
  8026b0:	39 f7                	cmp    %esi,%edi
  8026b2:	0f 86 a8 00 00 00    	jbe    802760 <__umoddi3+0x130>
  8026b8:	89 c8                	mov    %ecx,%eax
  8026ba:	83 c4 1c             	add    $0x1c,%esp
  8026bd:	5b                   	pop    %ebx
  8026be:	5e                   	pop    %esi
  8026bf:	5f                   	pop    %edi
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    
  8026c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c8:	89 e9                	mov    %ebp,%ecx
  8026ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8026cf:	29 ea                	sub    %ebp,%edx
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d7:	89 d1                	mov    %edx,%ecx
  8026d9:	89 f8                	mov    %edi,%eax
  8026db:	d3 e8                	shr    %cl,%eax
  8026dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026e9:	09 c1                	or     %eax,%ecx
  8026eb:	89 d8                	mov    %ebx,%eax
  8026ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e7                	shl    %cl,%edi
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	d3 e8                	shr    %cl,%eax
  8026f9:	89 e9                	mov    %ebp,%ecx
  8026fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ff:	d3 e3                	shl    %cl,%ebx
  802701:	89 c7                	mov    %eax,%edi
  802703:	89 d1                	mov    %edx,%ecx
  802705:	89 f0                	mov    %esi,%eax
  802707:	d3 e8                	shr    %cl,%eax
  802709:	89 e9                	mov    %ebp,%ecx
  80270b:	89 fa                	mov    %edi,%edx
  80270d:	d3 e6                	shl    %cl,%esi
  80270f:	09 d8                	or     %ebx,%eax
  802711:	f7 74 24 08          	divl   0x8(%esp)
  802715:	89 d1                	mov    %edx,%ecx
  802717:	89 f3                	mov    %esi,%ebx
  802719:	f7 64 24 0c          	mull   0xc(%esp)
  80271d:	89 c6                	mov    %eax,%esi
  80271f:	89 d7                	mov    %edx,%edi
  802721:	39 d1                	cmp    %edx,%ecx
  802723:	72 06                	jb     80272b <__umoddi3+0xfb>
  802725:	75 10                	jne    802737 <__umoddi3+0x107>
  802727:	39 c3                	cmp    %eax,%ebx
  802729:	73 0c                	jae    802737 <__umoddi3+0x107>
  80272b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80272f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802733:	89 d7                	mov    %edx,%edi
  802735:	89 c6                	mov    %eax,%esi
  802737:	89 ca                	mov    %ecx,%edx
  802739:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80273e:	29 f3                	sub    %esi,%ebx
  802740:	19 fa                	sbb    %edi,%edx
  802742:	89 d0                	mov    %edx,%eax
  802744:	d3 e0                	shl    %cl,%eax
  802746:	89 e9                	mov    %ebp,%ecx
  802748:	d3 eb                	shr    %cl,%ebx
  80274a:	d3 ea                	shr    %cl,%edx
  80274c:	09 d8                	or     %ebx,%eax
  80274e:	83 c4 1c             	add    $0x1c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80275d:	8d 76 00             	lea    0x0(%esi),%esi
  802760:	89 da                	mov    %ebx,%edx
  802762:	29 fe                	sub    %edi,%esi
  802764:	19 c2                	sbb    %eax,%edx
  802766:	89 f1                	mov    %esi,%ecx
  802768:	89 c8                	mov    %ecx,%eax
  80276a:	e9 4b ff ff ff       	jmp    8026ba <__umoddi3+0x8a>
