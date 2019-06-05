
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
  8000b9:	e8 22 0f 00 00       	call   800fe0 <sys_map_kernel_page>
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
  800124:	68 20 26 80 00       	push   $0x802620
  800129:	e8 70 01 00 00       	call   80029e <cprintf>
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
  800160:	e8 4c 0c 00 00       	call   800db1 <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	68 4c 26 80 00       	push   $0x80264c
  8001cc:	e8 cd 00 00 00       	call   80029e <cprintf>
	// call user main routine
	umain(argc, argv);
  8001d1:	83 c4 08             	add    $0x8,%esp
  8001d4:	ff 75 0c             	pushl  0xc(%ebp)
  8001d7:	ff 75 08             	pushl  0x8(%ebp)
  8001da:	e8 54 ff ff ff       	call   800133 <umain>

	// exit gracefully
	exit();
  8001df:	e8 0b 00 00 00       	call   8001ef <exit>
}
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    

008001ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001f5:	e8 a2 10 00 00       	call   80129c <close_all>
	sys_env_destroy(0);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	e8 6c 0b 00 00       	call   800d70 <sys_env_destroy>
}
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	53                   	push   %ebx
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800213:	8b 13                	mov    (%ebx),%edx
  800215:	8d 42 01             	lea    0x1(%edx),%eax
  800218:	89 03                	mov    %eax,(%ebx)
  80021a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800221:	3d ff 00 00 00       	cmp    $0xff,%eax
  800226:	74 09                	je     800231 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800228:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80022c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80022f:	c9                   	leave  
  800230:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	68 ff 00 00 00       	push   $0xff
  800239:	8d 43 08             	lea    0x8(%ebx),%eax
  80023c:	50                   	push   %eax
  80023d:	e8 f1 0a 00 00       	call   800d33 <sys_cputs>
		b->idx = 0;
  800242:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	eb db                	jmp    800228 <putch+0x1f>

0080024d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800256:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025d:	00 00 00 
	b.cnt = 0;
  800260:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800267:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	68 09 02 80 00       	push   $0x800209
  80027c:	e8 4a 01 00 00       	call   8003cb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800281:	83 c4 08             	add    $0x8,%esp
  800284:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80028a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800290:	50                   	push   %eax
  800291:	e8 9d 0a 00 00       	call   800d33 <sys_cputs>

	return b.cnt;
}
  800296:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    

0080029e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a7:	50                   	push   %eax
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 9d ff ff ff       	call   80024d <vcprintf>
	va_end(ap);

	return cnt;
}
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 1c             	sub    $0x1c,%esp
  8002bb:	89 c6                	mov    %eax,%esi
  8002bd:	89 d7                	mov    %edx,%edi
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002d1:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002d5:	74 2c                	je     800303 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002e7:	39 c2                	cmp    %eax,%edx
  8002e9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002ec:	73 43                	jae    800331 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002ee:	83 eb 01             	sub    $0x1,%ebx
  8002f1:	85 db                	test   %ebx,%ebx
  8002f3:	7e 6c                	jle    800361 <printnum+0xaf>
				putch(padc, putdat);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	57                   	push   %edi
  8002f9:	ff 75 18             	pushl  0x18(%ebp)
  8002fc:	ff d6                	call   *%esi
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	eb eb                	jmp    8002ee <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800303:	83 ec 0c             	sub    $0xc,%esp
  800306:	6a 20                	push   $0x20
  800308:	6a 00                	push   $0x0
  80030a:	50                   	push   %eax
  80030b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030e:	ff 75 e0             	pushl  -0x20(%ebp)
  800311:	89 fa                	mov    %edi,%edx
  800313:	89 f0                	mov    %esi,%eax
  800315:	e8 98 ff ff ff       	call   8002b2 <printnum>
		while (--width > 0)
  80031a:	83 c4 20             	add    $0x20,%esp
  80031d:	83 eb 01             	sub    $0x1,%ebx
  800320:	85 db                	test   %ebx,%ebx
  800322:	7e 65                	jle    800389 <printnum+0xd7>
			putch(padc, putdat);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	57                   	push   %edi
  800328:	6a 20                	push   $0x20
  80032a:	ff d6                	call   *%esi
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	eb ec                	jmp    80031d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	ff 75 18             	pushl  0x18(%ebp)
  800337:	83 eb 01             	sub    $0x1,%ebx
  80033a:	53                   	push   %ebx
  80033b:	50                   	push   %eax
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	ff 75 dc             	pushl  -0x24(%ebp)
  800342:	ff 75 d8             	pushl  -0x28(%ebp)
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	e8 70 20 00 00       	call   8023c0 <__udivdi3>
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	52                   	push   %edx
  800354:	50                   	push   %eax
  800355:	89 fa                	mov    %edi,%edx
  800357:	89 f0                	mov    %esi,%eax
  800359:	e8 54 ff ff ff       	call   8002b2 <printnum>
  80035e:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	57                   	push   %edi
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	ff 75 dc             	pushl  -0x24(%ebp)
  80036b:	ff 75 d8             	pushl  -0x28(%ebp)
  80036e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800371:	ff 75 e0             	pushl  -0x20(%ebp)
  800374:	e8 57 21 00 00       	call   8024d0 <__umoddi3>
  800379:	83 c4 14             	add    $0x14,%esp
  80037c:	0f be 80 70 26 80 00 	movsbl 0x802670(%eax),%eax
  800383:	50                   	push   %eax
  800384:	ff d6                	call   *%esi
  800386:	83 c4 10             	add    $0x10,%esp
	}
}
  800389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800397:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039b:	8b 10                	mov    (%eax),%edx
  80039d:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a0:	73 0a                	jae    8003ac <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a5:	89 08                	mov    %ecx,(%eax)
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	88 02                	mov    %al,(%edx)
}
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <printfmt>:
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003b4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 10             	pushl  0x10(%ebp)
  8003bb:	ff 75 0c             	pushl  0xc(%ebp)
  8003be:	ff 75 08             	pushl  0x8(%ebp)
  8003c1:	e8 05 00 00 00       	call   8003cb <vprintfmt>
}
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	c9                   	leave  
  8003ca:	c3                   	ret    

008003cb <vprintfmt>:
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	57                   	push   %edi
  8003cf:	56                   	push   %esi
  8003d0:	53                   	push   %ebx
  8003d1:	83 ec 3c             	sub    $0x3c,%esp
  8003d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003da:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003dd:	e9 32 04 00 00       	jmp    800814 <vprintfmt+0x449>
		padc = ' ';
  8003e2:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003e6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003ed:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800402:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800409:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	8d 47 01             	lea    0x1(%edi),%eax
  800411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800414:	0f b6 17             	movzbl (%edi),%edx
  800417:	8d 42 dd             	lea    -0x23(%edx),%eax
  80041a:	3c 55                	cmp    $0x55,%al
  80041c:	0f 87 12 05 00 00    	ja     800934 <vprintfmt+0x569>
  800422:	0f b6 c0             	movzbl %al,%eax
  800425:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80042f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800433:	eb d9                	jmp    80040e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800435:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800438:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80043c:	eb d0                	jmp    80040e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	0f b6 d2             	movzbl %dl,%edx
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800444:	b8 00 00 00 00       	mov    $0x0,%eax
  800449:	89 75 08             	mov    %esi,0x8(%ebp)
  80044c:	eb 03                	jmp    800451 <vprintfmt+0x86>
  80044e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800451:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800454:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800458:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80045b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80045e:	83 fe 09             	cmp    $0x9,%esi
  800461:	76 eb                	jbe    80044e <vprintfmt+0x83>
  800463:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800466:	8b 75 08             	mov    0x8(%ebp),%esi
  800469:	eb 14                	jmp    80047f <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 40 04             	lea    0x4(%eax),%eax
  800479:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80047f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800483:	79 89                	jns    80040e <vprintfmt+0x43>
				width = precision, precision = -1;
  800485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800488:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800492:	e9 77 ff ff ff       	jmp    80040e <vprintfmt+0x43>
  800497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049a:	85 c0                	test   %eax,%eax
  80049c:	0f 48 c1             	cmovs  %ecx,%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a5:	e9 64 ff ff ff       	jmp    80040e <vprintfmt+0x43>
  8004aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ad:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004b4:	e9 55 ff ff ff       	jmp    80040e <vprintfmt+0x43>
			lflag++;
  8004b9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c0:	e9 49 ff ff ff       	jmp    80040e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8d 78 04             	lea    0x4(%eax),%edi
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	53                   	push   %ebx
  8004cf:	ff 30                	pushl  (%eax)
  8004d1:	ff d6                	call   *%esi
			break;
  8004d3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004d6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004d9:	e9 33 03 00 00       	jmp    800811 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8d 78 04             	lea    0x4(%eax),%edi
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	99                   	cltd   
  8004e7:	31 d0                	xor    %edx,%eax
  8004e9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004eb:	83 f8 10             	cmp    $0x10,%eax
  8004ee:	7f 23                	jg     800513 <vprintfmt+0x148>
  8004f0:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	74 18                	je     800513 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004fb:	52                   	push   %edx
  8004fc:	68 b9 2a 80 00       	push   $0x802ab9
  800501:	53                   	push   %ebx
  800502:	56                   	push   %esi
  800503:	e8 a6 fe ff ff       	call   8003ae <printfmt>
  800508:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80050e:	e9 fe 02 00 00       	jmp    800811 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800513:	50                   	push   %eax
  800514:	68 88 26 80 00       	push   $0x802688
  800519:	53                   	push   %ebx
  80051a:	56                   	push   %esi
  80051b:	e8 8e fe ff ff       	call   8003ae <printfmt>
  800520:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800523:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800526:	e9 e6 02 00 00       	jmp    800811 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	83 c0 04             	add    $0x4,%eax
  800531:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800539:	85 c9                	test   %ecx,%ecx
  80053b:	b8 81 26 80 00       	mov    $0x802681,%eax
  800540:	0f 45 c1             	cmovne %ecx,%eax
  800543:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800546:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054a:	7e 06                	jle    800552 <vprintfmt+0x187>
  80054c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800550:	75 0d                	jne    80055f <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800552:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800555:	89 c7                	mov    %eax,%edi
  800557:	03 45 e0             	add    -0x20(%ebp),%eax
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055d:	eb 53                	jmp    8005b2 <vprintfmt+0x1e7>
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 d8             	pushl  -0x28(%ebp)
  800565:	50                   	push   %eax
  800566:	e8 71 04 00 00       	call   8009dc <strnlen>
  80056b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056e:	29 c1                	sub    %eax,%ecx
  800570:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800578:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80057c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80057f:	eb 0f                	jmp    800590 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	ff 75 e0             	pushl  -0x20(%ebp)
  800588:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80058a:	83 ef 01             	sub    $0x1,%edi
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	85 ff                	test   %edi,%edi
  800592:	7f ed                	jg     800581 <vprintfmt+0x1b6>
  800594:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800597:	85 c9                	test   %ecx,%ecx
  800599:	b8 00 00 00 00       	mov    $0x0,%eax
  80059e:	0f 49 c1             	cmovns %ecx,%eax
  8005a1:	29 c1                	sub    %eax,%ecx
  8005a3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005a6:	eb aa                	jmp    800552 <vprintfmt+0x187>
					putch(ch, putdat);
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	53                   	push   %ebx
  8005ac:	52                   	push   %edx
  8005ad:	ff d6                	call   *%esi
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b7:	83 c7 01             	add    $0x1,%edi
  8005ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005be:	0f be d0             	movsbl %al,%edx
  8005c1:	85 d2                	test   %edx,%edx
  8005c3:	74 4b                	je     800610 <vprintfmt+0x245>
  8005c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005c9:	78 06                	js     8005d1 <vprintfmt+0x206>
  8005cb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005cf:	78 1e                	js     8005ef <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005d5:	74 d1                	je     8005a8 <vprintfmt+0x1dd>
  8005d7:	0f be c0             	movsbl %al,%eax
  8005da:	83 e8 20             	sub    $0x20,%eax
  8005dd:	83 f8 5e             	cmp    $0x5e,%eax
  8005e0:	76 c6                	jbe    8005a8 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	6a 3f                	push   $0x3f
  8005e8:	ff d6                	call   *%esi
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	eb c3                	jmp    8005b2 <vprintfmt+0x1e7>
  8005ef:	89 cf                	mov    %ecx,%edi
  8005f1:	eb 0e                	jmp    800601 <vprintfmt+0x236>
				putch(' ', putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	6a 20                	push   $0x20
  8005f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005fb:	83 ef 01             	sub    $0x1,%edi
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	85 ff                	test   %edi,%edi
  800603:	7f ee                	jg     8005f3 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800605:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	e9 01 02 00 00       	jmp    800811 <vprintfmt+0x446>
  800610:	89 cf                	mov    %ecx,%edi
  800612:	eb ed                	jmp    800601 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800614:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800617:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80061e:	e9 eb fd ff ff       	jmp    80040e <vprintfmt+0x43>
	if (lflag >= 2)
  800623:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800627:	7f 21                	jg     80064a <vprintfmt+0x27f>
	else if (lflag)
  800629:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80062d:	74 68                	je     800697 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800637:	89 c1                	mov    %eax,%ecx
  800639:	c1 f9 1f             	sar    $0x1f,%ecx
  80063c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	eb 17                	jmp    800661 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 50 04             	mov    0x4(%eax),%edx
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800655:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 40 08             	lea    0x8(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800661:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800664:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80066d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800671:	78 3f                	js     8006b2 <vprintfmt+0x2e7>
			base = 10;
  800673:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800678:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80067c:	0f 84 71 01 00 00    	je     8007f3 <vprintfmt+0x428>
				putch('+', putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	6a 2b                	push   $0x2b
  800688:	ff d6                	call   *%esi
  80068a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800692:	e9 5c 01 00 00       	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b0:	eb af                	jmp    800661 <vprintfmt+0x296>
				putch('-', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 2d                	push   $0x2d
  8006b8:	ff d6                	call   *%esi
				num = -(long long) num;
  8006ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c0:	f7 d8                	neg    %eax
  8006c2:	83 d2 00             	adc    $0x0,%edx
  8006c5:	f7 da                	neg    %edx
  8006c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d5:	e9 19 01 00 00       	jmp    8007f3 <vprintfmt+0x428>
	if (lflag >= 2)
  8006da:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006de:	7f 29                	jg     800709 <vprintfmt+0x33e>
	else if (lflag)
  8006e0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e4:	74 44                	je     80072a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800704:	e9 ea 00 00 00       	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 08             	lea    0x8(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800720:	b8 0a 00 00 00       	mov    $0xa,%eax
  800725:	e9 c9 00 00 00       	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800743:	b8 0a 00 00 00       	mov    $0xa,%eax
  800748:	e9 a6 00 00 00       	jmp    8007f3 <vprintfmt+0x428>
			putch('0', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 30                	push   $0x30
  800753:	ff d6                	call   *%esi
	if (lflag >= 2)
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80075c:	7f 26                	jg     800784 <vprintfmt+0x3b9>
	else if (lflag)
  80075e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800762:	74 3e                	je     8007a2 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	ba 00 00 00 00       	mov    $0x0,%edx
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077d:	b8 08 00 00 00       	mov    $0x8,%eax
  800782:	eb 6f                	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 50 04             	mov    0x4(%eax),%edx
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 40 08             	lea    0x8(%eax),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079b:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a0:	eb 51                	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8d 40 04             	lea    0x4(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c0:	eb 31                	jmp    8007f3 <vprintfmt+0x428>
			putch('0', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	6a 30                	push   $0x30
  8007c8:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ca:	83 c4 08             	add    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	6a 78                	push   $0x78
  8007d0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007e2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007fa:	52                   	push   %edx
  8007fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8007fe:	50                   	push   %eax
  8007ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800802:	ff 75 d8             	pushl  -0x28(%ebp)
  800805:	89 da                	mov    %ebx,%edx
  800807:	89 f0                	mov    %esi,%eax
  800809:	e8 a4 fa ff ff       	call   8002b2 <printnum>
			break;
  80080e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800811:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	83 c7 01             	add    $0x1,%edi
  800817:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80081b:	83 f8 25             	cmp    $0x25,%eax
  80081e:	0f 84 be fb ff ff    	je     8003e2 <vprintfmt+0x17>
			if (ch == '\0')
  800824:	85 c0                	test   %eax,%eax
  800826:	0f 84 28 01 00 00    	je     800954 <vprintfmt+0x589>
			putch(ch, putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	50                   	push   %eax
  800831:	ff d6                	call   *%esi
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	eb dc                	jmp    800814 <vprintfmt+0x449>
	if (lflag >= 2)
  800838:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80083c:	7f 26                	jg     800864 <vprintfmt+0x499>
	else if (lflag)
  80083e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800842:	74 41                	je     800885 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 40 04             	lea    0x4(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085d:	b8 10 00 00 00       	mov    $0x10,%eax
  800862:	eb 8f                	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 50 04             	mov    0x4(%eax),%edx
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8d 40 08             	lea    0x8(%eax),%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087b:	b8 10 00 00 00       	mov    $0x10,%eax
  800880:	e9 6e ff ff ff       	jmp    8007f3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	ba 00 00 00 00       	mov    $0x0,%edx
  80088f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800892:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 40 04             	lea    0x4(%eax),%eax
  80089b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089e:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a3:	e9 4b ff ff ff       	jmp    8007f3 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 c0 04             	add    $0x4,%eax
  8008ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	74 14                	je     8008ce <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008ba:	8b 13                	mov    (%ebx),%edx
  8008bc:	83 fa 7f             	cmp    $0x7f,%edx
  8008bf:	7f 37                	jg     8008f8 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008c1:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c9:	e9 43 ff ff ff       	jmp    800811 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008d3:	bf a5 27 80 00       	mov    $0x8027a5,%edi
							putch(ch, putdat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	53                   	push   %ebx
  8008dc:	50                   	push   %eax
  8008dd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008df:	83 c7 01             	add    $0x1,%edi
  8008e2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	85 c0                	test   %eax,%eax
  8008eb:	75 eb                	jne    8008d8 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f3:	e9 19 ff ff ff       	jmp    800811 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008f8:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ff:	bf dd 27 80 00       	mov    $0x8027dd,%edi
							putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	53                   	push   %ebx
  800908:	50                   	push   %eax
  800909:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80090b:	83 c7 01             	add    $0x1,%edi
  80090e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	85 c0                	test   %eax,%eax
  800917:	75 eb                	jne    800904 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800919:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
  80091f:	e9 ed fe ff ff       	jmp    800811 <vprintfmt+0x446>
			putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	53                   	push   %ebx
  800928:	6a 25                	push   $0x25
  80092a:	ff d6                	call   *%esi
			break;
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	e9 dd fe ff ff       	jmp    800811 <vprintfmt+0x446>
			putch('%', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	53                   	push   %ebx
  800938:	6a 25                	push   $0x25
  80093a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	89 f8                	mov    %edi,%eax
  800941:	eb 03                	jmp    800946 <vprintfmt+0x57b>
  800943:	83 e8 01             	sub    $0x1,%eax
  800946:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80094a:	75 f7                	jne    800943 <vprintfmt+0x578>
  80094c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80094f:	e9 bd fe ff ff       	jmp    800811 <vprintfmt+0x446>
}
  800954:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5f                   	pop    %edi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800968:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80096b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80096f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800979:	85 c0                	test   %eax,%eax
  80097b:	74 26                	je     8009a3 <vsnprintf+0x47>
  80097d:	85 d2                	test   %edx,%edx
  80097f:	7e 22                	jle    8009a3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800981:	ff 75 14             	pushl  0x14(%ebp)
  800984:	ff 75 10             	pushl  0x10(%ebp)
  800987:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	68 91 03 80 00       	push   $0x800391
  800990:	e8 36 fa ff ff       	call   8003cb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800998:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80099b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099e:	83 c4 10             	add    $0x10,%esp
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    
		return -E_INVAL;
  8009a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009a8:	eb f7                	jmp    8009a1 <vsnprintf+0x45>

008009aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 10             	pushl  0x10(%ebp)
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 9a ff ff ff       	call   80095c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009d3:	74 05                	je     8009da <strlen+0x16>
		n++;
  8009d5:	83 c0 01             	add    $0x1,%eax
  8009d8:	eb f5                	jmp    8009cf <strlen+0xb>
	return n;
}
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ea:	39 c2                	cmp    %eax,%edx
  8009ec:	74 0d                	je     8009fb <strnlen+0x1f>
  8009ee:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009f2:	74 05                	je     8009f9 <strnlen+0x1d>
		n++;
  8009f4:	83 c2 01             	add    $0x1,%edx
  8009f7:	eb f1                	jmp    8009ea <strnlen+0xe>
  8009f9:	89 d0                	mov    %edx,%eax
	return n;
}
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	53                   	push   %ebx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a07:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a10:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	84 c9                	test   %cl,%cl
  800a18:	75 f2                	jne    800a0c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a1a:	5b                   	pop    %ebx
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	53                   	push   %ebx
  800a21:	83 ec 10             	sub    $0x10,%esp
  800a24:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a27:	53                   	push   %ebx
  800a28:	e8 97 ff ff ff       	call   8009c4 <strlen>
  800a2d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	01 d8                	add    %ebx,%eax
  800a35:	50                   	push   %eax
  800a36:	e8 c2 ff ff ff       	call   8009fd <strcpy>
	return dst;
}
  800a3b:	89 d8                	mov    %ebx,%eax
  800a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    

00800a42 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4d:	89 c6                	mov    %eax,%esi
  800a4f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a52:	89 c2                	mov    %eax,%edx
  800a54:	39 f2                	cmp    %esi,%edx
  800a56:	74 11                	je     800a69 <strncpy+0x27>
		*dst++ = *src;
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	0f b6 19             	movzbl (%ecx),%ebx
  800a5e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a61:	80 fb 01             	cmp    $0x1,%bl
  800a64:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a67:	eb eb                	jmp    800a54 <strncpy+0x12>
	}
	return ret;
}
  800a69:	5b                   	pop    %ebx
  800a6a:	5e                   	pop    %esi
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	8b 75 08             	mov    0x8(%ebp),%esi
  800a75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a78:	8b 55 10             	mov    0x10(%ebp),%edx
  800a7b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a7d:	85 d2                	test   %edx,%edx
  800a7f:	74 21                	je     800aa2 <strlcpy+0x35>
  800a81:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a85:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a87:	39 c2                	cmp    %eax,%edx
  800a89:	74 14                	je     800a9f <strlcpy+0x32>
  800a8b:	0f b6 19             	movzbl (%ecx),%ebx
  800a8e:	84 db                	test   %bl,%bl
  800a90:	74 0b                	je     800a9d <strlcpy+0x30>
			*dst++ = *src++;
  800a92:	83 c1 01             	add    $0x1,%ecx
  800a95:	83 c2 01             	add    $0x1,%edx
  800a98:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a9b:	eb ea                	jmp    800a87 <strlcpy+0x1a>
  800a9d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a9f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aa2:	29 f0                	sub    %esi,%eax
}
  800aa4:	5b                   	pop    %ebx
  800aa5:	5e                   	pop    %esi
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ab1:	0f b6 01             	movzbl (%ecx),%eax
  800ab4:	84 c0                	test   %al,%al
  800ab6:	74 0c                	je     800ac4 <strcmp+0x1c>
  800ab8:	3a 02                	cmp    (%edx),%al
  800aba:	75 08                	jne    800ac4 <strcmp+0x1c>
		p++, q++;
  800abc:	83 c1 01             	add    $0x1,%ecx
  800abf:	83 c2 01             	add    $0x1,%edx
  800ac2:	eb ed                	jmp    800ab1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac4:	0f b6 c0             	movzbl %al,%eax
  800ac7:	0f b6 12             	movzbl (%edx),%edx
  800aca:	29 d0                	sub    %edx,%eax
}
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad8:	89 c3                	mov    %eax,%ebx
  800ada:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800add:	eb 06                	jmp    800ae5 <strncmp+0x17>
		n--, p++, q++;
  800adf:	83 c0 01             	add    $0x1,%eax
  800ae2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ae5:	39 d8                	cmp    %ebx,%eax
  800ae7:	74 16                	je     800aff <strncmp+0x31>
  800ae9:	0f b6 08             	movzbl (%eax),%ecx
  800aec:	84 c9                	test   %cl,%cl
  800aee:	74 04                	je     800af4 <strncmp+0x26>
  800af0:	3a 0a                	cmp    (%edx),%cl
  800af2:	74 eb                	je     800adf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800af4:	0f b6 00             	movzbl (%eax),%eax
  800af7:	0f b6 12             	movzbl (%edx),%edx
  800afa:	29 d0                	sub    %edx,%eax
}
  800afc:	5b                   	pop    %ebx
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    
		return 0;
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	eb f6                	jmp    800afc <strncmp+0x2e>

00800b06 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b10:	0f b6 10             	movzbl (%eax),%edx
  800b13:	84 d2                	test   %dl,%dl
  800b15:	74 09                	je     800b20 <strchr+0x1a>
		if (*s == c)
  800b17:	38 ca                	cmp    %cl,%dl
  800b19:	74 0a                	je     800b25 <strchr+0x1f>
	for (; *s; s++)
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	eb f0                	jmp    800b10 <strchr+0xa>
			return (char *) s;
	return 0;
  800b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b31:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b34:	38 ca                	cmp    %cl,%dl
  800b36:	74 09                	je     800b41 <strfind+0x1a>
  800b38:	84 d2                	test   %dl,%dl
  800b3a:	74 05                	je     800b41 <strfind+0x1a>
	for (; *s; s++)
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	eb f0                	jmp    800b31 <strfind+0xa>
			break;
	return (char *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b4f:	85 c9                	test   %ecx,%ecx
  800b51:	74 31                	je     800b84 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b53:	89 f8                	mov    %edi,%eax
  800b55:	09 c8                	or     %ecx,%eax
  800b57:	a8 03                	test   $0x3,%al
  800b59:	75 23                	jne    800b7e <memset+0x3b>
		c &= 0xFF;
  800b5b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b5f:	89 d3                	mov    %edx,%ebx
  800b61:	c1 e3 08             	shl    $0x8,%ebx
  800b64:	89 d0                	mov    %edx,%eax
  800b66:	c1 e0 18             	shl    $0x18,%eax
  800b69:	89 d6                	mov    %edx,%esi
  800b6b:	c1 e6 10             	shl    $0x10,%esi
  800b6e:	09 f0                	or     %esi,%eax
  800b70:	09 c2                	or     %eax,%edx
  800b72:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b74:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b77:	89 d0                	mov    %edx,%eax
  800b79:	fc                   	cld    
  800b7a:	f3 ab                	rep stos %eax,%es:(%edi)
  800b7c:	eb 06                	jmp    800b84 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	fc                   	cld    
  800b82:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b84:	89 f8                	mov    %edi,%eax
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5f                   	pop    %edi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	57                   	push   %edi
  800b8f:	56                   	push   %esi
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b96:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b99:	39 c6                	cmp    %eax,%esi
  800b9b:	73 32                	jae    800bcf <memmove+0x44>
  800b9d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ba0:	39 c2                	cmp    %eax,%edx
  800ba2:	76 2b                	jbe    800bcf <memmove+0x44>
		s += n;
		d += n;
  800ba4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba7:	89 fe                	mov    %edi,%esi
  800ba9:	09 ce                	or     %ecx,%esi
  800bab:	09 d6                	or     %edx,%esi
  800bad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bb3:	75 0e                	jne    800bc3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bb5:	83 ef 04             	sub    $0x4,%edi
  800bb8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bbb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bbe:	fd                   	std    
  800bbf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc1:	eb 09                	jmp    800bcc <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bc3:	83 ef 01             	sub    $0x1,%edi
  800bc6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bc9:	fd                   	std    
  800bca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bcc:	fc                   	cld    
  800bcd:	eb 1a                	jmp    800be9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcf:	89 c2                	mov    %eax,%edx
  800bd1:	09 ca                	or     %ecx,%edx
  800bd3:	09 f2                	or     %esi,%edx
  800bd5:	f6 c2 03             	test   $0x3,%dl
  800bd8:	75 0a                	jne    800be4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bda:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bdd:	89 c7                	mov    %eax,%edi
  800bdf:	fc                   	cld    
  800be0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800be2:	eb 05                	jmp    800be9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800be4:	89 c7                	mov    %eax,%edi
  800be6:	fc                   	cld    
  800be7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bf3:	ff 75 10             	pushl  0x10(%ebp)
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	ff 75 08             	pushl  0x8(%ebp)
  800bfc:	e8 8a ff ff ff       	call   800b8b <memmove>
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0e:	89 c6                	mov    %eax,%esi
  800c10:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c13:	39 f0                	cmp    %esi,%eax
  800c15:	74 1c                	je     800c33 <memcmp+0x30>
		if (*s1 != *s2)
  800c17:	0f b6 08             	movzbl (%eax),%ecx
  800c1a:	0f b6 1a             	movzbl (%edx),%ebx
  800c1d:	38 d9                	cmp    %bl,%cl
  800c1f:	75 08                	jne    800c29 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c21:	83 c0 01             	add    $0x1,%eax
  800c24:	83 c2 01             	add    $0x1,%edx
  800c27:	eb ea                	jmp    800c13 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c29:	0f b6 c1             	movzbl %cl,%eax
  800c2c:	0f b6 db             	movzbl %bl,%ebx
  800c2f:	29 d8                	sub    %ebx,%eax
  800c31:	eb 05                	jmp    800c38 <memcmp+0x35>
	}

	return 0;
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c45:	89 c2                	mov    %eax,%edx
  800c47:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c4a:	39 d0                	cmp    %edx,%eax
  800c4c:	73 09                	jae    800c57 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c4e:	38 08                	cmp    %cl,(%eax)
  800c50:	74 05                	je     800c57 <memfind+0x1b>
	for (; s < ends; s++)
  800c52:	83 c0 01             	add    $0x1,%eax
  800c55:	eb f3                	jmp    800c4a <memfind+0xe>
			break;
	return (void *) s;
}
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c65:	eb 03                	jmp    800c6a <strtol+0x11>
		s++;
  800c67:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c6a:	0f b6 01             	movzbl (%ecx),%eax
  800c6d:	3c 20                	cmp    $0x20,%al
  800c6f:	74 f6                	je     800c67 <strtol+0xe>
  800c71:	3c 09                	cmp    $0x9,%al
  800c73:	74 f2                	je     800c67 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c75:	3c 2b                	cmp    $0x2b,%al
  800c77:	74 2a                	je     800ca3 <strtol+0x4a>
	int neg = 0;
  800c79:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c7e:	3c 2d                	cmp    $0x2d,%al
  800c80:	74 2b                	je     800cad <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c82:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c88:	75 0f                	jne    800c99 <strtol+0x40>
  800c8a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c8d:	74 28                	je     800cb7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c8f:	85 db                	test   %ebx,%ebx
  800c91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c96:	0f 44 d8             	cmove  %eax,%ebx
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ca1:	eb 50                	jmp    800cf3 <strtol+0x9a>
		s++;
  800ca3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ca6:	bf 00 00 00 00       	mov    $0x0,%edi
  800cab:	eb d5                	jmp    800c82 <strtol+0x29>
		s++, neg = 1;
  800cad:	83 c1 01             	add    $0x1,%ecx
  800cb0:	bf 01 00 00 00       	mov    $0x1,%edi
  800cb5:	eb cb                	jmp    800c82 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cbb:	74 0e                	je     800ccb <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cbd:	85 db                	test   %ebx,%ebx
  800cbf:	75 d8                	jne    800c99 <strtol+0x40>
		s++, base = 8;
  800cc1:	83 c1 01             	add    $0x1,%ecx
  800cc4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cc9:	eb ce                	jmp    800c99 <strtol+0x40>
		s += 2, base = 16;
  800ccb:	83 c1 02             	add    $0x2,%ecx
  800cce:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cd3:	eb c4                	jmp    800c99 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cd5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cd8:	89 f3                	mov    %esi,%ebx
  800cda:	80 fb 19             	cmp    $0x19,%bl
  800cdd:	77 29                	ja     800d08 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cdf:	0f be d2             	movsbl %dl,%edx
  800ce2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ce5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ce8:	7d 30                	jge    800d1a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cea:	83 c1 01             	add    $0x1,%ecx
  800ced:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cf1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cf3:	0f b6 11             	movzbl (%ecx),%edx
  800cf6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cf9:	89 f3                	mov    %esi,%ebx
  800cfb:	80 fb 09             	cmp    $0x9,%bl
  800cfe:	77 d5                	ja     800cd5 <strtol+0x7c>
			dig = *s - '0';
  800d00:	0f be d2             	movsbl %dl,%edx
  800d03:	83 ea 30             	sub    $0x30,%edx
  800d06:	eb dd                	jmp    800ce5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d08:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d0b:	89 f3                	mov    %esi,%ebx
  800d0d:	80 fb 19             	cmp    $0x19,%bl
  800d10:	77 08                	ja     800d1a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d12:	0f be d2             	movsbl %dl,%edx
  800d15:	83 ea 37             	sub    $0x37,%edx
  800d18:	eb cb                	jmp    800ce5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d1e:	74 05                	je     800d25 <strtol+0xcc>
		*endptr = (char *) s;
  800d20:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d23:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d25:	89 c2                	mov    %eax,%edx
  800d27:	f7 da                	neg    %edx
  800d29:	85 ff                	test   %edi,%edi
  800d2b:	0f 45 c2             	cmovne %edx,%eax
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d39:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	89 c3                	mov    %eax,%ebx
  800d46:	89 c7                	mov    %eax,%edi
  800d48:	89 c6                	mov    %eax,%esi
  800d4a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d57:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5c:	b8 01 00 00 00       	mov    $0x1,%eax
  800d61:	89 d1                	mov    %edx,%ecx
  800d63:	89 d3                	mov    %edx,%ebx
  800d65:	89 d7                	mov    %edx,%edi
  800d67:	89 d6                	mov    %edx,%esi
  800d69:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	b8 03 00 00 00       	mov    $0x3,%eax
  800d86:	89 cb                	mov    %ecx,%ebx
  800d88:	89 cf                	mov    %ecx,%edi
  800d8a:	89 ce                	mov    %ecx,%esi
  800d8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 03                	push   $0x3
  800da0:	68 e4 29 80 00       	push   $0x8029e4
  800da5:	6a 43                	push   $0x43
  800da7:	68 01 2a 80 00       	push   $0x802a01
  800dac:	e8 69 14 00 00       	call   80221a <_panic>

00800db1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbc:	b8 02 00 00 00       	mov    $0x2,%eax
  800dc1:	89 d1                	mov    %edx,%ecx
  800dc3:	89 d3                	mov    %edx,%ebx
  800dc5:	89 d7                	mov    %edx,%edi
  800dc7:	89 d6                	mov    %edx,%esi
  800dc9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_yield>:

void
sys_yield(void)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de0:	89 d1                	mov    %edx,%ecx
  800de2:	89 d3                	mov    %edx,%ebx
  800de4:	89 d7                	mov    %edx,%edi
  800de6:	89 d6                	mov    %edx,%esi
  800de8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    

00800def <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	be 00 00 00 00       	mov    $0x0,%esi
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 04 00 00 00       	mov    $0x4,%eax
  800e08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0b:	89 f7                	mov    %esi,%edi
  800e0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7f 08                	jg     800e1b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	83 ec 0c             	sub    $0xc,%esp
  800e1e:	50                   	push   %eax
  800e1f:	6a 04                	push   $0x4
  800e21:	68 e4 29 80 00       	push   $0x8029e4
  800e26:	6a 43                	push   $0x43
  800e28:	68 01 2a 80 00       	push   $0x802a01
  800e2d:	e8 e8 13 00 00       	call   80221a <_panic>

00800e32 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	57                   	push   %edi
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e41:	b8 05 00 00 00       	mov    $0x5,%eax
  800e46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e49:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4c:	8b 75 18             	mov    0x18(%ebp),%esi
  800e4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	7f 08                	jg     800e5d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5d:	83 ec 0c             	sub    $0xc,%esp
  800e60:	50                   	push   %eax
  800e61:	6a 05                	push   $0x5
  800e63:	68 e4 29 80 00       	push   $0x8029e4
  800e68:	6a 43                	push   $0x43
  800e6a:	68 01 2a 80 00       	push   $0x802a01
  800e6f:	e8 a6 13 00 00       	call   80221a <_panic>

00800e74 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	53                   	push   %ebx
  800e7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	b8 06 00 00 00       	mov    $0x6,%eax
  800e8d:	89 df                	mov    %ebx,%edi
  800e8f:	89 de                	mov    %ebx,%esi
  800e91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7f 08                	jg     800e9f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	50                   	push   %eax
  800ea3:	6a 06                	push   $0x6
  800ea5:	68 e4 29 80 00       	push   $0x8029e4
  800eaa:	6a 43                	push   $0x43
  800eac:	68 01 2a 80 00       	push   $0x802a01
  800eb1:	e8 64 13 00 00       	call   80221a <_panic>

00800eb6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	b8 08 00 00 00       	mov    $0x8,%eax
  800ecf:	89 df                	mov    %ebx,%edi
  800ed1:	89 de                	mov    %ebx,%esi
  800ed3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	7f 08                	jg     800ee1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5f                   	pop    %edi
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	50                   	push   %eax
  800ee5:	6a 08                	push   $0x8
  800ee7:	68 e4 29 80 00       	push   $0x8029e4
  800eec:	6a 43                	push   $0x43
  800eee:	68 01 2a 80 00       	push   $0x802a01
  800ef3:	e8 22 13 00 00       	call   80221a <_panic>

00800ef8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f01:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0c:	b8 09 00 00 00       	mov    $0x9,%eax
  800f11:	89 df                	mov    %ebx,%edi
  800f13:	89 de                	mov    %ebx,%esi
  800f15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	7f 08                	jg     800f23 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f23:	83 ec 0c             	sub    $0xc,%esp
  800f26:	50                   	push   %eax
  800f27:	6a 09                	push   $0x9
  800f29:	68 e4 29 80 00       	push   $0x8029e4
  800f2e:	6a 43                	push   $0x43
  800f30:	68 01 2a 80 00       	push   $0x802a01
  800f35:	e8 e0 12 00 00       	call   80221a <_panic>

00800f3a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	7f 08                	jg     800f65 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f65:	83 ec 0c             	sub    $0xc,%esp
  800f68:	50                   	push   %eax
  800f69:	6a 0a                	push   $0xa
  800f6b:	68 e4 29 80 00       	push   $0x8029e4
  800f70:	6a 43                	push   $0x43
  800f72:	68 01 2a 80 00       	push   $0x802a01
  800f77:	e8 9e 12 00 00       	call   80221a <_panic>

00800f7c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f88:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8d:	be 00 00 00 00       	mov    $0x0,%esi
  800f92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f98:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
  800fa5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fad:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fb5:	89 cb                	mov    %ecx,%ebx
  800fb7:	89 cf                	mov    %ecx,%edi
  800fb9:	89 ce                	mov    %ecx,%esi
  800fbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7f 08                	jg     800fc9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800fcd:	6a 0d                	push   $0xd
  800fcf:	68 e4 29 80 00       	push   $0x8029e4
  800fd4:	6a 43                	push   $0x43
  800fd6:	68 01 2a 80 00       	push   $0x802a01
  800fdb:	e8 3a 12 00 00       	call   80221a <_panic>

00800fe0 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800feb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ff6:	89 df                	mov    %ebx,%edi
  800ff8:	89 de                	mov    %ebx,%esi
  800ffa:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
	asm volatile("int %1\n"
  801007:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801014:	89 cb                	mov    %ecx,%ebx
  801016:	89 cf                	mov    %ecx,%edi
  801018:	89 ce                	mov    %ecx,%esi
  80101a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	57                   	push   %edi
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
	asm volatile("int %1\n"
  801027:	ba 00 00 00 00       	mov    $0x0,%edx
  80102c:	b8 10 00 00 00       	mov    $0x10,%eax
  801031:	89 d1                	mov    %edx,%ecx
  801033:	89 d3                	mov    %edx,%ebx
  801035:	89 d7                	mov    %edx,%edi
  801037:	89 d6                	mov    %edx,%esi
  801039:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80103b:	5b                   	pop    %ebx
  80103c:	5e                   	pop    %esi
  80103d:	5f                   	pop    %edi
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	53                   	push   %ebx
	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	b8 11 00 00 00       	mov    $0x11,%eax
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
	asm volatile("int %1\n"
  801067:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801072:	b8 12 00 00 00       	mov    $0x12,%eax
  801077:	89 df                	mov    %ebx,%edi
  801079:	89 de                	mov    %ebx,%esi
  80107b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801090:	8b 55 08             	mov    0x8(%ebp),%edx
  801093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801096:	b8 13 00 00 00       	mov    $0x13,%eax
  80109b:	89 df                	mov    %ebx,%edi
  80109d:	89 de                	mov    %ebx,%esi
  80109f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	7f 08                	jg     8010ad <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	50                   	push   %eax
  8010b1:	6a 13                	push   $0x13
  8010b3:	68 e4 29 80 00       	push   $0x8029e4
  8010b8:	6a 43                	push   $0x43
  8010ba:	68 01 2a 80 00       	push   $0x802a01
  8010bf:	e8 56 11 00 00       	call   80221a <_panic>

008010c4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cf:	c1 e8 0c             	shr    $0xc,%eax
}
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f3:	89 c2                	mov    %eax,%edx
  8010f5:	c1 ea 16             	shr    $0x16,%edx
  8010f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ff:	f6 c2 01             	test   $0x1,%dl
  801102:	74 2d                	je     801131 <fd_alloc+0x46>
  801104:	89 c2                	mov    %eax,%edx
  801106:	c1 ea 0c             	shr    $0xc,%edx
  801109:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801110:	f6 c2 01             	test   $0x1,%dl
  801113:	74 1c                	je     801131 <fd_alloc+0x46>
  801115:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80111a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80111f:	75 d2                	jne    8010f3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80112a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80112f:	eb 0a                	jmp    80113b <fd_alloc+0x50>
			*fd_store = fd;
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	89 01                	mov    %eax,(%ecx)
			return 0;
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801143:	83 f8 1f             	cmp    $0x1f,%eax
  801146:	77 30                	ja     801178 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801148:	c1 e0 0c             	shl    $0xc,%eax
  80114b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801150:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801156:	f6 c2 01             	test   $0x1,%dl
  801159:	74 24                	je     80117f <fd_lookup+0x42>
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	c1 ea 0c             	shr    $0xc,%edx
  801160:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801167:	f6 c2 01             	test   $0x1,%dl
  80116a:	74 1a                	je     801186 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	89 02                	mov    %eax,(%edx)
	return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    
		return -E_INVAL;
  801178:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117d:	eb f7                	jmp    801176 <fd_lookup+0x39>
		return -E_INVAL;
  80117f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801184:	eb f0                	jmp    801176 <fd_lookup+0x39>
  801186:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118b:	eb e9                	jmp    801176 <fd_lookup+0x39>

0080118d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801196:	ba 00 00 00 00       	mov    $0x0,%edx
  80119b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011a0:	39 08                	cmp    %ecx,(%eax)
  8011a2:	74 38                	je     8011dc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011a4:	83 c2 01             	add    $0x1,%edx
  8011a7:	8b 04 95 8c 2a 80 00 	mov    0x802a8c(,%edx,4),%eax
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	75 ee                	jne    8011a0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8011b7:	8b 40 48             	mov    0x48(%eax),%eax
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	51                   	push   %ecx
  8011be:	50                   	push   %eax
  8011bf:	68 10 2a 80 00       	push   $0x802a10
  8011c4:	e8 d5 f0 ff ff       	call   80029e <cprintf>
	*dev = 0;
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    
			*dev = devtab[i];
  8011dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011df:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e6:	eb f2                	jmp    8011da <dev_lookup+0x4d>

008011e8 <fd_close>:
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	57                   	push   %edi
  8011ec:	56                   	push   %esi
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 24             	sub    $0x24,%esp
  8011f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801201:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801204:	50                   	push   %eax
  801205:	e8 33 ff ff ff       	call   80113d <fd_lookup>
  80120a:	89 c3                	mov    %eax,%ebx
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	78 05                	js     801218 <fd_close+0x30>
	    || fd != fd2)
  801213:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801216:	74 16                	je     80122e <fd_close+0x46>
		return (must_exist ? r : 0);
  801218:	89 f8                	mov    %edi,%eax
  80121a:	84 c0                	test   %al,%al
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
  801221:	0f 44 d8             	cmove  %eax,%ebx
}
  801224:	89 d8                	mov    %ebx,%eax
  801226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801234:	50                   	push   %eax
  801235:	ff 36                	pushl  (%esi)
  801237:	e8 51 ff ff ff       	call   80118d <dev_lookup>
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 1a                	js     80125f <fd_close+0x77>
		if (dev->dev_close)
  801245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801248:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80124b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801250:	85 c0                	test   %eax,%eax
  801252:	74 0b                	je     80125f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	56                   	push   %esi
  801258:	ff d0                	call   *%eax
  80125a:	89 c3                	mov    %eax,%ebx
  80125c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	56                   	push   %esi
  801263:	6a 00                	push   $0x0
  801265:	e8 0a fc ff ff       	call   800e74 <sys_page_unmap>
	return r;
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	eb b5                	jmp    801224 <fd_close+0x3c>

0080126f <close>:

int
close(int fdnum)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801278:	50                   	push   %eax
  801279:	ff 75 08             	pushl  0x8(%ebp)
  80127c:	e8 bc fe ff ff       	call   80113d <fd_lookup>
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	79 02                	jns    80128a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    
		return fd_close(fd, 1);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	6a 01                	push   $0x1
  80128f:	ff 75 f4             	pushl  -0xc(%ebp)
  801292:	e8 51 ff ff ff       	call   8011e8 <fd_close>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	eb ec                	jmp    801288 <close+0x19>

0080129c <close_all>:

void
close_all(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	e8 be ff ff ff       	call   80126f <close>
	for (i = 0; i < MAXFD; i++)
  8012b1:	83 c3 01             	add    $0x1,%ebx
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	83 fb 20             	cmp    $0x20,%ebx
  8012ba:	75 ec                	jne    8012a8 <close_all+0xc>
}
  8012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	57                   	push   %edi
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 67 fe ff ff       	call   80113d <fd_lookup>
  8012d6:	89 c3                	mov    %eax,%ebx
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 88 81 00 00 00    	js     801364 <dup+0xa3>
		return r;
	close(newfdnum);
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	e8 81 ff ff ff       	call   80126f <close>

	newfd = INDEX2FD(newfdnum);
  8012ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f1:	c1 e6 0c             	shl    $0xc,%esi
  8012f4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012fa:	83 c4 04             	add    $0x4,%esp
  8012fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801300:	e8 cf fd ff ff       	call   8010d4 <fd2data>
  801305:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801307:	89 34 24             	mov    %esi,(%esp)
  80130a:	e8 c5 fd ff ff       	call   8010d4 <fd2data>
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801314:	89 d8                	mov    %ebx,%eax
  801316:	c1 e8 16             	shr    $0x16,%eax
  801319:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801320:	a8 01                	test   $0x1,%al
  801322:	74 11                	je     801335 <dup+0x74>
  801324:	89 d8                	mov    %ebx,%eax
  801326:	c1 e8 0c             	shr    $0xc,%eax
  801329:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801330:	f6 c2 01             	test   $0x1,%dl
  801333:	75 39                	jne    80136e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801335:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801338:	89 d0                	mov    %edx,%eax
  80133a:	c1 e8 0c             	shr    $0xc,%eax
  80133d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801344:	83 ec 0c             	sub    $0xc,%esp
  801347:	25 07 0e 00 00       	and    $0xe07,%eax
  80134c:	50                   	push   %eax
  80134d:	56                   	push   %esi
  80134e:	6a 00                	push   $0x0
  801350:	52                   	push   %edx
  801351:	6a 00                	push   $0x0
  801353:	e8 da fa ff ff       	call   800e32 <sys_page_map>
  801358:	89 c3                	mov    %eax,%ebx
  80135a:	83 c4 20             	add    $0x20,%esp
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 31                	js     801392 <dup+0xd1>
		goto err;

	return newfdnum;
  801361:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801364:	89 d8                	mov    %ebx,%eax
  801366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801369:	5b                   	pop    %ebx
  80136a:	5e                   	pop    %esi
  80136b:	5f                   	pop    %edi
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80136e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	25 07 0e 00 00       	and    $0xe07,%eax
  80137d:	50                   	push   %eax
  80137e:	57                   	push   %edi
  80137f:	6a 00                	push   $0x0
  801381:	53                   	push   %ebx
  801382:	6a 00                	push   $0x0
  801384:	e8 a9 fa ff ff       	call   800e32 <sys_page_map>
  801389:	89 c3                	mov    %eax,%ebx
  80138b:	83 c4 20             	add    $0x20,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	79 a3                	jns    801335 <dup+0x74>
	sys_page_unmap(0, newfd);
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	56                   	push   %esi
  801396:	6a 00                	push   $0x0
  801398:	e8 d7 fa ff ff       	call   800e74 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80139d:	83 c4 08             	add    $0x8,%esp
  8013a0:	57                   	push   %edi
  8013a1:	6a 00                	push   $0x0
  8013a3:	e8 cc fa ff ff       	call   800e74 <sys_page_unmap>
	return r;
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	eb b7                	jmp    801364 <dup+0xa3>

008013ad <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	53                   	push   %ebx
  8013b1:	83 ec 1c             	sub    $0x1c,%esp
  8013b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ba:	50                   	push   %eax
  8013bb:	53                   	push   %ebx
  8013bc:	e8 7c fd ff ff       	call   80113d <fd_lookup>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 3f                	js     801407 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d2:	ff 30                	pushl  (%eax)
  8013d4:	e8 b4 fd ff ff       	call   80118d <dev_lookup>
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 27                	js     801407 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e3:	8b 42 08             	mov    0x8(%edx),%eax
  8013e6:	83 e0 03             	and    $0x3,%eax
  8013e9:	83 f8 01             	cmp    $0x1,%eax
  8013ec:	74 1e                	je     80140c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f1:	8b 40 08             	mov    0x8(%eax),%eax
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	74 35                	je     80142d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	ff 75 10             	pushl  0x10(%ebp)
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	52                   	push   %edx
  801402:	ff d0                	call   *%eax
  801404:	83 c4 10             	add    $0x10,%esp
}
  801407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80140c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801411:	8b 40 48             	mov    0x48(%eax),%eax
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	53                   	push   %ebx
  801418:	50                   	push   %eax
  801419:	68 51 2a 80 00       	push   $0x802a51
  80141e:	e8 7b ee ff ff       	call   80029e <cprintf>
		return -E_INVAL;
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142b:	eb da                	jmp    801407 <read+0x5a>
		return -E_NOT_SUPP;
  80142d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801432:	eb d3                	jmp    801407 <read+0x5a>

00801434 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	57                   	push   %edi
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801440:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801443:	bb 00 00 00 00       	mov    $0x0,%ebx
  801448:	39 f3                	cmp    %esi,%ebx
  80144a:	73 23                	jae    80146f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	89 f0                	mov    %esi,%eax
  801451:	29 d8                	sub    %ebx,%eax
  801453:	50                   	push   %eax
  801454:	89 d8                	mov    %ebx,%eax
  801456:	03 45 0c             	add    0xc(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	57                   	push   %edi
  80145b:	e8 4d ff ff ff       	call   8013ad <read>
		if (m < 0)
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 06                	js     80146d <readn+0x39>
			return m;
		if (m == 0)
  801467:	74 06                	je     80146f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801469:	01 c3                	add    %eax,%ebx
  80146b:	eb db                	jmp    801448 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80146d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80146f:	89 d8                	mov    %ebx,%eax
  801471:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801474:	5b                   	pop    %ebx
  801475:	5e                   	pop    %esi
  801476:	5f                   	pop    %edi
  801477:	5d                   	pop    %ebp
  801478:	c3                   	ret    

00801479 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	53                   	push   %ebx
  80147d:	83 ec 1c             	sub    $0x1c,%esp
  801480:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801483:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	53                   	push   %ebx
  801488:	e8 b0 fc ff ff       	call   80113d <fd_lookup>
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	85 c0                	test   %eax,%eax
  801492:	78 3a                	js     8014ce <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149a:	50                   	push   %eax
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149e:	ff 30                	pushl  (%eax)
  8014a0:	e8 e8 fc ff ff       	call   80118d <dev_lookup>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 22                	js     8014ce <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b3:	74 1e                	je     8014d3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b8:	8b 52 0c             	mov    0xc(%edx),%edx
  8014bb:	85 d2                	test   %edx,%edx
  8014bd:	74 35                	je     8014f4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	ff 75 10             	pushl  0x10(%ebp)
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	50                   	push   %eax
  8014c9:	ff d2                	call   *%edx
  8014cb:	83 c4 10             	add    $0x10,%esp
}
  8014ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8014d8:	8b 40 48             	mov    0x48(%eax),%eax
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	53                   	push   %ebx
  8014df:	50                   	push   %eax
  8014e0:	68 6d 2a 80 00       	push   $0x802a6d
  8014e5:	e8 b4 ed ff ff       	call   80029e <cprintf>
		return -E_INVAL;
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f2:	eb da                	jmp    8014ce <write+0x55>
		return -E_NOT_SUPP;
  8014f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f9:	eb d3                	jmp    8014ce <write+0x55>

008014fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801501:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801504:	50                   	push   %eax
  801505:	ff 75 08             	pushl  0x8(%ebp)
  801508:	e8 30 fc ff ff       	call   80113d <fd_lookup>
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	78 0e                	js     801522 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	53                   	push   %ebx
  801528:	83 ec 1c             	sub    $0x1c,%esp
  80152b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	53                   	push   %ebx
  801533:	e8 05 fc ff ff       	call   80113d <fd_lookup>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 37                	js     801576 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801549:	ff 30                	pushl  (%eax)
  80154b:	e8 3d fc ff ff       	call   80118d <dev_lookup>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 1f                	js     801576 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155e:	74 1b                	je     80157b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801563:	8b 52 18             	mov    0x18(%edx),%edx
  801566:	85 d2                	test   %edx,%edx
  801568:	74 32                	je     80159c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	50                   	push   %eax
  801571:	ff d2                	call   *%edx
  801573:	83 c4 10             	add    $0x10,%esp
}
  801576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801579:	c9                   	leave  
  80157a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80157b:	a1 4c 50 80 00       	mov    0x80504c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801580:	8b 40 48             	mov    0x48(%eax),%eax
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	53                   	push   %ebx
  801587:	50                   	push   %eax
  801588:	68 30 2a 80 00       	push   $0x802a30
  80158d:	e8 0c ed ff ff       	call   80029e <cprintf>
		return -E_INVAL;
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159a:	eb da                	jmp    801576 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80159c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a1:	eb d3                	jmp    801576 <ftruncate+0x52>

008015a3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 1c             	sub    $0x1c,%esp
  8015aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	ff 75 08             	pushl  0x8(%ebp)
  8015b4:	e8 84 fb ff ff       	call   80113d <fd_lookup>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 4b                	js     80160b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c6:	50                   	push   %eax
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	ff 30                	pushl  (%eax)
  8015cc:	e8 bc fb ff ff       	call   80118d <dev_lookup>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 33                	js     80160b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015df:	74 2f                	je     801610 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015e1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015eb:	00 00 00 
	stat->st_isdir = 0;
  8015ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015f5:	00 00 00 
	stat->st_dev = dev;
  8015f8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	53                   	push   %ebx
  801602:	ff 75 f0             	pushl  -0x10(%ebp)
  801605:	ff 50 14             	call   *0x14(%eax)
  801608:	83 c4 10             	add    $0x10,%esp
}
  80160b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    
		return -E_NOT_SUPP;
  801610:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801615:	eb f4                	jmp    80160b <fstat+0x68>

00801617 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	e8 22 02 00 00       	call   80184b <open>
  801629:	89 c3                	mov    %eax,%ebx
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 1b                	js     80164d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	50                   	push   %eax
  801639:	e8 65 ff ff ff       	call   8015a3 <fstat>
  80163e:	89 c6                	mov    %eax,%esi
	close(fd);
  801640:	89 1c 24             	mov    %ebx,(%esp)
  801643:	e8 27 fc ff ff       	call   80126f <close>
	return r;
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	89 f3                	mov    %esi,%ebx
}
  80164d:	89 d8                	mov    %ebx,%eax
  80164f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
  80165b:	89 c6                	mov    %eax,%esi
  80165d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80165f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801666:	74 27                	je     80168f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801668:	6a 07                	push   $0x7
  80166a:	68 00 60 80 00       	push   $0x806000
  80166f:	56                   	push   %esi
  801670:	ff 35 00 40 80 00    	pushl  0x804000
  801676:	e8 69 0c 00 00       	call   8022e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167b:	83 c4 0c             	add    $0xc,%esp
  80167e:	6a 00                	push   $0x0
  801680:	53                   	push   %ebx
  801681:	6a 00                	push   $0x0
  801683:	e8 f3 0b 00 00       	call   80227b <ipc_recv>
}
  801688:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168b:	5b                   	pop    %ebx
  80168c:	5e                   	pop    %esi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	6a 01                	push   $0x1
  801694:	e8 a3 0c 00 00       	call   80233c <ipc_find_env>
  801699:	a3 00 40 80 00       	mov    %eax,0x804000
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	eb c5                	jmp    801668 <fsipc+0x12>

008016a3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8016af:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b7:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8016c6:	e8 8b ff ff ff       	call   801656 <fsipc>
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <devfile_flush>:
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d9:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 06 00 00 00       	mov    $0x6,%eax
  8016e8:	e8 69 ff ff ff       	call   801656 <fsipc>
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <devfile_stat>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ff:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	b8 05 00 00 00       	mov    $0x5,%eax
  80170e:	e8 43 ff ff ff       	call   801656 <fsipc>
  801713:	85 c0                	test   %eax,%eax
  801715:	78 2c                	js     801743 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	68 00 60 80 00       	push   $0x806000
  80171f:	53                   	push   %ebx
  801720:	e8 d8 f2 ff ff       	call   8009fd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801725:	a1 80 60 80 00       	mov    0x806080,%eax
  80172a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801730:	a1 84 60 80 00       	mov    0x806084,%eax
  801735:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <devfile_write>:
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	53                   	push   %ebx
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8b 40 0c             	mov    0xc(%eax),%eax
  801758:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80175d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801763:	53                   	push   %ebx
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	68 08 60 80 00       	push   $0x806008
  80176c:	e8 7c f4 ff ff       	call   800bed <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 04 00 00 00       	mov    $0x4,%eax
  80177b:	e8 d6 fe ff ff       	call   801656 <fsipc>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	85 c0                	test   %eax,%eax
  801785:	78 0b                	js     801792 <devfile_write+0x4a>
	assert(r <= n);
  801787:	39 d8                	cmp    %ebx,%eax
  801789:	77 0c                	ja     801797 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80178b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801790:	7f 1e                	jg     8017b0 <devfile_write+0x68>
}
  801792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801795:	c9                   	leave  
  801796:	c3                   	ret    
	assert(r <= n);
  801797:	68 a0 2a 80 00       	push   $0x802aa0
  80179c:	68 a7 2a 80 00       	push   $0x802aa7
  8017a1:	68 98 00 00 00       	push   $0x98
  8017a6:	68 bc 2a 80 00       	push   $0x802abc
  8017ab:	e8 6a 0a 00 00       	call   80221a <_panic>
	assert(r <= PGSIZE);
  8017b0:	68 c7 2a 80 00       	push   $0x802ac7
  8017b5:	68 a7 2a 80 00       	push   $0x802aa7
  8017ba:	68 99 00 00 00       	push   $0x99
  8017bf:	68 bc 2a 80 00       	push   $0x802abc
  8017c4:	e8 51 0a 00 00       	call   80221a <_panic>

008017c9 <devfile_read>:
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017dc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ec:	e8 65 fe ff ff       	call   801656 <fsipc>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 1f                	js     801816 <devfile_read+0x4d>
	assert(r <= n);
  8017f7:	39 f0                	cmp    %esi,%eax
  8017f9:	77 24                	ja     80181f <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017fb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801800:	7f 33                	jg     801835 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	50                   	push   %eax
  801806:	68 00 60 80 00       	push   $0x806000
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	e8 78 f3 ff ff       	call   800b8b <memmove>
	return r;
  801813:	83 c4 10             	add    $0x10,%esp
}
  801816:	89 d8                	mov    %ebx,%eax
  801818:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181b:	5b                   	pop    %ebx
  80181c:	5e                   	pop    %esi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    
	assert(r <= n);
  80181f:	68 a0 2a 80 00       	push   $0x802aa0
  801824:	68 a7 2a 80 00       	push   $0x802aa7
  801829:	6a 7c                	push   $0x7c
  80182b:	68 bc 2a 80 00       	push   $0x802abc
  801830:	e8 e5 09 00 00       	call   80221a <_panic>
	assert(r <= PGSIZE);
  801835:	68 c7 2a 80 00       	push   $0x802ac7
  80183a:	68 a7 2a 80 00       	push   $0x802aa7
  80183f:	6a 7d                	push   $0x7d
  801841:	68 bc 2a 80 00       	push   $0x802abc
  801846:	e8 cf 09 00 00       	call   80221a <_panic>

0080184b <open>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	83 ec 1c             	sub    $0x1c,%esp
  801853:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801856:	56                   	push   %esi
  801857:	e8 68 f1 ff ff       	call   8009c4 <strlen>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801864:	7f 6c                	jg     8018d2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801866:	83 ec 0c             	sub    $0xc,%esp
  801869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186c:	50                   	push   %eax
  80186d:	e8 79 f8 ff ff       	call   8010eb <fd_alloc>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 3c                	js     8018b7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80187b:	83 ec 08             	sub    $0x8,%esp
  80187e:	56                   	push   %esi
  80187f:	68 00 60 80 00       	push   $0x806000
  801884:	e8 74 f1 ff ff       	call   8009fd <strcpy>
	fsipcbuf.open.req_omode = mode;
  801889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801894:	b8 01 00 00 00       	mov    $0x1,%eax
  801899:	e8 b8 fd ff ff       	call   801656 <fsipc>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 19                	js     8018c0 <open+0x75>
	return fd2num(fd);
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ad:	e8 12 f8 ff ff       	call   8010c4 <fd2num>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	83 c4 10             	add    $0x10,%esp
}
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    
		fd_close(fd, 0);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	e8 1b f9 ff ff       	call   8011e8 <fd_close>
		return r;
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	eb e5                	jmp    8018b7 <open+0x6c>
		return -E_BAD_PATH;
  8018d2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018d7:	eb de                	jmp    8018b7 <open+0x6c>

008018d9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8018e9:	e8 68 fd ff ff       	call   801656 <fsipc>
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018f6:	68 d3 2a 80 00       	push   $0x802ad3
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	e8 fa f0 ff ff       	call   8009fd <strcpy>
	return 0;
}
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <devsock_close>:
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 10             	sub    $0x10,%esp
  801911:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801914:	53                   	push   %ebx
  801915:	e8 5d 0a 00 00       	call   802377 <pageref>
  80191a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801922:	83 f8 01             	cmp    $0x1,%eax
  801925:	74 07                	je     80192e <devsock_close+0x24>
}
  801927:	89 d0                	mov    %edx,%eax
  801929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	ff 73 0c             	pushl  0xc(%ebx)
  801934:	e8 b9 02 00 00       	call   801bf2 <nsipc_close>
  801939:	89 c2                	mov    %eax,%edx
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	eb e7                	jmp    801927 <devsock_close+0x1d>

00801940 <devsock_write>:
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801946:	6a 00                	push   $0x0
  801948:	ff 75 10             	pushl  0x10(%ebp)
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	ff 70 0c             	pushl  0xc(%eax)
  801954:	e8 76 03 00 00       	call   801ccf <nsipc_send>
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <devsock_read>:
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801961:	6a 00                	push   $0x0
  801963:	ff 75 10             	pushl  0x10(%ebp)
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	ff 70 0c             	pushl  0xc(%eax)
  80196f:	e8 ef 02 00 00       	call   801c63 <nsipc_recv>
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <fd2sockid>:
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80197c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	e8 b7 f7 ff ff       	call   80113d <fd_lookup>
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 10                	js     80199d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801990:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801996:	39 08                	cmp    %ecx,(%eax)
  801998:	75 05                	jne    80199f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80199a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    
		return -E_NOT_SUPP;
  80199f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a4:	eb f7                	jmp    80199d <fd2sockid+0x27>

008019a6 <alloc_sockfd>:
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	56                   	push   %esi
  8019aa:	53                   	push   %ebx
  8019ab:	83 ec 1c             	sub    $0x1c,%esp
  8019ae:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b3:	50                   	push   %eax
  8019b4:	e8 32 f7 ff ff       	call   8010eb <fd_alloc>
  8019b9:	89 c3                	mov    %eax,%ebx
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 43                	js     801a05 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	68 07 04 00 00       	push   $0x407
  8019ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cd:	6a 00                	push   $0x0
  8019cf:	e8 1b f4 ff ff       	call   800def <sys_page_alloc>
  8019d4:	89 c3                	mov    %eax,%ebx
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 28                	js     801a05 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019e6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019f2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	50                   	push   %eax
  8019f9:	e8 c6 f6 ff ff       	call   8010c4 <fd2num>
  8019fe:	89 c3                	mov    %eax,%ebx
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	eb 0c                	jmp    801a11 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a05:	83 ec 0c             	sub    $0xc,%esp
  801a08:	56                   	push   %esi
  801a09:	e8 e4 01 00 00       	call   801bf2 <nsipc_close>
		return r;
  801a0e:	83 c4 10             	add    $0x10,%esp
}
  801a11:	89 d8                	mov    %ebx,%eax
  801a13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a16:	5b                   	pop    %ebx
  801a17:	5e                   	pop    %esi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <accept>:
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	e8 4e ff ff ff       	call   801976 <fd2sockid>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 1b                	js     801a47 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	ff 75 10             	pushl  0x10(%ebp)
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	50                   	push   %eax
  801a36:	e8 0e 01 00 00       	call   801b49 <nsipc_accept>
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 05                	js     801a47 <accept+0x2d>
	return alloc_sockfd(r);
  801a42:	e8 5f ff ff ff       	call   8019a6 <alloc_sockfd>
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <bind>:
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	e8 1f ff ff ff       	call   801976 <fd2sockid>
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 12                	js     801a6d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	ff 75 10             	pushl  0x10(%ebp)
  801a61:	ff 75 0c             	pushl  0xc(%ebp)
  801a64:	50                   	push   %eax
  801a65:	e8 31 01 00 00       	call   801b9b <nsipc_bind>
  801a6a:	83 c4 10             	add    $0x10,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <shutdown>:
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	e8 f9 fe ff ff       	call   801976 <fd2sockid>
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 0f                	js     801a90 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	50                   	push   %eax
  801a88:	e8 43 01 00 00       	call   801bd0 <nsipc_shutdown>
  801a8d:	83 c4 10             	add    $0x10,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <connect>:
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	e8 d6 fe ff ff       	call   801976 <fd2sockid>
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 12                	js     801ab6 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	ff 75 10             	pushl  0x10(%ebp)
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	50                   	push   %eax
  801aae:	e8 59 01 00 00       	call   801c0c <nsipc_connect>
  801ab3:	83 c4 10             	add    $0x10,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <listen>:
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	e8 b0 fe ff ff       	call   801976 <fd2sockid>
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 0f                	js     801ad9 <listen+0x21>
	return nsipc_listen(r, backlog);
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	50                   	push   %eax
  801ad1:	e8 6b 01 00 00       	call   801c41 <nsipc_listen>
  801ad6:	83 c4 10             	add    $0x10,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <socket>:

int
socket(int domain, int type, int protocol)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ae1:	ff 75 10             	pushl  0x10(%ebp)
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	ff 75 08             	pushl  0x8(%ebp)
  801aea:	e8 3e 02 00 00       	call   801d2d <nsipc_socket>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 05                	js     801afb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801af6:	e8 ab fe ff ff       	call   8019a6 <alloc_sockfd>
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	53                   	push   %ebx
  801b01:	83 ec 04             	sub    $0x4,%esp
  801b04:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b06:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b0d:	74 26                	je     801b35 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b0f:	6a 07                	push   $0x7
  801b11:	68 00 70 80 00       	push   $0x807000
  801b16:	53                   	push   %ebx
  801b17:	ff 35 04 40 80 00    	pushl  0x804004
  801b1d:	e8 c2 07 00 00       	call   8022e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b22:	83 c4 0c             	add    $0xc,%esp
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 4b 07 00 00       	call   80227b <ipc_recv>
}
  801b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	6a 02                	push   $0x2
  801b3a:	e8 fd 07 00 00       	call   80233c <ipc_find_env>
  801b3f:	a3 04 40 80 00       	mov    %eax,0x804004
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	eb c6                	jmp    801b0f <nsipc+0x12>

00801b49 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
  801b4e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b59:	8b 06                	mov    (%esi),%eax
  801b5b:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b60:	b8 01 00 00 00       	mov    $0x1,%eax
  801b65:	e8 93 ff ff ff       	call   801afd <nsipc>
  801b6a:	89 c3                	mov    %eax,%ebx
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	79 09                	jns    801b79 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b70:	89 d8                	mov    %ebx,%eax
  801b72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b75:	5b                   	pop    %ebx
  801b76:	5e                   	pop    %esi
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b79:	83 ec 04             	sub    $0x4,%esp
  801b7c:	ff 35 10 70 80 00    	pushl  0x807010
  801b82:	68 00 70 80 00       	push   $0x807000
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	e8 fc ef ff ff       	call   800b8b <memmove>
		*addrlen = ret->ret_addrlen;
  801b8f:	a1 10 70 80 00       	mov    0x807010,%eax
  801b94:	89 06                	mov    %eax,(%esi)
  801b96:	83 c4 10             	add    $0x10,%esp
	return r;
  801b99:	eb d5                	jmp    801b70 <nsipc_accept+0x27>

00801b9b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	53                   	push   %ebx
  801b9f:	83 ec 08             	sub    $0x8,%esp
  801ba2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bad:	53                   	push   %ebx
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	68 04 70 80 00       	push   $0x807004
  801bb6:	e8 d0 ef ff ff       	call   800b8b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bbb:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801bc1:	b8 02 00 00 00       	mov    $0x2,%eax
  801bc6:	e8 32 ff ff ff       	call   801afd <nsipc>
}
  801bcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801be6:	b8 03 00 00 00       	mov    $0x3,%eax
  801beb:	e8 0d ff ff ff       	call   801afd <nsipc>
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <nsipc_close>:

int
nsipc_close(int s)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801c00:	b8 04 00 00 00       	mov    $0x4,%eax
  801c05:	e8 f3 fe ff ff       	call   801afd <nsipc>
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 08             	sub    $0x8,%esp
  801c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c1e:	53                   	push   %ebx
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	68 04 70 80 00       	push   $0x807004
  801c27:	e8 5f ef ff ff       	call   800b8b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c2c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801c32:	b8 05 00 00 00       	mov    $0x5,%eax
  801c37:	e8 c1 fe ff ff       	call   801afd <nsipc>
}
  801c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c52:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801c57:	b8 06 00 00 00       	mov    $0x6,%eax
  801c5c:	e8 9c fe ff ff       	call   801afd <nsipc>
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
  801c68:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801c73:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801c79:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c81:	b8 07 00 00 00       	mov    $0x7,%eax
  801c86:	e8 72 fe ff ff       	call   801afd <nsipc>
  801c8b:	89 c3                	mov    %eax,%ebx
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	78 1f                	js     801cb0 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c91:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c96:	7f 21                	jg     801cb9 <nsipc_recv+0x56>
  801c98:	39 c6                	cmp    %eax,%esi
  801c9a:	7c 1d                	jl     801cb9 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	50                   	push   %eax
  801ca0:	68 00 70 80 00       	push   $0x807000
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	e8 de ee ff ff       	call   800b8b <memmove>
  801cad:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cb0:	89 d8                	mov    %ebx,%eax
  801cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cb9:	68 df 2a 80 00       	push   $0x802adf
  801cbe:	68 a7 2a 80 00       	push   $0x802aa7
  801cc3:	6a 62                	push   $0x62
  801cc5:	68 f4 2a 80 00       	push   $0x802af4
  801cca:	e8 4b 05 00 00       	call   80221a <_panic>

00801ccf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801ce1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ce7:	7f 2e                	jg     801d17 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	53                   	push   %ebx
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	68 0c 70 80 00       	push   $0x80700c
  801cf5:	e8 91 ee ff ff       	call   800b8b <memmove>
	nsipcbuf.send.req_size = size;
  801cfa:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801d00:	8b 45 14             	mov    0x14(%ebp),%eax
  801d03:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801d08:	b8 08 00 00 00       	mov    $0x8,%eax
  801d0d:	e8 eb fd ff ff       	call   801afd <nsipc>
}
  801d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    
	assert(size < 1600);
  801d17:	68 00 2b 80 00       	push   $0x802b00
  801d1c:	68 a7 2a 80 00       	push   $0x802aa7
  801d21:	6a 6d                	push   $0x6d
  801d23:	68 f4 2a 80 00       	push   $0x802af4
  801d28:	e8 ed 04 00 00       	call   80221a <_panic>

00801d2d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801d43:	8b 45 10             	mov    0x10(%ebp),%eax
  801d46:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801d4b:	b8 09 00 00 00       	mov    $0x9,%eax
  801d50:	e8 a8 fd ff ff       	call   801afd <nsipc>
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	56                   	push   %esi
  801d5b:	53                   	push   %ebx
  801d5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	e8 6a f3 ff ff       	call   8010d4 <fd2data>
  801d6a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d6c:	83 c4 08             	add    $0x8,%esp
  801d6f:	68 0c 2b 80 00       	push   $0x802b0c
  801d74:	53                   	push   %ebx
  801d75:	e8 83 ec ff ff       	call   8009fd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d7a:	8b 46 04             	mov    0x4(%esi),%eax
  801d7d:	2b 06                	sub    (%esi),%eax
  801d7f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d85:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d8c:	00 00 00 
	stat->st_dev = &devpipe;
  801d8f:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d96:	30 80 00 
	return 0;
}
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    

00801da5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	53                   	push   %ebx
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801daf:	53                   	push   %ebx
  801db0:	6a 00                	push   $0x0
  801db2:	e8 bd f0 ff ff       	call   800e74 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801db7:	89 1c 24             	mov    %ebx,(%esp)
  801dba:	e8 15 f3 ff ff       	call   8010d4 <fd2data>
  801dbf:	83 c4 08             	add    $0x8,%esp
  801dc2:	50                   	push   %eax
  801dc3:	6a 00                	push   $0x0
  801dc5:	e8 aa f0 ff ff       	call   800e74 <sys_page_unmap>
}
  801dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <_pipeisclosed>:
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	57                   	push   %edi
  801dd3:	56                   	push   %esi
  801dd4:	53                   	push   %ebx
  801dd5:	83 ec 1c             	sub    $0x1c,%esp
  801dd8:	89 c7                	mov    %eax,%edi
  801dda:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ddc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801de1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	57                   	push   %edi
  801de8:	e8 8a 05 00 00       	call   802377 <pageref>
  801ded:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801df0:	89 34 24             	mov    %esi,(%esp)
  801df3:	e8 7f 05 00 00       	call   802377 <pageref>
		nn = thisenv->env_runs;
  801df8:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  801dfe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	39 cb                	cmp    %ecx,%ebx
  801e06:	74 1b                	je     801e23 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e08:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e0b:	75 cf                	jne    801ddc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e0d:	8b 42 58             	mov    0x58(%edx),%eax
  801e10:	6a 01                	push   $0x1
  801e12:	50                   	push   %eax
  801e13:	53                   	push   %ebx
  801e14:	68 13 2b 80 00       	push   $0x802b13
  801e19:	e8 80 e4 ff ff       	call   80029e <cprintf>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	eb b9                	jmp    801ddc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e23:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e26:	0f 94 c0             	sete   %al
  801e29:	0f b6 c0             	movzbl %al,%eax
}
  801e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    

00801e34 <devpipe_write>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	57                   	push   %edi
  801e38:	56                   	push   %esi
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 28             	sub    $0x28,%esp
  801e3d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e40:	56                   	push   %esi
  801e41:	e8 8e f2 ff ff       	call   8010d4 <fd2data>
  801e46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e50:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e53:	74 4f                	je     801ea4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e55:	8b 43 04             	mov    0x4(%ebx),%eax
  801e58:	8b 0b                	mov    (%ebx),%ecx
  801e5a:	8d 51 20             	lea    0x20(%ecx),%edx
  801e5d:	39 d0                	cmp    %edx,%eax
  801e5f:	72 14                	jb     801e75 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	89 f0                	mov    %esi,%eax
  801e65:	e8 65 ff ff ff       	call   801dcf <_pipeisclosed>
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	75 3b                	jne    801ea9 <devpipe_write+0x75>
			sys_yield();
  801e6e:	e8 5d ef ff ff       	call   800dd0 <sys_yield>
  801e73:	eb e0                	jmp    801e55 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e78:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e7c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	c1 fa 1f             	sar    $0x1f,%edx
  801e84:	89 d1                	mov    %edx,%ecx
  801e86:	c1 e9 1b             	shr    $0x1b,%ecx
  801e89:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e8c:	83 e2 1f             	and    $0x1f,%edx
  801e8f:	29 ca                	sub    %ecx,%edx
  801e91:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e95:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e99:	83 c0 01             	add    $0x1,%eax
  801e9c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e9f:	83 c7 01             	add    $0x1,%edi
  801ea2:	eb ac                	jmp    801e50 <devpipe_write+0x1c>
	return i;
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	eb 05                	jmp    801eae <devpipe_write+0x7a>
				return 0;
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <devpipe_read>:
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	57                   	push   %edi
  801eba:	56                   	push   %esi
  801ebb:	53                   	push   %ebx
  801ebc:	83 ec 18             	sub    $0x18,%esp
  801ebf:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ec2:	57                   	push   %edi
  801ec3:	e8 0c f2 ff ff       	call   8010d4 <fd2data>
  801ec8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	be 00 00 00 00       	mov    $0x0,%esi
  801ed2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ed5:	75 14                	jne    801eeb <devpipe_read+0x35>
	return i;
  801ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eda:	eb 02                	jmp    801ede <devpipe_read+0x28>
				return i;
  801edc:	89 f0                	mov    %esi,%eax
}
  801ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5f                   	pop    %edi
  801ee4:	5d                   	pop    %ebp
  801ee5:	c3                   	ret    
			sys_yield();
  801ee6:	e8 e5 ee ff ff       	call   800dd0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eeb:	8b 03                	mov    (%ebx),%eax
  801eed:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ef0:	75 18                	jne    801f0a <devpipe_read+0x54>
			if (i > 0)
  801ef2:	85 f6                	test   %esi,%esi
  801ef4:	75 e6                	jne    801edc <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ef6:	89 da                	mov    %ebx,%edx
  801ef8:	89 f8                	mov    %edi,%eax
  801efa:	e8 d0 fe ff ff       	call   801dcf <_pipeisclosed>
  801eff:	85 c0                	test   %eax,%eax
  801f01:	74 e3                	je     801ee6 <devpipe_read+0x30>
				return 0;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	eb d4                	jmp    801ede <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f0a:	99                   	cltd   
  801f0b:	c1 ea 1b             	shr    $0x1b,%edx
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	83 e0 1f             	and    $0x1f,%eax
  801f13:	29 d0                	sub    %edx,%eax
  801f15:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f1d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f20:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f23:	83 c6 01             	add    $0x1,%esi
  801f26:	eb aa                	jmp    801ed2 <devpipe_read+0x1c>

00801f28 <pipe>:
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f33:	50                   	push   %eax
  801f34:	e8 b2 f1 ff ff       	call   8010eb <fd_alloc>
  801f39:	89 c3                	mov    %eax,%ebx
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	0f 88 23 01 00 00    	js     802069 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f46:	83 ec 04             	sub    $0x4,%esp
  801f49:	68 07 04 00 00       	push   $0x407
  801f4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f51:	6a 00                	push   $0x0
  801f53:	e8 97 ee ff ff       	call   800def <sys_page_alloc>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	0f 88 04 01 00 00    	js     802069 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f6b:	50                   	push   %eax
  801f6c:	e8 7a f1 ff ff       	call   8010eb <fd_alloc>
  801f71:	89 c3                	mov    %eax,%ebx
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	85 c0                	test   %eax,%eax
  801f78:	0f 88 db 00 00 00    	js     802059 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	68 07 04 00 00       	push   $0x407
  801f86:	ff 75 f0             	pushl  -0x10(%ebp)
  801f89:	6a 00                	push   $0x0
  801f8b:	e8 5f ee ff ff       	call   800def <sys_page_alloc>
  801f90:	89 c3                	mov    %eax,%ebx
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	0f 88 bc 00 00 00    	js     802059 <pipe+0x131>
	va = fd2data(fd0);
  801f9d:	83 ec 0c             	sub    $0xc,%esp
  801fa0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa3:	e8 2c f1 ff ff       	call   8010d4 <fd2data>
  801fa8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801faa:	83 c4 0c             	add    $0xc,%esp
  801fad:	68 07 04 00 00       	push   $0x407
  801fb2:	50                   	push   %eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 35 ee ff ff       	call   800def <sys_page_alloc>
  801fba:	89 c3                	mov    %eax,%ebx
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	0f 88 82 00 00 00    	js     802049 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcd:	e8 02 f1 ff ff       	call   8010d4 <fd2data>
  801fd2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fd9:	50                   	push   %eax
  801fda:	6a 00                	push   $0x0
  801fdc:	56                   	push   %esi
  801fdd:	6a 00                	push   $0x0
  801fdf:	e8 4e ee ff ff       	call   800e32 <sys_page_map>
  801fe4:	89 c3                	mov    %eax,%ebx
  801fe6:	83 c4 20             	add    $0x20,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 4e                	js     80203b <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fed:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffa:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802001:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802004:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802009:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	ff 75 f4             	pushl  -0xc(%ebp)
  802016:	e8 a9 f0 ff ff       	call   8010c4 <fd2num>
  80201b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802020:	83 c4 04             	add    $0x4,%esp
  802023:	ff 75 f0             	pushl  -0x10(%ebp)
  802026:	e8 99 f0 ff ff       	call   8010c4 <fd2num>
  80202b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80202e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	bb 00 00 00 00       	mov    $0x0,%ebx
  802039:	eb 2e                	jmp    802069 <pipe+0x141>
	sys_page_unmap(0, va);
  80203b:	83 ec 08             	sub    $0x8,%esp
  80203e:	56                   	push   %esi
  80203f:	6a 00                	push   $0x0
  802041:	e8 2e ee ff ff       	call   800e74 <sys_page_unmap>
  802046:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802049:	83 ec 08             	sub    $0x8,%esp
  80204c:	ff 75 f0             	pushl  -0x10(%ebp)
  80204f:	6a 00                	push   $0x0
  802051:	e8 1e ee ff ff       	call   800e74 <sys_page_unmap>
  802056:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802059:	83 ec 08             	sub    $0x8,%esp
  80205c:	ff 75 f4             	pushl  -0xc(%ebp)
  80205f:	6a 00                	push   $0x0
  802061:	e8 0e ee ff ff       	call   800e74 <sys_page_unmap>
  802066:	83 c4 10             	add    $0x10,%esp
}
  802069:	89 d8                	mov    %ebx,%eax
  80206b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206e:	5b                   	pop    %ebx
  80206f:	5e                   	pop    %esi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    

00802072 <pipeisclosed>:
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802078:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80207b:	50                   	push   %eax
  80207c:	ff 75 08             	pushl  0x8(%ebp)
  80207f:	e8 b9 f0 ff ff       	call   80113d <fd_lookup>
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	85 c0                	test   %eax,%eax
  802089:	78 18                	js     8020a3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	ff 75 f4             	pushl  -0xc(%ebp)
  802091:	e8 3e f0 ff ff       	call   8010d4 <fd2data>
	return _pipeisclosed(fd, p);
  802096:	89 c2                	mov    %eax,%edx
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	e8 2f fd ff ff       	call   801dcf <_pipeisclosed>
  8020a0:	83 c4 10             	add    $0x10,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020aa:	c3                   	ret    

008020ab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020b1:	68 2b 2b 80 00       	push   $0x802b2b
  8020b6:	ff 75 0c             	pushl  0xc(%ebp)
  8020b9:	e8 3f e9 ff ff       	call   8009fd <strcpy>
	return 0;
}
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <devcons_write>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	57                   	push   %edi
  8020c9:	56                   	push   %esi
  8020ca:	53                   	push   %ebx
  8020cb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020d1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020dc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020df:	73 31                	jae    802112 <devcons_write+0x4d>
		m = n - tot;
  8020e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020e4:	29 f3                	sub    %esi,%ebx
  8020e6:	83 fb 7f             	cmp    $0x7f,%ebx
  8020e9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ee:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	53                   	push   %ebx
  8020f5:	89 f0                	mov    %esi,%eax
  8020f7:	03 45 0c             	add    0xc(%ebp),%eax
  8020fa:	50                   	push   %eax
  8020fb:	57                   	push   %edi
  8020fc:	e8 8a ea ff ff       	call   800b8b <memmove>
		sys_cputs(buf, m);
  802101:	83 c4 08             	add    $0x8,%esp
  802104:	53                   	push   %ebx
  802105:	57                   	push   %edi
  802106:	e8 28 ec ff ff       	call   800d33 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80210b:	01 de                	add    %ebx,%esi
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	eb ca                	jmp    8020dc <devcons_write+0x17>
}
  802112:	89 f0                	mov    %esi,%eax
  802114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    

0080211c <devcons_read>:
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 08             	sub    $0x8,%esp
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802127:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80212b:	74 21                	je     80214e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80212d:	e8 1f ec ff ff       	call   800d51 <sys_cgetc>
  802132:	85 c0                	test   %eax,%eax
  802134:	75 07                	jne    80213d <devcons_read+0x21>
		sys_yield();
  802136:	e8 95 ec ff ff       	call   800dd0 <sys_yield>
  80213b:	eb f0                	jmp    80212d <devcons_read+0x11>
	if (c < 0)
  80213d:	78 0f                	js     80214e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80213f:	83 f8 04             	cmp    $0x4,%eax
  802142:	74 0c                	je     802150 <devcons_read+0x34>
	*(char*)vbuf = c;
  802144:	8b 55 0c             	mov    0xc(%ebp),%edx
  802147:	88 02                	mov    %al,(%edx)
	return 1;
  802149:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    
		return 0;
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
  802155:	eb f7                	jmp    80214e <devcons_read+0x32>

00802157 <cputchar>:
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802163:	6a 01                	push   $0x1
  802165:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802168:	50                   	push   %eax
  802169:	e8 c5 eb ff ff       	call   800d33 <sys_cputs>
}
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <getchar>:
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802179:	6a 01                	push   $0x1
  80217b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80217e:	50                   	push   %eax
  80217f:	6a 00                	push   $0x0
  802181:	e8 27 f2 ff ff       	call   8013ad <read>
	if (r < 0)
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	85 c0                	test   %eax,%eax
  80218b:	78 06                	js     802193 <getchar+0x20>
	if (r < 1)
  80218d:	74 06                	je     802195 <getchar+0x22>
	return c;
  80218f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    
		return -E_EOF;
  802195:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80219a:	eb f7                	jmp    802193 <getchar+0x20>

0080219c <iscons>:
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a5:	50                   	push   %eax
  8021a6:	ff 75 08             	pushl  0x8(%ebp)
  8021a9:	e8 8f ef ff ff       	call   80113d <fd_lookup>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	78 11                	js     8021c6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021be:	39 10                	cmp    %edx,(%eax)
  8021c0:	0f 94 c0             	sete   %al
  8021c3:	0f b6 c0             	movzbl %al,%eax
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <opencons>:
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d1:	50                   	push   %eax
  8021d2:	e8 14 ef ff ff       	call   8010eb <fd_alloc>
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 3a                	js     802218 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	68 07 04 00 00       	push   $0x407
  8021e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e9:	6a 00                	push   $0x0
  8021eb:	e8 ff eb ff ff       	call   800def <sys_page_alloc>
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	78 21                	js     802218 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802200:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80220c:	83 ec 0c             	sub    $0xc,%esp
  80220f:	50                   	push   %eax
  802210:	e8 af ee ff ff       	call   8010c4 <fd2num>
  802215:	83 c4 10             	add    $0x10,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	56                   	push   %esi
  80221e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80221f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802224:	8b 40 48             	mov    0x48(%eax),%eax
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	68 68 2b 80 00       	push   $0x802b68
  80222f:	50                   	push   %eax
  802230:	68 37 2b 80 00       	push   $0x802b37
  802235:	e8 64 e0 ff ff       	call   80029e <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80223a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80223d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802243:	e8 69 eb ff ff       	call   800db1 <sys_getenvid>
  802248:	83 c4 04             	add    $0x4,%esp
  80224b:	ff 75 0c             	pushl  0xc(%ebp)
  80224e:	ff 75 08             	pushl  0x8(%ebp)
  802251:	56                   	push   %esi
  802252:	50                   	push   %eax
  802253:	68 44 2b 80 00       	push   $0x802b44
  802258:	e8 41 e0 ff ff       	call   80029e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80225d:	83 c4 18             	add    $0x18,%esp
  802260:	53                   	push   %ebx
  802261:	ff 75 10             	pushl  0x10(%ebp)
  802264:	e8 e4 df ff ff       	call   80024d <vcprintf>
	cprintf("\n");
  802269:	c7 04 24 64 26 80 00 	movl   $0x802664,(%esp)
  802270:	e8 29 e0 ff ff       	call   80029e <cprintf>
  802275:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802278:	cc                   	int3   
  802279:	eb fd                	jmp    802278 <_panic+0x5e>

0080227b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	8b 75 08             	mov    0x8(%ebp),%esi
  802283:	8b 45 0c             	mov    0xc(%ebp),%eax
  802286:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802289:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80228b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802290:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	50                   	push   %eax
  802297:	e8 03 ed ff ff       	call   800f9f <sys_ipc_recv>
	if(ret < 0){
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 2b                	js     8022ce <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022a3:	85 f6                	test   %esi,%esi
  8022a5:	74 0a                	je     8022b1 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ac:	8b 40 74             	mov    0x74(%eax),%eax
  8022af:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022b1:	85 db                	test   %ebx,%ebx
  8022b3:	74 0a                	je     8022bf <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8022b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ba:	8b 40 78             	mov    0x78(%eax),%eax
  8022bd:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8022bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022c4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    
		if(from_env_store)
  8022ce:	85 f6                	test   %esi,%esi
  8022d0:	74 06                	je     8022d8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022d8:	85 db                	test   %ebx,%ebx
  8022da:	74 eb                	je     8022c7 <ipc_recv+0x4c>
			*perm_store = 0;
  8022dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022e2:	eb e3                	jmp    8022c7 <ipc_recv+0x4c>

008022e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	57                   	push   %edi
  8022e8:	56                   	push   %esi
  8022e9:	53                   	push   %ebx
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022f6:	85 db                	test   %ebx,%ebx
  8022f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022fd:	0f 44 d8             	cmove  %eax,%ebx
  802300:	eb 05                	jmp    802307 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802302:	e8 c9 ea ff ff       	call   800dd0 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802307:	ff 75 14             	pushl  0x14(%ebp)
  80230a:	53                   	push   %ebx
  80230b:	56                   	push   %esi
  80230c:	57                   	push   %edi
  80230d:	e8 6a ec ff ff       	call   800f7c <sys_ipc_try_send>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	74 1b                	je     802334 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802319:	79 e7                	jns    802302 <ipc_send+0x1e>
  80231b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80231e:	74 e2                	je     802302 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 6f 2b 80 00       	push   $0x802b6f
  802328:	6a 48                	push   $0x48
  80232a:	68 84 2b 80 00       	push   $0x802b84
  80232f:	e8 e6 fe ff ff       	call   80221a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802347:	89 c2                	mov    %eax,%edx
  802349:	c1 e2 07             	shl    $0x7,%edx
  80234c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802352:	8b 52 50             	mov    0x50(%edx),%edx
  802355:	39 ca                	cmp    %ecx,%edx
  802357:	74 11                	je     80236a <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802359:	83 c0 01             	add    $0x1,%eax
  80235c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802361:	75 e4                	jne    802347 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	eb 0b                	jmp    802375 <ipc_find_env+0x39>
			return envs[i].env_id;
  80236a:	c1 e0 07             	shl    $0x7,%eax
  80236d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802372:	8b 40 48             	mov    0x48(%eax),%eax
}
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    

00802377 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80237d:	89 d0                	mov    %edx,%eax
  80237f:	c1 e8 16             	shr    $0x16,%eax
  802382:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80238e:	f6 c1 01             	test   $0x1,%cl
  802391:	74 1d                	je     8023b0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802393:	c1 ea 0c             	shr    $0xc,%edx
  802396:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80239d:	f6 c2 01             	test   $0x1,%dl
  8023a0:	74 0e                	je     8023b0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023a2:	c1 ea 0c             	shr    $0xc,%edx
  8023a5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023ac:	ef 
  8023ad:	0f b7 c0             	movzwl %ax,%eax
}
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
  8023b2:	66 90                	xchg   %ax,%ax
  8023b4:	66 90                	xchg   %ax,%ax
  8023b6:	66 90                	xchg   %ax,%ax
  8023b8:	66 90                	xchg   %ax,%ax
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__udivdi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023d7:	85 d2                	test   %edx,%edx
  8023d9:	75 4d                	jne    802428 <__udivdi3+0x68>
  8023db:	39 f3                	cmp    %esi,%ebx
  8023dd:	76 19                	jbe    8023f8 <__udivdi3+0x38>
  8023df:	31 ff                	xor    %edi,%edi
  8023e1:	89 e8                	mov    %ebp,%eax
  8023e3:	89 f2                	mov    %esi,%edx
  8023e5:	f7 f3                	div    %ebx
  8023e7:	89 fa                	mov    %edi,%edx
  8023e9:	83 c4 1c             	add    $0x1c,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 d9                	mov    %ebx,%ecx
  8023fa:	85 db                	test   %ebx,%ebx
  8023fc:	75 0b                	jne    802409 <__udivdi3+0x49>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f3                	div    %ebx
  802407:	89 c1                	mov    %eax,%ecx
  802409:	31 d2                	xor    %edx,%edx
  80240b:	89 f0                	mov    %esi,%eax
  80240d:	f7 f1                	div    %ecx
  80240f:	89 c6                	mov    %eax,%esi
  802411:	89 e8                	mov    %ebp,%eax
  802413:	89 f7                	mov    %esi,%edi
  802415:	f7 f1                	div    %ecx
  802417:	89 fa                	mov    %edi,%edx
  802419:	83 c4 1c             	add    $0x1c,%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
  802421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	77 1c                	ja     802448 <__udivdi3+0x88>
  80242c:	0f bd fa             	bsr    %edx,%edi
  80242f:	83 f7 1f             	xor    $0x1f,%edi
  802432:	75 2c                	jne    802460 <__udivdi3+0xa0>
  802434:	39 f2                	cmp    %esi,%edx
  802436:	72 06                	jb     80243e <__udivdi3+0x7e>
  802438:	31 c0                	xor    %eax,%eax
  80243a:	39 eb                	cmp    %ebp,%ebx
  80243c:	77 a9                	ja     8023e7 <__udivdi3+0x27>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	eb a2                	jmp    8023e7 <__udivdi3+0x27>
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	31 ff                	xor    %edi,%edi
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	89 fa                	mov    %edi,%edx
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	89 f9                	mov    %edi,%ecx
  802462:	b8 20 00 00 00       	mov    $0x20,%eax
  802467:	29 f8                	sub    %edi,%eax
  802469:	d3 e2                	shl    %cl,%edx
  80246b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80246f:	89 c1                	mov    %eax,%ecx
  802471:	89 da                	mov    %ebx,%edx
  802473:	d3 ea                	shr    %cl,%edx
  802475:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802479:	09 d1                	or     %edx,%ecx
  80247b:	89 f2                	mov    %esi,%edx
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 f9                	mov    %edi,%ecx
  802483:	d3 e3                	shl    %cl,%ebx
  802485:	89 c1                	mov    %eax,%ecx
  802487:	d3 ea                	shr    %cl,%edx
  802489:	89 f9                	mov    %edi,%ecx
  80248b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80248f:	89 eb                	mov    %ebp,%ebx
  802491:	d3 e6                	shl    %cl,%esi
  802493:	89 c1                	mov    %eax,%ecx
  802495:	d3 eb                	shr    %cl,%ebx
  802497:	09 de                	or     %ebx,%esi
  802499:	89 f0                	mov    %esi,%eax
  80249b:	f7 74 24 08          	divl   0x8(%esp)
  80249f:	89 d6                	mov    %edx,%esi
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	f7 64 24 0c          	mull   0xc(%esp)
  8024a7:	39 d6                	cmp    %edx,%esi
  8024a9:	72 15                	jb     8024c0 <__udivdi3+0x100>
  8024ab:	89 f9                	mov    %edi,%ecx
  8024ad:	d3 e5                	shl    %cl,%ebp
  8024af:	39 c5                	cmp    %eax,%ebp
  8024b1:	73 04                	jae    8024b7 <__udivdi3+0xf7>
  8024b3:	39 d6                	cmp    %edx,%esi
  8024b5:	74 09                	je     8024c0 <__udivdi3+0x100>
  8024b7:	89 d8                	mov    %ebx,%eax
  8024b9:	31 ff                	xor    %edi,%edi
  8024bb:	e9 27 ff ff ff       	jmp    8023e7 <__udivdi3+0x27>
  8024c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024c3:	31 ff                	xor    %edi,%edi
  8024c5:	e9 1d ff ff ff       	jmp    8023e7 <__udivdi3+0x27>
  8024ca:	66 90                	xchg   %ax,%ax
  8024cc:	66 90                	xchg   %ax,%ax
  8024ce:	66 90                	xchg   %ax,%ax

008024d0 <__umoddi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 1c             	sub    $0x1c,%esp
  8024d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024e7:	89 da                	mov    %ebx,%edx
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	75 43                	jne    802530 <__umoddi3+0x60>
  8024ed:	39 df                	cmp    %ebx,%edi
  8024ef:	76 17                	jbe    802508 <__umoddi3+0x38>
  8024f1:	89 f0                	mov    %esi,%eax
  8024f3:	f7 f7                	div    %edi
  8024f5:	89 d0                	mov    %edx,%eax
  8024f7:	31 d2                	xor    %edx,%edx
  8024f9:	83 c4 1c             	add    $0x1c,%esp
  8024fc:	5b                   	pop    %ebx
  8024fd:	5e                   	pop    %esi
  8024fe:	5f                   	pop    %edi
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	89 fd                	mov    %edi,%ebp
  80250a:	85 ff                	test   %edi,%edi
  80250c:	75 0b                	jne    802519 <__umoddi3+0x49>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f7                	div    %edi
  802517:	89 c5                	mov    %eax,%ebp
  802519:	89 d8                	mov    %ebx,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f5                	div    %ebp
  80251f:	89 f0                	mov    %esi,%eax
  802521:	f7 f5                	div    %ebp
  802523:	89 d0                	mov    %edx,%eax
  802525:	eb d0                	jmp    8024f7 <__umoddi3+0x27>
  802527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252e:	66 90                	xchg   %ax,%ax
  802530:	89 f1                	mov    %esi,%ecx
  802532:	39 d8                	cmp    %ebx,%eax
  802534:	76 0a                	jbe    802540 <__umoddi3+0x70>
  802536:	89 f0                	mov    %esi,%eax
  802538:	83 c4 1c             	add    $0x1c,%esp
  80253b:	5b                   	pop    %ebx
  80253c:	5e                   	pop    %esi
  80253d:	5f                   	pop    %edi
  80253e:	5d                   	pop    %ebp
  80253f:	c3                   	ret    
  802540:	0f bd e8             	bsr    %eax,%ebp
  802543:	83 f5 1f             	xor    $0x1f,%ebp
  802546:	75 20                	jne    802568 <__umoddi3+0x98>
  802548:	39 d8                	cmp    %ebx,%eax
  80254a:	0f 82 b0 00 00 00    	jb     802600 <__umoddi3+0x130>
  802550:	39 f7                	cmp    %esi,%edi
  802552:	0f 86 a8 00 00 00    	jbe    802600 <__umoddi3+0x130>
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	83 c4 1c             	add    $0x1c,%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5e                   	pop    %esi
  80255f:	5f                   	pop    %edi
  802560:	5d                   	pop    %ebp
  802561:	c3                   	ret    
  802562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	ba 20 00 00 00       	mov    $0x20,%edx
  80256f:	29 ea                	sub    %ebp,%edx
  802571:	d3 e0                	shl    %cl,%eax
  802573:	89 44 24 08          	mov    %eax,0x8(%esp)
  802577:	89 d1                	mov    %edx,%ecx
  802579:	89 f8                	mov    %edi,%eax
  80257b:	d3 e8                	shr    %cl,%eax
  80257d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802581:	89 54 24 04          	mov    %edx,0x4(%esp)
  802585:	8b 54 24 04          	mov    0x4(%esp),%edx
  802589:	09 c1                	or     %eax,%ecx
  80258b:	89 d8                	mov    %ebx,%eax
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 e9                	mov    %ebp,%ecx
  802593:	d3 e7                	shl    %cl,%edi
  802595:	89 d1                	mov    %edx,%ecx
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	d3 e3                	shl    %cl,%ebx
  8025a1:	89 c7                	mov    %eax,%edi
  8025a3:	89 d1                	mov    %edx,%ecx
  8025a5:	89 f0                	mov    %esi,%eax
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	89 fa                	mov    %edi,%edx
  8025ad:	d3 e6                	shl    %cl,%esi
  8025af:	09 d8                	or     %ebx,%eax
  8025b1:	f7 74 24 08          	divl   0x8(%esp)
  8025b5:	89 d1                	mov    %edx,%ecx
  8025b7:	89 f3                	mov    %esi,%ebx
  8025b9:	f7 64 24 0c          	mull   0xc(%esp)
  8025bd:	89 c6                	mov    %eax,%esi
  8025bf:	89 d7                	mov    %edx,%edi
  8025c1:	39 d1                	cmp    %edx,%ecx
  8025c3:	72 06                	jb     8025cb <__umoddi3+0xfb>
  8025c5:	75 10                	jne    8025d7 <__umoddi3+0x107>
  8025c7:	39 c3                	cmp    %eax,%ebx
  8025c9:	73 0c                	jae    8025d7 <__umoddi3+0x107>
  8025cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025d3:	89 d7                	mov    %edx,%edi
  8025d5:	89 c6                	mov    %eax,%esi
  8025d7:	89 ca                	mov    %ecx,%edx
  8025d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025de:	29 f3                	sub    %esi,%ebx
  8025e0:	19 fa                	sbb    %edi,%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	d3 e0                	shl    %cl,%eax
  8025e6:	89 e9                	mov    %ebp,%ecx
  8025e8:	d3 eb                	shr    %cl,%ebx
  8025ea:	d3 ea                	shr    %cl,%edx
  8025ec:	09 d8                	or     %ebx,%eax
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	89 da                	mov    %ebx,%edx
  802602:	29 fe                	sub    %edi,%esi
  802604:	19 c2                	sbb    %eax,%edx
  802606:	89 f1                	mov    %esi,%ecx
  802608:	89 c8                	mov    %ecx,%eax
  80260a:	e9 4b ff ff ff       	jmp    80255a <__umoddi3+0x8a>
