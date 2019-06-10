
obj/user/evilhello2.debug:     file format elf32-i386


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
  80002c:	e8 1c 01 00 00       	call   80014d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <evil>:
struct Segdesc *gdt;
struct Segdesc *entry;

// Call this function with ring0 privilege
void evil()
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
	// Kernel memory access
	*(char*)0xf010000a = 0;
  800037:	c6 05 0a 00 10 f0 00 	movb   $0x0,0xf010000a
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80003e:	bb 49 00 00 00       	mov    $0x49,%ebx
  800043:	ba f8 03 00 00       	mov    $0x3f8,%edx
  800048:	89 d8                	mov    %ebx,%eax
  80004a:	ee                   	out    %al,(%dx)
  80004b:	b9 4e 00 00 00       	mov    $0x4e,%ecx
  800050:	89 c8                	mov    %ecx,%eax
  800052:	ee                   	out    %al,(%dx)
  800053:	b8 20 00 00 00       	mov    $0x20,%eax
  800058:	ee                   	out    %al,(%dx)
  800059:	b8 52 00 00 00       	mov    $0x52,%eax
  80005e:	ee                   	out    %al,(%dx)
  80005f:	89 d8                	mov    %ebx,%eax
  800061:	ee                   	out    %al,(%dx)
  800062:	89 c8                	mov    %ecx,%eax
  800064:	ee                   	out    %al,(%dx)
  800065:	b8 47 00 00 00       	mov    $0x47,%eax
  80006a:	ee                   	out    %al,(%dx)
  80006b:	b8 30 00 00 00       	mov    $0x30,%eax
  800070:	ee                   	out    %al,(%dx)
  800071:	b8 21 00 00 00       	mov    $0x21,%eax
  800076:	ee                   	out    %al,(%dx)
  800077:	ee                   	out    %al,(%dx)
  800078:	ee                   	out    %al,(%dx)
  800079:	b8 0a 00 00 00       	mov    $0xa,%eax
  80007e:	ee                   	out    %al,(%dx)
	outb(0x3f8, '0');
	outb(0x3f8, '!');
	outb(0x3f8, '!');
	outb(0x3f8, '!');
	outb(0x3f8, '\n');
}
  80007f:	5b                   	pop    %ebx
  800080:	5d                   	pop    %ebp
  800081:	c3                   	ret    

00800082 <call_fun_ptr>:

void call_fun_ptr()
{
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	83 ec 08             	sub    $0x8,%esp
    evil();  
  800088:	e8 a6 ff ff ff       	call   800033 <evil>
    *entry = old;  
  80008d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  800093:	a1 44 50 80 00       	mov    0x805044,%eax
  800098:	8b 15 48 50 80 00    	mov    0x805048,%edx
  80009e:	89 01                	mov    %eax,(%ecx)
  8000a0:	89 51 04             	mov    %edx,0x4(%ecx)
    //asm volatile("popl %ebp");
    asm volatile("leave");
  8000a3:	c9                   	leave  
    asm volatile("lret");   
  8000a4:	cb                   	lret   
}
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <ring0_call>:
{
	__asm __volatile("sgdt %0" :  "=m" (*gdtd));
}

// Invoke a given function pointer with ring0 privilege, then return to ring3
void ring0_call(void (*fun_ptr)(void)) {
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 20             	sub    $0x20,%esp
	__asm __volatile("sgdt %0" :  "=m" (*gdtd));
  8000ad:	0f 01 45 f2          	sgdtl  -0xe(%ebp)

    // Lab3 : Your Code Here
    struct Pseudodesc r_gdt; 
    sgdt(&r_gdt);

    int t = sys_map_kernel_page((void* )r_gdt.pd_base, (void* )vaddr);
  8000b1:	68 40 40 80 00       	push   $0x804040
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	e8 73 0f 00 00       	call   801031 <sys_map_kernel_page>
    if (t < 0) {
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 5b                	js     800120 <ring0_call+0x79>
        cprintf("ring0_call: sys_map_kernel_page failed, %e\n", t);
    }

    uint32_t base = (uint32_t)(PGNUM(vaddr) << PTXSHIFT);
    uint32_t index = GD_UD >> 3;
    uint32_t offset = PGOFF(r_gdt.pd_base);
  8000c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8000c8:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    uint32_t base = (uint32_t)(PGNUM(vaddr) << PTXSHIFT);
  8000ce:	b8 40 40 80 00       	mov    $0x804040,%eax
  8000d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax

    gdt = (struct Segdesc*)(base+offset); 
  8000d8:	09 c1                	or     %eax,%ecx
  8000da:	89 0d 40 50 80 00    	mov    %ecx,0x805040
    entry = gdt + index; 
  8000e0:	8d 41 20             	lea    0x20(%ecx),%eax
  8000e3:	a3 20 40 80 00       	mov    %eax,0x804020
    old= *entry; 
  8000e8:	8b 41 20             	mov    0x20(%ecx),%eax
  8000eb:	8b 51 24             	mov    0x24(%ecx),%edx
  8000ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8000f3:	89 15 48 50 80 00    	mov    %edx,0x805048

    SETCALLGATE(*((struct Gatedesc*)entry), GD_KT, call_fun_ptr, 3);
  8000f9:	b8 82 00 80 00       	mov    $0x800082,%eax
  8000fe:	66 89 41 20          	mov    %ax,0x20(%ecx)
  800102:	66 c7 41 22 08 00    	movw   $0x8,0x22(%ecx)
  800108:	c6 41 24 00          	movb   $0x0,0x24(%ecx)
  80010c:	c6 41 25 ec          	movb   $0xec,0x25(%ecx)
  800110:	c1 e8 10             	shr    $0x10,%eax
  800113:	66 89 41 26          	mov    %ax,0x26(%ecx)
    asm volatile("lcall $0x20, $0");
  800117:	9a 00 00 00 00 20 00 	lcall  $0x20,$0x0
}
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    
        cprintf("ring0_call: sys_map_kernel_page failed, %e\n", t);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	50                   	push   %eax
  800124:	68 80 26 80 00       	push   $0x802680
  800129:	e8 c1 01 00 00       	call   8002ef <cprintf>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb 92                	jmp    8000c5 <ring0_call+0x1e>

00800133 <umain>:

void
umain(int argc, char **argv)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	83 ec 14             	sub    $0x14,%esp
        // call the evil function in ring0
	ring0_call(&evil);
  800139:	68 33 00 80 00       	push   $0x800033
  80013e:	e8 64 ff ff ff       	call   8000a7 <ring0_call>

	// call the evil function in ring3
	evil();
  800143:	e8 eb fe ff ff       	call   800033 <evil>
}
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800156:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80015d:	00 00 00 
	envid_t find = sys_getenvid();
  800160:	e8 9d 0c 00 00       	call   800e02 <sys_getenvid>
  800165:	8b 1d 4c 50 80 00    	mov    0x80504c,%ebx
  80016b:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800170:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800175:	bf 01 00 00 00       	mov    $0x1,%edi
  80017a:	eb 0b                	jmp    800187 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80017c:	83 c2 01             	add    $0x1,%edx
  80017f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800185:	74 21                	je     8001a8 <libmain+0x5b>
		if(envs[i].env_id == find)
  800187:	89 d1                	mov    %edx,%ecx
  800189:	c1 e1 07             	shl    $0x7,%ecx
  80018c:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800192:	8b 49 48             	mov    0x48(%ecx),%ecx
  800195:	39 c1                	cmp    %eax,%ecx
  800197:	75 e3                	jne    80017c <libmain+0x2f>
  800199:	89 d3                	mov    %edx,%ebx
  80019b:	c1 e3 07             	shl    $0x7,%ebx
  80019e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001a4:	89 fe                	mov    %edi,%esi
  8001a6:	eb d4                	jmp    80017c <libmain+0x2f>
  8001a8:	89 f0                	mov    %esi,%eax
  8001aa:	84 c0                	test   %al,%al
  8001ac:	74 06                	je     8001b4 <libmain+0x67>
  8001ae:	89 1d 4c 50 80 00    	mov    %ebx,0x80504c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001b8:	7e 0a                	jle    8001c4 <libmain+0x77>
		binaryname = argv[0];
  8001ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bd:	8b 00                	mov    (%eax),%eax
  8001bf:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8001c9:	8b 40 48             	mov    0x48(%eax),%eax
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	68 ac 26 80 00       	push   $0x8026ac
  8001d5:	e8 15 01 00 00       	call   8002ef <cprintf>
	cprintf("before umain\n");
  8001da:	c7 04 24 ca 26 80 00 	movl   $0x8026ca,(%esp)
  8001e1:	e8 09 01 00 00       	call   8002ef <cprintf>
	// call user main routine
	umain(argc, argv);
  8001e6:	83 c4 08             	add    $0x8,%esp
  8001e9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ec:	ff 75 08             	pushl  0x8(%ebp)
  8001ef:	e8 3f ff ff ff       	call   800133 <umain>
	cprintf("after umain\n");
  8001f4:	c7 04 24 d8 26 80 00 	movl   $0x8026d8,(%esp)
  8001fb:	e8 ef 00 00 00       	call   8002ef <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800200:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800205:	8b 40 48             	mov    0x48(%eax),%eax
  800208:	83 c4 08             	add    $0x8,%esp
  80020b:	50                   	push   %eax
  80020c:	68 e5 26 80 00       	push   $0x8026e5
  800211:	e8 d9 00 00 00       	call   8002ef <cprintf>
	// exit gracefully
	exit();
  800216:	e8 0b 00 00 00       	call   800226 <exit>
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5f                   	pop    %edi
  800224:	5d                   	pop    %ebp
  800225:	c3                   	ret    

00800226 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80022c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800231:	8b 40 48             	mov    0x48(%eax),%eax
  800234:	68 10 27 80 00       	push   $0x802710
  800239:	50                   	push   %eax
  80023a:	68 04 27 80 00       	push   $0x802704
  80023f:	e8 ab 00 00 00       	call   8002ef <cprintf>
	close_all();
  800244:	e8 c4 10 00 00       	call   80130d <close_all>
	sys_env_destroy(0);
  800249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800250:	e8 6c 0b 00 00       	call   800dc1 <sys_env_destroy>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	53                   	push   %ebx
  80025e:	83 ec 04             	sub    $0x4,%esp
  800261:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800264:	8b 13                	mov    (%ebx),%edx
  800266:	8d 42 01             	lea    0x1(%edx),%eax
  800269:	89 03                	mov    %eax,(%ebx)
  80026b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80026e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800272:	3d ff 00 00 00       	cmp    $0xff,%eax
  800277:	74 09                	je     800282 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800279:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800280:	c9                   	leave  
  800281:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	68 ff 00 00 00       	push   $0xff
  80028a:	8d 43 08             	lea    0x8(%ebx),%eax
  80028d:	50                   	push   %eax
  80028e:	e8 f1 0a 00 00       	call   800d84 <sys_cputs>
		b->idx = 0;
  800293:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	eb db                	jmp    800279 <putch+0x1f>

0080029e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ae:	00 00 00 
	b.cnt = 0;
  8002b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c7:	50                   	push   %eax
  8002c8:	68 5a 02 80 00       	push   $0x80025a
  8002cd:	e8 4a 01 00 00       	call   80041c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002d2:	83 c4 08             	add    $0x8,%esp
  8002d5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002db:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e1:	50                   	push   %eax
  8002e2:	e8 9d 0a 00 00       	call   800d84 <sys_cputs>

	return b.cnt;
}
  8002e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f8:	50                   	push   %eax
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 9d ff ff ff       	call   80029e <vcprintf>
	va_end(ap);

	return cnt;
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 1c             	sub    $0x1c,%esp
  80030c:	89 c6                	mov    %eax,%esi
  80030e:	89 d7                	mov    %edx,%edi
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	8b 55 0c             	mov    0xc(%ebp),%edx
  800316:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800319:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80031c:	8b 45 10             	mov    0x10(%ebp),%eax
  80031f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800322:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800326:	74 2c                	je     800354 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800328:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800332:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800335:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800338:	39 c2                	cmp    %eax,%edx
  80033a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80033d:	73 43                	jae    800382 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80033f:	83 eb 01             	sub    $0x1,%ebx
  800342:	85 db                	test   %ebx,%ebx
  800344:	7e 6c                	jle    8003b2 <printnum+0xaf>
				putch(padc, putdat);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	57                   	push   %edi
  80034a:	ff 75 18             	pushl  0x18(%ebp)
  80034d:	ff d6                	call   *%esi
  80034f:	83 c4 10             	add    $0x10,%esp
  800352:	eb eb                	jmp    80033f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	6a 20                	push   $0x20
  800359:	6a 00                	push   $0x0
  80035b:	50                   	push   %eax
  80035c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035f:	ff 75 e0             	pushl  -0x20(%ebp)
  800362:	89 fa                	mov    %edi,%edx
  800364:	89 f0                	mov    %esi,%eax
  800366:	e8 98 ff ff ff       	call   800303 <printnum>
		while (--width > 0)
  80036b:	83 c4 20             	add    $0x20,%esp
  80036e:	83 eb 01             	sub    $0x1,%ebx
  800371:	85 db                	test   %ebx,%ebx
  800373:	7e 65                	jle    8003da <printnum+0xd7>
			putch(padc, putdat);
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	57                   	push   %edi
  800379:	6a 20                	push   $0x20
  80037b:	ff d6                	call   *%esi
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	eb ec                	jmp    80036e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	ff 75 18             	pushl  0x18(%ebp)
  800388:	83 eb 01             	sub    $0x1,%ebx
  80038b:	53                   	push   %ebx
  80038c:	50                   	push   %eax
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	ff 75 dc             	pushl  -0x24(%ebp)
  800393:	ff 75 d8             	pushl  -0x28(%ebp)
  800396:	ff 75 e4             	pushl  -0x1c(%ebp)
  800399:	ff 75 e0             	pushl  -0x20(%ebp)
  80039c:	e8 8f 20 00 00       	call   802430 <__udivdi3>
  8003a1:	83 c4 18             	add    $0x18,%esp
  8003a4:	52                   	push   %edx
  8003a5:	50                   	push   %eax
  8003a6:	89 fa                	mov    %edi,%edx
  8003a8:	89 f0                	mov    %esi,%eax
  8003aa:	e8 54 ff ff ff       	call   800303 <printnum>
  8003af:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	57                   	push   %edi
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8003bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c5:	e8 76 21 00 00       	call   802540 <__umoddi3>
  8003ca:	83 c4 14             	add    $0x14,%esp
  8003cd:	0f be 80 15 27 80 00 	movsbl 0x802715(%eax),%eax
  8003d4:	50                   	push   %eax
  8003d5:	ff d6                	call   *%esi
  8003d7:	83 c4 10             	add    $0x10,%esp
	}
}
  8003da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003dd:	5b                   	pop    %ebx
  8003de:	5e                   	pop    %esi
  8003df:	5f                   	pop    %edi
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f1:	73 0a                	jae    8003fd <sprintputch+0x1b>
		*b->buf++ = ch;
  8003f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f6:	89 08                	mov    %ecx,(%eax)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	88 02                	mov    %al,(%edx)
}
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <printfmt>:
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800405:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800408:	50                   	push   %eax
  800409:	ff 75 10             	pushl  0x10(%ebp)
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	e8 05 00 00 00       	call   80041c <vprintfmt>
}
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <vprintfmt>:
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	57                   	push   %edi
  800420:	56                   	push   %esi
  800421:	53                   	push   %ebx
  800422:	83 ec 3c             	sub    $0x3c,%esp
  800425:	8b 75 08             	mov    0x8(%ebp),%esi
  800428:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80042b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80042e:	e9 32 04 00 00       	jmp    800865 <vprintfmt+0x449>
		padc = ' ';
  800433:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800437:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80043e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800445:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800453:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80045a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045f:	8d 47 01             	lea    0x1(%edi),%eax
  800462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800465:	0f b6 17             	movzbl (%edi),%edx
  800468:	8d 42 dd             	lea    -0x23(%edx),%eax
  80046b:	3c 55                	cmp    $0x55,%al
  80046d:	0f 87 12 05 00 00    	ja     800985 <vprintfmt+0x569>
  800473:	0f b6 c0             	movzbl %al,%eax
  800476:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800480:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800484:	eb d9                	jmp    80045f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800489:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80048d:	eb d0                	jmp    80045f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80048f:	0f b6 d2             	movzbl %dl,%edx
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800495:	b8 00 00 00 00       	mov    $0x0,%eax
  80049a:	89 75 08             	mov    %esi,0x8(%ebp)
  80049d:	eb 03                	jmp    8004a2 <vprintfmt+0x86>
  80049f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ac:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004af:	83 fe 09             	cmp    $0x9,%esi
  8004b2:	76 eb                	jbe    80049f <vprintfmt+0x83>
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ba:	eb 14                	jmp    8004d0 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d4:	79 89                	jns    80045f <vprintfmt+0x43>
				width = precision, precision = -1;
  8004d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e3:	e9 77 ff ff ff       	jmp    80045f <vprintfmt+0x43>
  8004e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	0f 48 c1             	cmovs  %ecx,%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f6:	e9 64 ff ff ff       	jmp    80045f <vprintfmt+0x43>
  8004fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004fe:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800505:	e9 55 ff ff ff       	jmp    80045f <vprintfmt+0x43>
			lflag++;
  80050a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800511:	e9 49 ff ff ff       	jmp    80045f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8d 78 04             	lea    0x4(%eax),%edi
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	ff 30                	pushl  (%eax)
  800522:	ff d6                	call   *%esi
			break;
  800524:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800527:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80052a:	e9 33 03 00 00       	jmp    800862 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8d 78 04             	lea    0x4(%eax),%edi
  800535:	8b 00                	mov    (%eax),%eax
  800537:	99                   	cltd   
  800538:	31 d0                	xor    %edx,%eax
  80053a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053c:	83 f8 11             	cmp    $0x11,%eax
  80053f:	7f 23                	jg     800564 <vprintfmt+0x148>
  800541:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  800548:	85 d2                	test   %edx,%edx
  80054a:	74 18                	je     800564 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80054c:	52                   	push   %edx
  80054d:	68 7d 2b 80 00       	push   $0x802b7d
  800552:	53                   	push   %ebx
  800553:	56                   	push   %esi
  800554:	e8 a6 fe ff ff       	call   8003ff <printfmt>
  800559:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055f:	e9 fe 02 00 00       	jmp    800862 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800564:	50                   	push   %eax
  800565:	68 2d 27 80 00       	push   $0x80272d
  80056a:	53                   	push   %ebx
  80056b:	56                   	push   %esi
  80056c:	e8 8e fe ff ff       	call   8003ff <printfmt>
  800571:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800574:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800577:	e9 e6 02 00 00       	jmp    800862 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	83 c0 04             	add    $0x4,%eax
  800582:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80058a:	85 c9                	test   %ecx,%ecx
  80058c:	b8 26 27 80 00       	mov    $0x802726,%eax
  800591:	0f 45 c1             	cmovne %ecx,%eax
  800594:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800597:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059b:	7e 06                	jle    8005a3 <vprintfmt+0x187>
  80059d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005a1:	75 0d                	jne    8005b0 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a6:	89 c7                	mov    %eax,%edi
  8005a8:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ae:	eb 53                	jmp    800603 <vprintfmt+0x1e7>
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b6:	50                   	push   %eax
  8005b7:	e8 71 04 00 00       	call   800a2d <strnlen>
  8005bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bf:	29 c1                	sub    %eax,%ecx
  8005c1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005c9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d0:	eb 0f                	jmp    8005e1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	83 ef 01             	sub    $0x1,%edi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	85 ff                	test   %edi,%edi
  8005e3:	7f ed                	jg     8005d2 <vprintfmt+0x1b6>
  8005e5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005e8:	85 c9                	test   %ecx,%ecx
  8005ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ef:	0f 49 c1             	cmovns %ecx,%eax
  8005f2:	29 c1                	sub    %eax,%ecx
  8005f4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005f7:	eb aa                	jmp    8005a3 <vprintfmt+0x187>
					putch(ch, putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	52                   	push   %edx
  8005fe:	ff d6                	call   *%esi
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800606:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800608:	83 c7 01             	add    $0x1,%edi
  80060b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060f:	0f be d0             	movsbl %al,%edx
  800612:	85 d2                	test   %edx,%edx
  800614:	74 4b                	je     800661 <vprintfmt+0x245>
  800616:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061a:	78 06                	js     800622 <vprintfmt+0x206>
  80061c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800620:	78 1e                	js     800640 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800622:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800626:	74 d1                	je     8005f9 <vprintfmt+0x1dd>
  800628:	0f be c0             	movsbl %al,%eax
  80062b:	83 e8 20             	sub    $0x20,%eax
  80062e:	83 f8 5e             	cmp    $0x5e,%eax
  800631:	76 c6                	jbe    8005f9 <vprintfmt+0x1dd>
					putch('?', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	6a 3f                	push   $0x3f
  800639:	ff d6                	call   *%esi
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	eb c3                	jmp    800603 <vprintfmt+0x1e7>
  800640:	89 cf                	mov    %ecx,%edi
  800642:	eb 0e                	jmp    800652 <vprintfmt+0x236>
				putch(' ', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 20                	push   $0x20
  80064a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064c:	83 ef 01             	sub    $0x1,%edi
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	85 ff                	test   %edi,%edi
  800654:	7f ee                	jg     800644 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800656:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	e9 01 02 00 00       	jmp    800862 <vprintfmt+0x446>
  800661:	89 cf                	mov    %ecx,%edi
  800663:	eb ed                	jmp    800652 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800665:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800668:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80066f:	e9 eb fd ff ff       	jmp    80045f <vprintfmt+0x43>
	if (lflag >= 2)
  800674:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800678:	7f 21                	jg     80069b <vprintfmt+0x27f>
	else if (lflag)
  80067a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80067e:	74 68                	je     8006e8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800688:	89 c1                	mov    %eax,%ecx
  80068a:	c1 f9 1f             	sar    $0x1f,%ecx
  80068d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 40 04             	lea    0x4(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
  800699:	eb 17                	jmp    8006b2 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 50 04             	mov    0x4(%eax),%edx
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 08             	lea    0x8(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c2:	78 3f                	js     800703 <vprintfmt+0x2e7>
			base = 10;
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006c9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006cd:	0f 84 71 01 00 00    	je     800844 <vprintfmt+0x428>
				putch('+', putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	6a 2b                	push   $0x2b
  8006d9:	ff d6                	call   *%esi
  8006db:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e3:	e9 5c 01 00 00       	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f0:	89 c1                	mov    %eax,%ecx
  8006f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800701:	eb af                	jmp    8006b2 <vprintfmt+0x296>
				putch('-', putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	6a 2d                	push   $0x2d
  800709:	ff d6                	call   *%esi
				num = -(long long) num;
  80070b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80070e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800711:	f7 d8                	neg    %eax
  800713:	83 d2 00             	adc    $0x0,%edx
  800716:	f7 da                	neg    %edx
  800718:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800721:	b8 0a 00 00 00       	mov    $0xa,%eax
  800726:	e9 19 01 00 00       	jmp    800844 <vprintfmt+0x428>
	if (lflag >= 2)
  80072b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80072f:	7f 29                	jg     80075a <vprintfmt+0x33e>
	else if (lflag)
  800731:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800735:	74 44                	je     80077b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	ba 00 00 00 00       	mov    $0x0,%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800750:	b8 0a 00 00 00       	mov    $0xa,%eax
  800755:	e9 ea 00 00 00       	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 50 04             	mov    0x4(%eax),%edx
  800760:	8b 00                	mov    (%eax),%eax
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8d 40 08             	lea    0x8(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800771:	b8 0a 00 00 00       	mov    $0xa,%eax
  800776:	e9 c9 00 00 00       	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800794:	b8 0a 00 00 00       	mov    $0xa,%eax
  800799:	e9 a6 00 00 00       	jmp    800844 <vprintfmt+0x428>
			putch('0', putdat);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	53                   	push   %ebx
  8007a2:	6a 30                	push   $0x30
  8007a4:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ad:	7f 26                	jg     8007d5 <vprintfmt+0x3b9>
	else if (lflag)
  8007af:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b3:	74 3e                	je     8007f3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 04             	lea    0x4(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d3:	eb 6f                	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 50 04             	mov    0x4(%eax),%edx
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 08             	lea    0x8(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f1:	eb 51                	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080c:	b8 08 00 00 00       	mov    $0x8,%eax
  800811:	eb 31                	jmp    800844 <vprintfmt+0x428>
			putch('0', putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	6a 30                	push   $0x30
  800819:	ff d6                	call   *%esi
			putch('x', putdat);
  80081b:	83 c4 08             	add    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	6a 78                	push   $0x78
  800821:	ff d6                	call   *%esi
			num = (unsigned long long)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
  80082d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800830:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800833:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800844:	83 ec 0c             	sub    $0xc,%esp
  800847:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80084b:	52                   	push   %edx
  80084c:	ff 75 e0             	pushl  -0x20(%ebp)
  80084f:	50                   	push   %eax
  800850:	ff 75 dc             	pushl  -0x24(%ebp)
  800853:	ff 75 d8             	pushl  -0x28(%ebp)
  800856:	89 da                	mov    %ebx,%edx
  800858:	89 f0                	mov    %esi,%eax
  80085a:	e8 a4 fa ff ff       	call   800303 <printnum>
			break;
  80085f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800862:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	83 c7 01             	add    $0x1,%edi
  800868:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80086c:	83 f8 25             	cmp    $0x25,%eax
  80086f:	0f 84 be fb ff ff    	je     800433 <vprintfmt+0x17>
			if (ch == '\0')
  800875:	85 c0                	test   %eax,%eax
  800877:	0f 84 28 01 00 00    	je     8009a5 <vprintfmt+0x589>
			putch(ch, putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	53                   	push   %ebx
  800881:	50                   	push   %eax
  800882:	ff d6                	call   *%esi
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	eb dc                	jmp    800865 <vprintfmt+0x449>
	if (lflag >= 2)
  800889:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088d:	7f 26                	jg     8008b5 <vprintfmt+0x499>
	else if (lflag)
  80088f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800893:	74 41                	je     8008d6 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	ba 00 00 00 00       	mov    $0x0,%edx
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b3:	eb 8f                	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8b 50 04             	mov    0x4(%eax),%edx
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 08             	lea    0x8(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cc:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d1:	e9 6e ff ff ff       	jmp    800844 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ef:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f4:	e9 4b ff ff ff       	jmp    800844 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 14                	je     80091f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80090b:	8b 13                	mov    (%ebx),%edx
  80090d:	83 fa 7f             	cmp    $0x7f,%edx
  800910:	7f 37                	jg     800949 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800912:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800914:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
  80091a:	e9 43 ff ff ff       	jmp    800862 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80091f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800924:	bf 49 28 80 00       	mov    $0x802849,%edi
							putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	53                   	push   %ebx
  80092d:	50                   	push   %eax
  80092e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800930:	83 c7 01             	add    $0x1,%edi
  800933:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800937:	83 c4 10             	add    $0x10,%esp
  80093a:	85 c0                	test   %eax,%eax
  80093c:	75 eb                	jne    800929 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80093e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
  800944:	e9 19 ff ff ff       	jmp    800862 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800949:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80094b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800950:	bf 81 28 80 00       	mov    $0x802881,%edi
							putch(ch, putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	53                   	push   %ebx
  800959:	50                   	push   %eax
  80095a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80095c:	83 c7 01             	add    $0x1,%edi
  80095f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	85 c0                	test   %eax,%eax
  800968:	75 eb                	jne    800955 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80096a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80096d:	89 45 14             	mov    %eax,0x14(%ebp)
  800970:	e9 ed fe ff ff       	jmp    800862 <vprintfmt+0x446>
			putch(ch, putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	53                   	push   %ebx
  800979:	6a 25                	push   $0x25
  80097b:	ff d6                	call   *%esi
			break;
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	e9 dd fe ff ff       	jmp    800862 <vprintfmt+0x446>
			putch('%', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	53                   	push   %ebx
  800989:	6a 25                	push   $0x25
  80098b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80098d:	83 c4 10             	add    $0x10,%esp
  800990:	89 f8                	mov    %edi,%eax
  800992:	eb 03                	jmp    800997 <vprintfmt+0x57b>
  800994:	83 e8 01             	sub    $0x1,%eax
  800997:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80099b:	75 f7                	jne    800994 <vprintfmt+0x578>
  80099d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a0:	e9 bd fe ff ff       	jmp    800862 <vprintfmt+0x446>
}
  8009a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5f                   	pop    %edi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	83 ec 18             	sub    $0x18,%esp
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ca:	85 c0                	test   %eax,%eax
  8009cc:	74 26                	je     8009f4 <vsnprintf+0x47>
  8009ce:	85 d2                	test   %edx,%edx
  8009d0:	7e 22                	jle    8009f4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d2:	ff 75 14             	pushl  0x14(%ebp)
  8009d5:	ff 75 10             	pushl  0x10(%ebp)
  8009d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009db:	50                   	push   %eax
  8009dc:	68 e2 03 80 00       	push   $0x8003e2
  8009e1:	e8 36 fa ff ff       	call   80041c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
}
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    
		return -E_INVAL;
  8009f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f9:	eb f7                	jmp    8009f2 <vsnprintf+0x45>

008009fb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a01:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a04:	50                   	push   %eax
  800a05:	ff 75 10             	pushl  0x10(%ebp)
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	ff 75 08             	pushl  0x8(%ebp)
  800a0e:	e8 9a ff ff ff       	call   8009ad <vsnprintf>
	va_end(ap);

	return rc;
}
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a24:	74 05                	je     800a2b <strlen+0x16>
		n++;
  800a26:	83 c0 01             	add    $0x1,%eax
  800a29:	eb f5                	jmp    800a20 <strlen+0xb>
	return n;
}
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	39 c2                	cmp    %eax,%edx
  800a3d:	74 0d                	je     800a4c <strnlen+0x1f>
  800a3f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a43:	74 05                	je     800a4a <strnlen+0x1d>
		n++;
  800a45:	83 c2 01             	add    $0x1,%edx
  800a48:	eb f1                	jmp    800a3b <strnlen+0xe>
  800a4a:	89 d0                	mov    %edx,%eax
	return n;
}
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	53                   	push   %ebx
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a58:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a61:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a64:	83 c2 01             	add    $0x1,%edx
  800a67:	84 c9                	test   %cl,%cl
  800a69:	75 f2                	jne    800a5d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a6b:	5b                   	pop    %ebx
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	53                   	push   %ebx
  800a72:	83 ec 10             	sub    $0x10,%esp
  800a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a78:	53                   	push   %ebx
  800a79:	e8 97 ff ff ff       	call   800a15 <strlen>
  800a7e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	01 d8                	add    %ebx,%eax
  800a86:	50                   	push   %eax
  800a87:	e8 c2 ff ff ff       	call   800a4e <strcpy>
	return dst;
}
  800a8c:	89 d8                	mov    %ebx,%eax
  800a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9e:	89 c6                	mov    %eax,%esi
  800aa0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	39 f2                	cmp    %esi,%edx
  800aa7:	74 11                	je     800aba <strncpy+0x27>
		*dst++ = *src;
  800aa9:	83 c2 01             	add    $0x1,%edx
  800aac:	0f b6 19             	movzbl (%ecx),%ebx
  800aaf:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab2:	80 fb 01             	cmp    $0x1,%bl
  800ab5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ab8:	eb eb                	jmp    800aa5 <strncpy+0x12>
	}
	return ret;
}
  800aba:	5b                   	pop    %ebx
  800abb:	5e                   	pop    %esi
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
  800ac3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac9:	8b 55 10             	mov    0x10(%ebp),%edx
  800acc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ace:	85 d2                	test   %edx,%edx
  800ad0:	74 21                	je     800af3 <strlcpy+0x35>
  800ad2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ad6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad8:	39 c2                	cmp    %eax,%edx
  800ada:	74 14                	je     800af0 <strlcpy+0x32>
  800adc:	0f b6 19             	movzbl (%ecx),%ebx
  800adf:	84 db                	test   %bl,%bl
  800ae1:	74 0b                	je     800aee <strlcpy+0x30>
			*dst++ = *src++;
  800ae3:	83 c1 01             	add    $0x1,%ecx
  800ae6:	83 c2 01             	add    $0x1,%edx
  800ae9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aec:	eb ea                	jmp    800ad8 <strlcpy+0x1a>
  800aee:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800af0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af3:	29 f0                	sub    %esi,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b02:	0f b6 01             	movzbl (%ecx),%eax
  800b05:	84 c0                	test   %al,%al
  800b07:	74 0c                	je     800b15 <strcmp+0x1c>
  800b09:	3a 02                	cmp    (%edx),%al
  800b0b:	75 08                	jne    800b15 <strcmp+0x1c>
		p++, q++;
  800b0d:	83 c1 01             	add    $0x1,%ecx
  800b10:	83 c2 01             	add    $0x1,%edx
  800b13:	eb ed                	jmp    800b02 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	0f b6 12             	movzbl (%edx),%edx
  800b1b:	29 d0                	sub    %edx,%eax
}
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	53                   	push   %ebx
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 c3                	mov    %eax,%ebx
  800b2b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2e:	eb 06                	jmp    800b36 <strncmp+0x17>
		n--, p++, q++;
  800b30:	83 c0 01             	add    $0x1,%eax
  800b33:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b36:	39 d8                	cmp    %ebx,%eax
  800b38:	74 16                	je     800b50 <strncmp+0x31>
  800b3a:	0f b6 08             	movzbl (%eax),%ecx
  800b3d:	84 c9                	test   %cl,%cl
  800b3f:	74 04                	je     800b45 <strncmp+0x26>
  800b41:	3a 0a                	cmp    (%edx),%cl
  800b43:	74 eb                	je     800b30 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b45:	0f b6 00             	movzbl (%eax),%eax
  800b48:	0f b6 12             	movzbl (%edx),%edx
  800b4b:	29 d0                	sub    %edx,%eax
}
  800b4d:	5b                   	pop    %ebx
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    
		return 0;
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	eb f6                	jmp    800b4d <strncmp+0x2e>

00800b57 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b61:	0f b6 10             	movzbl (%eax),%edx
  800b64:	84 d2                	test   %dl,%dl
  800b66:	74 09                	je     800b71 <strchr+0x1a>
		if (*s == c)
  800b68:	38 ca                	cmp    %cl,%dl
  800b6a:	74 0a                	je     800b76 <strchr+0x1f>
	for (; *s; s++)
  800b6c:	83 c0 01             	add    $0x1,%eax
  800b6f:	eb f0                	jmp    800b61 <strchr+0xa>
			return (char *) s;
	return 0;
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b82:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b85:	38 ca                	cmp    %cl,%dl
  800b87:	74 09                	je     800b92 <strfind+0x1a>
  800b89:	84 d2                	test   %dl,%dl
  800b8b:	74 05                	je     800b92 <strfind+0x1a>
	for (; *s; s++)
  800b8d:	83 c0 01             	add    $0x1,%eax
  800b90:	eb f0                	jmp    800b82 <strfind+0xa>
			break;
	return (char *) s;
}
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
  800b9a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba0:	85 c9                	test   %ecx,%ecx
  800ba2:	74 31                	je     800bd5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba4:	89 f8                	mov    %edi,%eax
  800ba6:	09 c8                	or     %ecx,%eax
  800ba8:	a8 03                	test   $0x3,%al
  800baa:	75 23                	jne    800bcf <memset+0x3b>
		c &= 0xFF;
  800bac:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb0:	89 d3                	mov    %edx,%ebx
  800bb2:	c1 e3 08             	shl    $0x8,%ebx
  800bb5:	89 d0                	mov    %edx,%eax
  800bb7:	c1 e0 18             	shl    $0x18,%eax
  800bba:	89 d6                	mov    %edx,%esi
  800bbc:	c1 e6 10             	shl    $0x10,%esi
  800bbf:	09 f0                	or     %esi,%eax
  800bc1:	09 c2                	or     %eax,%edx
  800bc3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bc5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc8:	89 d0                	mov    %edx,%eax
  800bca:	fc                   	cld    
  800bcb:	f3 ab                	rep stos %eax,%es:(%edi)
  800bcd:	eb 06                	jmp    800bd5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	fc                   	cld    
  800bd3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd5:	89 f8                	mov    %edi,%eax
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5f                   	pop    %edi
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bea:	39 c6                	cmp    %eax,%esi
  800bec:	73 32                	jae    800c20 <memmove+0x44>
  800bee:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf1:	39 c2                	cmp    %eax,%edx
  800bf3:	76 2b                	jbe    800c20 <memmove+0x44>
		s += n;
		d += n;
  800bf5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf8:	89 fe                	mov    %edi,%esi
  800bfa:	09 ce                	or     %ecx,%esi
  800bfc:	09 d6                	or     %edx,%esi
  800bfe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c04:	75 0e                	jne    800c14 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c06:	83 ef 04             	sub    $0x4,%edi
  800c09:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c0c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c0f:	fd                   	std    
  800c10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c12:	eb 09                	jmp    800c1d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c14:	83 ef 01             	sub    $0x1,%edi
  800c17:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c1a:	fd                   	std    
  800c1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c1d:	fc                   	cld    
  800c1e:	eb 1a                	jmp    800c3a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c20:	89 c2                	mov    %eax,%edx
  800c22:	09 ca                	or     %ecx,%edx
  800c24:	09 f2                	or     %esi,%edx
  800c26:	f6 c2 03             	test   $0x3,%dl
  800c29:	75 0a                	jne    800c35 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c2e:	89 c7                	mov    %eax,%edi
  800c30:	fc                   	cld    
  800c31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c33:	eb 05                	jmp    800c3a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c35:	89 c7                	mov    %eax,%edi
  800c37:	fc                   	cld    
  800c38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	ff 75 08             	pushl  0x8(%ebp)
  800c4d:	e8 8a ff ff ff       	call   800bdc <memmove>
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5f:	89 c6                	mov    %eax,%esi
  800c61:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c64:	39 f0                	cmp    %esi,%eax
  800c66:	74 1c                	je     800c84 <memcmp+0x30>
		if (*s1 != *s2)
  800c68:	0f b6 08             	movzbl (%eax),%ecx
  800c6b:	0f b6 1a             	movzbl (%edx),%ebx
  800c6e:	38 d9                	cmp    %bl,%cl
  800c70:	75 08                	jne    800c7a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c72:	83 c0 01             	add    $0x1,%eax
  800c75:	83 c2 01             	add    $0x1,%edx
  800c78:	eb ea                	jmp    800c64 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c7a:	0f b6 c1             	movzbl %cl,%eax
  800c7d:	0f b6 db             	movzbl %bl,%ebx
  800c80:	29 d8                	sub    %ebx,%eax
  800c82:	eb 05                	jmp    800c89 <memcmp+0x35>
	}

	return 0;
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c96:	89 c2                	mov    %eax,%edx
  800c98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c9b:	39 d0                	cmp    %edx,%eax
  800c9d:	73 09                	jae    800ca8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9f:	38 08                	cmp    %cl,(%eax)
  800ca1:	74 05                	je     800ca8 <memfind+0x1b>
	for (; s < ends; s++)
  800ca3:	83 c0 01             	add    $0x1,%eax
  800ca6:	eb f3                	jmp    800c9b <memfind+0xe>
			break;
	return (void *) s;
}
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb6:	eb 03                	jmp    800cbb <strtol+0x11>
		s++;
  800cb8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cbb:	0f b6 01             	movzbl (%ecx),%eax
  800cbe:	3c 20                	cmp    $0x20,%al
  800cc0:	74 f6                	je     800cb8 <strtol+0xe>
  800cc2:	3c 09                	cmp    $0x9,%al
  800cc4:	74 f2                	je     800cb8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc6:	3c 2b                	cmp    $0x2b,%al
  800cc8:	74 2a                	je     800cf4 <strtol+0x4a>
	int neg = 0;
  800cca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ccf:	3c 2d                	cmp    $0x2d,%al
  800cd1:	74 2b                	je     800cfe <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd9:	75 0f                	jne    800cea <strtol+0x40>
  800cdb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cde:	74 28                	je     800d08 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce0:	85 db                	test   %ebx,%ebx
  800ce2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce7:	0f 44 d8             	cmove  %eax,%ebx
  800cea:	b8 00 00 00 00       	mov    $0x0,%eax
  800cef:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf2:	eb 50                	jmp    800d44 <strtol+0x9a>
		s++;
  800cf4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfc:	eb d5                	jmp    800cd3 <strtol+0x29>
		s++, neg = 1;
  800cfe:	83 c1 01             	add    $0x1,%ecx
  800d01:	bf 01 00 00 00       	mov    $0x1,%edi
  800d06:	eb cb                	jmp    800cd3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d08:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d0c:	74 0e                	je     800d1c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d0e:	85 db                	test   %ebx,%ebx
  800d10:	75 d8                	jne    800cea <strtol+0x40>
		s++, base = 8;
  800d12:	83 c1 01             	add    $0x1,%ecx
  800d15:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d1a:	eb ce                	jmp    800cea <strtol+0x40>
		s += 2, base = 16;
  800d1c:	83 c1 02             	add    $0x2,%ecx
  800d1f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d24:	eb c4                	jmp    800cea <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d26:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d29:	89 f3                	mov    %esi,%ebx
  800d2b:	80 fb 19             	cmp    $0x19,%bl
  800d2e:	77 29                	ja     800d59 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d30:	0f be d2             	movsbl %dl,%edx
  800d33:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d36:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d39:	7d 30                	jge    800d6b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d3b:	83 c1 01             	add    $0x1,%ecx
  800d3e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d44:	0f b6 11             	movzbl (%ecx),%edx
  800d47:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d4a:	89 f3                	mov    %esi,%ebx
  800d4c:	80 fb 09             	cmp    $0x9,%bl
  800d4f:	77 d5                	ja     800d26 <strtol+0x7c>
			dig = *s - '0';
  800d51:	0f be d2             	movsbl %dl,%edx
  800d54:	83 ea 30             	sub    $0x30,%edx
  800d57:	eb dd                	jmp    800d36 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d59:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d5c:	89 f3                	mov    %esi,%ebx
  800d5e:	80 fb 19             	cmp    $0x19,%bl
  800d61:	77 08                	ja     800d6b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d63:	0f be d2             	movsbl %dl,%edx
  800d66:	83 ea 37             	sub    $0x37,%edx
  800d69:	eb cb                	jmp    800d36 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6f:	74 05                	je     800d76 <strtol+0xcc>
		*endptr = (char *) s;
  800d71:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d74:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d76:	89 c2                	mov    %eax,%edx
  800d78:	f7 da                	neg    %edx
  800d7a:	85 ff                	test   %edi,%edi
  800d7c:	0f 45 c2             	cmovne %edx,%eax
}
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	89 c3                	mov    %eax,%ebx
  800d97:	89 c7                	mov    %eax,%edi
  800d99:	89 c6                	mov    %eax,%esi
  800d9b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dad:	b8 01 00 00 00       	mov    $0x1,%eax
  800db2:	89 d1                	mov    %edx,%ecx
  800db4:	89 d3                	mov    %edx,%ebx
  800db6:	89 d7                	mov    %edx,%edi
  800db8:	89 d6                	mov    %edx,%esi
  800dba:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd2:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd7:	89 cb                	mov    %ecx,%ebx
  800dd9:	89 cf                	mov    %ecx,%edi
  800ddb:	89 ce                	mov    %ecx,%esi
  800ddd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	7f 08                	jg     800deb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	83 ec 0c             	sub    $0xc,%esp
  800dee:	50                   	push   %eax
  800def:	6a 03                	push   $0x3
  800df1:	68 a8 2a 80 00       	push   $0x802aa8
  800df6:	6a 43                	push   $0x43
  800df8:	68 c5 2a 80 00       	push   $0x802ac5
  800dfd:	e8 89 14 00 00       	call   80228b <_panic>

00800e02 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e08:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0d:	b8 02 00 00 00       	mov    $0x2,%eax
  800e12:	89 d1                	mov    %edx,%ecx
  800e14:	89 d3                	mov    %edx,%ebx
  800e16:	89 d7                	mov    %edx,%edi
  800e18:	89 d6                	mov    %edx,%esi
  800e1a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <sys_yield>:

void
sys_yield(void)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e27:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e31:	89 d1                	mov    %edx,%ecx
  800e33:	89 d3                	mov    %edx,%ebx
  800e35:	89 d7                	mov    %edx,%edi
  800e37:	89 d6                	mov    %edx,%esi
  800e39:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e49:	be 00 00 00 00       	mov    $0x0,%esi
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	b8 04 00 00 00       	mov    $0x4,%eax
  800e59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5c:	89 f7                	mov    %esi,%edi
  800e5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	7f 08                	jg     800e6c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	50                   	push   %eax
  800e70:	6a 04                	push   $0x4
  800e72:	68 a8 2a 80 00       	push   $0x802aa8
  800e77:	6a 43                	push   $0x43
  800e79:	68 c5 2a 80 00       	push   $0x802ac5
  800e7e:	e8 08 14 00 00       	call   80228b <_panic>

00800e83 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	b8 05 00 00 00       	mov    $0x5,%eax
  800e97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9d:	8b 75 18             	mov    0x18(%ebp),%esi
  800ea0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7f 08                	jg     800eae <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eae:	83 ec 0c             	sub    $0xc,%esp
  800eb1:	50                   	push   %eax
  800eb2:	6a 05                	push   $0x5
  800eb4:	68 a8 2a 80 00       	push   $0x802aa8
  800eb9:	6a 43                	push   $0x43
  800ebb:	68 c5 2a 80 00       	push   $0x802ac5
  800ec0:	e8 c6 13 00 00       	call   80228b <_panic>

00800ec5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	57                   	push   %edi
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
  800ecb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ece:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	b8 06 00 00 00       	mov    $0x6,%eax
  800ede:	89 df                	mov    %ebx,%edi
  800ee0:	89 de                	mov    %ebx,%esi
  800ee2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	7f 08                	jg     800ef0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	50                   	push   %eax
  800ef4:	6a 06                	push   $0x6
  800ef6:	68 a8 2a 80 00       	push   $0x802aa8
  800efb:	6a 43                	push   $0x43
  800efd:	68 c5 2a 80 00       	push   $0x802ac5
  800f02:	e8 84 13 00 00       	call   80228b <_panic>

00800f07 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f20:	89 df                	mov    %ebx,%edi
  800f22:	89 de                	mov    %ebx,%esi
  800f24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7f 08                	jg     800f32 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	83 ec 0c             	sub    $0xc,%esp
  800f35:	50                   	push   %eax
  800f36:	6a 08                	push   $0x8
  800f38:	68 a8 2a 80 00       	push   $0x802aa8
  800f3d:	6a 43                	push   $0x43
  800f3f:	68 c5 2a 80 00       	push   $0x802ac5
  800f44:	e8 42 13 00 00       	call   80228b <_panic>

00800f49 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f62:	89 df                	mov    %ebx,%edi
  800f64:	89 de                	mov    %ebx,%esi
  800f66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	7f 08                	jg     800f74 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	50                   	push   %eax
  800f78:	6a 09                	push   $0x9
  800f7a:	68 a8 2a 80 00       	push   $0x802aa8
  800f7f:	6a 43                	push   $0x43
  800f81:	68 c5 2a 80 00       	push   $0x802ac5
  800f86:	e8 00 13 00 00       	call   80228b <_panic>

00800f8b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	89 de                	mov    %ebx,%esi
  800fa8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	7f 08                	jg     800fb6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	50                   	push   %eax
  800fba:	6a 0a                	push   $0xa
  800fbc:	68 a8 2a 80 00       	push   $0x802aa8
  800fc1:	6a 43                	push   $0x43
  800fc3:	68 c5 2a 80 00       	push   $0x802ac5
  800fc8:	e8 be 12 00 00       	call   80228b <_panic>

00800fcd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fde:	be 00 00 00 00       	mov    $0x0,%esi
  800fe3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	57                   	push   %edi
  800ff4:	56                   	push   %esi
  800ff5:	53                   	push   %ebx
  800ff6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  801001:	b8 0d 00 00 00       	mov    $0xd,%eax
  801006:	89 cb                	mov    %ecx,%ebx
  801008:	89 cf                	mov    %ecx,%edi
  80100a:	89 ce                	mov    %ecx,%esi
  80100c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100e:	85 c0                	test   %eax,%eax
  801010:	7f 08                	jg     80101a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801012:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	50                   	push   %eax
  80101e:	6a 0d                	push   $0xd
  801020:	68 a8 2a 80 00       	push   $0x802aa8
  801025:	6a 43                	push   $0x43
  801027:	68 c5 2a 80 00       	push   $0x802ac5
  80102c:	e8 5a 12 00 00       	call   80228b <_panic>

00801031 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	57                   	push   %edi
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
	asm volatile("int %1\n"
  801037:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801042:	b8 0e 00 00 00       	mov    $0xe,%eax
  801047:	89 df                	mov    %ebx,%edi
  801049:	89 de                	mov    %ebx,%esi
  80104b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
	asm volatile("int %1\n"
  801058:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105d:	8b 55 08             	mov    0x8(%ebp),%edx
  801060:	b8 0f 00 00 00       	mov    $0xf,%eax
  801065:	89 cb                	mov    %ecx,%ebx
  801067:	89 cf                	mov    %ecx,%edi
  801069:	89 ce                	mov    %ecx,%esi
  80106b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
	asm volatile("int %1\n"
  801078:	ba 00 00 00 00       	mov    $0x0,%edx
  80107d:	b8 10 00 00 00       	mov    $0x10,%eax
  801082:	89 d1                	mov    %edx,%ecx
  801084:	89 d3                	mov    %edx,%ebx
  801086:	89 d7                	mov    %edx,%edi
  801088:	89 d6                	mov    %edx,%esi
  80108a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	57                   	push   %edi
  801095:	56                   	push   %esi
  801096:	53                   	push   %ebx
	asm volatile("int %1\n"
  801097:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a2:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a7:	89 df                	mov    %ebx,%edi
  8010a9:	89 de                	mov    %ebx,%esi
  8010ab:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	57                   	push   %edi
  8010b6:	56                   	push   %esi
  8010b7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c3:	b8 12 00 00 00       	mov    $0x12,%eax
  8010c8:	89 df                	mov    %ebx,%edi
  8010ca:	89 de                	mov    %ebx,%esi
  8010cc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ce:	5b                   	pop    %ebx
  8010cf:	5e                   	pop    %esi
  8010d0:	5f                   	pop    %edi
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	57                   	push   %edi
  8010d7:	56                   	push   %esi
  8010d8:	53                   	push   %ebx
  8010d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e7:	b8 13 00 00 00       	mov    $0x13,%eax
  8010ec:	89 df                	mov    %ebx,%edi
  8010ee:	89 de                	mov    %ebx,%esi
  8010f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	7f 08                	jg     8010fe <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f9:	5b                   	pop    %ebx
  8010fa:	5e                   	pop    %esi
  8010fb:	5f                   	pop    %edi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	50                   	push   %eax
  801102:	6a 13                	push   $0x13
  801104:	68 a8 2a 80 00       	push   $0x802aa8
  801109:	6a 43                	push   $0x43
  80110b:	68 c5 2a 80 00       	push   $0x802ac5
  801110:	e8 76 11 00 00       	call   80228b <_panic>

00801115 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	57                   	push   %edi
  801119:	56                   	push   %esi
  80111a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801120:	8b 55 08             	mov    0x8(%ebp),%edx
  801123:	b8 14 00 00 00       	mov    $0x14,%eax
  801128:	89 cb                	mov    %ecx,%ebx
  80112a:	89 cf                	mov    %ecx,%edi
  80112c:	89 ce                	mov    %ecx,%esi
  80112e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5f                   	pop    %edi
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	05 00 00 00 30       	add    $0x30000000,%eax
  801140:	c1 e8 0c             	shr    $0xc,%eax
}
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801150:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801155:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801164:	89 c2                	mov    %eax,%edx
  801166:	c1 ea 16             	shr    $0x16,%edx
  801169:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801170:	f6 c2 01             	test   $0x1,%dl
  801173:	74 2d                	je     8011a2 <fd_alloc+0x46>
  801175:	89 c2                	mov    %eax,%edx
  801177:	c1 ea 0c             	shr    $0xc,%edx
  80117a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801181:	f6 c2 01             	test   $0x1,%dl
  801184:	74 1c                	je     8011a2 <fd_alloc+0x46>
  801186:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80118b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801190:	75 d2                	jne    801164 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80119b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011a0:	eb 0a                	jmp    8011ac <fd_alloc+0x50>
			*fd_store = fd;
  8011a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b4:	83 f8 1f             	cmp    $0x1f,%eax
  8011b7:	77 30                	ja     8011e9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b9:	c1 e0 0c             	shl    $0xc,%eax
  8011bc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011c7:	f6 c2 01             	test   $0x1,%dl
  8011ca:	74 24                	je     8011f0 <fd_lookup+0x42>
  8011cc:	89 c2                	mov    %eax,%edx
  8011ce:	c1 ea 0c             	shr    $0xc,%edx
  8011d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d8:	f6 c2 01             	test   $0x1,%dl
  8011db:	74 1a                	je     8011f7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e0:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    
		return -E_INVAL;
  8011e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ee:	eb f7                	jmp    8011e7 <fd_lookup+0x39>
		return -E_INVAL;
  8011f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f5:	eb f0                	jmp    8011e7 <fd_lookup+0x39>
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fc:	eb e9                	jmp    8011e7 <fd_lookup+0x39>

008011fe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801207:	ba 00 00 00 00       	mov    $0x0,%edx
  80120c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801211:	39 08                	cmp    %ecx,(%eax)
  801213:	74 38                	je     80124d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801215:	83 c2 01             	add    $0x1,%edx
  801218:	8b 04 95 50 2b 80 00 	mov    0x802b50(,%edx,4),%eax
  80121f:	85 c0                	test   %eax,%eax
  801221:	75 ee                	jne    801211 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801223:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801228:	8b 40 48             	mov    0x48(%eax),%eax
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	51                   	push   %ecx
  80122f:	50                   	push   %eax
  801230:	68 d4 2a 80 00       	push   $0x802ad4
  801235:	e8 b5 f0 ff ff       	call   8002ef <cprintf>
	*dev = 0;
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    
			*dev = devtab[i];
  80124d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801250:	89 01                	mov    %eax,(%ecx)
			return 0;
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
  801257:	eb f2                	jmp    80124b <dev_lookup+0x4d>

00801259 <fd_close>:
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	57                   	push   %edi
  80125d:	56                   	push   %esi
  80125e:	53                   	push   %ebx
  80125f:	83 ec 24             	sub    $0x24,%esp
  801262:	8b 75 08             	mov    0x8(%ebp),%esi
  801265:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801268:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801272:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801275:	50                   	push   %eax
  801276:	e8 33 ff ff ff       	call   8011ae <fd_lookup>
  80127b:	89 c3                	mov    %eax,%ebx
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	78 05                	js     801289 <fd_close+0x30>
	    || fd != fd2)
  801284:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801287:	74 16                	je     80129f <fd_close+0x46>
		return (must_exist ? r : 0);
  801289:	89 f8                	mov    %edi,%eax
  80128b:	84 c0                	test   %al,%al
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
  801292:	0f 44 d8             	cmove  %eax,%ebx
}
  801295:	89 d8                	mov    %ebx,%eax
  801297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129a:	5b                   	pop    %ebx
  80129b:	5e                   	pop    %esi
  80129c:	5f                   	pop    %edi
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	ff 36                	pushl  (%esi)
  8012a8:	e8 51 ff ff ff       	call   8011fe <dev_lookup>
  8012ad:	89 c3                	mov    %eax,%ebx
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 1a                	js     8012d0 <fd_close+0x77>
		if (dev->dev_close)
  8012b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012bc:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	74 0b                	je     8012d0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	56                   	push   %esi
  8012c9:	ff d0                	call   *%eax
  8012cb:	89 c3                	mov    %eax,%ebx
  8012cd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	56                   	push   %esi
  8012d4:	6a 00                	push   $0x0
  8012d6:	e8 ea fb ff ff       	call   800ec5 <sys_page_unmap>
	return r;
  8012db:	83 c4 10             	add    $0x10,%esp
  8012de:	eb b5                	jmp    801295 <fd_close+0x3c>

008012e0 <close>:

int
close(int fdnum)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	e8 bc fe ff ff       	call   8011ae <fd_lookup>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	79 02                	jns    8012fb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    
		return fd_close(fd, 1);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	6a 01                	push   $0x1
  801300:	ff 75 f4             	pushl  -0xc(%ebp)
  801303:	e8 51 ff ff ff       	call   801259 <fd_close>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	eb ec                	jmp    8012f9 <close+0x19>

0080130d <close_all>:

void
close_all(void)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801314:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	53                   	push   %ebx
  80131d:	e8 be ff ff ff       	call   8012e0 <close>
	for (i = 0; i < MAXFD; i++)
  801322:	83 c3 01             	add    $0x1,%ebx
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	83 fb 20             	cmp    $0x20,%ebx
  80132b:	75 ec                	jne    801319 <close_all+0xc>
}
  80132d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	57                   	push   %edi
  801336:	56                   	push   %esi
  801337:	53                   	push   %ebx
  801338:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80133b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	ff 75 08             	pushl  0x8(%ebp)
  801342:	e8 67 fe ff ff       	call   8011ae <fd_lookup>
  801347:	89 c3                	mov    %eax,%ebx
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	0f 88 81 00 00 00    	js     8013d5 <dup+0xa3>
		return r;
	close(newfdnum);
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	ff 75 0c             	pushl  0xc(%ebp)
  80135a:	e8 81 ff ff ff       	call   8012e0 <close>

	newfd = INDEX2FD(newfdnum);
  80135f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801362:	c1 e6 0c             	shl    $0xc,%esi
  801365:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801371:	e8 cf fd ff ff       	call   801145 <fd2data>
  801376:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801378:	89 34 24             	mov    %esi,(%esp)
  80137b:	e8 c5 fd ff ff       	call   801145 <fd2data>
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801385:	89 d8                	mov    %ebx,%eax
  801387:	c1 e8 16             	shr    $0x16,%eax
  80138a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801391:	a8 01                	test   $0x1,%al
  801393:	74 11                	je     8013a6 <dup+0x74>
  801395:	89 d8                	mov    %ebx,%eax
  801397:	c1 e8 0c             	shr    $0xc,%eax
  80139a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a1:	f6 c2 01             	test   $0x1,%dl
  8013a4:	75 39                	jne    8013df <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013a9:	89 d0                	mov    %edx,%eax
  8013ab:	c1 e8 0c             	shr    $0xc,%eax
  8013ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b5:	83 ec 0c             	sub    $0xc,%esp
  8013b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bd:	50                   	push   %eax
  8013be:	56                   	push   %esi
  8013bf:	6a 00                	push   $0x0
  8013c1:	52                   	push   %edx
  8013c2:	6a 00                	push   $0x0
  8013c4:	e8 ba fa ff ff       	call   800e83 <sys_page_map>
  8013c9:	89 c3                	mov    %eax,%ebx
  8013cb:	83 c4 20             	add    $0x20,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 31                	js     801403 <dup+0xd1>
		goto err;

	return newfdnum;
  8013d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013d5:	89 d8                	mov    %ebx,%eax
  8013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5f                   	pop    %edi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e6:	83 ec 0c             	sub    $0xc,%esp
  8013e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ee:	50                   	push   %eax
  8013ef:	57                   	push   %edi
  8013f0:	6a 00                	push   $0x0
  8013f2:	53                   	push   %ebx
  8013f3:	6a 00                	push   $0x0
  8013f5:	e8 89 fa ff ff       	call   800e83 <sys_page_map>
  8013fa:	89 c3                	mov    %eax,%ebx
  8013fc:	83 c4 20             	add    $0x20,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	79 a3                	jns    8013a6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	56                   	push   %esi
  801407:	6a 00                	push   $0x0
  801409:	e8 b7 fa ff ff       	call   800ec5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80140e:	83 c4 08             	add    $0x8,%esp
  801411:	57                   	push   %edi
  801412:	6a 00                	push   $0x0
  801414:	e8 ac fa ff ff       	call   800ec5 <sys_page_unmap>
	return r;
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	eb b7                	jmp    8013d5 <dup+0xa3>

0080141e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	53                   	push   %ebx
  801422:	83 ec 1c             	sub    $0x1c,%esp
  801425:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801428:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142b:	50                   	push   %eax
  80142c:	53                   	push   %ebx
  80142d:	e8 7c fd ff ff       	call   8011ae <fd_lookup>
  801432:	83 c4 10             	add    $0x10,%esp
  801435:	85 c0                	test   %eax,%eax
  801437:	78 3f                	js     801478 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801439:	83 ec 08             	sub    $0x8,%esp
  80143c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143f:	50                   	push   %eax
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	ff 30                	pushl  (%eax)
  801445:	e8 b4 fd ff ff       	call   8011fe <dev_lookup>
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 27                	js     801478 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801454:	8b 42 08             	mov    0x8(%edx),%eax
  801457:	83 e0 03             	and    $0x3,%eax
  80145a:	83 f8 01             	cmp    $0x1,%eax
  80145d:	74 1e                	je     80147d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	8b 40 08             	mov    0x8(%eax),%eax
  801465:	85 c0                	test   %eax,%eax
  801467:	74 35                	je     80149e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	ff 75 10             	pushl  0x10(%ebp)
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	52                   	push   %edx
  801473:	ff d0                	call   *%eax
  801475:	83 c4 10             	add    $0x10,%esp
}
  801478:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801482:	8b 40 48             	mov    0x48(%eax),%eax
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	53                   	push   %ebx
  801489:	50                   	push   %eax
  80148a:	68 15 2b 80 00       	push   $0x802b15
  80148f:	e8 5b ee ff ff       	call   8002ef <cprintf>
		return -E_INVAL;
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149c:	eb da                	jmp    801478 <read+0x5a>
		return -E_NOT_SUPP;
  80149e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a3:	eb d3                	jmp    801478 <read+0x5a>

008014a5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	57                   	push   %edi
  8014a9:	56                   	push   %esi
  8014aa:	53                   	push   %ebx
  8014ab:	83 ec 0c             	sub    $0xc,%esp
  8014ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b9:	39 f3                	cmp    %esi,%ebx
  8014bb:	73 23                	jae    8014e0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	89 f0                	mov    %esi,%eax
  8014c2:	29 d8                	sub    %ebx,%eax
  8014c4:	50                   	push   %eax
  8014c5:	89 d8                	mov    %ebx,%eax
  8014c7:	03 45 0c             	add    0xc(%ebp),%eax
  8014ca:	50                   	push   %eax
  8014cb:	57                   	push   %edi
  8014cc:	e8 4d ff ff ff       	call   80141e <read>
		if (m < 0)
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 06                	js     8014de <readn+0x39>
			return m;
		if (m == 0)
  8014d8:	74 06                	je     8014e0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014da:	01 c3                	add    %eax,%ebx
  8014dc:	eb db                	jmp    8014b9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014de:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014e0:	89 d8                	mov    %ebx,%eax
  8014e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    

008014ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 1c             	sub    $0x1c,%esp
  8014f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	53                   	push   %ebx
  8014f9:	e8 b0 fc ff ff       	call   8011ae <fd_lookup>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 3a                	js     80153f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150b:	50                   	push   %eax
  80150c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150f:	ff 30                	pushl  (%eax)
  801511:	e8 e8 fc ff ff       	call   8011fe <dev_lookup>
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 22                	js     80153f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801524:	74 1e                	je     801544 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801529:	8b 52 0c             	mov    0xc(%edx),%edx
  80152c:	85 d2                	test   %edx,%edx
  80152e:	74 35                	je     801565 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	ff 75 10             	pushl  0x10(%ebp)
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	50                   	push   %eax
  80153a:	ff d2                	call   *%edx
  80153c:	83 c4 10             	add    $0x10,%esp
}
  80153f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801542:	c9                   	leave  
  801543:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801544:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801549:	8b 40 48             	mov    0x48(%eax),%eax
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	53                   	push   %ebx
  801550:	50                   	push   %eax
  801551:	68 31 2b 80 00       	push   $0x802b31
  801556:	e8 94 ed ff ff       	call   8002ef <cprintf>
		return -E_INVAL;
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801563:	eb da                	jmp    80153f <write+0x55>
		return -E_NOT_SUPP;
  801565:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156a:	eb d3                	jmp    80153f <write+0x55>

0080156c <seek>:

int
seek(int fdnum, off_t offset)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	ff 75 08             	pushl  0x8(%ebp)
  801579:	e8 30 fc ff ff       	call   8011ae <fd_lookup>
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 0e                	js     801593 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 1c             	sub    $0x1c,%esp
  80159c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80159f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a2:	50                   	push   %eax
  8015a3:	53                   	push   %ebx
  8015a4:	e8 05 fc ff ff       	call   8011ae <fd_lookup>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 37                	js     8015e7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	ff 30                	pushl  (%eax)
  8015bc:	e8 3d fc ff ff       	call   8011fe <dev_lookup>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 1f                	js     8015e7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015cf:	74 1b                	je     8015ec <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d4:	8b 52 18             	mov    0x18(%edx),%edx
  8015d7:	85 d2                	test   %edx,%edx
  8015d9:	74 32                	je     80160d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	ff d2                	call   *%edx
  8015e4:	83 c4 10             	add    $0x10,%esp
}
  8015e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f1:	8b 40 48             	mov    0x48(%eax),%eax
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	53                   	push   %ebx
  8015f8:	50                   	push   %eax
  8015f9:	68 f4 2a 80 00       	push   $0x802af4
  8015fe:	e8 ec ec ff ff       	call   8002ef <cprintf>
		return -E_INVAL;
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160b:	eb da                	jmp    8015e7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80160d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801612:	eb d3                	jmp    8015e7 <ftruncate+0x52>

00801614 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	53                   	push   %ebx
  801618:	83 ec 1c             	sub    $0x1c,%esp
  80161b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801621:	50                   	push   %eax
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	e8 84 fb ff ff       	call   8011ae <fd_lookup>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 4b                	js     80167c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163b:	ff 30                	pushl  (%eax)
  80163d:	e8 bc fb ff ff       	call   8011fe <dev_lookup>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 33                	js     80167c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801650:	74 2f                	je     801681 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801652:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801655:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80165c:	00 00 00 
	stat->st_isdir = 0;
  80165f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801666:	00 00 00 
	stat->st_dev = dev;
  801669:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80166f:	83 ec 08             	sub    $0x8,%esp
  801672:	53                   	push   %ebx
  801673:	ff 75 f0             	pushl  -0x10(%ebp)
  801676:	ff 50 14             	call   *0x14(%eax)
  801679:	83 c4 10             	add    $0x10,%esp
}
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    
		return -E_NOT_SUPP;
  801681:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801686:	eb f4                	jmp    80167c <fstat+0x68>

00801688 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	56                   	push   %esi
  80168c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	6a 00                	push   $0x0
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	e8 22 02 00 00       	call   8018bc <open>
  80169a:	89 c3                	mov    %eax,%ebx
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 1b                	js     8016be <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	50                   	push   %eax
  8016aa:	e8 65 ff ff ff       	call   801614 <fstat>
  8016af:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b1:	89 1c 24             	mov    %ebx,(%esp)
  8016b4:	e8 27 fc ff ff       	call   8012e0 <close>
	return r;
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	89 f3                	mov    %esi,%ebx
}
  8016be:	89 d8                	mov    %ebx,%eax
  8016c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	56                   	push   %esi
  8016cb:	53                   	push   %ebx
  8016cc:	89 c6                	mov    %eax,%esi
  8016ce:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016d0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016d7:	74 27                	je     801700 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016d9:	6a 07                	push   $0x7
  8016db:	68 00 60 80 00       	push   $0x806000
  8016e0:	56                   	push   %esi
  8016e1:	ff 35 00 40 80 00    	pushl  0x804000
  8016e7:	e8 69 0c 00 00       	call   802355 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ec:	83 c4 0c             	add    $0xc,%esp
  8016ef:	6a 00                	push   $0x0
  8016f1:	53                   	push   %ebx
  8016f2:	6a 00                	push   $0x0
  8016f4:	e8 f3 0b 00 00       	call   8022ec <ipc_recv>
}
  8016f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fc:	5b                   	pop    %ebx
  8016fd:	5e                   	pop    %esi
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801700:	83 ec 0c             	sub    $0xc,%esp
  801703:	6a 01                	push   $0x1
  801705:	e8 a3 0c 00 00       	call   8023ad <ipc_find_env>
  80170a:	a3 00 40 80 00       	mov    %eax,0x804000
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	eb c5                	jmp    8016d9 <fsipc+0x12>

00801714 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8b 40 0c             	mov    0xc(%eax),%eax
  801720:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801725:	8b 45 0c             	mov    0xc(%ebp),%eax
  801728:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80172d:	ba 00 00 00 00       	mov    $0x0,%edx
  801732:	b8 02 00 00 00       	mov    $0x2,%eax
  801737:	e8 8b ff ff ff       	call   8016c7 <fsipc>
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <devfile_flush>:
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8b 40 0c             	mov    0xc(%eax),%eax
  80174a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80174f:	ba 00 00 00 00       	mov    $0x0,%edx
  801754:	b8 06 00 00 00       	mov    $0x6,%eax
  801759:	e8 69 ff ff ff       	call   8016c7 <fsipc>
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <devfile_stat>:
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	53                   	push   %ebx
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8b 40 0c             	mov    0xc(%eax),%eax
  801770:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 05 00 00 00       	mov    $0x5,%eax
  80177f:	e8 43 ff ff ff       	call   8016c7 <fsipc>
  801784:	85 c0                	test   %eax,%eax
  801786:	78 2c                	js     8017b4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	68 00 60 80 00       	push   $0x806000
  801790:	53                   	push   %ebx
  801791:	e8 b8 f2 ff ff       	call   800a4e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801796:	a1 80 60 80 00       	mov    0x806080,%eax
  80179b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a1:	a1 84 60 80 00       	mov    0x806084,%eax
  8017a6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <devfile_write>:
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8017ce:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017d4:	53                   	push   %ebx
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	68 08 60 80 00       	push   $0x806008
  8017dd:	e8 5c f4 ff ff       	call   800c3e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ec:	e8 d6 fe ff ff       	call   8016c7 <fsipc>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 0b                	js     801803 <devfile_write+0x4a>
	assert(r <= n);
  8017f8:	39 d8                	cmp    %ebx,%eax
  8017fa:	77 0c                	ja     801808 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017fc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801801:	7f 1e                	jg     801821 <devfile_write+0x68>
}
  801803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801806:	c9                   	leave  
  801807:	c3                   	ret    
	assert(r <= n);
  801808:	68 64 2b 80 00       	push   $0x802b64
  80180d:	68 6b 2b 80 00       	push   $0x802b6b
  801812:	68 98 00 00 00       	push   $0x98
  801817:	68 80 2b 80 00       	push   $0x802b80
  80181c:	e8 6a 0a 00 00       	call   80228b <_panic>
	assert(r <= PGSIZE);
  801821:	68 8b 2b 80 00       	push   $0x802b8b
  801826:	68 6b 2b 80 00       	push   $0x802b6b
  80182b:	68 99 00 00 00       	push   $0x99
  801830:	68 80 2b 80 00       	push   $0x802b80
  801835:	e8 51 0a 00 00       	call   80228b <_panic>

0080183a <devfile_read>:
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	56                   	push   %esi
  80183e:	53                   	push   %ebx
  80183f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8b 40 0c             	mov    0xc(%eax),%eax
  801848:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80184d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	b8 03 00 00 00       	mov    $0x3,%eax
  80185d:	e8 65 fe ff ff       	call   8016c7 <fsipc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	85 c0                	test   %eax,%eax
  801866:	78 1f                	js     801887 <devfile_read+0x4d>
	assert(r <= n);
  801868:	39 f0                	cmp    %esi,%eax
  80186a:	77 24                	ja     801890 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80186c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801871:	7f 33                	jg     8018a6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	50                   	push   %eax
  801877:	68 00 60 80 00       	push   $0x806000
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	e8 58 f3 ff ff       	call   800bdc <memmove>
	return r;
  801884:	83 c4 10             	add    $0x10,%esp
}
  801887:	89 d8                	mov    %ebx,%eax
  801889:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188c:	5b                   	pop    %ebx
  80188d:	5e                   	pop    %esi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    
	assert(r <= n);
  801890:	68 64 2b 80 00       	push   $0x802b64
  801895:	68 6b 2b 80 00       	push   $0x802b6b
  80189a:	6a 7c                	push   $0x7c
  80189c:	68 80 2b 80 00       	push   $0x802b80
  8018a1:	e8 e5 09 00 00       	call   80228b <_panic>
	assert(r <= PGSIZE);
  8018a6:	68 8b 2b 80 00       	push   $0x802b8b
  8018ab:	68 6b 2b 80 00       	push   $0x802b6b
  8018b0:	6a 7d                	push   $0x7d
  8018b2:	68 80 2b 80 00       	push   $0x802b80
  8018b7:	e8 cf 09 00 00       	call   80228b <_panic>

008018bc <open>:
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	83 ec 1c             	sub    $0x1c,%esp
  8018c4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018c7:	56                   	push   %esi
  8018c8:	e8 48 f1 ff ff       	call   800a15 <strlen>
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d5:	7f 6c                	jg     801943 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018dd:	50                   	push   %eax
  8018de:	e8 79 f8 ff ff       	call   80115c <fd_alloc>
  8018e3:	89 c3                	mov    %eax,%ebx
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	78 3c                	js     801928 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	56                   	push   %esi
  8018f0:	68 00 60 80 00       	push   $0x806000
  8018f5:	e8 54 f1 ff ff       	call   800a4e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801905:	b8 01 00 00 00       	mov    $0x1,%eax
  80190a:	e8 b8 fd ff ff       	call   8016c7 <fsipc>
  80190f:	89 c3                	mov    %eax,%ebx
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	85 c0                	test   %eax,%eax
  801916:	78 19                	js     801931 <open+0x75>
	return fd2num(fd);
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	ff 75 f4             	pushl  -0xc(%ebp)
  80191e:	e8 12 f8 ff ff       	call   801135 <fd2num>
  801923:	89 c3                	mov    %eax,%ebx
  801925:	83 c4 10             	add    $0x10,%esp
}
  801928:	89 d8                	mov    %ebx,%eax
  80192a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5e                   	pop    %esi
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    
		fd_close(fd, 0);
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	6a 00                	push   $0x0
  801936:	ff 75 f4             	pushl  -0xc(%ebp)
  801939:	e8 1b f9 ff ff       	call   801259 <fd_close>
		return r;
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	eb e5                	jmp    801928 <open+0x6c>
		return -E_BAD_PATH;
  801943:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801948:	eb de                	jmp    801928 <open+0x6c>

0080194a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	b8 08 00 00 00       	mov    $0x8,%eax
  80195a:	e8 68 fd ff ff       	call   8016c7 <fsipc>
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801967:	68 97 2b 80 00       	push   $0x802b97
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	e8 da f0 ff ff       	call   800a4e <strcpy>
	return 0;
}
  801974:	b8 00 00 00 00       	mov    $0x0,%eax
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <devsock_close>:
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	53                   	push   %ebx
  80197f:	83 ec 10             	sub    $0x10,%esp
  801982:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801985:	53                   	push   %ebx
  801986:	e8 5d 0a 00 00       	call   8023e8 <pageref>
  80198b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80198e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801993:	83 f8 01             	cmp    $0x1,%eax
  801996:	74 07                	je     80199f <devsock_close+0x24>
}
  801998:	89 d0                	mov    %edx,%eax
  80199a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80199f:	83 ec 0c             	sub    $0xc,%esp
  8019a2:	ff 73 0c             	pushl  0xc(%ebx)
  8019a5:	e8 b9 02 00 00       	call   801c63 <nsipc_close>
  8019aa:	89 c2                	mov    %eax,%edx
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	eb e7                	jmp    801998 <devsock_close+0x1d>

008019b1 <devsock_write>:
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 10             	pushl  0x10(%ebp)
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	ff 70 0c             	pushl  0xc(%eax)
  8019c5:	e8 76 03 00 00       	call   801d40 <nsipc_send>
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <devsock_read>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	ff 70 0c             	pushl  0xc(%eax)
  8019e0:	e8 ef 02 00 00       	call   801cd4 <nsipc_recv>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <fd2sockid>:
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ed:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019f0:	52                   	push   %edx
  8019f1:	50                   	push   %eax
  8019f2:	e8 b7 f7 ff ff       	call   8011ae <fd_lookup>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 10                	js     801a0e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a07:	39 08                	cmp    %ecx,(%eax)
  801a09:	75 05                	jne    801a10 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a0b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    
		return -E_NOT_SUPP;
  801a10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a15:	eb f7                	jmp    801a0e <fd2sockid+0x27>

00801a17 <alloc_sockfd>:
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 1c             	sub    $0x1c,%esp
  801a1f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	e8 32 f7 ff ff       	call   80115c <fd_alloc>
  801a2a:	89 c3                	mov    %eax,%ebx
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 43                	js     801a76 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	68 07 04 00 00       	push   $0x407
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	6a 00                	push   $0x0
  801a40:	e8 fb f3 ff ff       	call   800e40 <sys_page_alloc>
  801a45:	89 c3                	mov    %eax,%ebx
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 28                	js     801a76 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a57:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a63:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	50                   	push   %eax
  801a6a:	e8 c6 f6 ff ff       	call   801135 <fd2num>
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	eb 0c                	jmp    801a82 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a76:	83 ec 0c             	sub    $0xc,%esp
  801a79:	56                   	push   %esi
  801a7a:	e8 e4 01 00 00       	call   801c63 <nsipc_close>
		return r;
  801a7f:	83 c4 10             	add    $0x10,%esp
}
  801a82:	89 d8                	mov    %ebx,%eax
  801a84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5d                   	pop    %ebp
  801a8a:	c3                   	ret    

00801a8b <accept>:
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	e8 4e ff ff ff       	call   8019e7 <fd2sockid>
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 1b                	js     801ab8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	50                   	push   %eax
  801aa7:	e8 0e 01 00 00       	call   801bba <nsipc_accept>
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 05                	js     801ab8 <accept+0x2d>
	return alloc_sockfd(r);
  801ab3:	e8 5f ff ff ff       	call   801a17 <alloc_sockfd>
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <bind>:
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	e8 1f ff ff ff       	call   8019e7 <fd2sockid>
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	78 12                	js     801ade <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	ff 75 10             	pushl  0x10(%ebp)
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	50                   	push   %eax
  801ad6:	e8 31 01 00 00       	call   801c0c <nsipc_bind>
  801adb:	83 c4 10             	add    $0x10,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <shutdown>:
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	e8 f9 fe ff ff       	call   8019e7 <fd2sockid>
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 0f                	js     801b01 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	50                   	push   %eax
  801af9:	e8 43 01 00 00       	call   801c41 <nsipc_shutdown>
  801afe:	83 c4 10             	add    $0x10,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <connect>:
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	e8 d6 fe ff ff       	call   8019e7 <fd2sockid>
  801b11:	85 c0                	test   %eax,%eax
  801b13:	78 12                	js     801b27 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	ff 75 10             	pushl  0x10(%ebp)
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	50                   	push   %eax
  801b1f:	e8 59 01 00 00       	call   801c7d <nsipc_connect>
  801b24:	83 c4 10             	add    $0x10,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <listen>:
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	e8 b0 fe ff ff       	call   8019e7 <fd2sockid>
  801b37:	85 c0                	test   %eax,%eax
  801b39:	78 0f                	js     801b4a <listen+0x21>
	return nsipc_listen(r, backlog);
  801b3b:	83 ec 08             	sub    $0x8,%esp
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	50                   	push   %eax
  801b42:	e8 6b 01 00 00       	call   801cb2 <nsipc_listen>
  801b47:	83 c4 10             	add    $0x10,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <socket>:

int
socket(int domain, int type, int protocol)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	e8 3e 02 00 00       	call   801d9e <nsipc_socket>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 05                	js     801b6c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b67:	e8 ab fe ff ff       	call   801a17 <alloc_sockfd>
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b77:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b7e:	74 26                	je     801ba6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b80:	6a 07                	push   $0x7
  801b82:	68 00 70 80 00       	push   $0x807000
  801b87:	53                   	push   %ebx
  801b88:	ff 35 04 40 80 00    	pushl  0x804004
  801b8e:	e8 c2 07 00 00       	call   802355 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b93:	83 c4 0c             	add    $0xc,%esp
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	e8 4b 07 00 00       	call   8022ec <ipc_recv>
}
  801ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ba6:	83 ec 0c             	sub    $0xc,%esp
  801ba9:	6a 02                	push   $0x2
  801bab:	e8 fd 07 00 00       	call   8023ad <ipc_find_env>
  801bb0:	a3 04 40 80 00       	mov    %eax,0x804004
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	eb c6                	jmp    801b80 <nsipc+0x12>

00801bba <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	56                   	push   %esi
  801bbe:	53                   	push   %ebx
  801bbf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bca:	8b 06                	mov    (%esi),%eax
  801bcc:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd6:	e8 93 ff ff ff       	call   801b6e <nsipc>
  801bdb:	89 c3                	mov    %eax,%ebx
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	79 09                	jns    801bea <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801be1:	89 d8                	mov    %ebx,%eax
  801be3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	ff 35 10 70 80 00    	pushl  0x807010
  801bf3:	68 00 70 80 00       	push   $0x807000
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	e8 dc ef ff ff       	call   800bdc <memmove>
		*addrlen = ret->ret_addrlen;
  801c00:	a1 10 70 80 00       	mov    0x807010,%eax
  801c05:	89 06                	mov    %eax,(%esi)
  801c07:	83 c4 10             	add    $0x10,%esp
	return r;
  801c0a:	eb d5                	jmp    801be1 <nsipc_accept+0x27>

00801c0c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 08             	sub    $0x8,%esp
  801c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c1e:	53                   	push   %ebx
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	68 04 70 80 00       	push   $0x807004
  801c27:	e8 b0 ef ff ff       	call   800bdc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c2c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801c32:	b8 02 00 00 00       	mov    $0x2,%eax
  801c37:	e8 32 ff ff ff       	call   801b6e <nsipc>
}
  801c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c52:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801c57:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5c:	e8 0d ff ff ff       	call   801b6e <nsipc>
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <nsipc_close>:

int
nsipc_close(int s)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801c71:	b8 04 00 00 00       	mov    $0x4,%eax
  801c76:	e8 f3 fe ff ff       	call   801b6e <nsipc>
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	53                   	push   %ebx
  801c81:	83 ec 08             	sub    $0x8,%esp
  801c84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c8f:	53                   	push   %ebx
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	68 04 70 80 00       	push   $0x807004
  801c98:	e8 3f ef ff ff       	call   800bdc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c9d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801ca3:	b8 05 00 00 00       	mov    $0x5,%eax
  801ca8:	e8 c1 fe ff ff       	call   801b6e <nsipc>
}
  801cad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801cc8:	b8 06 00 00 00       	mov    $0x6,%eax
  801ccd:	e8 9c fe ff ff       	call   801b6e <nsipc>
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	56                   	push   %esi
  801cd8:	53                   	push   %ebx
  801cd9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801ce4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801cea:	8b 45 14             	mov    0x14(%ebp),%eax
  801ced:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cf2:	b8 07 00 00 00       	mov    $0x7,%eax
  801cf7:	e8 72 fe ff ff       	call   801b6e <nsipc>
  801cfc:	89 c3                	mov    %eax,%ebx
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 1f                	js     801d21 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d02:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d07:	7f 21                	jg     801d2a <nsipc_recv+0x56>
  801d09:	39 c6                	cmp    %eax,%esi
  801d0b:	7c 1d                	jl     801d2a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	50                   	push   %eax
  801d11:	68 00 70 80 00       	push   $0x807000
  801d16:	ff 75 0c             	pushl  0xc(%ebp)
  801d19:	e8 be ee ff ff       	call   800bdc <memmove>
  801d1e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d21:	89 d8                	mov    %ebx,%eax
  801d23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5e                   	pop    %esi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d2a:	68 a3 2b 80 00       	push   $0x802ba3
  801d2f:	68 6b 2b 80 00       	push   $0x802b6b
  801d34:	6a 62                	push   $0x62
  801d36:	68 b8 2b 80 00       	push   $0x802bb8
  801d3b:	e8 4b 05 00 00       	call   80228b <_panic>

00801d40 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	53                   	push   %ebx
  801d44:	83 ec 04             	sub    $0x4,%esp
  801d47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801d52:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d58:	7f 2e                	jg     801d88 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	53                   	push   %ebx
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	68 0c 70 80 00       	push   $0x80700c
  801d66:	e8 71 ee ff ff       	call   800bdc <memmove>
	nsipcbuf.send.req_size = size;
  801d6b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801d71:	8b 45 14             	mov    0x14(%ebp),%eax
  801d74:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801d79:	b8 08 00 00 00       	mov    $0x8,%eax
  801d7e:	e8 eb fd ff ff       	call   801b6e <nsipc>
}
  801d83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    
	assert(size < 1600);
  801d88:	68 c4 2b 80 00       	push   $0x802bc4
  801d8d:	68 6b 2b 80 00       	push   $0x802b6b
  801d92:	6a 6d                	push   $0x6d
  801d94:	68 b8 2b 80 00       	push   $0x802bb8
  801d99:	e8 ed 04 00 00       	call   80228b <_panic>

00801d9e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801db4:	8b 45 10             	mov    0x10(%ebp),%eax
  801db7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801dbc:	b8 09 00 00 00       	mov    $0x9,%eax
  801dc1:	e8 a8 fd ff ff       	call   801b6e <nsipc>
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	56                   	push   %esi
  801dcc:	53                   	push   %ebx
  801dcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	e8 6a f3 ff ff       	call   801145 <fd2data>
  801ddb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ddd:	83 c4 08             	add    $0x8,%esp
  801de0:	68 d0 2b 80 00       	push   $0x802bd0
  801de5:	53                   	push   %ebx
  801de6:	e8 63 ec ff ff       	call   800a4e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801deb:	8b 46 04             	mov    0x4(%esi),%eax
  801dee:	2b 06                	sub    (%esi),%eax
  801df0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801df6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dfd:	00 00 00 
	stat->st_dev = &devpipe;
  801e00:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e07:	30 80 00 
	return 0;
}
  801e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    

00801e16 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	53                   	push   %ebx
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e20:	53                   	push   %ebx
  801e21:	6a 00                	push   $0x0
  801e23:	e8 9d f0 ff ff       	call   800ec5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e28:	89 1c 24             	mov    %ebx,(%esp)
  801e2b:	e8 15 f3 ff ff       	call   801145 <fd2data>
  801e30:	83 c4 08             	add    $0x8,%esp
  801e33:	50                   	push   %eax
  801e34:	6a 00                	push   $0x0
  801e36:	e8 8a f0 ff ff       	call   800ec5 <sys_page_unmap>
}
  801e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <_pipeisclosed>:
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	57                   	push   %edi
  801e44:	56                   	push   %esi
  801e45:	53                   	push   %ebx
  801e46:	83 ec 1c             	sub    $0x1c,%esp
  801e49:	89 c7                	mov    %eax,%edi
  801e4b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e4d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e52:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	57                   	push   %edi
  801e59:	e8 8a 05 00 00       	call   8023e8 <pageref>
  801e5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e61:	89 34 24             	mov    %esi,(%esp)
  801e64:	e8 7f 05 00 00       	call   8023e8 <pageref>
		nn = thisenv->env_runs;
  801e69:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  801e6f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	39 cb                	cmp    %ecx,%ebx
  801e77:	74 1b                	je     801e94 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e79:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e7c:	75 cf                	jne    801e4d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e7e:	8b 42 58             	mov    0x58(%edx),%eax
  801e81:	6a 01                	push   $0x1
  801e83:	50                   	push   %eax
  801e84:	53                   	push   %ebx
  801e85:	68 d7 2b 80 00       	push   $0x802bd7
  801e8a:	e8 60 e4 ff ff       	call   8002ef <cprintf>
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	eb b9                	jmp    801e4d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e94:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e97:	0f 94 c0             	sete   %al
  801e9a:	0f b6 c0             	movzbl %al,%eax
}
  801e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    

00801ea5 <devpipe_write>:
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	57                   	push   %edi
  801ea9:	56                   	push   %esi
  801eaa:	53                   	push   %ebx
  801eab:	83 ec 28             	sub    $0x28,%esp
  801eae:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eb1:	56                   	push   %esi
  801eb2:	e8 8e f2 ff ff       	call   801145 <fd2data>
  801eb7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec4:	74 4f                	je     801f15 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ec6:	8b 43 04             	mov    0x4(%ebx),%eax
  801ec9:	8b 0b                	mov    (%ebx),%ecx
  801ecb:	8d 51 20             	lea    0x20(%ecx),%edx
  801ece:	39 d0                	cmp    %edx,%eax
  801ed0:	72 14                	jb     801ee6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ed2:	89 da                	mov    %ebx,%edx
  801ed4:	89 f0                	mov    %esi,%eax
  801ed6:	e8 65 ff ff ff       	call   801e40 <_pipeisclosed>
  801edb:	85 c0                	test   %eax,%eax
  801edd:	75 3b                	jne    801f1a <devpipe_write+0x75>
			sys_yield();
  801edf:	e8 3d ef ff ff       	call   800e21 <sys_yield>
  801ee4:	eb e0                	jmp    801ec6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eed:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ef0:	89 c2                	mov    %eax,%edx
  801ef2:	c1 fa 1f             	sar    $0x1f,%edx
  801ef5:	89 d1                	mov    %edx,%ecx
  801ef7:	c1 e9 1b             	shr    $0x1b,%ecx
  801efa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801efd:	83 e2 1f             	and    $0x1f,%edx
  801f00:	29 ca                	sub    %ecx,%edx
  801f02:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f06:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f0a:	83 c0 01             	add    $0x1,%eax
  801f0d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f10:	83 c7 01             	add    $0x1,%edi
  801f13:	eb ac                	jmp    801ec1 <devpipe_write+0x1c>
	return i;
  801f15:	8b 45 10             	mov    0x10(%ebp),%eax
  801f18:	eb 05                	jmp    801f1f <devpipe_write+0x7a>
				return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f22:	5b                   	pop    %ebx
  801f23:	5e                   	pop    %esi
  801f24:	5f                   	pop    %edi
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    

00801f27 <devpipe_read>:
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	57                   	push   %edi
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 18             	sub    $0x18,%esp
  801f30:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f33:	57                   	push   %edi
  801f34:	e8 0c f2 ff ff       	call   801145 <fd2data>
  801f39:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	be 00 00 00 00       	mov    $0x0,%esi
  801f43:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f46:	75 14                	jne    801f5c <devpipe_read+0x35>
	return i;
  801f48:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4b:	eb 02                	jmp    801f4f <devpipe_read+0x28>
				return i;
  801f4d:	89 f0                	mov    %esi,%eax
}
  801f4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f52:	5b                   	pop    %ebx
  801f53:	5e                   	pop    %esi
  801f54:	5f                   	pop    %edi
  801f55:	5d                   	pop    %ebp
  801f56:	c3                   	ret    
			sys_yield();
  801f57:	e8 c5 ee ff ff       	call   800e21 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f5c:	8b 03                	mov    (%ebx),%eax
  801f5e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f61:	75 18                	jne    801f7b <devpipe_read+0x54>
			if (i > 0)
  801f63:	85 f6                	test   %esi,%esi
  801f65:	75 e6                	jne    801f4d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f67:	89 da                	mov    %ebx,%edx
  801f69:	89 f8                	mov    %edi,%eax
  801f6b:	e8 d0 fe ff ff       	call   801e40 <_pipeisclosed>
  801f70:	85 c0                	test   %eax,%eax
  801f72:	74 e3                	je     801f57 <devpipe_read+0x30>
				return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	eb d4                	jmp    801f4f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f7b:	99                   	cltd   
  801f7c:	c1 ea 1b             	shr    $0x1b,%edx
  801f7f:	01 d0                	add    %edx,%eax
  801f81:	83 e0 1f             	and    $0x1f,%eax
  801f84:	29 d0                	sub    %edx,%eax
  801f86:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f91:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f94:	83 c6 01             	add    $0x1,%esi
  801f97:	eb aa                	jmp    801f43 <devpipe_read+0x1c>

00801f99 <pipe>:
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	56                   	push   %esi
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa4:	50                   	push   %eax
  801fa5:	e8 b2 f1 ff ff       	call   80115c <fd_alloc>
  801faa:	89 c3                	mov    %eax,%ebx
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	0f 88 23 01 00 00    	js     8020da <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb7:	83 ec 04             	sub    $0x4,%esp
  801fba:	68 07 04 00 00       	push   $0x407
  801fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc2:	6a 00                	push   $0x0
  801fc4:	e8 77 ee ff ff       	call   800e40 <sys_page_alloc>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	0f 88 04 01 00 00    	js     8020da <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fdc:	50                   	push   %eax
  801fdd:	e8 7a f1 ff ff       	call   80115c <fd_alloc>
  801fe2:	89 c3                	mov    %eax,%ebx
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	0f 88 db 00 00 00    	js     8020ca <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	68 07 04 00 00       	push   $0x407
  801ff7:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffa:	6a 00                	push   $0x0
  801ffc:	e8 3f ee ff ff       	call   800e40 <sys_page_alloc>
  802001:	89 c3                	mov    %eax,%ebx
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	85 c0                	test   %eax,%eax
  802008:	0f 88 bc 00 00 00    	js     8020ca <pipe+0x131>
	va = fd2data(fd0);
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	ff 75 f4             	pushl  -0xc(%ebp)
  802014:	e8 2c f1 ff ff       	call   801145 <fd2data>
  802019:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201b:	83 c4 0c             	add    $0xc,%esp
  80201e:	68 07 04 00 00       	push   $0x407
  802023:	50                   	push   %eax
  802024:	6a 00                	push   $0x0
  802026:	e8 15 ee ff ff       	call   800e40 <sys_page_alloc>
  80202b:	89 c3                	mov    %eax,%ebx
  80202d:	83 c4 10             	add    $0x10,%esp
  802030:	85 c0                	test   %eax,%eax
  802032:	0f 88 82 00 00 00    	js     8020ba <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	ff 75 f0             	pushl  -0x10(%ebp)
  80203e:	e8 02 f1 ff ff       	call   801145 <fd2data>
  802043:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80204a:	50                   	push   %eax
  80204b:	6a 00                	push   $0x0
  80204d:	56                   	push   %esi
  80204e:	6a 00                	push   $0x0
  802050:	e8 2e ee ff ff       	call   800e83 <sys_page_map>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 20             	add    $0x20,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 4e                	js     8020ac <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80205e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802066:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802072:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802075:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	ff 75 f4             	pushl  -0xc(%ebp)
  802087:	e8 a9 f0 ff ff       	call   801135 <fd2num>
  80208c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802091:	83 c4 04             	add    $0x4,%esp
  802094:	ff 75 f0             	pushl  -0x10(%ebp)
  802097:	e8 99 f0 ff ff       	call   801135 <fd2num>
  80209c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020a2:	83 c4 10             	add    $0x10,%esp
  8020a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020aa:	eb 2e                	jmp    8020da <pipe+0x141>
	sys_page_unmap(0, va);
  8020ac:	83 ec 08             	sub    $0x8,%esp
  8020af:	56                   	push   %esi
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 0e ee ff ff       	call   800ec5 <sys_page_unmap>
  8020b7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020ba:	83 ec 08             	sub    $0x8,%esp
  8020bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c0:	6a 00                	push   $0x0
  8020c2:	e8 fe ed ff ff       	call   800ec5 <sys_page_unmap>
  8020c7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020ca:	83 ec 08             	sub    $0x8,%esp
  8020cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d0:	6a 00                	push   $0x0
  8020d2:	e8 ee ed ff ff       	call   800ec5 <sys_page_unmap>
  8020d7:	83 c4 10             	add    $0x10,%esp
}
  8020da:	89 d8                	mov    %ebx,%eax
  8020dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5e                   	pop    %esi
  8020e1:	5d                   	pop    %ebp
  8020e2:	c3                   	ret    

008020e3 <pipeisclosed>:
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ec:	50                   	push   %eax
  8020ed:	ff 75 08             	pushl  0x8(%ebp)
  8020f0:	e8 b9 f0 ff ff       	call   8011ae <fd_lookup>
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	78 18                	js     802114 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802102:	e8 3e f0 ff ff       	call   801145 <fd2data>
	return _pipeisclosed(fd, p);
  802107:	89 c2                	mov    %eax,%edx
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	e8 2f fd ff ff       	call   801e40 <_pipeisclosed>
  802111:	83 c4 10             	add    $0x10,%esp
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
  80211b:	c3                   	ret    

0080211c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802122:	68 ef 2b 80 00       	push   $0x802bef
  802127:	ff 75 0c             	pushl  0xc(%ebp)
  80212a:	e8 1f e9 ff ff       	call   800a4e <strcpy>
	return 0;
}
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <devcons_write>:
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	57                   	push   %edi
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802142:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802147:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80214d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802150:	73 31                	jae    802183 <devcons_write+0x4d>
		m = n - tot;
  802152:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802155:	29 f3                	sub    %esi,%ebx
  802157:	83 fb 7f             	cmp    $0x7f,%ebx
  80215a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80215f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802162:	83 ec 04             	sub    $0x4,%esp
  802165:	53                   	push   %ebx
  802166:	89 f0                	mov    %esi,%eax
  802168:	03 45 0c             	add    0xc(%ebp),%eax
  80216b:	50                   	push   %eax
  80216c:	57                   	push   %edi
  80216d:	e8 6a ea ff ff       	call   800bdc <memmove>
		sys_cputs(buf, m);
  802172:	83 c4 08             	add    $0x8,%esp
  802175:	53                   	push   %ebx
  802176:	57                   	push   %edi
  802177:	e8 08 ec ff ff       	call   800d84 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80217c:	01 de                	add    %ebx,%esi
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	eb ca                	jmp    80214d <devcons_write+0x17>
}
  802183:	89 f0                	mov    %esi,%eax
  802185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802188:	5b                   	pop    %ebx
  802189:	5e                   	pop    %esi
  80218a:	5f                   	pop    %edi
  80218b:	5d                   	pop    %ebp
  80218c:	c3                   	ret    

0080218d <devcons_read>:
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 08             	sub    $0x8,%esp
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219c:	74 21                	je     8021bf <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80219e:	e8 ff eb ff ff       	call   800da2 <sys_cgetc>
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	75 07                	jne    8021ae <devcons_read+0x21>
		sys_yield();
  8021a7:	e8 75 ec ff ff       	call   800e21 <sys_yield>
  8021ac:	eb f0                	jmp    80219e <devcons_read+0x11>
	if (c < 0)
  8021ae:	78 0f                	js     8021bf <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021b0:	83 f8 04             	cmp    $0x4,%eax
  8021b3:	74 0c                	je     8021c1 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	88 02                	mov    %al,(%edx)
	return 1;
  8021ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    
		return 0;
  8021c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c6:	eb f7                	jmp    8021bf <devcons_read+0x32>

008021c8 <cputchar>:
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d4:	6a 01                	push   $0x1
  8021d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d9:	50                   	push   %eax
  8021da:	e8 a5 eb ff ff       	call   800d84 <sys_cputs>
}
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <getchar>:
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ea:	6a 01                	push   $0x1
  8021ec:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ef:	50                   	push   %eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	e8 27 f2 ff ff       	call   80141e <read>
	if (r < 0)
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 06                	js     802204 <getchar+0x20>
	if (r < 1)
  8021fe:	74 06                	je     802206 <getchar+0x22>
	return c;
  802200:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    
		return -E_EOF;
  802206:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80220b:	eb f7                	jmp    802204 <getchar+0x20>

0080220d <iscons>:
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802213:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802216:	50                   	push   %eax
  802217:	ff 75 08             	pushl  0x8(%ebp)
  80221a:	e8 8f ef ff ff       	call   8011ae <fd_lookup>
  80221f:	83 c4 10             	add    $0x10,%esp
  802222:	85 c0                	test   %eax,%eax
  802224:	78 11                	js     802237 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80222f:	39 10                	cmp    %edx,(%eax)
  802231:	0f 94 c0             	sete   %al
  802234:	0f b6 c0             	movzbl %al,%eax
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <opencons>:
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80223f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802242:	50                   	push   %eax
  802243:	e8 14 ef ff ff       	call   80115c <fd_alloc>
  802248:	83 c4 10             	add    $0x10,%esp
  80224b:	85 c0                	test   %eax,%eax
  80224d:	78 3a                	js     802289 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	68 07 04 00 00       	push   $0x407
  802257:	ff 75 f4             	pushl  -0xc(%ebp)
  80225a:	6a 00                	push   $0x0
  80225c:	e8 df eb ff ff       	call   800e40 <sys_page_alloc>
  802261:	83 c4 10             	add    $0x10,%esp
  802264:	85 c0                	test   %eax,%eax
  802266:	78 21                	js     802289 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802271:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80227d:	83 ec 0c             	sub    $0xc,%esp
  802280:	50                   	push   %eax
  802281:	e8 af ee ff ff       	call   801135 <fd2num>
  802286:	83 c4 10             	add    $0x10,%esp
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	56                   	push   %esi
  80228f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802290:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802295:	8b 40 48             	mov    0x48(%eax),%eax
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	68 20 2c 80 00       	push   $0x802c20
  8022a0:	50                   	push   %eax
  8022a1:	68 04 27 80 00       	push   $0x802704
  8022a6:	e8 44 e0 ff ff       	call   8002ef <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8022ab:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022ae:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022b4:	e8 49 eb ff ff       	call   800e02 <sys_getenvid>
  8022b9:	83 c4 04             	add    $0x4,%esp
  8022bc:	ff 75 0c             	pushl  0xc(%ebp)
  8022bf:	ff 75 08             	pushl  0x8(%ebp)
  8022c2:	56                   	push   %esi
  8022c3:	50                   	push   %eax
  8022c4:	68 fc 2b 80 00       	push   $0x802bfc
  8022c9:	e8 21 e0 ff ff       	call   8002ef <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022ce:	83 c4 18             	add    $0x18,%esp
  8022d1:	53                   	push   %ebx
  8022d2:	ff 75 10             	pushl  0x10(%ebp)
  8022d5:	e8 c4 df ff ff       	call   80029e <vcprintf>
	cprintf("\n");
  8022da:	c7 04 24 c8 26 80 00 	movl   $0x8026c8,(%esp)
  8022e1:	e8 09 e0 ff ff       	call   8002ef <cprintf>
  8022e6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022e9:	cc                   	int3   
  8022ea:	eb fd                	jmp    8022e9 <_panic+0x5e>

008022ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	56                   	push   %esi
  8022f0:	53                   	push   %ebx
  8022f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022fa:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022fc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802301:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802304:	83 ec 0c             	sub    $0xc,%esp
  802307:	50                   	push   %eax
  802308:	e8 e3 ec ff ff       	call   800ff0 <sys_ipc_recv>
	if(ret < 0){
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	85 c0                	test   %eax,%eax
  802312:	78 2b                	js     80233f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802314:	85 f6                	test   %esi,%esi
  802316:	74 0a                	je     802322 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802318:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80231d:	8b 40 74             	mov    0x74(%eax),%eax
  802320:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802322:	85 db                	test   %ebx,%ebx
  802324:	74 0a                	je     802330 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802326:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80232b:	8b 40 78             	mov    0x78(%eax),%eax
  80232e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802330:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802335:	8b 40 70             	mov    0x70(%eax),%eax
}
  802338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    
		if(from_env_store)
  80233f:	85 f6                	test   %esi,%esi
  802341:	74 06                	je     802349 <ipc_recv+0x5d>
			*from_env_store = 0;
  802343:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802349:	85 db                	test   %ebx,%ebx
  80234b:	74 eb                	je     802338 <ipc_recv+0x4c>
			*perm_store = 0;
  80234d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802353:	eb e3                	jmp    802338 <ipc_recv+0x4c>

00802355 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	57                   	push   %edi
  802359:	56                   	push   %esi
  80235a:	53                   	push   %ebx
  80235b:	83 ec 0c             	sub    $0xc,%esp
  80235e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802361:	8b 75 0c             	mov    0xc(%ebp),%esi
  802364:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802367:	85 db                	test   %ebx,%ebx
  802369:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80236e:	0f 44 d8             	cmove  %eax,%ebx
  802371:	eb 05                	jmp    802378 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802373:	e8 a9 ea ff ff       	call   800e21 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802378:	ff 75 14             	pushl  0x14(%ebp)
  80237b:	53                   	push   %ebx
  80237c:	56                   	push   %esi
  80237d:	57                   	push   %edi
  80237e:	e8 4a ec ff ff       	call   800fcd <sys_ipc_try_send>
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	85 c0                	test   %eax,%eax
  802388:	74 1b                	je     8023a5 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80238a:	79 e7                	jns    802373 <ipc_send+0x1e>
  80238c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80238f:	74 e2                	je     802373 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 27 2c 80 00       	push   $0x802c27
  802399:	6a 46                	push   $0x46
  80239b:	68 3c 2c 80 00       	push   $0x802c3c
  8023a0:	e8 e6 fe ff ff       	call   80228b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a8:	5b                   	pop    %ebx
  8023a9:	5e                   	pop    %esi
  8023aa:	5f                   	pop    %edi
  8023ab:	5d                   	pop    %ebp
  8023ac:	c3                   	ret    

008023ad <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023b8:	89 c2                	mov    %eax,%edx
  8023ba:	c1 e2 07             	shl    $0x7,%edx
  8023bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023c3:	8b 52 50             	mov    0x50(%edx),%edx
  8023c6:	39 ca                	cmp    %ecx,%edx
  8023c8:	74 11                	je     8023db <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023ca:	83 c0 01             	add    $0x1,%eax
  8023cd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023d2:	75 e4                	jne    8023b8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d9:	eb 0b                	jmp    8023e6 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023db:	c1 e0 07             	shl    $0x7,%eax
  8023de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023e3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023e6:	5d                   	pop    %ebp
  8023e7:	c3                   	ret    

008023e8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ee:	89 d0                	mov    %edx,%eax
  8023f0:	c1 e8 16             	shr    $0x16,%eax
  8023f3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023ff:	f6 c1 01             	test   $0x1,%cl
  802402:	74 1d                	je     802421 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802404:	c1 ea 0c             	shr    $0xc,%edx
  802407:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80240e:	f6 c2 01             	test   $0x1,%dl
  802411:	74 0e                	je     802421 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802413:	c1 ea 0c             	shr    $0xc,%edx
  802416:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80241d:	ef 
  80241e:	0f b7 c0             	movzwl %ax,%eax
}
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    
  802423:	66 90                	xchg   %ax,%ax
  802425:	66 90                	xchg   %ax,%ax
  802427:	66 90                	xchg   %ax,%ax
  802429:	66 90                	xchg   %ax,%ax
  80242b:	66 90                	xchg   %ax,%ax
  80242d:	66 90                	xchg   %ax,%ax
  80242f:	90                   	nop

00802430 <__udivdi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80243b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80243f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802443:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802447:	85 d2                	test   %edx,%edx
  802449:	75 4d                	jne    802498 <__udivdi3+0x68>
  80244b:	39 f3                	cmp    %esi,%ebx
  80244d:	76 19                	jbe    802468 <__udivdi3+0x38>
  80244f:	31 ff                	xor    %edi,%edi
  802451:	89 e8                	mov    %ebp,%eax
  802453:	89 f2                	mov    %esi,%edx
  802455:	f7 f3                	div    %ebx
  802457:	89 fa                	mov    %edi,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 d9                	mov    %ebx,%ecx
  80246a:	85 db                	test   %ebx,%ebx
  80246c:	75 0b                	jne    802479 <__udivdi3+0x49>
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f3                	div    %ebx
  802477:	89 c1                	mov    %eax,%ecx
  802479:	31 d2                	xor    %edx,%edx
  80247b:	89 f0                	mov    %esi,%eax
  80247d:	f7 f1                	div    %ecx
  80247f:	89 c6                	mov    %eax,%esi
  802481:	89 e8                	mov    %ebp,%eax
  802483:	89 f7                	mov    %esi,%edi
  802485:	f7 f1                	div    %ecx
  802487:	89 fa                	mov    %edi,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	39 f2                	cmp    %esi,%edx
  80249a:	77 1c                	ja     8024b8 <__udivdi3+0x88>
  80249c:	0f bd fa             	bsr    %edx,%edi
  80249f:	83 f7 1f             	xor    $0x1f,%edi
  8024a2:	75 2c                	jne    8024d0 <__udivdi3+0xa0>
  8024a4:	39 f2                	cmp    %esi,%edx
  8024a6:	72 06                	jb     8024ae <__udivdi3+0x7e>
  8024a8:	31 c0                	xor    %eax,%eax
  8024aa:	39 eb                	cmp    %ebp,%ebx
  8024ac:	77 a9                	ja     802457 <__udivdi3+0x27>
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	eb a2                	jmp    802457 <__udivdi3+0x27>
  8024b5:	8d 76 00             	lea    0x0(%esi),%esi
  8024b8:	31 ff                	xor    %edi,%edi
  8024ba:	31 c0                	xor    %eax,%eax
  8024bc:	89 fa                	mov    %edi,%edx
  8024be:	83 c4 1c             	add    $0x1c,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5f                   	pop    %edi
  8024c4:	5d                   	pop    %ebp
  8024c5:	c3                   	ret    
  8024c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024cd:	8d 76 00             	lea    0x0(%esi),%esi
  8024d0:	89 f9                	mov    %edi,%ecx
  8024d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024d7:	29 f8                	sub    %edi,%eax
  8024d9:	d3 e2                	shl    %cl,%edx
  8024db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024df:	89 c1                	mov    %eax,%ecx
  8024e1:	89 da                	mov    %ebx,%edx
  8024e3:	d3 ea                	shr    %cl,%edx
  8024e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e9:	09 d1                	or     %edx,%ecx
  8024eb:	89 f2                	mov    %esi,%edx
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 f9                	mov    %edi,%ecx
  8024f3:	d3 e3                	shl    %cl,%ebx
  8024f5:	89 c1                	mov    %eax,%ecx
  8024f7:	d3 ea                	shr    %cl,%edx
  8024f9:	89 f9                	mov    %edi,%ecx
  8024fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024ff:	89 eb                	mov    %ebp,%ebx
  802501:	d3 e6                	shl    %cl,%esi
  802503:	89 c1                	mov    %eax,%ecx
  802505:	d3 eb                	shr    %cl,%ebx
  802507:	09 de                	or     %ebx,%esi
  802509:	89 f0                	mov    %esi,%eax
  80250b:	f7 74 24 08          	divl   0x8(%esp)
  80250f:	89 d6                	mov    %edx,%esi
  802511:	89 c3                	mov    %eax,%ebx
  802513:	f7 64 24 0c          	mull   0xc(%esp)
  802517:	39 d6                	cmp    %edx,%esi
  802519:	72 15                	jb     802530 <__udivdi3+0x100>
  80251b:	89 f9                	mov    %edi,%ecx
  80251d:	d3 e5                	shl    %cl,%ebp
  80251f:	39 c5                	cmp    %eax,%ebp
  802521:	73 04                	jae    802527 <__udivdi3+0xf7>
  802523:	39 d6                	cmp    %edx,%esi
  802525:	74 09                	je     802530 <__udivdi3+0x100>
  802527:	89 d8                	mov    %ebx,%eax
  802529:	31 ff                	xor    %edi,%edi
  80252b:	e9 27 ff ff ff       	jmp    802457 <__udivdi3+0x27>
  802530:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802533:	31 ff                	xor    %edi,%edi
  802535:	e9 1d ff ff ff       	jmp    802457 <__udivdi3+0x27>
  80253a:	66 90                	xchg   %ax,%ax
  80253c:	66 90                	xchg   %ax,%ax
  80253e:	66 90                	xchg   %ax,%ax

00802540 <__umoddi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	83 ec 1c             	sub    $0x1c,%esp
  802547:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80254b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80254f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802553:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802557:	89 da                	mov    %ebx,%edx
  802559:	85 c0                	test   %eax,%eax
  80255b:	75 43                	jne    8025a0 <__umoddi3+0x60>
  80255d:	39 df                	cmp    %ebx,%edi
  80255f:	76 17                	jbe    802578 <__umoddi3+0x38>
  802561:	89 f0                	mov    %esi,%eax
  802563:	f7 f7                	div    %edi
  802565:	89 d0                	mov    %edx,%eax
  802567:	31 d2                	xor    %edx,%edx
  802569:	83 c4 1c             	add    $0x1c,%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802578:	89 fd                	mov    %edi,%ebp
  80257a:	85 ff                	test   %edi,%edi
  80257c:	75 0b                	jne    802589 <__umoddi3+0x49>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	31 d2                	xor    %edx,%edx
  802585:	f7 f7                	div    %edi
  802587:	89 c5                	mov    %eax,%ebp
  802589:	89 d8                	mov    %ebx,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	f7 f5                	div    %ebp
  80258f:	89 f0                	mov    %esi,%eax
  802591:	f7 f5                	div    %ebp
  802593:	89 d0                	mov    %edx,%eax
  802595:	eb d0                	jmp    802567 <__umoddi3+0x27>
  802597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259e:	66 90                	xchg   %ax,%ax
  8025a0:	89 f1                	mov    %esi,%ecx
  8025a2:	39 d8                	cmp    %ebx,%eax
  8025a4:	76 0a                	jbe    8025b0 <__umoddi3+0x70>
  8025a6:	89 f0                	mov    %esi,%eax
  8025a8:	83 c4 1c             	add    $0x1c,%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	0f bd e8             	bsr    %eax,%ebp
  8025b3:	83 f5 1f             	xor    $0x1f,%ebp
  8025b6:	75 20                	jne    8025d8 <__umoddi3+0x98>
  8025b8:	39 d8                	cmp    %ebx,%eax
  8025ba:	0f 82 b0 00 00 00    	jb     802670 <__umoddi3+0x130>
  8025c0:	39 f7                	cmp    %esi,%edi
  8025c2:	0f 86 a8 00 00 00    	jbe    802670 <__umoddi3+0x130>
  8025c8:	89 c8                	mov    %ecx,%eax
  8025ca:	83 c4 1c             	add    $0x1c,%esp
  8025cd:	5b                   	pop    %ebx
  8025ce:	5e                   	pop    %esi
  8025cf:	5f                   	pop    %edi
  8025d0:	5d                   	pop    %ebp
  8025d1:	c3                   	ret    
  8025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	ba 20 00 00 00       	mov    $0x20,%edx
  8025df:	29 ea                	sub    %ebp,%edx
  8025e1:	d3 e0                	shl    %cl,%eax
  8025e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025e7:	89 d1                	mov    %edx,%ecx
  8025e9:	89 f8                	mov    %edi,%eax
  8025eb:	d3 e8                	shr    %cl,%eax
  8025ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025f9:	09 c1                	or     %eax,%ecx
  8025fb:	89 d8                	mov    %ebx,%eax
  8025fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802601:	89 e9                	mov    %ebp,%ecx
  802603:	d3 e7                	shl    %cl,%edi
  802605:	89 d1                	mov    %edx,%ecx
  802607:	d3 e8                	shr    %cl,%eax
  802609:	89 e9                	mov    %ebp,%ecx
  80260b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80260f:	d3 e3                	shl    %cl,%ebx
  802611:	89 c7                	mov    %eax,%edi
  802613:	89 d1                	mov    %edx,%ecx
  802615:	89 f0                	mov    %esi,%eax
  802617:	d3 e8                	shr    %cl,%eax
  802619:	89 e9                	mov    %ebp,%ecx
  80261b:	89 fa                	mov    %edi,%edx
  80261d:	d3 e6                	shl    %cl,%esi
  80261f:	09 d8                	or     %ebx,%eax
  802621:	f7 74 24 08          	divl   0x8(%esp)
  802625:	89 d1                	mov    %edx,%ecx
  802627:	89 f3                	mov    %esi,%ebx
  802629:	f7 64 24 0c          	mull   0xc(%esp)
  80262d:	89 c6                	mov    %eax,%esi
  80262f:	89 d7                	mov    %edx,%edi
  802631:	39 d1                	cmp    %edx,%ecx
  802633:	72 06                	jb     80263b <__umoddi3+0xfb>
  802635:	75 10                	jne    802647 <__umoddi3+0x107>
  802637:	39 c3                	cmp    %eax,%ebx
  802639:	73 0c                	jae    802647 <__umoddi3+0x107>
  80263b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80263f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802643:	89 d7                	mov    %edx,%edi
  802645:	89 c6                	mov    %eax,%esi
  802647:	89 ca                	mov    %ecx,%edx
  802649:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80264e:	29 f3                	sub    %esi,%ebx
  802650:	19 fa                	sbb    %edi,%edx
  802652:	89 d0                	mov    %edx,%eax
  802654:	d3 e0                	shl    %cl,%eax
  802656:	89 e9                	mov    %ebp,%ecx
  802658:	d3 eb                	shr    %cl,%ebx
  80265a:	d3 ea                	shr    %cl,%edx
  80265c:	09 d8                	or     %ebx,%eax
  80265e:	83 c4 1c             	add    $0x1c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    
  802666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	89 da                	mov    %ebx,%edx
  802672:	29 fe                	sub    %edi,%esi
  802674:	19 c2                	sbb    %eax,%edx
  802676:	89 f1                	mov    %esi,%ecx
  802678:	89 c8                	mov    %ecx,%eax
  80267a:	e9 4b ff ff ff       	jmp    8025ca <__umoddi3+0x8a>
