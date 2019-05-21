
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
  80008d:	8b 0d 20 20 80 00    	mov    0x802020,%ecx
  800093:	a1 44 30 80 00       	mov    0x803044,%eax
  800098:	8b 15 48 30 80 00    	mov    0x803048,%edx
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
  8000b1:	68 40 20 80 00       	push   $0x802040
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	e8 0d 0f 00 00       	call   800fcb <sys_map_kernel_page>
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
  8000ce:	b8 40 20 80 00       	mov    $0x802040,%eax
  8000d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax

    gdt = (struct Segdesc*)(base+offset); 
  8000d8:	09 c1                	or     %eax,%ecx
  8000da:	89 0d 40 30 80 00    	mov    %ecx,0x803040
    entry = gdt + index; 
  8000e0:	8d 41 20             	lea    0x20(%ecx),%eax
  8000e3:	a3 20 20 80 00       	mov    %eax,0x802020
    old= *entry; 
  8000e8:	8b 41 20             	mov    0x20(%ecx),%eax
  8000eb:	8b 51 24             	mov    0x24(%ecx),%edx
  8000ee:	a3 44 30 80 00       	mov    %eax,0x803044
  8000f3:	89 15 48 30 80 00    	mov    %edx,0x803048

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
  800124:	68 c0 12 80 00       	push   $0x8012c0
  800129:	e8 5b 01 00 00       	call   800289 <cprintf>
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
  800156:	c7 05 4c 30 80 00 00 	movl   $0x0,0x80304c
  80015d:	00 00 00 
	envid_t find = sys_getenvid();
  800160:	e8 37 0c 00 00       	call   800d9c <sys_getenvid>
  800165:	8b 1d 4c 30 80 00    	mov    0x80304c,%ebx
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
  8001ae:	89 1d 4c 30 80 00    	mov    %ebx,0x80304c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001b8:	7e 0a                	jle    8001c4 <libmain+0x77>
		binaryname = argv[0];
  8001ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bd:	8b 00                	mov    (%eax),%eax
  8001bf:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ca:	ff 75 08             	pushl  0x8(%ebp)
  8001cd:	e8 61 ff ff ff       	call   800133 <umain>

	// exit gracefully
	exit();
  8001d2:	e8 0b 00 00 00       	call   8001e2 <exit>
}
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001dd:	5b                   	pop    %ebx
  8001de:	5e                   	pop    %esi
  8001df:	5f                   	pop    %edi
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 6c 0b 00 00       	call   800d5b <sys_env_destroy>
}
  8001ef:	83 c4 10             	add    $0x10,%esp
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	53                   	push   %ebx
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001fe:	8b 13                	mov    (%ebx),%edx
  800200:	8d 42 01             	lea    0x1(%edx),%eax
  800203:	89 03                	mov    %eax,(%ebx)
  800205:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800208:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80020c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800211:	74 09                	je     80021c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800213:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	68 ff 00 00 00       	push   $0xff
  800224:	8d 43 08             	lea    0x8(%ebx),%eax
  800227:	50                   	push   %eax
  800228:	e8 f1 0a 00 00       	call   800d1e <sys_cputs>
		b->idx = 0;
  80022d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb db                	jmp    800213 <putch+0x1f>

00800238 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800241:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800248:	00 00 00 
	b.cnt = 0;
  80024b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800252:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800255:	ff 75 0c             	pushl  0xc(%ebp)
  800258:	ff 75 08             	pushl  0x8(%ebp)
  80025b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800261:	50                   	push   %eax
  800262:	68 f4 01 80 00       	push   $0x8001f4
  800267:	e8 4a 01 00 00       	call   8003b6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026c:	83 c4 08             	add    $0x8,%esp
  80026f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800275:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	e8 9d 0a 00 00       	call   800d1e <sys_cputs>

	return b.cnt;
}
  800281:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800292:	50                   	push   %eax
  800293:	ff 75 08             	pushl  0x8(%ebp)
  800296:	e8 9d ff ff ff       	call   800238 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 1c             	sub    $0x1c,%esp
  8002a6:	89 c6                	mov    %eax,%esi
  8002a8:	89 d7                	mov    %edx,%edi
  8002aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002bc:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002c0:	74 2c                	je     8002ee <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002d2:	39 c2                	cmp    %eax,%edx
  8002d4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002d7:	73 43                	jae    80031c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d9:	83 eb 01             	sub    $0x1,%ebx
  8002dc:	85 db                	test   %ebx,%ebx
  8002de:	7e 6c                	jle    80034c <printnum+0xaf>
				putch(padc, putdat);
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	57                   	push   %edi
  8002e4:	ff 75 18             	pushl  0x18(%ebp)
  8002e7:	ff d6                	call   *%esi
  8002e9:	83 c4 10             	add    $0x10,%esp
  8002ec:	eb eb                	jmp    8002d9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	6a 20                	push   $0x20
  8002f3:	6a 00                	push   $0x0
  8002f5:	50                   	push   %eax
  8002f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fc:	89 fa                	mov    %edi,%edx
  8002fe:	89 f0                	mov    %esi,%eax
  800300:	e8 98 ff ff ff       	call   80029d <printnum>
		while (--width > 0)
  800305:	83 c4 20             	add    $0x20,%esp
  800308:	83 eb 01             	sub    $0x1,%ebx
  80030b:	85 db                	test   %ebx,%ebx
  80030d:	7e 65                	jle    800374 <printnum+0xd7>
			putch(padc, putdat);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	57                   	push   %edi
  800313:	6a 20                	push   $0x20
  800315:	ff d6                	call   *%esi
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	eb ec                	jmp    800308 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	ff 75 18             	pushl  0x18(%ebp)
  800322:	83 eb 01             	sub    $0x1,%ebx
  800325:	53                   	push   %ebx
  800326:	50                   	push   %eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	ff 75 dc             	pushl  -0x24(%ebp)
  80032d:	ff 75 d8             	pushl  -0x28(%ebp)
  800330:	ff 75 e4             	pushl  -0x1c(%ebp)
  800333:	ff 75 e0             	pushl  -0x20(%ebp)
  800336:	e8 35 0d 00 00       	call   801070 <__udivdi3>
  80033b:	83 c4 18             	add    $0x18,%esp
  80033e:	52                   	push   %edx
  80033f:	50                   	push   %eax
  800340:	89 fa                	mov    %edi,%edx
  800342:	89 f0                	mov    %esi,%eax
  800344:	e8 54 ff ff ff       	call   80029d <printnum>
  800349:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	57                   	push   %edi
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	ff 75 dc             	pushl  -0x24(%ebp)
  800356:	ff 75 d8             	pushl  -0x28(%ebp)
  800359:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035c:	ff 75 e0             	pushl  -0x20(%ebp)
  80035f:	e8 1c 0e 00 00       	call   801180 <__umoddi3>
  800364:	83 c4 14             	add    $0x14,%esp
  800367:	0f be 80 f6 12 80 00 	movsbl 0x8012f6(%eax),%eax
  80036e:	50                   	push   %eax
  80036f:	ff d6                	call   *%esi
  800371:	83 c4 10             	add    $0x10,%esp
	}
}
  800374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    

0080037c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800382:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800386:	8b 10                	mov    (%eax),%edx
  800388:	3b 50 04             	cmp    0x4(%eax),%edx
  80038b:	73 0a                	jae    800397 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800390:	89 08                	mov    %ecx,(%eax)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	88 02                	mov    %al,(%edx)
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <printfmt>:
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a2:	50                   	push   %eax
  8003a3:	ff 75 10             	pushl  0x10(%ebp)
  8003a6:	ff 75 0c             	pushl  0xc(%ebp)
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	e8 05 00 00 00       	call   8003b6 <vprintfmt>
}
  8003b1:	83 c4 10             	add    $0x10,%esp
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <vprintfmt>:
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	57                   	push   %edi
  8003ba:	56                   	push   %esi
  8003bb:	53                   	push   %ebx
  8003bc:	83 ec 3c             	sub    $0x3c,%esp
  8003bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c8:	e9 32 04 00 00       	jmp    8007ff <vprintfmt+0x449>
		padc = ' ';
  8003cd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003d1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003d8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ed:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003f4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8d 47 01             	lea    0x1(%edi),%eax
  8003fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ff:	0f b6 17             	movzbl (%edi),%edx
  800402:	8d 42 dd             	lea    -0x23(%edx),%eax
  800405:	3c 55                	cmp    $0x55,%al
  800407:	0f 87 12 05 00 00    	ja     80091f <vprintfmt+0x569>
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	ff 24 85 e0 14 80 00 	jmp    *0x8014e0(,%eax,4)
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80041a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80041e:	eb d9                	jmp    8003f9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800423:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800427:	eb d0                	jmp    8003f9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800429:	0f b6 d2             	movzbl %dl,%edx
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80042f:	b8 00 00 00 00       	mov    $0x0,%eax
  800434:	89 75 08             	mov    %esi,0x8(%ebp)
  800437:	eb 03                	jmp    80043c <vprintfmt+0x86>
  800439:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800443:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800446:	8d 72 d0             	lea    -0x30(%edx),%esi
  800449:	83 fe 09             	cmp    $0x9,%esi
  80044c:	76 eb                	jbe    800439 <vprintfmt+0x83>
  80044e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800451:	8b 75 08             	mov    0x8(%ebp),%esi
  800454:	eb 14                	jmp    80046a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	8d 40 04             	lea    0x4(%eax),%eax
  800464:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800467:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80046a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046e:	79 89                	jns    8003f9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800470:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800473:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800476:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80047d:	e9 77 ff ff ff       	jmp    8003f9 <vprintfmt+0x43>
  800482:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800485:	85 c0                	test   %eax,%eax
  800487:	0f 48 c1             	cmovs  %ecx,%eax
  80048a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800490:	e9 64 ff ff ff       	jmp    8003f9 <vprintfmt+0x43>
  800495:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800498:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049f:	e9 55 ff ff ff       	jmp    8003f9 <vprintfmt+0x43>
			lflag++;
  8004a4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ab:	e9 49 ff ff ff       	jmp    8003f9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8d 78 04             	lea    0x4(%eax),%edi
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	53                   	push   %ebx
  8004ba:	ff 30                	pushl  (%eax)
  8004bc:	ff d6                	call   *%esi
			break;
  8004be:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004c1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c4:	e9 33 03 00 00       	jmp    8007fc <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	8d 78 04             	lea    0x4(%eax),%edi
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	99                   	cltd   
  8004d2:	31 d0                	xor    %edx,%eax
  8004d4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d6:	83 f8 0f             	cmp    $0xf,%eax
  8004d9:	7f 23                	jg     8004fe <vprintfmt+0x148>
  8004db:	8b 14 85 40 16 80 00 	mov    0x801640(,%eax,4),%edx
  8004e2:	85 d2                	test   %edx,%edx
  8004e4:	74 18                	je     8004fe <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e6:	52                   	push   %edx
  8004e7:	68 17 13 80 00       	push   $0x801317
  8004ec:	53                   	push   %ebx
  8004ed:	56                   	push   %esi
  8004ee:	e8 a6 fe ff ff       	call   800399 <printfmt>
  8004f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f9:	e9 fe 02 00 00       	jmp    8007fc <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fe:	50                   	push   %eax
  8004ff:	68 0e 13 80 00       	push   $0x80130e
  800504:	53                   	push   %ebx
  800505:	56                   	push   %esi
  800506:	e8 8e fe ff ff       	call   800399 <printfmt>
  80050b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800511:	e9 e6 02 00 00       	jmp    8007fc <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	83 c0 04             	add    $0x4,%eax
  80051c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800524:	85 c9                	test   %ecx,%ecx
  800526:	b8 07 13 80 00       	mov    $0x801307,%eax
  80052b:	0f 45 c1             	cmovne %ecx,%eax
  80052e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800531:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800535:	7e 06                	jle    80053d <vprintfmt+0x187>
  800537:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80053b:	75 0d                	jne    80054a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800540:	89 c7                	mov    %eax,%edi
  800542:	03 45 e0             	add    -0x20(%ebp),%eax
  800545:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800548:	eb 53                	jmp    80059d <vprintfmt+0x1e7>
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d8             	pushl  -0x28(%ebp)
  800550:	50                   	push   %eax
  800551:	e8 71 04 00 00       	call   8009c7 <strnlen>
  800556:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800559:	29 c1                	sub    %eax,%ecx
  80055b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80055e:	83 c4 10             	add    $0x10,%esp
  800561:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800563:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800567:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80056a:	eb 0f                	jmp    80057b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	53                   	push   %ebx
  800570:	ff 75 e0             	pushl  -0x20(%ebp)
  800573:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800575:	83 ef 01             	sub    $0x1,%edi
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	85 ff                	test   %edi,%edi
  80057d:	7f ed                	jg     80056c <vprintfmt+0x1b6>
  80057f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800582:	85 c9                	test   %ecx,%ecx
  800584:	b8 00 00 00 00       	mov    $0x0,%eax
  800589:	0f 49 c1             	cmovns %ecx,%eax
  80058c:	29 c1                	sub    %eax,%ecx
  80058e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800591:	eb aa                	jmp    80053d <vprintfmt+0x187>
					putch(ch, putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	53                   	push   %ebx
  800597:	52                   	push   %edx
  800598:	ff d6                	call   *%esi
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a2:	83 c7 01             	add    $0x1,%edi
  8005a5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a9:	0f be d0             	movsbl %al,%edx
  8005ac:	85 d2                	test   %edx,%edx
  8005ae:	74 4b                	je     8005fb <vprintfmt+0x245>
  8005b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b4:	78 06                	js     8005bc <vprintfmt+0x206>
  8005b6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ba:	78 1e                	js     8005da <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005bc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005c0:	74 d1                	je     800593 <vprintfmt+0x1dd>
  8005c2:	0f be c0             	movsbl %al,%eax
  8005c5:	83 e8 20             	sub    $0x20,%eax
  8005c8:	83 f8 5e             	cmp    $0x5e,%eax
  8005cb:	76 c6                	jbe    800593 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	6a 3f                	push   $0x3f
  8005d3:	ff d6                	call   *%esi
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	eb c3                	jmp    80059d <vprintfmt+0x1e7>
  8005da:	89 cf                	mov    %ecx,%edi
  8005dc:	eb 0e                	jmp    8005ec <vprintfmt+0x236>
				putch(' ', putdat);
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	53                   	push   %ebx
  8005e2:	6a 20                	push   $0x20
  8005e4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e6:	83 ef 01             	sub    $0x1,%edi
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	85 ff                	test   %edi,%edi
  8005ee:	7f ee                	jg     8005de <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f6:	e9 01 02 00 00       	jmp    8007fc <vprintfmt+0x446>
  8005fb:	89 cf                	mov    %ecx,%edi
  8005fd:	eb ed                	jmp    8005ec <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800602:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800609:	e9 eb fd ff ff       	jmp    8003f9 <vprintfmt+0x43>
	if (lflag >= 2)
  80060e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800612:	7f 21                	jg     800635 <vprintfmt+0x27f>
	else if (lflag)
  800614:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800618:	74 68                	je     800682 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800622:	89 c1                	mov    %eax,%ecx
  800624:	c1 f9 1f             	sar    $0x1f,%ecx
  800627:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 40 04             	lea    0x4(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
  800633:	eb 17                	jmp    80064c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 50 04             	mov    0x4(%eax),%edx
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800640:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8d 40 08             	lea    0x8(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80064c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800652:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800655:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800658:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80065c:	78 3f                	js     80069d <vprintfmt+0x2e7>
			base = 10;
  80065e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800663:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800667:	0f 84 71 01 00 00    	je     8007de <vprintfmt+0x428>
				putch('+', putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	53                   	push   %ebx
  800671:	6a 2b                	push   $0x2b
  800673:	ff d6                	call   *%esi
  800675:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800678:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067d:	e9 5c 01 00 00       	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, int);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80068a:	89 c1                	mov    %eax,%ecx
  80068c:	c1 f9 1f             	sar    $0x1f,%ecx
  80068f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
  80069b:	eb af                	jmp    80064c <vprintfmt+0x296>
				putch('-', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 2d                	push   $0x2d
  8006a3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ab:	f7 d8                	neg    %eax
  8006ad:	83 d2 00             	adc    $0x0,%edx
  8006b0:	f7 da                	neg    %edx
  8006b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c0:	e9 19 01 00 00       	jmp    8007de <vprintfmt+0x428>
	if (lflag >= 2)
  8006c5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c9:	7f 29                	jg     8006f4 <vprintfmt+0x33e>
	else if (lflag)
  8006cb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cf:	74 44                	je     800715 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ef:	e9 ea 00 00 00       	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 08             	lea    0x8(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800710:	e9 c9 00 00 00       	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
  80071f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800722:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800733:	e9 a6 00 00 00       	jmp    8007de <vprintfmt+0x428>
			putch('0', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 30                	push   $0x30
  80073e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800747:	7f 26                	jg     80076f <vprintfmt+0x3b9>
	else if (lflag)
  800749:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074d:	74 3e                	je     80078d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	ba 00 00 00 00       	mov    $0x0,%edx
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800768:	b8 08 00 00 00       	mov    $0x8,%eax
  80076d:	eb 6f                	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 50 04             	mov    0x4(%eax),%edx
  800775:	8b 00                	mov    (%eax),%eax
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 08             	lea    0x8(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800786:	b8 08 00 00 00       	mov    $0x8,%eax
  80078b:	eb 51                	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 40 04             	lea    0x4(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a6:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ab:	eb 31                	jmp    8007de <vprintfmt+0x428>
			putch('0', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	6a 30                	push   $0x30
  8007b3:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b5:	83 c4 08             	add    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	6a 78                	push   $0x78
  8007bb:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007cd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8d 40 04             	lea    0x4(%eax),%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007de:	83 ec 0c             	sub    $0xc,%esp
  8007e1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007e5:	52                   	push   %edx
  8007e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f0:	89 da                	mov    %ebx,%edx
  8007f2:	89 f0                	mov    %esi,%eax
  8007f4:	e8 a4 fa ff ff       	call   80029d <printnum>
			break;
  8007f9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ff:	83 c7 01             	add    $0x1,%edi
  800802:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800806:	83 f8 25             	cmp    $0x25,%eax
  800809:	0f 84 be fb ff ff    	je     8003cd <vprintfmt+0x17>
			if (ch == '\0')
  80080f:	85 c0                	test   %eax,%eax
  800811:	0f 84 28 01 00 00    	je     80093f <vprintfmt+0x589>
			putch(ch, putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	53                   	push   %ebx
  80081b:	50                   	push   %eax
  80081c:	ff d6                	call   *%esi
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	eb dc                	jmp    8007ff <vprintfmt+0x449>
	if (lflag >= 2)
  800823:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800827:	7f 26                	jg     80084f <vprintfmt+0x499>
	else if (lflag)
  800829:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082d:	74 41                	je     800870 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8d 40 04             	lea    0x4(%eax),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800848:	b8 10 00 00 00       	mov    $0x10,%eax
  80084d:	eb 8f                	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8b 50 04             	mov    0x4(%eax),%edx
  800855:	8b 00                	mov    (%eax),%eax
  800857:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8d 40 08             	lea    0x8(%eax),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800866:	b8 10 00 00 00       	mov    $0x10,%eax
  80086b:	e9 6e ff ff ff       	jmp    8007de <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	ba 00 00 00 00       	mov    $0x0,%edx
  80087a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8d 40 04             	lea    0x4(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800889:	b8 10 00 00 00       	mov    $0x10,%eax
  80088e:	e9 4b ff ff ff       	jmp    8007de <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 c0 04             	add    $0x4,%eax
  800899:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	85 c0                	test   %eax,%eax
  8008a3:	74 14                	je     8008b9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008a5:	8b 13                	mov    (%ebx),%edx
  8008a7:	83 fa 7f             	cmp    $0x7f,%edx
  8008aa:	7f 37                	jg     8008e3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008ac:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b4:	e9 43 ff ff ff       	jmp    8007fc <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008be:	bf 2d 14 80 00       	mov    $0x80142d,%edi
							putch(ch, putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	50                   	push   %eax
  8008c8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ca:	83 c7 01             	add    $0x1,%edi
  8008cd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	85 c0                	test   %eax,%eax
  8008d6:	75 eb                	jne    8008c3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008db:	89 45 14             	mov    %eax,0x14(%ebp)
  8008de:	e9 19 ff ff ff       	jmp    8007fc <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008e3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ea:	bf 65 14 80 00       	mov    $0x801465,%edi
							putch(ch, putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	50                   	push   %eax
  8008f4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f6:	83 c7 01             	add    $0x1,%edi
  8008f9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	85 c0                	test   %eax,%eax
  800902:	75 eb                	jne    8008ef <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
  80090a:	e9 ed fe ff ff       	jmp    8007fc <vprintfmt+0x446>
			putch(ch, putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	6a 25                	push   $0x25
  800915:	ff d6                	call   *%esi
			break;
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	e9 dd fe ff ff       	jmp    8007fc <vprintfmt+0x446>
			putch('%', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	53                   	push   %ebx
  800923:	6a 25                	push   $0x25
  800925:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	89 f8                	mov    %edi,%eax
  80092c:	eb 03                	jmp    800931 <vprintfmt+0x57b>
  80092e:	83 e8 01             	sub    $0x1,%eax
  800931:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800935:	75 f7                	jne    80092e <vprintfmt+0x578>
  800937:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80093a:	e9 bd fe ff ff       	jmp    8007fc <vprintfmt+0x446>
}
  80093f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5f                   	pop    %edi
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 18             	sub    $0x18,%esp
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800953:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800956:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80095a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80095d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800964:	85 c0                	test   %eax,%eax
  800966:	74 26                	je     80098e <vsnprintf+0x47>
  800968:	85 d2                	test   %edx,%edx
  80096a:	7e 22                	jle    80098e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096c:	ff 75 14             	pushl  0x14(%ebp)
  80096f:	ff 75 10             	pushl  0x10(%ebp)
  800972:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800975:	50                   	push   %eax
  800976:	68 7c 03 80 00       	push   $0x80037c
  80097b:	e8 36 fa ff ff       	call   8003b6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800983:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800989:	83 c4 10             	add    $0x10,%esp
}
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    
		return -E_INVAL;
  80098e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800993:	eb f7                	jmp    80098c <vsnprintf+0x45>

00800995 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099e:	50                   	push   %eax
  80099f:	ff 75 10             	pushl  0x10(%ebp)
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	ff 75 08             	pushl  0x8(%ebp)
  8009a8:	e8 9a ff ff ff       	call   800947 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ba:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009be:	74 05                	je     8009c5 <strlen+0x16>
		n++;
  8009c0:	83 c0 01             	add    $0x1,%eax
  8009c3:	eb f5                	jmp    8009ba <strlen+0xb>
	return n;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 0d                	je     8009e6 <strnlen+0x1f>
  8009d9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009dd:	74 05                	je     8009e4 <strnlen+0x1d>
		n++;
  8009df:	83 c2 01             	add    $0x1,%edx
  8009e2:	eb f1                	jmp    8009d5 <strnlen+0xe>
  8009e4:	89 d0                	mov    %edx,%eax
	return n;
}
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009fb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009fe:	83 c2 01             	add    $0x1,%edx
  800a01:	84 c9                	test   %cl,%cl
  800a03:	75 f2                	jne    8009f7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a05:	5b                   	pop    %ebx
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	53                   	push   %ebx
  800a0c:	83 ec 10             	sub    $0x10,%esp
  800a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a12:	53                   	push   %ebx
  800a13:	e8 97 ff ff ff       	call   8009af <strlen>
  800a18:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a1b:	ff 75 0c             	pushl  0xc(%ebp)
  800a1e:	01 d8                	add    %ebx,%eax
  800a20:	50                   	push   %eax
  800a21:	e8 c2 ff ff ff       	call   8009e8 <strcpy>
	return dst;
}
  800a26:	89 d8                	mov    %ebx,%eax
  800a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a38:	89 c6                	mov    %eax,%esi
  800a3a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	39 f2                	cmp    %esi,%edx
  800a41:	74 11                	je     800a54 <strncpy+0x27>
		*dst++ = *src;
  800a43:	83 c2 01             	add    $0x1,%edx
  800a46:	0f b6 19             	movzbl (%ecx),%ebx
  800a49:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4c:	80 fb 01             	cmp    $0x1,%bl
  800a4f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a52:	eb eb                	jmp    800a3f <strncpy+0x12>
	}
	return ret;
}
  800a54:	5b                   	pop    %ebx
  800a55:	5e                   	pop    %esi
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	56                   	push   %esi
  800a5c:	53                   	push   %ebx
  800a5d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a63:	8b 55 10             	mov    0x10(%ebp),%edx
  800a66:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a68:	85 d2                	test   %edx,%edx
  800a6a:	74 21                	je     800a8d <strlcpy+0x35>
  800a6c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a70:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a72:	39 c2                	cmp    %eax,%edx
  800a74:	74 14                	je     800a8a <strlcpy+0x32>
  800a76:	0f b6 19             	movzbl (%ecx),%ebx
  800a79:	84 db                	test   %bl,%bl
  800a7b:	74 0b                	je     800a88 <strlcpy+0x30>
			*dst++ = *src++;
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	83 c2 01             	add    $0x1,%edx
  800a83:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a86:	eb ea                	jmp    800a72 <strlcpy+0x1a>
  800a88:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a8a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8d:	29 f0                	sub    %esi,%eax
}
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a9c:	0f b6 01             	movzbl (%ecx),%eax
  800a9f:	84 c0                	test   %al,%al
  800aa1:	74 0c                	je     800aaf <strcmp+0x1c>
  800aa3:	3a 02                	cmp    (%edx),%al
  800aa5:	75 08                	jne    800aaf <strcmp+0x1c>
		p++, q++;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	83 c2 01             	add    $0x1,%edx
  800aad:	eb ed                	jmp    800a9c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aaf:	0f b6 c0             	movzbl %al,%eax
  800ab2:	0f b6 12             	movzbl (%edx),%edx
  800ab5:	29 d0                	sub    %edx,%eax
}
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	53                   	push   %ebx
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	89 c3                	mov    %eax,%ebx
  800ac5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac8:	eb 06                	jmp    800ad0 <strncmp+0x17>
		n--, p++, q++;
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ad0:	39 d8                	cmp    %ebx,%eax
  800ad2:	74 16                	je     800aea <strncmp+0x31>
  800ad4:	0f b6 08             	movzbl (%eax),%ecx
  800ad7:	84 c9                	test   %cl,%cl
  800ad9:	74 04                	je     800adf <strncmp+0x26>
  800adb:	3a 0a                	cmp    (%edx),%cl
  800add:	74 eb                	je     800aca <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800adf:	0f b6 00             	movzbl (%eax),%eax
  800ae2:	0f b6 12             	movzbl (%edx),%edx
  800ae5:	29 d0                	sub    %edx,%eax
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    
		return 0;
  800aea:	b8 00 00 00 00       	mov    $0x0,%eax
  800aef:	eb f6                	jmp    800ae7 <strncmp+0x2e>

00800af1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afb:	0f b6 10             	movzbl (%eax),%edx
  800afe:	84 d2                	test   %dl,%dl
  800b00:	74 09                	je     800b0b <strchr+0x1a>
		if (*s == c)
  800b02:	38 ca                	cmp    %cl,%dl
  800b04:	74 0a                	je     800b10 <strchr+0x1f>
	for (; *s; s++)
  800b06:	83 c0 01             	add    $0x1,%eax
  800b09:	eb f0                	jmp    800afb <strchr+0xa>
			return (char *) s;
	return 0;
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b1f:	38 ca                	cmp    %cl,%dl
  800b21:	74 09                	je     800b2c <strfind+0x1a>
  800b23:	84 d2                	test   %dl,%dl
  800b25:	74 05                	je     800b2c <strfind+0x1a>
	for (; *s; s++)
  800b27:	83 c0 01             	add    $0x1,%eax
  800b2a:	eb f0                	jmp    800b1c <strfind+0xa>
			break;
	return (char *) s;
}
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	57                   	push   %edi
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b3a:	85 c9                	test   %ecx,%ecx
  800b3c:	74 31                	je     800b6f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3e:	89 f8                	mov    %edi,%eax
  800b40:	09 c8                	or     %ecx,%eax
  800b42:	a8 03                	test   $0x3,%al
  800b44:	75 23                	jne    800b69 <memset+0x3b>
		c &= 0xFF;
  800b46:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b4a:	89 d3                	mov    %edx,%ebx
  800b4c:	c1 e3 08             	shl    $0x8,%ebx
  800b4f:	89 d0                	mov    %edx,%eax
  800b51:	c1 e0 18             	shl    $0x18,%eax
  800b54:	89 d6                	mov    %edx,%esi
  800b56:	c1 e6 10             	shl    $0x10,%esi
  800b59:	09 f0                	or     %esi,%eax
  800b5b:	09 c2                	or     %eax,%edx
  800b5d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b5f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b62:	89 d0                	mov    %edx,%eax
  800b64:	fc                   	cld    
  800b65:	f3 ab                	rep stos %eax,%es:(%edi)
  800b67:	eb 06                	jmp    800b6f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	fc                   	cld    
  800b6d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b6f:	89 f8                	mov    %edi,%eax
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b84:	39 c6                	cmp    %eax,%esi
  800b86:	73 32                	jae    800bba <memmove+0x44>
  800b88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b8b:	39 c2                	cmp    %eax,%edx
  800b8d:	76 2b                	jbe    800bba <memmove+0x44>
		s += n;
		d += n;
  800b8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b92:	89 fe                	mov    %edi,%esi
  800b94:	09 ce                	or     %ecx,%esi
  800b96:	09 d6                	or     %edx,%esi
  800b98:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9e:	75 0e                	jne    800bae <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ba0:	83 ef 04             	sub    $0x4,%edi
  800ba3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba9:	fd                   	std    
  800baa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bac:	eb 09                	jmp    800bb7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bae:	83 ef 01             	sub    $0x1,%edi
  800bb1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb4:	fd                   	std    
  800bb5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb7:	fc                   	cld    
  800bb8:	eb 1a                	jmp    800bd4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bba:	89 c2                	mov    %eax,%edx
  800bbc:	09 ca                	or     %ecx,%edx
  800bbe:	09 f2                	or     %esi,%edx
  800bc0:	f6 c2 03             	test   $0x3,%dl
  800bc3:	75 0a                	jne    800bcf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc8:	89 c7                	mov    %eax,%edi
  800bca:	fc                   	cld    
  800bcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcd:	eb 05                	jmp    800bd4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bcf:	89 c7                	mov    %eax,%edi
  800bd1:	fc                   	cld    
  800bd2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd4:	5e                   	pop    %esi
  800bd5:	5f                   	pop    %edi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bde:	ff 75 10             	pushl  0x10(%ebp)
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	ff 75 08             	pushl  0x8(%ebp)
  800be7:	e8 8a ff ff ff       	call   800b76 <memmove>
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	89 c6                	mov    %eax,%esi
  800bfb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bfe:	39 f0                	cmp    %esi,%eax
  800c00:	74 1c                	je     800c1e <memcmp+0x30>
		if (*s1 != *s2)
  800c02:	0f b6 08             	movzbl (%eax),%ecx
  800c05:	0f b6 1a             	movzbl (%edx),%ebx
  800c08:	38 d9                	cmp    %bl,%cl
  800c0a:	75 08                	jne    800c14 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c0c:	83 c0 01             	add    $0x1,%eax
  800c0f:	83 c2 01             	add    $0x1,%edx
  800c12:	eb ea                	jmp    800bfe <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c14:	0f b6 c1             	movzbl %cl,%eax
  800c17:	0f b6 db             	movzbl %bl,%ebx
  800c1a:	29 d8                	sub    %ebx,%eax
  800c1c:	eb 05                	jmp    800c23 <memcmp+0x35>
	}

	return 0;
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c30:	89 c2                	mov    %eax,%edx
  800c32:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c35:	39 d0                	cmp    %edx,%eax
  800c37:	73 09                	jae    800c42 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c39:	38 08                	cmp    %cl,(%eax)
  800c3b:	74 05                	je     800c42 <memfind+0x1b>
	for (; s < ends; s++)
  800c3d:	83 c0 01             	add    $0x1,%eax
  800c40:	eb f3                	jmp    800c35 <memfind+0xe>
			break;
	return (void *) s;
}
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c50:	eb 03                	jmp    800c55 <strtol+0x11>
		s++;
  800c52:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c55:	0f b6 01             	movzbl (%ecx),%eax
  800c58:	3c 20                	cmp    $0x20,%al
  800c5a:	74 f6                	je     800c52 <strtol+0xe>
  800c5c:	3c 09                	cmp    $0x9,%al
  800c5e:	74 f2                	je     800c52 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c60:	3c 2b                	cmp    $0x2b,%al
  800c62:	74 2a                	je     800c8e <strtol+0x4a>
	int neg = 0;
  800c64:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c69:	3c 2d                	cmp    $0x2d,%al
  800c6b:	74 2b                	je     800c98 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c73:	75 0f                	jne    800c84 <strtol+0x40>
  800c75:	80 39 30             	cmpb   $0x30,(%ecx)
  800c78:	74 28                	je     800ca2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c7a:	85 db                	test   %ebx,%ebx
  800c7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c81:	0f 44 d8             	cmove  %eax,%ebx
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
  800c89:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c8c:	eb 50                	jmp    800cde <strtol+0x9a>
		s++;
  800c8e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c91:	bf 00 00 00 00       	mov    $0x0,%edi
  800c96:	eb d5                	jmp    800c6d <strtol+0x29>
		s++, neg = 1;
  800c98:	83 c1 01             	add    $0x1,%ecx
  800c9b:	bf 01 00 00 00       	mov    $0x1,%edi
  800ca0:	eb cb                	jmp    800c6d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ca6:	74 0e                	je     800cb6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca8:	85 db                	test   %ebx,%ebx
  800caa:	75 d8                	jne    800c84 <strtol+0x40>
		s++, base = 8;
  800cac:	83 c1 01             	add    $0x1,%ecx
  800caf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb4:	eb ce                	jmp    800c84 <strtol+0x40>
		s += 2, base = 16;
  800cb6:	83 c1 02             	add    $0x2,%ecx
  800cb9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cbe:	eb c4                	jmp    800c84 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cc0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cc3:	89 f3                	mov    %esi,%ebx
  800cc5:	80 fb 19             	cmp    $0x19,%bl
  800cc8:	77 29                	ja     800cf3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cca:	0f be d2             	movsbl %dl,%edx
  800ccd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cd0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cd3:	7d 30                	jge    800d05 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd5:	83 c1 01             	add    $0x1,%ecx
  800cd8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cdc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cde:	0f b6 11             	movzbl (%ecx),%edx
  800ce1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce4:	89 f3                	mov    %esi,%ebx
  800ce6:	80 fb 09             	cmp    $0x9,%bl
  800ce9:	77 d5                	ja     800cc0 <strtol+0x7c>
			dig = *s - '0';
  800ceb:	0f be d2             	movsbl %dl,%edx
  800cee:	83 ea 30             	sub    $0x30,%edx
  800cf1:	eb dd                	jmp    800cd0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cf3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cf6:	89 f3                	mov    %esi,%ebx
  800cf8:	80 fb 19             	cmp    $0x19,%bl
  800cfb:	77 08                	ja     800d05 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cfd:	0f be d2             	movsbl %dl,%edx
  800d00:	83 ea 37             	sub    $0x37,%edx
  800d03:	eb cb                	jmp    800cd0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d09:	74 05                	je     800d10 <strtol+0xcc>
		*endptr = (char *) s;
  800d0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d10:	89 c2                	mov    %eax,%edx
  800d12:	f7 da                	neg    %edx
  800d14:	85 ff                	test   %edi,%edi
  800d16:	0f 45 c2             	cmovne %edx,%eax
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d24:	b8 00 00 00 00       	mov    $0x0,%eax
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2f:	89 c3                	mov    %eax,%ebx
  800d31:	89 c7                	mov    %eax,%edi
  800d33:	89 c6                	mov    %eax,%esi
  800d35:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_cgetc>:

int
sys_cgetc(void)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d42:	ba 00 00 00 00       	mov    $0x0,%edx
  800d47:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4c:	89 d1                	mov    %edx,%ecx
  800d4e:	89 d3                	mov    %edx,%ebx
  800d50:	89 d7                	mov    %edx,%edi
  800d52:	89 d6                	mov    %edx,%esi
  800d54:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
  800d61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d71:	89 cb                	mov    %ecx,%ebx
  800d73:	89 cf                	mov    %ecx,%edi
  800d75:	89 ce                	mov    %ecx,%esi
  800d77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7f 08                	jg     800d85 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d85:	83 ec 0c             	sub    $0xc,%esp
  800d88:	50                   	push   %eax
  800d89:	6a 03                	push   $0x3
  800d8b:	68 80 16 80 00       	push   $0x801680
  800d90:	6a 43                	push   $0x43
  800d92:	68 9d 16 80 00       	push   $0x80169d
  800d97:	e8 70 02 00 00       	call   80100c <_panic>

00800d9c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	57                   	push   %edi
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da2:	ba 00 00 00 00       	mov    $0x0,%edx
  800da7:	b8 02 00 00 00       	mov    $0x2,%eax
  800dac:	89 d1                	mov    %edx,%ecx
  800dae:	89 d3                	mov    %edx,%ebx
  800db0:	89 d7                	mov    %edx,%edi
  800db2:	89 d6                	mov    %edx,%esi
  800db4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <sys_yield>:

void
sys_yield(void)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dcb:	89 d1                	mov    %edx,%ecx
  800dcd:	89 d3                	mov    %edx,%ebx
  800dcf:	89 d7                	mov    %edx,%edi
  800dd1:	89 d6                	mov    %edx,%esi
  800dd3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	be 00 00 00 00       	mov    $0x0,%esi
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	b8 04 00 00 00       	mov    $0x4,%eax
  800df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df6:	89 f7                	mov    %esi,%edi
  800df8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	7f 08                	jg     800e06 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	83 ec 0c             	sub    $0xc,%esp
  800e09:	50                   	push   %eax
  800e0a:	6a 04                	push   $0x4
  800e0c:	68 80 16 80 00       	push   $0x801680
  800e11:	6a 43                	push   $0x43
  800e13:	68 9d 16 80 00       	push   $0x80169d
  800e18:	e8 ef 01 00 00       	call   80100c <_panic>

00800e1d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
  800e23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2c:	b8 05 00 00 00       	mov    $0x5,%eax
  800e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e34:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e37:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7f 08                	jg     800e48 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e43:	5b                   	pop    %ebx
  800e44:	5e                   	pop    %esi
  800e45:	5f                   	pop    %edi
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	50                   	push   %eax
  800e4c:	6a 05                	push   $0x5
  800e4e:	68 80 16 80 00       	push   $0x801680
  800e53:	6a 43                	push   $0x43
  800e55:	68 9d 16 80 00       	push   $0x80169d
  800e5a:	e8 ad 01 00 00       	call   80100c <_panic>

00800e5f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	57                   	push   %edi
  800e63:	56                   	push   %esi
  800e64:	53                   	push   %ebx
  800e65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	b8 06 00 00 00       	mov    $0x6,%eax
  800e78:	89 df                	mov    %ebx,%edi
  800e7a:	89 de                	mov    %ebx,%esi
  800e7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	7f 08                	jg     800e8a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	50                   	push   %eax
  800e8e:	6a 06                	push   $0x6
  800e90:	68 80 16 80 00       	push   $0x801680
  800e95:	6a 43                	push   $0x43
  800e97:	68 9d 16 80 00       	push   $0x80169d
  800e9c:	e8 6b 01 00 00       	call   80100c <_panic>

00800ea1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb5:	b8 08 00 00 00       	mov    $0x8,%eax
  800eba:	89 df                	mov    %ebx,%edi
  800ebc:	89 de                	mov    %ebx,%esi
  800ebe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	7f 08                	jg     800ecc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	50                   	push   %eax
  800ed0:	6a 08                	push   $0x8
  800ed2:	68 80 16 80 00       	push   $0x801680
  800ed7:	6a 43                	push   $0x43
  800ed9:	68 9d 16 80 00       	push   $0x80169d
  800ede:	e8 29 01 00 00       	call   80100c <_panic>

00800ee3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef7:	b8 09 00 00 00       	mov    $0x9,%eax
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	89 de                	mov    %ebx,%esi
  800f00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7f 08                	jg     800f0e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	50                   	push   %eax
  800f12:	6a 09                	push   $0x9
  800f14:	68 80 16 80 00       	push   $0x801680
  800f19:	6a 43                	push   $0x43
  800f1b:	68 9d 16 80 00       	push   $0x80169d
  800f20:	e8 e7 00 00 00       	call   80100c <_panic>

00800f25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3e:	89 df                	mov    %ebx,%edi
  800f40:	89 de                	mov    %ebx,%esi
  800f42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f44:	85 c0                	test   %eax,%eax
  800f46:	7f 08                	jg     800f50 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	50                   	push   %eax
  800f54:	6a 0a                	push   $0xa
  800f56:	68 80 16 80 00       	push   $0x801680
  800f5b:	6a 43                	push   $0x43
  800f5d:	68 9d 16 80 00       	push   $0x80169d
  800f62:	e8 a5 00 00 00       	call   80100c <_panic>

00800f67 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f78:	be 00 00 00 00       	mov    $0x0,%esi
  800f7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f80:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f83:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f93:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa0:	89 cb                	mov    %ecx,%ebx
  800fa2:	89 cf                	mov    %ecx,%edi
  800fa4:	89 ce                	mov    %ecx,%esi
  800fa6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	7f 08                	jg     800fb4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	50                   	push   %eax
  800fb8:	6a 0d                	push   $0xd
  800fba:	68 80 16 80 00       	push   $0x801680
  800fbf:	6a 43                	push   $0x43
  800fc1:	68 9d 16 80 00       	push   $0x80169d
  800fc6:	e8 41 00 00 00       	call   80100c <_panic>

00800fcb <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdc:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fe1:	89 df                	mov    %ebx,%edi
  800fe3:	89 de                	mov    %ebx,%esi
  800fe5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffa:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fff:	89 cb                	mov    %ecx,%ebx
  801001:	89 cf                	mov    %ecx,%edi
  801003:	89 ce                	mov    %ecx,%esi
  801005:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801011:	a1 4c 30 80 00       	mov    0x80304c,%eax
  801016:	8b 40 48             	mov    0x48(%eax),%eax
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	68 dc 16 80 00       	push   $0x8016dc
  801021:	50                   	push   %eax
  801022:	68 ab 16 80 00       	push   $0x8016ab
  801027:	e8 5d f2 ff ff       	call   800289 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80102c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80102f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801035:	e8 62 fd ff ff       	call   800d9c <sys_getenvid>
  80103a:	83 c4 04             	add    $0x4,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	ff 75 08             	pushl  0x8(%ebp)
  801043:	56                   	push   %esi
  801044:	50                   	push   %eax
  801045:	68 b8 16 80 00       	push   $0x8016b8
  80104a:	e8 3a f2 ff ff       	call   800289 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80104f:	83 c4 18             	add    $0x18,%esp
  801052:	53                   	push   %ebx
  801053:	ff 75 10             	pushl  0x10(%ebp)
  801056:	e8 dd f1 ff ff       	call   800238 <vcprintf>
	cprintf("\n");
  80105b:	c7 04 24 b4 16 80 00 	movl   $0x8016b4,(%esp)
  801062:	e8 22 f2 ff ff       	call   800289 <cprintf>
  801067:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80106a:	cc                   	int3   
  80106b:	eb fd                	jmp    80106a <_panic+0x5e>
  80106d:	66 90                	xchg   %ax,%ax
  80106f:	90                   	nop

00801070 <__udivdi3>:
  801070:	55                   	push   %ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 1c             	sub    $0x1c,%esp
  801077:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80107b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80107f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801083:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801087:	85 d2                	test   %edx,%edx
  801089:	75 4d                	jne    8010d8 <__udivdi3+0x68>
  80108b:	39 f3                	cmp    %esi,%ebx
  80108d:	76 19                	jbe    8010a8 <__udivdi3+0x38>
  80108f:	31 ff                	xor    %edi,%edi
  801091:	89 e8                	mov    %ebp,%eax
  801093:	89 f2                	mov    %esi,%edx
  801095:	f7 f3                	div    %ebx
  801097:	89 fa                	mov    %edi,%edx
  801099:	83 c4 1c             	add    $0x1c,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
  8010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a8:	89 d9                	mov    %ebx,%ecx
  8010aa:	85 db                	test   %ebx,%ebx
  8010ac:	75 0b                	jne    8010b9 <__udivdi3+0x49>
  8010ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8010b3:	31 d2                	xor    %edx,%edx
  8010b5:	f7 f3                	div    %ebx
  8010b7:	89 c1                	mov    %eax,%ecx
  8010b9:	31 d2                	xor    %edx,%edx
  8010bb:	89 f0                	mov    %esi,%eax
  8010bd:	f7 f1                	div    %ecx
  8010bf:	89 c6                	mov    %eax,%esi
  8010c1:	89 e8                	mov    %ebp,%eax
  8010c3:	89 f7                	mov    %esi,%edi
  8010c5:	f7 f1                	div    %ecx
  8010c7:	89 fa                	mov    %edi,%edx
  8010c9:	83 c4 1c             	add    $0x1c,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	39 f2                	cmp    %esi,%edx
  8010da:	77 1c                	ja     8010f8 <__udivdi3+0x88>
  8010dc:	0f bd fa             	bsr    %edx,%edi
  8010df:	83 f7 1f             	xor    $0x1f,%edi
  8010e2:	75 2c                	jne    801110 <__udivdi3+0xa0>
  8010e4:	39 f2                	cmp    %esi,%edx
  8010e6:	72 06                	jb     8010ee <__udivdi3+0x7e>
  8010e8:	31 c0                	xor    %eax,%eax
  8010ea:	39 eb                	cmp    %ebp,%ebx
  8010ec:	77 a9                	ja     801097 <__udivdi3+0x27>
  8010ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8010f3:	eb a2                	jmp    801097 <__udivdi3+0x27>
  8010f5:	8d 76 00             	lea    0x0(%esi),%esi
  8010f8:	31 ff                	xor    %edi,%edi
  8010fa:	31 c0                	xor    %eax,%eax
  8010fc:	89 fa                	mov    %edi,%edx
  8010fe:	83 c4 1c             	add    $0x1c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    
  801106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80110d:	8d 76 00             	lea    0x0(%esi),%esi
  801110:	89 f9                	mov    %edi,%ecx
  801112:	b8 20 00 00 00       	mov    $0x20,%eax
  801117:	29 f8                	sub    %edi,%eax
  801119:	d3 e2                	shl    %cl,%edx
  80111b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80111f:	89 c1                	mov    %eax,%ecx
  801121:	89 da                	mov    %ebx,%edx
  801123:	d3 ea                	shr    %cl,%edx
  801125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801129:	09 d1                	or     %edx,%ecx
  80112b:	89 f2                	mov    %esi,%edx
  80112d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801131:	89 f9                	mov    %edi,%ecx
  801133:	d3 e3                	shl    %cl,%ebx
  801135:	89 c1                	mov    %eax,%ecx
  801137:	d3 ea                	shr    %cl,%edx
  801139:	89 f9                	mov    %edi,%ecx
  80113b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80113f:	89 eb                	mov    %ebp,%ebx
  801141:	d3 e6                	shl    %cl,%esi
  801143:	89 c1                	mov    %eax,%ecx
  801145:	d3 eb                	shr    %cl,%ebx
  801147:	09 de                	or     %ebx,%esi
  801149:	89 f0                	mov    %esi,%eax
  80114b:	f7 74 24 08          	divl   0x8(%esp)
  80114f:	89 d6                	mov    %edx,%esi
  801151:	89 c3                	mov    %eax,%ebx
  801153:	f7 64 24 0c          	mull   0xc(%esp)
  801157:	39 d6                	cmp    %edx,%esi
  801159:	72 15                	jb     801170 <__udivdi3+0x100>
  80115b:	89 f9                	mov    %edi,%ecx
  80115d:	d3 e5                	shl    %cl,%ebp
  80115f:	39 c5                	cmp    %eax,%ebp
  801161:	73 04                	jae    801167 <__udivdi3+0xf7>
  801163:	39 d6                	cmp    %edx,%esi
  801165:	74 09                	je     801170 <__udivdi3+0x100>
  801167:	89 d8                	mov    %ebx,%eax
  801169:	31 ff                	xor    %edi,%edi
  80116b:	e9 27 ff ff ff       	jmp    801097 <__udivdi3+0x27>
  801170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801173:	31 ff                	xor    %edi,%edi
  801175:	e9 1d ff ff ff       	jmp    801097 <__udivdi3+0x27>
  80117a:	66 90                	xchg   %ax,%ax
  80117c:	66 90                	xchg   %ax,%ax
  80117e:	66 90                	xchg   %ax,%ax

00801180 <__umoddi3>:
  801180:	55                   	push   %ebp
  801181:	57                   	push   %edi
  801182:	56                   	push   %esi
  801183:	53                   	push   %ebx
  801184:	83 ec 1c             	sub    $0x1c,%esp
  801187:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80118b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80118f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801197:	89 da                	mov    %ebx,%edx
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 43                	jne    8011e0 <__umoddi3+0x60>
  80119d:	39 df                	cmp    %ebx,%edi
  80119f:	76 17                	jbe    8011b8 <__umoddi3+0x38>
  8011a1:	89 f0                	mov    %esi,%eax
  8011a3:	f7 f7                	div    %edi
  8011a5:	89 d0                	mov    %edx,%eax
  8011a7:	31 d2                	xor    %edx,%edx
  8011a9:	83 c4 1c             	add    $0x1c,%esp
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    
  8011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011b8:	89 fd                	mov    %edi,%ebp
  8011ba:	85 ff                	test   %edi,%edi
  8011bc:	75 0b                	jne    8011c9 <__umoddi3+0x49>
  8011be:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c3:	31 d2                	xor    %edx,%edx
  8011c5:	f7 f7                	div    %edi
  8011c7:	89 c5                	mov    %eax,%ebp
  8011c9:	89 d8                	mov    %ebx,%eax
  8011cb:	31 d2                	xor    %edx,%edx
  8011cd:	f7 f5                	div    %ebp
  8011cf:	89 f0                	mov    %esi,%eax
  8011d1:	f7 f5                	div    %ebp
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	eb d0                	jmp    8011a7 <__umoddi3+0x27>
  8011d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011de:	66 90                	xchg   %ax,%ax
  8011e0:	89 f1                	mov    %esi,%ecx
  8011e2:	39 d8                	cmp    %ebx,%eax
  8011e4:	76 0a                	jbe    8011f0 <__umoddi3+0x70>
  8011e6:	89 f0                	mov    %esi,%eax
  8011e8:	83 c4 1c             	add    $0x1c,%esp
  8011eb:	5b                   	pop    %ebx
  8011ec:	5e                   	pop    %esi
  8011ed:	5f                   	pop    %edi
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    
  8011f0:	0f bd e8             	bsr    %eax,%ebp
  8011f3:	83 f5 1f             	xor    $0x1f,%ebp
  8011f6:	75 20                	jne    801218 <__umoddi3+0x98>
  8011f8:	39 d8                	cmp    %ebx,%eax
  8011fa:	0f 82 b0 00 00 00    	jb     8012b0 <__umoddi3+0x130>
  801200:	39 f7                	cmp    %esi,%edi
  801202:	0f 86 a8 00 00 00    	jbe    8012b0 <__umoddi3+0x130>
  801208:	89 c8                	mov    %ecx,%eax
  80120a:	83 c4 1c             	add    $0x1c,%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5e                   	pop    %esi
  80120f:	5f                   	pop    %edi
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    
  801212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801218:	89 e9                	mov    %ebp,%ecx
  80121a:	ba 20 00 00 00       	mov    $0x20,%edx
  80121f:	29 ea                	sub    %ebp,%edx
  801221:	d3 e0                	shl    %cl,%eax
  801223:	89 44 24 08          	mov    %eax,0x8(%esp)
  801227:	89 d1                	mov    %edx,%ecx
  801229:	89 f8                	mov    %edi,%eax
  80122b:	d3 e8                	shr    %cl,%eax
  80122d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801231:	89 54 24 04          	mov    %edx,0x4(%esp)
  801235:	8b 54 24 04          	mov    0x4(%esp),%edx
  801239:	09 c1                	or     %eax,%ecx
  80123b:	89 d8                	mov    %ebx,%eax
  80123d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801241:	89 e9                	mov    %ebp,%ecx
  801243:	d3 e7                	shl    %cl,%edi
  801245:	89 d1                	mov    %edx,%ecx
  801247:	d3 e8                	shr    %cl,%eax
  801249:	89 e9                	mov    %ebp,%ecx
  80124b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80124f:	d3 e3                	shl    %cl,%ebx
  801251:	89 c7                	mov    %eax,%edi
  801253:	89 d1                	mov    %edx,%ecx
  801255:	89 f0                	mov    %esi,%eax
  801257:	d3 e8                	shr    %cl,%eax
  801259:	89 e9                	mov    %ebp,%ecx
  80125b:	89 fa                	mov    %edi,%edx
  80125d:	d3 e6                	shl    %cl,%esi
  80125f:	09 d8                	or     %ebx,%eax
  801261:	f7 74 24 08          	divl   0x8(%esp)
  801265:	89 d1                	mov    %edx,%ecx
  801267:	89 f3                	mov    %esi,%ebx
  801269:	f7 64 24 0c          	mull   0xc(%esp)
  80126d:	89 c6                	mov    %eax,%esi
  80126f:	89 d7                	mov    %edx,%edi
  801271:	39 d1                	cmp    %edx,%ecx
  801273:	72 06                	jb     80127b <__umoddi3+0xfb>
  801275:	75 10                	jne    801287 <__umoddi3+0x107>
  801277:	39 c3                	cmp    %eax,%ebx
  801279:	73 0c                	jae    801287 <__umoddi3+0x107>
  80127b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80127f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801283:	89 d7                	mov    %edx,%edi
  801285:	89 c6                	mov    %eax,%esi
  801287:	89 ca                	mov    %ecx,%edx
  801289:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80128e:	29 f3                	sub    %esi,%ebx
  801290:	19 fa                	sbb    %edi,%edx
  801292:	89 d0                	mov    %edx,%eax
  801294:	d3 e0                	shl    %cl,%eax
  801296:	89 e9                	mov    %ebp,%ecx
  801298:	d3 eb                	shr    %cl,%ebx
  80129a:	d3 ea                	shr    %cl,%edx
  80129c:	09 d8                	or     %ebx,%eax
  80129e:	83 c4 1c             	add    $0x1c,%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    
  8012a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012ad:	8d 76 00             	lea    0x0(%esi),%esi
  8012b0:	89 da                	mov    %ebx,%edx
  8012b2:	29 fe                	sub    %edi,%esi
  8012b4:	19 c2                	sbb    %eax,%edx
  8012b6:	89 f1                	mov    %esi,%ecx
  8012b8:	89 c8                	mov    %ecx,%eax
  8012ba:	e9 4b ff ff ff       	jmp    80120a <__umoddi3+0x8a>
