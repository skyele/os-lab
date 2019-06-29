
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 a4 01 00 00       	call   8001d5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 4f 0e 00 00       	call   800e99 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 78 0e 00 00       	call   800edc <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 b7 0b 00 00       	call   800c35 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 91 0e 00 00       	call   800f1e <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 80 26 80 00       	push   $0x802680
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 93 26 80 00       	push   $0x802693
  8000a8:	e8 a5 01 00 00       	call   800252 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 a3 26 80 00       	push   $0x8026a3
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 93 26 80 00       	push   $0x802693
  8000ba:	e8 93 01 00 00       	call   800252 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 b4 26 80 00       	push   $0x8026b4
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 93 26 80 00       	push   $0x802693
  8000cc:	e8 81 01 00 00       	call   800252 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 2c                	js     800112 <dumbfork+0x41>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	74 3a                	je     800124 <dumbfork+0x53>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ea:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f4:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  8000fa:	73 44                	jae    800140 <dumbfork+0x6f>
		duppage(envid, addr);
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	52                   	push   %edx
  800100:	56                   	push   %esi
  800101:	e8 2d ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800106:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb df                	jmp    8000f1 <dumbfork+0x20>
		panic("sys_exofork: %e", envid);
  800112:	50                   	push   %eax
  800113:	68 c7 26 80 00       	push   $0x8026c7
  800118:	6a 37                	push   $0x37
  80011a:	68 93 26 80 00       	push   $0x802693
  80011f:	e8 2e 01 00 00       	call   800252 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 32 0d 00 00       	call   800e5b <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800134:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800139:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80013e:	eb 24                	jmp    800164 <dumbfork+0x93>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800146:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014b:	50                   	push   %eax
  80014c:	53                   	push   %ebx
  80014d:	e8 e1 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800152:	83 c4 08             	add    $0x8,%esp
  800155:	6a 02                	push   $0x2
  800157:	53                   	push   %ebx
  800158:	e8 03 0e 00 00       	call   800f60 <sys_env_set_status>
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	85 c0                	test   %eax,%eax
  800162:	78 09                	js     80016d <dumbfork+0x9c>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800164:	89 d8                	mov    %ebx,%eax
  800166:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800169:	5b                   	pop    %ebx
  80016a:	5e                   	pop    %esi
  80016b:	5d                   	pop    %ebp
  80016c:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016d:	50                   	push   %eax
  80016e:	68 d7 26 80 00       	push   $0x8026d7
  800173:	6a 4c                	push   $0x4c
  800175:	68 93 26 80 00       	push   $0x802693
  80017a:	e8 d3 00 00 00       	call   800252 <_panic>

0080017f <umain>:
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800188:	e8 44 ff ff ff       	call   8000d1 <dumbfork>
  80018d:	89 c7                	mov    %eax,%edi
  80018f:	85 c0                	test   %eax,%eax
  800191:	be ee 26 80 00       	mov    $0x8026ee,%esi
  800196:	b8 f5 26 80 00       	mov    $0x8026f5,%eax
  80019b:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a3:	eb 1f                	jmp    8001c4 <umain+0x45>
  8001a5:	83 fb 13             	cmp    $0x13,%ebx
  8001a8:	7f 23                	jg     8001cd <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	68 fb 26 80 00       	push   $0x8026fb
  8001b4:	e8 8f 01 00 00       	call   800348 <cprintf>
		sys_yield();
  8001b9:	e8 bc 0c 00 00       	call   800e7a <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001be:	83 c3 01             	add    $0x1,%ebx
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	85 ff                	test   %edi,%edi
  8001c6:	74 dd                	je     8001a5 <umain+0x26>
  8001c8:	83 fb 09             	cmp    $0x9,%ebx
  8001cb:	7e dd                	jle    8001aa <umain+0x2b>
}
  8001cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8001e0:	e8 76 0c 00 00       	call   800e5b <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8001e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ea:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f5:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	7e 07                	jle    800205 <libmain+0x30>
		binaryname = argv[0];
  8001fe:	8b 06                	mov    (%esi),%eax
  800200:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	e8 70 ff ff ff       	call   80017f <umain>

	// exit gracefully
	exit();
  80020f:	e8 0a 00 00 00       	call   80021e <exit>
}
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800224:	a1 08 40 80 00       	mov    0x804008,%eax
  800229:	8b 40 48             	mov    0x48(%eax),%eax
  80022c:	68 24 27 80 00       	push   $0x802724
  800231:	50                   	push   %eax
  800232:	68 17 27 80 00       	push   $0x802717
  800237:	e8 0c 01 00 00       	call   800348 <cprintf>
	close_all();
  80023c:	e8 25 11 00 00       	call   801366 <close_all>
	sys_env_destroy(0);
  800241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800248:	e8 cd 0b 00 00       	call   800e1a <sys_env_destroy>
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800257:	a1 08 40 80 00       	mov    0x804008,%eax
  80025c:	8b 40 48             	mov    0x48(%eax),%eax
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	68 50 27 80 00       	push   $0x802750
  800267:	50                   	push   %eax
  800268:	68 17 27 80 00       	push   $0x802717
  80026d:	e8 d6 00 00 00       	call   800348 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800272:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800275:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80027b:	e8 db 0b 00 00       	call   800e5b <sys_getenvid>
  800280:	83 c4 04             	add    $0x4,%esp
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	56                   	push   %esi
  80028a:	50                   	push   %eax
  80028b:	68 2c 27 80 00       	push   $0x80272c
  800290:	e8 b3 00 00 00       	call   800348 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800295:	83 c4 18             	add    $0x18,%esp
  800298:	53                   	push   %ebx
  800299:	ff 75 10             	pushl  0x10(%ebp)
  80029c:	e8 56 00 00 00       	call   8002f7 <vcprintf>
	cprintf("\n");
  8002a1:	c7 04 24 0b 27 80 00 	movl   $0x80270b,(%esp)
  8002a8:	e8 9b 00 00 00       	call   800348 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002b0:	cc                   	int3   
  8002b1:	eb fd                	jmp    8002b0 <_panic+0x5e>

008002b3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002bd:	8b 13                	mov    (%ebx),%edx
  8002bf:	8d 42 01             	lea    0x1(%edx),%eax
  8002c2:	89 03                	mov    %eax,(%ebx)
  8002c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	74 09                	je     8002db <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002d2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	68 ff 00 00 00       	push   $0xff
  8002e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e6:	50                   	push   %eax
  8002e7:	e8 f1 0a 00 00       	call   800ddd <sys_cputs>
		b->idx = 0;
  8002ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	eb db                	jmp    8002d2 <putch+0x1f>

008002f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800300:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800307:	00 00 00 
	b.cnt = 0;
  80030a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800311:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800320:	50                   	push   %eax
  800321:	68 b3 02 80 00       	push   $0x8002b3
  800326:	e8 4a 01 00 00       	call   800475 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80032b:	83 c4 08             	add    $0x8,%esp
  80032e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800334:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	e8 9d 0a 00 00       	call   800ddd <sys_cputs>

	return b.cnt;
}
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800351:	50                   	push   %eax
  800352:	ff 75 08             	pushl  0x8(%ebp)
  800355:	e8 9d ff ff ff       	call   8002f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	57                   	push   %edi
  800360:	56                   	push   %esi
  800361:	53                   	push   %ebx
  800362:	83 ec 1c             	sub    $0x1c,%esp
  800365:	89 c6                	mov    %eax,%esi
  800367:	89 d7                	mov    %edx,%edi
  800369:	8b 45 08             	mov    0x8(%ebp),%eax
  80036c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800375:	8b 45 10             	mov    0x10(%ebp),%eax
  800378:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80037b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80037f:	74 2c                	je     8003ad <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800381:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800384:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80038b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80038e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800391:	39 c2                	cmp    %eax,%edx
  800393:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800396:	73 43                	jae    8003db <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800398:	83 eb 01             	sub    $0x1,%ebx
  80039b:	85 db                	test   %ebx,%ebx
  80039d:	7e 6c                	jle    80040b <printnum+0xaf>
				putch(padc, putdat);
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	57                   	push   %edi
  8003a3:	ff 75 18             	pushl  0x18(%ebp)
  8003a6:	ff d6                	call   *%esi
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	eb eb                	jmp    800398 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003ad:	83 ec 0c             	sub    $0xc,%esp
  8003b0:	6a 20                	push   $0x20
  8003b2:	6a 00                	push   $0x0
  8003b4:	50                   	push   %eax
  8003b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003bb:	89 fa                	mov    %edi,%edx
  8003bd:	89 f0                	mov    %esi,%eax
  8003bf:	e8 98 ff ff ff       	call   80035c <printnum>
		while (--width > 0)
  8003c4:	83 c4 20             	add    $0x20,%esp
  8003c7:	83 eb 01             	sub    $0x1,%ebx
  8003ca:	85 db                	test   %ebx,%ebx
  8003cc:	7e 65                	jle    800433 <printnum+0xd7>
			putch(padc, putdat);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	57                   	push   %edi
  8003d2:	6a 20                	push   $0x20
  8003d4:	ff d6                	call   *%esi
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	eb ec                	jmp    8003c7 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003db:	83 ec 0c             	sub    $0xc,%esp
  8003de:	ff 75 18             	pushl  0x18(%ebp)
  8003e1:	83 eb 01             	sub    $0x1,%ebx
  8003e4:	53                   	push   %ebx
  8003e5:	50                   	push   %eax
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f5:	e8 26 20 00 00       	call   802420 <__udivdi3>
  8003fa:	83 c4 18             	add    $0x18,%esp
  8003fd:	52                   	push   %edx
  8003fe:	50                   	push   %eax
  8003ff:	89 fa                	mov    %edi,%edx
  800401:	89 f0                	mov    %esi,%eax
  800403:	e8 54 ff ff ff       	call   80035c <printnum>
  800408:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	57                   	push   %edi
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	ff 75 dc             	pushl  -0x24(%ebp)
  800415:	ff 75 d8             	pushl  -0x28(%ebp)
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	ff 75 e0             	pushl  -0x20(%ebp)
  80041e:	e8 0d 21 00 00       	call   802530 <__umoddi3>
  800423:	83 c4 14             	add    $0x14,%esp
  800426:	0f be 80 57 27 80 00 	movsbl 0x802757(%eax),%eax
  80042d:	50                   	push   %eax
  80042e:	ff d6                	call   *%esi
  800430:	83 c4 10             	add    $0x10,%esp
	}
}
  800433:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800436:	5b                   	pop    %ebx
  800437:	5e                   	pop    %esi
  800438:	5f                   	pop    %edi
  800439:	5d                   	pop    %ebp
  80043a:	c3                   	ret    

0080043b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800441:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800445:	8b 10                	mov    (%eax),%edx
  800447:	3b 50 04             	cmp    0x4(%eax),%edx
  80044a:	73 0a                	jae    800456 <sprintputch+0x1b>
		*b->buf++ = ch;
  80044c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80044f:	89 08                	mov    %ecx,(%eax)
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	88 02                	mov    %al,(%edx)
}
  800456:	5d                   	pop    %ebp
  800457:	c3                   	ret    

00800458 <printfmt>:
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80045e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800461:	50                   	push   %eax
  800462:	ff 75 10             	pushl  0x10(%ebp)
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	ff 75 08             	pushl  0x8(%ebp)
  80046b:	e8 05 00 00 00       	call   800475 <vprintfmt>
}
  800470:	83 c4 10             	add    $0x10,%esp
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <vprintfmt>:
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	57                   	push   %edi
  800479:	56                   	push   %esi
  80047a:	53                   	push   %ebx
  80047b:	83 ec 3c             	sub    $0x3c,%esp
  80047e:	8b 75 08             	mov    0x8(%ebp),%esi
  800481:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800484:	8b 7d 10             	mov    0x10(%ebp),%edi
  800487:	e9 32 04 00 00       	jmp    8008be <vprintfmt+0x449>
		padc = ' ';
  80048c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800490:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800497:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80049e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004ac:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004b3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8d 47 01             	lea    0x1(%edi),%eax
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004be:	0f b6 17             	movzbl (%edi),%edx
  8004c1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004c4:	3c 55                	cmp    $0x55,%al
  8004c6:	0f 87 12 05 00 00    	ja     8009de <vprintfmt+0x569>
  8004cc:	0f b6 c0             	movzbl %al,%eax
  8004cf:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  8004d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004d9:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004dd:	eb d9                	jmp    8004b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004e2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004e6:	eb d0                	jmp    8004b8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	0f b6 d2             	movzbl %dl,%edx
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	eb 03                	jmp    8004fb <vprintfmt+0x86>
  8004f8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800502:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800505:	8d 72 d0             	lea    -0x30(%edx),%esi
  800508:	83 fe 09             	cmp    $0x9,%esi
  80050b:	76 eb                	jbe    8004f8 <vprintfmt+0x83>
  80050d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800510:	8b 75 08             	mov    0x8(%ebp),%esi
  800513:	eb 14                	jmp    800529 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8d 40 04             	lea    0x4(%eax),%eax
  800523:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800529:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052d:	79 89                	jns    8004b8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80052f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800535:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80053c:	e9 77 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
  800541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	0f 48 c1             	cmovs  %ecx,%eax
  800549:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054f:	e9 64 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
  800554:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800557:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80055e:	e9 55 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
			lflag++;
  800563:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80056a:	e9 49 ff ff ff       	jmp    8004b8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 78 04             	lea    0x4(%eax),%edi
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	53                   	push   %ebx
  800579:	ff 30                	pushl  (%eax)
  80057b:	ff d6                	call   *%esi
			break;
  80057d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800580:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800583:	e9 33 03 00 00       	jmp    8008bb <vprintfmt+0x446>
			err = va_arg(ap, int);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 78 04             	lea    0x4(%eax),%edi
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	99                   	cltd   
  800591:	31 d0                	xor    %edx,%eax
  800593:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800595:	83 f8 11             	cmp    $0x11,%eax
  800598:	7f 23                	jg     8005bd <vprintfmt+0x148>
  80059a:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  8005a1:	85 d2                	test   %edx,%edx
  8005a3:	74 18                	je     8005bd <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005a5:	52                   	push   %edx
  8005a6:	68 c1 2b 80 00       	push   $0x802bc1
  8005ab:	53                   	push   %ebx
  8005ac:	56                   	push   %esi
  8005ad:	e8 a6 fe ff ff       	call   800458 <printfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b8:	e9 fe 02 00 00       	jmp    8008bb <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005bd:	50                   	push   %eax
  8005be:	68 6f 27 80 00       	push   $0x80276f
  8005c3:	53                   	push   %ebx
  8005c4:	56                   	push   %esi
  8005c5:	e8 8e fe ff ff       	call   800458 <printfmt>
  8005ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005d0:	e9 e6 02 00 00       	jmp    8008bb <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005e3:	85 c9                	test   %ecx,%ecx
  8005e5:	b8 68 27 80 00       	mov    $0x802768,%eax
  8005ea:	0f 45 c1             	cmovne %ecx,%eax
  8005ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f4:	7e 06                	jle    8005fc <vprintfmt+0x187>
  8005f6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005fa:	75 0d                	jne    800609 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ff:	89 c7                	mov    %eax,%edi
  800601:	03 45 e0             	add    -0x20(%ebp),%eax
  800604:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800607:	eb 53                	jmp    80065c <vprintfmt+0x1e7>
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	ff 75 d8             	pushl  -0x28(%ebp)
  80060f:	50                   	push   %eax
  800610:	e8 71 04 00 00       	call   800a86 <strnlen>
  800615:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800618:	29 c1                	sub    %eax,%ecx
  80061a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800622:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800626:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800629:	eb 0f                	jmp    80063a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	ff 75 e0             	pushl  -0x20(%ebp)
  800632:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	83 ef 01             	sub    $0x1,%edi
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	85 ff                	test   %edi,%edi
  80063c:	7f ed                	jg     80062b <vprintfmt+0x1b6>
  80063e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800641:	85 c9                	test   %ecx,%ecx
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	0f 49 c1             	cmovns %ecx,%eax
  80064b:	29 c1                	sub    %eax,%ecx
  80064d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800650:	eb aa                	jmp    8005fc <vprintfmt+0x187>
					putch(ch, putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	52                   	push   %edx
  800657:	ff d6                	call   *%esi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800661:	83 c7 01             	add    $0x1,%edi
  800664:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800668:	0f be d0             	movsbl %al,%edx
  80066b:	85 d2                	test   %edx,%edx
  80066d:	74 4b                	je     8006ba <vprintfmt+0x245>
  80066f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800673:	78 06                	js     80067b <vprintfmt+0x206>
  800675:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800679:	78 1e                	js     800699 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80067b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80067f:	74 d1                	je     800652 <vprintfmt+0x1dd>
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 e8 20             	sub    $0x20,%eax
  800687:	83 f8 5e             	cmp    $0x5e,%eax
  80068a:	76 c6                	jbe    800652 <vprintfmt+0x1dd>
					putch('?', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	6a 3f                	push   $0x3f
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	eb c3                	jmp    80065c <vprintfmt+0x1e7>
  800699:	89 cf                	mov    %ecx,%edi
  80069b:	eb 0e                	jmp    8006ab <vprintfmt+0x236>
				putch(' ', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 20                	push   $0x20
  8006a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006a5:	83 ef 01             	sub    $0x1,%edi
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	85 ff                	test   %edi,%edi
  8006ad:	7f ee                	jg     80069d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b5:	e9 01 02 00 00       	jmp    8008bb <vprintfmt+0x446>
  8006ba:	89 cf                	mov    %ecx,%edi
  8006bc:	eb ed                	jmp    8006ab <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006c1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006c8:	e9 eb fd ff ff       	jmp    8004b8 <vprintfmt+0x43>
	if (lflag >= 2)
  8006cd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006d1:	7f 21                	jg     8006f4 <vprintfmt+0x27f>
	else if (lflag)
  8006d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d7:	74 68                	je     800741 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e1:	89 c1                	mov    %eax,%ecx
  8006e3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8d 40 04             	lea    0x4(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	eb 17                	jmp    80070b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 50 04             	mov    0x4(%eax),%edx
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 08             	lea    0x8(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80070b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80070e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800717:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80071b:	78 3f                	js     80075c <vprintfmt+0x2e7>
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800722:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800726:	0f 84 71 01 00 00    	je     80089d <vprintfmt+0x428>
				putch('+', putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	53                   	push   %ebx
  800730:	6a 2b                	push   $0x2b
  800732:	ff d6                	call   *%esi
  800734:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073c:	e9 5c 01 00 00       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800749:	89 c1                	mov    %eax,%ecx
  80074b:	c1 f9 1f             	sar    $0x1f,%ecx
  80074e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
  80075a:	eb af                	jmp    80070b <vprintfmt+0x296>
				putch('-', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	53                   	push   %ebx
  800760:	6a 2d                	push   $0x2d
  800762:	ff d6                	call   *%esi
				num = -(long long) num;
  800764:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800767:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80076a:	f7 d8                	neg    %eax
  80076c:	83 d2 00             	adc    $0x0,%edx
  80076f:	f7 da                	neg    %edx
  800771:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800774:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800777:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80077a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077f:	e9 19 01 00 00       	jmp    80089d <vprintfmt+0x428>
	if (lflag >= 2)
  800784:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800788:	7f 29                	jg     8007b3 <vprintfmt+0x33e>
	else if (lflag)
  80078a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078e:	74 44                	je     8007d4 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ae:	e9 ea 00 00 00       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 50 04             	mov    0x4(%eax),%edx
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8d 40 08             	lea    0x8(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cf:	e9 c9 00 00 00       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f2:	e9 a6 00 00 00       	jmp    80089d <vprintfmt+0x428>
			putch('0', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 30                	push   $0x30
  8007fd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800806:	7f 26                	jg     80082e <vprintfmt+0x3b9>
	else if (lflag)
  800808:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80080c:	74 3e                	je     80084c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	ba 00 00 00 00       	mov    $0x0,%edx
  800818:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800827:	b8 08 00 00 00       	mov    $0x8,%eax
  80082c:	eb 6f                	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8b 50 04             	mov    0x4(%eax),%edx
  800834:	8b 00                	mov    (%eax),%eax
  800836:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800839:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8d 40 08             	lea    0x8(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800845:	b8 08 00 00 00       	mov    $0x8,%eax
  80084a:	eb 51                	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  80086a:	eb 31                	jmp    80089d <vprintfmt+0x428>
			putch('0', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	6a 30                	push   $0x30
  800872:	ff d6                	call   *%esi
			putch('x', putdat);
  800874:	83 c4 08             	add    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	6a 78                	push   $0x78
  80087a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	ba 00 00 00 00       	mov    $0x0,%edx
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80088c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 04             	lea    0x4(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800898:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80089d:	83 ec 0c             	sub    $0xc,%esp
  8008a0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008a4:	52                   	push   %edx
  8008a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8008ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8008af:	89 da                	mov    %ebx,%edx
  8008b1:	89 f0                	mov    %esi,%eax
  8008b3:	e8 a4 fa ff ff       	call   80035c <printnum>
			break;
  8008b8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008be:	83 c7 01             	add    $0x1,%edi
  8008c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008c5:	83 f8 25             	cmp    $0x25,%eax
  8008c8:	0f 84 be fb ff ff    	je     80048c <vprintfmt+0x17>
			if (ch == '\0')
  8008ce:	85 c0                	test   %eax,%eax
  8008d0:	0f 84 28 01 00 00    	je     8009fe <vprintfmt+0x589>
			putch(ch, putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	53                   	push   %ebx
  8008da:	50                   	push   %eax
  8008db:	ff d6                	call   *%esi
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	eb dc                	jmp    8008be <vprintfmt+0x449>
	if (lflag >= 2)
  8008e2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008e6:	7f 26                	jg     80090e <vprintfmt+0x499>
	else if (lflag)
  8008e8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ec:	74 41                	je     80092f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 40 04             	lea    0x4(%eax),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800907:	b8 10 00 00 00       	mov    $0x10,%eax
  80090c:	eb 8f                	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8b 50 04             	mov    0x4(%eax),%edx
  800914:	8b 00                	mov    (%eax),%eax
  800916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800919:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8d 40 08             	lea    0x8(%eax),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800925:	b8 10 00 00 00       	mov    $0x10,%eax
  80092a:	e9 6e ff ff ff       	jmp    80089d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	ba 00 00 00 00       	mov    $0x0,%edx
  800939:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8d 40 04             	lea    0x4(%eax),%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800948:	b8 10 00 00 00       	mov    $0x10,%eax
  80094d:	e9 4b ff ff ff       	jmp    80089d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	83 c0 04             	add    $0x4,%eax
  800958:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	85 c0                	test   %eax,%eax
  800962:	74 14                	je     800978 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800964:	8b 13                	mov    (%ebx),%edx
  800966:	83 fa 7f             	cmp    $0x7f,%edx
  800969:	7f 37                	jg     8009a2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80096b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80096d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	e9 43 ff ff ff       	jmp    8008bb <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800978:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097d:	bf 8d 28 80 00       	mov    $0x80288d,%edi
							putch(ch, putdat);
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	53                   	push   %ebx
  800986:	50                   	push   %eax
  800987:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800989:	83 c7 01             	add    $0x1,%edi
  80098c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	85 c0                	test   %eax,%eax
  800995:	75 eb                	jne    800982 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800997:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80099a:	89 45 14             	mov    %eax,0x14(%ebp)
  80099d:	e9 19 ff ff ff       	jmp    8008bb <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009a2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a9:	bf c5 28 80 00       	mov    $0x8028c5,%edi
							putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	53                   	push   %ebx
  8009b2:	50                   	push   %eax
  8009b3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009b5:	83 c7 01             	add    $0x1,%edi
  8009b8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	75 eb                	jne    8009ae <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c9:	e9 ed fe ff ff       	jmp    8008bb <vprintfmt+0x446>
			putch(ch, putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	53                   	push   %ebx
  8009d2:	6a 25                	push   $0x25
  8009d4:	ff d6                	call   *%esi
			break;
  8009d6:	83 c4 10             	add    $0x10,%esp
  8009d9:	e9 dd fe ff ff       	jmp    8008bb <vprintfmt+0x446>
			putch('%', putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	53                   	push   %ebx
  8009e2:	6a 25                	push   $0x25
  8009e4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e6:	83 c4 10             	add    $0x10,%esp
  8009e9:	89 f8                	mov    %edi,%eax
  8009eb:	eb 03                	jmp    8009f0 <vprintfmt+0x57b>
  8009ed:	83 e8 01             	sub    $0x1,%eax
  8009f0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009f4:	75 f7                	jne    8009ed <vprintfmt+0x578>
  8009f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f9:	e9 bd fe ff ff       	jmp    8008bb <vprintfmt+0x446>
}
  8009fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a01:	5b                   	pop    %ebx
  800a02:	5e                   	pop    %esi
  800a03:	5f                   	pop    %edi
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 18             	sub    $0x18,%esp
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a15:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a19:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a23:	85 c0                	test   %eax,%eax
  800a25:	74 26                	je     800a4d <vsnprintf+0x47>
  800a27:	85 d2                	test   %edx,%edx
  800a29:	7e 22                	jle    800a4d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a2b:	ff 75 14             	pushl  0x14(%ebp)
  800a2e:	ff 75 10             	pushl  0x10(%ebp)
  800a31:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	68 3b 04 80 00       	push   $0x80043b
  800a3a:	e8 36 fa ff ff       	call   800475 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a48:	83 c4 10             	add    $0x10,%esp
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    
		return -E_INVAL;
  800a4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a52:	eb f7                	jmp    800a4b <vsnprintf+0x45>

00800a54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a5d:	50                   	push   %eax
  800a5e:	ff 75 10             	pushl  0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 9a ff ff ff       	call   800a06 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a7d:	74 05                	je     800a84 <strlen+0x16>
		n++;
  800a7f:	83 c0 01             	add    $0x1,%eax
  800a82:	eb f5                	jmp    800a79 <strlen+0xb>
	return n;
}
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	74 0d                	je     800aa5 <strnlen+0x1f>
  800a98:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a9c:	74 05                	je     800aa3 <strnlen+0x1d>
		n++;
  800a9e:	83 c2 01             	add    $0x1,%edx
  800aa1:	eb f1                	jmp    800a94 <strnlen+0xe>
  800aa3:	89 d0                	mov    %edx,%eax
	return n;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aba:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800abd:	83 c2 01             	add    $0x1,%edx
  800ac0:	84 c9                	test   %cl,%cl
  800ac2:	75 f2                	jne    800ab6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	83 ec 10             	sub    $0x10,%esp
  800ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad1:	53                   	push   %ebx
  800ad2:	e8 97 ff ff ff       	call   800a6e <strlen>
  800ad7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	01 d8                	add    %ebx,%eax
  800adf:	50                   	push   %eax
  800ae0:	e8 c2 ff ff ff       	call   800aa7 <strcpy>
	return dst;
}
  800ae5:	89 d8                	mov    %ebx,%eax
  800ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af7:	89 c6                	mov    %eax,%esi
  800af9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	39 f2                	cmp    %esi,%edx
  800b00:	74 11                	je     800b13 <strncpy+0x27>
		*dst++ = *src;
  800b02:	83 c2 01             	add    $0x1,%edx
  800b05:	0f b6 19             	movzbl (%ecx),%ebx
  800b08:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0b:	80 fb 01             	cmp    $0x1,%bl
  800b0e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b11:	eb eb                	jmp    800afe <strncpy+0x12>
	}
	return ret;
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
  800b1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b22:	8b 55 10             	mov    0x10(%ebp),%edx
  800b25:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b27:	85 d2                	test   %edx,%edx
  800b29:	74 21                	je     800b4c <strlcpy+0x35>
  800b2b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b2f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b31:	39 c2                	cmp    %eax,%edx
  800b33:	74 14                	je     800b49 <strlcpy+0x32>
  800b35:	0f b6 19             	movzbl (%ecx),%ebx
  800b38:	84 db                	test   %bl,%bl
  800b3a:	74 0b                	je     800b47 <strlcpy+0x30>
			*dst++ = *src++;
  800b3c:	83 c1 01             	add    $0x1,%ecx
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b45:	eb ea                	jmp    800b31 <strlcpy+0x1a>
  800b47:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4c:	29 f0                	sub    %esi,%eax
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b58:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b5b:	0f b6 01             	movzbl (%ecx),%eax
  800b5e:	84 c0                	test   %al,%al
  800b60:	74 0c                	je     800b6e <strcmp+0x1c>
  800b62:	3a 02                	cmp    (%edx),%al
  800b64:	75 08                	jne    800b6e <strcmp+0x1c>
		p++, q++;
  800b66:	83 c1 01             	add    $0x1,%ecx
  800b69:	83 c2 01             	add    $0x1,%edx
  800b6c:	eb ed                	jmp    800b5b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6e:	0f b6 c0             	movzbl %al,%eax
  800b71:	0f b6 12             	movzbl (%edx),%edx
  800b74:	29 d0                	sub    %edx,%eax
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	53                   	push   %ebx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b82:	89 c3                	mov    %eax,%ebx
  800b84:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b87:	eb 06                	jmp    800b8f <strncmp+0x17>
		n--, p++, q++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b8f:	39 d8                	cmp    %ebx,%eax
  800b91:	74 16                	je     800ba9 <strncmp+0x31>
  800b93:	0f b6 08             	movzbl (%eax),%ecx
  800b96:	84 c9                	test   %cl,%cl
  800b98:	74 04                	je     800b9e <strncmp+0x26>
  800b9a:	3a 0a                	cmp    (%edx),%cl
  800b9c:	74 eb                	je     800b89 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9e:	0f b6 00             	movzbl (%eax),%eax
  800ba1:	0f b6 12             	movzbl (%edx),%edx
  800ba4:	29 d0                	sub    %edx,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    
		return 0;
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bae:	eb f6                	jmp    800ba6 <strncmp+0x2e>

00800bb0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bba:	0f b6 10             	movzbl (%eax),%edx
  800bbd:	84 d2                	test   %dl,%dl
  800bbf:	74 09                	je     800bca <strchr+0x1a>
		if (*s == c)
  800bc1:	38 ca                	cmp    %cl,%dl
  800bc3:	74 0a                	je     800bcf <strchr+0x1f>
	for (; *s; s++)
  800bc5:	83 c0 01             	add    $0x1,%eax
  800bc8:	eb f0                	jmp    800bba <strchr+0xa>
			return (char *) s;
	return 0;
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bdb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bde:	38 ca                	cmp    %cl,%dl
  800be0:	74 09                	je     800beb <strfind+0x1a>
  800be2:	84 d2                	test   %dl,%dl
  800be4:	74 05                	je     800beb <strfind+0x1a>
	for (; *s; s++)
  800be6:	83 c0 01             	add    $0x1,%eax
  800be9:	eb f0                	jmp    800bdb <strfind+0xa>
			break;
	return (char *) s;
}
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
  800bf3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf9:	85 c9                	test   %ecx,%ecx
  800bfb:	74 31                	je     800c2e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bfd:	89 f8                	mov    %edi,%eax
  800bff:	09 c8                	or     %ecx,%eax
  800c01:	a8 03                	test   $0x3,%al
  800c03:	75 23                	jne    800c28 <memset+0x3b>
		c &= 0xFF;
  800c05:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	c1 e3 08             	shl    $0x8,%ebx
  800c0e:	89 d0                	mov    %edx,%eax
  800c10:	c1 e0 18             	shl    $0x18,%eax
  800c13:	89 d6                	mov    %edx,%esi
  800c15:	c1 e6 10             	shl    $0x10,%esi
  800c18:	09 f0                	or     %esi,%eax
  800c1a:	09 c2                	or     %eax,%edx
  800c1c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c21:	89 d0                	mov    %edx,%eax
  800c23:	fc                   	cld    
  800c24:	f3 ab                	rep stos %eax,%es:(%edi)
  800c26:	eb 06                	jmp    800c2e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2b:	fc                   	cld    
  800c2c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2e:	89 f8                	mov    %edi,%eax
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c43:	39 c6                	cmp    %eax,%esi
  800c45:	73 32                	jae    800c79 <memmove+0x44>
  800c47:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c4a:	39 c2                	cmp    %eax,%edx
  800c4c:	76 2b                	jbe    800c79 <memmove+0x44>
		s += n;
		d += n;
  800c4e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c51:	89 fe                	mov    %edi,%esi
  800c53:	09 ce                	or     %ecx,%esi
  800c55:	09 d6                	or     %edx,%esi
  800c57:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5d:	75 0e                	jne    800c6d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c5f:	83 ef 04             	sub    $0x4,%edi
  800c62:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c68:	fd                   	std    
  800c69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6b:	eb 09                	jmp    800c76 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6d:	83 ef 01             	sub    $0x1,%edi
  800c70:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c73:	fd                   	std    
  800c74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c76:	fc                   	cld    
  800c77:	eb 1a                	jmp    800c93 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	09 ca                	or     %ecx,%edx
  800c7d:	09 f2                	or     %esi,%edx
  800c7f:	f6 c2 03             	test   $0x3,%dl
  800c82:	75 0a                	jne    800c8e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c87:	89 c7                	mov    %eax,%edi
  800c89:	fc                   	cld    
  800c8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8c:	eb 05                	jmp    800c93 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c8e:	89 c7                	mov    %eax,%edi
  800c90:	fc                   	cld    
  800c91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c9d:	ff 75 10             	pushl  0x10(%ebp)
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	e8 8a ff ff ff       	call   800c35 <memmove>
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb8:	89 c6                	mov    %eax,%esi
  800cba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbd:	39 f0                	cmp    %esi,%eax
  800cbf:	74 1c                	je     800cdd <memcmp+0x30>
		if (*s1 != *s2)
  800cc1:	0f b6 08             	movzbl (%eax),%ecx
  800cc4:	0f b6 1a             	movzbl (%edx),%ebx
  800cc7:	38 d9                	cmp    %bl,%cl
  800cc9:	75 08                	jne    800cd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	eb ea                	jmp    800cbd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd3:	0f b6 c1             	movzbl %cl,%eax
  800cd6:	0f b6 db             	movzbl %bl,%ebx
  800cd9:	29 d8                	sub    %ebx,%eax
  800cdb:	eb 05                	jmp    800ce2 <memcmp+0x35>
	}

	return 0;
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf4:	39 d0                	cmp    %edx,%eax
  800cf6:	73 09                	jae    800d01 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf8:	38 08                	cmp    %cl,(%eax)
  800cfa:	74 05                	je     800d01 <memfind+0x1b>
	for (; s < ends; s++)
  800cfc:	83 c0 01             	add    $0x1,%eax
  800cff:	eb f3                	jmp    800cf4 <memfind+0xe>
			break;
	return (void *) s;
}
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0f:	eb 03                	jmp    800d14 <strtol+0x11>
		s++;
  800d11:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d14:	0f b6 01             	movzbl (%ecx),%eax
  800d17:	3c 20                	cmp    $0x20,%al
  800d19:	74 f6                	je     800d11 <strtol+0xe>
  800d1b:	3c 09                	cmp    $0x9,%al
  800d1d:	74 f2                	je     800d11 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d1f:	3c 2b                	cmp    $0x2b,%al
  800d21:	74 2a                	je     800d4d <strtol+0x4a>
	int neg = 0;
  800d23:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d28:	3c 2d                	cmp    $0x2d,%al
  800d2a:	74 2b                	je     800d57 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d32:	75 0f                	jne    800d43 <strtol+0x40>
  800d34:	80 39 30             	cmpb   $0x30,(%ecx)
  800d37:	74 28                	je     800d61 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d40:	0f 44 d8             	cmove  %eax,%ebx
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d4b:	eb 50                	jmp    800d9d <strtol+0x9a>
		s++;
  800d4d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
  800d55:	eb d5                	jmp    800d2c <strtol+0x29>
		s++, neg = 1;
  800d57:	83 c1 01             	add    $0x1,%ecx
  800d5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800d5f:	eb cb                	jmp    800d2c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d65:	74 0e                	je     800d75 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d67:	85 db                	test   %ebx,%ebx
  800d69:	75 d8                	jne    800d43 <strtol+0x40>
		s++, base = 8;
  800d6b:	83 c1 01             	add    $0x1,%ecx
  800d6e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d73:	eb ce                	jmp    800d43 <strtol+0x40>
		s += 2, base = 16;
  800d75:	83 c1 02             	add    $0x2,%ecx
  800d78:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d7d:	eb c4                	jmp    800d43 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d82:	89 f3                	mov    %esi,%ebx
  800d84:	80 fb 19             	cmp    $0x19,%bl
  800d87:	77 29                	ja     800db2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d89:	0f be d2             	movsbl %dl,%edx
  800d8c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d8f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d92:	7d 30                	jge    800dc4 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d94:	83 c1 01             	add    $0x1,%ecx
  800d97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d9b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d9d:	0f b6 11             	movzbl (%ecx),%edx
  800da0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da3:	89 f3                	mov    %esi,%ebx
  800da5:	80 fb 09             	cmp    $0x9,%bl
  800da8:	77 d5                	ja     800d7f <strtol+0x7c>
			dig = *s - '0';
  800daa:	0f be d2             	movsbl %dl,%edx
  800dad:	83 ea 30             	sub    $0x30,%edx
  800db0:	eb dd                	jmp    800d8f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800db2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db5:	89 f3                	mov    %esi,%ebx
  800db7:	80 fb 19             	cmp    $0x19,%bl
  800dba:	77 08                	ja     800dc4 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dbc:	0f be d2             	movsbl %dl,%edx
  800dbf:	83 ea 37             	sub    $0x37,%edx
  800dc2:	eb cb                	jmp    800d8f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc8:	74 05                	je     800dcf <strtol+0xcc>
		*endptr = (char *) s;
  800dca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dcf:	89 c2                	mov    %eax,%edx
  800dd1:	f7 da                	neg    %edx
  800dd3:	85 ff                	test   %edi,%edi
  800dd5:	0f 45 c2             	cmovne %edx,%eax
}
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	b8 00 00 00 00       	mov    $0x0,%eax
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	89 c3                	mov    %eax,%ebx
  800df0:	89 c7                	mov    %eax,%edi
  800df2:	89 c6                	mov    %eax,%esi
  800df4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_cgetc>:

int
sys_cgetc(void)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	b8 01 00 00 00       	mov    $0x1,%eax
  800e0b:	89 d1                	mov    %edx,%ecx
  800e0d:	89 d3                	mov    %edx,%ebx
  800e0f:	89 d7                	mov    %edx,%edi
  800e11:	89 d6                	mov    %edx,%esi
  800e13:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	89 cb                	mov    %ecx,%ebx
  800e32:	89 cf                	mov    %ecx,%edi
  800e34:	89 ce                	mov    %ecx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 03                	push   $0x3
  800e4a:	68 e8 2a 80 00       	push   $0x802ae8
  800e4f:	6a 43                	push   $0x43
  800e51:	68 05 2b 80 00       	push   $0x802b05
  800e56:	e8 f7 f3 ff ff       	call   800252 <_panic>

00800e5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e61:	ba 00 00 00 00       	mov    $0x0,%edx
  800e66:	b8 02 00 00 00       	mov    $0x2,%eax
  800e6b:	89 d1                	mov    %edx,%ecx
  800e6d:	89 d3                	mov    %edx,%ebx
  800e6f:	89 d7                	mov    %edx,%edi
  800e71:	89 d6                	mov    %edx,%esi
  800e73:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <sys_yield>:

void
sys_yield(void)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e80:	ba 00 00 00 00       	mov    $0x0,%edx
  800e85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e8a:	89 d1                	mov    %edx,%ecx
  800e8c:	89 d3                	mov    %edx,%ebx
  800e8e:	89 d7                	mov    %edx,%edi
  800e90:	89 d6                	mov    %edx,%esi
  800e92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea2:	be 00 00 00 00       	mov    $0x0,%esi
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb5:	89 f7                	mov    %esi,%edi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 04                	push   $0x4
  800ecb:	68 e8 2a 80 00       	push   $0x802ae8
  800ed0:	6a 43                	push   $0x43
  800ed2:	68 05 2b 80 00       	push   $0x802b05
  800ed7:	e8 76 f3 ff ff       	call   800252 <_panic>

00800edc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 05                	push   $0x5
  800f0d:	68 e8 2a 80 00       	push   $0x802ae8
  800f12:	6a 43                	push   $0x43
  800f14:	68 05 2b 80 00       	push   $0x802b05
  800f19:	e8 34 f3 ff ff       	call   800252 <_panic>

00800f1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 06 00 00 00       	mov    $0x6,%eax
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	89 de                	mov    %ebx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	50                   	push   %eax
  800f4d:	6a 06                	push   $0x6
  800f4f:	68 e8 2a 80 00       	push   $0x802ae8
  800f54:	6a 43                	push   $0x43
  800f56:	68 05 2b 80 00       	push   $0x802b05
  800f5b:	e8 f2 f2 ff ff       	call   800252 <_panic>

00800f60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	b8 08 00 00 00       	mov    $0x8,%eax
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 08                	push   $0x8
  800f91:	68 e8 2a 80 00       	push   $0x802ae8
  800f96:	6a 43                	push   $0x43
  800f98:	68 05 2b 80 00       	push   $0x802b05
  800f9d:	e8 b0 f2 ff ff       	call   800252 <_panic>

00800fa2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 09 00 00 00       	mov    $0x9,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7f 08                	jg     800fcd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	50                   	push   %eax
  800fd1:	6a 09                	push   $0x9
  800fd3:	68 e8 2a 80 00       	push   $0x802ae8
  800fd8:	6a 43                	push   $0x43
  800fda:	68 05 2b 80 00       	push   $0x802b05
  800fdf:	e8 6e f2 ff ff       	call   800252 <_panic>

00800fe4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7f 08                	jg     80100f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	6a 0a                	push   $0xa
  801015:	68 e8 2a 80 00       	push   $0x802ae8
  80101a:	6a 43                	push   $0x43
  80101c:	68 05 2b 80 00       	push   $0x802b05
  801021:	e8 2c f2 ff ff       	call   800252 <_panic>

00801026 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	b8 0c 00 00 00       	mov    $0xc,%eax
  801037:	be 00 00 00 00       	mov    $0x0,%esi
  80103c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801042:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
  80104f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801052:	b9 00 00 00 00       	mov    $0x0,%ecx
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105f:	89 cb                	mov    %ecx,%ebx
  801061:	89 cf                	mov    %ecx,%edi
  801063:	89 ce                	mov    %ecx,%esi
  801065:	cd 30                	int    $0x30
	if(check && ret > 0)
  801067:	85 c0                	test   %eax,%eax
  801069:	7f 08                	jg     801073 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  801077:	6a 0d                	push   $0xd
  801079:	68 e8 2a 80 00       	push   $0x802ae8
  80107e:	6a 43                	push   $0x43
  801080:	68 05 2b 80 00       	push   $0x802b05
  801085:	e8 c8 f1 ff ff       	call   800252 <_panic>

0080108a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a0:	89 df                	mov    %ebx,%edi
  8010a2:	89 de                	mov    %ebx,%esi
  8010a4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5f                   	pop    %edi
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010be:	89 cb                	mov    %ecx,%ebx
  8010c0:	89 cf                	mov    %ecx,%edi
  8010c2:	89 ce                	mov    %ecx,%esi
  8010c4:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fb:	b8 11 00 00 00       	mov    $0x11,%eax
  801100:	89 df                	mov    %ebx,%edi
  801102:	89 de                	mov    %ebx,%esi
  801104:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801106:	5b                   	pop    %ebx
  801107:	5e                   	pop    %esi
  801108:	5f                   	pop    %edi
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    

0080110b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
	asm volatile("int %1\n"
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
  801116:	8b 55 08             	mov    0x8(%ebp),%edx
  801119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111c:	b8 12 00 00 00       	mov    $0x12,%eax
  801121:	89 df                	mov    %ebx,%edi
  801123:	89 de                	mov    %ebx,%esi
  801125:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801127:	5b                   	pop    %ebx
  801128:	5e                   	pop    %esi
  801129:	5f                   	pop    %edi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801135:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801140:	b8 13 00 00 00       	mov    $0x13,%eax
  801145:	89 df                	mov    %ebx,%edi
  801147:	89 de                	mov    %ebx,%esi
  801149:	cd 30                	int    $0x30
	if(check && ret > 0)
  80114b:	85 c0                	test   %eax,%eax
  80114d:	7f 08                	jg     801157 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80114f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801152:	5b                   	pop    %ebx
  801153:	5e                   	pop    %esi
  801154:	5f                   	pop    %edi
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	50                   	push   %eax
  80115b:	6a 13                	push   $0x13
  80115d:	68 e8 2a 80 00       	push   $0x802ae8
  801162:	6a 43                	push   $0x43
  801164:	68 05 2b 80 00       	push   $0x802b05
  801169:	e8 e4 f0 ff ff       	call   800252 <_panic>

0080116e <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	57                   	push   %edi
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
	asm volatile("int %1\n"
  801174:	b9 00 00 00 00       	mov    $0x0,%ecx
  801179:	8b 55 08             	mov    0x8(%ebp),%edx
  80117c:	b8 14 00 00 00       	mov    $0x14,%eax
  801181:	89 cb                	mov    %ecx,%ebx
  801183:	89 cf                	mov    %ecx,%edi
  801185:	89 ce                	mov    %ecx,%esi
  801187:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	05 00 00 00 30       	add    $0x30000000,%eax
  801199:	c1 e8 0c             	shr    $0xc,%eax
}
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ae:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	c1 ea 16             	shr    $0x16,%edx
  8011c2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c9:	f6 c2 01             	test   $0x1,%dl
  8011cc:	74 2d                	je     8011fb <fd_alloc+0x46>
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	c1 ea 0c             	shr    $0xc,%edx
  8011d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011da:	f6 c2 01             	test   $0x1,%dl
  8011dd:	74 1c                	je     8011fb <fd_alloc+0x46>
  8011df:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011e4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e9:	75 d2                	jne    8011bd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011f4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f9:	eb 0a                	jmp    801205 <fd_alloc+0x50>
			*fd_store = fd;
  8011fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    

00801207 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80120d:	83 f8 1f             	cmp    $0x1f,%eax
  801210:	77 30                	ja     801242 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801212:	c1 e0 0c             	shl    $0xc,%eax
  801215:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80121a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801220:	f6 c2 01             	test   $0x1,%dl
  801223:	74 24                	je     801249 <fd_lookup+0x42>
  801225:	89 c2                	mov    %eax,%edx
  801227:	c1 ea 0c             	shr    $0xc,%edx
  80122a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801231:	f6 c2 01             	test   $0x1,%dl
  801234:	74 1a                	je     801250 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801236:	8b 55 0c             	mov    0xc(%ebp),%edx
  801239:	89 02                	mov    %eax,(%edx)
	return 0;
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801240:	5d                   	pop    %ebp
  801241:	c3                   	ret    
		return -E_INVAL;
  801242:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801247:	eb f7                	jmp    801240 <fd_lookup+0x39>
		return -E_INVAL;
  801249:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124e:	eb f0                	jmp    801240 <fd_lookup+0x39>
  801250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801255:	eb e9                	jmp    801240 <fd_lookup+0x39>

00801257 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	83 ec 08             	sub    $0x8,%esp
  80125d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801260:	ba 00 00 00 00       	mov    $0x0,%edx
  801265:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80126a:	39 08                	cmp    %ecx,(%eax)
  80126c:	74 38                	je     8012a6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80126e:	83 c2 01             	add    $0x1,%edx
  801271:	8b 04 95 94 2b 80 00 	mov    0x802b94(,%edx,4),%eax
  801278:	85 c0                	test   %eax,%eax
  80127a:	75 ee                	jne    80126a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80127c:	a1 08 40 80 00       	mov    0x804008,%eax
  801281:	8b 40 48             	mov    0x48(%eax),%eax
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	51                   	push   %ecx
  801288:	50                   	push   %eax
  801289:	68 14 2b 80 00       	push   $0x802b14
  80128e:	e8 b5 f0 ff ff       	call   800348 <cprintf>
	*dev = 0;
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    
			*dev = devtab[i];
  8012a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b0:	eb f2                	jmp    8012a4 <dev_lookup+0x4d>

008012b2 <fd_close>:
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 24             	sub    $0x24,%esp
  8012bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8012be:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012cb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ce:	50                   	push   %eax
  8012cf:	e8 33 ff ff ff       	call   801207 <fd_lookup>
  8012d4:	89 c3                	mov    %eax,%ebx
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	78 05                	js     8012e2 <fd_close+0x30>
	    || fd != fd2)
  8012dd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012e0:	74 16                	je     8012f8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012e2:	89 f8                	mov    %edi,%eax
  8012e4:	84 c0                	test   %al,%al
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012eb:	0f 44 d8             	cmove  %eax,%ebx
}
  8012ee:	89 d8                	mov    %ebx,%eax
  8012f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f3:	5b                   	pop    %ebx
  8012f4:	5e                   	pop    %esi
  8012f5:	5f                   	pop    %edi
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012fe:	50                   	push   %eax
  8012ff:	ff 36                	pushl  (%esi)
  801301:	e8 51 ff ff ff       	call   801257 <dev_lookup>
  801306:	89 c3                	mov    %eax,%ebx
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	85 c0                	test   %eax,%eax
  80130d:	78 1a                	js     801329 <fd_close+0x77>
		if (dev->dev_close)
  80130f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801312:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801315:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 0b                	je     801329 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	56                   	push   %esi
  801322:	ff d0                	call   *%eax
  801324:	89 c3                	mov    %eax,%ebx
  801326:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	56                   	push   %esi
  80132d:	6a 00                	push   $0x0
  80132f:	e8 ea fb ff ff       	call   800f1e <sys_page_unmap>
	return r;
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	eb b5                	jmp    8012ee <fd_close+0x3c>

00801339 <close>:

int
close(int fdnum)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80133f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801342:	50                   	push   %eax
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	e8 bc fe ff ff       	call   801207 <fd_lookup>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	79 02                	jns    801354 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    
		return fd_close(fd, 1);
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	6a 01                	push   $0x1
  801359:	ff 75 f4             	pushl  -0xc(%ebp)
  80135c:	e8 51 ff ff ff       	call   8012b2 <fd_close>
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	eb ec                	jmp    801352 <close+0x19>

00801366 <close_all>:

void
close_all(void)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	53                   	push   %ebx
  80136a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80136d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801372:	83 ec 0c             	sub    $0xc,%esp
  801375:	53                   	push   %ebx
  801376:	e8 be ff ff ff       	call   801339 <close>
	for (i = 0; i < MAXFD; i++)
  80137b:	83 c3 01             	add    $0x1,%ebx
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	83 fb 20             	cmp    $0x20,%ebx
  801384:	75 ec                	jne    801372 <close_all+0xc>
}
  801386:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	57                   	push   %edi
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
  801391:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801394:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	ff 75 08             	pushl  0x8(%ebp)
  80139b:	e8 67 fe ff ff       	call   801207 <fd_lookup>
  8013a0:	89 c3                	mov    %eax,%ebx
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	0f 88 81 00 00 00    	js     80142e <dup+0xa3>
		return r;
	close(newfdnum);
  8013ad:	83 ec 0c             	sub    $0xc,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	e8 81 ff ff ff       	call   801339 <close>

	newfd = INDEX2FD(newfdnum);
  8013b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013bb:	c1 e6 0c             	shl    $0xc,%esi
  8013be:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013c4:	83 c4 04             	add    $0x4,%esp
  8013c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013ca:	e8 cf fd ff ff       	call   80119e <fd2data>
  8013cf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013d1:	89 34 24             	mov    %esi,(%esp)
  8013d4:	e8 c5 fd ff ff       	call   80119e <fd2data>
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013de:	89 d8                	mov    %ebx,%eax
  8013e0:	c1 e8 16             	shr    $0x16,%eax
  8013e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ea:	a8 01                	test   $0x1,%al
  8013ec:	74 11                	je     8013ff <dup+0x74>
  8013ee:	89 d8                	mov    %ebx,%eax
  8013f0:	c1 e8 0c             	shr    $0xc,%eax
  8013f3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013fa:	f6 c2 01             	test   $0x1,%dl
  8013fd:	75 39                	jne    801438 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801402:	89 d0                	mov    %edx,%eax
  801404:	c1 e8 0c             	shr    $0xc,%eax
  801407:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	25 07 0e 00 00       	and    $0xe07,%eax
  801416:	50                   	push   %eax
  801417:	56                   	push   %esi
  801418:	6a 00                	push   $0x0
  80141a:	52                   	push   %edx
  80141b:	6a 00                	push   $0x0
  80141d:	e8 ba fa ff ff       	call   800edc <sys_page_map>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 20             	add    $0x20,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 31                	js     80145c <dup+0xd1>
		goto err;

	return newfdnum;
  80142b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142e:	89 d8                	mov    %ebx,%eax
  801430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5f                   	pop    %edi
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801438:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80143f:	83 ec 0c             	sub    $0xc,%esp
  801442:	25 07 0e 00 00       	and    $0xe07,%eax
  801447:	50                   	push   %eax
  801448:	57                   	push   %edi
  801449:	6a 00                	push   $0x0
  80144b:	53                   	push   %ebx
  80144c:	6a 00                	push   $0x0
  80144e:	e8 89 fa ff ff       	call   800edc <sys_page_map>
  801453:	89 c3                	mov    %eax,%ebx
  801455:	83 c4 20             	add    $0x20,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	79 a3                	jns    8013ff <dup+0x74>
	sys_page_unmap(0, newfd);
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	56                   	push   %esi
  801460:	6a 00                	push   $0x0
  801462:	e8 b7 fa ff ff       	call   800f1e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801467:	83 c4 08             	add    $0x8,%esp
  80146a:	57                   	push   %edi
  80146b:	6a 00                	push   $0x0
  80146d:	e8 ac fa ff ff       	call   800f1e <sys_page_unmap>
	return r;
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	eb b7                	jmp    80142e <dup+0xa3>

00801477 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	53                   	push   %ebx
  80147b:	83 ec 1c             	sub    $0x1c,%esp
  80147e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801481:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801484:	50                   	push   %eax
  801485:	53                   	push   %ebx
  801486:	e8 7c fd ff ff       	call   801207 <fd_lookup>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 3f                	js     8014d1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801498:	50                   	push   %eax
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149c:	ff 30                	pushl  (%eax)
  80149e:	e8 b4 fd ff ff       	call   801257 <dev_lookup>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 27                	js     8014d1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ad:	8b 42 08             	mov    0x8(%edx),%eax
  8014b0:	83 e0 03             	and    $0x3,%eax
  8014b3:	83 f8 01             	cmp    $0x1,%eax
  8014b6:	74 1e                	je     8014d6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	8b 40 08             	mov    0x8(%eax),%eax
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	74 35                	je     8014f7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	ff 75 10             	pushl  0x10(%ebp)
  8014c8:	ff 75 0c             	pushl  0xc(%ebp)
  8014cb:	52                   	push   %edx
  8014cc:	ff d0                	call   *%eax
  8014ce:	83 c4 10             	add    $0x10,%esp
}
  8014d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8014db:	8b 40 48             	mov    0x48(%eax),%eax
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	53                   	push   %ebx
  8014e2:	50                   	push   %eax
  8014e3:	68 58 2b 80 00       	push   $0x802b58
  8014e8:	e8 5b ee ff ff       	call   800348 <cprintf>
		return -E_INVAL;
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f5:	eb da                	jmp    8014d1 <read+0x5a>
		return -E_NOT_SUPP;
  8014f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fc:	eb d3                	jmp    8014d1 <read+0x5a>

008014fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	57                   	push   %edi
  801502:	56                   	push   %esi
  801503:	53                   	push   %ebx
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	8b 7d 08             	mov    0x8(%ebp),%edi
  80150a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801512:	39 f3                	cmp    %esi,%ebx
  801514:	73 23                	jae    801539 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	89 f0                	mov    %esi,%eax
  80151b:	29 d8                	sub    %ebx,%eax
  80151d:	50                   	push   %eax
  80151e:	89 d8                	mov    %ebx,%eax
  801520:	03 45 0c             	add    0xc(%ebp),%eax
  801523:	50                   	push   %eax
  801524:	57                   	push   %edi
  801525:	e8 4d ff ff ff       	call   801477 <read>
		if (m < 0)
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	78 06                	js     801537 <readn+0x39>
			return m;
		if (m == 0)
  801531:	74 06                	je     801539 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801533:	01 c3                	add    %eax,%ebx
  801535:	eb db                	jmp    801512 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801537:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801539:	89 d8                	mov    %ebx,%eax
  80153b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153e:	5b                   	pop    %ebx
  80153f:	5e                   	pop    %esi
  801540:	5f                   	pop    %edi
  801541:	5d                   	pop    %ebp
  801542:	c3                   	ret    

00801543 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	53                   	push   %ebx
  801547:	83 ec 1c             	sub    $0x1c,%esp
  80154a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801550:	50                   	push   %eax
  801551:	53                   	push   %ebx
  801552:	e8 b0 fc ff ff       	call   801207 <fd_lookup>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 3a                	js     801598 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801564:	50                   	push   %eax
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	ff 30                	pushl  (%eax)
  80156a:	e8 e8 fc ff ff       	call   801257 <dev_lookup>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 22                	js     801598 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80157d:	74 1e                	je     80159d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801582:	8b 52 0c             	mov    0xc(%edx),%edx
  801585:	85 d2                	test   %edx,%edx
  801587:	74 35                	je     8015be <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	ff 75 10             	pushl  0x10(%ebp)
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	50                   	push   %eax
  801593:	ff d2                	call   *%edx
  801595:	83 c4 10             	add    $0x10,%esp
}
  801598:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80159d:	a1 08 40 80 00       	mov    0x804008,%eax
  8015a2:	8b 40 48             	mov    0x48(%eax),%eax
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	53                   	push   %ebx
  8015a9:	50                   	push   %eax
  8015aa:	68 74 2b 80 00       	push   $0x802b74
  8015af:	e8 94 ed ff ff       	call   800348 <cprintf>
		return -E_INVAL;
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015bc:	eb da                	jmp    801598 <write+0x55>
		return -E_NOT_SUPP;
  8015be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c3:	eb d3                	jmp    801598 <write+0x55>

008015c5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	e8 30 fc ff ff       	call   801207 <fd_lookup>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	78 0e                	js     8015ec <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 1c             	sub    $0x1c,%esp
  8015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015fb:	50                   	push   %eax
  8015fc:	53                   	push   %ebx
  8015fd:	e8 05 fc ff ff       	call   801207 <fd_lookup>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	85 c0                	test   %eax,%eax
  801607:	78 37                	js     801640 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160f:	50                   	push   %eax
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	ff 30                	pushl  (%eax)
  801615:	e8 3d fc ff ff       	call   801257 <dev_lookup>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 1f                	js     801640 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801624:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801628:	74 1b                	je     801645 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80162a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162d:	8b 52 18             	mov    0x18(%edx),%edx
  801630:	85 d2                	test   %edx,%edx
  801632:	74 32                	je     801666 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	50                   	push   %eax
  80163b:	ff d2                	call   *%edx
  80163d:	83 c4 10             	add    $0x10,%esp
}
  801640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801643:	c9                   	leave  
  801644:	c3                   	ret    
			thisenv->env_id, fdnum);
  801645:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80164a:	8b 40 48             	mov    0x48(%eax),%eax
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	53                   	push   %ebx
  801651:	50                   	push   %eax
  801652:	68 34 2b 80 00       	push   $0x802b34
  801657:	e8 ec ec ff ff       	call   800348 <cprintf>
		return -E_INVAL;
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801664:	eb da                	jmp    801640 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801666:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166b:	eb d3                	jmp    801640 <ftruncate+0x52>

0080166d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	53                   	push   %ebx
  801671:	83 ec 1c             	sub    $0x1c,%esp
  801674:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801677:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	ff 75 08             	pushl  0x8(%ebp)
  80167e:	e8 84 fb ff ff       	call   801207 <fd_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 4b                	js     8016d5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80168a:	83 ec 08             	sub    $0x8,%esp
  80168d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801690:	50                   	push   %eax
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	ff 30                	pushl  (%eax)
  801696:	e8 bc fb ff ff       	call   801257 <dev_lookup>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 33                	js     8016d5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a9:	74 2f                	je     8016da <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016ab:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ae:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016b5:	00 00 00 
	stat->st_isdir = 0;
  8016b8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bf:	00 00 00 
	stat->st_dev = dev;
  8016c2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	53                   	push   %ebx
  8016cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8016cf:	ff 50 14             	call   *0x14(%eax)
  8016d2:	83 c4 10             	add    $0x10,%esp
}
  8016d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    
		return -E_NOT_SUPP;
  8016da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016df:	eb f4                	jmp    8016d5 <fstat+0x68>

008016e1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	6a 00                	push   $0x0
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	e8 22 02 00 00       	call   801915 <open>
  8016f3:	89 c3                	mov    %eax,%ebx
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 1b                	js     801717 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016fc:	83 ec 08             	sub    $0x8,%esp
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	50                   	push   %eax
  801703:	e8 65 ff ff ff       	call   80166d <fstat>
  801708:	89 c6                	mov    %eax,%esi
	close(fd);
  80170a:	89 1c 24             	mov    %ebx,(%esp)
  80170d:	e8 27 fc ff ff       	call   801339 <close>
	return r;
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 f3                	mov    %esi,%ebx
}
  801717:	89 d8                	mov    %ebx,%eax
  801719:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171c:	5b                   	pop    %ebx
  80171d:	5e                   	pop    %esi
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	89 c6                	mov    %eax,%esi
  801727:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801729:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801730:	74 27                	je     801759 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801732:	6a 07                	push   $0x7
  801734:	68 00 50 80 00       	push   $0x805000
  801739:	56                   	push   %esi
  80173a:	ff 35 00 40 80 00    	pushl  0x804000
  801740:	e8 08 0c 00 00       	call   80234d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801745:	83 c4 0c             	add    $0xc,%esp
  801748:	6a 00                	push   $0x0
  80174a:	53                   	push   %ebx
  80174b:	6a 00                	push   $0x0
  80174d:	e8 92 0b 00 00       	call   8022e4 <ipc_recv>
}
  801752:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801759:	83 ec 0c             	sub    $0xc,%esp
  80175c:	6a 01                	push   $0x1
  80175e:	e8 42 0c 00 00       	call   8023a5 <ipc_find_env>
  801763:	a3 00 40 80 00       	mov    %eax,0x804000
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	eb c5                	jmp    801732 <fsipc+0x12>

0080176d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8b 40 0c             	mov    0xc(%eax),%eax
  801779:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80177e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801781:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801786:	ba 00 00 00 00       	mov    $0x0,%edx
  80178b:	b8 02 00 00 00       	mov    $0x2,%eax
  801790:	e8 8b ff ff ff       	call   801720 <fsipc>
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <devfile_flush>:
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8017b2:	e8 69 ff ff ff       	call   801720 <fsipc>
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <devfile_stat>:
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d8:	e8 43 ff ff ff       	call   801720 <fsipc>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 2c                	js     80180d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	68 00 50 80 00       	push   $0x805000
  8017e9:	53                   	push   %ebx
  8017ea:	e8 b8 f2 ff ff       	call   800aa7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ef:	a1 80 50 80 00       	mov    0x805080,%eax
  8017f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017fa:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <devfile_write>:
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	53                   	push   %ebx
  801816:	83 ec 08             	sub    $0x8,%esp
  801819:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 40 0c             	mov    0xc(%eax),%eax
  801822:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801827:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80182d:	53                   	push   %ebx
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	68 08 50 80 00       	push   $0x805008
  801836:	e8 5c f4 ff ff       	call   800c97 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80183b:	ba 00 00 00 00       	mov    $0x0,%edx
  801840:	b8 04 00 00 00       	mov    $0x4,%eax
  801845:	e8 d6 fe ff ff       	call   801720 <fsipc>
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	78 0b                	js     80185c <devfile_write+0x4a>
	assert(r <= n);
  801851:	39 d8                	cmp    %ebx,%eax
  801853:	77 0c                	ja     801861 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801855:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80185a:	7f 1e                	jg     80187a <devfile_write+0x68>
}
  80185c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185f:	c9                   	leave  
  801860:	c3                   	ret    
	assert(r <= n);
  801861:	68 a8 2b 80 00       	push   $0x802ba8
  801866:	68 af 2b 80 00       	push   $0x802baf
  80186b:	68 98 00 00 00       	push   $0x98
  801870:	68 c4 2b 80 00       	push   $0x802bc4
  801875:	e8 d8 e9 ff ff       	call   800252 <_panic>
	assert(r <= PGSIZE);
  80187a:	68 cf 2b 80 00       	push   $0x802bcf
  80187f:	68 af 2b 80 00       	push   $0x802baf
  801884:	68 99 00 00 00       	push   $0x99
  801889:	68 c4 2b 80 00       	push   $0x802bc4
  80188e:	e8 bf e9 ff ff       	call   800252 <_panic>

00801893 <devfile_read>:
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018a6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8018b6:	e8 65 fe ff ff       	call   801720 <fsipc>
  8018bb:	89 c3                	mov    %eax,%ebx
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	78 1f                	js     8018e0 <devfile_read+0x4d>
	assert(r <= n);
  8018c1:	39 f0                	cmp    %esi,%eax
  8018c3:	77 24                	ja     8018e9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ca:	7f 33                	jg     8018ff <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	50                   	push   %eax
  8018d0:	68 00 50 80 00       	push   $0x805000
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	e8 58 f3 ff ff       	call   800c35 <memmove>
	return r;
  8018dd:	83 c4 10             	add    $0x10,%esp
}
  8018e0:	89 d8                	mov    %ebx,%eax
  8018e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    
	assert(r <= n);
  8018e9:	68 a8 2b 80 00       	push   $0x802ba8
  8018ee:	68 af 2b 80 00       	push   $0x802baf
  8018f3:	6a 7c                	push   $0x7c
  8018f5:	68 c4 2b 80 00       	push   $0x802bc4
  8018fa:	e8 53 e9 ff ff       	call   800252 <_panic>
	assert(r <= PGSIZE);
  8018ff:	68 cf 2b 80 00       	push   $0x802bcf
  801904:	68 af 2b 80 00       	push   $0x802baf
  801909:	6a 7d                	push   $0x7d
  80190b:	68 c4 2b 80 00       	push   $0x802bc4
  801910:	e8 3d e9 ff ff       	call   800252 <_panic>

00801915 <open>:
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	56                   	push   %esi
  801919:	53                   	push   %ebx
  80191a:	83 ec 1c             	sub    $0x1c,%esp
  80191d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801920:	56                   	push   %esi
  801921:	e8 48 f1 ff ff       	call   800a6e <strlen>
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80192e:	7f 6c                	jg     80199c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801936:	50                   	push   %eax
  801937:	e8 79 f8 ff ff       	call   8011b5 <fd_alloc>
  80193c:	89 c3                	mov    %eax,%ebx
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	85 c0                	test   %eax,%eax
  801943:	78 3c                	js     801981 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	56                   	push   %esi
  801949:	68 00 50 80 00       	push   $0x805000
  80194e:	e8 54 f1 ff ff       	call   800aa7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801953:	8b 45 0c             	mov    0xc(%ebp),%eax
  801956:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80195b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195e:	b8 01 00 00 00       	mov    $0x1,%eax
  801963:	e8 b8 fd ff ff       	call   801720 <fsipc>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	85 c0                	test   %eax,%eax
  80196f:	78 19                	js     80198a <open+0x75>
	return fd2num(fd);
  801971:	83 ec 0c             	sub    $0xc,%esp
  801974:	ff 75 f4             	pushl  -0xc(%ebp)
  801977:	e8 12 f8 ff ff       	call   80118e <fd2num>
  80197c:	89 c3                	mov    %eax,%ebx
  80197e:	83 c4 10             	add    $0x10,%esp
}
  801981:	89 d8                	mov    %ebx,%eax
  801983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    
		fd_close(fd, 0);
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 f4             	pushl  -0xc(%ebp)
  801992:	e8 1b f9 ff ff       	call   8012b2 <fd_close>
		return r;
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	eb e5                	jmp    801981 <open+0x6c>
		return -E_BAD_PATH;
  80199c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019a1:	eb de                	jmp    801981 <open+0x6c>

008019a3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8019b3:	e8 68 fd ff ff       	call   801720 <fsipc>
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019c0:	68 db 2b 80 00       	push   $0x802bdb
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 da f0 ff ff       	call   800aa7 <strcpy>
	return 0;
}
  8019cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <devsock_close>:
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 10             	sub    $0x10,%esp
  8019db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019de:	53                   	push   %ebx
  8019df:	e8 00 0a 00 00       	call   8023e4 <pageref>
  8019e4:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019e7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019ec:	83 f8 01             	cmp    $0x1,%eax
  8019ef:	74 07                	je     8019f8 <devsock_close+0x24>
}
  8019f1:	89 d0                	mov    %edx,%eax
  8019f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019f8:	83 ec 0c             	sub    $0xc,%esp
  8019fb:	ff 73 0c             	pushl  0xc(%ebx)
  8019fe:	e8 b9 02 00 00       	call   801cbc <nsipc_close>
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	eb e7                	jmp    8019f1 <devsock_close+0x1d>

00801a0a <devsock_write>:
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	ff 75 10             	pushl  0x10(%ebp)
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	ff 70 0c             	pushl  0xc(%eax)
  801a1e:	e8 76 03 00 00       	call   801d99 <nsipc_send>
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <devsock_read>:
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	ff 70 0c             	pushl  0xc(%eax)
  801a39:	e8 ef 02 00 00       	call   801d2d <nsipc_recv>
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <fd2sockid>:
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a46:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a49:	52                   	push   %edx
  801a4a:	50                   	push   %eax
  801a4b:	e8 b7 f7 ff ff       	call   801207 <fd_lookup>
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	85 c0                	test   %eax,%eax
  801a55:	78 10                	js     801a67 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a60:	39 08                	cmp    %ecx,(%eax)
  801a62:	75 05                	jne    801a69 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a64:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    
		return -E_NOT_SUPP;
  801a69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6e:	eb f7                	jmp    801a67 <fd2sockid+0x27>

00801a70 <alloc_sockfd>:
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	56                   	push   %esi
  801a74:	53                   	push   %ebx
  801a75:	83 ec 1c             	sub    $0x1c,%esp
  801a78:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7d:	50                   	push   %eax
  801a7e:	e8 32 f7 ff ff       	call   8011b5 <fd_alloc>
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 43                	js     801acf <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 07 04 00 00       	push   $0x407
  801a94:	ff 75 f4             	pushl  -0xc(%ebp)
  801a97:	6a 00                	push   $0x0
  801a99:	e8 fb f3 ff ff       	call   800e99 <sys_page_alloc>
  801a9e:	89 c3                	mov    %eax,%ebx
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 28                	js     801acf <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ab0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801abc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	50                   	push   %eax
  801ac3:	e8 c6 f6 ff ff       	call   80118e <fd2num>
  801ac8:	89 c3                	mov    %eax,%ebx
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	eb 0c                	jmp    801adb <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	56                   	push   %esi
  801ad3:	e8 e4 01 00 00       	call   801cbc <nsipc_close>
		return r;
  801ad8:	83 c4 10             	add    $0x10,%esp
}
  801adb:	89 d8                	mov    %ebx,%eax
  801add:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <accept>:
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	e8 4e ff ff ff       	call   801a40 <fd2sockid>
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 1b                	js     801b11 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	ff 75 10             	pushl  0x10(%ebp)
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	50                   	push   %eax
  801b00:	e8 0e 01 00 00       	call   801c13 <nsipc_accept>
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 05                	js     801b11 <accept+0x2d>
	return alloc_sockfd(r);
  801b0c:	e8 5f ff ff ff       	call   801a70 <alloc_sockfd>
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <bind>:
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	e8 1f ff ff ff       	call   801a40 <fd2sockid>
  801b21:	85 c0                	test   %eax,%eax
  801b23:	78 12                	js     801b37 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	ff 75 10             	pushl  0x10(%ebp)
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	50                   	push   %eax
  801b2f:	e8 31 01 00 00       	call   801c65 <nsipc_bind>
  801b34:	83 c4 10             	add    $0x10,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <shutdown>:
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	e8 f9 fe ff ff       	call   801a40 <fd2sockid>
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 0f                	js     801b5a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b4b:	83 ec 08             	sub    $0x8,%esp
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	50                   	push   %eax
  801b52:	e8 43 01 00 00       	call   801c9a <nsipc_shutdown>
  801b57:	83 c4 10             	add    $0x10,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <connect>:
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	e8 d6 fe ff ff       	call   801a40 <fd2sockid>
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 12                	js     801b80 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	ff 75 10             	pushl  0x10(%ebp)
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	50                   	push   %eax
  801b78:	e8 59 01 00 00       	call   801cd6 <nsipc_connect>
  801b7d:	83 c4 10             	add    $0x10,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <listen>:
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	e8 b0 fe ff ff       	call   801a40 <fd2sockid>
  801b90:	85 c0                	test   %eax,%eax
  801b92:	78 0f                	js     801ba3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b94:	83 ec 08             	sub    $0x8,%esp
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	e8 6b 01 00 00       	call   801d0b <nsipc_listen>
  801ba0:	83 c4 10             	add    $0x10,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bab:	ff 75 10             	pushl  0x10(%ebp)
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	e8 3e 02 00 00       	call   801df7 <nsipc_socket>
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 05                	js     801bc5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bc0:	e8 ab fe ff ff       	call   801a70 <alloc_sockfd>
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	53                   	push   %ebx
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bd0:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bd7:	74 26                	je     801bff <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd9:	6a 07                	push   $0x7
  801bdb:	68 00 60 80 00       	push   $0x806000
  801be0:	53                   	push   %ebx
  801be1:	ff 35 04 40 80 00    	pushl  0x804004
  801be7:	e8 61 07 00 00       	call   80234d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bec:	83 c4 0c             	add    $0xc,%esp
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	e8 ea 06 00 00       	call   8022e4 <ipc_recv>
}
  801bfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	6a 02                	push   $0x2
  801c04:	e8 9c 07 00 00       	call   8023a5 <ipc_find_env>
  801c09:	a3 04 40 80 00       	mov    %eax,0x804004
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	eb c6                	jmp    801bd9 <nsipc+0x12>

00801c13 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c23:	8b 06                	mov    (%esi),%eax
  801c25:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2f:	e8 93 ff ff ff       	call   801bc7 <nsipc>
  801c34:	89 c3                	mov    %eax,%ebx
  801c36:	85 c0                	test   %eax,%eax
  801c38:	79 09                	jns    801c43 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c3a:	89 d8                	mov    %ebx,%eax
  801c3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	ff 35 10 60 80 00    	pushl  0x806010
  801c4c:	68 00 60 80 00       	push   $0x806000
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	e8 dc ef ff ff       	call   800c35 <memmove>
		*addrlen = ret->ret_addrlen;
  801c59:	a1 10 60 80 00       	mov    0x806010,%eax
  801c5e:	89 06                	mov    %eax,(%esi)
  801c60:	83 c4 10             	add    $0x10,%esp
	return r;
  801c63:	eb d5                	jmp    801c3a <nsipc_accept+0x27>

00801c65 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c77:	53                   	push   %ebx
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	68 04 60 80 00       	push   $0x806004
  801c80:	e8 b0 ef ff ff       	call   800c35 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c85:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c8b:	b8 02 00 00 00       	mov    $0x2,%eax
  801c90:	e8 32 ff ff ff       	call   801bc7 <nsipc>
}
  801c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb5:	e8 0d ff ff ff       	call   801bc7 <nsipc>
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <nsipc_close>:

int
nsipc_close(int s)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cca:	b8 04 00 00 00       	mov    $0x4,%eax
  801ccf:	e8 f3 fe ff ff       	call   801bc7 <nsipc>
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	53                   	push   %ebx
  801cda:	83 ec 08             	sub    $0x8,%esp
  801cdd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ce8:	53                   	push   %ebx
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	68 04 60 80 00       	push   $0x806004
  801cf1:	e8 3f ef ff ff       	call   800c35 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cf6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cfc:	b8 05 00 00 00       	mov    $0x5,%eax
  801d01:	e8 c1 fe ff ff       	call   801bc7 <nsipc>
}
  801d06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d21:	b8 06 00 00 00       	mov    $0x6,%eax
  801d26:	e8 9c fe ff ff       	call   801bc7 <nsipc>
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	56                   	push   %esi
  801d31:	53                   	push   %ebx
  801d32:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d3d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d43:	8b 45 14             	mov    0x14(%ebp),%eax
  801d46:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d4b:	b8 07 00 00 00       	mov    $0x7,%eax
  801d50:	e8 72 fe ff ff       	call   801bc7 <nsipc>
  801d55:	89 c3                	mov    %eax,%ebx
  801d57:	85 c0                	test   %eax,%eax
  801d59:	78 1f                	js     801d7a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d5b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d60:	7f 21                	jg     801d83 <nsipc_recv+0x56>
  801d62:	39 c6                	cmp    %eax,%esi
  801d64:	7c 1d                	jl     801d83 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d66:	83 ec 04             	sub    $0x4,%esp
  801d69:	50                   	push   %eax
  801d6a:	68 00 60 80 00       	push   $0x806000
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	e8 be ee ff ff       	call   800c35 <memmove>
  801d77:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d7a:	89 d8                	mov    %ebx,%eax
  801d7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d83:	68 e7 2b 80 00       	push   $0x802be7
  801d88:	68 af 2b 80 00       	push   $0x802baf
  801d8d:	6a 62                	push   $0x62
  801d8f:	68 fc 2b 80 00       	push   $0x802bfc
  801d94:	e8 b9 e4 ff ff       	call   800252 <_panic>

00801d99 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dab:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801db1:	7f 2e                	jg     801de1 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	53                   	push   %ebx
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	68 0c 60 80 00       	push   $0x80600c
  801dbf:	e8 71 ee ff ff       	call   800c35 <memmove>
	nsipcbuf.send.req_size = size;
  801dc4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dca:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dd2:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd7:	e8 eb fd ff ff       	call   801bc7 <nsipc>
}
  801ddc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    
	assert(size < 1600);
  801de1:	68 08 2c 80 00       	push   $0x802c08
  801de6:	68 af 2b 80 00       	push   $0x802baf
  801deb:	6a 6d                	push   $0x6d
  801ded:	68 fc 2b 80 00       	push   $0x802bfc
  801df2:	e8 5b e4 ff ff       	call   800252 <_panic>

00801df7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e08:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e15:	b8 09 00 00 00       	mov    $0x9,%eax
  801e1a:	e8 a8 fd ff ff       	call   801bc7 <nsipc>
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
  801e26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	e8 6a f3 ff ff       	call   80119e <fd2data>
  801e34:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e36:	83 c4 08             	add    $0x8,%esp
  801e39:	68 14 2c 80 00       	push   $0x802c14
  801e3e:	53                   	push   %ebx
  801e3f:	e8 63 ec ff ff       	call   800aa7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e44:	8b 46 04             	mov    0x4(%esi),%eax
  801e47:	2b 06                	sub    (%esi),%eax
  801e49:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e4f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e56:	00 00 00 
	stat->st_dev = &devpipe;
  801e59:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e60:	30 80 00 
	return 0;
}
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5e                   	pop    %esi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 0c             	sub    $0xc,%esp
  801e76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e79:	53                   	push   %ebx
  801e7a:	6a 00                	push   $0x0
  801e7c:	e8 9d f0 ff ff       	call   800f1e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e81:	89 1c 24             	mov    %ebx,(%esp)
  801e84:	e8 15 f3 ff ff       	call   80119e <fd2data>
  801e89:	83 c4 08             	add    $0x8,%esp
  801e8c:	50                   	push   %eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	e8 8a f0 ff ff       	call   800f1e <sys_page_unmap>
}
  801e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <_pipeisclosed>:
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	57                   	push   %edi
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
  801e9f:	83 ec 1c             	sub    $0x1c,%esp
  801ea2:	89 c7                	mov    %eax,%edi
  801ea4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ea6:	a1 08 40 80 00       	mov    0x804008,%eax
  801eab:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	57                   	push   %edi
  801eb2:	e8 2d 05 00 00       	call   8023e4 <pageref>
  801eb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eba:	89 34 24             	mov    %esi,(%esp)
  801ebd:	e8 22 05 00 00       	call   8023e4 <pageref>
		nn = thisenv->env_runs;
  801ec2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ec8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	39 cb                	cmp    %ecx,%ebx
  801ed0:	74 1b                	je     801eed <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ed2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ed5:	75 cf                	jne    801ea6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ed7:	8b 42 58             	mov    0x58(%edx),%eax
  801eda:	6a 01                	push   $0x1
  801edc:	50                   	push   %eax
  801edd:	53                   	push   %ebx
  801ede:	68 1b 2c 80 00       	push   $0x802c1b
  801ee3:	e8 60 e4 ff ff       	call   800348 <cprintf>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	eb b9                	jmp    801ea6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801eed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef0:	0f 94 c0             	sete   %al
  801ef3:	0f b6 c0             	movzbl %al,%eax
}
  801ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef9:	5b                   	pop    %ebx
  801efa:	5e                   	pop    %esi
  801efb:	5f                   	pop    %edi
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    

00801efe <devpipe_write>:
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	57                   	push   %edi
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	83 ec 28             	sub    $0x28,%esp
  801f07:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f0a:	56                   	push   %esi
  801f0b:	e8 8e f2 ff ff       	call   80119e <fd2data>
  801f10:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f1d:	74 4f                	je     801f6e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f1f:	8b 43 04             	mov    0x4(%ebx),%eax
  801f22:	8b 0b                	mov    (%ebx),%ecx
  801f24:	8d 51 20             	lea    0x20(%ecx),%edx
  801f27:	39 d0                	cmp    %edx,%eax
  801f29:	72 14                	jb     801f3f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f2b:	89 da                	mov    %ebx,%edx
  801f2d:	89 f0                	mov    %esi,%eax
  801f2f:	e8 65 ff ff ff       	call   801e99 <_pipeisclosed>
  801f34:	85 c0                	test   %eax,%eax
  801f36:	75 3b                	jne    801f73 <devpipe_write+0x75>
			sys_yield();
  801f38:	e8 3d ef ff ff       	call   800e7a <sys_yield>
  801f3d:	eb e0                	jmp    801f1f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f42:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f46:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f49:	89 c2                	mov    %eax,%edx
  801f4b:	c1 fa 1f             	sar    $0x1f,%edx
  801f4e:	89 d1                	mov    %edx,%ecx
  801f50:	c1 e9 1b             	shr    $0x1b,%ecx
  801f53:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f56:	83 e2 1f             	and    $0x1f,%edx
  801f59:	29 ca                	sub    %ecx,%edx
  801f5b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f5f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f63:	83 c0 01             	add    $0x1,%eax
  801f66:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f69:	83 c7 01             	add    $0x1,%edi
  801f6c:	eb ac                	jmp    801f1a <devpipe_write+0x1c>
	return i;
  801f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f71:	eb 05                	jmp    801f78 <devpipe_write+0x7a>
				return 0;
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7b:	5b                   	pop    %ebx
  801f7c:	5e                   	pop    %esi
  801f7d:	5f                   	pop    %edi
  801f7e:	5d                   	pop    %ebp
  801f7f:	c3                   	ret    

00801f80 <devpipe_read>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	57                   	push   %edi
  801f84:	56                   	push   %esi
  801f85:	53                   	push   %ebx
  801f86:	83 ec 18             	sub    $0x18,%esp
  801f89:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f8c:	57                   	push   %edi
  801f8d:	e8 0c f2 ff ff       	call   80119e <fd2data>
  801f92:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	be 00 00 00 00       	mov    $0x0,%esi
  801f9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f9f:	75 14                	jne    801fb5 <devpipe_read+0x35>
	return i;
  801fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa4:	eb 02                	jmp    801fa8 <devpipe_read+0x28>
				return i;
  801fa6:	89 f0                	mov    %esi,%eax
}
  801fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5f                   	pop    %edi
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    
			sys_yield();
  801fb0:	e8 c5 ee ff ff       	call   800e7a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fb5:	8b 03                	mov    (%ebx),%eax
  801fb7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fba:	75 18                	jne    801fd4 <devpipe_read+0x54>
			if (i > 0)
  801fbc:	85 f6                	test   %esi,%esi
  801fbe:	75 e6                	jne    801fa6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fc0:	89 da                	mov    %ebx,%edx
  801fc2:	89 f8                	mov    %edi,%eax
  801fc4:	e8 d0 fe ff ff       	call   801e99 <_pipeisclosed>
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	74 e3                	je     801fb0 <devpipe_read+0x30>
				return 0;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	eb d4                	jmp    801fa8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fd4:	99                   	cltd   
  801fd5:	c1 ea 1b             	shr    $0x1b,%edx
  801fd8:	01 d0                	add    %edx,%eax
  801fda:	83 e0 1f             	and    $0x1f,%eax
  801fdd:	29 d0                	sub    %edx,%eax
  801fdf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fe4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fea:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fed:	83 c6 01             	add    $0x1,%esi
  801ff0:	eb aa                	jmp    801f9c <devpipe_read+0x1c>

00801ff2 <pipe>:
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	56                   	push   %esi
  801ff6:	53                   	push   %ebx
  801ff7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ffa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffd:	50                   	push   %eax
  801ffe:	e8 b2 f1 ff ff       	call   8011b5 <fd_alloc>
  802003:	89 c3                	mov    %eax,%ebx
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	85 c0                	test   %eax,%eax
  80200a:	0f 88 23 01 00 00    	js     802133 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	68 07 04 00 00       	push   $0x407
  802018:	ff 75 f4             	pushl  -0xc(%ebp)
  80201b:	6a 00                	push   $0x0
  80201d:	e8 77 ee ff ff       	call   800e99 <sys_page_alloc>
  802022:	89 c3                	mov    %eax,%ebx
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	85 c0                	test   %eax,%eax
  802029:	0f 88 04 01 00 00    	js     802133 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802035:	50                   	push   %eax
  802036:	e8 7a f1 ff ff       	call   8011b5 <fd_alloc>
  80203b:	89 c3                	mov    %eax,%ebx
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	0f 88 db 00 00 00    	js     802123 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 07 04 00 00       	push   $0x407
  802050:	ff 75 f0             	pushl  -0x10(%ebp)
  802053:	6a 00                	push   $0x0
  802055:	e8 3f ee ff ff       	call   800e99 <sys_page_alloc>
  80205a:	89 c3                	mov    %eax,%ebx
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	85 c0                	test   %eax,%eax
  802061:	0f 88 bc 00 00 00    	js     802123 <pipe+0x131>
	va = fd2data(fd0);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	ff 75 f4             	pushl  -0xc(%ebp)
  80206d:	e8 2c f1 ff ff       	call   80119e <fd2data>
  802072:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802074:	83 c4 0c             	add    $0xc,%esp
  802077:	68 07 04 00 00       	push   $0x407
  80207c:	50                   	push   %eax
  80207d:	6a 00                	push   $0x0
  80207f:	e8 15 ee ff ff       	call   800e99 <sys_page_alloc>
  802084:	89 c3                	mov    %eax,%ebx
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	85 c0                	test   %eax,%eax
  80208b:	0f 88 82 00 00 00    	js     802113 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	ff 75 f0             	pushl  -0x10(%ebp)
  802097:	e8 02 f1 ff ff       	call   80119e <fd2data>
  80209c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020a3:	50                   	push   %eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	56                   	push   %esi
  8020a7:	6a 00                	push   $0x0
  8020a9:	e8 2e ee ff ff       	call   800edc <sys_page_map>
  8020ae:	89 c3                	mov    %eax,%ebx
  8020b0:	83 c4 20             	add    $0x20,%esp
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 4e                	js     802105 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020b7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bf:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ce:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e0:	e8 a9 f0 ff ff       	call   80118e <fd2num>
  8020e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ea:	83 c4 04             	add    $0x4,%esp
  8020ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8020f0:	e8 99 f0 ff ff       	call   80118e <fd2num>
  8020f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  802103:	eb 2e                	jmp    802133 <pipe+0x141>
	sys_page_unmap(0, va);
  802105:	83 ec 08             	sub    $0x8,%esp
  802108:	56                   	push   %esi
  802109:	6a 00                	push   $0x0
  80210b:	e8 0e ee ff ff       	call   800f1e <sys_page_unmap>
  802110:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802113:	83 ec 08             	sub    $0x8,%esp
  802116:	ff 75 f0             	pushl  -0x10(%ebp)
  802119:	6a 00                	push   $0x0
  80211b:	e8 fe ed ff ff       	call   800f1e <sys_page_unmap>
  802120:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802123:	83 ec 08             	sub    $0x8,%esp
  802126:	ff 75 f4             	pushl  -0xc(%ebp)
  802129:	6a 00                	push   $0x0
  80212b:	e8 ee ed ff ff       	call   800f1e <sys_page_unmap>
  802130:	83 c4 10             	add    $0x10,%esp
}
  802133:	89 d8                	mov    %ebx,%eax
  802135:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802138:	5b                   	pop    %ebx
  802139:	5e                   	pop    %esi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <pipeisclosed>:
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802145:	50                   	push   %eax
  802146:	ff 75 08             	pushl  0x8(%ebp)
  802149:	e8 b9 f0 ff ff       	call   801207 <fd_lookup>
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	85 c0                	test   %eax,%eax
  802153:	78 18                	js     80216d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	ff 75 f4             	pushl  -0xc(%ebp)
  80215b:	e8 3e f0 ff ff       	call   80119e <fd2data>
	return _pipeisclosed(fd, p);
  802160:	89 c2                	mov    %eax,%edx
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	e8 2f fd ff ff       	call   801e99 <_pipeisclosed>
  80216a:	83 c4 10             	add    $0x10,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	c3                   	ret    

00802175 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80217b:	68 33 2c 80 00       	push   $0x802c33
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	e8 1f e9 ff ff       	call   800aa7 <strcpy>
	return 0;
}
  802188:	b8 00 00 00 00       	mov    $0x0,%eax
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <devcons_write>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	57                   	push   %edi
  802193:	56                   	push   %esi
  802194:	53                   	push   %ebx
  802195:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80219b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021a0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021a6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a9:	73 31                	jae    8021dc <devcons_write+0x4d>
		m = n - tot;
  8021ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ae:	29 f3                	sub    %esi,%ebx
  8021b0:	83 fb 7f             	cmp    $0x7f,%ebx
  8021b3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021b8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021bb:	83 ec 04             	sub    $0x4,%esp
  8021be:	53                   	push   %ebx
  8021bf:	89 f0                	mov    %esi,%eax
  8021c1:	03 45 0c             	add    0xc(%ebp),%eax
  8021c4:	50                   	push   %eax
  8021c5:	57                   	push   %edi
  8021c6:	e8 6a ea ff ff       	call   800c35 <memmove>
		sys_cputs(buf, m);
  8021cb:	83 c4 08             	add    $0x8,%esp
  8021ce:	53                   	push   %ebx
  8021cf:	57                   	push   %edi
  8021d0:	e8 08 ec ff ff       	call   800ddd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021d5:	01 de                	add    %ebx,%esi
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	eb ca                	jmp    8021a6 <devcons_write+0x17>
}
  8021dc:	89 f0                	mov    %esi,%eax
  8021de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <devcons_read>:
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 08             	sub    $0x8,%esp
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021f5:	74 21                	je     802218 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021f7:	e8 ff eb ff ff       	call   800dfb <sys_cgetc>
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	75 07                	jne    802207 <devcons_read+0x21>
		sys_yield();
  802200:	e8 75 ec ff ff       	call   800e7a <sys_yield>
  802205:	eb f0                	jmp    8021f7 <devcons_read+0x11>
	if (c < 0)
  802207:	78 0f                	js     802218 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802209:	83 f8 04             	cmp    $0x4,%eax
  80220c:	74 0c                	je     80221a <devcons_read+0x34>
	*(char*)vbuf = c;
  80220e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802211:	88 02                	mov    %al,(%edx)
	return 1;
  802213:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    
		return 0;
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	eb f7                	jmp    802218 <devcons_read+0x32>

00802221 <cputchar>:
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80222d:	6a 01                	push   $0x1
  80222f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802232:	50                   	push   %eax
  802233:	e8 a5 eb ff ff       	call   800ddd <sys_cputs>
}
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <getchar>:
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802243:	6a 01                	push   $0x1
  802245:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802248:	50                   	push   %eax
  802249:	6a 00                	push   $0x0
  80224b:	e8 27 f2 ff ff       	call   801477 <read>
	if (r < 0)
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	85 c0                	test   %eax,%eax
  802255:	78 06                	js     80225d <getchar+0x20>
	if (r < 1)
  802257:	74 06                	je     80225f <getchar+0x22>
	return c;
  802259:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    
		return -E_EOF;
  80225f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802264:	eb f7                	jmp    80225d <getchar+0x20>

00802266 <iscons>:
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80226c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226f:	50                   	push   %eax
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	e8 8f ef ff ff       	call   801207 <fd_lookup>
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	85 c0                	test   %eax,%eax
  80227d:	78 11                	js     802290 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802288:	39 10                	cmp    %edx,(%eax)
  80228a:	0f 94 c0             	sete   %al
  80228d:	0f b6 c0             	movzbl %al,%eax
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <opencons>:
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802298:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229b:	50                   	push   %eax
  80229c:	e8 14 ef ff ff       	call   8011b5 <fd_alloc>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 3a                	js     8022e2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	68 07 04 00 00       	push   $0x407
  8022b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b3:	6a 00                	push   $0x0
  8022b5:	e8 df eb ff ff       	call   800e99 <sys_page_alloc>
  8022ba:	83 c4 10             	add    $0x10,%esp
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	78 21                	js     8022e2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022d6:	83 ec 0c             	sub    $0xc,%esp
  8022d9:	50                   	push   %eax
  8022da:	e8 af ee ff ff       	call   80118e <fd2num>
  8022df:	83 c4 10             	add    $0x10,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	56                   	push   %esi
  8022e8:	53                   	push   %ebx
  8022e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8022ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022f2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022f4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022f9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	50                   	push   %eax
  802300:	e8 44 ed ff ff       	call   801049 <sys_ipc_recv>
	if(ret < 0){
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 2b                	js     802337 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80230c:	85 f6                	test   %esi,%esi
  80230e:	74 0a                	je     80231a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802310:	a1 08 40 80 00       	mov    0x804008,%eax
  802315:	8b 40 78             	mov    0x78(%eax),%eax
  802318:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80231a:	85 db                	test   %ebx,%ebx
  80231c:	74 0a                	je     802328 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80231e:	a1 08 40 80 00       	mov    0x804008,%eax
  802323:	8b 40 7c             	mov    0x7c(%eax),%eax
  802326:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802328:	a1 08 40 80 00       	mov    0x804008,%eax
  80232d:	8b 40 74             	mov    0x74(%eax),%eax
}
  802330:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802333:	5b                   	pop    %ebx
  802334:	5e                   	pop    %esi
  802335:	5d                   	pop    %ebp
  802336:	c3                   	ret    
		if(from_env_store)
  802337:	85 f6                	test   %esi,%esi
  802339:	74 06                	je     802341 <ipc_recv+0x5d>
			*from_env_store = 0;
  80233b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802341:	85 db                	test   %ebx,%ebx
  802343:	74 eb                	je     802330 <ipc_recv+0x4c>
			*perm_store = 0;
  802345:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80234b:	eb e3                	jmp    802330 <ipc_recv+0x4c>

0080234d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	57                   	push   %edi
  802351:	56                   	push   %esi
  802352:	53                   	push   %ebx
  802353:	83 ec 0c             	sub    $0xc,%esp
  802356:	8b 7d 08             	mov    0x8(%ebp),%edi
  802359:	8b 75 0c             	mov    0xc(%ebp),%esi
  80235c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80235f:	85 db                	test   %ebx,%ebx
  802361:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802366:	0f 44 d8             	cmove  %eax,%ebx
  802369:	eb 05                	jmp    802370 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80236b:	e8 0a eb ff ff       	call   800e7a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802370:	ff 75 14             	pushl  0x14(%ebp)
  802373:	53                   	push   %ebx
  802374:	56                   	push   %esi
  802375:	57                   	push   %edi
  802376:	e8 ab ec ff ff       	call   801026 <sys_ipc_try_send>
  80237b:	83 c4 10             	add    $0x10,%esp
  80237e:	85 c0                	test   %eax,%eax
  802380:	74 1b                	je     80239d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802382:	79 e7                	jns    80236b <ipc_send+0x1e>
  802384:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802387:	74 e2                	je     80236b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	68 3f 2c 80 00       	push   $0x802c3f
  802391:	6a 46                	push   $0x46
  802393:	68 54 2c 80 00       	push   $0x802c54
  802398:	e8 b5 de ff ff       	call   800252 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80239d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    

008023a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023b0:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8023b6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023bc:	8b 52 50             	mov    0x50(%edx),%edx
  8023bf:	39 ca                	cmp    %ecx,%edx
  8023c1:	74 11                	je     8023d4 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8023c3:	83 c0 01             	add    $0x1,%eax
  8023c6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023cb:	75 e3                	jne    8023b0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d2:	eb 0e                	jmp    8023e2 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8023d4:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8023da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023df:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ea:	89 d0                	mov    %edx,%eax
  8023ec:	c1 e8 16             	shr    $0x16,%eax
  8023ef:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023fb:	f6 c1 01             	test   $0x1,%cl
  8023fe:	74 1d                	je     80241d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802400:	c1 ea 0c             	shr    $0xc,%edx
  802403:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80240a:	f6 c2 01             	test   $0x1,%dl
  80240d:	74 0e                	je     80241d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80240f:	c1 ea 0c             	shr    $0xc,%edx
  802412:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802419:	ef 
  80241a:	0f b7 c0             	movzwl %ax,%eax
}
  80241d:	5d                   	pop    %ebp
  80241e:	c3                   	ret    
  80241f:	90                   	nop

00802420 <__udivdi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80242b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80242f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802433:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802437:	85 d2                	test   %edx,%edx
  802439:	75 4d                	jne    802488 <__udivdi3+0x68>
  80243b:	39 f3                	cmp    %esi,%ebx
  80243d:	76 19                	jbe    802458 <__udivdi3+0x38>
  80243f:	31 ff                	xor    %edi,%edi
  802441:	89 e8                	mov    %ebp,%eax
  802443:	89 f2                	mov    %esi,%edx
  802445:	f7 f3                	div    %ebx
  802447:	89 fa                	mov    %edi,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 d9                	mov    %ebx,%ecx
  80245a:	85 db                	test   %ebx,%ebx
  80245c:	75 0b                	jne    802469 <__udivdi3+0x49>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f3                	div    %ebx
  802467:	89 c1                	mov    %eax,%ecx
  802469:	31 d2                	xor    %edx,%edx
  80246b:	89 f0                	mov    %esi,%eax
  80246d:	f7 f1                	div    %ecx
  80246f:	89 c6                	mov    %eax,%esi
  802471:	89 e8                	mov    %ebp,%eax
  802473:	89 f7                	mov    %esi,%edi
  802475:	f7 f1                	div    %ecx
  802477:	89 fa                	mov    %edi,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	39 f2                	cmp    %esi,%edx
  80248a:	77 1c                	ja     8024a8 <__udivdi3+0x88>
  80248c:	0f bd fa             	bsr    %edx,%edi
  80248f:	83 f7 1f             	xor    $0x1f,%edi
  802492:	75 2c                	jne    8024c0 <__udivdi3+0xa0>
  802494:	39 f2                	cmp    %esi,%edx
  802496:	72 06                	jb     80249e <__udivdi3+0x7e>
  802498:	31 c0                	xor    %eax,%eax
  80249a:	39 eb                	cmp    %ebp,%ebx
  80249c:	77 a9                	ja     802447 <__udivdi3+0x27>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	eb a2                	jmp    802447 <__udivdi3+0x27>
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	31 ff                	xor    %edi,%edi
  8024aa:	31 c0                	xor    %eax,%eax
  8024ac:	89 fa                	mov    %edi,%edx
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	89 f9                	mov    %edi,%ecx
  8024c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024c7:	29 f8                	sub    %edi,%eax
  8024c9:	d3 e2                	shl    %cl,%edx
  8024cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024cf:	89 c1                	mov    %eax,%ecx
  8024d1:	89 da                	mov    %ebx,%edx
  8024d3:	d3 ea                	shr    %cl,%edx
  8024d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d9:	09 d1                	or     %edx,%ecx
  8024db:	89 f2                	mov    %esi,%edx
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 f9                	mov    %edi,%ecx
  8024e3:	d3 e3                	shl    %cl,%ebx
  8024e5:	89 c1                	mov    %eax,%ecx
  8024e7:	d3 ea                	shr    %cl,%edx
  8024e9:	89 f9                	mov    %edi,%ecx
  8024eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024ef:	89 eb                	mov    %ebp,%ebx
  8024f1:	d3 e6                	shl    %cl,%esi
  8024f3:	89 c1                	mov    %eax,%ecx
  8024f5:	d3 eb                	shr    %cl,%ebx
  8024f7:	09 de                	or     %ebx,%esi
  8024f9:	89 f0                	mov    %esi,%eax
  8024fb:	f7 74 24 08          	divl   0x8(%esp)
  8024ff:	89 d6                	mov    %edx,%esi
  802501:	89 c3                	mov    %eax,%ebx
  802503:	f7 64 24 0c          	mull   0xc(%esp)
  802507:	39 d6                	cmp    %edx,%esi
  802509:	72 15                	jb     802520 <__udivdi3+0x100>
  80250b:	89 f9                	mov    %edi,%ecx
  80250d:	d3 e5                	shl    %cl,%ebp
  80250f:	39 c5                	cmp    %eax,%ebp
  802511:	73 04                	jae    802517 <__udivdi3+0xf7>
  802513:	39 d6                	cmp    %edx,%esi
  802515:	74 09                	je     802520 <__udivdi3+0x100>
  802517:	89 d8                	mov    %ebx,%eax
  802519:	31 ff                	xor    %edi,%edi
  80251b:	e9 27 ff ff ff       	jmp    802447 <__udivdi3+0x27>
  802520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802523:	31 ff                	xor    %edi,%edi
  802525:	e9 1d ff ff ff       	jmp    802447 <__udivdi3+0x27>
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__umoddi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	53                   	push   %ebx
  802534:	83 ec 1c             	sub    $0x1c,%esp
  802537:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80253b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80253f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802547:	89 da                	mov    %ebx,%edx
  802549:	85 c0                	test   %eax,%eax
  80254b:	75 43                	jne    802590 <__umoddi3+0x60>
  80254d:	39 df                	cmp    %ebx,%edi
  80254f:	76 17                	jbe    802568 <__umoddi3+0x38>
  802551:	89 f0                	mov    %esi,%eax
  802553:	f7 f7                	div    %edi
  802555:	89 d0                	mov    %edx,%eax
  802557:	31 d2                	xor    %edx,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	89 fd                	mov    %edi,%ebp
  80256a:	85 ff                	test   %edi,%edi
  80256c:	75 0b                	jne    802579 <__umoddi3+0x49>
  80256e:	b8 01 00 00 00       	mov    $0x1,%eax
  802573:	31 d2                	xor    %edx,%edx
  802575:	f7 f7                	div    %edi
  802577:	89 c5                	mov    %eax,%ebp
  802579:	89 d8                	mov    %ebx,%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	f7 f5                	div    %ebp
  80257f:	89 f0                	mov    %esi,%eax
  802581:	f7 f5                	div    %ebp
  802583:	89 d0                	mov    %edx,%eax
  802585:	eb d0                	jmp    802557 <__umoddi3+0x27>
  802587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258e:	66 90                	xchg   %ax,%ax
  802590:	89 f1                	mov    %esi,%ecx
  802592:	39 d8                	cmp    %ebx,%eax
  802594:	76 0a                	jbe    8025a0 <__umoddi3+0x70>
  802596:	89 f0                	mov    %esi,%eax
  802598:	83 c4 1c             	add    $0x1c,%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5e                   	pop    %esi
  80259d:	5f                   	pop    %edi
  80259e:	5d                   	pop    %ebp
  80259f:	c3                   	ret    
  8025a0:	0f bd e8             	bsr    %eax,%ebp
  8025a3:	83 f5 1f             	xor    $0x1f,%ebp
  8025a6:	75 20                	jne    8025c8 <__umoddi3+0x98>
  8025a8:	39 d8                	cmp    %ebx,%eax
  8025aa:	0f 82 b0 00 00 00    	jb     802660 <__umoddi3+0x130>
  8025b0:	39 f7                	cmp    %esi,%edi
  8025b2:	0f 86 a8 00 00 00    	jbe    802660 <__umoddi3+0x130>
  8025b8:	89 c8                	mov    %ecx,%eax
  8025ba:	83 c4 1c             	add    $0x1c,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5e                   	pop    %esi
  8025bf:	5f                   	pop    %edi
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    
  8025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8025cf:	29 ea                	sub    %ebp,%edx
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d7:	89 d1                	mov    %edx,%ecx
  8025d9:	89 f8                	mov    %edi,%eax
  8025db:	d3 e8                	shr    %cl,%eax
  8025dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025e9:	09 c1                	or     %eax,%ecx
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025f1:	89 e9                	mov    %ebp,%ecx
  8025f3:	d3 e7                	shl    %cl,%edi
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	d3 e8                	shr    %cl,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ff:	d3 e3                	shl    %cl,%ebx
  802601:	89 c7                	mov    %eax,%edi
  802603:	89 d1                	mov    %edx,%ecx
  802605:	89 f0                	mov    %esi,%eax
  802607:	d3 e8                	shr    %cl,%eax
  802609:	89 e9                	mov    %ebp,%ecx
  80260b:	89 fa                	mov    %edi,%edx
  80260d:	d3 e6                	shl    %cl,%esi
  80260f:	09 d8                	or     %ebx,%eax
  802611:	f7 74 24 08          	divl   0x8(%esp)
  802615:	89 d1                	mov    %edx,%ecx
  802617:	89 f3                	mov    %esi,%ebx
  802619:	f7 64 24 0c          	mull   0xc(%esp)
  80261d:	89 c6                	mov    %eax,%esi
  80261f:	89 d7                	mov    %edx,%edi
  802621:	39 d1                	cmp    %edx,%ecx
  802623:	72 06                	jb     80262b <__umoddi3+0xfb>
  802625:	75 10                	jne    802637 <__umoddi3+0x107>
  802627:	39 c3                	cmp    %eax,%ebx
  802629:	73 0c                	jae    802637 <__umoddi3+0x107>
  80262b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80262f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802633:	89 d7                	mov    %edx,%edi
  802635:	89 c6                	mov    %eax,%esi
  802637:	89 ca                	mov    %ecx,%edx
  802639:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80263e:	29 f3                	sub    %esi,%ebx
  802640:	19 fa                	sbb    %edi,%edx
  802642:	89 d0                	mov    %edx,%eax
  802644:	d3 e0                	shl    %cl,%eax
  802646:	89 e9                	mov    %ebp,%ecx
  802648:	d3 eb                	shr    %cl,%ebx
  80264a:	d3 ea                	shr    %cl,%edx
  80264c:	09 d8                	or     %ebx,%eax
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	89 da                	mov    %ebx,%edx
  802662:	29 fe                	sub    %edi,%esi
  802664:	19 c2                	sbb    %eax,%edx
  802666:	89 f1                	mov    %esi,%ecx
  802668:	89 c8                	mov    %ecx,%eax
  80266a:	e9 4b ff ff ff       	jmp    8025ba <__umoddi3+0x8a>
