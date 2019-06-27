
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 af 0a 00 00       	call   800af8 <strcpy>
	exit();
  800049:	e8 21 02 00 00       	call   80026f <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 72 0e 00 00       	call   800eea <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 ac 13 00 00       	call   801434 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 29 2c 00 00       	call   802cca <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 ef 0a 00 00       	call   800ba3 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 c0 32 80 00       	mov    $0x8032c0,%eax
  8000be:	ba c6 32 80 00       	mov    $0x8032c6,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 fc 32 80 00       	push   $0x8032fc
  8000cc:	e8 c8 02 00 00       	call   800399 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 17 33 80 00       	push   $0x803317
  8000d8:	68 1c 33 80 00       	push   $0x80331c
  8000dd:	68 1b 33 80 00       	push   $0x80331b
  8000e2:	e8 9f 23 00 00       	call   802486 <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 cf 2b 00 00       	call   802cca <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 95 0a 00 00       	call   800ba3 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 c0 32 80 00       	mov    $0x8032c0,%eax
  800118:	ba c6 32 80 00       	mov    $0x8032c6,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 33 33 80 00       	push   $0x803333
  800126:	e8 6e 02 00 00       	call   800399 <cprintf>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 cc 32 80 00       	push   $0x8032cc
  800144:	6a 13                	push   $0x13
  800146:	68 df 32 80 00       	push   $0x8032df
  80014b:	e8 53 01 00 00       	call   8002a3 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 f3 32 80 00       	push   $0x8032f3
  800156:	6a 17                	push   $0x17
  800158:	68 df 32 80 00       	push   $0x8032df
  80015d:	e8 41 01 00 00       	call   8002a3 <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 83 09 00 00       	call   800af8 <strcpy>
		exit();
  800175:	e8 f5 00 00 00       	call   80026f <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 29 33 80 00       	push   $0x803329
  800188:	6a 21                	push   $0x21
  80018a:	68 df 32 80 00       	push   $0x8032df
  80018f:	e8 0f 01 00 00       	call   8002a3 <_panic>

00800194 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80019d:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001a4:	00 00 00 
	envid_t find = sys_getenvid();
  8001a7:	e8 00 0d 00 00       	call   800eac <sys_getenvid>
  8001ac:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8001b2:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c1:	eb 0b                	jmp    8001ce <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001c3:	83 c2 01             	add    $0x1,%edx
  8001c6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001cc:	74 23                	je     8001f1 <libmain+0x5d>
		if(envs[i].env_id == find)
  8001ce:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8001d4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001da:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001dd:	39 c1                	cmp    %eax,%ecx
  8001df:	75 e2                	jne    8001c3 <libmain+0x2f>
  8001e1:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8001e7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001ed:	89 fe                	mov    %edi,%esi
  8001ef:	eb d2                	jmp    8001c3 <libmain+0x2f>
  8001f1:	89 f0                	mov    %esi,%eax
  8001f3:	84 c0                	test   %al,%al
  8001f5:	74 06                	je     8001fd <libmain+0x69>
  8001f7:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x79>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 08 40 80 00       	mov    %eax,0x804008

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80020d:	a1 08 50 80 00       	mov    0x805008,%eax
  800212:	8b 40 48             	mov    0x48(%eax),%eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	50                   	push   %eax
  800219:	68 6d 33 80 00       	push   $0x80336d
  80021e:	e8 76 01 00 00       	call   800399 <cprintf>
	cprintf("before umain\n");
  800223:	c7 04 24 8b 33 80 00 	movl   $0x80338b,(%esp)
  80022a:	e8 6a 01 00 00       	call   800399 <cprintf>
	// call user main routine
	umain(argc, argv);
  80022f:	83 c4 08             	add    $0x8,%esp
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	e8 16 fe ff ff       	call   800053 <umain>
	cprintf("after umain\n");
  80023d:	c7 04 24 99 33 80 00 	movl   $0x803399,(%esp)
  800244:	e8 50 01 00 00       	call   800399 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800249:	a1 08 50 80 00       	mov    0x805008,%eax
  80024e:	8b 40 48             	mov    0x48(%eax),%eax
  800251:	83 c4 08             	add    $0x8,%esp
  800254:	50                   	push   %eax
  800255:	68 a6 33 80 00       	push   $0x8033a6
  80025a:	e8 3a 01 00 00       	call   800399 <cprintf>
	// exit gracefully
	exit();
  80025f:	e8 0b 00 00 00       	call   80026f <exit>
}
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800275:	a1 08 50 80 00       	mov    0x805008,%eax
  80027a:	8b 40 48             	mov    0x48(%eax),%eax
  80027d:	68 d0 33 80 00       	push   $0x8033d0
  800282:	50                   	push   %eax
  800283:	68 c5 33 80 00       	push   $0x8033c5
  800288:	e8 0c 01 00 00       	call   800399 <cprintf>
	close_all();
  80028d:	e8 12 16 00 00       	call   8018a4 <close_all>
	sys_env_destroy(0);
  800292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800299:	e8 cd 0b 00 00       	call   800e6b <sys_env_destroy>
}
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    

008002a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	56                   	push   %esi
  8002a7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8002ad:	8b 40 48             	mov    0x48(%eax),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	68 fc 33 80 00       	push   $0x8033fc
  8002b8:	50                   	push   %eax
  8002b9:	68 c5 33 80 00       	push   $0x8033c5
  8002be:	e8 d6 00 00 00       	call   800399 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002c3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c6:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8002cc:	e8 db 0b 00 00       	call   800eac <sys_getenvid>
  8002d1:	83 c4 04             	add    $0x4,%esp
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	56                   	push   %esi
  8002db:	50                   	push   %eax
  8002dc:	68 d8 33 80 00       	push   $0x8033d8
  8002e1:	e8 b3 00 00 00       	call   800399 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e6:	83 c4 18             	add    $0x18,%esp
  8002e9:	53                   	push   %ebx
  8002ea:	ff 75 10             	pushl  0x10(%ebp)
  8002ed:	e8 56 00 00 00       	call   800348 <vcprintf>
	cprintf("\n");
  8002f2:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
  8002f9:	e8 9b 00 00 00       	call   800399 <cprintf>
  8002fe:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800301:	cc                   	int3   
  800302:	eb fd                	jmp    800301 <_panic+0x5e>

00800304 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	53                   	push   %ebx
  800308:	83 ec 04             	sub    $0x4,%esp
  80030b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030e:	8b 13                	mov    (%ebx),%edx
  800310:	8d 42 01             	lea    0x1(%edx),%eax
  800313:	89 03                	mov    %eax,(%ebx)
  800315:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800318:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80031c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800321:	74 09                	je     80032c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800323:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	68 ff 00 00 00       	push   $0xff
  800334:	8d 43 08             	lea    0x8(%ebx),%eax
  800337:	50                   	push   %eax
  800338:	e8 f1 0a 00 00       	call   800e2e <sys_cputs>
		b->idx = 0;
  80033d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	eb db                	jmp    800323 <putch+0x1f>

00800348 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800351:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800358:	00 00 00 
	b.cnt = 0;
  80035b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800362:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	68 04 03 80 00       	push   $0x800304
  800377:	e8 4a 01 00 00       	call   8004c6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80037c:	83 c4 08             	add    $0x8,%esp
  80037f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800385:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80038b:	50                   	push   %eax
  80038c:	e8 9d 0a 00 00       	call   800e2e <sys_cputs>

	return b.cnt;
}
  800391:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003a2:	50                   	push   %eax
  8003a3:	ff 75 08             	pushl  0x8(%ebp)
  8003a6:	e8 9d ff ff ff       	call   800348 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	57                   	push   %edi
  8003b1:	56                   	push   %esi
  8003b2:	53                   	push   %ebx
  8003b3:	83 ec 1c             	sub    $0x1c,%esp
  8003b6:	89 c6                	mov    %eax,%esi
  8003b8:	89 d7                	mov    %edx,%edi
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003cc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003d0:	74 2c                	je     8003fe <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003df:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e2:	39 c2                	cmp    %eax,%edx
  8003e4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003e7:	73 43                	jae    80042c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003e9:	83 eb 01             	sub    $0x1,%ebx
  8003ec:	85 db                	test   %ebx,%ebx
  8003ee:	7e 6c                	jle    80045c <printnum+0xaf>
				putch(padc, putdat);
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	57                   	push   %edi
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	ff d6                	call   *%esi
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	eb eb                	jmp    8003e9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	6a 20                	push   $0x20
  800403:	6a 00                	push   $0x0
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	ff 75 e0             	pushl  -0x20(%ebp)
  80040c:	89 fa                	mov    %edi,%edx
  80040e:	89 f0                	mov    %esi,%eax
  800410:	e8 98 ff ff ff       	call   8003ad <printnum>
		while (--width > 0)
  800415:	83 c4 20             	add    $0x20,%esp
  800418:	83 eb 01             	sub    $0x1,%ebx
  80041b:	85 db                	test   %ebx,%ebx
  80041d:	7e 65                	jle    800484 <printnum+0xd7>
			putch(padc, putdat);
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	57                   	push   %edi
  800423:	6a 20                	push   $0x20
  800425:	ff d6                	call   *%esi
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	eb ec                	jmp    800418 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	ff 75 18             	pushl  0x18(%ebp)
  800432:	83 eb 01             	sub    $0x1,%ebx
  800435:	53                   	push   %ebx
  800436:	50                   	push   %eax
  800437:	83 ec 08             	sub    $0x8,%esp
  80043a:	ff 75 dc             	pushl  -0x24(%ebp)
  80043d:	ff 75 d8             	pushl  -0x28(%ebp)
  800440:	ff 75 e4             	pushl  -0x1c(%ebp)
  800443:	ff 75 e0             	pushl  -0x20(%ebp)
  800446:	e8 25 2c 00 00       	call   803070 <__udivdi3>
  80044b:	83 c4 18             	add    $0x18,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	89 fa                	mov    %edi,%edx
  800452:	89 f0                	mov    %esi,%eax
  800454:	e8 54 ff ff ff       	call   8003ad <printnum>
  800459:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	57                   	push   %edi
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	ff 75 dc             	pushl  -0x24(%ebp)
  800466:	ff 75 d8             	pushl  -0x28(%ebp)
  800469:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046c:	ff 75 e0             	pushl  -0x20(%ebp)
  80046f:	e8 0c 2d 00 00       	call   803180 <__umoddi3>
  800474:	83 c4 14             	add    $0x14,%esp
  800477:	0f be 80 03 34 80 00 	movsbl 0x803403(%eax),%eax
  80047e:	50                   	push   %eax
  80047f:	ff d6                	call   *%esi
  800481:	83 c4 10             	add    $0x10,%esp
	}
}
  800484:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800487:	5b                   	pop    %ebx
  800488:	5e                   	pop    %esi
  800489:	5f                   	pop    %edi
  80048a:	5d                   	pop    %ebp
  80048b:	c3                   	ret    

0080048c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800492:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800496:	8b 10                	mov    (%eax),%edx
  800498:	3b 50 04             	cmp    0x4(%eax),%edx
  80049b:	73 0a                	jae    8004a7 <sprintputch+0x1b>
		*b->buf++ = ch;
  80049d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a0:	89 08                	mov    %ecx,(%eax)
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	88 02                	mov    %al,(%edx)
}
  8004a7:	5d                   	pop    %ebp
  8004a8:	c3                   	ret    

008004a9 <printfmt>:
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004af:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b2:	50                   	push   %eax
  8004b3:	ff 75 10             	pushl  0x10(%ebp)
  8004b6:	ff 75 0c             	pushl  0xc(%ebp)
  8004b9:	ff 75 08             	pushl  0x8(%ebp)
  8004bc:	e8 05 00 00 00       	call   8004c6 <vprintfmt>
}
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <vprintfmt>:
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	57                   	push   %edi
  8004ca:	56                   	push   %esi
  8004cb:	53                   	push   %ebx
  8004cc:	83 ec 3c             	sub    $0x3c,%esp
  8004cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004d8:	e9 32 04 00 00       	jmp    80090f <vprintfmt+0x449>
		padc = ' ';
  8004dd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004e1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800504:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800509:	8d 47 01             	lea    0x1(%edi),%eax
  80050c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050f:	0f b6 17             	movzbl (%edi),%edx
  800512:	8d 42 dd             	lea    -0x23(%edx),%eax
  800515:	3c 55                	cmp    $0x55,%al
  800517:	0f 87 12 05 00 00    	ja     800a2f <vprintfmt+0x569>
  80051d:	0f b6 c0             	movzbl %al,%eax
  800520:	ff 24 85 e0 35 80 00 	jmp    *0x8035e0(,%eax,4)
  800527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80052a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80052e:	eb d9                	jmp    800509 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800533:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800537:	eb d0                	jmp    800509 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800539:	0f b6 d2             	movzbl %dl,%edx
  80053c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80053f:	b8 00 00 00 00       	mov    $0x0,%eax
  800544:	89 75 08             	mov    %esi,0x8(%ebp)
  800547:	eb 03                	jmp    80054c <vprintfmt+0x86>
  800549:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80054c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800553:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800556:	8d 72 d0             	lea    -0x30(%edx),%esi
  800559:	83 fe 09             	cmp    $0x9,%esi
  80055c:	76 eb                	jbe    800549 <vprintfmt+0x83>
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	8b 75 08             	mov    0x8(%ebp),%esi
  800564:	eb 14                	jmp    80057a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 40 04             	lea    0x4(%eax),%eax
  800574:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80057a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057e:	79 89                	jns    800509 <vprintfmt+0x43>
				width = precision, precision = -1;
  800580:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800586:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80058d:	e9 77 ff ff ff       	jmp    800509 <vprintfmt+0x43>
  800592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	0f 48 c1             	cmovs  %ecx,%eax
  80059a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a0:	e9 64 ff ff ff       	jmp    800509 <vprintfmt+0x43>
  8005a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005af:	e9 55 ff ff ff       	jmp    800509 <vprintfmt+0x43>
			lflag++;
  8005b4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005bb:	e9 49 ff ff ff       	jmp    800509 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8d 78 04             	lea    0x4(%eax),%edi
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	ff 30                	pushl  (%eax)
  8005cc:	ff d6                	call   *%esi
			break;
  8005ce:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d4:	e9 33 03 00 00       	jmp    80090c <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 78 04             	lea    0x4(%eax),%edi
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	99                   	cltd   
  8005e2:	31 d0                	xor    %edx,%eax
  8005e4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e6:	83 f8 11             	cmp    $0x11,%eax
  8005e9:	7f 23                	jg     80060e <vprintfmt+0x148>
  8005eb:	8b 14 85 40 37 80 00 	mov    0x803740(,%eax,4),%edx
  8005f2:	85 d2                	test   %edx,%edx
  8005f4:	74 18                	je     80060e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005f6:	52                   	push   %edx
  8005f7:	68 4d 39 80 00       	push   $0x80394d
  8005fc:	53                   	push   %ebx
  8005fd:	56                   	push   %esi
  8005fe:	e8 a6 fe ff ff       	call   8004a9 <printfmt>
  800603:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800606:	89 7d 14             	mov    %edi,0x14(%ebp)
  800609:	e9 fe 02 00 00       	jmp    80090c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80060e:	50                   	push   %eax
  80060f:	68 1b 34 80 00       	push   $0x80341b
  800614:	53                   	push   %ebx
  800615:	56                   	push   %esi
  800616:	e8 8e fe ff ff       	call   8004a9 <printfmt>
  80061b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80061e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800621:	e9 e6 02 00 00       	jmp    80090c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	83 c0 04             	add    $0x4,%eax
  80062c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800634:	85 c9                	test   %ecx,%ecx
  800636:	b8 14 34 80 00       	mov    $0x803414,%eax
  80063b:	0f 45 c1             	cmovne %ecx,%eax
  80063e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800641:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800645:	7e 06                	jle    80064d <vprintfmt+0x187>
  800647:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80064b:	75 0d                	jne    80065a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800650:	89 c7                	mov    %eax,%edi
  800652:	03 45 e0             	add    -0x20(%ebp),%eax
  800655:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800658:	eb 53                	jmp    8006ad <vprintfmt+0x1e7>
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 d8             	pushl  -0x28(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 71 04 00 00       	call   800ad7 <strnlen>
  800666:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800669:	29 c1                	sub    %eax,%ecx
  80066b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800673:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800677:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80067a:	eb 0f                	jmp    80068b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	53                   	push   %ebx
  800680:	ff 75 e0             	pushl  -0x20(%ebp)
  800683:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800685:	83 ef 01             	sub    $0x1,%edi
  800688:	83 c4 10             	add    $0x10,%esp
  80068b:	85 ff                	test   %edi,%edi
  80068d:	7f ed                	jg     80067c <vprintfmt+0x1b6>
  80068f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800692:	85 c9                	test   %ecx,%ecx
  800694:	b8 00 00 00 00       	mov    $0x0,%eax
  800699:	0f 49 c1             	cmovns %ecx,%eax
  80069c:	29 c1                	sub    %eax,%ecx
  80069e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006a1:	eb aa                	jmp    80064d <vprintfmt+0x187>
					putch(ch, putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	53                   	push   %ebx
  8006a7:	52                   	push   %edx
  8006a8:	ff d6                	call   *%esi
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b2:	83 c7 01             	add    $0x1,%edi
  8006b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b9:	0f be d0             	movsbl %al,%edx
  8006bc:	85 d2                	test   %edx,%edx
  8006be:	74 4b                	je     80070b <vprintfmt+0x245>
  8006c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c4:	78 06                	js     8006cc <vprintfmt+0x206>
  8006c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ca:	78 1e                	js     8006ea <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006cc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006d0:	74 d1                	je     8006a3 <vprintfmt+0x1dd>
  8006d2:	0f be c0             	movsbl %al,%eax
  8006d5:	83 e8 20             	sub    $0x20,%eax
  8006d8:	83 f8 5e             	cmp    $0x5e,%eax
  8006db:	76 c6                	jbe    8006a3 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 3f                	push   $0x3f
  8006e3:	ff d6                	call   *%esi
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	eb c3                	jmp    8006ad <vprintfmt+0x1e7>
  8006ea:	89 cf                	mov    %ecx,%edi
  8006ec:	eb 0e                	jmp    8006fc <vprintfmt+0x236>
				putch(' ', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 20                	push   $0x20
  8006f4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006f6:	83 ef 01             	sub    $0x1,%edi
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	85 ff                	test   %edi,%edi
  8006fe:	7f ee                	jg     8006ee <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800700:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
  800706:	e9 01 02 00 00       	jmp    80090c <vprintfmt+0x446>
  80070b:	89 cf                	mov    %ecx,%edi
  80070d:	eb ed                	jmp    8006fc <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80070f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800712:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800719:	e9 eb fd ff ff       	jmp    800509 <vprintfmt+0x43>
	if (lflag >= 2)
  80071e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800722:	7f 21                	jg     800745 <vprintfmt+0x27f>
	else if (lflag)
  800724:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800728:	74 68                	je     800792 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800732:	89 c1                	mov    %eax,%ecx
  800734:	c1 f9 1f             	sar    $0x1f,%ecx
  800737:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	eb 17                	jmp    80075c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 50 04             	mov    0x4(%eax),%edx
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800750:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 08             	lea    0x8(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80075c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80075f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800768:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80076c:	78 3f                	js     8007ad <vprintfmt+0x2e7>
			base = 10;
  80076e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800773:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800777:	0f 84 71 01 00 00    	je     8008ee <vprintfmt+0x428>
				putch('+', putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	53                   	push   %ebx
  800781:	6a 2b                	push   $0x2b
  800783:	ff d6                	call   *%esi
  800785:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800788:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078d:	e9 5c 01 00 00       	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, int);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80079a:	89 c1                	mov    %eax,%ecx
  80079c:	c1 f9 1f             	sar    $0x1f,%ecx
  80079f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ab:	eb af                	jmp    80075c <vprintfmt+0x296>
				putch('-', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	6a 2d                	push   $0x2d
  8007b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007bb:	f7 d8                	neg    %eax
  8007bd:	83 d2 00             	adc    $0x0,%edx
  8007c0:	f7 da                	neg    %edx
  8007c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d0:	e9 19 01 00 00       	jmp    8008ee <vprintfmt+0x428>
	if (lflag >= 2)
  8007d5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007d9:	7f 29                	jg     800804 <vprintfmt+0x33e>
	else if (lflag)
  8007db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007df:	74 44                	je     800825 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8d 40 04             	lea    0x4(%eax),%eax
  8007f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ff:	e9 ea 00 00 00       	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 50 04             	mov    0x4(%eax),%edx
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800820:	e9 c9 00 00 00       	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	ba 00 00 00 00       	mov    $0x0,%edx
  80082f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800832:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8d 40 04             	lea    0x4(%eax),%eax
  80083b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800843:	e9 a6 00 00 00       	jmp    8008ee <vprintfmt+0x428>
			putch('0', putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	53                   	push   %ebx
  80084c:	6a 30                	push   $0x30
  80084e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800857:	7f 26                	jg     80087f <vprintfmt+0x3b9>
	else if (lflag)
  800859:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80085d:	74 3e                	je     80089d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	ba 00 00 00 00       	mov    $0x0,%edx
  800869:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8d 40 04             	lea    0x4(%eax),%eax
  800875:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800878:	b8 08 00 00 00       	mov    $0x8,%eax
  80087d:	eb 6f                	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 50 04             	mov    0x4(%eax),%edx
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 08             	lea    0x8(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800896:	b8 08 00 00 00       	mov    $0x8,%eax
  80089b:	eb 51                	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8008bb:	eb 31                	jmp    8008ee <vprintfmt+0x428>
			putch('0', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	53                   	push   %ebx
  8008c1:	6a 30                	push   $0x30
  8008c3:	ff d6                	call   *%esi
			putch('x', putdat);
  8008c5:	83 c4 08             	add    $0x8,%esp
  8008c8:	53                   	push   %ebx
  8008c9:	6a 78                	push   $0x78
  8008cb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008da:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008dd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 40 04             	lea    0x4(%eax),%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008f5:	52                   	push   %edx
  8008f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8008fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800900:	89 da                	mov    %ebx,%edx
  800902:	89 f0                	mov    %esi,%eax
  800904:	e8 a4 fa ff ff       	call   8003ad <printnum>
			break;
  800909:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80090c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090f:	83 c7 01             	add    $0x1,%edi
  800912:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800916:	83 f8 25             	cmp    $0x25,%eax
  800919:	0f 84 be fb ff ff    	je     8004dd <vprintfmt+0x17>
			if (ch == '\0')
  80091f:	85 c0                	test   %eax,%eax
  800921:	0f 84 28 01 00 00    	je     800a4f <vprintfmt+0x589>
			putch(ch, putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	53                   	push   %ebx
  80092b:	50                   	push   %eax
  80092c:	ff d6                	call   *%esi
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	eb dc                	jmp    80090f <vprintfmt+0x449>
	if (lflag >= 2)
  800933:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800937:	7f 26                	jg     80095f <vprintfmt+0x499>
	else if (lflag)
  800939:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80093d:	74 41                	je     800980 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	ba 00 00 00 00       	mov    $0x0,%edx
  800949:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800958:	b8 10 00 00 00       	mov    $0x10,%eax
  80095d:	eb 8f                	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	8b 50 04             	mov    0x4(%eax),%edx
  800965:	8b 00                	mov    (%eax),%eax
  800967:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	8d 40 08             	lea    0x8(%eax),%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800976:	b8 10 00 00 00       	mov    $0x10,%eax
  80097b:	e9 6e ff ff ff       	jmp    8008ee <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	ba 00 00 00 00       	mov    $0x0,%edx
  80098a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	8d 40 04             	lea    0x4(%eax),%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800999:	b8 10 00 00 00       	mov    $0x10,%eax
  80099e:	e9 4b ff ff ff       	jmp    8008ee <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 c0 04             	add    $0x4,%eax
  8009a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	85 c0                	test   %eax,%eax
  8009b3:	74 14                	je     8009c9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009b5:	8b 13                	mov    (%ebx),%edx
  8009b7:	83 fa 7f             	cmp    $0x7f,%edx
  8009ba:	7f 37                	jg     8009f3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009bc:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	e9 43 ff ff ff       	jmp    80090c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ce:	bf 39 35 80 00       	mov    $0x803539,%edi
							putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009da:	83 c7 01             	add    $0x1,%edi
  8009dd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	85 c0                	test   %eax,%eax
  8009e6:	75 eb                	jne    8009d3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ee:	e9 19 ff ff ff       	jmp    80090c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009f3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009fa:	bf 71 35 80 00       	mov    $0x803571,%edi
							putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	53                   	push   %ebx
  800a03:	50                   	push   %eax
  800a04:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a06:	83 c7 01             	add    $0x1,%edi
  800a09:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	85 c0                	test   %eax,%eax
  800a12:	75 eb                	jne    8009ff <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1a:	e9 ed fe ff ff       	jmp    80090c <vprintfmt+0x446>
			putch(ch, putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	53                   	push   %ebx
  800a23:	6a 25                	push   $0x25
  800a25:	ff d6                	call   *%esi
			break;
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	e9 dd fe ff ff       	jmp    80090c <vprintfmt+0x446>
			putch('%', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	53                   	push   %ebx
  800a33:	6a 25                	push   $0x25
  800a35:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	89 f8                	mov    %edi,%eax
  800a3c:	eb 03                	jmp    800a41 <vprintfmt+0x57b>
  800a3e:	83 e8 01             	sub    $0x1,%eax
  800a41:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a45:	75 f7                	jne    800a3e <vprintfmt+0x578>
  800a47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a4a:	e9 bd fe ff ff       	jmp    80090c <vprintfmt+0x446>
}
  800a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5f                   	pop    %edi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 18             	sub    $0x18,%esp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a74:	85 c0                	test   %eax,%eax
  800a76:	74 26                	je     800a9e <vsnprintf+0x47>
  800a78:	85 d2                	test   %edx,%edx
  800a7a:	7e 22                	jle    800a9e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a7c:	ff 75 14             	pushl  0x14(%ebp)
  800a7f:	ff 75 10             	pushl  0x10(%ebp)
  800a82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	68 8c 04 80 00       	push   $0x80048c
  800a8b:	e8 36 fa ff ff       	call   8004c6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a93:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a99:	83 c4 10             	add    $0x10,%esp
}
  800a9c:	c9                   	leave  
  800a9d:	c3                   	ret    
		return -E_INVAL;
  800a9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa3:	eb f7                	jmp    800a9c <vsnprintf+0x45>

00800aa5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aab:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aae:	50                   	push   %eax
  800aaf:	ff 75 10             	pushl  0x10(%ebp)
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	e8 9a ff ff ff       	call   800a57 <vsnprintf>
	va_end(ap);

	return rc;
}
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ace:	74 05                	je     800ad5 <strlen+0x16>
		n++;
  800ad0:	83 c0 01             	add    $0x1,%eax
  800ad3:	eb f5                	jmp    800aca <strlen+0xb>
	return n;
}
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae5:	39 c2                	cmp    %eax,%edx
  800ae7:	74 0d                	je     800af6 <strnlen+0x1f>
  800ae9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800aed:	74 05                	je     800af4 <strnlen+0x1d>
		n++;
  800aef:	83 c2 01             	add    $0x1,%edx
  800af2:	eb f1                	jmp    800ae5 <strnlen+0xe>
  800af4:	89 d0                	mov    %edx,%eax
	return n;
}
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	53                   	push   %ebx
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b02:	ba 00 00 00 00       	mov    $0x0,%edx
  800b07:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b0b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b0e:	83 c2 01             	add    $0x1,%edx
  800b11:	84 c9                	test   %cl,%cl
  800b13:	75 f2                	jne    800b07 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b15:	5b                   	pop    %ebx
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	53                   	push   %ebx
  800b1c:	83 ec 10             	sub    $0x10,%esp
  800b1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b22:	53                   	push   %ebx
  800b23:	e8 97 ff ff ff       	call   800abf <strlen>
  800b28:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	01 d8                	add    %ebx,%eax
  800b30:	50                   	push   %eax
  800b31:	e8 c2 ff ff ff       	call   800af8 <strcpy>
	return dst;
}
  800b36:	89 d8                	mov    %ebx,%eax
  800b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b48:	89 c6                	mov    %eax,%esi
  800b4a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	39 f2                	cmp    %esi,%edx
  800b51:	74 11                	je     800b64 <strncpy+0x27>
		*dst++ = *src;
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	0f b6 19             	movzbl (%ecx),%ebx
  800b59:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b5c:	80 fb 01             	cmp    $0x1,%bl
  800b5f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b62:	eb eb                	jmp    800b4f <strncpy+0x12>
	}
	return ret;
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b73:	8b 55 10             	mov    0x10(%ebp),%edx
  800b76:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b78:	85 d2                	test   %edx,%edx
  800b7a:	74 21                	je     800b9d <strlcpy+0x35>
  800b7c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b80:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b82:	39 c2                	cmp    %eax,%edx
  800b84:	74 14                	je     800b9a <strlcpy+0x32>
  800b86:	0f b6 19             	movzbl (%ecx),%ebx
  800b89:	84 db                	test   %bl,%bl
  800b8b:	74 0b                	je     800b98 <strlcpy+0x30>
			*dst++ = *src++;
  800b8d:	83 c1 01             	add    $0x1,%ecx
  800b90:	83 c2 01             	add    $0x1,%edx
  800b93:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b96:	eb ea                	jmp    800b82 <strlcpy+0x1a>
  800b98:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b9a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9d:	29 f0                	sub    %esi,%eax
}
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bac:	0f b6 01             	movzbl (%ecx),%eax
  800baf:	84 c0                	test   %al,%al
  800bb1:	74 0c                	je     800bbf <strcmp+0x1c>
  800bb3:	3a 02                	cmp    (%edx),%al
  800bb5:	75 08                	jne    800bbf <strcmp+0x1c>
		p++, q++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	83 c2 01             	add    $0x1,%edx
  800bbd:	eb ed                	jmp    800bac <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbf:	0f b6 c0             	movzbl %al,%eax
  800bc2:	0f b6 12             	movzbl (%edx),%edx
  800bc5:	29 d0                	sub    %edx,%eax
}
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd3:	89 c3                	mov    %eax,%ebx
  800bd5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd8:	eb 06                	jmp    800be0 <strncmp+0x17>
		n--, p++, q++;
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800be0:	39 d8                	cmp    %ebx,%eax
  800be2:	74 16                	je     800bfa <strncmp+0x31>
  800be4:	0f b6 08             	movzbl (%eax),%ecx
  800be7:	84 c9                	test   %cl,%cl
  800be9:	74 04                	je     800bef <strncmp+0x26>
  800beb:	3a 0a                	cmp    (%edx),%cl
  800bed:	74 eb                	je     800bda <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bef:	0f b6 00             	movzbl (%eax),%eax
  800bf2:	0f b6 12             	movzbl (%edx),%edx
  800bf5:	29 d0                	sub    %edx,%eax
}
  800bf7:	5b                   	pop    %ebx
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    
		return 0;
  800bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800bff:	eb f6                	jmp    800bf7 <strncmp+0x2e>

00800c01 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c0b:	0f b6 10             	movzbl (%eax),%edx
  800c0e:	84 d2                	test   %dl,%dl
  800c10:	74 09                	je     800c1b <strchr+0x1a>
		if (*s == c)
  800c12:	38 ca                	cmp    %cl,%dl
  800c14:	74 0a                	je     800c20 <strchr+0x1f>
	for (; *s; s++)
  800c16:	83 c0 01             	add    $0x1,%eax
  800c19:	eb f0                	jmp    800c0b <strchr+0xa>
			return (char *) s;
	return 0;
  800c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c2c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c2f:	38 ca                	cmp    %cl,%dl
  800c31:	74 09                	je     800c3c <strfind+0x1a>
  800c33:	84 d2                	test   %dl,%dl
  800c35:	74 05                	je     800c3c <strfind+0x1a>
	for (; *s; s++)
  800c37:	83 c0 01             	add    $0x1,%eax
  800c3a:	eb f0                	jmp    800c2c <strfind+0xa>
			break;
	return (char *) s;
}
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	57                   	push   %edi
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c4a:	85 c9                	test   %ecx,%ecx
  800c4c:	74 31                	je     800c7f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4e:	89 f8                	mov    %edi,%eax
  800c50:	09 c8                	or     %ecx,%eax
  800c52:	a8 03                	test   $0x3,%al
  800c54:	75 23                	jne    800c79 <memset+0x3b>
		c &= 0xFF;
  800c56:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c5a:	89 d3                	mov    %edx,%ebx
  800c5c:	c1 e3 08             	shl    $0x8,%ebx
  800c5f:	89 d0                	mov    %edx,%eax
  800c61:	c1 e0 18             	shl    $0x18,%eax
  800c64:	89 d6                	mov    %edx,%esi
  800c66:	c1 e6 10             	shl    $0x10,%esi
  800c69:	09 f0                	or     %esi,%eax
  800c6b:	09 c2                	or     %eax,%edx
  800c6d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c72:	89 d0                	mov    %edx,%eax
  800c74:	fc                   	cld    
  800c75:	f3 ab                	rep stos %eax,%es:(%edi)
  800c77:	eb 06                	jmp    800c7f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	fc                   	cld    
  800c7d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7f:	89 f8                	mov    %edi,%eax
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c91:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c94:	39 c6                	cmp    %eax,%esi
  800c96:	73 32                	jae    800cca <memmove+0x44>
  800c98:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c9b:	39 c2                	cmp    %eax,%edx
  800c9d:	76 2b                	jbe    800cca <memmove+0x44>
		s += n;
		d += n;
  800c9f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca2:	89 fe                	mov    %edi,%esi
  800ca4:	09 ce                	or     %ecx,%esi
  800ca6:	09 d6                	or     %edx,%esi
  800ca8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cae:	75 0e                	jne    800cbe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cb0:	83 ef 04             	sub    $0x4,%edi
  800cb3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb9:	fd                   	std    
  800cba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbc:	eb 09                	jmp    800cc7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cbe:	83 ef 01             	sub    $0x1,%edi
  800cc1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc4:	fd                   	std    
  800cc5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc7:	fc                   	cld    
  800cc8:	eb 1a                	jmp    800ce4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cca:	89 c2                	mov    %eax,%edx
  800ccc:	09 ca                	or     %ecx,%edx
  800cce:	09 f2                	or     %esi,%edx
  800cd0:	f6 c2 03             	test   $0x3,%dl
  800cd3:	75 0a                	jne    800cdf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd8:	89 c7                	mov    %eax,%edi
  800cda:	fc                   	cld    
  800cdb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cdd:	eb 05                	jmp    800ce4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cdf:	89 c7                	mov    %eax,%edi
  800ce1:	fc                   	cld    
  800ce2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cee:	ff 75 10             	pushl  0x10(%ebp)
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	ff 75 08             	pushl  0x8(%ebp)
  800cf7:	e8 8a ff ff ff       	call   800c86 <memmove>
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	89 c6                	mov    %eax,%esi
  800d0b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0e:	39 f0                	cmp    %esi,%eax
  800d10:	74 1c                	je     800d2e <memcmp+0x30>
		if (*s1 != *s2)
  800d12:	0f b6 08             	movzbl (%eax),%ecx
  800d15:	0f b6 1a             	movzbl (%edx),%ebx
  800d18:	38 d9                	cmp    %bl,%cl
  800d1a:	75 08                	jne    800d24 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d1c:	83 c0 01             	add    $0x1,%eax
  800d1f:	83 c2 01             	add    $0x1,%edx
  800d22:	eb ea                	jmp    800d0e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d24:	0f b6 c1             	movzbl %cl,%eax
  800d27:	0f b6 db             	movzbl %bl,%ebx
  800d2a:	29 d8                	sub    %ebx,%eax
  800d2c:	eb 05                	jmp    800d33 <memcmp+0x35>
	}

	return 0;
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d40:	89 c2                	mov    %eax,%edx
  800d42:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d45:	39 d0                	cmp    %edx,%eax
  800d47:	73 09                	jae    800d52 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d49:	38 08                	cmp    %cl,(%eax)
  800d4b:	74 05                	je     800d52 <memfind+0x1b>
	for (; s < ends; s++)
  800d4d:	83 c0 01             	add    $0x1,%eax
  800d50:	eb f3                	jmp    800d45 <memfind+0xe>
			break;
	return (void *) s;
}
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d60:	eb 03                	jmp    800d65 <strtol+0x11>
		s++;
  800d62:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d65:	0f b6 01             	movzbl (%ecx),%eax
  800d68:	3c 20                	cmp    $0x20,%al
  800d6a:	74 f6                	je     800d62 <strtol+0xe>
  800d6c:	3c 09                	cmp    $0x9,%al
  800d6e:	74 f2                	je     800d62 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d70:	3c 2b                	cmp    $0x2b,%al
  800d72:	74 2a                	je     800d9e <strtol+0x4a>
	int neg = 0;
  800d74:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d79:	3c 2d                	cmp    $0x2d,%al
  800d7b:	74 2b                	je     800da8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d83:	75 0f                	jne    800d94 <strtol+0x40>
  800d85:	80 39 30             	cmpb   $0x30,(%ecx)
  800d88:	74 28                	je     800db2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d8a:	85 db                	test   %ebx,%ebx
  800d8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d91:	0f 44 d8             	cmove  %eax,%ebx
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d9c:	eb 50                	jmp    800dee <strtol+0x9a>
		s++;
  800d9e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800da1:	bf 00 00 00 00       	mov    $0x0,%edi
  800da6:	eb d5                	jmp    800d7d <strtol+0x29>
		s++, neg = 1;
  800da8:	83 c1 01             	add    $0x1,%ecx
  800dab:	bf 01 00 00 00       	mov    $0x1,%edi
  800db0:	eb cb                	jmp    800d7d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800db6:	74 0e                	je     800dc6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800db8:	85 db                	test   %ebx,%ebx
  800dba:	75 d8                	jne    800d94 <strtol+0x40>
		s++, base = 8;
  800dbc:	83 c1 01             	add    $0x1,%ecx
  800dbf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc4:	eb ce                	jmp    800d94 <strtol+0x40>
		s += 2, base = 16;
  800dc6:	83 c1 02             	add    $0x2,%ecx
  800dc9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dce:	eb c4                	jmp    800d94 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dd0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dd3:	89 f3                	mov    %esi,%ebx
  800dd5:	80 fb 19             	cmp    $0x19,%bl
  800dd8:	77 29                	ja     800e03 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dda:	0f be d2             	movsbl %dl,%edx
  800ddd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800de0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800de3:	7d 30                	jge    800e15 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800de5:	83 c1 01             	add    $0x1,%ecx
  800de8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dec:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dee:	0f b6 11             	movzbl (%ecx),%edx
  800df1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800df4:	89 f3                	mov    %esi,%ebx
  800df6:	80 fb 09             	cmp    $0x9,%bl
  800df9:	77 d5                	ja     800dd0 <strtol+0x7c>
			dig = *s - '0';
  800dfb:	0f be d2             	movsbl %dl,%edx
  800dfe:	83 ea 30             	sub    $0x30,%edx
  800e01:	eb dd                	jmp    800de0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e03:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e06:	89 f3                	mov    %esi,%ebx
  800e08:	80 fb 19             	cmp    $0x19,%bl
  800e0b:	77 08                	ja     800e15 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e0d:	0f be d2             	movsbl %dl,%edx
  800e10:	83 ea 37             	sub    $0x37,%edx
  800e13:	eb cb                	jmp    800de0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e19:	74 05                	je     800e20 <strtol+0xcc>
		*endptr = (char *) s;
  800e1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e1e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e20:	89 c2                	mov    %eax,%edx
  800e22:	f7 da                	neg    %edx
  800e24:	85 ff                	test   %edi,%edi
  800e26:	0f 45 c2             	cmovne %edx,%eax
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3f:	89 c3                	mov    %eax,%ebx
  800e41:	89 c7                	mov    %eax,%edi
  800e43:	89 c6                	mov    %eax,%esi
  800e45:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_cgetc>:

int
sys_cgetc(void)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e52:	ba 00 00 00 00       	mov    $0x0,%edx
  800e57:	b8 01 00 00 00       	mov    $0x1,%eax
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	89 d3                	mov    %edx,%ebx
  800e60:	89 d7                	mov    %edx,%edi
  800e62:	89 d6                	mov    %edx,%esi
  800e64:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e81:	89 cb                	mov    %ecx,%ebx
  800e83:	89 cf                	mov    %ecx,%edi
  800e85:	89 ce                	mov    %ecx,%esi
  800e87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7f 08                	jg     800e95 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	50                   	push   %eax
  800e99:	6a 03                	push   $0x3
  800e9b:	68 88 37 80 00       	push   $0x803788
  800ea0:	6a 43                	push   $0x43
  800ea2:	68 a5 37 80 00       	push   $0x8037a5
  800ea7:	e8 f7 f3 ff ff       	call   8002a3 <_panic>

00800eac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb7:	b8 02 00 00 00       	mov    $0x2,%eax
  800ebc:	89 d1                	mov    %edx,%ecx
  800ebe:	89 d3                	mov    %edx,%ebx
  800ec0:	89 d7                	mov    %edx,%edi
  800ec2:	89 d6                	mov    %edx,%esi
  800ec4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_yield>:

void
sys_yield(void)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800edb:	89 d1                	mov    %edx,%ecx
  800edd:	89 d3                	mov    %edx,%ebx
  800edf:	89 d7                	mov    %edx,%edi
  800ee1:	89 d6                	mov    %edx,%esi
  800ee3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
  800ef0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef3:	be 00 00 00 00       	mov    $0x0,%esi
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efe:	b8 04 00 00 00       	mov    $0x4,%eax
  800f03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f06:	89 f7                	mov    %esi,%edi
  800f08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	6a 04                	push   $0x4
  800f1c:	68 88 37 80 00       	push   $0x803788
  800f21:	6a 43                	push   $0x43
  800f23:	68 a5 37 80 00       	push   $0x8037a5
  800f28:	e8 76 f3 ff ff       	call   8002a3 <_panic>

00800f2d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3c:	b8 05 00 00 00       	mov    $0x5,%eax
  800f41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f47:	8b 75 18             	mov    0x18(%ebp),%esi
  800f4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 05                	push   $0x5
  800f5e:	68 88 37 80 00       	push   $0x803788
  800f63:	6a 43                	push   $0x43
  800f65:	68 a5 37 80 00       	push   $0x8037a5
  800f6a:	e8 34 f3 ff ff       	call   8002a3 <_panic>

00800f6f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	b8 06 00 00 00       	mov    $0x6,%eax
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7f 08                	jg     800f9a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	50                   	push   %eax
  800f9e:	6a 06                	push   $0x6
  800fa0:	68 88 37 80 00       	push   $0x803788
  800fa5:	6a 43                	push   $0x43
  800fa7:	68 a5 37 80 00       	push   $0x8037a5
  800fac:	e8 f2 f2 ff ff       	call   8002a3 <_panic>

00800fb1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc5:	b8 08 00 00 00       	mov    $0x8,%eax
  800fca:	89 df                	mov    %ebx,%edi
  800fcc:	89 de                	mov    %ebx,%esi
  800fce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	7f 08                	jg     800fdc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	50                   	push   %eax
  800fe0:	6a 08                	push   $0x8
  800fe2:	68 88 37 80 00       	push   $0x803788
  800fe7:	6a 43                	push   $0x43
  800fe9:	68 a5 37 80 00       	push   $0x8037a5
  800fee:	e8 b0 f2 ff ff       	call   8002a3 <_panic>

00800ff3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801007:	b8 09 00 00 00       	mov    $0x9,%eax
  80100c:	89 df                	mov    %ebx,%edi
  80100e:	89 de                	mov    %ebx,%esi
  801010:	cd 30                	int    $0x30
	if(check && ret > 0)
  801012:	85 c0                	test   %eax,%eax
  801014:	7f 08                	jg     80101e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801016:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	50                   	push   %eax
  801022:	6a 09                	push   $0x9
  801024:	68 88 37 80 00       	push   $0x803788
  801029:	6a 43                	push   $0x43
  80102b:	68 a5 37 80 00       	push   $0x8037a5
  801030:	e8 6e f2 ff ff       	call   8002a3 <_panic>

00801035 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	57                   	push   %edi
  801039:	56                   	push   %esi
  80103a:	53                   	push   %ebx
  80103b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
  801046:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801049:	b8 0a 00 00 00       	mov    $0xa,%eax
  80104e:	89 df                	mov    %ebx,%edi
  801050:	89 de                	mov    %ebx,%esi
  801052:	cd 30                	int    $0x30
	if(check && ret > 0)
  801054:	85 c0                	test   %eax,%eax
  801056:	7f 08                	jg     801060 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801060:	83 ec 0c             	sub    $0xc,%esp
  801063:	50                   	push   %eax
  801064:	6a 0a                	push   $0xa
  801066:	68 88 37 80 00       	push   $0x803788
  80106b:	6a 43                	push   $0x43
  80106d:	68 a5 37 80 00       	push   $0x8037a5
  801072:	e8 2c f2 ff ff       	call   8002a3 <_panic>

00801077 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	57                   	push   %edi
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801083:	b8 0c 00 00 00       	mov    $0xc,%eax
  801088:	be 00 00 00 00       	mov    $0x0,%esi
  80108d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801090:	8b 7d 14             	mov    0x14(%ebp),%edi
  801093:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010b0:	89 cb                	mov    %ecx,%ebx
  8010b2:	89 cf                	mov    %ecx,%edi
  8010b4:	89 ce                	mov    %ecx,%esi
  8010b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	7f 08                	jg     8010c4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c4:	83 ec 0c             	sub    $0xc,%esp
  8010c7:	50                   	push   %eax
  8010c8:	6a 0d                	push   $0xd
  8010ca:	68 88 37 80 00       	push   $0x803788
  8010cf:	6a 43                	push   $0x43
  8010d1:	68 a5 37 80 00       	push   $0x8037a5
  8010d6:	e8 c8 f1 ff ff       	call   8002a3 <_panic>

008010db <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ec:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010f1:	89 df                	mov    %ebx,%edi
  8010f3:	89 de                	mov    %ebx,%esi
  8010f5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
	asm volatile("int %1\n"
  801102:	b9 00 00 00 00       	mov    $0x0,%ecx
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80110f:	89 cb                	mov    %ecx,%ebx
  801111:	89 cf                	mov    %ecx,%edi
  801113:	89 ce                	mov    %ecx,%esi
  801115:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
	asm volatile("int %1\n"
  801122:	ba 00 00 00 00       	mov    $0x0,%edx
  801127:	b8 10 00 00 00       	mov    $0x10,%eax
  80112c:	89 d1                	mov    %edx,%ecx
  80112e:	89 d3                	mov    %edx,%ebx
  801130:	89 d7                	mov    %edx,%edi
  801132:	89 d6                	mov    %edx,%esi
  801134:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801136:	5b                   	pop    %ebx
  801137:	5e                   	pop    %esi
  801138:	5f                   	pop    %edi
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	57                   	push   %edi
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
	asm volatile("int %1\n"
  801141:	bb 00 00 00 00       	mov    $0x0,%ebx
  801146:	8b 55 08             	mov    0x8(%ebp),%edx
  801149:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114c:	b8 11 00 00 00       	mov    $0x11,%eax
  801151:	89 df                	mov    %ebx,%edi
  801153:	89 de                	mov    %ebx,%esi
  801155:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
	asm volatile("int %1\n"
  801162:	bb 00 00 00 00       	mov    $0x0,%ebx
  801167:	8b 55 08             	mov    0x8(%ebp),%edx
  80116a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116d:	b8 12 00 00 00       	mov    $0x12,%eax
  801172:	89 df                	mov    %ebx,%edi
  801174:	89 de                	mov    %ebx,%esi
  801176:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	53                   	push   %ebx
  801183:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801186:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118b:	8b 55 08             	mov    0x8(%ebp),%edx
  80118e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801191:	b8 13 00 00 00       	mov    $0x13,%eax
  801196:	89 df                	mov    %ebx,%edi
  801198:	89 de                	mov    %ebx,%esi
  80119a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80119c:	85 c0                	test   %eax,%eax
  80119e:	7f 08                	jg     8011a8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a3:	5b                   	pop    %ebx
  8011a4:	5e                   	pop    %esi
  8011a5:	5f                   	pop    %edi
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a8:	83 ec 0c             	sub    $0xc,%esp
  8011ab:	50                   	push   %eax
  8011ac:	6a 13                	push   $0x13
  8011ae:	68 88 37 80 00       	push   $0x803788
  8011b3:	6a 43                	push   $0x43
  8011b5:	68 a5 37 80 00       	push   $0x8037a5
  8011ba:	e8 e4 f0 ff ff       	call   8002a3 <_panic>

008011bf <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	57                   	push   %edi
  8011c3:	56                   	push   %esi
  8011c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cd:	b8 14 00 00 00       	mov    $0x14,%eax
  8011d2:	89 cb                	mov    %ecx,%ebx
  8011d4:	89 cf                	mov    %ecx,%edi
  8011d6:	89 ce                	mov    %ecx,%esi
  8011d8:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8011da:	5b                   	pop    %ebx
  8011db:	5e                   	pop    %esi
  8011dc:	5f                   	pop    %edi
  8011dd:	5d                   	pop    %ebp
  8011de:	c3                   	ret    

008011df <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011e6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ed:	f6 c5 04             	test   $0x4,%ch
  8011f0:	75 45                	jne    801237 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011f2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011f9:	83 e1 07             	and    $0x7,%ecx
  8011fc:	83 f9 07             	cmp    $0x7,%ecx
  8011ff:	74 6f                	je     801270 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801201:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801208:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80120e:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801214:	0f 84 b6 00 00 00    	je     8012d0 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80121a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801221:	83 e1 05             	and    $0x5,%ecx
  801224:	83 f9 05             	cmp    $0x5,%ecx
  801227:	0f 84 d7 00 00 00    	je     801304 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
  801232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801235:	c9                   	leave  
  801236:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801237:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80123e:	c1 e2 0c             	shl    $0xc,%edx
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80124a:	51                   	push   %ecx
  80124b:	52                   	push   %edx
  80124c:	50                   	push   %eax
  80124d:	52                   	push   %edx
  80124e:	6a 00                	push   $0x0
  801250:	e8 d8 fc ff ff       	call   800f2d <sys_page_map>
		if(r < 0)
  801255:	83 c4 20             	add    $0x20,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	79 d1                	jns    80122d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	68 b3 37 80 00       	push   $0x8037b3
  801264:	6a 54                	push   $0x54
  801266:	68 c9 37 80 00       	push   $0x8037c9
  80126b:	e8 33 f0 ff ff       	call   8002a3 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801270:	89 d3                	mov    %edx,%ebx
  801272:	c1 e3 0c             	shl    $0xc,%ebx
  801275:	83 ec 0c             	sub    $0xc,%esp
  801278:	68 05 08 00 00       	push   $0x805
  80127d:	53                   	push   %ebx
  80127e:	50                   	push   %eax
  80127f:	53                   	push   %ebx
  801280:	6a 00                	push   $0x0
  801282:	e8 a6 fc ff ff       	call   800f2d <sys_page_map>
		if(r < 0)
  801287:	83 c4 20             	add    $0x20,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 2e                	js     8012bc <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80128e:	83 ec 0c             	sub    $0xc,%esp
  801291:	68 05 08 00 00       	push   $0x805
  801296:	53                   	push   %ebx
  801297:	6a 00                	push   $0x0
  801299:	53                   	push   %ebx
  80129a:	6a 00                	push   $0x0
  80129c:	e8 8c fc ff ff       	call   800f2d <sys_page_map>
		if(r < 0)
  8012a1:	83 c4 20             	add    $0x20,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	79 85                	jns    80122d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	68 b3 37 80 00       	push   $0x8037b3
  8012b0:	6a 5f                	push   $0x5f
  8012b2:	68 c9 37 80 00       	push   $0x8037c9
  8012b7:	e8 e7 ef ff ff       	call   8002a3 <_panic>
			panic("sys_page_map() panic\n");
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	68 b3 37 80 00       	push   $0x8037b3
  8012c4:	6a 5b                	push   $0x5b
  8012c6:	68 c9 37 80 00       	push   $0x8037c9
  8012cb:	e8 d3 ef ff ff       	call   8002a3 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012d0:	c1 e2 0c             	shl    $0xc,%edx
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	68 05 08 00 00       	push   $0x805
  8012db:	52                   	push   %edx
  8012dc:	50                   	push   %eax
  8012dd:	52                   	push   %edx
  8012de:	6a 00                	push   $0x0
  8012e0:	e8 48 fc ff ff       	call   800f2d <sys_page_map>
		if(r < 0)
  8012e5:	83 c4 20             	add    $0x20,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	0f 89 3d ff ff ff    	jns    80122d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	68 b3 37 80 00       	push   $0x8037b3
  8012f8:	6a 66                	push   $0x66
  8012fa:	68 c9 37 80 00       	push   $0x8037c9
  8012ff:	e8 9f ef ff ff       	call   8002a3 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801304:	c1 e2 0c             	shl    $0xc,%edx
  801307:	83 ec 0c             	sub    $0xc,%esp
  80130a:	6a 05                	push   $0x5
  80130c:	52                   	push   %edx
  80130d:	50                   	push   %eax
  80130e:	52                   	push   %edx
  80130f:	6a 00                	push   $0x0
  801311:	e8 17 fc ff ff       	call   800f2d <sys_page_map>
		if(r < 0)
  801316:	83 c4 20             	add    $0x20,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	0f 89 0c ff ff ff    	jns    80122d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	68 b3 37 80 00       	push   $0x8037b3
  801329:	6a 6d                	push   $0x6d
  80132b:	68 c9 37 80 00       	push   $0x8037c9
  801330:	e8 6e ef ff ff       	call   8002a3 <_panic>

00801335 <pgfault>:
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	53                   	push   %ebx
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80133f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801341:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801345:	0f 84 99 00 00 00    	je     8013e4 <pgfault+0xaf>
  80134b:	89 c2                	mov    %eax,%edx
  80134d:	c1 ea 16             	shr    $0x16,%edx
  801350:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801357:	f6 c2 01             	test   $0x1,%dl
  80135a:	0f 84 84 00 00 00    	je     8013e4 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801360:	89 c2                	mov    %eax,%edx
  801362:	c1 ea 0c             	shr    $0xc,%edx
  801365:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136c:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801372:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801378:	75 6a                	jne    8013e4 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80137a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137f:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	6a 07                	push   $0x7
  801386:	68 00 f0 7f 00       	push   $0x7ff000
  80138b:	6a 00                	push   $0x0
  80138d:	e8 58 fb ff ff       	call   800eea <sys_page_alloc>
	if(ret < 0)
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 5f                	js     8013f8 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	68 00 10 00 00       	push   $0x1000
  8013a1:	53                   	push   %ebx
  8013a2:	68 00 f0 7f 00       	push   $0x7ff000
  8013a7:	e8 3c f9 ff ff       	call   800ce8 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013ac:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013b3:	53                   	push   %ebx
  8013b4:	6a 00                	push   $0x0
  8013b6:	68 00 f0 7f 00       	push   $0x7ff000
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 6b fb ff ff       	call   800f2d <sys_page_map>
	if(ret < 0)
  8013c2:	83 c4 20             	add    $0x20,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 43                	js     80140c <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013c9:	83 ec 08             	sub    $0x8,%esp
  8013cc:	68 00 f0 7f 00       	push   $0x7ff000
  8013d1:	6a 00                	push   $0x0
  8013d3:	e8 97 fb ff ff       	call   800f6f <sys_page_unmap>
	if(ret < 0)
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 41                	js     801420 <pgfault+0xeb>
}
  8013df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 d4 37 80 00       	push   $0x8037d4
  8013ec:	6a 26                	push   $0x26
  8013ee:	68 c9 37 80 00       	push   $0x8037c9
  8013f3:	e8 ab ee ff ff       	call   8002a3 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 e8 37 80 00       	push   $0x8037e8
  801400:	6a 31                	push   $0x31
  801402:	68 c9 37 80 00       	push   $0x8037c9
  801407:	e8 97 ee ff ff       	call   8002a3 <_panic>
		panic("panic in sys_page_map()\n");
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	68 03 38 80 00       	push   $0x803803
  801414:	6a 36                	push   $0x36
  801416:	68 c9 37 80 00       	push   $0x8037c9
  80141b:	e8 83 ee ff ff       	call   8002a3 <_panic>
		panic("panic in sys_page_unmap()\n");
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 1c 38 80 00       	push   $0x80381c
  801428:	6a 39                	push   $0x39
  80142a:	68 c9 37 80 00       	push   $0x8037c9
  80142f:	e8 6f ee ff ff       	call   8002a3 <_panic>

00801434 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	57                   	push   %edi
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
  80143a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80143d:	68 35 13 80 00       	push   $0x801335
  801442:	e8 4a 1a 00 00       	call   802e91 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801447:	b8 07 00 00 00       	mov    $0x7,%eax
  80144c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 2a                	js     80147f <fork+0x4b>
  801455:	89 c6                	mov    %eax,%esi
  801457:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801459:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80145e:	75 4b                	jne    8014ab <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801460:	e8 47 fa ff ff       	call   800eac <sys_getenvid>
  801465:	25 ff 03 00 00       	and    $0x3ff,%eax
  80146a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801470:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801475:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80147a:	e9 90 00 00 00       	jmp    80150f <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	68 38 38 80 00       	push   $0x803838
  801487:	68 8c 00 00 00       	push   $0x8c
  80148c:	68 c9 37 80 00       	push   $0x8037c9
  801491:	e8 0d ee ff ff       	call   8002a3 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801496:	89 f8                	mov    %edi,%eax
  801498:	e8 42 fd ff ff       	call   8011df <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80149d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014a3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014a9:	74 26                	je     8014d1 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014ab:	89 d8                	mov    %ebx,%eax
  8014ad:	c1 e8 16             	shr    $0x16,%eax
  8014b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b7:	a8 01                	test   $0x1,%al
  8014b9:	74 e2                	je     80149d <fork+0x69>
  8014bb:	89 da                	mov    %ebx,%edx
  8014bd:	c1 ea 0c             	shr    $0xc,%edx
  8014c0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014c7:	83 e0 05             	and    $0x5,%eax
  8014ca:	83 f8 05             	cmp    $0x5,%eax
  8014cd:	75 ce                	jne    80149d <fork+0x69>
  8014cf:	eb c5                	jmp    801496 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	6a 07                	push   $0x7
  8014d6:	68 00 f0 bf ee       	push   $0xeebff000
  8014db:	56                   	push   %esi
  8014dc:	e8 09 fa ff ff       	call   800eea <sys_page_alloc>
	if(ret < 0)
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 31                	js     801519 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	68 00 2f 80 00       	push   $0x802f00
  8014f0:	56                   	push   %esi
  8014f1:	e8 3f fb ff ff       	call   801035 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 33                	js     801530 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014fd:	83 ec 08             	sub    $0x8,%esp
  801500:	6a 02                	push   $0x2
  801502:	56                   	push   %esi
  801503:	e8 a9 fa ff ff       	call   800fb1 <sys_env_set_status>
	if(ret < 0)
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 38                	js     801547 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80150f:	89 f0                	mov    %esi,%eax
  801511:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801514:	5b                   	pop    %ebx
  801515:	5e                   	pop    %esi
  801516:	5f                   	pop    %edi
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	68 e8 37 80 00       	push   $0x8037e8
  801521:	68 98 00 00 00       	push   $0x98
  801526:	68 c9 37 80 00       	push   $0x8037c9
  80152b:	e8 73 ed ff ff       	call   8002a3 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	68 5c 38 80 00       	push   $0x80385c
  801538:	68 9b 00 00 00       	push   $0x9b
  80153d:	68 c9 37 80 00       	push   $0x8037c9
  801542:	e8 5c ed ff ff       	call   8002a3 <_panic>
		panic("panic in sys_env_set_status()\n");
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	68 84 38 80 00       	push   $0x803884
  80154f:	68 9e 00 00 00       	push   $0x9e
  801554:	68 c9 37 80 00       	push   $0x8037c9
  801559:	e8 45 ed ff ff       	call   8002a3 <_panic>

0080155e <sfork>:

// Challenge!
int
sfork(void)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801567:	68 35 13 80 00       	push   $0x801335
  80156c:	e8 20 19 00 00       	call   802e91 <set_pgfault_handler>
  801571:	b8 07 00 00 00       	mov    $0x7,%eax
  801576:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 2a                	js     8015a9 <sfork+0x4b>
  80157f:	89 c7                	mov    %eax,%edi
  801581:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801583:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801588:	75 58                	jne    8015e2 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80158a:	e8 1d f9 ff ff       	call   800eac <sys_getenvid>
  80158f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801594:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80159a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80159f:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8015a4:	e9 d4 00 00 00       	jmp    80167d <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	68 38 38 80 00       	push   $0x803838
  8015b1:	68 af 00 00 00       	push   $0xaf
  8015b6:	68 c9 37 80 00       	push   $0x8037c9
  8015bb:	e8 e3 ec ff ff       	call   8002a3 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015c0:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015c5:	89 f0                	mov    %esi,%eax
  8015c7:	e8 13 fc ff ff       	call   8011df <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015cc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015d2:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015d8:	77 65                	ja     80163f <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8015da:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015e0:	74 de                	je     8015c0 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015e2:	89 d8                	mov    %ebx,%eax
  8015e4:	c1 e8 16             	shr    $0x16,%eax
  8015e7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ee:	a8 01                	test   $0x1,%al
  8015f0:	74 da                	je     8015cc <sfork+0x6e>
  8015f2:	89 da                	mov    %ebx,%edx
  8015f4:	c1 ea 0c             	shr    $0xc,%edx
  8015f7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015fe:	83 e0 05             	and    $0x5,%eax
  801601:	83 f8 05             	cmp    $0x5,%eax
  801604:	75 c6                	jne    8015cc <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801606:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80160d:	c1 e2 0c             	shl    $0xc,%edx
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	83 e0 07             	and    $0x7,%eax
  801616:	50                   	push   %eax
  801617:	52                   	push   %edx
  801618:	56                   	push   %esi
  801619:	52                   	push   %edx
  80161a:	6a 00                	push   $0x0
  80161c:	e8 0c f9 ff ff       	call   800f2d <sys_page_map>
  801621:	83 c4 20             	add    $0x20,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	74 a4                	je     8015cc <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	68 b3 37 80 00       	push   $0x8037b3
  801630:	68 ba 00 00 00       	push   $0xba
  801635:	68 c9 37 80 00       	push   $0x8037c9
  80163a:	e8 64 ec ff ff       	call   8002a3 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	6a 07                	push   $0x7
  801644:	68 00 f0 bf ee       	push   $0xeebff000
  801649:	57                   	push   %edi
  80164a:	e8 9b f8 ff ff       	call   800eea <sys_page_alloc>
	if(ret < 0)
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	85 c0                	test   %eax,%eax
  801654:	78 31                	js     801687 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	68 00 2f 80 00       	push   $0x802f00
  80165e:	57                   	push   %edi
  80165f:	e8 d1 f9 ff ff       	call   801035 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	78 33                	js     80169e <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80166b:	83 ec 08             	sub    $0x8,%esp
  80166e:	6a 02                	push   $0x2
  801670:	57                   	push   %edi
  801671:	e8 3b f9 ff ff       	call   800fb1 <sys_env_set_status>
	if(ret < 0)
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 38                	js     8016b5 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80167d:	89 f8                	mov    %edi,%eax
  80167f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5f                   	pop    %edi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	68 e8 37 80 00       	push   $0x8037e8
  80168f:	68 c0 00 00 00       	push   $0xc0
  801694:	68 c9 37 80 00       	push   $0x8037c9
  801699:	e8 05 ec ff ff       	call   8002a3 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 5c 38 80 00       	push   $0x80385c
  8016a6:	68 c3 00 00 00       	push   $0xc3
  8016ab:	68 c9 37 80 00       	push   $0x8037c9
  8016b0:	e8 ee eb ff ff       	call   8002a3 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 84 38 80 00       	push   $0x803884
  8016bd:	68 c6 00 00 00       	push   $0xc6
  8016c2:	68 c9 37 80 00       	push   $0x8037c9
  8016c7:	e8 d7 eb ff ff       	call   8002a3 <_panic>

008016cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	05 00 00 00 30       	add    $0x30000000,%eax
  8016d7:	c1 e8 0c             	shr    $0xc,%eax
}
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016fb:	89 c2                	mov    %eax,%edx
  8016fd:	c1 ea 16             	shr    $0x16,%edx
  801700:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801707:	f6 c2 01             	test   $0x1,%dl
  80170a:	74 2d                	je     801739 <fd_alloc+0x46>
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	c1 ea 0c             	shr    $0xc,%edx
  801711:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801718:	f6 c2 01             	test   $0x1,%dl
  80171b:	74 1c                	je     801739 <fd_alloc+0x46>
  80171d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801722:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801727:	75 d2                	jne    8016fb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801732:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801737:	eb 0a                	jmp    801743 <fd_alloc+0x50>
			*fd_store = fd;
  801739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80174b:	83 f8 1f             	cmp    $0x1f,%eax
  80174e:	77 30                	ja     801780 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801750:	c1 e0 0c             	shl    $0xc,%eax
  801753:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801758:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80175e:	f6 c2 01             	test   $0x1,%dl
  801761:	74 24                	je     801787 <fd_lookup+0x42>
  801763:	89 c2                	mov    %eax,%edx
  801765:	c1 ea 0c             	shr    $0xc,%edx
  801768:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80176f:	f6 c2 01             	test   $0x1,%dl
  801772:	74 1a                	je     80178e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801774:	8b 55 0c             	mov    0xc(%ebp),%edx
  801777:	89 02                	mov    %eax,(%edx)
	return 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    
		return -E_INVAL;
  801780:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801785:	eb f7                	jmp    80177e <fd_lookup+0x39>
		return -E_INVAL;
  801787:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178c:	eb f0                	jmp    80177e <fd_lookup+0x39>
  80178e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801793:	eb e9                	jmp    80177e <fd_lookup+0x39>

00801795 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017a8:	39 08                	cmp    %ecx,(%eax)
  8017aa:	74 38                	je     8017e4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017ac:	83 c2 01             	add    $0x1,%edx
  8017af:	8b 04 95 20 39 80 00 	mov    0x803920(,%edx,4),%eax
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	75 ee                	jne    8017a8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8017bf:	8b 40 48             	mov    0x48(%eax),%eax
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	51                   	push   %ecx
  8017c6:	50                   	push   %eax
  8017c7:	68 a4 38 80 00       	push   $0x8038a4
  8017cc:	e8 c8 eb ff ff       	call   800399 <cprintf>
	*dev = 0;
  8017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    
			*dev = devtab[i];
  8017e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ee:	eb f2                	jmp    8017e2 <dev_lookup+0x4d>

008017f0 <fd_close>:
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	57                   	push   %edi
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 24             	sub    $0x24,%esp
  8017f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8017fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801802:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801803:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801809:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80180c:	50                   	push   %eax
  80180d:	e8 33 ff ff ff       	call   801745 <fd_lookup>
  801812:	89 c3                	mov    %eax,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 05                	js     801820 <fd_close+0x30>
	    || fd != fd2)
  80181b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80181e:	74 16                	je     801836 <fd_close+0x46>
		return (must_exist ? r : 0);
  801820:	89 f8                	mov    %edi,%eax
  801822:	84 c0                	test   %al,%al
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
  801829:	0f 44 d8             	cmove  %eax,%ebx
}
  80182c:	89 d8                	mov    %ebx,%eax
  80182e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5f                   	pop    %edi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80183c:	50                   	push   %eax
  80183d:	ff 36                	pushl  (%esi)
  80183f:	e8 51 ff ff ff       	call   801795 <dev_lookup>
  801844:	89 c3                	mov    %eax,%ebx
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	78 1a                	js     801867 <fd_close+0x77>
		if (dev->dev_close)
  80184d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801850:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801853:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801858:	85 c0                	test   %eax,%eax
  80185a:	74 0b                	je     801867 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80185c:	83 ec 0c             	sub    $0xc,%esp
  80185f:	56                   	push   %esi
  801860:	ff d0                	call   *%eax
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801867:	83 ec 08             	sub    $0x8,%esp
  80186a:	56                   	push   %esi
  80186b:	6a 00                	push   $0x0
  80186d:	e8 fd f6 ff ff       	call   800f6f <sys_page_unmap>
	return r;
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	eb b5                	jmp    80182c <fd_close+0x3c>

00801877 <close>:

int
close(int fdnum)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801880:	50                   	push   %eax
  801881:	ff 75 08             	pushl  0x8(%ebp)
  801884:	e8 bc fe ff ff       	call   801745 <fd_lookup>
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	79 02                	jns    801892 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    
		return fd_close(fd, 1);
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	6a 01                	push   $0x1
  801897:	ff 75 f4             	pushl  -0xc(%ebp)
  80189a:	e8 51 ff ff ff       	call   8017f0 <fd_close>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	eb ec                	jmp    801890 <close+0x19>

008018a4 <close_all>:

void
close_all(void)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018b0:	83 ec 0c             	sub    $0xc,%esp
  8018b3:	53                   	push   %ebx
  8018b4:	e8 be ff ff ff       	call   801877 <close>
	for (i = 0; i < MAXFD; i++)
  8018b9:	83 c3 01             	add    $0x1,%ebx
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	83 fb 20             	cmp    $0x20,%ebx
  8018c2:	75 ec                	jne    8018b0 <close_all+0xc>
}
  8018c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	57                   	push   %edi
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018d5:	50                   	push   %eax
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	e8 67 fe ff ff       	call   801745 <fd_lookup>
  8018de:	89 c3                	mov    %eax,%ebx
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	0f 88 81 00 00 00    	js     80196c <dup+0xa3>
		return r;
	close(newfdnum);
  8018eb:	83 ec 0c             	sub    $0xc,%esp
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	e8 81 ff ff ff       	call   801877 <close>

	newfd = INDEX2FD(newfdnum);
  8018f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018f9:	c1 e6 0c             	shl    $0xc,%esi
  8018fc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801902:	83 c4 04             	add    $0x4,%esp
  801905:	ff 75 e4             	pushl  -0x1c(%ebp)
  801908:	e8 cf fd ff ff       	call   8016dc <fd2data>
  80190d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80190f:	89 34 24             	mov    %esi,(%esp)
  801912:	e8 c5 fd ff ff       	call   8016dc <fd2data>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	c1 e8 16             	shr    $0x16,%eax
  801921:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801928:	a8 01                	test   $0x1,%al
  80192a:	74 11                	je     80193d <dup+0x74>
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	c1 e8 0c             	shr    $0xc,%eax
  801931:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801938:	f6 c2 01             	test   $0x1,%dl
  80193b:	75 39                	jne    801976 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80193d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801940:	89 d0                	mov    %edx,%eax
  801942:	c1 e8 0c             	shr    $0xc,%eax
  801945:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	25 07 0e 00 00       	and    $0xe07,%eax
  801954:	50                   	push   %eax
  801955:	56                   	push   %esi
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	6a 00                	push   $0x0
  80195b:	e8 cd f5 ff ff       	call   800f2d <sys_page_map>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 20             	add    $0x20,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 31                	js     80199a <dup+0xd1>
		goto err;

	return newfdnum;
  801969:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80196c:	89 d8                	mov    %ebx,%eax
  80196e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5f                   	pop    %edi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801976:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	25 07 0e 00 00       	and    $0xe07,%eax
  801985:	50                   	push   %eax
  801986:	57                   	push   %edi
  801987:	6a 00                	push   $0x0
  801989:	53                   	push   %ebx
  80198a:	6a 00                	push   $0x0
  80198c:	e8 9c f5 ff ff       	call   800f2d <sys_page_map>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	83 c4 20             	add    $0x20,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	79 a3                	jns    80193d <dup+0x74>
	sys_page_unmap(0, newfd);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	56                   	push   %esi
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 ca f5 ff ff       	call   800f6f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019a5:	83 c4 08             	add    $0x8,%esp
  8019a8:	57                   	push   %edi
  8019a9:	6a 00                	push   $0x0
  8019ab:	e8 bf f5 ff ff       	call   800f6f <sys_page_unmap>
	return r;
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	eb b7                	jmp    80196c <dup+0xa3>

008019b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 1c             	sub    $0x1c,%esp
  8019bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c2:	50                   	push   %eax
  8019c3:	53                   	push   %ebx
  8019c4:	e8 7c fd ff ff       	call   801745 <fd_lookup>
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 3f                	js     801a0f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d6:	50                   	push   %eax
  8019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019da:	ff 30                	pushl  (%eax)
  8019dc:	e8 b4 fd ff ff       	call   801795 <dev_lookup>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 27                	js     801a0f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019eb:	8b 42 08             	mov    0x8(%edx),%eax
  8019ee:	83 e0 03             	and    $0x3,%eax
  8019f1:	83 f8 01             	cmp    $0x1,%eax
  8019f4:	74 1e                	je     801a14 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f9:	8b 40 08             	mov    0x8(%eax),%eax
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	74 35                	je     801a35 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	ff 75 10             	pushl  0x10(%ebp)
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	52                   	push   %edx
  801a0a:	ff d0                	call   *%eax
  801a0c:	83 c4 10             	add    $0x10,%esp
}
  801a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a14:	a1 08 50 80 00       	mov    0x805008,%eax
  801a19:	8b 40 48             	mov    0x48(%eax),%eax
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	53                   	push   %ebx
  801a20:	50                   	push   %eax
  801a21:	68 e5 38 80 00       	push   $0x8038e5
  801a26:	e8 6e e9 ff ff       	call   800399 <cprintf>
		return -E_INVAL;
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a33:	eb da                	jmp    801a0f <read+0x5a>
		return -E_NOT_SUPP;
  801a35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a3a:	eb d3                	jmp    801a0f <read+0x5a>

00801a3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	57                   	push   %edi
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 0c             	sub    $0xc,%esp
  801a45:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a48:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a50:	39 f3                	cmp    %esi,%ebx
  801a52:	73 23                	jae    801a77 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	89 f0                	mov    %esi,%eax
  801a59:	29 d8                	sub    %ebx,%eax
  801a5b:	50                   	push   %eax
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	03 45 0c             	add    0xc(%ebp),%eax
  801a61:	50                   	push   %eax
  801a62:	57                   	push   %edi
  801a63:	e8 4d ff ff ff       	call   8019b5 <read>
		if (m < 0)
  801a68:	83 c4 10             	add    $0x10,%esp
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	78 06                	js     801a75 <readn+0x39>
			return m;
		if (m == 0)
  801a6f:	74 06                	je     801a77 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a71:	01 c3                	add    %eax,%ebx
  801a73:	eb db                	jmp    801a50 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a75:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a77:	89 d8                	mov    %ebx,%eax
  801a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    

00801a81 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	53                   	push   %ebx
  801a85:	83 ec 1c             	sub    $0x1c,%esp
  801a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a8e:	50                   	push   %eax
  801a8f:	53                   	push   %ebx
  801a90:	e8 b0 fc ff ff       	call   801745 <fd_lookup>
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 3a                	js     801ad6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a9c:	83 ec 08             	sub    $0x8,%esp
  801a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa2:	50                   	push   %eax
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	ff 30                	pushl  (%eax)
  801aa8:	e8 e8 fc ff ff       	call   801795 <dev_lookup>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 22                	js     801ad6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801abb:	74 1e                	je     801adb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac0:	8b 52 0c             	mov    0xc(%edx),%edx
  801ac3:	85 d2                	test   %edx,%edx
  801ac5:	74 35                	je     801afc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	ff 75 10             	pushl  0x10(%ebp)
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	50                   	push   %eax
  801ad1:	ff d2                	call   *%edx
  801ad3:	83 c4 10             	add    $0x10,%esp
}
  801ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801adb:	a1 08 50 80 00       	mov    0x805008,%eax
  801ae0:	8b 40 48             	mov    0x48(%eax),%eax
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	53                   	push   %ebx
  801ae7:	50                   	push   %eax
  801ae8:	68 01 39 80 00       	push   $0x803901
  801aed:	e8 a7 e8 ff ff       	call   800399 <cprintf>
		return -E_INVAL;
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801afa:	eb da                	jmp    801ad6 <write+0x55>
		return -E_NOT_SUPP;
  801afc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b01:	eb d3                	jmp    801ad6 <write+0x55>

00801b03 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	ff 75 08             	pushl  0x8(%ebp)
  801b10:	e8 30 fc ff ff       	call   801745 <fd_lookup>
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 0e                	js     801b2a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b22:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 1c             	sub    $0x1c,%esp
  801b33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b39:	50                   	push   %eax
  801b3a:	53                   	push   %ebx
  801b3b:	e8 05 fc ff ff       	call   801745 <fd_lookup>
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 37                	js     801b7e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4d:	50                   	push   %eax
  801b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b51:	ff 30                	pushl  (%eax)
  801b53:	e8 3d fc ff ff       	call   801795 <dev_lookup>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 1f                	js     801b7e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b62:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b66:	74 1b                	je     801b83 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6b:	8b 52 18             	mov    0x18(%edx),%edx
  801b6e:	85 d2                	test   %edx,%edx
  801b70:	74 32                	je     801ba4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b72:	83 ec 08             	sub    $0x8,%esp
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	ff d2                	call   *%edx
  801b7b:	83 c4 10             	add    $0x10,%esp
}
  801b7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b83:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b88:	8b 40 48             	mov    0x48(%eax),%eax
  801b8b:	83 ec 04             	sub    $0x4,%esp
  801b8e:	53                   	push   %ebx
  801b8f:	50                   	push   %eax
  801b90:	68 c4 38 80 00       	push   $0x8038c4
  801b95:	e8 ff e7 ff ff       	call   800399 <cprintf>
		return -E_INVAL;
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba2:	eb da                	jmp    801b7e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801ba4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba9:	eb d3                	jmp    801b7e <ftruncate+0x52>

00801bab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	53                   	push   %ebx
  801baf:	83 ec 1c             	sub    $0x1c,%esp
  801bb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bb5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb8:	50                   	push   %eax
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	e8 84 fb ff ff       	call   801745 <fd_lookup>
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 4b                	js     801c13 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bce:	50                   	push   %eax
  801bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd2:	ff 30                	pushl  (%eax)
  801bd4:	e8 bc fb ff ff       	call   801795 <dev_lookup>
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 33                	js     801c13 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801be7:	74 2f                	je     801c18 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801be9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bf3:	00 00 00 
	stat->st_isdir = 0;
  801bf6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bfd:	00 00 00 
	stat->st_dev = dev;
  801c00:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c06:	83 ec 08             	sub    $0x8,%esp
  801c09:	53                   	push   %ebx
  801c0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c0d:	ff 50 14             	call   *0x14(%eax)
  801c10:	83 c4 10             	add    $0x10,%esp
}
  801c13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    
		return -E_NOT_SUPP;
  801c18:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c1d:	eb f4                	jmp    801c13 <fstat+0x68>

00801c1f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	56                   	push   %esi
  801c23:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 08             	pushl  0x8(%ebp)
  801c2c:	e8 22 02 00 00       	call   801e53 <open>
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	78 1b                	js     801c55 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c3a:	83 ec 08             	sub    $0x8,%esp
  801c3d:	ff 75 0c             	pushl  0xc(%ebp)
  801c40:	50                   	push   %eax
  801c41:	e8 65 ff ff ff       	call   801bab <fstat>
  801c46:	89 c6                	mov    %eax,%esi
	close(fd);
  801c48:	89 1c 24             	mov    %ebx,(%esp)
  801c4b:	e8 27 fc ff ff       	call   801877 <close>
	return r;
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	89 f3                	mov    %esi,%ebx
}
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5a:	5b                   	pop    %ebx
  801c5b:	5e                   	pop    %esi
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    

00801c5e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	56                   	push   %esi
  801c62:	53                   	push   %ebx
  801c63:	89 c6                	mov    %eax,%esi
  801c65:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c67:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c6e:	74 27                	je     801c97 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c70:	6a 07                	push   $0x7
  801c72:	68 00 60 80 00       	push   $0x806000
  801c77:	56                   	push   %esi
  801c78:	ff 35 00 50 80 00    	pushl  0x805000
  801c7e:	e8 0c 13 00 00       	call   802f8f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c83:	83 c4 0c             	add    $0xc,%esp
  801c86:	6a 00                	push   $0x0
  801c88:	53                   	push   %ebx
  801c89:	6a 00                	push   $0x0
  801c8b:	e8 96 12 00 00       	call   802f26 <ipc_recv>
}
  801c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	6a 01                	push   $0x1
  801c9c:	e8 46 13 00 00       	call   802fe7 <ipc_find_env>
  801ca1:	a3 00 50 80 00       	mov    %eax,0x805000
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	eb c5                	jmp    801c70 <fsipc+0x12>

00801cab <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc9:	b8 02 00 00 00       	mov    $0x2,%eax
  801cce:	e8 8b ff ff ff       	call   801c5e <fsipc>
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <devfile_flush>:
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce1:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ceb:	b8 06 00 00 00       	mov    $0x6,%eax
  801cf0:	e8 69 ff ff ff       	call   801c5e <fsipc>
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <devfile_stat>:
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	8b 40 0c             	mov    0xc(%eax),%eax
  801d07:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d11:	b8 05 00 00 00       	mov    $0x5,%eax
  801d16:	e8 43 ff ff ff       	call   801c5e <fsipc>
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 2c                	js     801d4b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	68 00 60 80 00       	push   $0x806000
  801d27:	53                   	push   %ebx
  801d28:	e8 cb ed ff ff       	call   800af8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d2d:	a1 80 60 80 00       	mov    0x806080,%eax
  801d32:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d38:	a1 84 60 80 00       	mov    0x806084,%eax
  801d3d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <devfile_write>:
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	53                   	push   %ebx
  801d54:	83 ec 08             	sub    $0x8,%esp
  801d57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d60:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d65:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d6b:	53                   	push   %ebx
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	68 08 60 80 00       	push   $0x806008
  801d74:	e8 6f ef ff ff       	call   800ce8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d79:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d83:	e8 d6 fe ff ff       	call   801c5e <fsipc>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 0b                	js     801d9a <devfile_write+0x4a>
	assert(r <= n);
  801d8f:	39 d8                	cmp    %ebx,%eax
  801d91:	77 0c                	ja     801d9f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d93:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d98:	7f 1e                	jg     801db8 <devfile_write+0x68>
}
  801d9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    
	assert(r <= n);
  801d9f:	68 34 39 80 00       	push   $0x803934
  801da4:	68 3b 39 80 00       	push   $0x80393b
  801da9:	68 98 00 00 00       	push   $0x98
  801dae:	68 50 39 80 00       	push   $0x803950
  801db3:	e8 eb e4 ff ff       	call   8002a3 <_panic>
	assert(r <= PGSIZE);
  801db8:	68 5b 39 80 00       	push   $0x80395b
  801dbd:	68 3b 39 80 00       	push   $0x80393b
  801dc2:	68 99 00 00 00       	push   $0x99
  801dc7:	68 50 39 80 00       	push   $0x803950
  801dcc:	e8 d2 e4 ff ff       	call   8002a3 <_panic>

00801dd1 <devfile_read>:
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	56                   	push   %esi
  801dd5:	53                   	push   %ebx
  801dd6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddf:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801de4:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dea:	ba 00 00 00 00       	mov    $0x0,%edx
  801def:	b8 03 00 00 00       	mov    $0x3,%eax
  801df4:	e8 65 fe ff ff       	call   801c5e <fsipc>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	78 1f                	js     801e1e <devfile_read+0x4d>
	assert(r <= n);
  801dff:	39 f0                	cmp    %esi,%eax
  801e01:	77 24                	ja     801e27 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e03:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e08:	7f 33                	jg     801e3d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	50                   	push   %eax
  801e0e:	68 00 60 80 00       	push   $0x806000
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	e8 6b ee ff ff       	call   800c86 <memmove>
	return r;
  801e1b:	83 c4 10             	add    $0x10,%esp
}
  801e1e:	89 d8                	mov    %ebx,%eax
  801e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    
	assert(r <= n);
  801e27:	68 34 39 80 00       	push   $0x803934
  801e2c:	68 3b 39 80 00       	push   $0x80393b
  801e31:	6a 7c                	push   $0x7c
  801e33:	68 50 39 80 00       	push   $0x803950
  801e38:	e8 66 e4 ff ff       	call   8002a3 <_panic>
	assert(r <= PGSIZE);
  801e3d:	68 5b 39 80 00       	push   $0x80395b
  801e42:	68 3b 39 80 00       	push   $0x80393b
  801e47:	6a 7d                	push   $0x7d
  801e49:	68 50 39 80 00       	push   $0x803950
  801e4e:	e8 50 e4 ff ff       	call   8002a3 <_panic>

00801e53 <open>:
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e5e:	56                   	push   %esi
  801e5f:	e8 5b ec ff ff       	call   800abf <strlen>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e6c:	7f 6c                	jg     801eda <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e74:	50                   	push   %eax
  801e75:	e8 79 f8 ff ff       	call   8016f3 <fd_alloc>
  801e7a:	89 c3                	mov    %eax,%ebx
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	78 3c                	js     801ebf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e83:	83 ec 08             	sub    $0x8,%esp
  801e86:	56                   	push   %esi
  801e87:	68 00 60 80 00       	push   $0x806000
  801e8c:	e8 67 ec ff ff       	call   800af8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e94:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea1:	e8 b8 fd ff ff       	call   801c5e <fsipc>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	85 c0                	test   %eax,%eax
  801ead:	78 19                	js     801ec8 <open+0x75>
	return fd2num(fd);
  801eaf:	83 ec 0c             	sub    $0xc,%esp
  801eb2:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb5:	e8 12 f8 ff ff       	call   8016cc <fd2num>
  801eba:	89 c3                	mov    %eax,%ebx
  801ebc:	83 c4 10             	add    $0x10,%esp
}
  801ebf:	89 d8                	mov    %ebx,%eax
  801ec1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    
		fd_close(fd, 0);
  801ec8:	83 ec 08             	sub    $0x8,%esp
  801ecb:	6a 00                	push   $0x0
  801ecd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed0:	e8 1b f9 ff ff       	call   8017f0 <fd_close>
		return r;
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	eb e5                	jmp    801ebf <open+0x6c>
		return -E_BAD_PATH;
  801eda:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801edf:	eb de                	jmp    801ebf <open+0x6c>

00801ee1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eec:	b8 08 00 00 00       	mov    $0x8,%eax
  801ef1:	e8 68 fd ff ff       	call   801c5e <fsipc>
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	57                   	push   %edi
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801f04:	68 40 3a 80 00       	push   $0x803a40
  801f09:	68 c9 33 80 00       	push   $0x8033c9
  801f0e:	e8 86 e4 ff ff       	call   800399 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801f13:	83 c4 08             	add    $0x8,%esp
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 08             	pushl  0x8(%ebp)
  801f1b:	e8 33 ff ff ff       	call   801e53 <open>
  801f20:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	0f 88 0b 05 00 00    	js     80243c <spawn+0x544>
  801f31:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f33:	83 ec 04             	sub    $0x4,%esp
  801f36:	68 00 02 00 00       	push   $0x200
  801f3b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f41:	50                   	push   %eax
  801f42:	51                   	push   %ecx
  801f43:	e8 f4 fa ff ff       	call   801a3c <readn>
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f50:	75 75                	jne    801fc7 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801f52:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f59:	45 4c 46 
  801f5c:	75 69                	jne    801fc7 <spawn+0xcf>
  801f5e:	b8 07 00 00 00       	mov    $0x7,%eax
  801f63:	cd 30                	int    $0x30
  801f65:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801f6b:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801f71:	85 c0                	test   %eax,%eax
  801f73:	0f 88 b7 04 00 00    	js     802430 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f79:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f7e:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801f84:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f8a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f90:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f95:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f97:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f9d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801fa3:	83 ec 08             	sub    $0x8,%esp
  801fa6:	68 34 3a 80 00       	push   $0x803a34
  801fab:	68 c9 33 80 00       	push   $0x8033c9
  801fb0:	e8 e4 e3 ff ff       	call   800399 <cprintf>
  801fb5:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fb8:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801fbd:	be 00 00 00 00       	mov    $0x0,%esi
  801fc2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801fc5:	eb 4b                	jmp    802012 <spawn+0x11a>
		close(fd);
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fd0:	e8 a2 f8 ff ff       	call   801877 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801fd5:	83 c4 0c             	add    $0xc,%esp
  801fd8:	68 7f 45 4c 46       	push   $0x464c457f
  801fdd:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801fe3:	68 67 39 80 00       	push   $0x803967
  801fe8:	e8 ac e3 ff ff       	call   800399 <cprintf>
		return -E_NOT_EXEC;
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801ff7:	ff ff ff 
  801ffa:	e9 3d 04 00 00       	jmp    80243c <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  801fff:	83 ec 0c             	sub    $0xc,%esp
  802002:	50                   	push   %eax
  802003:	e8 b7 ea ff ff       	call   800abf <strlen>
  802008:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80200c:	83 c3 01             	add    $0x1,%ebx
  80200f:	83 c4 10             	add    $0x10,%esp
  802012:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802019:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80201c:	85 c0                	test   %eax,%eax
  80201e:	75 df                	jne    801fff <spawn+0x107>
  802020:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802026:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80202c:	bf 00 10 40 00       	mov    $0x401000,%edi
  802031:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802033:	89 fa                	mov    %edi,%edx
  802035:	83 e2 fc             	and    $0xfffffffc,%edx
  802038:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80203f:	29 c2                	sub    %eax,%edx
  802041:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802047:	8d 42 f8             	lea    -0x8(%edx),%eax
  80204a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80204f:	0f 86 0a 04 00 00    	jbe    80245f <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	6a 07                	push   $0x7
  80205a:	68 00 00 40 00       	push   $0x400000
  80205f:	6a 00                	push   $0x0
  802061:	e8 84 ee ff ff       	call   800eea <sys_page_alloc>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	0f 88 f3 03 00 00    	js     802464 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802071:	be 00 00 00 00       	mov    $0x0,%esi
  802076:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80207c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80207f:	eb 30                	jmp    8020b1 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  802081:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802087:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80208d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802090:	83 ec 08             	sub    $0x8,%esp
  802093:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802096:	57                   	push   %edi
  802097:	e8 5c ea ff ff       	call   800af8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80209c:	83 c4 04             	add    $0x4,%esp
  80209f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8020a2:	e8 18 ea ff ff       	call   800abf <strlen>
  8020a7:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8020ab:	83 c6 01             	add    $0x1,%esi
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8020b7:	7f c8                	jg     802081 <spawn+0x189>
	}
	argv_store[argc] = 0;
  8020b9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020bf:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8020c5:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020cc:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8020d2:	0f 85 86 00 00 00    	jne    80215e <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8020d8:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8020de:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8020e4:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8020e7:	89 d0                	mov    %edx,%eax
  8020e9:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8020ef:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8020f2:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8020f7:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	6a 07                	push   $0x7
  802102:	68 00 d0 bf ee       	push   $0xeebfd000
  802107:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80210d:	68 00 00 40 00       	push   $0x400000
  802112:	6a 00                	push   $0x0
  802114:	e8 14 ee ff ff       	call   800f2d <sys_page_map>
  802119:	89 c3                	mov    %eax,%ebx
  80211b:	83 c4 20             	add    $0x20,%esp
  80211e:	85 c0                	test   %eax,%eax
  802120:	0f 88 46 03 00 00    	js     80246c <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802126:	83 ec 08             	sub    $0x8,%esp
  802129:	68 00 00 40 00       	push   $0x400000
  80212e:	6a 00                	push   $0x0
  802130:	e8 3a ee ff ff       	call   800f6f <sys_page_unmap>
  802135:	89 c3                	mov    %eax,%ebx
  802137:	83 c4 10             	add    $0x10,%esp
  80213a:	85 c0                	test   %eax,%eax
  80213c:	0f 88 2a 03 00 00    	js     80246c <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802142:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802148:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80214f:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802156:	00 00 00 
  802159:	e9 4f 01 00 00       	jmp    8022ad <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80215e:	68 f0 39 80 00       	push   $0x8039f0
  802163:	68 3b 39 80 00       	push   $0x80393b
  802168:	68 f8 00 00 00       	push   $0xf8
  80216d:	68 81 39 80 00       	push   $0x803981
  802172:	e8 2c e1 ff ff       	call   8002a3 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	6a 07                	push   $0x7
  80217c:	68 00 00 40 00       	push   $0x400000
  802181:	6a 00                	push   $0x0
  802183:	e8 62 ed ff ff       	call   800eea <sys_page_alloc>
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	85 c0                	test   %eax,%eax
  80218d:	0f 88 b7 02 00 00    	js     80244a <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802193:	83 ec 08             	sub    $0x8,%esp
  802196:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80219c:	01 f0                	add    %esi,%eax
  80219e:	50                   	push   %eax
  80219f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021a5:	e8 59 f9 ff ff       	call   801b03 <seek>
  8021aa:	83 c4 10             	add    $0x10,%esp
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	0f 88 9c 02 00 00    	js     802451 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021be:	29 f0                	sub    %esi,%eax
  8021c0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8021c5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021ca:	0f 47 c1             	cmova  %ecx,%eax
  8021cd:	50                   	push   %eax
  8021ce:	68 00 00 40 00       	push   $0x400000
  8021d3:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021d9:	e8 5e f8 ff ff       	call   801a3c <readn>
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	0f 88 6f 02 00 00    	js     802458 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021f2:	53                   	push   %ebx
  8021f3:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021f9:	68 00 00 40 00       	push   $0x400000
  8021fe:	6a 00                	push   $0x0
  802200:	e8 28 ed ff ff       	call   800f2d <sys_page_map>
  802205:	83 c4 20             	add    $0x20,%esp
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 7c                	js     802288 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80220c:	83 ec 08             	sub    $0x8,%esp
  80220f:	68 00 00 40 00       	push   $0x400000
  802214:	6a 00                	push   $0x0
  802216:	e8 54 ed ff ff       	call   800f6f <sys_page_unmap>
  80221b:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80221e:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802224:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80222a:	89 fe                	mov    %edi,%esi
  80222c:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802232:	76 69                	jbe    80229d <spawn+0x3a5>
		if (i >= filesz) {
  802234:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  80223a:	0f 87 37 ff ff ff    	ja     802177 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802249:	53                   	push   %ebx
  80224a:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802250:	e8 95 ec ff ff       	call   800eea <sys_page_alloc>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	85 c0                	test   %eax,%eax
  80225a:	79 c2                	jns    80221e <spawn+0x326>
  80225c:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802267:	e8 ff eb ff ff       	call   800e6b <sys_env_destroy>
	close(fd);
  80226c:	83 c4 04             	add    $0x4,%esp
  80226f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802275:	e8 fd f5 ff ff       	call   801877 <close>
	return r;
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802283:	e9 b4 01 00 00       	jmp    80243c <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  802288:	50                   	push   %eax
  802289:	68 8d 39 80 00       	push   $0x80398d
  80228e:	68 2b 01 00 00       	push   $0x12b
  802293:	68 81 39 80 00       	push   $0x803981
  802298:	e8 06 e0 ff ff       	call   8002a3 <_panic>
  80229d:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8022a3:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8022aa:	83 c6 20             	add    $0x20,%esi
  8022ad:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8022b4:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8022ba:	7e 6d                	jle    802329 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  8022bc:	83 3e 01             	cmpl   $0x1,(%esi)
  8022bf:	75 e2                	jne    8022a3 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8022c1:	8b 46 18             	mov    0x18(%esi),%eax
  8022c4:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8022c7:	83 f8 01             	cmp    $0x1,%eax
  8022ca:	19 c0                	sbb    %eax,%eax
  8022cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8022cf:	83 c0 07             	add    $0x7,%eax
  8022d2:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8022d8:	8b 4e 04             	mov    0x4(%esi),%ecx
  8022db:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8022e1:	8b 56 10             	mov    0x10(%esi),%edx
  8022e4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8022ea:	8b 7e 14             	mov    0x14(%esi),%edi
  8022ed:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8022f3:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8022f6:	89 d8                	mov    %ebx,%eax
  8022f8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022fd:	74 1a                	je     802319 <spawn+0x421>
		va -= i;
  8022ff:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802301:	01 c7                	add    %eax,%edi
  802303:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802309:	01 c2                	add    %eax,%edx
  80230b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802311:	29 c1                	sub    %eax,%ecx
  802313:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802319:	bf 00 00 00 00       	mov    $0x0,%edi
  80231e:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802324:	e9 01 ff ff ff       	jmp    80222a <spawn+0x332>
	close(fd);
  802329:	83 ec 0c             	sub    $0xc,%esp
  80232c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802332:	e8 40 f5 ff ff       	call   801877 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  802337:	83 c4 08             	add    $0x8,%esp
  80233a:	68 20 3a 80 00       	push   $0x803a20
  80233f:	68 c9 33 80 00       	push   $0x8033c9
  802344:	e8 50 e0 ff ff       	call   800399 <cprintf>
  802349:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80234c:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802351:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802357:	eb 0e                	jmp    802367 <spawn+0x46f>
  802359:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80235f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802365:	74 5e                	je     8023c5 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802367:	89 d8                	mov    %ebx,%eax
  802369:	c1 e8 16             	shr    $0x16,%eax
  80236c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802373:	a8 01                	test   $0x1,%al
  802375:	74 e2                	je     802359 <spawn+0x461>
  802377:	89 da                	mov    %ebx,%edx
  802379:	c1 ea 0c             	shr    $0xc,%edx
  80237c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802383:	25 05 04 00 00       	and    $0x405,%eax
  802388:	3d 05 04 00 00       	cmp    $0x405,%eax
  80238d:	75 ca                	jne    802359 <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  80238f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	25 07 0e 00 00       	and    $0xe07,%eax
  80239e:	50                   	push   %eax
  80239f:	53                   	push   %ebx
  8023a0:	56                   	push   %esi
  8023a1:	53                   	push   %ebx
  8023a2:	6a 00                	push   $0x0
  8023a4:	e8 84 eb ff ff       	call   800f2d <sys_page_map>
  8023a9:	83 c4 20             	add    $0x20,%esp
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	79 a9                	jns    802359 <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  8023b0:	50                   	push   %eax
  8023b1:	68 aa 39 80 00       	push   $0x8039aa
  8023b6:	68 3b 01 00 00       	push   $0x13b
  8023bb:	68 81 39 80 00       	push   $0x803981
  8023c0:	e8 de de ff ff       	call   8002a3 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8023c5:	83 ec 08             	sub    $0x8,%esp
  8023c8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8023ce:	50                   	push   %eax
  8023cf:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023d5:	e8 19 ec ff ff       	call   800ff3 <sys_env_set_trapframe>
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	78 25                	js     802406 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8023e1:	83 ec 08             	sub    $0x8,%esp
  8023e4:	6a 02                	push   $0x2
  8023e6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023ec:	e8 c0 eb ff ff       	call   800fb1 <sys_env_set_status>
  8023f1:	83 c4 10             	add    $0x10,%esp
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	78 23                	js     80241b <spawn+0x523>
	return child;
  8023f8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023fe:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802404:	eb 36                	jmp    80243c <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  802406:	50                   	push   %eax
  802407:	68 bc 39 80 00       	push   $0x8039bc
  80240c:	68 8a 00 00 00       	push   $0x8a
  802411:	68 81 39 80 00       	push   $0x803981
  802416:	e8 88 de ff ff       	call   8002a3 <_panic>
		panic("sys_env_set_status: %e", r);
  80241b:	50                   	push   %eax
  80241c:	68 d6 39 80 00       	push   $0x8039d6
  802421:	68 8d 00 00 00       	push   $0x8d
  802426:	68 81 39 80 00       	push   $0x803981
  80242b:	e8 73 de ff ff       	call   8002a3 <_panic>
		return r;
  802430:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802436:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80243c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5f                   	pop    %edi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    
  80244a:	89 c7                	mov    %eax,%edi
  80244c:	e9 0d fe ff ff       	jmp    80225e <spawn+0x366>
  802451:	89 c7                	mov    %eax,%edi
  802453:	e9 06 fe ff ff       	jmp    80225e <spawn+0x366>
  802458:	89 c7                	mov    %eax,%edi
  80245a:	e9 ff fd ff ff       	jmp    80225e <spawn+0x366>
		return -E_NO_MEM;
  80245f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802464:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80246a:	eb d0                	jmp    80243c <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  80246c:	83 ec 08             	sub    $0x8,%esp
  80246f:	68 00 00 40 00       	push   $0x400000
  802474:	6a 00                	push   $0x0
  802476:	e8 f4 ea ff ff       	call   800f6f <sys_page_unmap>
  80247b:	83 c4 10             	add    $0x10,%esp
  80247e:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802484:	eb b6                	jmp    80243c <spawn+0x544>

00802486 <spawnl>:
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	57                   	push   %edi
  80248a:	56                   	push   %esi
  80248b:	53                   	push   %ebx
  80248c:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  80248f:	68 18 3a 80 00       	push   $0x803a18
  802494:	68 c9 33 80 00       	push   $0x8033c9
  802499:	e8 fb de ff ff       	call   800399 <cprintf>
	va_start(vl, arg0);
  80249e:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  8024a1:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8024a9:	8d 4a 04             	lea    0x4(%edx),%ecx
  8024ac:	83 3a 00             	cmpl   $0x0,(%edx)
  8024af:	74 07                	je     8024b8 <spawnl+0x32>
		argc++;
  8024b1:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8024b4:	89 ca                	mov    %ecx,%edx
  8024b6:	eb f1                	jmp    8024a9 <spawnl+0x23>
	const char *argv[argc+2];
  8024b8:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8024bf:	83 e2 f0             	and    $0xfffffff0,%edx
  8024c2:	29 d4                	sub    %edx,%esp
  8024c4:	8d 54 24 03          	lea    0x3(%esp),%edx
  8024c8:	c1 ea 02             	shr    $0x2,%edx
  8024cb:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8024d2:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8024d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d7:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8024de:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8024e5:	00 
	va_start(vl, arg0);
  8024e6:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8024e9:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f0:	eb 0b                	jmp    8024fd <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8024f2:	83 c0 01             	add    $0x1,%eax
  8024f5:	8b 39                	mov    (%ecx),%edi
  8024f7:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8024fa:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8024fd:	39 d0                	cmp    %edx,%eax
  8024ff:	75 f1                	jne    8024f2 <spawnl+0x6c>
	return spawn(prog, argv);
  802501:	83 ec 08             	sub    $0x8,%esp
  802504:	56                   	push   %esi
  802505:	ff 75 08             	pushl  0x8(%ebp)
  802508:	e8 eb f9 ff ff       	call   801ef8 <spawn>
}
  80250d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    

00802515 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80251b:	68 46 3a 80 00       	push   $0x803a46
  802520:	ff 75 0c             	pushl  0xc(%ebp)
  802523:	e8 d0 e5 ff ff       	call   800af8 <strcpy>
	return 0;
}
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <devsock_close>:
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	53                   	push   %ebx
  802533:	83 ec 10             	sub    $0x10,%esp
  802536:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802539:	53                   	push   %ebx
  80253a:	e8 e7 0a 00 00       	call   803026 <pageref>
  80253f:	83 c4 10             	add    $0x10,%esp
		return 0;
  802542:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802547:	83 f8 01             	cmp    $0x1,%eax
  80254a:	74 07                	je     802553 <devsock_close+0x24>
}
  80254c:	89 d0                	mov    %edx,%eax
  80254e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802551:	c9                   	leave  
  802552:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802553:	83 ec 0c             	sub    $0xc,%esp
  802556:	ff 73 0c             	pushl  0xc(%ebx)
  802559:	e8 b9 02 00 00       	call   802817 <nsipc_close>
  80255e:	89 c2                	mov    %eax,%edx
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	eb e7                	jmp    80254c <devsock_close+0x1d>

00802565 <devsock_write>:
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80256b:	6a 00                	push   $0x0
  80256d:	ff 75 10             	pushl  0x10(%ebp)
  802570:	ff 75 0c             	pushl  0xc(%ebp)
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	ff 70 0c             	pushl  0xc(%eax)
  802579:	e8 76 03 00 00       	call   8028f4 <nsipc_send>
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <devsock_read>:
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802586:	6a 00                	push   $0x0
  802588:	ff 75 10             	pushl  0x10(%ebp)
  80258b:	ff 75 0c             	pushl  0xc(%ebp)
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	ff 70 0c             	pushl  0xc(%eax)
  802594:	e8 ef 02 00 00       	call   802888 <nsipc_recv>
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <fd2sockid>:
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8025a1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025a4:	52                   	push   %edx
  8025a5:	50                   	push   %eax
  8025a6:	e8 9a f1 ff ff       	call   801745 <fd_lookup>
  8025ab:	83 c4 10             	add    $0x10,%esp
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 10                	js     8025c2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  8025bb:	39 08                	cmp    %ecx,(%eax)
  8025bd:	75 05                	jne    8025c4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    
		return -E_NOT_SUPP;
  8025c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025c9:	eb f7                	jmp    8025c2 <fd2sockid+0x27>

008025cb <alloc_sockfd>:
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	56                   	push   %esi
  8025cf:	53                   	push   %ebx
  8025d0:	83 ec 1c             	sub    $0x1c,%esp
  8025d3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8025d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d8:	50                   	push   %eax
  8025d9:	e8 15 f1 ff ff       	call   8016f3 <fd_alloc>
  8025de:	89 c3                	mov    %eax,%ebx
  8025e0:	83 c4 10             	add    $0x10,%esp
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	78 43                	js     80262a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	68 07 04 00 00       	push   $0x407
  8025ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f2:	6a 00                	push   $0x0
  8025f4:	e8 f1 e8 ff ff       	call   800eea <sys_page_alloc>
  8025f9:	89 c3                	mov    %eax,%ebx
  8025fb:	83 c4 10             	add    $0x10,%esp
  8025fe:	85 c0                	test   %eax,%eax
  802600:	78 28                	js     80262a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80260b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802617:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	50                   	push   %eax
  80261e:	e8 a9 f0 ff ff       	call   8016cc <fd2num>
  802623:	89 c3                	mov    %eax,%ebx
  802625:	83 c4 10             	add    $0x10,%esp
  802628:	eb 0c                	jmp    802636 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	56                   	push   %esi
  80262e:	e8 e4 01 00 00       	call   802817 <nsipc_close>
		return r;
  802633:	83 c4 10             	add    $0x10,%esp
}
  802636:	89 d8                	mov    %ebx,%eax
  802638:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80263b:	5b                   	pop    %ebx
  80263c:	5e                   	pop    %esi
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    

0080263f <accept>:
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	e8 4e ff ff ff       	call   80259b <fd2sockid>
  80264d:	85 c0                	test   %eax,%eax
  80264f:	78 1b                	js     80266c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	ff 75 10             	pushl  0x10(%ebp)
  802657:	ff 75 0c             	pushl  0xc(%ebp)
  80265a:	50                   	push   %eax
  80265b:	e8 0e 01 00 00       	call   80276e <nsipc_accept>
  802660:	83 c4 10             	add    $0x10,%esp
  802663:	85 c0                	test   %eax,%eax
  802665:	78 05                	js     80266c <accept+0x2d>
	return alloc_sockfd(r);
  802667:	e8 5f ff ff ff       	call   8025cb <alloc_sockfd>
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <bind>:
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	e8 1f ff ff ff       	call   80259b <fd2sockid>
  80267c:	85 c0                	test   %eax,%eax
  80267e:	78 12                	js     802692 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802680:	83 ec 04             	sub    $0x4,%esp
  802683:	ff 75 10             	pushl  0x10(%ebp)
  802686:	ff 75 0c             	pushl  0xc(%ebp)
  802689:	50                   	push   %eax
  80268a:	e8 31 01 00 00       	call   8027c0 <nsipc_bind>
  80268f:	83 c4 10             	add    $0x10,%esp
}
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <shutdown>:
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
  802697:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	e8 f9 fe ff ff       	call   80259b <fd2sockid>
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	78 0f                	js     8026b5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8026a6:	83 ec 08             	sub    $0x8,%esp
  8026a9:	ff 75 0c             	pushl  0xc(%ebp)
  8026ac:	50                   	push   %eax
  8026ad:	e8 43 01 00 00       	call   8027f5 <nsipc_shutdown>
  8026b2:	83 c4 10             	add    $0x10,%esp
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <connect>:
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
  8026ba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	e8 d6 fe ff ff       	call   80259b <fd2sockid>
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	78 12                	js     8026db <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8026c9:	83 ec 04             	sub    $0x4,%esp
  8026cc:	ff 75 10             	pushl  0x10(%ebp)
  8026cf:	ff 75 0c             	pushl  0xc(%ebp)
  8026d2:	50                   	push   %eax
  8026d3:	e8 59 01 00 00       	call   802831 <nsipc_connect>
  8026d8:	83 c4 10             	add    $0x10,%esp
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <listen>:
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	e8 b0 fe ff ff       	call   80259b <fd2sockid>
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	78 0f                	js     8026fe <listen+0x21>
	return nsipc_listen(r, backlog);
  8026ef:	83 ec 08             	sub    $0x8,%esp
  8026f2:	ff 75 0c             	pushl  0xc(%ebp)
  8026f5:	50                   	push   %eax
  8026f6:	e8 6b 01 00 00       	call   802866 <nsipc_listen>
  8026fb:	83 c4 10             	add    $0x10,%esp
}
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <socket>:

int
socket(int domain, int type, int protocol)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802706:	ff 75 10             	pushl  0x10(%ebp)
  802709:	ff 75 0c             	pushl  0xc(%ebp)
  80270c:	ff 75 08             	pushl  0x8(%ebp)
  80270f:	e8 3e 02 00 00       	call   802952 <nsipc_socket>
  802714:	83 c4 10             	add    $0x10,%esp
  802717:	85 c0                	test   %eax,%eax
  802719:	78 05                	js     802720 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80271b:	e8 ab fe ff ff       	call   8025cb <alloc_sockfd>
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	53                   	push   %ebx
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80272b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802732:	74 26                	je     80275a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802734:	6a 07                	push   $0x7
  802736:	68 00 70 80 00       	push   $0x807000
  80273b:	53                   	push   %ebx
  80273c:	ff 35 04 50 80 00    	pushl  0x805004
  802742:	e8 48 08 00 00       	call   802f8f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802747:	83 c4 0c             	add    $0xc,%esp
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	e8 d1 07 00 00       	call   802f26 <ipc_recv>
}
  802755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802758:	c9                   	leave  
  802759:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	6a 02                	push   $0x2
  80275f:	e8 83 08 00 00       	call   802fe7 <ipc_find_env>
  802764:	a3 04 50 80 00       	mov    %eax,0x805004
  802769:	83 c4 10             	add    $0x10,%esp
  80276c:	eb c6                	jmp    802734 <nsipc+0x12>

0080276e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	56                   	push   %esi
  802772:	53                   	push   %ebx
  802773:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80277e:	8b 06                	mov    (%esi),%eax
  802780:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802785:	b8 01 00 00 00       	mov    $0x1,%eax
  80278a:	e8 93 ff ff ff       	call   802722 <nsipc>
  80278f:	89 c3                	mov    %eax,%ebx
  802791:	85 c0                	test   %eax,%eax
  802793:	79 09                	jns    80279e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802795:	89 d8                	mov    %ebx,%eax
  802797:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80279a:	5b                   	pop    %ebx
  80279b:	5e                   	pop    %esi
  80279c:	5d                   	pop    %ebp
  80279d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	ff 35 10 70 80 00    	pushl  0x807010
  8027a7:	68 00 70 80 00       	push   $0x807000
  8027ac:	ff 75 0c             	pushl  0xc(%ebp)
  8027af:	e8 d2 e4 ff ff       	call   800c86 <memmove>
		*addrlen = ret->ret_addrlen;
  8027b4:	a1 10 70 80 00       	mov    0x807010,%eax
  8027b9:	89 06                	mov    %eax,(%esi)
  8027bb:	83 c4 10             	add    $0x10,%esp
	return r;
  8027be:	eb d5                	jmp    802795 <nsipc_accept+0x27>

008027c0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	53                   	push   %ebx
  8027c4:	83 ec 08             	sub    $0x8,%esp
  8027c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8027d2:	53                   	push   %ebx
  8027d3:	ff 75 0c             	pushl  0xc(%ebp)
  8027d6:	68 04 70 80 00       	push   $0x807004
  8027db:	e8 a6 e4 ff ff       	call   800c86 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8027e0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8027e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8027eb:	e8 32 ff ff ff       	call   802722 <nsipc>
}
  8027f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802803:	8b 45 0c             	mov    0xc(%ebp),%eax
  802806:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80280b:	b8 03 00 00 00       	mov    $0x3,%eax
  802810:	e8 0d ff ff ff       	call   802722 <nsipc>
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <nsipc_close>:

int
nsipc_close(int s)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802825:	b8 04 00 00 00       	mov    $0x4,%eax
  80282a:	e8 f3 fe ff ff       	call   802722 <nsipc>
}
  80282f:	c9                   	leave  
  802830:	c3                   	ret    

00802831 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
  802834:	53                   	push   %ebx
  802835:	83 ec 08             	sub    $0x8,%esp
  802838:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802843:	53                   	push   %ebx
  802844:	ff 75 0c             	pushl  0xc(%ebp)
  802847:	68 04 70 80 00       	push   $0x807004
  80284c:	e8 35 e4 ff ff       	call   800c86 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802851:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802857:	b8 05 00 00 00       	mov    $0x5,%eax
  80285c:	e8 c1 fe ff ff       	call   802722 <nsipc>
}
  802861:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802874:	8b 45 0c             	mov    0xc(%ebp),%eax
  802877:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80287c:	b8 06 00 00 00       	mov    $0x6,%eax
  802881:	e8 9c fe ff ff       	call   802722 <nsipc>
}
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
  80288b:	56                   	push   %esi
  80288c:	53                   	push   %ebx
  80288d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802898:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80289e:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a1:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8028a6:	b8 07 00 00 00       	mov    $0x7,%eax
  8028ab:	e8 72 fe ff ff       	call   802722 <nsipc>
  8028b0:	89 c3                	mov    %eax,%ebx
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	78 1f                	js     8028d5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8028b6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8028bb:	7f 21                	jg     8028de <nsipc_recv+0x56>
  8028bd:	39 c6                	cmp    %eax,%esi
  8028bf:	7c 1d                	jl     8028de <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	50                   	push   %eax
  8028c5:	68 00 70 80 00       	push   $0x807000
  8028ca:	ff 75 0c             	pushl  0xc(%ebp)
  8028cd:	e8 b4 e3 ff ff       	call   800c86 <memmove>
  8028d2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8028d5:	89 d8                	mov    %ebx,%eax
  8028d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028da:	5b                   	pop    %ebx
  8028db:	5e                   	pop    %esi
  8028dc:	5d                   	pop    %ebp
  8028dd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8028de:	68 52 3a 80 00       	push   $0x803a52
  8028e3:	68 3b 39 80 00       	push   $0x80393b
  8028e8:	6a 62                	push   $0x62
  8028ea:	68 67 3a 80 00       	push   $0x803a67
  8028ef:	e8 af d9 ff ff       	call   8002a3 <_panic>

008028f4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	53                   	push   %ebx
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802906:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80290c:	7f 2e                	jg     80293c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	53                   	push   %ebx
  802912:	ff 75 0c             	pushl  0xc(%ebp)
  802915:	68 0c 70 80 00       	push   $0x80700c
  80291a:	e8 67 e3 ff ff       	call   800c86 <memmove>
	nsipcbuf.send.req_size = size;
  80291f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802925:	8b 45 14             	mov    0x14(%ebp),%eax
  802928:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80292d:	b8 08 00 00 00       	mov    $0x8,%eax
  802932:	e8 eb fd ff ff       	call   802722 <nsipc>
}
  802937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80293a:	c9                   	leave  
  80293b:	c3                   	ret    
	assert(size < 1600);
  80293c:	68 73 3a 80 00       	push   $0x803a73
  802941:	68 3b 39 80 00       	push   $0x80393b
  802946:	6a 6d                	push   $0x6d
  802948:	68 67 3a 80 00       	push   $0x803a67
  80294d:	e8 51 d9 ff ff       	call   8002a3 <_panic>

00802952 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802960:	8b 45 0c             	mov    0xc(%ebp),%eax
  802963:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802968:	8b 45 10             	mov    0x10(%ebp),%eax
  80296b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802970:	b8 09 00 00 00       	mov    $0x9,%eax
  802975:	e8 a8 fd ff ff       	call   802722 <nsipc>
}
  80297a:	c9                   	leave  
  80297b:	c3                   	ret    

0080297c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80297c:	55                   	push   %ebp
  80297d:	89 e5                	mov    %esp,%ebp
  80297f:	56                   	push   %esi
  802980:	53                   	push   %ebx
  802981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802984:	83 ec 0c             	sub    $0xc,%esp
  802987:	ff 75 08             	pushl  0x8(%ebp)
  80298a:	e8 4d ed ff ff       	call   8016dc <fd2data>
  80298f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802991:	83 c4 08             	add    $0x8,%esp
  802994:	68 7f 3a 80 00       	push   $0x803a7f
  802999:	53                   	push   %ebx
  80299a:	e8 59 e1 ff ff       	call   800af8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80299f:	8b 46 04             	mov    0x4(%esi),%eax
  8029a2:	2b 06                	sub    (%esi),%eax
  8029a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8029aa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8029b1:	00 00 00 
	stat->st_dev = &devpipe;
  8029b4:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8029bb:	40 80 00 
	return 0;
}
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029c6:	5b                   	pop    %ebx
  8029c7:	5e                   	pop    %esi
  8029c8:	5d                   	pop    %ebp
  8029c9:	c3                   	ret    

008029ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	53                   	push   %ebx
  8029ce:	83 ec 0c             	sub    $0xc,%esp
  8029d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8029d4:	53                   	push   %ebx
  8029d5:	6a 00                	push   $0x0
  8029d7:	e8 93 e5 ff ff       	call   800f6f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8029dc:	89 1c 24             	mov    %ebx,(%esp)
  8029df:	e8 f8 ec ff ff       	call   8016dc <fd2data>
  8029e4:	83 c4 08             	add    $0x8,%esp
  8029e7:	50                   	push   %eax
  8029e8:	6a 00                	push   $0x0
  8029ea:	e8 80 e5 ff ff       	call   800f6f <sys_page_unmap>
}
  8029ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <_pipeisclosed>:
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
  8029f7:	57                   	push   %edi
  8029f8:	56                   	push   %esi
  8029f9:	53                   	push   %ebx
  8029fa:	83 ec 1c             	sub    $0x1c,%esp
  8029fd:	89 c7                	mov    %eax,%edi
  8029ff:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802a01:	a1 08 50 80 00       	mov    0x805008,%eax
  802a06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802a09:	83 ec 0c             	sub    $0xc,%esp
  802a0c:	57                   	push   %edi
  802a0d:	e8 14 06 00 00       	call   803026 <pageref>
  802a12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a15:	89 34 24             	mov    %esi,(%esp)
  802a18:	e8 09 06 00 00       	call   803026 <pageref>
		nn = thisenv->env_runs;
  802a1d:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802a23:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802a26:	83 c4 10             	add    $0x10,%esp
  802a29:	39 cb                	cmp    %ecx,%ebx
  802a2b:	74 1b                	je     802a48 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802a2d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a30:	75 cf                	jne    802a01 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802a32:	8b 42 58             	mov    0x58(%edx),%eax
  802a35:	6a 01                	push   $0x1
  802a37:	50                   	push   %eax
  802a38:	53                   	push   %ebx
  802a39:	68 86 3a 80 00       	push   $0x803a86
  802a3e:	e8 56 d9 ff ff       	call   800399 <cprintf>
  802a43:	83 c4 10             	add    $0x10,%esp
  802a46:	eb b9                	jmp    802a01 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802a48:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a4b:	0f 94 c0             	sete   %al
  802a4e:	0f b6 c0             	movzbl %al,%eax
}
  802a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a54:	5b                   	pop    %ebx
  802a55:	5e                   	pop    %esi
  802a56:	5f                   	pop    %edi
  802a57:	5d                   	pop    %ebp
  802a58:	c3                   	ret    

00802a59 <devpipe_write>:
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
  802a5c:	57                   	push   %edi
  802a5d:	56                   	push   %esi
  802a5e:	53                   	push   %ebx
  802a5f:	83 ec 28             	sub    $0x28,%esp
  802a62:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802a65:	56                   	push   %esi
  802a66:	e8 71 ec ff ff       	call   8016dc <fd2data>
  802a6b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a6d:	83 c4 10             	add    $0x10,%esp
  802a70:	bf 00 00 00 00       	mov    $0x0,%edi
  802a75:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a78:	74 4f                	je     802ac9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a7a:	8b 43 04             	mov    0x4(%ebx),%eax
  802a7d:	8b 0b                	mov    (%ebx),%ecx
  802a7f:	8d 51 20             	lea    0x20(%ecx),%edx
  802a82:	39 d0                	cmp    %edx,%eax
  802a84:	72 14                	jb     802a9a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802a86:	89 da                	mov    %ebx,%edx
  802a88:	89 f0                	mov    %esi,%eax
  802a8a:	e8 65 ff ff ff       	call   8029f4 <_pipeisclosed>
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	75 3b                	jne    802ace <devpipe_write+0x75>
			sys_yield();
  802a93:	e8 33 e4 ff ff       	call   800ecb <sys_yield>
  802a98:	eb e0                	jmp    802a7a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a9d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802aa1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802aa4:	89 c2                	mov    %eax,%edx
  802aa6:	c1 fa 1f             	sar    $0x1f,%edx
  802aa9:	89 d1                	mov    %edx,%ecx
  802aab:	c1 e9 1b             	shr    $0x1b,%ecx
  802aae:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802ab1:	83 e2 1f             	and    $0x1f,%edx
  802ab4:	29 ca                	sub    %ecx,%edx
  802ab6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802aba:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802abe:	83 c0 01             	add    $0x1,%eax
  802ac1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802ac4:	83 c7 01             	add    $0x1,%edi
  802ac7:	eb ac                	jmp    802a75 <devpipe_write+0x1c>
	return i;
  802ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  802acc:	eb 05                	jmp    802ad3 <devpipe_write+0x7a>
				return 0;
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ad6:	5b                   	pop    %ebx
  802ad7:	5e                   	pop    %esi
  802ad8:	5f                   	pop    %edi
  802ad9:	5d                   	pop    %ebp
  802ada:	c3                   	ret    

00802adb <devpipe_read>:
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	57                   	push   %edi
  802adf:	56                   	push   %esi
  802ae0:	53                   	push   %ebx
  802ae1:	83 ec 18             	sub    $0x18,%esp
  802ae4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802ae7:	57                   	push   %edi
  802ae8:	e8 ef eb ff ff       	call   8016dc <fd2data>
  802aed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802aef:	83 c4 10             	add    $0x10,%esp
  802af2:	be 00 00 00 00       	mov    $0x0,%esi
  802af7:	3b 75 10             	cmp    0x10(%ebp),%esi
  802afa:	75 14                	jne    802b10 <devpipe_read+0x35>
	return i;
  802afc:	8b 45 10             	mov    0x10(%ebp),%eax
  802aff:	eb 02                	jmp    802b03 <devpipe_read+0x28>
				return i;
  802b01:	89 f0                	mov    %esi,%eax
}
  802b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b06:	5b                   	pop    %ebx
  802b07:	5e                   	pop    %esi
  802b08:	5f                   	pop    %edi
  802b09:	5d                   	pop    %ebp
  802b0a:	c3                   	ret    
			sys_yield();
  802b0b:	e8 bb e3 ff ff       	call   800ecb <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802b10:	8b 03                	mov    (%ebx),%eax
  802b12:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b15:	75 18                	jne    802b2f <devpipe_read+0x54>
			if (i > 0)
  802b17:	85 f6                	test   %esi,%esi
  802b19:	75 e6                	jne    802b01 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802b1b:	89 da                	mov    %ebx,%edx
  802b1d:	89 f8                	mov    %edi,%eax
  802b1f:	e8 d0 fe ff ff       	call   8029f4 <_pipeisclosed>
  802b24:	85 c0                	test   %eax,%eax
  802b26:	74 e3                	je     802b0b <devpipe_read+0x30>
				return 0;
  802b28:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2d:	eb d4                	jmp    802b03 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b2f:	99                   	cltd   
  802b30:	c1 ea 1b             	shr    $0x1b,%edx
  802b33:	01 d0                	add    %edx,%eax
  802b35:	83 e0 1f             	and    $0x1f,%eax
  802b38:	29 d0                	sub    %edx,%eax
  802b3a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802b3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b42:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802b45:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802b48:	83 c6 01             	add    $0x1,%esi
  802b4b:	eb aa                	jmp    802af7 <devpipe_read+0x1c>

00802b4d <pipe>:
{
  802b4d:	55                   	push   %ebp
  802b4e:	89 e5                	mov    %esp,%ebp
  802b50:	56                   	push   %esi
  802b51:	53                   	push   %ebx
  802b52:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802b55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b58:	50                   	push   %eax
  802b59:	e8 95 eb ff ff       	call   8016f3 <fd_alloc>
  802b5e:	89 c3                	mov    %eax,%ebx
  802b60:	83 c4 10             	add    $0x10,%esp
  802b63:	85 c0                	test   %eax,%eax
  802b65:	0f 88 23 01 00 00    	js     802c8e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 07 04 00 00       	push   $0x407
  802b73:	ff 75 f4             	pushl  -0xc(%ebp)
  802b76:	6a 00                	push   $0x0
  802b78:	e8 6d e3 ff ff       	call   800eea <sys_page_alloc>
  802b7d:	89 c3                	mov    %eax,%ebx
  802b7f:	83 c4 10             	add    $0x10,%esp
  802b82:	85 c0                	test   %eax,%eax
  802b84:	0f 88 04 01 00 00    	js     802c8e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802b8a:	83 ec 0c             	sub    $0xc,%esp
  802b8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b90:	50                   	push   %eax
  802b91:	e8 5d eb ff ff       	call   8016f3 <fd_alloc>
  802b96:	89 c3                	mov    %eax,%ebx
  802b98:	83 c4 10             	add    $0x10,%esp
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	0f 88 db 00 00 00    	js     802c7e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	68 07 04 00 00       	push   $0x407
  802bab:	ff 75 f0             	pushl  -0x10(%ebp)
  802bae:	6a 00                	push   $0x0
  802bb0:	e8 35 e3 ff ff       	call   800eea <sys_page_alloc>
  802bb5:	89 c3                	mov    %eax,%ebx
  802bb7:	83 c4 10             	add    $0x10,%esp
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	0f 88 bc 00 00 00    	js     802c7e <pipe+0x131>
	va = fd2data(fd0);
  802bc2:	83 ec 0c             	sub    $0xc,%esp
  802bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  802bc8:	e8 0f eb ff ff       	call   8016dc <fd2data>
  802bcd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bcf:	83 c4 0c             	add    $0xc,%esp
  802bd2:	68 07 04 00 00       	push   $0x407
  802bd7:	50                   	push   %eax
  802bd8:	6a 00                	push   $0x0
  802bda:	e8 0b e3 ff ff       	call   800eea <sys_page_alloc>
  802bdf:	89 c3                	mov    %eax,%ebx
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	85 c0                	test   %eax,%eax
  802be6:	0f 88 82 00 00 00    	js     802c6e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bec:	83 ec 0c             	sub    $0xc,%esp
  802bef:	ff 75 f0             	pushl  -0x10(%ebp)
  802bf2:	e8 e5 ea ff ff       	call   8016dc <fd2data>
  802bf7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802bfe:	50                   	push   %eax
  802bff:	6a 00                	push   $0x0
  802c01:	56                   	push   %esi
  802c02:	6a 00                	push   $0x0
  802c04:	e8 24 e3 ff ff       	call   800f2d <sys_page_map>
  802c09:	89 c3                	mov    %eax,%ebx
  802c0b:	83 c4 20             	add    $0x20,%esp
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	78 4e                	js     802c60 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802c12:	a1 44 40 80 00       	mov    0x804044,%eax
  802c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802c26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c29:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802c35:	83 ec 0c             	sub    $0xc,%esp
  802c38:	ff 75 f4             	pushl  -0xc(%ebp)
  802c3b:	e8 8c ea ff ff       	call   8016cc <fd2num>
  802c40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c43:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802c45:	83 c4 04             	add    $0x4,%esp
  802c48:	ff 75 f0             	pushl  -0x10(%ebp)
  802c4b:	e8 7c ea ff ff       	call   8016cc <fd2num>
  802c50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c53:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802c56:	83 c4 10             	add    $0x10,%esp
  802c59:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c5e:	eb 2e                	jmp    802c8e <pipe+0x141>
	sys_page_unmap(0, va);
  802c60:	83 ec 08             	sub    $0x8,%esp
  802c63:	56                   	push   %esi
  802c64:	6a 00                	push   $0x0
  802c66:	e8 04 e3 ff ff       	call   800f6f <sys_page_unmap>
  802c6b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802c6e:	83 ec 08             	sub    $0x8,%esp
  802c71:	ff 75 f0             	pushl  -0x10(%ebp)
  802c74:	6a 00                	push   $0x0
  802c76:	e8 f4 e2 ff ff       	call   800f6f <sys_page_unmap>
  802c7b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c7e:	83 ec 08             	sub    $0x8,%esp
  802c81:	ff 75 f4             	pushl  -0xc(%ebp)
  802c84:	6a 00                	push   $0x0
  802c86:	e8 e4 e2 ff ff       	call   800f6f <sys_page_unmap>
  802c8b:	83 c4 10             	add    $0x10,%esp
}
  802c8e:	89 d8                	mov    %ebx,%eax
  802c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c93:	5b                   	pop    %ebx
  802c94:	5e                   	pop    %esi
  802c95:	5d                   	pop    %ebp
  802c96:	c3                   	ret    

00802c97 <pipeisclosed>:
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
  802c9a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ca0:	50                   	push   %eax
  802ca1:	ff 75 08             	pushl  0x8(%ebp)
  802ca4:	e8 9c ea ff ff       	call   801745 <fd_lookup>
  802ca9:	83 c4 10             	add    $0x10,%esp
  802cac:	85 c0                	test   %eax,%eax
  802cae:	78 18                	js     802cc8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802cb0:	83 ec 0c             	sub    $0xc,%esp
  802cb3:	ff 75 f4             	pushl  -0xc(%ebp)
  802cb6:	e8 21 ea ff ff       	call   8016dc <fd2data>
	return _pipeisclosed(fd, p);
  802cbb:	89 c2                	mov    %eax,%edx
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	e8 2f fd ff ff       	call   8029f4 <_pipeisclosed>
  802cc5:	83 c4 10             	add    $0x10,%esp
}
  802cc8:	c9                   	leave  
  802cc9:	c3                   	ret    

00802cca <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	56                   	push   %esi
  802cce:	53                   	push   %ebx
  802ccf:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802cd2:	85 f6                	test   %esi,%esi
  802cd4:	74 16                	je     802cec <wait+0x22>
	e = &envs[ENVX(envid)];
  802cd6:	89 f3                	mov    %esi,%ebx
  802cd8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cde:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802ce4:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802cea:	eb 1b                	jmp    802d07 <wait+0x3d>
	assert(envid != 0);
  802cec:	68 9e 3a 80 00       	push   $0x803a9e
  802cf1:	68 3b 39 80 00       	push   $0x80393b
  802cf6:	6a 09                	push   $0x9
  802cf8:	68 a9 3a 80 00       	push   $0x803aa9
  802cfd:	e8 a1 d5 ff ff       	call   8002a3 <_panic>
		sys_yield();
  802d02:	e8 c4 e1 ff ff       	call   800ecb <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802d07:	8b 43 48             	mov    0x48(%ebx),%eax
  802d0a:	39 f0                	cmp    %esi,%eax
  802d0c:	75 07                	jne    802d15 <wait+0x4b>
  802d0e:	8b 43 54             	mov    0x54(%ebx),%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	75 ed                	jne    802d02 <wait+0x38>
}
  802d15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d18:	5b                   	pop    %ebx
  802d19:	5e                   	pop    %esi
  802d1a:	5d                   	pop    %ebp
  802d1b:	c3                   	ret    

00802d1c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d21:	c3                   	ret    

00802d22 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802d22:	55                   	push   %ebp
  802d23:	89 e5                	mov    %esp,%ebp
  802d25:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802d28:	68 b4 3a 80 00       	push   $0x803ab4
  802d2d:	ff 75 0c             	pushl  0xc(%ebp)
  802d30:	e8 c3 dd ff ff       	call   800af8 <strcpy>
	return 0;
}
  802d35:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3a:	c9                   	leave  
  802d3b:	c3                   	ret    

00802d3c <devcons_write>:
{
  802d3c:	55                   	push   %ebp
  802d3d:	89 e5                	mov    %esp,%ebp
  802d3f:	57                   	push   %edi
  802d40:	56                   	push   %esi
  802d41:	53                   	push   %ebx
  802d42:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802d48:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802d4d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802d53:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d56:	73 31                	jae    802d89 <devcons_write+0x4d>
		m = n - tot;
  802d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d5b:	29 f3                	sub    %esi,%ebx
  802d5d:	83 fb 7f             	cmp    $0x7f,%ebx
  802d60:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d65:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802d68:	83 ec 04             	sub    $0x4,%esp
  802d6b:	53                   	push   %ebx
  802d6c:	89 f0                	mov    %esi,%eax
  802d6e:	03 45 0c             	add    0xc(%ebp),%eax
  802d71:	50                   	push   %eax
  802d72:	57                   	push   %edi
  802d73:	e8 0e df ff ff       	call   800c86 <memmove>
		sys_cputs(buf, m);
  802d78:	83 c4 08             	add    $0x8,%esp
  802d7b:	53                   	push   %ebx
  802d7c:	57                   	push   %edi
  802d7d:	e8 ac e0 ff ff       	call   800e2e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802d82:	01 de                	add    %ebx,%esi
  802d84:	83 c4 10             	add    $0x10,%esp
  802d87:	eb ca                	jmp    802d53 <devcons_write+0x17>
}
  802d89:	89 f0                	mov    %esi,%eax
  802d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d8e:	5b                   	pop    %ebx
  802d8f:	5e                   	pop    %esi
  802d90:	5f                   	pop    %edi
  802d91:	5d                   	pop    %ebp
  802d92:	c3                   	ret    

00802d93 <devcons_read>:
{
  802d93:	55                   	push   %ebp
  802d94:	89 e5                	mov    %esp,%ebp
  802d96:	83 ec 08             	sub    $0x8,%esp
  802d99:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802da2:	74 21                	je     802dc5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802da4:	e8 a3 e0 ff ff       	call   800e4c <sys_cgetc>
  802da9:	85 c0                	test   %eax,%eax
  802dab:	75 07                	jne    802db4 <devcons_read+0x21>
		sys_yield();
  802dad:	e8 19 e1 ff ff       	call   800ecb <sys_yield>
  802db2:	eb f0                	jmp    802da4 <devcons_read+0x11>
	if (c < 0)
  802db4:	78 0f                	js     802dc5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802db6:	83 f8 04             	cmp    $0x4,%eax
  802db9:	74 0c                	je     802dc7 <devcons_read+0x34>
	*(char*)vbuf = c;
  802dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dbe:	88 02                	mov    %al,(%edx)
	return 1;
  802dc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802dc5:	c9                   	leave  
  802dc6:	c3                   	ret    
		return 0;
  802dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcc:	eb f7                	jmp    802dc5 <devcons_read+0x32>

00802dce <cputchar>:
{
  802dce:	55                   	push   %ebp
  802dcf:	89 e5                	mov    %esp,%ebp
  802dd1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802dda:	6a 01                	push   $0x1
  802ddc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ddf:	50                   	push   %eax
  802de0:	e8 49 e0 ff ff       	call   800e2e <sys_cputs>
}
  802de5:	83 c4 10             	add    $0x10,%esp
  802de8:	c9                   	leave  
  802de9:	c3                   	ret    

00802dea <getchar>:
{
  802dea:	55                   	push   %ebp
  802deb:	89 e5                	mov    %esp,%ebp
  802ded:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802df0:	6a 01                	push   $0x1
  802df2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802df5:	50                   	push   %eax
  802df6:	6a 00                	push   $0x0
  802df8:	e8 b8 eb ff ff       	call   8019b5 <read>
	if (r < 0)
  802dfd:	83 c4 10             	add    $0x10,%esp
  802e00:	85 c0                	test   %eax,%eax
  802e02:	78 06                	js     802e0a <getchar+0x20>
	if (r < 1)
  802e04:	74 06                	je     802e0c <getchar+0x22>
	return c;
  802e06:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    
		return -E_EOF;
  802e0c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802e11:	eb f7                	jmp    802e0a <getchar+0x20>

00802e13 <iscons>:
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
  802e16:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e1c:	50                   	push   %eax
  802e1d:	ff 75 08             	pushl  0x8(%ebp)
  802e20:	e8 20 e9 ff ff       	call   801745 <fd_lookup>
  802e25:	83 c4 10             	add    $0x10,%esp
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	78 11                	js     802e3d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e35:	39 10                	cmp    %edx,(%eax)
  802e37:	0f 94 c0             	sete   %al
  802e3a:	0f b6 c0             	movzbl %al,%eax
}
  802e3d:	c9                   	leave  
  802e3e:	c3                   	ret    

00802e3f <opencons>:
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
  802e42:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802e45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e48:	50                   	push   %eax
  802e49:	e8 a5 e8 ff ff       	call   8016f3 <fd_alloc>
  802e4e:	83 c4 10             	add    $0x10,%esp
  802e51:	85 c0                	test   %eax,%eax
  802e53:	78 3a                	js     802e8f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 07 04 00 00       	push   $0x407
  802e5d:	ff 75 f4             	pushl  -0xc(%ebp)
  802e60:	6a 00                	push   $0x0
  802e62:	e8 83 e0 ff ff       	call   800eea <sys_page_alloc>
  802e67:	83 c4 10             	add    $0x10,%esp
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	78 21                	js     802e8f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e77:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e83:	83 ec 0c             	sub    $0xc,%esp
  802e86:	50                   	push   %eax
  802e87:	e8 40 e8 ff ff       	call   8016cc <fd2num>
  802e8c:	83 c4 10             	add    $0x10,%esp
}
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
  802e94:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e97:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e9e:	74 0a                	je     802eaa <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ea8:	c9                   	leave  
  802ea9:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	6a 07                	push   $0x7
  802eaf:	68 00 f0 bf ee       	push   $0xeebff000
  802eb4:	6a 00                	push   $0x0
  802eb6:	e8 2f e0 ff ff       	call   800eea <sys_page_alloc>
		if(r < 0)
  802ebb:	83 c4 10             	add    $0x10,%esp
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	78 2a                	js     802eec <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802ec2:	83 ec 08             	sub    $0x8,%esp
  802ec5:	68 00 2f 80 00       	push   $0x802f00
  802eca:	6a 00                	push   $0x0
  802ecc:	e8 64 e1 ff ff       	call   801035 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802ed1:	83 c4 10             	add    $0x10,%esp
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	79 c8                	jns    802ea0 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802ed8:	83 ec 04             	sub    $0x4,%esp
  802edb:	68 f0 3a 80 00       	push   $0x803af0
  802ee0:	6a 25                	push   $0x25
  802ee2:	68 2c 3b 80 00       	push   $0x803b2c
  802ee7:	e8 b7 d3 ff ff       	call   8002a3 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802eec:	83 ec 04             	sub    $0x4,%esp
  802eef:	68 c0 3a 80 00       	push   $0x803ac0
  802ef4:	6a 22                	push   $0x22
  802ef6:	68 2c 3b 80 00       	push   $0x803b2c
  802efb:	e8 a3 d3 ff ff       	call   8002a3 <_panic>

00802f00 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802f00:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802f01:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802f06:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802f08:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802f0b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802f0f:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802f13:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802f16:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802f18:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802f1c:	83 c4 08             	add    $0x8,%esp
	popal
  802f1f:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802f20:	83 c4 04             	add    $0x4,%esp
	popfl
  802f23:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802f24:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802f25:	c3                   	ret    

00802f26 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
  802f29:	56                   	push   %esi
  802f2a:	53                   	push   %ebx
  802f2b:	8b 75 08             	mov    0x8(%ebp),%esi
  802f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802f34:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802f36:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802f3b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802f3e:	83 ec 0c             	sub    $0xc,%esp
  802f41:	50                   	push   %eax
  802f42:	e8 53 e1 ff ff       	call   80109a <sys_ipc_recv>
	if(ret < 0){
  802f47:	83 c4 10             	add    $0x10,%esp
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	78 2b                	js     802f79 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802f4e:	85 f6                	test   %esi,%esi
  802f50:	74 0a                	je     802f5c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802f52:	a1 08 50 80 00       	mov    0x805008,%eax
  802f57:	8b 40 78             	mov    0x78(%eax),%eax
  802f5a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802f5c:	85 db                	test   %ebx,%ebx
  802f5e:	74 0a                	je     802f6a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802f60:	a1 08 50 80 00       	mov    0x805008,%eax
  802f65:	8b 40 7c             	mov    0x7c(%eax),%eax
  802f68:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802f6a:	a1 08 50 80 00       	mov    0x805008,%eax
  802f6f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f75:	5b                   	pop    %ebx
  802f76:	5e                   	pop    %esi
  802f77:	5d                   	pop    %ebp
  802f78:	c3                   	ret    
		if(from_env_store)
  802f79:	85 f6                	test   %esi,%esi
  802f7b:	74 06                	je     802f83 <ipc_recv+0x5d>
			*from_env_store = 0;
  802f7d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802f83:	85 db                	test   %ebx,%ebx
  802f85:	74 eb                	je     802f72 <ipc_recv+0x4c>
			*perm_store = 0;
  802f87:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802f8d:	eb e3                	jmp    802f72 <ipc_recv+0x4c>

00802f8f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
  802f92:	57                   	push   %edi
  802f93:	56                   	push   %esi
  802f94:	53                   	push   %ebx
  802f95:	83 ec 0c             	sub    $0xc,%esp
  802f98:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802fa1:	85 db                	test   %ebx,%ebx
  802fa3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802fa8:	0f 44 d8             	cmove  %eax,%ebx
  802fab:	eb 05                	jmp    802fb2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802fad:	e8 19 df ff ff       	call   800ecb <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802fb2:	ff 75 14             	pushl  0x14(%ebp)
  802fb5:	53                   	push   %ebx
  802fb6:	56                   	push   %esi
  802fb7:	57                   	push   %edi
  802fb8:	e8 ba e0 ff ff       	call   801077 <sys_ipc_try_send>
  802fbd:	83 c4 10             	add    $0x10,%esp
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 1b                	je     802fdf <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802fc4:	79 e7                	jns    802fad <ipc_send+0x1e>
  802fc6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802fc9:	74 e2                	je     802fad <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 3a 3b 80 00       	push   $0x803b3a
  802fd3:	6a 46                	push   $0x46
  802fd5:	68 4f 3b 80 00       	push   $0x803b4f
  802fda:	e8 c4 d2 ff ff       	call   8002a3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fe2:	5b                   	pop    %ebx
  802fe3:	5e                   	pop    %esi
  802fe4:	5f                   	pop    %edi
  802fe5:	5d                   	pop    %ebp
  802fe6:	c3                   	ret    

00802fe7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802fe7:	55                   	push   %ebp
  802fe8:	89 e5                	mov    %esp,%ebp
  802fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802ff2:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802ff8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ffe:	8b 52 50             	mov    0x50(%edx),%edx
  803001:	39 ca                	cmp    %ecx,%edx
  803003:	74 11                	je     803016 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  803005:	83 c0 01             	add    $0x1,%eax
  803008:	3d 00 04 00 00       	cmp    $0x400,%eax
  80300d:	75 e3                	jne    802ff2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80300f:	b8 00 00 00 00       	mov    $0x0,%eax
  803014:	eb 0e                	jmp    803024 <ipc_find_env+0x3d>
			return envs[i].env_id;
  803016:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80301c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803021:	8b 40 48             	mov    0x48(%eax),%eax
}
  803024:	5d                   	pop    %ebp
  803025:	c3                   	ret    

00803026 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
  803029:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80302c:	89 d0                	mov    %edx,%eax
  80302e:	c1 e8 16             	shr    $0x16,%eax
  803031:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803038:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80303d:	f6 c1 01             	test   $0x1,%cl
  803040:	74 1d                	je     80305f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803042:	c1 ea 0c             	shr    $0xc,%edx
  803045:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80304c:	f6 c2 01             	test   $0x1,%dl
  80304f:	74 0e                	je     80305f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803051:	c1 ea 0c             	shr    $0xc,%edx
  803054:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80305b:	ef 
  80305c:	0f b7 c0             	movzwl %ax,%eax
}
  80305f:	5d                   	pop    %ebp
  803060:	c3                   	ret    
  803061:	66 90                	xchg   %ax,%ax
  803063:	66 90                	xchg   %ax,%ax
  803065:	66 90                	xchg   %ax,%ax
  803067:	66 90                	xchg   %ax,%ax
  803069:	66 90                	xchg   %ax,%ax
  80306b:	66 90                	xchg   %ax,%ax
  80306d:	66 90                	xchg   %ax,%ax
  80306f:	90                   	nop

00803070 <__udivdi3>:
  803070:	55                   	push   %ebp
  803071:	57                   	push   %edi
  803072:	56                   	push   %esi
  803073:	53                   	push   %ebx
  803074:	83 ec 1c             	sub    $0x1c,%esp
  803077:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80307b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80307f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803083:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803087:	85 d2                	test   %edx,%edx
  803089:	75 4d                	jne    8030d8 <__udivdi3+0x68>
  80308b:	39 f3                	cmp    %esi,%ebx
  80308d:	76 19                	jbe    8030a8 <__udivdi3+0x38>
  80308f:	31 ff                	xor    %edi,%edi
  803091:	89 e8                	mov    %ebp,%eax
  803093:	89 f2                	mov    %esi,%edx
  803095:	f7 f3                	div    %ebx
  803097:	89 fa                	mov    %edi,%edx
  803099:	83 c4 1c             	add    $0x1c,%esp
  80309c:	5b                   	pop    %ebx
  80309d:	5e                   	pop    %esi
  80309e:	5f                   	pop    %edi
  80309f:	5d                   	pop    %ebp
  8030a0:	c3                   	ret    
  8030a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030a8:	89 d9                	mov    %ebx,%ecx
  8030aa:	85 db                	test   %ebx,%ebx
  8030ac:	75 0b                	jne    8030b9 <__udivdi3+0x49>
  8030ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8030b3:	31 d2                	xor    %edx,%edx
  8030b5:	f7 f3                	div    %ebx
  8030b7:	89 c1                	mov    %eax,%ecx
  8030b9:	31 d2                	xor    %edx,%edx
  8030bb:	89 f0                	mov    %esi,%eax
  8030bd:	f7 f1                	div    %ecx
  8030bf:	89 c6                	mov    %eax,%esi
  8030c1:	89 e8                	mov    %ebp,%eax
  8030c3:	89 f7                	mov    %esi,%edi
  8030c5:	f7 f1                	div    %ecx
  8030c7:	89 fa                	mov    %edi,%edx
  8030c9:	83 c4 1c             	add    $0x1c,%esp
  8030cc:	5b                   	pop    %ebx
  8030cd:	5e                   	pop    %esi
  8030ce:	5f                   	pop    %edi
  8030cf:	5d                   	pop    %ebp
  8030d0:	c3                   	ret    
  8030d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030d8:	39 f2                	cmp    %esi,%edx
  8030da:	77 1c                	ja     8030f8 <__udivdi3+0x88>
  8030dc:	0f bd fa             	bsr    %edx,%edi
  8030df:	83 f7 1f             	xor    $0x1f,%edi
  8030e2:	75 2c                	jne    803110 <__udivdi3+0xa0>
  8030e4:	39 f2                	cmp    %esi,%edx
  8030e6:	72 06                	jb     8030ee <__udivdi3+0x7e>
  8030e8:	31 c0                	xor    %eax,%eax
  8030ea:	39 eb                	cmp    %ebp,%ebx
  8030ec:	77 a9                	ja     803097 <__udivdi3+0x27>
  8030ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8030f3:	eb a2                	jmp    803097 <__udivdi3+0x27>
  8030f5:	8d 76 00             	lea    0x0(%esi),%esi
  8030f8:	31 ff                	xor    %edi,%edi
  8030fa:	31 c0                	xor    %eax,%eax
  8030fc:	89 fa                	mov    %edi,%edx
  8030fe:	83 c4 1c             	add    $0x1c,%esp
  803101:	5b                   	pop    %ebx
  803102:	5e                   	pop    %esi
  803103:	5f                   	pop    %edi
  803104:	5d                   	pop    %ebp
  803105:	c3                   	ret    
  803106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80310d:	8d 76 00             	lea    0x0(%esi),%esi
  803110:	89 f9                	mov    %edi,%ecx
  803112:	b8 20 00 00 00       	mov    $0x20,%eax
  803117:	29 f8                	sub    %edi,%eax
  803119:	d3 e2                	shl    %cl,%edx
  80311b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80311f:	89 c1                	mov    %eax,%ecx
  803121:	89 da                	mov    %ebx,%edx
  803123:	d3 ea                	shr    %cl,%edx
  803125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803129:	09 d1                	or     %edx,%ecx
  80312b:	89 f2                	mov    %esi,%edx
  80312d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803131:	89 f9                	mov    %edi,%ecx
  803133:	d3 e3                	shl    %cl,%ebx
  803135:	89 c1                	mov    %eax,%ecx
  803137:	d3 ea                	shr    %cl,%edx
  803139:	89 f9                	mov    %edi,%ecx
  80313b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80313f:	89 eb                	mov    %ebp,%ebx
  803141:	d3 e6                	shl    %cl,%esi
  803143:	89 c1                	mov    %eax,%ecx
  803145:	d3 eb                	shr    %cl,%ebx
  803147:	09 de                	or     %ebx,%esi
  803149:	89 f0                	mov    %esi,%eax
  80314b:	f7 74 24 08          	divl   0x8(%esp)
  80314f:	89 d6                	mov    %edx,%esi
  803151:	89 c3                	mov    %eax,%ebx
  803153:	f7 64 24 0c          	mull   0xc(%esp)
  803157:	39 d6                	cmp    %edx,%esi
  803159:	72 15                	jb     803170 <__udivdi3+0x100>
  80315b:	89 f9                	mov    %edi,%ecx
  80315d:	d3 e5                	shl    %cl,%ebp
  80315f:	39 c5                	cmp    %eax,%ebp
  803161:	73 04                	jae    803167 <__udivdi3+0xf7>
  803163:	39 d6                	cmp    %edx,%esi
  803165:	74 09                	je     803170 <__udivdi3+0x100>
  803167:	89 d8                	mov    %ebx,%eax
  803169:	31 ff                	xor    %edi,%edi
  80316b:	e9 27 ff ff ff       	jmp    803097 <__udivdi3+0x27>
  803170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803173:	31 ff                	xor    %edi,%edi
  803175:	e9 1d ff ff ff       	jmp    803097 <__udivdi3+0x27>
  80317a:	66 90                	xchg   %ax,%ax
  80317c:	66 90                	xchg   %ax,%ax
  80317e:	66 90                	xchg   %ax,%ax

00803180 <__umoddi3>:
  803180:	55                   	push   %ebp
  803181:	57                   	push   %edi
  803182:	56                   	push   %esi
  803183:	53                   	push   %ebx
  803184:	83 ec 1c             	sub    $0x1c,%esp
  803187:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80318b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80318f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803197:	89 da                	mov    %ebx,%edx
  803199:	85 c0                	test   %eax,%eax
  80319b:	75 43                	jne    8031e0 <__umoddi3+0x60>
  80319d:	39 df                	cmp    %ebx,%edi
  80319f:	76 17                	jbe    8031b8 <__umoddi3+0x38>
  8031a1:	89 f0                	mov    %esi,%eax
  8031a3:	f7 f7                	div    %edi
  8031a5:	89 d0                	mov    %edx,%eax
  8031a7:	31 d2                	xor    %edx,%edx
  8031a9:	83 c4 1c             	add    $0x1c,%esp
  8031ac:	5b                   	pop    %ebx
  8031ad:	5e                   	pop    %esi
  8031ae:	5f                   	pop    %edi
  8031af:	5d                   	pop    %ebp
  8031b0:	c3                   	ret    
  8031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031b8:	89 fd                	mov    %edi,%ebp
  8031ba:	85 ff                	test   %edi,%edi
  8031bc:	75 0b                	jne    8031c9 <__umoddi3+0x49>
  8031be:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c3:	31 d2                	xor    %edx,%edx
  8031c5:	f7 f7                	div    %edi
  8031c7:	89 c5                	mov    %eax,%ebp
  8031c9:	89 d8                	mov    %ebx,%eax
  8031cb:	31 d2                	xor    %edx,%edx
  8031cd:	f7 f5                	div    %ebp
  8031cf:	89 f0                	mov    %esi,%eax
  8031d1:	f7 f5                	div    %ebp
  8031d3:	89 d0                	mov    %edx,%eax
  8031d5:	eb d0                	jmp    8031a7 <__umoddi3+0x27>
  8031d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031de:	66 90                	xchg   %ax,%ax
  8031e0:	89 f1                	mov    %esi,%ecx
  8031e2:	39 d8                	cmp    %ebx,%eax
  8031e4:	76 0a                	jbe    8031f0 <__umoddi3+0x70>
  8031e6:	89 f0                	mov    %esi,%eax
  8031e8:	83 c4 1c             	add    $0x1c,%esp
  8031eb:	5b                   	pop    %ebx
  8031ec:	5e                   	pop    %esi
  8031ed:	5f                   	pop    %edi
  8031ee:	5d                   	pop    %ebp
  8031ef:	c3                   	ret    
  8031f0:	0f bd e8             	bsr    %eax,%ebp
  8031f3:	83 f5 1f             	xor    $0x1f,%ebp
  8031f6:	75 20                	jne    803218 <__umoddi3+0x98>
  8031f8:	39 d8                	cmp    %ebx,%eax
  8031fa:	0f 82 b0 00 00 00    	jb     8032b0 <__umoddi3+0x130>
  803200:	39 f7                	cmp    %esi,%edi
  803202:	0f 86 a8 00 00 00    	jbe    8032b0 <__umoddi3+0x130>
  803208:	89 c8                	mov    %ecx,%eax
  80320a:	83 c4 1c             	add    $0x1c,%esp
  80320d:	5b                   	pop    %ebx
  80320e:	5e                   	pop    %esi
  80320f:	5f                   	pop    %edi
  803210:	5d                   	pop    %ebp
  803211:	c3                   	ret    
  803212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803218:	89 e9                	mov    %ebp,%ecx
  80321a:	ba 20 00 00 00       	mov    $0x20,%edx
  80321f:	29 ea                	sub    %ebp,%edx
  803221:	d3 e0                	shl    %cl,%eax
  803223:	89 44 24 08          	mov    %eax,0x8(%esp)
  803227:	89 d1                	mov    %edx,%ecx
  803229:	89 f8                	mov    %edi,%eax
  80322b:	d3 e8                	shr    %cl,%eax
  80322d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803231:	89 54 24 04          	mov    %edx,0x4(%esp)
  803235:	8b 54 24 04          	mov    0x4(%esp),%edx
  803239:	09 c1                	or     %eax,%ecx
  80323b:	89 d8                	mov    %ebx,%eax
  80323d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803241:	89 e9                	mov    %ebp,%ecx
  803243:	d3 e7                	shl    %cl,%edi
  803245:	89 d1                	mov    %edx,%ecx
  803247:	d3 e8                	shr    %cl,%eax
  803249:	89 e9                	mov    %ebp,%ecx
  80324b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80324f:	d3 e3                	shl    %cl,%ebx
  803251:	89 c7                	mov    %eax,%edi
  803253:	89 d1                	mov    %edx,%ecx
  803255:	89 f0                	mov    %esi,%eax
  803257:	d3 e8                	shr    %cl,%eax
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	89 fa                	mov    %edi,%edx
  80325d:	d3 e6                	shl    %cl,%esi
  80325f:	09 d8                	or     %ebx,%eax
  803261:	f7 74 24 08          	divl   0x8(%esp)
  803265:	89 d1                	mov    %edx,%ecx
  803267:	89 f3                	mov    %esi,%ebx
  803269:	f7 64 24 0c          	mull   0xc(%esp)
  80326d:	89 c6                	mov    %eax,%esi
  80326f:	89 d7                	mov    %edx,%edi
  803271:	39 d1                	cmp    %edx,%ecx
  803273:	72 06                	jb     80327b <__umoddi3+0xfb>
  803275:	75 10                	jne    803287 <__umoddi3+0x107>
  803277:	39 c3                	cmp    %eax,%ebx
  803279:	73 0c                	jae    803287 <__umoddi3+0x107>
  80327b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80327f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803283:	89 d7                	mov    %edx,%edi
  803285:	89 c6                	mov    %eax,%esi
  803287:	89 ca                	mov    %ecx,%edx
  803289:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80328e:	29 f3                	sub    %esi,%ebx
  803290:	19 fa                	sbb    %edi,%edx
  803292:	89 d0                	mov    %edx,%eax
  803294:	d3 e0                	shl    %cl,%eax
  803296:	89 e9                	mov    %ebp,%ecx
  803298:	d3 eb                	shr    %cl,%ebx
  80329a:	d3 ea                	shr    %cl,%edx
  80329c:	09 d8                	or     %ebx,%eax
  80329e:	83 c4 1c             	add    $0x1c,%esp
  8032a1:	5b                   	pop    %ebx
  8032a2:	5e                   	pop    %esi
  8032a3:	5f                   	pop    %edi
  8032a4:	5d                   	pop    %ebp
  8032a5:	c3                   	ret    
  8032a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032ad:	8d 76 00             	lea    0x0(%esi),%esi
  8032b0:	89 da                	mov    %ebx,%edx
  8032b2:	29 fe                	sub    %edi,%esi
  8032b4:	19 c2                	sbb    %eax,%edx
  8032b6:	89 f1                	mov    %esi,%ecx
  8032b8:	89 c8                	mov    %ecx,%eax
  8032ba:	e9 4b ff ff ff       	jmp    80320a <__umoddi3+0x8a>
