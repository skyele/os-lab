
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
  8000b9:	e8 75 0f 00 00       	call   801033 <sys_map_kernel_page>
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
  800129:	e8 c3 01 00 00       	call   8002f1 <cprintf>
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
  800160:	e8 9f 0c 00 00       	call   800e04 <sys_getenvid>
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
  800185:	74 23                	je     8001aa <libmain+0x5d>
		if(envs[i].env_id == find)
  800187:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80018d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800193:	8b 49 48             	mov    0x48(%ecx),%ecx
  800196:	39 c1                	cmp    %eax,%ecx
  800198:	75 e2                	jne    80017c <libmain+0x2f>
  80019a:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8001a0:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001a6:	89 fe                	mov    %edi,%esi
  8001a8:	eb d2                	jmp    80017c <libmain+0x2f>
  8001aa:	89 f0                	mov    %esi,%eax
  8001ac:	84 c0                	test   %al,%al
  8001ae:	74 06                	je     8001b6 <libmain+0x69>
  8001b0:	89 1d 4c 50 80 00    	mov    %ebx,0x80504c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ba:	7e 0a                	jle    8001c6 <libmain+0x79>
		binaryname = argv[0];
  8001bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bf:	8b 00                	mov    (%eax),%eax
  8001c1:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001c6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8001cb:	8b 40 48             	mov    0x48(%eax),%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 ac 26 80 00       	push   $0x8026ac
  8001d7:	e8 15 01 00 00       	call   8002f1 <cprintf>
	cprintf("before umain\n");
  8001dc:	c7 04 24 ca 26 80 00 	movl   $0x8026ca,(%esp)
  8001e3:	e8 09 01 00 00       	call   8002f1 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ee:	ff 75 08             	pushl  0x8(%ebp)
  8001f1:	e8 3d ff ff ff       	call   800133 <umain>
	cprintf("after umain\n");
  8001f6:	c7 04 24 d8 26 80 00 	movl   $0x8026d8,(%esp)
  8001fd:	e8 ef 00 00 00       	call   8002f1 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800202:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800207:	8b 40 48             	mov    0x48(%eax),%eax
  80020a:	83 c4 08             	add    $0x8,%esp
  80020d:	50                   	push   %eax
  80020e:	68 e5 26 80 00       	push   $0x8026e5
  800213:	e8 d9 00 00 00       	call   8002f1 <cprintf>
	// exit gracefully
	exit();
  800218:	e8 0b 00 00 00       	call   800228 <exit>
}
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800223:	5b                   	pop    %ebx
  800224:	5e                   	pop    %esi
  800225:	5f                   	pop    %edi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80022e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800233:	8b 40 48             	mov    0x48(%eax),%eax
  800236:	68 10 27 80 00       	push   $0x802710
  80023b:	50                   	push   %eax
  80023c:	68 04 27 80 00       	push   $0x802704
  800241:	e8 ab 00 00 00       	call   8002f1 <cprintf>
	close_all();
  800246:	e8 c4 10 00 00       	call   80130f <close_all>
	sys_env_destroy(0);
  80024b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800252:	e8 6c 0b 00 00       	call   800dc3 <sys_env_destroy>
}
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	c9                   	leave  
  80025b:	c3                   	ret    

0080025c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	53                   	push   %ebx
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800266:	8b 13                	mov    (%ebx),%edx
  800268:	8d 42 01             	lea    0x1(%edx),%eax
  80026b:	89 03                	mov    %eax,(%ebx)
  80026d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800270:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800274:	3d ff 00 00 00       	cmp    $0xff,%eax
  800279:	74 09                	je     800284 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80027b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800282:	c9                   	leave  
  800283:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	68 ff 00 00 00       	push   $0xff
  80028c:	8d 43 08             	lea    0x8(%ebx),%eax
  80028f:	50                   	push   %eax
  800290:	e8 f1 0a 00 00       	call   800d86 <sys_cputs>
		b->idx = 0;
  800295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	eb db                	jmp    80027b <putch+0x1f>

008002a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b0:	00 00 00 
	b.cnt = 0;
  8002b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002bd:	ff 75 0c             	pushl  0xc(%ebp)
  8002c0:	ff 75 08             	pushl  0x8(%ebp)
  8002c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c9:	50                   	push   %eax
  8002ca:	68 5c 02 80 00       	push   $0x80025c
  8002cf:	e8 4a 01 00 00       	call   80041e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002d4:	83 c4 08             	add    $0x8,%esp
  8002d7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002dd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	e8 9d 0a 00 00       	call   800d86 <sys_cputs>

	return b.cnt;
}
  8002e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002fa:	50                   	push   %eax
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	e8 9d ff ff ff       	call   8002a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800303:	c9                   	leave  
  800304:	c3                   	ret    

00800305 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 1c             	sub    $0x1c,%esp
  80030e:	89 c6                	mov    %eax,%esi
  800310:	89 d7                	mov    %edx,%edi
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	8b 55 0c             	mov    0xc(%ebp),%edx
  800318:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80031e:	8b 45 10             	mov    0x10(%ebp),%eax
  800321:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800324:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800328:	74 2c                	je     800356 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80032a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800334:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800337:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033a:	39 c2                	cmp    %eax,%edx
  80033c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80033f:	73 43                	jae    800384 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800341:	83 eb 01             	sub    $0x1,%ebx
  800344:	85 db                	test   %ebx,%ebx
  800346:	7e 6c                	jle    8003b4 <printnum+0xaf>
				putch(padc, putdat);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	57                   	push   %edi
  80034c:	ff 75 18             	pushl  0x18(%ebp)
  80034f:	ff d6                	call   *%esi
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	eb eb                	jmp    800341 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	6a 20                	push   $0x20
  80035b:	6a 00                	push   $0x0
  80035d:	50                   	push   %eax
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	89 fa                	mov    %edi,%edx
  800366:	89 f0                	mov    %esi,%eax
  800368:	e8 98 ff ff ff       	call   800305 <printnum>
		while (--width > 0)
  80036d:	83 c4 20             	add    $0x20,%esp
  800370:	83 eb 01             	sub    $0x1,%ebx
  800373:	85 db                	test   %ebx,%ebx
  800375:	7e 65                	jle    8003dc <printnum+0xd7>
			putch(padc, putdat);
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	57                   	push   %edi
  80037b:	6a 20                	push   $0x20
  80037d:	ff d6                	call   *%esi
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	eb ec                	jmp    800370 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	ff 75 18             	pushl  0x18(%ebp)
  80038a:	83 eb 01             	sub    $0x1,%ebx
  80038d:	53                   	push   %ebx
  80038e:	50                   	push   %eax
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	ff 75 dc             	pushl  -0x24(%ebp)
  800395:	ff 75 d8             	pushl  -0x28(%ebp)
  800398:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039b:	ff 75 e0             	pushl  -0x20(%ebp)
  80039e:	e8 8d 20 00 00       	call   802430 <__udivdi3>
  8003a3:	83 c4 18             	add    $0x18,%esp
  8003a6:	52                   	push   %edx
  8003a7:	50                   	push   %eax
  8003a8:	89 fa                	mov    %edi,%edx
  8003aa:	89 f0                	mov    %esi,%eax
  8003ac:	e8 54 ff ff ff       	call   800305 <printnum>
  8003b1:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	57                   	push   %edi
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003be:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c7:	e8 74 21 00 00       	call   802540 <__umoddi3>
  8003cc:	83 c4 14             	add    $0x14,%esp
  8003cf:	0f be 80 15 27 80 00 	movsbl 0x802715(%eax),%eax
  8003d6:	50                   	push   %eax
  8003d7:	ff d6                	call   *%esi
  8003d9:	83 c4 10             	add    $0x10,%esp
	}
}
  8003dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003df:	5b                   	pop    %ebx
  8003e0:	5e                   	pop    %esi
  8003e1:	5f                   	pop    %edi
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ea:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ee:	8b 10                	mov    (%eax),%edx
  8003f0:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f3:	73 0a                	jae    8003ff <sprintputch+0x1b>
		*b->buf++ = ch;
  8003f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f8:	89 08                	mov    %ecx,(%eax)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	88 02                	mov    %al,(%edx)
}
  8003ff:	5d                   	pop    %ebp
  800400:	c3                   	ret    

00800401 <printfmt>:
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800407:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040a:	50                   	push   %eax
  80040b:	ff 75 10             	pushl  0x10(%ebp)
  80040e:	ff 75 0c             	pushl  0xc(%ebp)
  800411:	ff 75 08             	pushl  0x8(%ebp)
  800414:	e8 05 00 00 00       	call   80041e <vprintfmt>
}
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <vprintfmt>:
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	57                   	push   %edi
  800422:	56                   	push   %esi
  800423:	53                   	push   %ebx
  800424:	83 ec 3c             	sub    $0x3c,%esp
  800427:	8b 75 08             	mov    0x8(%ebp),%esi
  80042a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80042d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800430:	e9 32 04 00 00       	jmp    800867 <vprintfmt+0x449>
		padc = ' ';
  800435:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800439:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800440:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800447:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800455:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80045c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8d 47 01             	lea    0x1(%edi),%eax
  800464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800467:	0f b6 17             	movzbl (%edi),%edx
  80046a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80046d:	3c 55                	cmp    $0x55,%al
  80046f:	0f 87 12 05 00 00    	ja     800987 <vprintfmt+0x569>
  800475:	0f b6 c0             	movzbl %al,%eax
  800478:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800482:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800486:	eb d9                	jmp    800461 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80048b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80048f:	eb d0                	jmp    800461 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800491:	0f b6 d2             	movzbl %dl,%edx
  800494:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800497:	b8 00 00 00 00       	mov    $0x0,%eax
  80049c:	89 75 08             	mov    %esi,0x8(%ebp)
  80049f:	eb 03                	jmp    8004a4 <vprintfmt+0x86>
  8004a1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ab:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ae:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004b1:	83 fe 09             	cmp    $0x9,%esi
  8004b4:	76 eb                	jbe    8004a1 <vprintfmt+0x83>
  8004b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bc:	eb 14                	jmp    8004d2 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	8d 40 04             	lea    0x4(%eax),%eax
  8004cc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d6:	79 89                	jns    800461 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e5:	e9 77 ff ff ff       	jmp    800461 <vprintfmt+0x43>
  8004ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	0f 48 c1             	cmovs  %ecx,%eax
  8004f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f8:	e9 64 ff ff ff       	jmp    800461 <vprintfmt+0x43>
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800500:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800507:	e9 55 ff ff ff       	jmp    800461 <vprintfmt+0x43>
			lflag++;
  80050c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800513:	e9 49 ff ff ff       	jmp    800461 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 78 04             	lea    0x4(%eax),%edi
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	ff 30                	pushl  (%eax)
  800524:	ff d6                	call   *%esi
			break;
  800526:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800529:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80052c:	e9 33 03 00 00       	jmp    800864 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 78 04             	lea    0x4(%eax),%edi
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	31 d0                	xor    %edx,%eax
  80053c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053e:	83 f8 11             	cmp    $0x11,%eax
  800541:	7f 23                	jg     800566 <vprintfmt+0x148>
  800543:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 18                	je     800566 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80054e:	52                   	push   %edx
  80054f:	68 7d 2b 80 00       	push   $0x802b7d
  800554:	53                   	push   %ebx
  800555:	56                   	push   %esi
  800556:	e8 a6 fe ff ff       	call   800401 <printfmt>
  80055b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800561:	e9 fe 02 00 00       	jmp    800864 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800566:	50                   	push   %eax
  800567:	68 2d 27 80 00       	push   $0x80272d
  80056c:	53                   	push   %ebx
  80056d:	56                   	push   %esi
  80056e:	e8 8e fe ff ff       	call   800401 <printfmt>
  800573:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800576:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800579:	e9 e6 02 00 00       	jmp    800864 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	83 c0 04             	add    $0x4,%eax
  800584:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	b8 26 27 80 00       	mov    $0x802726,%eax
  800593:	0f 45 c1             	cmovne %ecx,%eax
  800596:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800599:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059d:	7e 06                	jle    8005a5 <vprintfmt+0x187>
  80059f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005a3:	75 0d                	jne    8005b2 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a8:	89 c7                	mov    %eax,%edi
  8005aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b0:	eb 53                	jmp    800605 <vprintfmt+0x1e7>
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 71 04 00 00       	call   800a2f <strnlen>
  8005be:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c1:	29 c1                	sub    %eax,%ecx
  8005c3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005cb:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d2:	eb 0f                	jmp    8005e3 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	53                   	push   %ebx
  8005d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005db:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dd:	83 ef 01             	sub    $0x1,%edi
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	85 ff                	test   %edi,%edi
  8005e5:	7f ed                	jg     8005d4 <vprintfmt+0x1b6>
  8005e7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ea:	85 c9                	test   %ecx,%ecx
  8005ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f1:	0f 49 c1             	cmovns %ecx,%eax
  8005f4:	29 c1                	sub    %eax,%ecx
  8005f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005f9:	eb aa                	jmp    8005a5 <vprintfmt+0x187>
					putch(ch, putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	52                   	push   %edx
  800600:	ff d6                	call   *%esi
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800608:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060a:	83 c7 01             	add    $0x1,%edi
  80060d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800611:	0f be d0             	movsbl %al,%edx
  800614:	85 d2                	test   %edx,%edx
  800616:	74 4b                	je     800663 <vprintfmt+0x245>
  800618:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061c:	78 06                	js     800624 <vprintfmt+0x206>
  80061e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800622:	78 1e                	js     800642 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800624:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800628:	74 d1                	je     8005fb <vprintfmt+0x1dd>
  80062a:	0f be c0             	movsbl %al,%eax
  80062d:	83 e8 20             	sub    $0x20,%eax
  800630:	83 f8 5e             	cmp    $0x5e,%eax
  800633:	76 c6                	jbe    8005fb <vprintfmt+0x1dd>
					putch('?', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 3f                	push   $0x3f
  80063b:	ff d6                	call   *%esi
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	eb c3                	jmp    800605 <vprintfmt+0x1e7>
  800642:	89 cf                	mov    %ecx,%edi
  800644:	eb 0e                	jmp    800654 <vprintfmt+0x236>
				putch(' ', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 20                	push   $0x20
  80064c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064e:	83 ef 01             	sub    $0x1,%edi
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	85 ff                	test   %edi,%edi
  800656:	7f ee                	jg     800646 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800658:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	e9 01 02 00 00       	jmp    800864 <vprintfmt+0x446>
  800663:	89 cf                	mov    %ecx,%edi
  800665:	eb ed                	jmp    800654 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80066a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800671:	e9 eb fd ff ff       	jmp    800461 <vprintfmt+0x43>
	if (lflag >= 2)
  800676:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067a:	7f 21                	jg     80069d <vprintfmt+0x27f>
	else if (lflag)
  80067c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800680:	74 68                	je     8006ea <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80068a:	89 c1                	mov    %eax,%ecx
  80068c:	c1 f9 1f             	sar    $0x1f,%ecx
  80068f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
  80069b:	eb 17                	jmp    8006b4 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 50 04             	mov    0x4(%eax),%edx
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8d 40 08             	lea    0x8(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c4:	78 3f                	js     800705 <vprintfmt+0x2e7>
			base = 10;
  8006c6:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006cb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006cf:	0f 84 71 01 00 00    	je     800846 <vprintfmt+0x428>
				putch('+', putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	6a 2b                	push   $0x2b
  8006db:	ff d6                	call   *%esi
  8006dd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e5:	e9 5c 01 00 00       	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f2:	89 c1                	mov    %eax,%ecx
  8006f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8d 40 04             	lea    0x4(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
  800703:	eb af                	jmp    8006b4 <vprintfmt+0x296>
				putch('-', putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 2d                	push   $0x2d
  80070b:	ff d6                	call   *%esi
				num = -(long long) num;
  80070d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800710:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800713:	f7 d8                	neg    %eax
  800715:	83 d2 00             	adc    $0x0,%edx
  800718:	f7 da                	neg    %edx
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800720:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800723:	b8 0a 00 00 00       	mov    $0xa,%eax
  800728:	e9 19 01 00 00       	jmp    800846 <vprintfmt+0x428>
	if (lflag >= 2)
  80072d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800731:	7f 29                	jg     80075c <vprintfmt+0x33e>
	else if (lflag)
  800733:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800737:	74 44                	je     80077d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
  800743:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800746:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800752:	b8 0a 00 00 00       	mov    $0xa,%eax
  800757:	e9 ea 00 00 00       	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 50 04             	mov    0x4(%eax),%edx
  800762:	8b 00                	mov    (%eax),%eax
  800764:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800767:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 40 08             	lea    0x8(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800773:	b8 0a 00 00 00       	mov    $0xa,%eax
  800778:	e9 c9 00 00 00       	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800796:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079b:	e9 a6 00 00 00       	jmp    800846 <vprintfmt+0x428>
			putch('0', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	53                   	push   %ebx
  8007a4:	6a 30                	push   $0x30
  8007a6:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007af:	7f 26                	jg     8007d7 <vprintfmt+0x3b9>
	else if (lflag)
  8007b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b5:	74 3e                	je     8007f5 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 04             	lea    0x4(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d5:	eb 6f                	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 08             	lea    0x8(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f3:	eb 51                	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800802:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8d 40 04             	lea    0x4(%eax),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080e:	b8 08 00 00 00       	mov    $0x8,%eax
  800813:	eb 31                	jmp    800846 <vprintfmt+0x428>
			putch('0', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	6a 30                	push   $0x30
  80081b:	ff d6                	call   *%esi
			putch('x', putdat);
  80081d:	83 c4 08             	add    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 78                	push   $0x78
  800823:	ff d6                	call   *%esi
			num = (unsigned long long)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	ba 00 00 00 00       	mov    $0x0,%edx
  80082f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800832:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800835:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8d 40 04             	lea    0x4(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800841:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80084d:	52                   	push   %edx
  80084e:	ff 75 e0             	pushl  -0x20(%ebp)
  800851:	50                   	push   %eax
  800852:	ff 75 dc             	pushl  -0x24(%ebp)
  800855:	ff 75 d8             	pushl  -0x28(%ebp)
  800858:	89 da                	mov    %ebx,%edx
  80085a:	89 f0                	mov    %esi,%eax
  80085c:	e8 a4 fa ff ff       	call   800305 <printnum>
			break;
  800861:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800864:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800867:	83 c7 01             	add    $0x1,%edi
  80086a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80086e:	83 f8 25             	cmp    $0x25,%eax
  800871:	0f 84 be fb ff ff    	je     800435 <vprintfmt+0x17>
			if (ch == '\0')
  800877:	85 c0                	test   %eax,%eax
  800879:	0f 84 28 01 00 00    	je     8009a7 <vprintfmt+0x589>
			putch(ch, putdat);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	53                   	push   %ebx
  800883:	50                   	push   %eax
  800884:	ff d6                	call   *%esi
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	eb dc                	jmp    800867 <vprintfmt+0x449>
	if (lflag >= 2)
  80088b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80088f:	7f 26                	jg     8008b7 <vprintfmt+0x499>
	else if (lflag)
  800891:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800895:	74 41                	je     8008d8 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8d 40 04             	lea    0x4(%eax),%eax
  8008ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b0:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b5:	eb 8f                	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	8b 50 04             	mov    0x4(%eax),%edx
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8d 40 08             	lea    0x8(%eax),%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d3:	e9 6e ff ff ff       	jmp    800846 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  8008f6:	e9 4b ff ff ff       	jmp    800846 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	83 c0 04             	add    $0x4,%eax
  800901:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	85 c0                	test   %eax,%eax
  80090b:	74 14                	je     800921 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80090d:	8b 13                	mov    (%ebx),%edx
  80090f:	83 fa 7f             	cmp    $0x7f,%edx
  800912:	7f 37                	jg     80094b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800914:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800916:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800919:	89 45 14             	mov    %eax,0x14(%ebp)
  80091c:	e9 43 ff ff ff       	jmp    800864 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800921:	b8 0a 00 00 00       	mov    $0xa,%eax
  800926:	bf 49 28 80 00       	mov    $0x802849,%edi
							putch(ch, putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	53                   	push   %ebx
  80092f:	50                   	push   %eax
  800930:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800932:	83 c7 01             	add    $0x1,%edi
  800935:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	85 c0                	test   %eax,%eax
  80093e:	75 eb                	jne    80092b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800940:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
  800946:	e9 19 ff ff ff       	jmp    800864 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80094b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80094d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800952:	bf 81 28 80 00       	mov    $0x802881,%edi
							putch(ch, putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	53                   	push   %ebx
  80095b:	50                   	push   %eax
  80095c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80095e:	83 c7 01             	add    $0x1,%edi
  800961:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	85 c0                	test   %eax,%eax
  80096a:	75 eb                	jne    800957 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80096c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80096f:	89 45 14             	mov    %eax,0x14(%ebp)
  800972:	e9 ed fe ff ff       	jmp    800864 <vprintfmt+0x446>
			putch(ch, putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	53                   	push   %ebx
  80097b:	6a 25                	push   $0x25
  80097d:	ff d6                	call   *%esi
			break;
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	e9 dd fe ff ff       	jmp    800864 <vprintfmt+0x446>
			putch('%', putdat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	53                   	push   %ebx
  80098b:	6a 25                	push   $0x25
  80098d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	89 f8                	mov    %edi,%eax
  800994:	eb 03                	jmp    800999 <vprintfmt+0x57b>
  800996:	83 e8 01             	sub    $0x1,%eax
  800999:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80099d:	75 f7                	jne    800996 <vprintfmt+0x578>
  80099f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a2:	e9 bd fe ff ff       	jmp    800864 <vprintfmt+0x446>
}
  8009a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009aa:	5b                   	pop    %ebx
  8009ab:	5e                   	pop    %esi
  8009ac:	5f                   	pop    %edi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 18             	sub    $0x18,%esp
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009be:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009cc:	85 c0                	test   %eax,%eax
  8009ce:	74 26                	je     8009f6 <vsnprintf+0x47>
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	7e 22                	jle    8009f6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d4:	ff 75 14             	pushl  0x14(%ebp)
  8009d7:	ff 75 10             	pushl  0x10(%ebp)
  8009da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009dd:	50                   	push   %eax
  8009de:	68 e4 03 80 00       	push   $0x8003e4
  8009e3:	e8 36 fa ff ff       	call   80041e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f1:	83 c4 10             	add    $0x10,%esp
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    
		return -E_INVAL;
  8009f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fb:	eb f7                	jmp    8009f4 <vsnprintf+0x45>

008009fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a03:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a06:	50                   	push   %eax
  800a07:	ff 75 10             	pushl  0x10(%ebp)
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	ff 75 08             	pushl  0x8(%ebp)
  800a10:	e8 9a ff ff ff       	call   8009af <vsnprintf>
	va_end(ap);

	return rc;
}
  800a15:	c9                   	leave  
  800a16:	c3                   	ret    

00800a17 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a22:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a26:	74 05                	je     800a2d <strlen+0x16>
		n++;
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f5                	jmp    800a22 <strlen+0xb>
	return n;
}
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a38:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3d:	39 c2                	cmp    %eax,%edx
  800a3f:	74 0d                	je     800a4e <strnlen+0x1f>
  800a41:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a45:	74 05                	je     800a4c <strnlen+0x1d>
		n++;
  800a47:	83 c2 01             	add    $0x1,%edx
  800a4a:	eb f1                	jmp    800a3d <strnlen+0xe>
  800a4c:	89 d0                	mov    %edx,%eax
	return n;
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a63:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a66:	83 c2 01             	add    $0x1,%edx
  800a69:	84 c9                	test   %cl,%cl
  800a6b:	75 f2                	jne    800a5f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a6d:	5b                   	pop    %ebx
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	53                   	push   %ebx
  800a74:	83 ec 10             	sub    $0x10,%esp
  800a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a7a:	53                   	push   %ebx
  800a7b:	e8 97 ff ff ff       	call   800a17 <strlen>
  800a80:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	01 d8                	add    %ebx,%eax
  800a88:	50                   	push   %eax
  800a89:	e8 c2 ff ff ff       	call   800a50 <strcpy>
	return dst;
}
  800a8e:	89 d8                	mov    %ebx,%eax
  800a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	56                   	push   %esi
  800a99:	53                   	push   %ebx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa0:	89 c6                	mov    %eax,%esi
  800aa2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa5:	89 c2                	mov    %eax,%edx
  800aa7:	39 f2                	cmp    %esi,%edx
  800aa9:	74 11                	je     800abc <strncpy+0x27>
		*dst++ = *src;
  800aab:	83 c2 01             	add    $0x1,%edx
  800aae:	0f b6 19             	movzbl (%ecx),%ebx
  800ab1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab4:	80 fb 01             	cmp    $0x1,%bl
  800ab7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800aba:	eb eb                	jmp    800aa7 <strncpy+0x12>
	}
	return ret;
}
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	56                   	push   %esi
  800ac4:	53                   	push   %ebx
  800ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acb:	8b 55 10             	mov    0x10(%ebp),%edx
  800ace:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad0:	85 d2                	test   %edx,%edx
  800ad2:	74 21                	je     800af5 <strlcpy+0x35>
  800ad4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ad8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ada:	39 c2                	cmp    %eax,%edx
  800adc:	74 14                	je     800af2 <strlcpy+0x32>
  800ade:	0f b6 19             	movzbl (%ecx),%ebx
  800ae1:	84 db                	test   %bl,%bl
  800ae3:	74 0b                	je     800af0 <strlcpy+0x30>
			*dst++ = *src++;
  800ae5:	83 c1 01             	add    $0x1,%ecx
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aee:	eb ea                	jmp    800ada <strlcpy+0x1a>
  800af0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800af2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af5:	29 f0                	sub    %esi,%eax
}
  800af7:	5b                   	pop    %ebx
  800af8:	5e                   	pop    %esi
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b01:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b04:	0f b6 01             	movzbl (%ecx),%eax
  800b07:	84 c0                	test   %al,%al
  800b09:	74 0c                	je     800b17 <strcmp+0x1c>
  800b0b:	3a 02                	cmp    (%edx),%al
  800b0d:	75 08                	jne    800b17 <strcmp+0x1c>
		p++, q++;
  800b0f:	83 c1 01             	add    $0x1,%ecx
  800b12:	83 c2 01             	add    $0x1,%edx
  800b15:	eb ed                	jmp    800b04 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b17:	0f b6 c0             	movzbl %al,%eax
  800b1a:	0f b6 12             	movzbl (%edx),%edx
  800b1d:	29 d0                	sub    %edx,%eax
}
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2b:	89 c3                	mov    %eax,%ebx
  800b2d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b30:	eb 06                	jmp    800b38 <strncmp+0x17>
		n--, p++, q++;
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b38:	39 d8                	cmp    %ebx,%eax
  800b3a:	74 16                	je     800b52 <strncmp+0x31>
  800b3c:	0f b6 08             	movzbl (%eax),%ecx
  800b3f:	84 c9                	test   %cl,%cl
  800b41:	74 04                	je     800b47 <strncmp+0x26>
  800b43:	3a 0a                	cmp    (%edx),%cl
  800b45:	74 eb                	je     800b32 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b47:	0f b6 00             	movzbl (%eax),%eax
  800b4a:	0f b6 12             	movzbl (%edx),%edx
  800b4d:	29 d0                	sub    %edx,%eax
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    
		return 0;
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
  800b57:	eb f6                	jmp    800b4f <strncmp+0x2e>

00800b59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b63:	0f b6 10             	movzbl (%eax),%edx
  800b66:	84 d2                	test   %dl,%dl
  800b68:	74 09                	je     800b73 <strchr+0x1a>
		if (*s == c)
  800b6a:	38 ca                	cmp    %cl,%dl
  800b6c:	74 0a                	je     800b78 <strchr+0x1f>
	for (; *s; s++)
  800b6e:	83 c0 01             	add    $0x1,%eax
  800b71:	eb f0                	jmp    800b63 <strchr+0xa>
			return (char *) s;
	return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b84:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b87:	38 ca                	cmp    %cl,%dl
  800b89:	74 09                	je     800b94 <strfind+0x1a>
  800b8b:	84 d2                	test   %dl,%dl
  800b8d:	74 05                	je     800b94 <strfind+0x1a>
	for (; *s; s++)
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	eb f0                	jmp    800b84 <strfind+0xa>
			break;
	return (char *) s;
}
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
  800b9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba2:	85 c9                	test   %ecx,%ecx
  800ba4:	74 31                	je     800bd7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba6:	89 f8                	mov    %edi,%eax
  800ba8:	09 c8                	or     %ecx,%eax
  800baa:	a8 03                	test   $0x3,%al
  800bac:	75 23                	jne    800bd1 <memset+0x3b>
		c &= 0xFF;
  800bae:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb2:	89 d3                	mov    %edx,%ebx
  800bb4:	c1 e3 08             	shl    $0x8,%ebx
  800bb7:	89 d0                	mov    %edx,%eax
  800bb9:	c1 e0 18             	shl    $0x18,%eax
  800bbc:	89 d6                	mov    %edx,%esi
  800bbe:	c1 e6 10             	shl    $0x10,%esi
  800bc1:	09 f0                	or     %esi,%eax
  800bc3:	09 c2                	or     %eax,%edx
  800bc5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bc7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bca:	89 d0                	mov    %edx,%eax
  800bcc:	fc                   	cld    
  800bcd:	f3 ab                	rep stos %eax,%es:(%edi)
  800bcf:	eb 06                	jmp    800bd7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd4:	fc                   	cld    
  800bd5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd7:	89 f8                	mov    %edi,%eax
  800bd9:	5b                   	pop    %ebx
  800bda:	5e                   	pop    %esi
  800bdb:	5f                   	pop    %edi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bec:	39 c6                	cmp    %eax,%esi
  800bee:	73 32                	jae    800c22 <memmove+0x44>
  800bf0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf3:	39 c2                	cmp    %eax,%edx
  800bf5:	76 2b                	jbe    800c22 <memmove+0x44>
		s += n;
		d += n;
  800bf7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfa:	89 fe                	mov    %edi,%esi
  800bfc:	09 ce                	or     %ecx,%esi
  800bfe:	09 d6                	or     %edx,%esi
  800c00:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c06:	75 0e                	jne    800c16 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c08:	83 ef 04             	sub    $0x4,%edi
  800c0b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c11:	fd                   	std    
  800c12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c14:	eb 09                	jmp    800c1f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c16:	83 ef 01             	sub    $0x1,%edi
  800c19:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c1c:	fd                   	std    
  800c1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c1f:	fc                   	cld    
  800c20:	eb 1a                	jmp    800c3c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c22:	89 c2                	mov    %eax,%edx
  800c24:	09 ca                	or     %ecx,%edx
  800c26:	09 f2                	or     %esi,%edx
  800c28:	f6 c2 03             	test   $0x3,%dl
  800c2b:	75 0a                	jne    800c37 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c30:	89 c7                	mov    %eax,%edi
  800c32:	fc                   	cld    
  800c33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c35:	eb 05                	jmp    800c3c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c37:	89 c7                	mov    %eax,%edi
  800c39:	fc                   	cld    
  800c3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c46:	ff 75 10             	pushl  0x10(%ebp)
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	ff 75 08             	pushl  0x8(%ebp)
  800c4f:	e8 8a ff ff ff       	call   800bde <memmove>
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	89 c6                	mov    %eax,%esi
  800c63:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c66:	39 f0                	cmp    %esi,%eax
  800c68:	74 1c                	je     800c86 <memcmp+0x30>
		if (*s1 != *s2)
  800c6a:	0f b6 08             	movzbl (%eax),%ecx
  800c6d:	0f b6 1a             	movzbl (%edx),%ebx
  800c70:	38 d9                	cmp    %bl,%cl
  800c72:	75 08                	jne    800c7c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c74:	83 c0 01             	add    $0x1,%eax
  800c77:	83 c2 01             	add    $0x1,%edx
  800c7a:	eb ea                	jmp    800c66 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c7c:	0f b6 c1             	movzbl %cl,%eax
  800c7f:	0f b6 db             	movzbl %bl,%ebx
  800c82:	29 d8                	sub    %ebx,%eax
  800c84:	eb 05                	jmp    800c8b <memcmp+0x35>
	}

	return 0;
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c98:	89 c2                	mov    %eax,%edx
  800c9a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c9d:	39 d0                	cmp    %edx,%eax
  800c9f:	73 09                	jae    800caa <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca1:	38 08                	cmp    %cl,(%eax)
  800ca3:	74 05                	je     800caa <memfind+0x1b>
	for (; s < ends; s++)
  800ca5:	83 c0 01             	add    $0x1,%eax
  800ca8:	eb f3                	jmp    800c9d <memfind+0xe>
			break;
	return (void *) s;
}
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb8:	eb 03                	jmp    800cbd <strtol+0x11>
		s++;
  800cba:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cbd:	0f b6 01             	movzbl (%ecx),%eax
  800cc0:	3c 20                	cmp    $0x20,%al
  800cc2:	74 f6                	je     800cba <strtol+0xe>
  800cc4:	3c 09                	cmp    $0x9,%al
  800cc6:	74 f2                	je     800cba <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc8:	3c 2b                	cmp    $0x2b,%al
  800cca:	74 2a                	je     800cf6 <strtol+0x4a>
	int neg = 0;
  800ccc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cd1:	3c 2d                	cmp    $0x2d,%al
  800cd3:	74 2b                	je     800d00 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cdb:	75 0f                	jne    800cec <strtol+0x40>
  800cdd:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce0:	74 28                	je     800d0a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce2:	85 db                	test   %ebx,%ebx
  800ce4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce9:	0f 44 d8             	cmove  %eax,%ebx
  800cec:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf4:	eb 50                	jmp    800d46 <strtol+0x9a>
		s++;
  800cf6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfe:	eb d5                	jmp    800cd5 <strtol+0x29>
		s++, neg = 1;
  800d00:	83 c1 01             	add    $0x1,%ecx
  800d03:	bf 01 00 00 00       	mov    $0x1,%edi
  800d08:	eb cb                	jmp    800cd5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d0e:	74 0e                	je     800d1e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d10:	85 db                	test   %ebx,%ebx
  800d12:	75 d8                	jne    800cec <strtol+0x40>
		s++, base = 8;
  800d14:	83 c1 01             	add    $0x1,%ecx
  800d17:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d1c:	eb ce                	jmp    800cec <strtol+0x40>
		s += 2, base = 16;
  800d1e:	83 c1 02             	add    $0x2,%ecx
  800d21:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d26:	eb c4                	jmp    800cec <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d28:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d2b:	89 f3                	mov    %esi,%ebx
  800d2d:	80 fb 19             	cmp    $0x19,%bl
  800d30:	77 29                	ja     800d5b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d32:	0f be d2             	movsbl %dl,%edx
  800d35:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d38:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d3b:	7d 30                	jge    800d6d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d3d:	83 c1 01             	add    $0x1,%ecx
  800d40:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d44:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d46:	0f b6 11             	movzbl (%ecx),%edx
  800d49:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d4c:	89 f3                	mov    %esi,%ebx
  800d4e:	80 fb 09             	cmp    $0x9,%bl
  800d51:	77 d5                	ja     800d28 <strtol+0x7c>
			dig = *s - '0';
  800d53:	0f be d2             	movsbl %dl,%edx
  800d56:	83 ea 30             	sub    $0x30,%edx
  800d59:	eb dd                	jmp    800d38 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d5b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d5e:	89 f3                	mov    %esi,%ebx
  800d60:	80 fb 19             	cmp    $0x19,%bl
  800d63:	77 08                	ja     800d6d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d65:	0f be d2             	movsbl %dl,%edx
  800d68:	83 ea 37             	sub    $0x37,%edx
  800d6b:	eb cb                	jmp    800d38 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 05                	je     800d78 <strtol+0xcc>
		*endptr = (char *) s;
  800d73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d76:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d78:	89 c2                	mov    %eax,%edx
  800d7a:	f7 da                	neg    %edx
  800d7c:	85 ff                	test   %edi,%edi
  800d7e:	0f 45 c2             	cmovne %edx,%eax
}
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d97:	89 c3                	mov    %eax,%ebx
  800d99:	89 c7                	mov    %eax,%edi
  800d9b:	89 c6                	mov    %eax,%esi
  800d9d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 01 00 00 00       	mov    $0x1,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd9:	89 cb                	mov    %ecx,%ebx
  800ddb:	89 cf                	mov    %ecx,%edi
  800ddd:	89 ce                	mov    %ecx,%esi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 03                	push   $0x3
  800df3:	68 a8 2a 80 00       	push   $0x802aa8
  800df8:	6a 43                	push   $0x43
  800dfa:	68 c5 2a 80 00       	push   $0x802ac5
  800dff:	e8 89 14 00 00       	call   80228d <_panic>

00800e04 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0f:	b8 02 00 00 00       	mov    $0x2,%eax
  800e14:	89 d1                	mov    %edx,%ecx
  800e16:	89 d3                	mov    %edx,%ebx
  800e18:	89 d7                	mov    %edx,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_yield>:

void
sys_yield(void)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e29:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e33:	89 d1                	mov    %edx,%ecx
  800e35:	89 d3                	mov    %edx,%ebx
  800e37:	89 d7                	mov    %edx,%edi
  800e39:	89 d6                	mov    %edx,%esi
  800e3b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4b:	be 00 00 00 00       	mov    $0x0,%esi
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	b8 04 00 00 00       	mov    $0x4,%eax
  800e5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5e:	89 f7                	mov    %esi,%edi
  800e60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7f 08                	jg     800e6e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	50                   	push   %eax
  800e72:	6a 04                	push   $0x4
  800e74:	68 a8 2a 80 00       	push   $0x802aa8
  800e79:	6a 43                	push   $0x43
  800e7b:	68 c5 2a 80 00       	push   $0x802ac5
  800e80:	e8 08 14 00 00       	call   80228d <_panic>

00800e85 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	b8 05 00 00 00       	mov    $0x5,%eax
  800e99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9f:	8b 75 18             	mov    0x18(%ebp),%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 05                	push   $0x5
  800eb6:	68 a8 2a 80 00       	push   $0x802aa8
  800ebb:	6a 43                	push   $0x43
  800ebd:	68 c5 2a 80 00       	push   $0x802ac5
  800ec2:	e8 c6 13 00 00       	call   80228d <_panic>

00800ec7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edb:	b8 06 00 00 00       	mov    $0x6,%eax
  800ee0:	89 df                	mov    %ebx,%edi
  800ee2:	89 de                	mov    %ebx,%esi
  800ee4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7f 08                	jg     800ef2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	83 ec 0c             	sub    $0xc,%esp
  800ef5:	50                   	push   %eax
  800ef6:	6a 06                	push   $0x6
  800ef8:	68 a8 2a 80 00       	push   $0x802aa8
  800efd:	6a 43                	push   $0x43
  800eff:	68 c5 2a 80 00       	push   $0x802ac5
  800f04:	e8 84 13 00 00       	call   80228d <_panic>

00800f09 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f17:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f22:	89 df                	mov    %ebx,%edi
  800f24:	89 de                	mov    %ebx,%esi
  800f26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7f 08                	jg     800f34 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 08                	push   $0x8
  800f3a:	68 a8 2a 80 00       	push   $0x802aa8
  800f3f:	6a 43                	push   $0x43
  800f41:	68 c5 2a 80 00       	push   $0x802ac5
  800f46:	e8 42 13 00 00       	call   80228d <_panic>

00800f4b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
  800f51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	b8 09 00 00 00       	mov    $0x9,%eax
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	7f 08                	jg     800f76 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	50                   	push   %eax
  800f7a:	6a 09                	push   $0x9
  800f7c:	68 a8 2a 80 00       	push   $0x802aa8
  800f81:	6a 43                	push   $0x43
  800f83:	68 c5 2a 80 00       	push   $0x802ac5
  800f88:	e8 00 13 00 00       	call   80228d <_panic>

00800f8d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7f 08                	jg     800fb8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	50                   	push   %eax
  800fbc:	6a 0a                	push   $0xa
  800fbe:	68 a8 2a 80 00       	push   $0x802aa8
  800fc3:	6a 43                	push   $0x43
  800fc5:	68 c5 2a 80 00       	push   $0x802ac5
  800fca:	e8 be 12 00 00       	call   80228d <_panic>

00800fcf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fe0:	be 00 00 00 00       	mov    $0x0,%esi
  800fe5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800feb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	b8 0d 00 00 00       	mov    $0xd,%eax
  801008:	89 cb                	mov    %ecx,%ebx
  80100a:	89 cf                	mov    %ecx,%edi
  80100c:	89 ce                	mov    %ecx,%esi
  80100e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801010:	85 c0                	test   %eax,%eax
  801012:	7f 08                	jg     80101c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801014:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	50                   	push   %eax
  801020:	6a 0d                	push   $0xd
  801022:	68 a8 2a 80 00       	push   $0x802aa8
  801027:	6a 43                	push   $0x43
  801029:	68 c5 2a 80 00       	push   $0x802ac5
  80102e:	e8 5a 12 00 00       	call   80228d <_panic>

00801033 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
	asm volatile("int %1\n"
  801039:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801044:	b8 0e 00 00 00       	mov    $0xe,%eax
  801049:	89 df                	mov    %ebx,%edi
  80104b:	89 de                	mov    %ebx,%esi
  80104d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	57                   	push   %edi
  801058:	56                   	push   %esi
  801059:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105f:	8b 55 08             	mov    0x8(%ebp),%edx
  801062:	b8 0f 00 00 00       	mov    $0xf,%eax
  801067:	89 cb                	mov    %ecx,%ebx
  801069:	89 cf                	mov    %ecx,%edi
  80106b:	89 ce                	mov    %ecx,%esi
  80106d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80106f:	5b                   	pop    %ebx
  801070:	5e                   	pop    %esi
  801071:	5f                   	pop    %edi
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	57                   	push   %edi
  801078:	56                   	push   %esi
  801079:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107a:	ba 00 00 00 00       	mov    $0x0,%edx
  80107f:	b8 10 00 00 00       	mov    $0x10,%eax
  801084:	89 d1                	mov    %edx,%ecx
  801086:	89 d3                	mov    %edx,%ebx
  801088:	89 d7                	mov    %edx,%edi
  80108a:	89 d6                	mov    %edx,%esi
  80108c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80108e:	5b                   	pop    %ebx
  80108f:	5e                   	pop    %esi
  801090:	5f                   	pop    %edi
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    

00801093 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
	asm volatile("int %1\n"
  801099:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a4:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a9:	89 df                	mov    %ebx,%edi
  8010ab:	89 de                	mov    %ebx,%esi
  8010ad:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010af:	5b                   	pop    %ebx
  8010b0:	5e                   	pop    %esi
  8010b1:	5f                   	pop    %edi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    

008010b4 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	57                   	push   %edi
  8010b8:	56                   	push   %esi
  8010b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c5:	b8 12 00 00 00       	mov    $0x12,%eax
  8010ca:	89 df                	mov    %ebx,%edi
  8010cc:	89 de                	mov    %ebx,%esi
  8010ce:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010d0:	5b                   	pop    %ebx
  8010d1:	5e                   	pop    %esi
  8010d2:	5f                   	pop    %edi
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e9:	b8 13 00 00 00       	mov    $0x13,%eax
  8010ee:	89 df                	mov    %ebx,%edi
  8010f0:	89 de                	mov    %ebx,%esi
  8010f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7f 08                	jg     801100 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	50                   	push   %eax
  801104:	6a 13                	push   $0x13
  801106:	68 a8 2a 80 00       	push   $0x802aa8
  80110b:	6a 43                	push   $0x43
  80110d:	68 c5 2a 80 00       	push   $0x802ac5
  801112:	e8 76 11 00 00       	call   80228d <_panic>

00801117 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	b8 14 00 00 00       	mov    $0x14,%eax
  80112a:	89 cb                	mov    %ecx,%ebx
  80112c:	89 cf                	mov    %ecx,%edi
  80112e:	89 ce                	mov    %ecx,%esi
  801130:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	05 00 00 00 30       	add    $0x30000000,%eax
  801142:	c1 e8 0c             	shr    $0xc,%eax
}
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801157:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801166:	89 c2                	mov    %eax,%edx
  801168:	c1 ea 16             	shr    $0x16,%edx
  80116b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801172:	f6 c2 01             	test   $0x1,%dl
  801175:	74 2d                	je     8011a4 <fd_alloc+0x46>
  801177:	89 c2                	mov    %eax,%edx
  801179:	c1 ea 0c             	shr    $0xc,%edx
  80117c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801183:	f6 c2 01             	test   $0x1,%dl
  801186:	74 1c                	je     8011a4 <fd_alloc+0x46>
  801188:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80118d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801192:	75 d2                	jne    801166 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80119d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011a2:	eb 0a                	jmp    8011ae <fd_alloc+0x50>
			*fd_store = fd;
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b6:	83 f8 1f             	cmp    $0x1f,%eax
  8011b9:	77 30                	ja     8011eb <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011bb:	c1 e0 0c             	shl    $0xc,%eax
  8011be:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011c9:	f6 c2 01             	test   $0x1,%dl
  8011cc:	74 24                	je     8011f2 <fd_lookup+0x42>
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	c1 ea 0c             	shr    $0xc,%edx
  8011d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011da:	f6 c2 01             	test   $0x1,%dl
  8011dd:	74 1a                	je     8011f9 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    
		return -E_INVAL;
  8011eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f0:	eb f7                	jmp    8011e9 <fd_lookup+0x39>
		return -E_INVAL;
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb f0                	jmp    8011e9 <fd_lookup+0x39>
  8011f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fe:	eb e9                	jmp    8011e9 <fd_lookup+0x39>

00801200 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801209:	ba 00 00 00 00       	mov    $0x0,%edx
  80120e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801213:	39 08                	cmp    %ecx,(%eax)
  801215:	74 38                	je     80124f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801217:	83 c2 01             	add    $0x1,%edx
  80121a:	8b 04 95 50 2b 80 00 	mov    0x802b50(,%edx,4),%eax
  801221:	85 c0                	test   %eax,%eax
  801223:	75 ee                	jne    801213 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801225:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80122a:	8b 40 48             	mov    0x48(%eax),%eax
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	51                   	push   %ecx
  801231:	50                   	push   %eax
  801232:	68 d4 2a 80 00       	push   $0x802ad4
  801237:	e8 b5 f0 ff ff       	call   8002f1 <cprintf>
	*dev = 0;
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    
			*dev = devtab[i];
  80124f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801252:	89 01                	mov    %eax,(%ecx)
			return 0;
  801254:	b8 00 00 00 00       	mov    $0x0,%eax
  801259:	eb f2                	jmp    80124d <dev_lookup+0x4d>

0080125b <fd_close>:
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	83 ec 24             	sub    $0x24,%esp
  801264:	8b 75 08             	mov    0x8(%ebp),%esi
  801267:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80126a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801274:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801277:	50                   	push   %eax
  801278:	e8 33 ff ff ff       	call   8011b0 <fd_lookup>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 05                	js     80128b <fd_close+0x30>
	    || fd != fd2)
  801286:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801289:	74 16                	je     8012a1 <fd_close+0x46>
		return (must_exist ? r : 0);
  80128b:	89 f8                	mov    %edi,%eax
  80128d:	84 c0                	test   %al,%al
  80128f:	b8 00 00 00 00       	mov    $0x0,%eax
  801294:	0f 44 d8             	cmove  %eax,%ebx
}
  801297:	89 d8                	mov    %ebx,%eax
  801299:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5f                   	pop    %edi
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012a7:	50                   	push   %eax
  8012a8:	ff 36                	pushl  (%esi)
  8012aa:	e8 51 ff ff ff       	call   801200 <dev_lookup>
  8012af:	89 c3                	mov    %eax,%ebx
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 1a                	js     8012d2 <fd_close+0x77>
		if (dev->dev_close)
  8012b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	74 0b                	je     8012d2 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012c7:	83 ec 0c             	sub    $0xc,%esp
  8012ca:	56                   	push   %esi
  8012cb:	ff d0                	call   *%eax
  8012cd:	89 c3                	mov    %eax,%ebx
  8012cf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012d2:	83 ec 08             	sub    $0x8,%esp
  8012d5:	56                   	push   %esi
  8012d6:	6a 00                	push   $0x0
  8012d8:	e8 ea fb ff ff       	call   800ec7 <sys_page_unmap>
	return r;
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	eb b5                	jmp    801297 <fd_close+0x3c>

008012e2 <close>:

int
close(int fdnum)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 bc fe ff ff       	call   8011b0 <fd_lookup>
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	79 02                	jns    8012fd <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    
		return fd_close(fd, 1);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	6a 01                	push   $0x1
  801302:	ff 75 f4             	pushl  -0xc(%ebp)
  801305:	e8 51 ff ff ff       	call   80125b <fd_close>
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	eb ec                	jmp    8012fb <close+0x19>

0080130f <close_all>:

void
close_all(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	53                   	push   %ebx
  801313:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801316:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	53                   	push   %ebx
  80131f:	e8 be ff ff ff       	call   8012e2 <close>
	for (i = 0; i < MAXFD; i++)
  801324:	83 c3 01             	add    $0x1,%ebx
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	83 fb 20             	cmp    $0x20,%ebx
  80132d:	75 ec                	jne    80131b <close_all+0xc>
}
  80132f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	57                   	push   %edi
  801338:	56                   	push   %esi
  801339:	53                   	push   %ebx
  80133a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80133d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 67 fe ff ff       	call   8011b0 <fd_lookup>
  801349:	89 c3                	mov    %eax,%ebx
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	0f 88 81 00 00 00    	js     8013d7 <dup+0xa3>
		return r;
	close(newfdnum);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	e8 81 ff ff ff       	call   8012e2 <close>

	newfd = INDEX2FD(newfdnum);
  801361:	8b 75 0c             	mov    0xc(%ebp),%esi
  801364:	c1 e6 0c             	shl    $0xc,%esi
  801367:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80136d:	83 c4 04             	add    $0x4,%esp
  801370:	ff 75 e4             	pushl  -0x1c(%ebp)
  801373:	e8 cf fd ff ff       	call   801147 <fd2data>
  801378:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80137a:	89 34 24             	mov    %esi,(%esp)
  80137d:	e8 c5 fd ff ff       	call   801147 <fd2data>
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801387:	89 d8                	mov    %ebx,%eax
  801389:	c1 e8 16             	shr    $0x16,%eax
  80138c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801393:	a8 01                	test   $0x1,%al
  801395:	74 11                	je     8013a8 <dup+0x74>
  801397:	89 d8                	mov    %ebx,%eax
  801399:	c1 e8 0c             	shr    $0xc,%eax
  80139c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a3:	f6 c2 01             	test   $0x1,%dl
  8013a6:	75 39                	jne    8013e1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ab:	89 d0                	mov    %edx,%eax
  8013ad:	c1 e8 0c             	shr    $0xc,%eax
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	83 ec 0c             	sub    $0xc,%esp
  8013ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bf:	50                   	push   %eax
  8013c0:	56                   	push   %esi
  8013c1:	6a 00                	push   $0x0
  8013c3:	52                   	push   %edx
  8013c4:	6a 00                	push   $0x0
  8013c6:	e8 ba fa ff ff       	call   800e85 <sys_page_map>
  8013cb:	89 c3                	mov    %eax,%ebx
  8013cd:	83 c4 20             	add    $0x20,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 31                	js     801405 <dup+0xd1>
		goto err;

	return newfdnum;
  8013d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5f                   	pop    %edi
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f0:	50                   	push   %eax
  8013f1:	57                   	push   %edi
  8013f2:	6a 00                	push   $0x0
  8013f4:	53                   	push   %ebx
  8013f5:	6a 00                	push   $0x0
  8013f7:	e8 89 fa ff ff       	call   800e85 <sys_page_map>
  8013fc:	89 c3                	mov    %eax,%ebx
  8013fe:	83 c4 20             	add    $0x20,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	79 a3                	jns    8013a8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	56                   	push   %esi
  801409:	6a 00                	push   $0x0
  80140b:	e8 b7 fa ff ff       	call   800ec7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801410:	83 c4 08             	add    $0x8,%esp
  801413:	57                   	push   %edi
  801414:	6a 00                	push   $0x0
  801416:	e8 ac fa ff ff       	call   800ec7 <sys_page_unmap>
	return r;
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	eb b7                	jmp    8013d7 <dup+0xa3>

00801420 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	53                   	push   %ebx
  80142f:	e8 7c fd ff ff       	call   8011b0 <fd_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 3f                	js     80147a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	ff 30                	pushl  (%eax)
  801447:	e8 b4 fd ff ff       	call   801200 <dev_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 27                	js     80147a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801456:	8b 42 08             	mov    0x8(%edx),%eax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	83 f8 01             	cmp    $0x1,%eax
  80145f:	74 1e                	je     80147f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	8b 40 08             	mov    0x8(%eax),%eax
  801467:	85 c0                	test   %eax,%eax
  801469:	74 35                	je     8014a0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	ff 75 10             	pushl  0x10(%ebp)
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	52                   	push   %edx
  801475:	ff d0                	call   *%eax
  801477:	83 c4 10             	add    $0x10,%esp
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	53                   	push   %ebx
  80148b:	50                   	push   %eax
  80148c:	68 15 2b 80 00       	push   $0x802b15
  801491:	e8 5b ee ff ff       	call   8002f1 <cprintf>
		return -E_INVAL;
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149e:	eb da                	jmp    80147a <read+0x5a>
		return -E_NOT_SUPP;
  8014a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a5:	eb d3                	jmp    80147a <read+0x5a>

008014a7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	57                   	push   %edi
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bb:	39 f3                	cmp    %esi,%ebx
  8014bd:	73 23                	jae    8014e2 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	89 f0                	mov    %esi,%eax
  8014c4:	29 d8                	sub    %ebx,%eax
  8014c6:	50                   	push   %eax
  8014c7:	89 d8                	mov    %ebx,%eax
  8014c9:	03 45 0c             	add    0xc(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	57                   	push   %edi
  8014ce:	e8 4d ff ff ff       	call   801420 <read>
		if (m < 0)
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 06                	js     8014e0 <readn+0x39>
			return m;
		if (m == 0)
  8014da:	74 06                	je     8014e2 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014dc:	01 c3                	add    %eax,%ebx
  8014de:	eb db                	jmp    8014bb <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014e2:	89 d8                	mov    %ebx,%eax
  8014e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e7:	5b                   	pop    %ebx
  8014e8:	5e                   	pop    %esi
  8014e9:	5f                   	pop    %edi
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 1c             	sub    $0x1c,%esp
  8014f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	53                   	push   %ebx
  8014fb:	e8 b0 fc ff ff       	call   8011b0 <fd_lookup>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 3a                	js     801541 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150d:	50                   	push   %eax
  80150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801511:	ff 30                	pushl  (%eax)
  801513:	e8 e8 fc ff ff       	call   801200 <dev_lookup>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 22                	js     801541 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801526:	74 1e                	je     801546 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152b:	8b 52 0c             	mov    0xc(%edx),%edx
  80152e:	85 d2                	test   %edx,%edx
  801530:	74 35                	je     801567 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	ff 75 10             	pushl  0x10(%ebp)
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	50                   	push   %eax
  80153c:	ff d2                	call   *%edx
  80153e:	83 c4 10             	add    $0x10,%esp
}
  801541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801544:	c9                   	leave  
  801545:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801546:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80154b:	8b 40 48             	mov    0x48(%eax),%eax
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	53                   	push   %ebx
  801552:	50                   	push   %eax
  801553:	68 31 2b 80 00       	push   $0x802b31
  801558:	e8 94 ed ff ff       	call   8002f1 <cprintf>
		return -E_INVAL;
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801565:	eb da                	jmp    801541 <write+0x55>
		return -E_NOT_SUPP;
  801567:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156c:	eb d3                	jmp    801541 <write+0x55>

0080156e <seek>:

int
seek(int fdnum, off_t offset)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 30 fc ff ff       	call   8011b0 <fd_lookup>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 0e                	js     801595 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	53                   	push   %ebx
  80159b:	83 ec 1c             	sub    $0x1c,%esp
  80159e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a4:	50                   	push   %eax
  8015a5:	53                   	push   %ebx
  8015a6:	e8 05 fc ff ff       	call   8011b0 <fd_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 37                	js     8015e9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b8:	50                   	push   %eax
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bc:	ff 30                	pushl  (%eax)
  8015be:	e8 3d fc ff ff       	call   801200 <dev_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 1f                	js     8015e9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d1:	74 1b                	je     8015ee <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d6:	8b 52 18             	mov    0x18(%edx),%edx
  8015d9:	85 d2                	test   %edx,%edx
  8015db:	74 32                	je     80160f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	50                   	push   %eax
  8015e4:	ff d2                	call   *%edx
  8015e6:	83 c4 10             	add    $0x10,%esp
}
  8015e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ee:	a1 4c 50 80 00       	mov    0x80504c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f3:	8b 40 48             	mov    0x48(%eax),%eax
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	53                   	push   %ebx
  8015fa:	50                   	push   %eax
  8015fb:	68 f4 2a 80 00       	push   $0x802af4
  801600:	e8 ec ec ff ff       	call   8002f1 <cprintf>
		return -E_INVAL;
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160d:	eb da                	jmp    8015e9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80160f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801614:	eb d3                	jmp    8015e9 <ftruncate+0x52>

00801616 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 1c             	sub    $0x1c,%esp
  80161d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801620:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	e8 84 fb ff ff       	call   8011b0 <fd_lookup>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	85 c0                	test   %eax,%eax
  801631:	78 4b                	js     80167e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163d:	ff 30                	pushl  (%eax)
  80163f:	e8 bc fb ff ff       	call   801200 <dev_lookup>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 33                	js     80167e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801652:	74 2f                	je     801683 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801654:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801657:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80165e:	00 00 00 
	stat->st_isdir = 0;
  801661:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801668:	00 00 00 
	stat->st_dev = dev;
  80166b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	53                   	push   %ebx
  801675:	ff 75 f0             	pushl  -0x10(%ebp)
  801678:	ff 50 14             	call   *0x14(%eax)
  80167b:	83 c4 10             	add    $0x10,%esp
}
  80167e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801681:	c9                   	leave  
  801682:	c3                   	ret    
		return -E_NOT_SUPP;
  801683:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801688:	eb f4                	jmp    80167e <fstat+0x68>

0080168a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	6a 00                	push   $0x0
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	e8 22 02 00 00       	call   8018be <open>
  80169c:	89 c3                	mov    %eax,%ebx
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	78 1b                	js     8016c0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016a5:	83 ec 08             	sub    $0x8,%esp
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	50                   	push   %eax
  8016ac:	e8 65 ff ff ff       	call   801616 <fstat>
  8016b1:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b3:	89 1c 24             	mov    %ebx,(%esp)
  8016b6:	e8 27 fc ff ff       	call   8012e2 <close>
	return r;
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	89 f3                	mov    %esi,%ebx
}
  8016c0:	89 d8                	mov    %ebx,%eax
  8016c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	89 c6                	mov    %eax,%esi
  8016d0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016d2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016d9:	74 27                	je     801702 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016db:	6a 07                	push   $0x7
  8016dd:	68 00 60 80 00       	push   $0x806000
  8016e2:	56                   	push   %esi
  8016e3:	ff 35 00 40 80 00    	pushl  0x804000
  8016e9:	e8 69 0c 00 00       	call   802357 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ee:	83 c4 0c             	add    $0xc,%esp
  8016f1:	6a 00                	push   $0x0
  8016f3:	53                   	push   %ebx
  8016f4:	6a 00                	push   $0x0
  8016f6:	e8 f3 0b 00 00       	call   8022ee <ipc_recv>
}
  8016fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	6a 01                	push   $0x1
  801707:	e8 a3 0c 00 00       	call   8023af <ipc_find_env>
  80170c:	a3 00 40 80 00       	mov    %eax,0x804000
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	eb c5                	jmp    8016db <fsipc+0x12>

00801716 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8b 40 0c             	mov    0xc(%eax),%eax
  801722:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 02 00 00 00       	mov    $0x2,%eax
  801739:	e8 8b ff ff ff       	call   8016c9 <fsipc>
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <devfile_flush>:
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	8b 40 0c             	mov    0xc(%eax),%eax
  80174c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	b8 06 00 00 00       	mov    $0x6,%eax
  80175b:	e8 69 ff ff ff       	call   8016c9 <fsipc>
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <devfile_stat>:
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	53                   	push   %ebx
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8b 40 0c             	mov    0xc(%eax),%eax
  801772:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	b8 05 00 00 00       	mov    $0x5,%eax
  801781:	e8 43 ff ff ff       	call   8016c9 <fsipc>
  801786:	85 c0                	test   %eax,%eax
  801788:	78 2c                	js     8017b6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	68 00 60 80 00       	push   $0x806000
  801792:	53                   	push   %ebx
  801793:	e8 b8 f2 ff ff       	call   800a50 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801798:	a1 80 60 80 00       	mov    0x806080,%eax
  80179d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a3:	a1 84 60 80 00       	mov    0x806084,%eax
  8017a8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <devfile_write>:
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8017d0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017d6:	53                   	push   %ebx
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	68 08 60 80 00       	push   $0x806008
  8017df:	e8 5c f4 ff ff       	call   800c40 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ee:	e8 d6 fe ff ff       	call   8016c9 <fsipc>
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 0b                	js     801805 <devfile_write+0x4a>
	assert(r <= n);
  8017fa:	39 d8                	cmp    %ebx,%eax
  8017fc:	77 0c                	ja     80180a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017fe:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801803:	7f 1e                	jg     801823 <devfile_write+0x68>
}
  801805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801808:	c9                   	leave  
  801809:	c3                   	ret    
	assert(r <= n);
  80180a:	68 64 2b 80 00       	push   $0x802b64
  80180f:	68 6b 2b 80 00       	push   $0x802b6b
  801814:	68 98 00 00 00       	push   $0x98
  801819:	68 80 2b 80 00       	push   $0x802b80
  80181e:	e8 6a 0a 00 00       	call   80228d <_panic>
	assert(r <= PGSIZE);
  801823:	68 8b 2b 80 00       	push   $0x802b8b
  801828:	68 6b 2b 80 00       	push   $0x802b6b
  80182d:	68 99 00 00 00       	push   $0x99
  801832:	68 80 2b 80 00       	push   $0x802b80
  801837:	e8 51 0a 00 00       	call   80228d <_panic>

0080183c <devfile_read>:
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8b 40 0c             	mov    0xc(%eax),%eax
  80184a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80184f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801855:	ba 00 00 00 00       	mov    $0x0,%edx
  80185a:	b8 03 00 00 00       	mov    $0x3,%eax
  80185f:	e8 65 fe ff ff       	call   8016c9 <fsipc>
  801864:	89 c3                	mov    %eax,%ebx
  801866:	85 c0                	test   %eax,%eax
  801868:	78 1f                	js     801889 <devfile_read+0x4d>
	assert(r <= n);
  80186a:	39 f0                	cmp    %esi,%eax
  80186c:	77 24                	ja     801892 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80186e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801873:	7f 33                	jg     8018a8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	50                   	push   %eax
  801879:	68 00 60 80 00       	push   $0x806000
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	e8 58 f3 ff ff       	call   800bde <memmove>
	return r;
  801886:	83 c4 10             	add    $0x10,%esp
}
  801889:	89 d8                	mov    %ebx,%eax
  80188b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    
	assert(r <= n);
  801892:	68 64 2b 80 00       	push   $0x802b64
  801897:	68 6b 2b 80 00       	push   $0x802b6b
  80189c:	6a 7c                	push   $0x7c
  80189e:	68 80 2b 80 00       	push   $0x802b80
  8018a3:	e8 e5 09 00 00       	call   80228d <_panic>
	assert(r <= PGSIZE);
  8018a8:	68 8b 2b 80 00       	push   $0x802b8b
  8018ad:	68 6b 2b 80 00       	push   $0x802b6b
  8018b2:	6a 7d                	push   $0x7d
  8018b4:	68 80 2b 80 00       	push   $0x802b80
  8018b9:	e8 cf 09 00 00       	call   80228d <_panic>

008018be <open>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 1c             	sub    $0x1c,%esp
  8018c6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018c9:	56                   	push   %esi
  8018ca:	e8 48 f1 ff ff       	call   800a17 <strlen>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d7:	7f 6c                	jg     801945 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018df:	50                   	push   %eax
  8018e0:	e8 79 f8 ff ff       	call   80115e <fd_alloc>
  8018e5:	89 c3                	mov    %eax,%ebx
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 3c                	js     80192a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018ee:	83 ec 08             	sub    $0x8,%esp
  8018f1:	56                   	push   %esi
  8018f2:	68 00 60 80 00       	push   $0x806000
  8018f7:	e8 54 f1 ff ff       	call   800a50 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ff:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801907:	b8 01 00 00 00       	mov    $0x1,%eax
  80190c:	e8 b8 fd ff ff       	call   8016c9 <fsipc>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	85 c0                	test   %eax,%eax
  801918:	78 19                	js     801933 <open+0x75>
	return fd2num(fd);
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	ff 75 f4             	pushl  -0xc(%ebp)
  801920:	e8 12 f8 ff ff       	call   801137 <fd2num>
  801925:	89 c3                	mov    %eax,%ebx
  801927:	83 c4 10             	add    $0x10,%esp
}
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    
		fd_close(fd, 0);
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	6a 00                	push   $0x0
  801938:	ff 75 f4             	pushl  -0xc(%ebp)
  80193b:	e8 1b f9 ff ff       	call   80125b <fd_close>
		return r;
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	eb e5                	jmp    80192a <open+0x6c>
		return -E_BAD_PATH;
  801945:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194a:	eb de                	jmp    80192a <open+0x6c>

0080194c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	b8 08 00 00 00       	mov    $0x8,%eax
  80195c:	e8 68 fd ff ff       	call   8016c9 <fsipc>
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801969:	68 97 2b 80 00       	push   $0x802b97
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	e8 da f0 ff ff       	call   800a50 <strcpy>
	return 0;
}
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <devsock_close>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	53                   	push   %ebx
  801981:	83 ec 10             	sub    $0x10,%esp
  801984:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801987:	53                   	push   %ebx
  801988:	e8 61 0a 00 00       	call   8023ee <pageref>
  80198d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801990:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801995:	83 f8 01             	cmp    $0x1,%eax
  801998:	74 07                	je     8019a1 <devsock_close+0x24>
}
  80199a:	89 d0                	mov    %edx,%eax
  80199c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 73 0c             	pushl  0xc(%ebx)
  8019a7:	e8 b9 02 00 00       	call   801c65 <nsipc_close>
  8019ac:	89 c2                	mov    %eax,%edx
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	eb e7                	jmp    80199a <devsock_close+0x1d>

008019b3 <devsock_write>:
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 10             	pushl  0x10(%ebp)
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	ff 70 0c             	pushl  0xc(%eax)
  8019c7:	e8 76 03 00 00       	call   801d42 <nsipc_send>
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <devsock_read>:
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	ff 75 10             	pushl  0x10(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	ff 70 0c             	pushl  0xc(%eax)
  8019e2:	e8 ef 02 00 00       	call   801cd6 <nsipc_recv>
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <fd2sockid>:
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	e8 b7 f7 ff ff       	call   8011b0 <fd_lookup>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 10                	js     801a10 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a03:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a09:	39 08                	cmp    %ecx,(%eax)
  801a0b:	75 05                	jne    801a12 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a0d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    
		return -E_NOT_SUPP;
  801a12:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a17:	eb f7                	jmp    801a10 <fd2sockid+0x27>

00801a19 <alloc_sockfd>:
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	56                   	push   %esi
  801a1d:	53                   	push   %ebx
  801a1e:	83 ec 1c             	sub    $0x1c,%esp
  801a21:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a26:	50                   	push   %eax
  801a27:	e8 32 f7 ff ff       	call   80115e <fd_alloc>
  801a2c:	89 c3                	mov    %eax,%ebx
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 43                	js     801a78 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	68 07 04 00 00       	push   $0x407
  801a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a40:	6a 00                	push   $0x0
  801a42:	e8 fb f3 ff ff       	call   800e42 <sys_page_alloc>
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 28                	js     801a78 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a59:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a65:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	50                   	push   %eax
  801a6c:	e8 c6 f6 ff ff       	call   801137 <fd2num>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	eb 0c                	jmp    801a84 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	56                   	push   %esi
  801a7c:	e8 e4 01 00 00       	call   801c65 <nsipc_close>
		return r;
  801a81:	83 c4 10             	add    $0x10,%esp
}
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5e                   	pop    %esi
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <accept>:
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	e8 4e ff ff ff       	call   8019e9 <fd2sockid>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 1b                	js     801aba <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	e8 0e 01 00 00       	call   801bbc <nsipc_accept>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 05                	js     801aba <accept+0x2d>
	return alloc_sockfd(r);
  801ab5:	e8 5f ff ff ff       	call   801a19 <alloc_sockfd>
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <bind>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	e8 1f ff ff ff       	call   8019e9 <fd2sockid>
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 12                	js     801ae0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	e8 31 01 00 00       	call   801c0e <nsipc_bind>
  801add:	83 c4 10             	add    $0x10,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <shutdown>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	e8 f9 fe ff ff       	call   8019e9 <fd2sockid>
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 0f                	js     801b03 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	50                   	push   %eax
  801afb:	e8 43 01 00 00       	call   801c43 <nsipc_shutdown>
  801b00:	83 c4 10             	add    $0x10,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <connect>:
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	e8 d6 fe ff ff       	call   8019e9 <fd2sockid>
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 12                	js     801b29 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	ff 75 10             	pushl  0x10(%ebp)
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	50                   	push   %eax
  801b21:	e8 59 01 00 00       	call   801c7f <nsipc_connect>
  801b26:	83 c4 10             	add    $0x10,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <listen>:
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	e8 b0 fe ff ff       	call   8019e9 <fd2sockid>
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 0f                	js     801b4c <listen+0x21>
	return nsipc_listen(r, backlog);
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	e8 6b 01 00 00       	call   801cb4 <nsipc_listen>
  801b49:	83 c4 10             	add    $0x10,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <socket>:

int
socket(int domain, int type, int protocol)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b54:	ff 75 10             	pushl  0x10(%ebp)
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 3e 02 00 00       	call   801da0 <nsipc_socket>
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	85 c0                	test   %eax,%eax
  801b67:	78 05                	js     801b6e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b69:	e8 ab fe ff ff       	call   801a19 <alloc_sockfd>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	53                   	push   %ebx
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b79:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b80:	74 26                	je     801ba8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b82:	6a 07                	push   $0x7
  801b84:	68 00 70 80 00       	push   $0x807000
  801b89:	53                   	push   %ebx
  801b8a:	ff 35 04 40 80 00    	pushl  0x804004
  801b90:	e8 c2 07 00 00       	call   802357 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b95:	83 c4 0c             	add    $0xc,%esp
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	e8 4b 07 00 00       	call   8022ee <ipc_recv>
}
  801ba3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	6a 02                	push   $0x2
  801bad:	e8 fd 07 00 00       	call   8023af <ipc_find_env>
  801bb2:	a3 04 40 80 00       	mov    %eax,0x804004
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	eb c6                	jmp    801b82 <nsipc+0x12>

00801bbc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bcc:	8b 06                	mov    (%esi),%eax
  801bce:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd8:	e8 93 ff ff ff       	call   801b70 <nsipc>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	79 09                	jns    801bec <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	ff 35 10 70 80 00    	pushl  0x807010
  801bf5:	68 00 70 80 00       	push   $0x807000
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	e8 dc ef ff ff       	call   800bde <memmove>
		*addrlen = ret->ret_addrlen;
  801c02:	a1 10 70 80 00       	mov    0x807010,%eax
  801c07:	89 06                	mov    %eax,(%esi)
  801c09:	83 c4 10             	add    $0x10,%esp
	return r;
  801c0c:	eb d5                	jmp    801be3 <nsipc_accept+0x27>

00801c0e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	53                   	push   %ebx
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c20:	53                   	push   %ebx
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	68 04 70 80 00       	push   $0x807004
  801c29:	e8 b0 ef ff ff       	call   800bde <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c2e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801c34:	b8 02 00 00 00       	mov    $0x2,%eax
  801c39:	e8 32 ff ff ff       	call   801b70 <nsipc>
}
  801c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c54:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801c59:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5e:	e8 0d ff ff ff       	call   801b70 <nsipc>
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <nsipc_close>:

int
nsipc_close(int s)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801c73:	b8 04 00 00 00       	mov    $0x4,%eax
  801c78:	e8 f3 fe ff ff       	call   801b70 <nsipc>
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 08             	sub    $0x8,%esp
  801c86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c91:	53                   	push   %ebx
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	68 04 70 80 00       	push   $0x807004
  801c9a:	e8 3f ef ff ff       	call   800bde <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c9f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801ca5:	b8 05 00 00 00       	mov    $0x5,%eax
  801caa:	e8 c1 fe ff ff       	call   801b70 <nsipc>
}
  801caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801cca:	b8 06 00 00 00       	mov    $0x6,%eax
  801ccf:	e8 9c fe ff ff       	call   801b70 <nsipc>
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801ce6:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801cec:	8b 45 14             	mov    0x14(%ebp),%eax
  801cef:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cf4:	b8 07 00 00 00       	mov    $0x7,%eax
  801cf9:	e8 72 fe ff ff       	call   801b70 <nsipc>
  801cfe:	89 c3                	mov    %eax,%ebx
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 1f                	js     801d23 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d04:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d09:	7f 21                	jg     801d2c <nsipc_recv+0x56>
  801d0b:	39 c6                	cmp    %eax,%esi
  801d0d:	7c 1d                	jl     801d2c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	50                   	push   %eax
  801d13:	68 00 70 80 00       	push   $0x807000
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	e8 be ee ff ff       	call   800bde <memmove>
  801d20:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d23:	89 d8                	mov    %ebx,%eax
  801d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d2c:	68 a3 2b 80 00       	push   $0x802ba3
  801d31:	68 6b 2b 80 00       	push   $0x802b6b
  801d36:	6a 62                	push   $0x62
  801d38:	68 b8 2b 80 00       	push   $0x802bb8
  801d3d:	e8 4b 05 00 00       	call   80228d <_panic>

00801d42 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801d54:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d5a:	7f 2e                	jg     801d8a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	53                   	push   %ebx
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	68 0c 70 80 00       	push   $0x80700c
  801d68:	e8 71 ee ff ff       	call   800bde <memmove>
	nsipcbuf.send.req_size = size;
  801d6d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801d7b:	b8 08 00 00 00       	mov    $0x8,%eax
  801d80:	e8 eb fd ff ff       	call   801b70 <nsipc>
}
  801d85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    
	assert(size < 1600);
  801d8a:	68 c4 2b 80 00       	push   $0x802bc4
  801d8f:	68 6b 2b 80 00       	push   $0x802b6b
  801d94:	6a 6d                	push   $0x6d
  801d96:	68 b8 2b 80 00       	push   $0x802bb8
  801d9b:	e8 ed 04 00 00       	call   80228d <_panic>

00801da0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801db6:	8b 45 10             	mov    0x10(%ebp),%eax
  801db9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801dbe:	b8 09 00 00 00       	mov    $0x9,%eax
  801dc3:	e8 a8 fd ff ff       	call   801b70 <nsipc>
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	e8 6a f3 ff ff       	call   801147 <fd2data>
  801ddd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ddf:	83 c4 08             	add    $0x8,%esp
  801de2:	68 d0 2b 80 00       	push   $0x802bd0
  801de7:	53                   	push   %ebx
  801de8:	e8 63 ec ff ff       	call   800a50 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ded:	8b 46 04             	mov    0x4(%esi),%eax
  801df0:	2b 06                	sub    (%esi),%eax
  801df2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801df8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dff:	00 00 00 
	stat->st_dev = &devpipe;
  801e02:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e09:	30 80 00 
	return 0;
}
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    

00801e18 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	53                   	push   %ebx
  801e1c:	83 ec 0c             	sub    $0xc,%esp
  801e1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e22:	53                   	push   %ebx
  801e23:	6a 00                	push   $0x0
  801e25:	e8 9d f0 ff ff       	call   800ec7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e2a:	89 1c 24             	mov    %ebx,(%esp)
  801e2d:	e8 15 f3 ff ff       	call   801147 <fd2data>
  801e32:	83 c4 08             	add    $0x8,%esp
  801e35:	50                   	push   %eax
  801e36:	6a 00                	push   $0x0
  801e38:	e8 8a f0 ff ff       	call   800ec7 <sys_page_unmap>
}
  801e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <_pipeisclosed>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	89 c7                	mov    %eax,%edi
  801e4d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e4f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e54:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	57                   	push   %edi
  801e5b:	e8 8e 05 00 00       	call   8023ee <pageref>
  801e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e63:	89 34 24             	mov    %esi,(%esp)
  801e66:	e8 83 05 00 00       	call   8023ee <pageref>
		nn = thisenv->env_runs;
  801e6b:	8b 15 4c 50 80 00    	mov    0x80504c,%edx
  801e71:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	39 cb                	cmp    %ecx,%ebx
  801e79:	74 1b                	je     801e96 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e7b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e7e:	75 cf                	jne    801e4f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e80:	8b 42 58             	mov    0x58(%edx),%eax
  801e83:	6a 01                	push   $0x1
  801e85:	50                   	push   %eax
  801e86:	53                   	push   %ebx
  801e87:	68 d7 2b 80 00       	push   $0x802bd7
  801e8c:	e8 60 e4 ff ff       	call   8002f1 <cprintf>
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	eb b9                	jmp    801e4f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e96:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e99:	0f 94 c0             	sete   %al
  801e9c:	0f b6 c0             	movzbl %al,%eax
}
  801e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea2:	5b                   	pop    %ebx
  801ea3:	5e                   	pop    %esi
  801ea4:	5f                   	pop    %edi
  801ea5:	5d                   	pop    %ebp
  801ea6:	c3                   	ret    

00801ea7 <devpipe_write>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	57                   	push   %edi
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	83 ec 28             	sub    $0x28,%esp
  801eb0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eb3:	56                   	push   %esi
  801eb4:	e8 8e f2 ff ff       	call   801147 <fd2data>
  801eb9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec6:	74 4f                	je     801f17 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ec8:	8b 43 04             	mov    0x4(%ebx),%eax
  801ecb:	8b 0b                	mov    (%ebx),%ecx
  801ecd:	8d 51 20             	lea    0x20(%ecx),%edx
  801ed0:	39 d0                	cmp    %edx,%eax
  801ed2:	72 14                	jb     801ee8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ed4:	89 da                	mov    %ebx,%edx
  801ed6:	89 f0                	mov    %esi,%eax
  801ed8:	e8 65 ff ff ff       	call   801e42 <_pipeisclosed>
  801edd:	85 c0                	test   %eax,%eax
  801edf:	75 3b                	jne    801f1c <devpipe_write+0x75>
			sys_yield();
  801ee1:	e8 3d ef ff ff       	call   800e23 <sys_yield>
  801ee6:	eb e0                	jmp    801ec8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eeb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eef:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ef2:	89 c2                	mov    %eax,%edx
  801ef4:	c1 fa 1f             	sar    $0x1f,%edx
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	c1 e9 1b             	shr    $0x1b,%ecx
  801efc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eff:	83 e2 1f             	and    $0x1f,%edx
  801f02:	29 ca                	sub    %ecx,%edx
  801f04:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f08:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f0c:	83 c0 01             	add    $0x1,%eax
  801f0f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f12:	83 c7 01             	add    $0x1,%edi
  801f15:	eb ac                	jmp    801ec3 <devpipe_write+0x1c>
	return i;
  801f17:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1a:	eb 05                	jmp    801f21 <devpipe_write+0x7a>
				return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5f                   	pop    %edi
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    

00801f29 <devpipe_read>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	57                   	push   %edi
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
  801f2f:	83 ec 18             	sub    $0x18,%esp
  801f32:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f35:	57                   	push   %edi
  801f36:	e8 0c f2 ff ff       	call   801147 <fd2data>
  801f3b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	be 00 00 00 00       	mov    $0x0,%esi
  801f45:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f48:	75 14                	jne    801f5e <devpipe_read+0x35>
	return i;
  801f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4d:	eb 02                	jmp    801f51 <devpipe_read+0x28>
				return i;
  801f4f:	89 f0                	mov    %esi,%eax
}
  801f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    
			sys_yield();
  801f59:	e8 c5 ee ff ff       	call   800e23 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f5e:	8b 03                	mov    (%ebx),%eax
  801f60:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f63:	75 18                	jne    801f7d <devpipe_read+0x54>
			if (i > 0)
  801f65:	85 f6                	test   %esi,%esi
  801f67:	75 e6                	jne    801f4f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	89 f8                	mov    %edi,%eax
  801f6d:	e8 d0 fe ff ff       	call   801e42 <_pipeisclosed>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	74 e3                	je     801f59 <devpipe_read+0x30>
				return 0;
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	eb d4                	jmp    801f51 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f7d:	99                   	cltd   
  801f7e:	c1 ea 1b             	shr    $0x1b,%edx
  801f81:	01 d0                	add    %edx,%eax
  801f83:	83 e0 1f             	and    $0x1f,%eax
  801f86:	29 d0                	sub    %edx,%eax
  801f88:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f90:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f93:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f96:	83 c6 01             	add    $0x1,%esi
  801f99:	eb aa                	jmp    801f45 <devpipe_read+0x1c>

00801f9b <pipe>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa6:	50                   	push   %eax
  801fa7:	e8 b2 f1 ff ff       	call   80115e <fd_alloc>
  801fac:	89 c3                	mov    %eax,%ebx
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	0f 88 23 01 00 00    	js     8020dc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 07 04 00 00       	push   $0x407
  801fc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc4:	6a 00                	push   $0x0
  801fc6:	e8 77 ee ff ff       	call   800e42 <sys_page_alloc>
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	0f 88 04 01 00 00    	js     8020dc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fde:	50                   	push   %eax
  801fdf:	e8 7a f1 ff ff       	call   80115e <fd_alloc>
  801fe4:	89 c3                	mov    %eax,%ebx
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	0f 88 db 00 00 00    	js     8020cc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	68 07 04 00 00       	push   $0x407
  801ff9:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffc:	6a 00                	push   $0x0
  801ffe:	e8 3f ee ff ff       	call   800e42 <sys_page_alloc>
  802003:	89 c3                	mov    %eax,%ebx
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	85 c0                	test   %eax,%eax
  80200a:	0f 88 bc 00 00 00    	js     8020cc <pipe+0x131>
	va = fd2data(fd0);
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	ff 75 f4             	pushl  -0xc(%ebp)
  802016:	e8 2c f1 ff ff       	call   801147 <fd2data>
  80201b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201d:	83 c4 0c             	add    $0xc,%esp
  802020:	68 07 04 00 00       	push   $0x407
  802025:	50                   	push   %eax
  802026:	6a 00                	push   $0x0
  802028:	e8 15 ee ff ff       	call   800e42 <sys_page_alloc>
  80202d:	89 c3                	mov    %eax,%ebx
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	85 c0                	test   %eax,%eax
  802034:	0f 88 82 00 00 00    	js     8020bc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	ff 75 f0             	pushl  -0x10(%ebp)
  802040:	e8 02 f1 ff ff       	call   801147 <fd2data>
  802045:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80204c:	50                   	push   %eax
  80204d:	6a 00                	push   $0x0
  80204f:	56                   	push   %esi
  802050:	6a 00                	push   $0x0
  802052:	e8 2e ee ff ff       	call   800e85 <sys_page_map>
  802057:	89 c3                	mov    %eax,%ebx
  802059:	83 c4 20             	add    $0x20,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	78 4e                	js     8020ae <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802060:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80206a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802074:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802077:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	ff 75 f4             	pushl  -0xc(%ebp)
  802089:	e8 a9 f0 ff ff       	call   801137 <fd2num>
  80208e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802091:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802093:	83 c4 04             	add    $0x4,%esp
  802096:	ff 75 f0             	pushl  -0x10(%ebp)
  802099:	e8 99 f0 ff ff       	call   801137 <fd2num>
  80209e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020ac:	eb 2e                	jmp    8020dc <pipe+0x141>
	sys_page_unmap(0, va);
  8020ae:	83 ec 08             	sub    $0x8,%esp
  8020b1:	56                   	push   %esi
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 0e ee ff ff       	call   800ec7 <sys_page_unmap>
  8020b9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 fe ed ff ff       	call   800ec7 <sys_page_unmap>
  8020c9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020cc:	83 ec 08             	sub    $0x8,%esp
  8020cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 ee ed ff ff       	call   800ec7 <sys_page_unmap>
  8020d9:	83 c4 10             	add    $0x10,%esp
}
  8020dc:	89 d8                	mov    %ebx,%eax
  8020de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    

008020e5 <pipeisclosed>:
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ee:	50                   	push   %eax
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	e8 b9 f0 ff ff       	call   8011b0 <fd_lookup>
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 18                	js     802116 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	ff 75 f4             	pushl  -0xc(%ebp)
  802104:	e8 3e f0 ff ff       	call   801147 <fd2data>
	return _pipeisclosed(fd, p);
  802109:	89 c2                	mov    %eax,%edx
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	e8 2f fd ff ff       	call   801e42 <_pipeisclosed>
  802113:	83 c4 10             	add    $0x10,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	c3                   	ret    

0080211e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802124:	68 ef 2b 80 00       	push   $0x802bef
  802129:	ff 75 0c             	pushl  0xc(%ebp)
  80212c:	e8 1f e9 ff ff       	call   800a50 <strcpy>
	return 0;
}
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <devcons_write>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	57                   	push   %edi
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802144:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802149:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80214f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802152:	73 31                	jae    802185 <devcons_write+0x4d>
		m = n - tot;
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802157:	29 f3                	sub    %esi,%ebx
  802159:	83 fb 7f             	cmp    $0x7f,%ebx
  80215c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802161:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	53                   	push   %ebx
  802168:	89 f0                	mov    %esi,%eax
  80216a:	03 45 0c             	add    0xc(%ebp),%eax
  80216d:	50                   	push   %eax
  80216e:	57                   	push   %edi
  80216f:	e8 6a ea ff ff       	call   800bde <memmove>
		sys_cputs(buf, m);
  802174:	83 c4 08             	add    $0x8,%esp
  802177:	53                   	push   %ebx
  802178:	57                   	push   %edi
  802179:	e8 08 ec ff ff       	call   800d86 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80217e:	01 de                	add    %ebx,%esi
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	eb ca                	jmp    80214f <devcons_write+0x17>
}
  802185:	89 f0                	mov    %esi,%eax
  802187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80218a:	5b                   	pop    %ebx
  80218b:	5e                   	pop    %esi
  80218c:	5f                   	pop    %edi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <devcons_read>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80219a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219e:	74 21                	je     8021c1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021a0:	e8 ff eb ff ff       	call   800da4 <sys_cgetc>
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	75 07                	jne    8021b0 <devcons_read+0x21>
		sys_yield();
  8021a9:	e8 75 ec ff ff       	call   800e23 <sys_yield>
  8021ae:	eb f0                	jmp    8021a0 <devcons_read+0x11>
	if (c < 0)
  8021b0:	78 0f                	js     8021c1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021b2:	83 f8 04             	cmp    $0x4,%eax
  8021b5:	74 0c                	je     8021c3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	88 02                	mov    %al,(%edx)
	return 1;
  8021bc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    
		return 0;
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	eb f7                	jmp    8021c1 <devcons_read+0x32>

008021ca <cputchar>:
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d6:	6a 01                	push   $0x1
  8021d8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021db:	50                   	push   %eax
  8021dc:	e8 a5 eb ff ff       	call   800d86 <sys_cputs>
}
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <getchar>:
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ec:	6a 01                	push   $0x1
  8021ee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f1:	50                   	push   %eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	e8 27 f2 ff ff       	call   801420 <read>
	if (r < 0)
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	78 06                	js     802206 <getchar+0x20>
	if (r < 1)
  802200:	74 06                	je     802208 <getchar+0x22>
	return c;
  802202:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    
		return -E_EOF;
  802208:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80220d:	eb f7                	jmp    802206 <getchar+0x20>

0080220f <iscons>:
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802215:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802218:	50                   	push   %eax
  802219:	ff 75 08             	pushl  0x8(%ebp)
  80221c:	e8 8f ef ff ff       	call   8011b0 <fd_lookup>
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	85 c0                	test   %eax,%eax
  802226:	78 11                	js     802239 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802231:	39 10                	cmp    %edx,(%eax)
  802233:	0f 94 c0             	sete   %al
  802236:	0f b6 c0             	movzbl %al,%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <opencons>:
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802244:	50                   	push   %eax
  802245:	e8 14 ef ff ff       	call   80115e <fd_alloc>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	78 3a                	js     80228b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	68 07 04 00 00       	push   $0x407
  802259:	ff 75 f4             	pushl  -0xc(%ebp)
  80225c:	6a 00                	push   $0x0
  80225e:	e8 df eb ff ff       	call   800e42 <sys_page_alloc>
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	85 c0                	test   %eax,%eax
  802268:	78 21                	js     80228b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802273:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80227f:	83 ec 0c             	sub    $0xc,%esp
  802282:	50                   	push   %eax
  802283:	e8 af ee ff ff       	call   801137 <fd2num>
  802288:	83 c4 10             	add    $0x10,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802292:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802297:	8b 40 48             	mov    0x48(%eax),%eax
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	68 20 2c 80 00       	push   $0x802c20
  8022a2:	50                   	push   %eax
  8022a3:	68 04 27 80 00       	push   $0x802704
  8022a8:	e8 44 e0 ff ff       	call   8002f1 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8022ad:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022b0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022b6:	e8 49 eb ff ff       	call   800e04 <sys_getenvid>
  8022bb:	83 c4 04             	add    $0x4,%esp
  8022be:	ff 75 0c             	pushl  0xc(%ebp)
  8022c1:	ff 75 08             	pushl  0x8(%ebp)
  8022c4:	56                   	push   %esi
  8022c5:	50                   	push   %eax
  8022c6:	68 fc 2b 80 00       	push   $0x802bfc
  8022cb:	e8 21 e0 ff ff       	call   8002f1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022d0:	83 c4 18             	add    $0x18,%esp
  8022d3:	53                   	push   %ebx
  8022d4:	ff 75 10             	pushl  0x10(%ebp)
  8022d7:	e8 c4 df ff ff       	call   8002a0 <vcprintf>
	cprintf("\n");
  8022dc:	c7 04 24 c8 26 80 00 	movl   $0x8026c8,(%esp)
  8022e3:	e8 09 e0 ff ff       	call   8002f1 <cprintf>
  8022e8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022eb:	cc                   	int3   
  8022ec:	eb fd                	jmp    8022eb <_panic+0x5e>

008022ee <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	56                   	push   %esi
  8022f2:	53                   	push   %ebx
  8022f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8022f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022fc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022fe:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802303:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802306:	83 ec 0c             	sub    $0xc,%esp
  802309:	50                   	push   %eax
  80230a:	e8 e3 ec ff ff       	call   800ff2 <sys_ipc_recv>
	if(ret < 0){
  80230f:	83 c4 10             	add    $0x10,%esp
  802312:	85 c0                	test   %eax,%eax
  802314:	78 2b                	js     802341 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802316:	85 f6                	test   %esi,%esi
  802318:	74 0a                	je     802324 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80231a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80231f:	8b 40 78             	mov    0x78(%eax),%eax
  802322:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802324:	85 db                	test   %ebx,%ebx
  802326:	74 0a                	je     802332 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802328:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80232d:	8b 40 7c             	mov    0x7c(%eax),%eax
  802330:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802332:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802337:	8b 40 74             	mov    0x74(%eax),%eax
}
  80233a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
		if(from_env_store)
  802341:	85 f6                	test   %esi,%esi
  802343:	74 06                	je     80234b <ipc_recv+0x5d>
			*from_env_store = 0;
  802345:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80234b:	85 db                	test   %ebx,%ebx
  80234d:	74 eb                	je     80233a <ipc_recv+0x4c>
			*perm_store = 0;
  80234f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802355:	eb e3                	jmp    80233a <ipc_recv+0x4c>

00802357 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	57                   	push   %edi
  80235b:	56                   	push   %esi
  80235c:	53                   	push   %ebx
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	8b 7d 08             	mov    0x8(%ebp),%edi
  802363:	8b 75 0c             	mov    0xc(%ebp),%esi
  802366:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802369:	85 db                	test   %ebx,%ebx
  80236b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802370:	0f 44 d8             	cmove  %eax,%ebx
  802373:	eb 05                	jmp    80237a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802375:	e8 a9 ea ff ff       	call   800e23 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80237a:	ff 75 14             	pushl  0x14(%ebp)
  80237d:	53                   	push   %ebx
  80237e:	56                   	push   %esi
  80237f:	57                   	push   %edi
  802380:	e8 4a ec ff ff       	call   800fcf <sys_ipc_try_send>
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	85 c0                	test   %eax,%eax
  80238a:	74 1b                	je     8023a7 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80238c:	79 e7                	jns    802375 <ipc_send+0x1e>
  80238e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802391:	74 e2                	je     802375 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	68 27 2c 80 00       	push   $0x802c27
  80239b:	6a 46                	push   $0x46
  80239d:	68 3c 2c 80 00       	push   $0x802c3c
  8023a2:	e8 e6 fe ff ff       	call   80228d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023aa:	5b                   	pop    %ebx
  8023ab:	5e                   	pop    %esi
  8023ac:	5f                   	pop    %edi
  8023ad:	5d                   	pop    %ebp
  8023ae:	c3                   	ret    

008023af <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ba:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8023c0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023c6:	8b 52 50             	mov    0x50(%edx),%edx
  8023c9:	39 ca                	cmp    %ecx,%edx
  8023cb:	74 11                	je     8023de <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8023cd:	83 c0 01             	add    $0x1,%eax
  8023d0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023d5:	75 e3                	jne    8023ba <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	eb 0e                	jmp    8023ec <ipc_find_env+0x3d>
			return envs[i].env_id;
  8023de:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8023e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023e9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    

008023ee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023f4:	89 d0                	mov    %edx,%eax
  8023f6:	c1 e8 16             	shr    $0x16,%eax
  8023f9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802405:	f6 c1 01             	test   $0x1,%cl
  802408:	74 1d                	je     802427 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80240a:	c1 ea 0c             	shr    $0xc,%edx
  80240d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802414:	f6 c2 01             	test   $0x1,%dl
  802417:	74 0e                	je     802427 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802419:	c1 ea 0c             	shr    $0xc,%edx
  80241c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802423:	ef 
  802424:	0f b7 c0             	movzwl %ax,%eax
}
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
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
