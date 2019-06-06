
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
  800124:	68 60 26 80 00       	push   $0x802660
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
  8001d0:	68 8c 26 80 00       	push   $0x80268c
  8001d5:	e8 15 01 00 00       	call   8002ef <cprintf>
	cprintf("before umain\n");
  8001da:	c7 04 24 aa 26 80 00 	movl   $0x8026aa,(%esp)
  8001e1:	e8 09 01 00 00       	call   8002ef <cprintf>
	// call user main routine
	umain(argc, argv);
  8001e6:	83 c4 08             	add    $0x8,%esp
  8001e9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ec:	ff 75 08             	pushl  0x8(%ebp)
  8001ef:	e8 3f ff ff ff       	call   800133 <umain>
	cprintf("after umain\n");
  8001f4:	c7 04 24 b8 26 80 00 	movl   $0x8026b8,(%esp)
  8001fb:	e8 ef 00 00 00       	call   8002ef <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800200:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800205:	8b 40 48             	mov    0x48(%eax),%eax
  800208:	83 c4 08             	add    $0x8,%esp
  80020b:	50                   	push   %eax
  80020c:	68 c5 26 80 00       	push   $0x8026c5
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
  800234:	68 f0 26 80 00       	push   $0x8026f0
  800239:	50                   	push   %eax
  80023a:	68 e4 26 80 00       	push   $0x8026e4
  80023f:	e8 ab 00 00 00       	call   8002ef <cprintf>
	close_all();
  800244:	e8 a4 10 00 00       	call   8012ed <close_all>
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
  80039c:	e8 6f 20 00 00       	call   802410 <__udivdi3>
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
  8003c5:	e8 56 21 00 00       	call   802520 <__umoddi3>
  8003ca:	83 c4 14             	add    $0x14,%esp
  8003cd:	0f be 80 f5 26 80 00 	movsbl 0x8026f5(%eax),%eax
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
  800476:	ff 24 85 e0 28 80 00 	jmp    *0x8028e0(,%eax,4)
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
  800541:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  800548:	85 d2                	test   %edx,%edx
  80054a:	74 18                	je     800564 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80054c:	52                   	push   %edx
  80054d:	68 5d 2b 80 00       	push   $0x802b5d
  800552:	53                   	push   %ebx
  800553:	56                   	push   %esi
  800554:	e8 a6 fe ff ff       	call   8003ff <printfmt>
  800559:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055f:	e9 fe 02 00 00       	jmp    800862 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800564:	50                   	push   %eax
  800565:	68 0d 27 80 00       	push   $0x80270d
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
  80058c:	b8 06 27 80 00       	mov    $0x802706,%eax
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
  800924:	bf 29 28 80 00       	mov    $0x802829,%edi
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
  800950:	bf 61 28 80 00       	mov    $0x802861,%edi
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
  800df1:	68 88 2a 80 00       	push   $0x802a88
  800df6:	6a 43                	push   $0x43
  800df8:	68 a5 2a 80 00       	push   $0x802aa5
  800dfd:	e8 69 14 00 00       	call   80226b <_panic>

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
  800e72:	68 88 2a 80 00       	push   $0x802a88
  800e77:	6a 43                	push   $0x43
  800e79:	68 a5 2a 80 00       	push   $0x802aa5
  800e7e:	e8 e8 13 00 00       	call   80226b <_panic>

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
  800eb4:	68 88 2a 80 00       	push   $0x802a88
  800eb9:	6a 43                	push   $0x43
  800ebb:	68 a5 2a 80 00       	push   $0x802aa5
  800ec0:	e8 a6 13 00 00       	call   80226b <_panic>

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
  800ef6:	68 88 2a 80 00       	push   $0x802a88
  800efb:	6a 43                	push   $0x43
  800efd:	68 a5 2a 80 00       	push   $0x802aa5
  800f02:	e8 64 13 00 00       	call   80226b <_panic>

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
  800f38:	68 88 2a 80 00       	push   $0x802a88
  800f3d:	6a 43                	push   $0x43
  800f3f:	68 a5 2a 80 00       	push   $0x802aa5
  800f44:	e8 22 13 00 00       	call   80226b <_panic>

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
  800f7a:	68 88 2a 80 00       	push   $0x802a88
  800f7f:	6a 43                	push   $0x43
  800f81:	68 a5 2a 80 00       	push   $0x802aa5
  800f86:	e8 e0 12 00 00       	call   80226b <_panic>

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
  800fbc:	68 88 2a 80 00       	push   $0x802a88
  800fc1:	6a 43                	push   $0x43
  800fc3:	68 a5 2a 80 00       	push   $0x802aa5
  800fc8:	e8 9e 12 00 00       	call   80226b <_panic>

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
  801020:	68 88 2a 80 00       	push   $0x802a88
  801025:	6a 43                	push   $0x43
  801027:	68 a5 2a 80 00       	push   $0x802aa5
  80102c:	e8 3a 12 00 00       	call   80226b <_panic>

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
  801104:	68 88 2a 80 00       	push   $0x802a88
  801109:	6a 43                	push   $0x43
  80110b:	68 a5 2a 80 00       	push   $0x802aa5
  801110:	e8 56 11 00 00       	call   80226b <_panic>

00801115 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	05 00 00 00 30       	add    $0x30000000,%eax
  801120:	c1 e8 0c             	shr    $0xc,%eax
}
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801135:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801144:	89 c2                	mov    %eax,%edx
  801146:	c1 ea 16             	shr    $0x16,%edx
  801149:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801150:	f6 c2 01             	test   $0x1,%dl
  801153:	74 2d                	je     801182 <fd_alloc+0x46>
  801155:	89 c2                	mov    %eax,%edx
  801157:	c1 ea 0c             	shr    $0xc,%edx
  80115a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801161:	f6 c2 01             	test   $0x1,%dl
  801164:	74 1c                	je     801182 <fd_alloc+0x46>
  801166:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80116b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801170:	75 d2                	jne    801144 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80117b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801180:	eb 0a                	jmp    80118c <fd_alloc+0x50>
			*fd_store = fd;
  801182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801185:	89 01                	mov    %eax,(%ecx)
			return 0;
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801194:	83 f8 1f             	cmp    $0x1f,%eax
  801197:	77 30                	ja     8011c9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801199:	c1 e0 0c             	shl    $0xc,%eax
  80119c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011a7:	f6 c2 01             	test   $0x1,%dl
  8011aa:	74 24                	je     8011d0 <fd_lookup+0x42>
  8011ac:	89 c2                	mov    %eax,%edx
  8011ae:	c1 ea 0c             	shr    $0xc,%edx
  8011b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b8:	f6 c2 01             	test   $0x1,%dl
  8011bb:	74 1a                	je     8011d7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c0:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    
		return -E_INVAL;
  8011c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ce:	eb f7                	jmp    8011c7 <fd_lookup+0x39>
		return -E_INVAL;
  8011d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d5:	eb f0                	jmp    8011c7 <fd_lookup+0x39>
  8011d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011dc:	eb e9                	jmp    8011c7 <fd_lookup+0x39>

008011de <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ec:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011f1:	39 08                	cmp    %ecx,(%eax)
  8011f3:	74 38                	je     80122d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011f5:	83 c2 01             	add    $0x1,%edx
  8011f8:	8b 04 95 30 2b 80 00 	mov    0x802b30(,%edx,4),%eax
  8011ff:	85 c0                	test   %eax,%eax
  801201:	75 ee                	jne    8011f1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801203:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801208:	8b 40 48             	mov    0x48(%eax),%eax
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	51                   	push   %ecx
  80120f:	50                   	push   %eax
  801210:	68 b4 2a 80 00       	push   $0x802ab4
  801215:	e8 d5 f0 ff ff       	call   8002ef <cprintf>
	*dev = 0;
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801223:	83 c4 10             	add    $0x10,%esp
  801226:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    
			*dev = devtab[i];
  80122d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801230:	89 01                	mov    %eax,(%ecx)
			return 0;
  801232:	b8 00 00 00 00       	mov    $0x0,%eax
  801237:	eb f2                	jmp    80122b <dev_lookup+0x4d>

00801239 <fd_close>:
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	57                   	push   %edi
  80123d:	56                   	push   %esi
  80123e:	53                   	push   %ebx
  80123f:	83 ec 24             	sub    $0x24,%esp
  801242:	8b 75 08             	mov    0x8(%ebp),%esi
  801245:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801248:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80124b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801252:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801255:	50                   	push   %eax
  801256:	e8 33 ff ff ff       	call   80118e <fd_lookup>
  80125b:	89 c3                	mov    %eax,%ebx
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	78 05                	js     801269 <fd_close+0x30>
	    || fd != fd2)
  801264:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801267:	74 16                	je     80127f <fd_close+0x46>
		return (must_exist ? r : 0);
  801269:	89 f8                	mov    %edi,%eax
  80126b:	84 c0                	test   %al,%al
  80126d:	b8 00 00 00 00       	mov    $0x0,%eax
  801272:	0f 44 d8             	cmove  %eax,%ebx
}
  801275:	89 d8                	mov    %ebx,%eax
  801277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5f                   	pop    %edi
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80127f:	83 ec 08             	sub    $0x8,%esp
  801282:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801285:	50                   	push   %eax
  801286:	ff 36                	pushl  (%esi)
  801288:	e8 51 ff ff ff       	call   8011de <dev_lookup>
  80128d:	89 c3                	mov    %eax,%ebx
  80128f:	83 c4 10             	add    $0x10,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 1a                	js     8012b0 <fd_close+0x77>
		if (dev->dev_close)
  801296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801299:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80129c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	74 0b                	je     8012b0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012a5:	83 ec 0c             	sub    $0xc,%esp
  8012a8:	56                   	push   %esi
  8012a9:	ff d0                	call   *%eax
  8012ab:	89 c3                	mov    %eax,%ebx
  8012ad:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	56                   	push   %esi
  8012b4:	6a 00                	push   $0x0
  8012b6:	e8 0a fc ff ff       	call   800ec5 <sys_page_unmap>
	return r;
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	eb b5                	jmp    801275 <fd_close+0x3c>

008012c0 <close>:

int
close(int fdnum)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 08             	pushl  0x8(%ebp)
  8012cd:	e8 bc fe ff ff       	call   80118e <fd_lookup>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	79 02                	jns    8012db <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    
		return fd_close(fd, 1);
  8012db:	83 ec 08             	sub    $0x8,%esp
  8012de:	6a 01                	push   $0x1
  8012e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e3:	e8 51 ff ff ff       	call   801239 <fd_close>
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	eb ec                	jmp    8012d9 <close+0x19>

008012ed <close_all>:

void
close_all(void)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	53                   	push   %ebx
  8012f1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f9:	83 ec 0c             	sub    $0xc,%esp
  8012fc:	53                   	push   %ebx
  8012fd:	e8 be ff ff ff       	call   8012c0 <close>
	for (i = 0; i < MAXFD; i++)
  801302:	83 c3 01             	add    $0x1,%ebx
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	83 fb 20             	cmp    $0x20,%ebx
  80130b:	75 ec                	jne    8012f9 <close_all+0xc>
}
  80130d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80131b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80131e:	50                   	push   %eax
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	e8 67 fe ff ff       	call   80118e <fd_lookup>
  801327:	89 c3                	mov    %eax,%ebx
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	0f 88 81 00 00 00    	js     8013b5 <dup+0xa3>
		return r;
	close(newfdnum);
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	e8 81 ff ff ff       	call   8012c0 <close>

	newfd = INDEX2FD(newfdnum);
  80133f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801342:	c1 e6 0c             	shl    $0xc,%esi
  801345:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80134b:	83 c4 04             	add    $0x4,%esp
  80134e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801351:	e8 cf fd ff ff       	call   801125 <fd2data>
  801356:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801358:	89 34 24             	mov    %esi,(%esp)
  80135b:	e8 c5 fd ff ff       	call   801125 <fd2data>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801365:	89 d8                	mov    %ebx,%eax
  801367:	c1 e8 16             	shr    $0x16,%eax
  80136a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801371:	a8 01                	test   $0x1,%al
  801373:	74 11                	je     801386 <dup+0x74>
  801375:	89 d8                	mov    %ebx,%eax
  801377:	c1 e8 0c             	shr    $0xc,%eax
  80137a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801381:	f6 c2 01             	test   $0x1,%dl
  801384:	75 39                	jne    8013bf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801386:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801389:	89 d0                	mov    %edx,%eax
  80138b:	c1 e8 0c             	shr    $0xc,%eax
  80138e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801395:	83 ec 0c             	sub    $0xc,%esp
  801398:	25 07 0e 00 00       	and    $0xe07,%eax
  80139d:	50                   	push   %eax
  80139e:	56                   	push   %esi
  80139f:	6a 00                	push   $0x0
  8013a1:	52                   	push   %edx
  8013a2:	6a 00                	push   $0x0
  8013a4:	e8 da fa ff ff       	call   800e83 <sys_page_map>
  8013a9:	89 c3                	mov    %eax,%ebx
  8013ab:	83 c4 20             	add    $0x20,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 31                	js     8013e3 <dup+0xd1>
		goto err;

	return newfdnum;
  8013b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013b5:	89 d8                	mov    %ebx,%eax
  8013b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ba:	5b                   	pop    %ebx
  8013bb:	5e                   	pop    %esi
  8013bc:	5f                   	pop    %edi
  8013bd:	5d                   	pop    %ebp
  8013be:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c6:	83 ec 0c             	sub    $0xc,%esp
  8013c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ce:	50                   	push   %eax
  8013cf:	57                   	push   %edi
  8013d0:	6a 00                	push   $0x0
  8013d2:	53                   	push   %ebx
  8013d3:	6a 00                	push   $0x0
  8013d5:	e8 a9 fa ff ff       	call   800e83 <sys_page_map>
  8013da:	89 c3                	mov    %eax,%ebx
  8013dc:	83 c4 20             	add    $0x20,%esp
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	79 a3                	jns    801386 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013e3:	83 ec 08             	sub    $0x8,%esp
  8013e6:	56                   	push   %esi
  8013e7:	6a 00                	push   $0x0
  8013e9:	e8 d7 fa ff ff       	call   800ec5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013ee:	83 c4 08             	add    $0x8,%esp
  8013f1:	57                   	push   %edi
  8013f2:	6a 00                	push   $0x0
  8013f4:	e8 cc fa ff ff       	call   800ec5 <sys_page_unmap>
	return r;
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	eb b7                	jmp    8013b5 <dup+0xa3>

008013fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	53                   	push   %ebx
  801402:	83 ec 1c             	sub    $0x1c,%esp
  801405:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801408:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140b:	50                   	push   %eax
  80140c:	53                   	push   %ebx
  80140d:	e8 7c fd ff ff       	call   80118e <fd_lookup>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 3f                	js     801458 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801423:	ff 30                	pushl  (%eax)
  801425:	e8 b4 fd ff ff       	call   8011de <dev_lookup>
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 27                	js     801458 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801434:	8b 42 08             	mov    0x8(%edx),%eax
  801437:	83 e0 03             	and    $0x3,%eax
  80143a:	83 f8 01             	cmp    $0x1,%eax
  80143d:	74 1e                	je     80145d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80143f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801442:	8b 40 08             	mov    0x8(%eax),%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 35                	je     80147e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	ff 75 10             	pushl  0x10(%ebp)
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	52                   	push   %edx
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
}
  801458:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801462:	8b 40 48             	mov    0x48(%eax),%eax
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	53                   	push   %ebx
  801469:	50                   	push   %eax
  80146a:	68 f5 2a 80 00       	push   $0x802af5
  80146f:	e8 7b ee ff ff       	call   8002ef <cprintf>
		return -E_INVAL;
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147c:	eb da                	jmp    801458 <read+0x5a>
		return -E_NOT_SUPP;
  80147e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801483:	eb d3                	jmp    801458 <read+0x5a>

00801485 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	57                   	push   %edi
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 0c             	sub    $0xc,%esp
  80148e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801491:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801494:	bb 00 00 00 00       	mov    $0x0,%ebx
  801499:	39 f3                	cmp    %esi,%ebx
  80149b:	73 23                	jae    8014c0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	89 f0                	mov    %esi,%eax
  8014a2:	29 d8                	sub    %ebx,%eax
  8014a4:	50                   	push   %eax
  8014a5:	89 d8                	mov    %ebx,%eax
  8014a7:	03 45 0c             	add    0xc(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	57                   	push   %edi
  8014ac:	e8 4d ff ff ff       	call   8013fe <read>
		if (m < 0)
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 06                	js     8014be <readn+0x39>
			return m;
		if (m == 0)
  8014b8:	74 06                	je     8014c0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014ba:	01 c3                	add    %eax,%ebx
  8014bc:	eb db                	jmp    801499 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014be:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014c0:	89 d8                	mov    %ebx,%eax
  8014c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 1c             	sub    $0x1c,%esp
  8014d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d7:	50                   	push   %eax
  8014d8:	53                   	push   %ebx
  8014d9:	e8 b0 fc ff ff       	call   80118e <fd_lookup>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 3a                	js     80151f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014eb:	50                   	push   %eax
  8014ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ef:	ff 30                	pushl  (%eax)
  8014f1:	e8 e8 fc ff ff       	call   8011de <dev_lookup>
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 22                	js     80151f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801500:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801504:	74 1e                	je     801524 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801506:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801509:	8b 52 0c             	mov    0xc(%edx),%edx
  80150c:	85 d2                	test   %edx,%edx
  80150e:	74 35                	je     801545 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	ff 75 10             	pushl  0x10(%ebp)
  801516:	ff 75 0c             	pushl  0xc(%ebp)
  801519:	50                   	push   %eax
  80151a:	ff d2                	call   *%edx
  80151c:	83 c4 10             	add    $0x10,%esp
}
  80151f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801522:	c9                   	leave  
  801523:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801524:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801529:	8b 40 48             	mov    0x48(%eax),%eax
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	53                   	push   %ebx
  801530:	50                   	push   %eax
  801531:	68 11 2b 80 00       	push   $0x802b11
  801536:	e8 b4 ed ff ff       	call   8002ef <cprintf>
		return -E_INVAL;
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801543:	eb da                	jmp    80151f <write+0x55>
		return -E_NOT_SUPP;
  801545:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154a:	eb d3                	jmp    80151f <write+0x55>

0080154c <seek>:

int
seek(int fdnum, off_t offset)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	ff 75 08             	pushl  0x8(%ebp)
  801559:	e8 30 fc ff ff       	call   80118e <fd_lookup>
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	78 0e                	js     801573 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801565:	8b 55 0c             	mov    0xc(%ebp),%edx
  801568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80156e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	53                   	push   %ebx
  801579:	83 ec 1c             	sub    $0x1c,%esp
  80157c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801582:	50                   	push   %eax
  801583:	53                   	push   %ebx
  801584:	e8 05 fc ff ff       	call   80118e <fd_lookup>
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 37                	js     8015c7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801596:	50                   	push   %eax
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	ff 30                	pushl  (%eax)
  80159c:	e8 3d fc ff ff       	call   8011de <dev_lookup>
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 1f                	js     8015c7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015af:	74 1b                	je     8015cc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b4:	8b 52 18             	mov    0x18(%edx),%edx
  8015b7:	85 d2                	test   %edx,%edx
  8015b9:	74 32                	je     8015ed <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	50                   	push   %eax
  8015c2:	ff d2                	call   *%edx
  8015c4:	83 c4 10             	add    $0x10,%esp
}
  8015c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015cc:	a1 4c 50 80 00       	mov    0x80504c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d1:	8b 40 48             	mov    0x48(%eax),%eax
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	53                   	push   %ebx
  8015d8:	50                   	push   %eax
  8015d9:	68 d4 2a 80 00       	push   $0x802ad4
  8015de:	e8 0c ed ff ff       	call   8002ef <cprintf>
		return -E_INVAL;
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015eb:	eb da                	jmp    8015c7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f2:	eb d3                	jmp    8015c7 <ftruncate+0x52>

008015f4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 1c             	sub    $0x1c,%esp
  8015fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801601:	50                   	push   %eax
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	e8 84 fb ff ff       	call   80118e <fd_lookup>
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 4b                	js     80165c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161b:	ff 30                	pushl  (%eax)
  80161d:	e8 bc fb ff ff       	call   8011de <dev_lookup>
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	78 33                	js     80165c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801630:	74 2f                	je     801661 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801632:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801635:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163c:	00 00 00 
	stat->st_isdir = 0;
  80163f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801646:	00 00 00 
	stat->st_dev = dev;
  801649:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	53                   	push   %ebx
  801653:	ff 75 f0             	pushl  -0x10(%ebp)
  801656:	ff 50 14             	call   *0x14(%eax)
  801659:	83 c4 10             	add    $0x10,%esp
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
		return -E_NOT_SUPP;
  801661:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801666:	eb f4                	jmp    80165c <fstat+0x68>

00801668 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	56                   	push   %esi
  80166c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80166d:	83 ec 08             	sub    $0x8,%esp
  801670:	6a 00                	push   $0x0
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	e8 22 02 00 00       	call   80189c <open>
  80167a:	89 c3                	mov    %eax,%ebx
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	85 c0                	test   %eax,%eax
  801681:	78 1b                	js     80169e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	50                   	push   %eax
  80168a:	e8 65 ff ff ff       	call   8015f4 <fstat>
  80168f:	89 c6                	mov    %eax,%esi
	close(fd);
  801691:	89 1c 24             	mov    %ebx,(%esp)
  801694:	e8 27 fc ff ff       	call   8012c0 <close>
	return r;
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	89 f3                	mov    %esi,%ebx
}
  80169e:	89 d8                	mov    %ebx,%eax
  8016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	89 c6                	mov    %eax,%esi
  8016ae:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016b0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016b7:	74 27                	je     8016e0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016b9:	6a 07                	push   $0x7
  8016bb:	68 00 60 80 00       	push   $0x806000
  8016c0:	56                   	push   %esi
  8016c1:	ff 35 00 40 80 00    	pushl  0x804000
  8016c7:	e8 69 0c 00 00       	call   802335 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016cc:	83 c4 0c             	add    $0xc,%esp
  8016cf:	6a 00                	push   $0x0
  8016d1:	53                   	push   %ebx
  8016d2:	6a 00                	push   $0x0
  8016d4:	e8 f3 0b 00 00       	call   8022cc <ipc_recv>
}
  8016d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016dc:	5b                   	pop    %ebx
  8016dd:	5e                   	pop    %esi
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e0:	83 ec 0c             	sub    $0xc,%esp
  8016e3:	6a 01                	push   $0x1
  8016e5:	e8 a3 0c 00 00       	call   80238d <ipc_find_env>
  8016ea:	a3 00 40 80 00       	mov    %eax,0x804000
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	eb c5                	jmp    8016b9 <fsipc+0x12>

008016f4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801700:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80170d:	ba 00 00 00 00       	mov    $0x0,%edx
  801712:	b8 02 00 00 00       	mov    $0x2,%eax
  801717:	e8 8b ff ff ff       	call   8016a7 <fsipc>
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <devfile_flush>:
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8b 40 0c             	mov    0xc(%eax),%eax
  80172a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 06 00 00 00       	mov    $0x6,%eax
  801739:	e8 69 ff ff ff       	call   8016a7 <fsipc>
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <devfile_stat>:
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8b 40 0c             	mov    0xc(%eax),%eax
  801750:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	b8 05 00 00 00       	mov    $0x5,%eax
  80175f:	e8 43 ff ff ff       	call   8016a7 <fsipc>
  801764:	85 c0                	test   %eax,%eax
  801766:	78 2c                	js     801794 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801768:	83 ec 08             	sub    $0x8,%esp
  80176b:	68 00 60 80 00       	push   $0x806000
  801770:	53                   	push   %ebx
  801771:	e8 d8 f2 ff ff       	call   800a4e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801776:	a1 80 60 80 00       	mov    0x806080,%eax
  80177b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801781:	a1 84 60 80 00       	mov    0x806084,%eax
  801786:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <devfile_write>:
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	53                   	push   %ebx
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8017ae:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017b4:	53                   	push   %ebx
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	68 08 60 80 00       	push   $0x806008
  8017bd:	e8 7c f4 ff ff       	call   800c3e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017cc:	e8 d6 fe ff ff       	call   8016a7 <fsipc>
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 0b                	js     8017e3 <devfile_write+0x4a>
	assert(r <= n);
  8017d8:	39 d8                	cmp    %ebx,%eax
  8017da:	77 0c                	ja     8017e8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017dc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e1:	7f 1e                	jg     801801 <devfile_write+0x68>
}
  8017e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    
	assert(r <= n);
  8017e8:	68 44 2b 80 00       	push   $0x802b44
  8017ed:	68 4b 2b 80 00       	push   $0x802b4b
  8017f2:	68 98 00 00 00       	push   $0x98
  8017f7:	68 60 2b 80 00       	push   $0x802b60
  8017fc:	e8 6a 0a 00 00       	call   80226b <_panic>
	assert(r <= PGSIZE);
  801801:	68 6b 2b 80 00       	push   $0x802b6b
  801806:	68 4b 2b 80 00       	push   $0x802b4b
  80180b:	68 99 00 00 00       	push   $0x99
  801810:	68 60 2b 80 00       	push   $0x802b60
  801815:	e8 51 0a 00 00       	call   80226b <_panic>

0080181a <devfile_read>:
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
  80181f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	8b 40 0c             	mov    0xc(%eax),%eax
  801828:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80182d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	b8 03 00 00 00       	mov    $0x3,%eax
  80183d:	e8 65 fe ff ff       	call   8016a7 <fsipc>
  801842:	89 c3                	mov    %eax,%ebx
  801844:	85 c0                	test   %eax,%eax
  801846:	78 1f                	js     801867 <devfile_read+0x4d>
	assert(r <= n);
  801848:	39 f0                	cmp    %esi,%eax
  80184a:	77 24                	ja     801870 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80184c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801851:	7f 33                	jg     801886 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	50                   	push   %eax
  801857:	68 00 60 80 00       	push   $0x806000
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	e8 78 f3 ff ff       	call   800bdc <memmove>
	return r;
  801864:	83 c4 10             	add    $0x10,%esp
}
  801867:	89 d8                	mov    %ebx,%eax
  801869:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
	assert(r <= n);
  801870:	68 44 2b 80 00       	push   $0x802b44
  801875:	68 4b 2b 80 00       	push   $0x802b4b
  80187a:	6a 7c                	push   $0x7c
  80187c:	68 60 2b 80 00       	push   $0x802b60
  801881:	e8 e5 09 00 00       	call   80226b <_panic>
	assert(r <= PGSIZE);
  801886:	68 6b 2b 80 00       	push   $0x802b6b
  80188b:	68 4b 2b 80 00       	push   $0x802b4b
  801890:	6a 7d                	push   $0x7d
  801892:	68 60 2b 80 00       	push   $0x802b60
  801897:	e8 cf 09 00 00       	call   80226b <_panic>

0080189c <open>:
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	56                   	push   %esi
  8018a0:	53                   	push   %ebx
  8018a1:	83 ec 1c             	sub    $0x1c,%esp
  8018a4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018a7:	56                   	push   %esi
  8018a8:	e8 68 f1 ff ff       	call   800a15 <strlen>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018b5:	7f 6c                	jg     801923 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	e8 79 f8 ff ff       	call   80113c <fd_alloc>
  8018c3:	89 c3                	mov    %eax,%ebx
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	78 3c                	js     801908 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018cc:	83 ec 08             	sub    $0x8,%esp
  8018cf:	56                   	push   %esi
  8018d0:	68 00 60 80 00       	push   $0x806000
  8018d5:	e8 74 f1 ff ff       	call   800a4e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ea:	e8 b8 fd ff ff       	call   8016a7 <fsipc>
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 19                	js     801911 <open+0x75>
	return fd2num(fd);
  8018f8:	83 ec 0c             	sub    $0xc,%esp
  8018fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fe:	e8 12 f8 ff ff       	call   801115 <fd2num>
  801903:	89 c3                	mov    %eax,%ebx
  801905:	83 c4 10             	add    $0x10,%esp
}
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190d:	5b                   	pop    %ebx
  80190e:	5e                   	pop    %esi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    
		fd_close(fd, 0);
  801911:	83 ec 08             	sub    $0x8,%esp
  801914:	6a 00                	push   $0x0
  801916:	ff 75 f4             	pushl  -0xc(%ebp)
  801919:	e8 1b f9 ff ff       	call   801239 <fd_close>
		return r;
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	eb e5                	jmp    801908 <open+0x6c>
		return -E_BAD_PATH;
  801923:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801928:	eb de                	jmp    801908 <open+0x6c>

0080192a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	b8 08 00 00 00       	mov    $0x8,%eax
  80193a:	e8 68 fd ff ff       	call   8016a7 <fsipc>
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801947:	68 77 2b 80 00       	push   $0x802b77
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	e8 fa f0 ff ff       	call   800a4e <strcpy>
	return 0;
}
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <devsock_close>:
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	53                   	push   %ebx
  80195f:	83 ec 10             	sub    $0x10,%esp
  801962:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801965:	53                   	push   %ebx
  801966:	e8 5d 0a 00 00       	call   8023c8 <pageref>
  80196b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801973:	83 f8 01             	cmp    $0x1,%eax
  801976:	74 07                	je     80197f <devsock_close+0x24>
}
  801978:	89 d0                	mov    %edx,%eax
  80197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80197f:	83 ec 0c             	sub    $0xc,%esp
  801982:	ff 73 0c             	pushl  0xc(%ebx)
  801985:	e8 b9 02 00 00       	call   801c43 <nsipc_close>
  80198a:	89 c2                	mov    %eax,%edx
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	eb e7                	jmp    801978 <devsock_close+0x1d>

00801991 <devsock_write>:
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801997:	6a 00                	push   $0x0
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	ff 70 0c             	pushl  0xc(%eax)
  8019a5:	e8 76 03 00 00       	call   801d20 <nsipc_send>
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <devsock_read>:
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	ff 75 10             	pushl  0x10(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	ff 70 0c             	pushl  0xc(%eax)
  8019c0:	e8 ef 02 00 00       	call   801cb4 <nsipc_recv>
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <fd2sockid>:
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019cd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	e8 b7 f7 ff ff       	call   80118e <fd_lookup>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 10                	js     8019ee <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019e7:	39 08                	cmp    %ecx,(%eax)
  8019e9:	75 05                	jne    8019f0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019eb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    
		return -E_NOT_SUPP;
  8019f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f5:	eb f7                	jmp    8019ee <fd2sockid+0x27>

008019f7 <alloc_sockfd>:
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 1c             	sub    $0x1c,%esp
  8019ff:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a04:	50                   	push   %eax
  801a05:	e8 32 f7 ff ff       	call   80113c <fd_alloc>
  801a0a:	89 c3                	mov    %eax,%ebx
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 43                	js     801a56 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	68 07 04 00 00       	push   $0x407
  801a1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1e:	6a 00                	push   $0x0
  801a20:	e8 1b f4 ff ff       	call   800e40 <sys_page_alloc>
  801a25:	89 c3                	mov    %eax,%ebx
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 28                	js     801a56 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a31:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a37:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a43:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	50                   	push   %eax
  801a4a:	e8 c6 f6 ff ff       	call   801115 <fd2num>
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	eb 0c                	jmp    801a62 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	56                   	push   %esi
  801a5a:	e8 e4 01 00 00       	call   801c43 <nsipc_close>
		return r;
  801a5f:	83 c4 10             	add    $0x10,%esp
}
  801a62:	89 d8                	mov    %ebx,%eax
  801a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <accept>:
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	e8 4e ff ff ff       	call   8019c7 <fd2sockid>
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 1b                	js     801a98 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	e8 0e 01 00 00       	call   801b9a <nsipc_accept>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 05                	js     801a98 <accept+0x2d>
	return alloc_sockfd(r);
  801a93:	e8 5f ff ff ff       	call   8019f7 <alloc_sockfd>
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <bind>:
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	e8 1f ff ff ff       	call   8019c7 <fd2sockid>
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 12                	js     801abe <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	50                   	push   %eax
  801ab6:	e8 31 01 00 00       	call   801bec <nsipc_bind>
  801abb:	83 c4 10             	add    $0x10,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <shutdown>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	e8 f9 fe ff ff       	call   8019c7 <fd2sockid>
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 0f                	js     801ae1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	e8 43 01 00 00       	call   801c21 <nsipc_shutdown>
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <connect>:
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	e8 d6 fe ff ff       	call   8019c7 <fd2sockid>
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 12                	js     801b07 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	ff 75 10             	pushl  0x10(%ebp)
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	e8 59 01 00 00       	call   801c5d <nsipc_connect>
  801b04:	83 c4 10             	add    $0x10,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <listen>:
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	e8 b0 fe ff ff       	call   8019c7 <fd2sockid>
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 0f                	js     801b2a <listen+0x21>
	return nsipc_listen(r, backlog);
  801b1b:	83 ec 08             	sub    $0x8,%esp
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	50                   	push   %eax
  801b22:	e8 6b 01 00 00       	call   801c92 <nsipc_listen>
  801b27:	83 c4 10             	add    $0x10,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <socket>:

int
socket(int domain, int type, int protocol)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b32:	ff 75 10             	pushl  0x10(%ebp)
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	ff 75 08             	pushl  0x8(%ebp)
  801b3b:	e8 3e 02 00 00       	call   801d7e <nsipc_socket>
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 05                	js     801b4c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b47:	e8 ab fe ff ff       	call   8019f7 <alloc_sockfd>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	53                   	push   %ebx
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b57:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b5e:	74 26                	je     801b86 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b60:	6a 07                	push   $0x7
  801b62:	68 00 70 80 00       	push   $0x807000
  801b67:	53                   	push   %ebx
  801b68:	ff 35 04 40 80 00    	pushl  0x804004
  801b6e:	e8 c2 07 00 00       	call   802335 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b73:	83 c4 0c             	add    $0xc,%esp
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	e8 4b 07 00 00       	call   8022cc <ipc_recv>
}
  801b81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b86:	83 ec 0c             	sub    $0xc,%esp
  801b89:	6a 02                	push   $0x2
  801b8b:	e8 fd 07 00 00       	call   80238d <ipc_find_env>
  801b90:	a3 04 40 80 00       	mov    %eax,0x804004
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	eb c6                	jmp    801b60 <nsipc+0x12>

00801b9a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	56                   	push   %esi
  801b9e:	53                   	push   %ebx
  801b9f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801baa:	8b 06                	mov    (%esi),%eax
  801bac:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	e8 93 ff ff ff       	call   801b4e <nsipc>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	79 09                	jns    801bca <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bc1:	89 d8                	mov    %ebx,%eax
  801bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	ff 35 10 70 80 00    	pushl  0x807010
  801bd3:	68 00 70 80 00       	push   $0x807000
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	e8 fc ef ff ff       	call   800bdc <memmove>
		*addrlen = ret->ret_addrlen;
  801be0:	a1 10 70 80 00       	mov    0x807010,%eax
  801be5:	89 06                	mov    %eax,(%esi)
  801be7:	83 c4 10             	add    $0x10,%esp
	return r;
  801bea:	eb d5                	jmp    801bc1 <nsipc_accept+0x27>

00801bec <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 08             	sub    $0x8,%esp
  801bf3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bfe:	53                   	push   %ebx
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	68 04 70 80 00       	push   $0x807004
  801c07:	e8 d0 ef ff ff       	call   800bdc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c0c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801c12:	b8 02 00 00 00       	mov    $0x2,%eax
  801c17:	e8 32 ff ff ff       	call   801b4e <nsipc>
}
  801c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c32:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801c37:	b8 03 00 00 00       	mov    $0x3,%eax
  801c3c:	e8 0d ff ff ff       	call   801b4e <nsipc>
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <nsipc_close>:

int
nsipc_close(int s)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801c51:	b8 04 00 00 00       	mov    $0x4,%eax
  801c56:	e8 f3 fe ff ff       	call   801b4e <nsipc>
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	53                   	push   %ebx
  801c61:	83 ec 08             	sub    $0x8,%esp
  801c64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c6f:	53                   	push   %ebx
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	68 04 70 80 00       	push   $0x807004
  801c78:	e8 5f ef ff ff       	call   800bdc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c7d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801c83:	b8 05 00 00 00       	mov    $0x5,%eax
  801c88:	e8 c1 fe ff ff       	call   801b4e <nsipc>
}
  801c8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801ca8:	b8 06 00 00 00       	mov    $0x6,%eax
  801cad:	e8 9c fe ff ff       	call   801b4e <nsipc>
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	56                   	push   %esi
  801cb8:	53                   	push   %ebx
  801cb9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801cc4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cd2:	b8 07 00 00 00       	mov    $0x7,%eax
  801cd7:	e8 72 fe ff ff       	call   801b4e <nsipc>
  801cdc:	89 c3                	mov    %eax,%ebx
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 1f                	js     801d01 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ce2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ce7:	7f 21                	jg     801d0a <nsipc_recv+0x56>
  801ce9:	39 c6                	cmp    %eax,%esi
  801ceb:	7c 1d                	jl     801d0a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	50                   	push   %eax
  801cf1:	68 00 70 80 00       	push   $0x807000
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	e8 de ee ff ff       	call   800bdc <memmove>
  801cfe:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d01:	89 d8                	mov    %ebx,%eax
  801d03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d0a:	68 83 2b 80 00       	push   $0x802b83
  801d0f:	68 4b 2b 80 00       	push   $0x802b4b
  801d14:	6a 62                	push   $0x62
  801d16:	68 98 2b 80 00       	push   $0x802b98
  801d1b:	e8 4b 05 00 00       	call   80226b <_panic>

00801d20 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	53                   	push   %ebx
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801d32:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d38:	7f 2e                	jg     801d68 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	53                   	push   %ebx
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	68 0c 70 80 00       	push   $0x80700c
  801d46:	e8 91 ee ff ff       	call   800bdc <memmove>
	nsipcbuf.send.req_size = size;
  801d4b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801d51:	8b 45 14             	mov    0x14(%ebp),%eax
  801d54:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801d59:	b8 08 00 00 00       	mov    $0x8,%eax
  801d5e:	e8 eb fd ff ff       	call   801b4e <nsipc>
}
  801d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    
	assert(size < 1600);
  801d68:	68 a4 2b 80 00       	push   $0x802ba4
  801d6d:	68 4b 2b 80 00       	push   $0x802b4b
  801d72:	6a 6d                	push   $0x6d
  801d74:	68 98 2b 80 00       	push   $0x802b98
  801d79:	e8 ed 04 00 00       	call   80226b <_panic>

00801d7e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801d94:	8b 45 10             	mov    0x10(%ebp),%eax
  801d97:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801d9c:	b8 09 00 00 00       	mov    $0x9,%eax
  801da1:	e8 a8 fd ff ff       	call   801b4e <nsipc>
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801db0:	83 ec 0c             	sub    $0xc,%esp
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	e8 6a f3 ff ff       	call   801125 <fd2data>
  801dbb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dbd:	83 c4 08             	add    $0x8,%esp
  801dc0:	68 b0 2b 80 00       	push   $0x802bb0
  801dc5:	53                   	push   %ebx
  801dc6:	e8 83 ec ff ff       	call   800a4e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dcb:	8b 46 04             	mov    0x4(%esi),%eax
  801dce:	2b 06                	sub    (%esi),%eax
  801dd0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dd6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ddd:	00 00 00 
	stat->st_dev = &devpipe;
  801de0:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801de7:	30 80 00 
	return 0;
}
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5e                   	pop    %esi
  801df4:	5d                   	pop    %ebp
  801df5:	c3                   	ret    

00801df6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	53                   	push   %ebx
  801dfa:	83 ec 0c             	sub    $0xc,%esp
  801dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e00:	53                   	push   %ebx
  801e01:	6a 00                	push   $0x0
  801e03:	e8 bd f0 ff ff       	call   800ec5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e08:	89 1c 24             	mov    %ebx,(%esp)
  801e0b:	e8 15 f3 ff ff       	call   801125 <fd2data>
  801e10:	83 c4 08             	add    $0x8,%esp
  801e13:	50                   	push   %eax
  801e14:	6a 00                	push   $0x0
  801e16:	e8 aa f0 ff ff       	call   800ec5 <sys_page_unmap>
}
  801e1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <_pipeisclosed>:
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	57                   	push   %edi
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
  801e26:	83 ec 1c             	sub    $0x1c,%esp
  801e29:	89 c7                	mov    %eax,%edi
  801e2b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e2d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e32:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	57                   	push   %edi
  801e39:	e8 8a 05 00 00       	call   8023c8 <pageref>
  801e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e41:	89 34 24             	mov    %esi,(%esp)
  801e44:	e8 7f 05 00 00       	call   8023c8 <pageref>
		nn = thisenv->env_runs;
  801e49:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  801e4f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	39 cb                	cmp    %ecx,%ebx
  801e57:	74 1b                	je     801e74 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e5c:	75 cf                	jne    801e2d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e5e:	8b 42 58             	mov    0x58(%edx),%eax
  801e61:	6a 01                	push   $0x1
  801e63:	50                   	push   %eax
  801e64:	53                   	push   %ebx
  801e65:	68 b7 2b 80 00       	push   $0x802bb7
  801e6a:	e8 80 e4 ff ff       	call   8002ef <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	eb b9                	jmp    801e2d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e74:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e77:	0f 94 c0             	sete   %al
  801e7a:	0f b6 c0             	movzbl %al,%eax
}
  801e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    

00801e85 <devpipe_write>:
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	57                   	push   %edi
  801e89:	56                   	push   %esi
  801e8a:	53                   	push   %ebx
  801e8b:	83 ec 28             	sub    $0x28,%esp
  801e8e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e91:	56                   	push   %esi
  801e92:	e8 8e f2 ff ff       	call   801125 <fd2data>
  801e97:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ea4:	74 4f                	je     801ef5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea6:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea9:	8b 0b                	mov    (%ebx),%ecx
  801eab:	8d 51 20             	lea    0x20(%ecx),%edx
  801eae:	39 d0                	cmp    %edx,%eax
  801eb0:	72 14                	jb     801ec6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801eb2:	89 da                	mov    %ebx,%edx
  801eb4:	89 f0                	mov    %esi,%eax
  801eb6:	e8 65 ff ff ff       	call   801e20 <_pipeisclosed>
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	75 3b                	jne    801efa <devpipe_write+0x75>
			sys_yield();
  801ebf:	e8 5d ef ff ff       	call   800e21 <sys_yield>
  801ec4:	eb e0                	jmp    801ea6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ecd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ed0:	89 c2                	mov    %eax,%edx
  801ed2:	c1 fa 1f             	sar    $0x1f,%edx
  801ed5:	89 d1                	mov    %edx,%ecx
  801ed7:	c1 e9 1b             	shr    $0x1b,%ecx
  801eda:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801edd:	83 e2 1f             	and    $0x1f,%edx
  801ee0:	29 ca                	sub    %ecx,%edx
  801ee2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ee6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801eea:	83 c0 01             	add    $0x1,%eax
  801eed:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ef0:	83 c7 01             	add    $0x1,%edi
  801ef3:	eb ac                	jmp    801ea1 <devpipe_write+0x1c>
	return i;
  801ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef8:	eb 05                	jmp    801eff <devpipe_write+0x7a>
				return 0;
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f02:	5b                   	pop    %ebx
  801f03:	5e                   	pop    %esi
  801f04:	5f                   	pop    %edi
  801f05:	5d                   	pop    %ebp
  801f06:	c3                   	ret    

00801f07 <devpipe_read>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	57                   	push   %edi
  801f0b:	56                   	push   %esi
  801f0c:	53                   	push   %ebx
  801f0d:	83 ec 18             	sub    $0x18,%esp
  801f10:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f13:	57                   	push   %edi
  801f14:	e8 0c f2 ff ff       	call   801125 <fd2data>
  801f19:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	be 00 00 00 00       	mov    $0x0,%esi
  801f23:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f26:	75 14                	jne    801f3c <devpipe_read+0x35>
	return i;
  801f28:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2b:	eb 02                	jmp    801f2f <devpipe_read+0x28>
				return i;
  801f2d:	89 f0                	mov    %esi,%eax
}
  801f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f32:	5b                   	pop    %ebx
  801f33:	5e                   	pop    %esi
  801f34:	5f                   	pop    %edi
  801f35:	5d                   	pop    %ebp
  801f36:	c3                   	ret    
			sys_yield();
  801f37:	e8 e5 ee ff ff       	call   800e21 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f3c:	8b 03                	mov    (%ebx),%eax
  801f3e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f41:	75 18                	jne    801f5b <devpipe_read+0x54>
			if (i > 0)
  801f43:	85 f6                	test   %esi,%esi
  801f45:	75 e6                	jne    801f2d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f47:	89 da                	mov    %ebx,%edx
  801f49:	89 f8                	mov    %edi,%eax
  801f4b:	e8 d0 fe ff ff       	call   801e20 <_pipeisclosed>
  801f50:	85 c0                	test   %eax,%eax
  801f52:	74 e3                	je     801f37 <devpipe_read+0x30>
				return 0;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	eb d4                	jmp    801f2f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f5b:	99                   	cltd   
  801f5c:	c1 ea 1b             	shr    $0x1b,%edx
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	83 e0 1f             	and    $0x1f,%eax
  801f64:	29 d0                	sub    %edx,%eax
  801f66:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f6e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f71:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f74:	83 c6 01             	add    $0x1,%esi
  801f77:	eb aa                	jmp    801f23 <devpipe_read+0x1c>

00801f79 <pipe>:
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f84:	50                   	push   %eax
  801f85:	e8 b2 f1 ff ff       	call   80113c <fd_alloc>
  801f8a:	89 c3                	mov    %eax,%ebx
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	0f 88 23 01 00 00    	js     8020ba <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f97:	83 ec 04             	sub    $0x4,%esp
  801f9a:	68 07 04 00 00       	push   $0x407
  801f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa2:	6a 00                	push   $0x0
  801fa4:	e8 97 ee ff ff       	call   800e40 <sys_page_alloc>
  801fa9:	89 c3                	mov    %eax,%ebx
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	0f 88 04 01 00 00    	js     8020ba <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fbc:	50                   	push   %eax
  801fbd:	e8 7a f1 ff ff       	call   80113c <fd_alloc>
  801fc2:	89 c3                	mov    %eax,%ebx
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	0f 88 db 00 00 00    	js     8020aa <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 07 04 00 00       	push   $0x407
  801fd7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fda:	6a 00                	push   $0x0
  801fdc:	e8 5f ee ff ff       	call   800e40 <sys_page_alloc>
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	0f 88 bc 00 00 00    	js     8020aa <pipe+0x131>
	va = fd2data(fd0);
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff4:	e8 2c f1 ff ff       	call   801125 <fd2data>
  801ff9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffb:	83 c4 0c             	add    $0xc,%esp
  801ffe:	68 07 04 00 00       	push   $0x407
  802003:	50                   	push   %eax
  802004:	6a 00                	push   $0x0
  802006:	e8 35 ee ff ff       	call   800e40 <sys_page_alloc>
  80200b:	89 c3                	mov    %eax,%ebx
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	85 c0                	test   %eax,%eax
  802012:	0f 88 82 00 00 00    	js     80209a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	ff 75 f0             	pushl  -0x10(%ebp)
  80201e:	e8 02 f1 ff ff       	call   801125 <fd2data>
  802023:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80202a:	50                   	push   %eax
  80202b:	6a 00                	push   $0x0
  80202d:	56                   	push   %esi
  80202e:	6a 00                	push   $0x0
  802030:	e8 4e ee ff ff       	call   800e83 <sys_page_map>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	83 c4 20             	add    $0x20,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 4e                	js     80208c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80203e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802055:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	ff 75 f4             	pushl  -0xc(%ebp)
  802067:	e8 a9 f0 ff ff       	call   801115 <fd2num>
  80206c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802071:	83 c4 04             	add    $0x4,%esp
  802074:	ff 75 f0             	pushl  -0x10(%ebp)
  802077:	e8 99 f0 ff ff       	call   801115 <fd2num>
  80207c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	bb 00 00 00 00       	mov    $0x0,%ebx
  80208a:	eb 2e                	jmp    8020ba <pipe+0x141>
	sys_page_unmap(0, va);
  80208c:	83 ec 08             	sub    $0x8,%esp
  80208f:	56                   	push   %esi
  802090:	6a 00                	push   $0x0
  802092:	e8 2e ee ff ff       	call   800ec5 <sys_page_unmap>
  802097:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80209a:	83 ec 08             	sub    $0x8,%esp
  80209d:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 1e ee ff ff       	call   800ec5 <sys_page_unmap>
  8020a7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020aa:	83 ec 08             	sub    $0x8,%esp
  8020ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 0e ee ff ff       	call   800ec5 <sys_page_unmap>
  8020b7:	83 c4 10             	add    $0x10,%esp
}
  8020ba:	89 d8                	mov    %ebx,%eax
  8020bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <pipeisclosed>:
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cc:	50                   	push   %eax
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	e8 b9 f0 ff ff       	call   80118e <fd_lookup>
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 18                	js     8020f4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	e8 3e f0 ff ff       	call   801125 <fd2data>
	return _pipeisclosed(fd, p);
  8020e7:	89 c2                	mov    %eax,%edx
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	e8 2f fd ff ff       	call   801e20 <_pipeisclosed>
  8020f1:	83 c4 10             	add    $0x10,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fb:	c3                   	ret    

008020fc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802102:	68 cf 2b 80 00       	push   $0x802bcf
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	e8 3f e9 ff ff       	call   800a4e <strcpy>
	return 0;
}
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <devcons_write>:
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	57                   	push   %edi
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
  80211c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802122:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802127:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80212d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802130:	73 31                	jae    802163 <devcons_write+0x4d>
		m = n - tot;
  802132:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802135:	29 f3                	sub    %esi,%ebx
  802137:	83 fb 7f             	cmp    $0x7f,%ebx
  80213a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80213f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	53                   	push   %ebx
  802146:	89 f0                	mov    %esi,%eax
  802148:	03 45 0c             	add    0xc(%ebp),%eax
  80214b:	50                   	push   %eax
  80214c:	57                   	push   %edi
  80214d:	e8 8a ea ff ff       	call   800bdc <memmove>
		sys_cputs(buf, m);
  802152:	83 c4 08             	add    $0x8,%esp
  802155:	53                   	push   %ebx
  802156:	57                   	push   %edi
  802157:	e8 28 ec ff ff       	call   800d84 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80215c:	01 de                	add    %ebx,%esi
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	eb ca                	jmp    80212d <devcons_write+0x17>
}
  802163:	89 f0                	mov    %esi,%eax
  802165:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802168:	5b                   	pop    %ebx
  802169:	5e                   	pop    %esi
  80216a:	5f                   	pop    %edi
  80216b:	5d                   	pop    %ebp
  80216c:	c3                   	ret    

0080216d <devcons_read>:
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 08             	sub    $0x8,%esp
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802178:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217c:	74 21                	je     80219f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80217e:	e8 1f ec ff ff       	call   800da2 <sys_cgetc>
  802183:	85 c0                	test   %eax,%eax
  802185:	75 07                	jne    80218e <devcons_read+0x21>
		sys_yield();
  802187:	e8 95 ec ff ff       	call   800e21 <sys_yield>
  80218c:	eb f0                	jmp    80217e <devcons_read+0x11>
	if (c < 0)
  80218e:	78 0f                	js     80219f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802190:	83 f8 04             	cmp    $0x4,%eax
  802193:	74 0c                	je     8021a1 <devcons_read+0x34>
	*(char*)vbuf = c;
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	88 02                	mov    %al,(%edx)
	return 1;
  80219a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    
		return 0;
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a6:	eb f7                	jmp    80219f <devcons_read+0x32>

008021a8 <cputchar>:
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021b4:	6a 01                	push   $0x1
  8021b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b9:	50                   	push   %eax
  8021ba:	e8 c5 eb ff ff       	call   800d84 <sys_cputs>
}
  8021bf:	83 c4 10             	add    $0x10,%esp
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <getchar>:
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ca:	6a 01                	push   $0x1
  8021cc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021cf:	50                   	push   %eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	e8 27 f2 ff ff       	call   8013fe <read>
	if (r < 0)
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 06                	js     8021e4 <getchar+0x20>
	if (r < 1)
  8021de:	74 06                	je     8021e6 <getchar+0x22>
	return c;
  8021e0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    
		return -E_EOF;
  8021e6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021eb:	eb f7                	jmp    8021e4 <getchar+0x20>

008021ed <iscons>:
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f6:	50                   	push   %eax
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	e8 8f ef ff ff       	call   80118e <fd_lookup>
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	85 c0                	test   %eax,%eax
  802204:	78 11                	js     802217 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80220f:	39 10                	cmp    %edx,(%eax)
  802211:	0f 94 c0             	sete   %al
  802214:	0f b6 c0             	movzbl %al,%eax
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <opencons>:
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80221f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802222:	50                   	push   %eax
  802223:	e8 14 ef ff ff       	call   80113c <fd_alloc>
  802228:	83 c4 10             	add    $0x10,%esp
  80222b:	85 c0                	test   %eax,%eax
  80222d:	78 3a                	js     802269 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	68 07 04 00 00       	push   $0x407
  802237:	ff 75 f4             	pushl  -0xc(%ebp)
  80223a:	6a 00                	push   $0x0
  80223c:	e8 ff eb ff ff       	call   800e40 <sys_page_alloc>
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	85 c0                	test   %eax,%eax
  802246:	78 21                	js     802269 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802251:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80225d:	83 ec 0c             	sub    $0xc,%esp
  802260:	50                   	push   %eax
  802261:	e8 af ee ff ff       	call   801115 <fd2num>
  802266:	83 c4 10             	add    $0x10,%esp
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802270:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802275:	8b 40 48             	mov    0x48(%eax),%eax
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	68 00 2c 80 00       	push   $0x802c00
  802280:	50                   	push   %eax
  802281:	68 e4 26 80 00       	push   $0x8026e4
  802286:	e8 64 e0 ff ff       	call   8002ef <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80228b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80228e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802294:	e8 69 eb ff ff       	call   800e02 <sys_getenvid>
  802299:	83 c4 04             	add    $0x4,%esp
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	ff 75 08             	pushl  0x8(%ebp)
  8022a2:	56                   	push   %esi
  8022a3:	50                   	push   %eax
  8022a4:	68 dc 2b 80 00       	push   $0x802bdc
  8022a9:	e8 41 e0 ff ff       	call   8002ef <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022ae:	83 c4 18             	add    $0x18,%esp
  8022b1:	53                   	push   %ebx
  8022b2:	ff 75 10             	pushl  0x10(%ebp)
  8022b5:	e8 e4 df ff ff       	call   80029e <vcprintf>
	cprintf("\n");
  8022ba:	c7 04 24 a8 26 80 00 	movl   $0x8026a8,(%esp)
  8022c1:	e8 29 e0 ff ff       	call   8002ef <cprintf>
  8022c6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022c9:	cc                   	int3   
  8022ca:	eb fd                	jmp    8022c9 <_panic+0x5e>

008022cc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	56                   	push   %esi
  8022d0:	53                   	push   %ebx
  8022d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8022d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022da:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022dc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022e1:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022e4:	83 ec 0c             	sub    $0xc,%esp
  8022e7:	50                   	push   %eax
  8022e8:	e8 03 ed ff ff       	call   800ff0 <sys_ipc_recv>
	if(ret < 0){
  8022ed:	83 c4 10             	add    $0x10,%esp
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	78 2b                	js     80231f <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022f4:	85 f6                	test   %esi,%esi
  8022f6:	74 0a                	je     802302 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022fd:	8b 40 74             	mov    0x74(%eax),%eax
  802300:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802302:	85 db                	test   %ebx,%ebx
  802304:	74 0a                	je     802310 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802306:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80230b:	8b 40 78             	mov    0x78(%eax),%eax
  80230e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802310:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802315:	8b 40 70             	mov    0x70(%eax),%eax
}
  802318:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5e                   	pop    %esi
  80231d:	5d                   	pop    %ebp
  80231e:	c3                   	ret    
		if(from_env_store)
  80231f:	85 f6                	test   %esi,%esi
  802321:	74 06                	je     802329 <ipc_recv+0x5d>
			*from_env_store = 0;
  802323:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802329:	85 db                	test   %ebx,%ebx
  80232b:	74 eb                	je     802318 <ipc_recv+0x4c>
			*perm_store = 0;
  80232d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802333:	eb e3                	jmp    802318 <ipc_recv+0x4c>

00802335 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	57                   	push   %edi
  802339:	56                   	push   %esi
  80233a:	53                   	push   %ebx
  80233b:	83 ec 0c             	sub    $0xc,%esp
  80233e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802341:	8b 75 0c             	mov    0xc(%ebp),%esi
  802344:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802347:	85 db                	test   %ebx,%ebx
  802349:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80234e:	0f 44 d8             	cmove  %eax,%ebx
  802351:	eb 05                	jmp    802358 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802353:	e8 c9 ea ff ff       	call   800e21 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802358:	ff 75 14             	pushl  0x14(%ebp)
  80235b:	53                   	push   %ebx
  80235c:	56                   	push   %esi
  80235d:	57                   	push   %edi
  80235e:	e8 6a ec ff ff       	call   800fcd <sys_ipc_try_send>
  802363:	83 c4 10             	add    $0x10,%esp
  802366:	85 c0                	test   %eax,%eax
  802368:	74 1b                	je     802385 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80236a:	79 e7                	jns    802353 <ipc_send+0x1e>
  80236c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80236f:	74 e2                	je     802353 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 07 2c 80 00       	push   $0x802c07
  802379:	6a 46                	push   $0x46
  80237b:	68 1c 2c 80 00       	push   $0x802c1c
  802380:	e8 e6 fe ff ff       	call   80226b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802385:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802388:	5b                   	pop    %ebx
  802389:	5e                   	pop    %esi
  80238a:	5f                   	pop    %edi
  80238b:	5d                   	pop    %ebp
  80238c:	c3                   	ret    

0080238d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802398:	89 c2                	mov    %eax,%edx
  80239a:	c1 e2 07             	shl    $0x7,%edx
  80239d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023a3:	8b 52 50             	mov    0x50(%edx),%edx
  8023a6:	39 ca                	cmp    %ecx,%edx
  8023a8:	74 11                	je     8023bb <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023aa:	83 c0 01             	add    $0x1,%eax
  8023ad:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023b2:	75 e4                	jne    802398 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b9:	eb 0b                	jmp    8023c6 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023bb:	c1 e0 07             	shl    $0x7,%eax
  8023be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023c3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    

008023c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ce:	89 d0                	mov    %edx,%eax
  8023d0:	c1 e8 16             	shr    $0x16,%eax
  8023d3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023df:	f6 c1 01             	test   $0x1,%cl
  8023e2:	74 1d                	je     802401 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023e4:	c1 ea 0c             	shr    $0xc,%edx
  8023e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023ee:	f6 c2 01             	test   $0x1,%dl
  8023f1:	74 0e                	je     802401 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023f3:	c1 ea 0c             	shr    $0xc,%edx
  8023f6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023fd:	ef 
  8023fe:	0f b7 c0             	movzwl %ax,%eax
}
  802401:	5d                   	pop    %ebp
  802402:	c3                   	ret    
  802403:	66 90                	xchg   %ax,%ax
  802405:	66 90                	xchg   %ax,%ax
  802407:	66 90                	xchg   %ax,%ax
  802409:	66 90                	xchg   %ax,%ax
  80240b:	66 90                	xchg   %ax,%ax
  80240d:	66 90                	xchg   %ax,%ax
  80240f:	90                   	nop

00802410 <__udivdi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80241b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80241f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802423:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802427:	85 d2                	test   %edx,%edx
  802429:	75 4d                	jne    802478 <__udivdi3+0x68>
  80242b:	39 f3                	cmp    %esi,%ebx
  80242d:	76 19                	jbe    802448 <__udivdi3+0x38>
  80242f:	31 ff                	xor    %edi,%edi
  802431:	89 e8                	mov    %ebp,%eax
  802433:	89 f2                	mov    %esi,%edx
  802435:	f7 f3                	div    %ebx
  802437:	89 fa                	mov    %edi,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 d9                	mov    %ebx,%ecx
  80244a:	85 db                	test   %ebx,%ebx
  80244c:	75 0b                	jne    802459 <__udivdi3+0x49>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f3                	div    %ebx
  802457:	89 c1                	mov    %eax,%ecx
  802459:	31 d2                	xor    %edx,%edx
  80245b:	89 f0                	mov    %esi,%eax
  80245d:	f7 f1                	div    %ecx
  80245f:	89 c6                	mov    %eax,%esi
  802461:	89 e8                	mov    %ebp,%eax
  802463:	89 f7                	mov    %esi,%edi
  802465:	f7 f1                	div    %ecx
  802467:	89 fa                	mov    %edi,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	39 f2                	cmp    %esi,%edx
  80247a:	77 1c                	ja     802498 <__udivdi3+0x88>
  80247c:	0f bd fa             	bsr    %edx,%edi
  80247f:	83 f7 1f             	xor    $0x1f,%edi
  802482:	75 2c                	jne    8024b0 <__udivdi3+0xa0>
  802484:	39 f2                	cmp    %esi,%edx
  802486:	72 06                	jb     80248e <__udivdi3+0x7e>
  802488:	31 c0                	xor    %eax,%eax
  80248a:	39 eb                	cmp    %ebp,%ebx
  80248c:	77 a9                	ja     802437 <__udivdi3+0x27>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	eb a2                	jmp    802437 <__udivdi3+0x27>
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	31 ff                	xor    %edi,%edi
  80249a:	31 c0                	xor    %eax,%eax
  80249c:	89 fa                	mov    %edi,%edx
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ad:	8d 76 00             	lea    0x0(%esi),%esi
  8024b0:	89 f9                	mov    %edi,%ecx
  8024b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024b7:	29 f8                	sub    %edi,%eax
  8024b9:	d3 e2                	shl    %cl,%edx
  8024bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024bf:	89 c1                	mov    %eax,%ecx
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	d3 ea                	shr    %cl,%edx
  8024c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c9:	09 d1                	or     %edx,%ecx
  8024cb:	89 f2                	mov    %esi,%edx
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 f9                	mov    %edi,%ecx
  8024d3:	d3 e3                	shl    %cl,%ebx
  8024d5:	89 c1                	mov    %eax,%ecx
  8024d7:	d3 ea                	shr    %cl,%edx
  8024d9:	89 f9                	mov    %edi,%ecx
  8024db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024df:	89 eb                	mov    %ebp,%ebx
  8024e1:	d3 e6                	shl    %cl,%esi
  8024e3:	89 c1                	mov    %eax,%ecx
  8024e5:	d3 eb                	shr    %cl,%ebx
  8024e7:	09 de                	or     %ebx,%esi
  8024e9:	89 f0                	mov    %esi,%eax
  8024eb:	f7 74 24 08          	divl   0x8(%esp)
  8024ef:	89 d6                	mov    %edx,%esi
  8024f1:	89 c3                	mov    %eax,%ebx
  8024f3:	f7 64 24 0c          	mull   0xc(%esp)
  8024f7:	39 d6                	cmp    %edx,%esi
  8024f9:	72 15                	jb     802510 <__udivdi3+0x100>
  8024fb:	89 f9                	mov    %edi,%ecx
  8024fd:	d3 e5                	shl    %cl,%ebp
  8024ff:	39 c5                	cmp    %eax,%ebp
  802501:	73 04                	jae    802507 <__udivdi3+0xf7>
  802503:	39 d6                	cmp    %edx,%esi
  802505:	74 09                	je     802510 <__udivdi3+0x100>
  802507:	89 d8                	mov    %ebx,%eax
  802509:	31 ff                	xor    %edi,%edi
  80250b:	e9 27 ff ff ff       	jmp    802437 <__udivdi3+0x27>
  802510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802513:	31 ff                	xor    %edi,%edi
  802515:	e9 1d ff ff ff       	jmp    802437 <__udivdi3+0x27>
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__umoddi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80252b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80252f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802537:	89 da                	mov    %ebx,%edx
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 43                	jne    802580 <__umoddi3+0x60>
  80253d:	39 df                	cmp    %ebx,%edi
  80253f:	76 17                	jbe    802558 <__umoddi3+0x38>
  802541:	89 f0                	mov    %esi,%eax
  802543:	f7 f7                	div    %edi
  802545:	89 d0                	mov    %edx,%eax
  802547:	31 d2                	xor    %edx,%edx
  802549:	83 c4 1c             	add    $0x1c,%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5f                   	pop    %edi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 fd                	mov    %edi,%ebp
  80255a:	85 ff                	test   %edi,%edi
  80255c:	75 0b                	jne    802569 <__umoddi3+0x49>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f7                	div    %edi
  802567:	89 c5                	mov    %eax,%ebp
  802569:	89 d8                	mov    %ebx,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	f7 f5                	div    %ebp
  80256f:	89 f0                	mov    %esi,%eax
  802571:	f7 f5                	div    %ebp
  802573:	89 d0                	mov    %edx,%eax
  802575:	eb d0                	jmp    802547 <__umoddi3+0x27>
  802577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257e:	66 90                	xchg   %ax,%ax
  802580:	89 f1                	mov    %esi,%ecx
  802582:	39 d8                	cmp    %ebx,%eax
  802584:	76 0a                	jbe    802590 <__umoddi3+0x70>
  802586:	89 f0                	mov    %esi,%eax
  802588:	83 c4 1c             	add    $0x1c,%esp
  80258b:	5b                   	pop    %ebx
  80258c:	5e                   	pop    %esi
  80258d:	5f                   	pop    %edi
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    
  802590:	0f bd e8             	bsr    %eax,%ebp
  802593:	83 f5 1f             	xor    $0x1f,%ebp
  802596:	75 20                	jne    8025b8 <__umoddi3+0x98>
  802598:	39 d8                	cmp    %ebx,%eax
  80259a:	0f 82 b0 00 00 00    	jb     802650 <__umoddi3+0x130>
  8025a0:	39 f7                	cmp    %esi,%edi
  8025a2:	0f 86 a8 00 00 00    	jbe    802650 <__umoddi3+0x130>
  8025a8:	89 c8                	mov    %ecx,%eax
  8025aa:	83 c4 1c             	add    $0x1c,%esp
  8025ad:	5b                   	pop    %ebx
  8025ae:	5e                   	pop    %esi
  8025af:	5f                   	pop    %edi
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    
  8025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8025bf:	29 ea                	sub    %ebp,%edx
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c7:	89 d1                	mov    %edx,%ecx
  8025c9:	89 f8                	mov    %edi,%eax
  8025cb:	d3 e8                	shr    %cl,%eax
  8025cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025d9:	09 c1                	or     %eax,%ecx
  8025db:	89 d8                	mov    %ebx,%eax
  8025dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e1:	89 e9                	mov    %ebp,%ecx
  8025e3:	d3 e7                	shl    %cl,%edi
  8025e5:	89 d1                	mov    %edx,%ecx
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	d3 e3                	shl    %cl,%ebx
  8025f1:	89 c7                	mov    %eax,%edi
  8025f3:	89 d1                	mov    %edx,%ecx
  8025f5:	89 f0                	mov    %esi,%eax
  8025f7:	d3 e8                	shr    %cl,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	89 fa                	mov    %edi,%edx
  8025fd:	d3 e6                	shl    %cl,%esi
  8025ff:	09 d8                	or     %ebx,%eax
  802601:	f7 74 24 08          	divl   0x8(%esp)
  802605:	89 d1                	mov    %edx,%ecx
  802607:	89 f3                	mov    %esi,%ebx
  802609:	f7 64 24 0c          	mull   0xc(%esp)
  80260d:	89 c6                	mov    %eax,%esi
  80260f:	89 d7                	mov    %edx,%edi
  802611:	39 d1                	cmp    %edx,%ecx
  802613:	72 06                	jb     80261b <__umoddi3+0xfb>
  802615:	75 10                	jne    802627 <__umoddi3+0x107>
  802617:	39 c3                	cmp    %eax,%ebx
  802619:	73 0c                	jae    802627 <__umoddi3+0x107>
  80261b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80261f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802623:	89 d7                	mov    %edx,%edi
  802625:	89 c6                	mov    %eax,%esi
  802627:	89 ca                	mov    %ecx,%edx
  802629:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80262e:	29 f3                	sub    %esi,%ebx
  802630:	19 fa                	sbb    %edi,%edx
  802632:	89 d0                	mov    %edx,%eax
  802634:	d3 e0                	shl    %cl,%eax
  802636:	89 e9                	mov    %ebp,%ecx
  802638:	d3 eb                	shr    %cl,%ebx
  80263a:	d3 ea                	shr    %cl,%edx
  80263c:	09 d8                	or     %ebx,%eax
  80263e:	83 c4 1c             	add    $0x1c,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80264d:	8d 76 00             	lea    0x0(%esi),%esi
  802650:	89 da                	mov    %ebx,%edx
  802652:	29 fe                	sub    %edi,%esi
  802654:	19 c2                	sbb    %eax,%edx
  802656:	89 f1                	mov    %esi,%ecx
  802658:	89 c8                	mov    %ecx,%eax
  80265a:	e9 4b ff ff ff       	jmp    8025aa <__umoddi3+0x8a>
