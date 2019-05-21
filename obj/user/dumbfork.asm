
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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
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
  800045:	e8 76 0e 00 00       	call   800ec0 <sys_page_alloc>
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
  80005f:	e8 9f 0e 00 00       	call   800f03 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 de 0b 00 00       	call   800c5c <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 b8 0e 00 00       	call   800f45 <sys_page_unmap>
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
  80009c:	68 60 13 80 00       	push   $0x801360
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 73 13 80 00       	push   $0x801373
  8000a8:	e8 cc 01 00 00       	call   800279 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 83 13 80 00       	push   $0x801383
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 73 13 80 00       	push   $0x801373
  8000ba:	e8 ba 01 00 00       	call   800279 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 94 13 80 00       	push   $0x801394
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 73 13 80 00       	push   $0x801373
  8000cc:	e8 a8 01 00 00       	call   800279 <_panic>

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
  8000f4:	81 fa 08 20 80 00    	cmp    $0x802008,%edx
  8000fa:	73 41                	jae    80013d <dumbfork+0x6c>
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
  800113:	68 a7 13 80 00       	push   $0x8013a7
  800118:	6a 37                	push   $0x37
  80011a:	68 73 13 80 00       	push   $0x801373
  80011f:	e8 55 01 00 00       	call   800279 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 59 0d 00 00       	call   800e82 <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	c1 e0 07             	shl    $0x7,%eax
  800131:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800136:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80013b:	eb 24                	jmp    800161 <dumbfork+0x90>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800143:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800148:	50                   	push   %eax
  800149:	53                   	push   %ebx
  80014a:	e8 e4 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80014f:	83 c4 08             	add    $0x8,%esp
  800152:	6a 02                	push   $0x2
  800154:	53                   	push   %ebx
  800155:	e8 2d 0e 00 00       	call   800f87 <sys_env_set_status>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	85 c0                	test   %eax,%eax
  80015f:	78 09                	js     80016a <dumbfork+0x99>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800161:	89 d8                	mov    %ebx,%eax
  800163:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016a:	50                   	push   %eax
  80016b:	68 b7 13 80 00       	push   $0x8013b7
  800170:	6a 4c                	push   $0x4c
  800172:	68 73 13 80 00       	push   $0x801373
  800177:	e8 fd 00 00 00       	call   800279 <_panic>

0080017c <umain>:
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	57                   	push   %edi
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800185:	e8 47 ff ff ff       	call   8000d1 <dumbfork>
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	85 c0                	test   %eax,%eax
  80018e:	be ce 13 80 00       	mov    $0x8013ce,%esi
  800193:	b8 d5 13 80 00       	mov    $0x8013d5,%eax
  800198:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a0:	eb 1f                	jmp    8001c1 <umain+0x45>
  8001a2:	83 fb 13             	cmp    $0x13,%ebx
  8001a5:	7f 23                	jg     8001ca <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	68 db 13 80 00       	push   $0x8013db
  8001b1:	e8 b9 01 00 00       	call   80036f <cprintf>
		sys_yield();
  8001b6:	e8 e6 0c 00 00       	call   800ea1 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bb:	83 c3 01             	add    $0x1,%ebx
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	85 ff                	test   %edi,%edi
  8001c3:	74 dd                	je     8001a2 <umain+0x26>
  8001c5:	83 fb 09             	cmp    $0x9,%ebx
  8001c8:	7e dd                	jle    8001a7 <umain+0x2b>
}
  8001ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cd:	5b                   	pop    %ebx
  8001ce:	5e                   	pop    %esi
  8001cf:	5f                   	pop    %edi
  8001d0:	5d                   	pop    %ebp
  8001d1:	c3                   	ret    

008001d2 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	57                   	push   %edi
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001db:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8001e2:	00 00 00 
	envid_t find = sys_getenvid();
  8001e5:	e8 98 0c 00 00       	call   800e82 <sys_getenvid>
  8001ea:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ff:	eb 0b                	jmp    80020c <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800201:	83 c2 01             	add    $0x1,%edx
  800204:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80020a:	74 21                	je     80022d <libmain+0x5b>
		if(envs[i].env_id == find)
  80020c:	89 d1                	mov    %edx,%ecx
  80020e:	c1 e1 07             	shl    $0x7,%ecx
  800211:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800217:	8b 49 48             	mov    0x48(%ecx),%ecx
  80021a:	39 c1                	cmp    %eax,%ecx
  80021c:	75 e3                	jne    800201 <libmain+0x2f>
  80021e:	89 d3                	mov    %edx,%ebx
  800220:	c1 e3 07             	shl    $0x7,%ebx
  800223:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800229:	89 fe                	mov    %edi,%esi
  80022b:	eb d4                	jmp    800201 <libmain+0x2f>
  80022d:	89 f0                	mov    %esi,%eax
  80022f:	84 c0                	test   %al,%al
  800231:	74 06                	je     800239 <libmain+0x67>
  800233:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023d:	7e 0a                	jle    800249 <libmain+0x77>
		binaryname = argv[0];
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	ff 75 0c             	pushl  0xc(%ebp)
  80024f:	ff 75 08             	pushl  0x8(%ebp)
  800252:	e8 25 ff ff ff       	call   80017c <umain>

	// exit gracefully
	exit();
  800257:	e8 0b 00 00 00       	call   800267 <exit>
}
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800262:	5b                   	pop    %ebx
  800263:	5e                   	pop    %esi
  800264:	5f                   	pop    %edi
  800265:	5d                   	pop    %ebp
  800266:	c3                   	ret    

00800267 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80026d:	6a 00                	push   $0x0
  80026f:	e8 cd 0b 00 00       	call   800e41 <sys_env_destroy>
}
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80027e:	a1 04 20 80 00       	mov    0x802004,%eax
  800283:	8b 40 48             	mov    0x48(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 28 14 80 00       	push   $0x801428
  80028e:	50                   	push   %eax
  80028f:	68 f7 13 80 00       	push   $0x8013f7
  800294:	e8 d6 00 00 00       	call   80036f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800299:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8002a2:	e8 db 0b 00 00       	call   800e82 <sys_getenvid>
  8002a7:	83 c4 04             	add    $0x4,%esp
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	56                   	push   %esi
  8002b1:	50                   	push   %eax
  8002b2:	68 04 14 80 00       	push   $0x801404
  8002b7:	e8 b3 00 00 00       	call   80036f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002bc:	83 c4 18             	add    $0x18,%esp
  8002bf:	53                   	push   %ebx
  8002c0:	ff 75 10             	pushl  0x10(%ebp)
  8002c3:	e8 56 00 00 00       	call   80031e <vcprintf>
	cprintf("\n");
  8002c8:	c7 04 24 eb 13 80 00 	movl   $0x8013eb,(%esp)
  8002cf:	e8 9b 00 00 00       	call   80036f <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d7:	cc                   	int3   
  8002d8:	eb fd                	jmp    8002d7 <_panic+0x5e>

008002da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e4:	8b 13                	mov    (%ebx),%edx
  8002e6:	8d 42 01             	lea    0x1(%edx),%eax
  8002e9:	89 03                	mov    %eax,(%ebx)
  8002eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f7:	74 09                	je     800302 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800300:	c9                   	leave  
  800301:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	68 ff 00 00 00       	push   $0xff
  80030a:	8d 43 08             	lea    0x8(%ebx),%eax
  80030d:	50                   	push   %eax
  80030e:	e8 f1 0a 00 00       	call   800e04 <sys_cputs>
		b->idx = 0;
  800313:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	eb db                	jmp    8002f9 <putch+0x1f>

0080031e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800327:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032e:	00 00 00 
	b.cnt = 0;
  800331:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800338:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 08             	pushl  0x8(%ebp)
  800341:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	68 da 02 80 00       	push   $0x8002da
  80034d:	e8 4a 01 00 00       	call   80049c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800352:	83 c4 08             	add    $0x8,%esp
  800355:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80035b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800361:	50                   	push   %eax
  800362:	e8 9d 0a 00 00       	call   800e04 <sys_cputs>

	return b.cnt;
}
  800367:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80036d:	c9                   	leave  
  80036e:	c3                   	ret    

0080036f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800375:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800378:	50                   	push   %eax
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 9d ff ff ff       	call   80031e <vcprintf>
	va_end(ap);

	return cnt;
}
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	57                   	push   %edi
  800387:	56                   	push   %esi
  800388:	53                   	push   %ebx
  800389:	83 ec 1c             	sub    $0x1c,%esp
  80038c:	89 c6                	mov    %eax,%esi
  80038e:	89 d7                	mov    %edx,%edi
  800390:	8b 45 08             	mov    0x8(%ebp),%eax
  800393:	8b 55 0c             	mov    0xc(%ebp),%edx
  800396:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800399:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80039c:	8b 45 10             	mov    0x10(%ebp),%eax
  80039f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003a2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003a6:	74 2c                	je     8003d4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003bd:	73 43                	jae    800402 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003bf:	83 eb 01             	sub    $0x1,%ebx
  8003c2:	85 db                	test   %ebx,%ebx
  8003c4:	7e 6c                	jle    800432 <printnum+0xaf>
				putch(padc, putdat);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	57                   	push   %edi
  8003ca:	ff 75 18             	pushl  0x18(%ebp)
  8003cd:	ff d6                	call   *%esi
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	eb eb                	jmp    8003bf <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	6a 20                	push   $0x20
  8003d9:	6a 00                	push   $0x0
  8003db:	50                   	push   %eax
  8003dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003df:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e2:	89 fa                	mov    %edi,%edx
  8003e4:	89 f0                	mov    %esi,%eax
  8003e6:	e8 98 ff ff ff       	call   800383 <printnum>
		while (--width > 0)
  8003eb:	83 c4 20             	add    $0x20,%esp
  8003ee:	83 eb 01             	sub    $0x1,%ebx
  8003f1:	85 db                	test   %ebx,%ebx
  8003f3:	7e 65                	jle    80045a <printnum+0xd7>
			putch(padc, putdat);
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	57                   	push   %edi
  8003f9:	6a 20                	push   $0x20
  8003fb:	ff d6                	call   *%esi
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	eb ec                	jmp    8003ee <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	83 ec 0c             	sub    $0xc,%esp
  800405:	ff 75 18             	pushl  0x18(%ebp)
  800408:	83 eb 01             	sub    $0x1,%ebx
  80040b:	53                   	push   %ebx
  80040c:	50                   	push   %eax
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	ff 75 dc             	pushl  -0x24(%ebp)
  800413:	ff 75 d8             	pushl  -0x28(%ebp)
  800416:	ff 75 e4             	pushl  -0x1c(%ebp)
  800419:	ff 75 e0             	pushl  -0x20(%ebp)
  80041c:	e8 df 0c 00 00       	call   801100 <__udivdi3>
  800421:	83 c4 18             	add    $0x18,%esp
  800424:	52                   	push   %edx
  800425:	50                   	push   %eax
  800426:	89 fa                	mov    %edi,%edx
  800428:	89 f0                	mov    %esi,%eax
  80042a:	e8 54 ff ff ff       	call   800383 <printnum>
  80042f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	57                   	push   %edi
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	ff 75 dc             	pushl  -0x24(%ebp)
  80043c:	ff 75 d8             	pushl  -0x28(%ebp)
  80043f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800442:	ff 75 e0             	pushl  -0x20(%ebp)
  800445:	e8 c6 0d 00 00       	call   801210 <__umoddi3>
  80044a:	83 c4 14             	add    $0x14,%esp
  80044d:	0f be 80 2f 14 80 00 	movsbl 0x80142f(%eax),%eax
  800454:	50                   	push   %eax
  800455:	ff d6                	call   *%esi
  800457:	83 c4 10             	add    $0x10,%esp
	}
}
  80045a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045d:	5b                   	pop    %ebx
  80045e:	5e                   	pop    %esi
  80045f:	5f                   	pop    %edi
  800460:	5d                   	pop    %ebp
  800461:	c3                   	ret    

00800462 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800468:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046c:	8b 10                	mov    (%eax),%edx
  80046e:	3b 50 04             	cmp    0x4(%eax),%edx
  800471:	73 0a                	jae    80047d <sprintputch+0x1b>
		*b->buf++ = ch;
  800473:	8d 4a 01             	lea    0x1(%edx),%ecx
  800476:	89 08                	mov    %ecx,(%eax)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	88 02                	mov    %al,(%edx)
}
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <printfmt>:
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800485:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800488:	50                   	push   %eax
  800489:	ff 75 10             	pushl  0x10(%ebp)
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	ff 75 08             	pushl  0x8(%ebp)
  800492:	e8 05 00 00 00       	call   80049c <vprintfmt>
}
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <vprintfmt>:
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 3c             	sub    $0x3c,%esp
  8004a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004ae:	e9 32 04 00 00       	jmp    8008e5 <vprintfmt+0x449>
		padc = ' ';
  8004b3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004b7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004be:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004c5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004df:	8d 47 01             	lea    0x1(%edi),%eax
  8004e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004e5:	0f b6 17             	movzbl (%edi),%edx
  8004e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004eb:	3c 55                	cmp    $0x55,%al
  8004ed:	0f 87 12 05 00 00    	ja     800a05 <vprintfmt+0x569>
  8004f3:	0f b6 c0             	movzbl %al,%eax
  8004f6:	ff 24 85 20 16 80 00 	jmp    *0x801620(,%eax,4)
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800500:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800504:	eb d9                	jmp    8004df <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800506:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800509:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80050d:	eb d0                	jmp    8004df <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80050f:	0f b6 d2             	movzbl %dl,%edx
  800512:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800515:	b8 00 00 00 00       	mov    $0x0,%eax
  80051a:	89 75 08             	mov    %esi,0x8(%ebp)
  80051d:	eb 03                	jmp    800522 <vprintfmt+0x86>
  80051f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800522:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800525:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800529:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80052c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80052f:	83 fe 09             	cmp    $0x9,%esi
  800532:	76 eb                	jbe    80051f <vprintfmt+0x83>
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800537:	8b 75 08             	mov    0x8(%ebp),%esi
  80053a:	eb 14                	jmp    800550 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 40 04             	lea    0x4(%eax),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800550:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800554:	79 89                	jns    8004df <vprintfmt+0x43>
				width = precision, precision = -1;
  800556:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800559:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800563:	e9 77 ff ff ff       	jmp    8004df <vprintfmt+0x43>
  800568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056b:	85 c0                	test   %eax,%eax
  80056d:	0f 48 c1             	cmovs  %ecx,%eax
  800570:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800576:	e9 64 ff ff ff       	jmp    8004df <vprintfmt+0x43>
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80057e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800585:	e9 55 ff ff ff       	jmp    8004df <vprintfmt+0x43>
			lflag++;
  80058a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80058e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800591:	e9 49 ff ff ff       	jmp    8004df <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 78 04             	lea    0x4(%eax),%edi
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	ff 30                	pushl  (%eax)
  8005a2:	ff d6                	call   *%esi
			break;
  8005a4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005a7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005aa:	e9 33 03 00 00       	jmp    8008e2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 78 04             	lea    0x4(%eax),%edi
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	99                   	cltd   
  8005b8:	31 d0                	xor    %edx,%eax
  8005ba:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005bc:	83 f8 0f             	cmp    $0xf,%eax
  8005bf:	7f 23                	jg     8005e4 <vprintfmt+0x148>
  8005c1:	8b 14 85 80 17 80 00 	mov    0x801780(,%eax,4),%edx
  8005c8:	85 d2                	test   %edx,%edx
  8005ca:	74 18                	je     8005e4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005cc:	52                   	push   %edx
  8005cd:	68 50 14 80 00       	push   $0x801450
  8005d2:	53                   	push   %ebx
  8005d3:	56                   	push   %esi
  8005d4:	e8 a6 fe ff ff       	call   80047f <printfmt>
  8005d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005dc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005df:	e9 fe 02 00 00       	jmp    8008e2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005e4:	50                   	push   %eax
  8005e5:	68 47 14 80 00       	push   $0x801447
  8005ea:	53                   	push   %ebx
  8005eb:	56                   	push   %esi
  8005ec:	e8 8e fe ff ff       	call   80047f <printfmt>
  8005f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005f7:	e9 e6 02 00 00       	jmp    8008e2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	83 c0 04             	add    $0x4,%eax
  800602:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80060a:	85 c9                	test   %ecx,%ecx
  80060c:	b8 40 14 80 00       	mov    $0x801440,%eax
  800611:	0f 45 c1             	cmovne %ecx,%eax
  800614:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800617:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80061b:	7e 06                	jle    800623 <vprintfmt+0x187>
  80061d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800621:	75 0d                	jne    800630 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800623:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800626:	89 c7                	mov    %eax,%edi
  800628:	03 45 e0             	add    -0x20(%ebp),%eax
  80062b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80062e:	eb 53                	jmp    800683 <vprintfmt+0x1e7>
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	ff 75 d8             	pushl  -0x28(%ebp)
  800636:	50                   	push   %eax
  800637:	e8 71 04 00 00       	call   800aad <strnlen>
  80063c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80063f:	29 c1                	sub    %eax,%ecx
  800641:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800649:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80064d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800650:	eb 0f                	jmp    800661 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	ff 75 e0             	pushl  -0x20(%ebp)
  800659:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80065b:	83 ef 01             	sub    $0x1,%edi
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	85 ff                	test   %edi,%edi
  800663:	7f ed                	jg     800652 <vprintfmt+0x1b6>
  800665:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	0f 49 c1             	cmovns %ecx,%eax
  800672:	29 c1                	sub    %eax,%ecx
  800674:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800677:	eb aa                	jmp    800623 <vprintfmt+0x187>
					putch(ch, putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	53                   	push   %ebx
  80067d:	52                   	push   %edx
  80067e:	ff d6                	call   *%esi
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800686:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800688:	83 c7 01             	add    $0x1,%edi
  80068b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80068f:	0f be d0             	movsbl %al,%edx
  800692:	85 d2                	test   %edx,%edx
  800694:	74 4b                	je     8006e1 <vprintfmt+0x245>
  800696:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80069a:	78 06                	js     8006a2 <vprintfmt+0x206>
  80069c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006a0:	78 1e                	js     8006c0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006a6:	74 d1                	je     800679 <vprintfmt+0x1dd>
  8006a8:	0f be c0             	movsbl %al,%eax
  8006ab:	83 e8 20             	sub    $0x20,%eax
  8006ae:	83 f8 5e             	cmp    $0x5e,%eax
  8006b1:	76 c6                	jbe    800679 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 3f                	push   $0x3f
  8006b9:	ff d6                	call   *%esi
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	eb c3                	jmp    800683 <vprintfmt+0x1e7>
  8006c0:	89 cf                	mov    %ecx,%edi
  8006c2:	eb 0e                	jmp    8006d2 <vprintfmt+0x236>
				putch(' ', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 20                	push   $0x20
  8006ca:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006cc:	83 ef 01             	sub    $0x1,%edi
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	85 ff                	test   %edi,%edi
  8006d4:	7f ee                	jg     8006c4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006d6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006dc:	e9 01 02 00 00       	jmp    8008e2 <vprintfmt+0x446>
  8006e1:	89 cf                	mov    %ecx,%edi
  8006e3:	eb ed                	jmp    8006d2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006e8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006ef:	e9 eb fd ff ff       	jmp    8004df <vprintfmt+0x43>
	if (lflag >= 2)
  8006f4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f8:	7f 21                	jg     80071b <vprintfmt+0x27f>
	else if (lflag)
  8006fa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006fe:	74 68                	je     800768 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800708:	89 c1                	mov    %eax,%ecx
  80070a:	c1 f9 1f             	sar    $0x1f,%ecx
  80070d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8d 40 04             	lea    0x4(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
  800719:	eb 17                	jmp    800732 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800726:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 40 08             	lea    0x8(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800732:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800735:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80073e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800742:	78 3f                	js     800783 <vprintfmt+0x2e7>
			base = 10;
  800744:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800749:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80074d:	0f 84 71 01 00 00    	je     8008c4 <vprintfmt+0x428>
				putch('+', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	6a 2b                	push   $0x2b
  800759:	ff d6                	call   *%esi
  80075b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80075e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800763:	e9 5c 01 00 00       	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800770:	89 c1                	mov    %eax,%ecx
  800772:	c1 f9 1f             	sar    $0x1f,%ecx
  800775:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8d 40 04             	lea    0x4(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
  800781:	eb af                	jmp    800732 <vprintfmt+0x296>
				putch('-', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 2d                	push   $0x2d
  800789:	ff d6                	call   *%esi
				num = -(long long) num;
  80078b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80078e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800791:	f7 d8                	neg    %eax
  800793:	83 d2 00             	adc    $0x0,%edx
  800796:	f7 da                	neg    %edx
  800798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a6:	e9 19 01 00 00       	jmp    8008c4 <vprintfmt+0x428>
	if (lflag >= 2)
  8007ab:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007af:	7f 29                	jg     8007da <vprintfmt+0x33e>
	else if (lflag)
  8007b1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b5:	74 44                	je     8007fb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 04             	lea    0x4(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d5:	e9 ea 00 00 00       	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 08             	lea    0x8(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f6:	e9 c9 00 00 00       	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	ba 00 00 00 00       	mov    $0x0,%edx
  800805:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800808:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 40 04             	lea    0x4(%eax),%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800814:	b8 0a 00 00 00       	mov    $0xa,%eax
  800819:	e9 a6 00 00 00       	jmp    8008c4 <vprintfmt+0x428>
			putch('0', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	6a 30                	push   $0x30
  800824:	ff d6                	call   *%esi
	if (lflag >= 2)
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80082d:	7f 26                	jg     800855 <vprintfmt+0x3b9>
	else if (lflag)
  80082f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800833:	74 3e                	je     800873 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	ba 00 00 00 00       	mov    $0x0,%edx
  80083f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800842:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084e:	b8 08 00 00 00       	mov    $0x8,%eax
  800853:	eb 6f                	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	8b 50 04             	mov    0x4(%eax),%edx
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800860:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8d 40 08             	lea    0x8(%eax),%eax
  800869:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086c:	b8 08 00 00 00       	mov    $0x8,%eax
  800871:	eb 51                	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	ba 00 00 00 00       	mov    $0x0,%edx
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 04             	lea    0x4(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80088c:	b8 08 00 00 00       	mov    $0x8,%eax
  800891:	eb 31                	jmp    8008c4 <vprintfmt+0x428>
			putch('0', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	6a 30                	push   $0x30
  800899:	ff d6                	call   *%esi
			putch('x', putdat);
  80089b:	83 c4 08             	add    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	6a 78                	push   $0x78
  8008a1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008b3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	8d 40 04             	lea    0x4(%eax),%eax
  8008bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bf:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c4:	83 ec 0c             	sub    $0xc,%esp
  8008c7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008cb:	52                   	push   %edx
  8008cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8008d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8008d6:	89 da                	mov    %ebx,%edx
  8008d8:	89 f0                	mov    %esi,%eax
  8008da:	e8 a4 fa ff ff       	call   800383 <printnum>
			break;
  8008df:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e5:	83 c7 01             	add    $0x1,%edi
  8008e8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ec:	83 f8 25             	cmp    $0x25,%eax
  8008ef:	0f 84 be fb ff ff    	je     8004b3 <vprintfmt+0x17>
			if (ch == '\0')
  8008f5:	85 c0                	test   %eax,%eax
  8008f7:	0f 84 28 01 00 00    	je     800a25 <vprintfmt+0x589>
			putch(ch, putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	53                   	push   %ebx
  800901:	50                   	push   %eax
  800902:	ff d6                	call   *%esi
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	eb dc                	jmp    8008e5 <vprintfmt+0x449>
	if (lflag >= 2)
  800909:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80090d:	7f 26                	jg     800935 <vprintfmt+0x499>
	else if (lflag)
  80090f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800913:	74 41                	je     800956 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
  80091f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800922:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8d 40 04             	lea    0x4(%eax),%eax
  80092b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092e:	b8 10 00 00 00       	mov    $0x10,%eax
  800933:	eb 8f                	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 50 04             	mov    0x4(%eax),%edx
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800940:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8d 40 08             	lea    0x8(%eax),%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094c:	b8 10 00 00 00       	mov    $0x10,%eax
  800951:	e9 6e ff ff ff       	jmp    8008c4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800963:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	8d 40 04             	lea    0x4(%eax),%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096f:	b8 10 00 00 00       	mov    $0x10,%eax
  800974:	e9 4b ff ff ff       	jmp    8008c4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	83 c0 04             	add    $0x4,%eax
  80097f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	85 c0                	test   %eax,%eax
  800989:	74 14                	je     80099f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80098b:	8b 13                	mov    (%ebx),%edx
  80098d:	83 fa 7f             	cmp    $0x7f,%edx
  800990:	7f 37                	jg     8009c9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800992:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800994:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800997:	89 45 14             	mov    %eax,0x14(%ebp)
  80099a:	e9 43 ff ff ff       	jmp    8008e2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80099f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a4:	bf 69 15 80 00       	mov    $0x801569,%edi
							putch(ch, putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	53                   	push   %ebx
  8009ad:	50                   	push   %eax
  8009ae:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009b0:	83 c7 01             	add    $0x1,%edi
  8009b3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	75 eb                	jne    8009a9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	e9 19 ff ff ff       	jmp    8008e2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009c9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d0:	bf a1 15 80 00       	mov    $0x8015a1,%edi
							putch(ch, putdat);
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	53                   	push   %ebx
  8009d9:	50                   	push   %eax
  8009da:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009dc:	83 c7 01             	add    $0x1,%edi
  8009df:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	85 c0                	test   %eax,%eax
  8009e8:	75 eb                	jne    8009d5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f0:	e9 ed fe ff ff       	jmp    8008e2 <vprintfmt+0x446>
			putch(ch, putdat);
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	53                   	push   %ebx
  8009f9:	6a 25                	push   $0x25
  8009fb:	ff d6                	call   *%esi
			break;
  8009fd:	83 c4 10             	add    $0x10,%esp
  800a00:	e9 dd fe ff ff       	jmp    8008e2 <vprintfmt+0x446>
			putch('%', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	53                   	push   %ebx
  800a09:	6a 25                	push   $0x25
  800a0b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a0d:	83 c4 10             	add    $0x10,%esp
  800a10:	89 f8                	mov    %edi,%eax
  800a12:	eb 03                	jmp    800a17 <vprintfmt+0x57b>
  800a14:	83 e8 01             	sub    $0x1,%eax
  800a17:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a1b:	75 f7                	jne    800a14 <vprintfmt+0x578>
  800a1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a20:	e9 bd fe ff ff       	jmp    8008e2 <vprintfmt+0x446>
}
  800a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5f                   	pop    %edi
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 18             	sub    $0x18,%esp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a3c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a40:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	74 26                	je     800a74 <vsnprintf+0x47>
  800a4e:	85 d2                	test   %edx,%edx
  800a50:	7e 22                	jle    800a74 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a52:	ff 75 14             	pushl  0x14(%ebp)
  800a55:	ff 75 10             	pushl  0x10(%ebp)
  800a58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	68 62 04 80 00       	push   $0x800462
  800a61:	e8 36 fa ff ff       	call   80049c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    
		return -E_INVAL;
  800a74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a79:	eb f7                	jmp    800a72 <vsnprintf+0x45>

00800a7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a81:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a84:	50                   	push   %eax
  800a85:	ff 75 10             	pushl  0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 9a ff ff ff       	call   800a2d <vsnprintf>
	va_end(ap);

	return rc;
}
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa4:	74 05                	je     800aab <strlen+0x16>
		n++;
  800aa6:	83 c0 01             	add    $0x1,%eax
  800aa9:	eb f5                	jmp    800aa0 <strlen+0xb>
	return n;
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  800abb:	39 c2                	cmp    %eax,%edx
  800abd:	74 0d                	je     800acc <strnlen+0x1f>
  800abf:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ac3:	74 05                	je     800aca <strnlen+0x1d>
		n++;
  800ac5:	83 c2 01             	add    $0x1,%edx
  800ac8:	eb f1                	jmp    800abb <strnlen+0xe>
  800aca:	89 d0                	mov    %edx,%eax
	return n;
}
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  800add:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ae1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ae4:	83 c2 01             	add    $0x1,%edx
  800ae7:	84 c9                	test   %cl,%cl
  800ae9:	75 f2                	jne    800add <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aeb:	5b                   	pop    %ebx
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	53                   	push   %ebx
  800af2:	83 ec 10             	sub    $0x10,%esp
  800af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800af8:	53                   	push   %ebx
  800af9:	e8 97 ff ff ff       	call   800a95 <strlen>
  800afe:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	01 d8                	add    %ebx,%eax
  800b06:	50                   	push   %eax
  800b07:	e8 c2 ff ff ff       	call   800ace <strcpy>
	return dst;
}
  800b0c:	89 d8                	mov    %ebx,%eax
  800b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1e:	89 c6                	mov    %eax,%esi
  800b20:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b23:	89 c2                	mov    %eax,%edx
  800b25:	39 f2                	cmp    %esi,%edx
  800b27:	74 11                	je     800b3a <strncpy+0x27>
		*dst++ = *src;
  800b29:	83 c2 01             	add    $0x1,%edx
  800b2c:	0f b6 19             	movzbl (%ecx),%ebx
  800b2f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b32:	80 fb 01             	cmp    $0x1,%bl
  800b35:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b38:	eb eb                	jmp    800b25 <strncpy+0x12>
	}
	return ret;
}
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	8b 75 08             	mov    0x8(%ebp),%esi
  800b46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b49:	8b 55 10             	mov    0x10(%ebp),%edx
  800b4c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b4e:	85 d2                	test   %edx,%edx
  800b50:	74 21                	je     800b73 <strlcpy+0x35>
  800b52:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b56:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	74 14                	je     800b70 <strlcpy+0x32>
  800b5c:	0f b6 19             	movzbl (%ecx),%ebx
  800b5f:	84 db                	test   %bl,%bl
  800b61:	74 0b                	je     800b6e <strlcpy+0x30>
			*dst++ = *src++;
  800b63:	83 c1 01             	add    $0x1,%ecx
  800b66:	83 c2 01             	add    $0x1,%edx
  800b69:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b6c:	eb ea                	jmp    800b58 <strlcpy+0x1a>
  800b6e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b70:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b73:	29 f0                	sub    %esi,%eax
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b82:	0f b6 01             	movzbl (%ecx),%eax
  800b85:	84 c0                	test   %al,%al
  800b87:	74 0c                	je     800b95 <strcmp+0x1c>
  800b89:	3a 02                	cmp    (%edx),%al
  800b8b:	75 08                	jne    800b95 <strcmp+0x1c>
		p++, q++;
  800b8d:	83 c1 01             	add    $0x1,%ecx
  800b90:	83 c2 01             	add    $0x1,%edx
  800b93:	eb ed                	jmp    800b82 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b95:	0f b6 c0             	movzbl %al,%eax
  800b98:	0f b6 12             	movzbl (%edx),%edx
  800b9b:	29 d0                	sub    %edx,%eax
}
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	53                   	push   %ebx
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba9:	89 c3                	mov    %eax,%ebx
  800bab:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bae:	eb 06                	jmp    800bb6 <strncmp+0x17>
		n--, p++, q++;
  800bb0:	83 c0 01             	add    $0x1,%eax
  800bb3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bb6:	39 d8                	cmp    %ebx,%eax
  800bb8:	74 16                	je     800bd0 <strncmp+0x31>
  800bba:	0f b6 08             	movzbl (%eax),%ecx
  800bbd:	84 c9                	test   %cl,%cl
  800bbf:	74 04                	je     800bc5 <strncmp+0x26>
  800bc1:	3a 0a                	cmp    (%edx),%cl
  800bc3:	74 eb                	je     800bb0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc5:	0f b6 00             	movzbl (%eax),%eax
  800bc8:	0f b6 12             	movzbl (%edx),%edx
  800bcb:	29 d0                	sub    %edx,%eax
}
  800bcd:	5b                   	pop    %ebx
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    
		return 0;
  800bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd5:	eb f6                	jmp    800bcd <strncmp+0x2e>

00800bd7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be1:	0f b6 10             	movzbl (%eax),%edx
  800be4:	84 d2                	test   %dl,%dl
  800be6:	74 09                	je     800bf1 <strchr+0x1a>
		if (*s == c)
  800be8:	38 ca                	cmp    %cl,%dl
  800bea:	74 0a                	je     800bf6 <strchr+0x1f>
	for (; *s; s++)
  800bec:	83 c0 01             	add    $0x1,%eax
  800bef:	eb f0                	jmp    800be1 <strchr+0xa>
			return (char *) s;
	return 0;
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c02:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c05:	38 ca                	cmp    %cl,%dl
  800c07:	74 09                	je     800c12 <strfind+0x1a>
  800c09:	84 d2                	test   %dl,%dl
  800c0b:	74 05                	je     800c12 <strfind+0x1a>
	for (; *s; s++)
  800c0d:	83 c0 01             	add    $0x1,%eax
  800c10:	eb f0                	jmp    800c02 <strfind+0xa>
			break;
	return (char *) s;
}
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
  800c1a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c20:	85 c9                	test   %ecx,%ecx
  800c22:	74 31                	je     800c55 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c24:	89 f8                	mov    %edi,%eax
  800c26:	09 c8                	or     %ecx,%eax
  800c28:	a8 03                	test   $0x3,%al
  800c2a:	75 23                	jne    800c4f <memset+0x3b>
		c &= 0xFF;
  800c2c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c30:	89 d3                	mov    %edx,%ebx
  800c32:	c1 e3 08             	shl    $0x8,%ebx
  800c35:	89 d0                	mov    %edx,%eax
  800c37:	c1 e0 18             	shl    $0x18,%eax
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	c1 e6 10             	shl    $0x10,%esi
  800c3f:	09 f0                	or     %esi,%eax
  800c41:	09 c2                	or     %eax,%edx
  800c43:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c45:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c48:	89 d0                	mov    %edx,%eax
  800c4a:	fc                   	cld    
  800c4b:	f3 ab                	rep stos %eax,%es:(%edi)
  800c4d:	eb 06                	jmp    800c55 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	fc                   	cld    
  800c53:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c55:	89 f8                	mov    %edi,%eax
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c67:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c6a:	39 c6                	cmp    %eax,%esi
  800c6c:	73 32                	jae    800ca0 <memmove+0x44>
  800c6e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c71:	39 c2                	cmp    %eax,%edx
  800c73:	76 2b                	jbe    800ca0 <memmove+0x44>
		s += n;
		d += n;
  800c75:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c78:	89 fe                	mov    %edi,%esi
  800c7a:	09 ce                	or     %ecx,%esi
  800c7c:	09 d6                	or     %edx,%esi
  800c7e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c84:	75 0e                	jne    800c94 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c86:	83 ef 04             	sub    $0x4,%edi
  800c89:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c8c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c8f:	fd                   	std    
  800c90:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c92:	eb 09                	jmp    800c9d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c94:	83 ef 01             	sub    $0x1,%edi
  800c97:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c9a:	fd                   	std    
  800c9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c9d:	fc                   	cld    
  800c9e:	eb 1a                	jmp    800cba <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca0:	89 c2                	mov    %eax,%edx
  800ca2:	09 ca                	or     %ecx,%edx
  800ca4:	09 f2                	or     %esi,%edx
  800ca6:	f6 c2 03             	test   $0x3,%dl
  800ca9:	75 0a                	jne    800cb5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cab:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cae:	89 c7                	mov    %eax,%edi
  800cb0:	fc                   	cld    
  800cb1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb3:	eb 05                	jmp    800cba <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cb5:	89 c7                	mov    %eax,%edi
  800cb7:	fc                   	cld    
  800cb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc4:	ff 75 10             	pushl  0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 8a ff ff ff       	call   800c5c <memmove>
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdf:	89 c6                	mov    %eax,%esi
  800ce1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce4:	39 f0                	cmp    %esi,%eax
  800ce6:	74 1c                	je     800d04 <memcmp+0x30>
		if (*s1 != *s2)
  800ce8:	0f b6 08             	movzbl (%eax),%ecx
  800ceb:	0f b6 1a             	movzbl (%edx),%ebx
  800cee:	38 d9                	cmp    %bl,%cl
  800cf0:	75 08                	jne    800cfa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cf2:	83 c0 01             	add    $0x1,%eax
  800cf5:	83 c2 01             	add    $0x1,%edx
  800cf8:	eb ea                	jmp    800ce4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cfa:	0f b6 c1             	movzbl %cl,%eax
  800cfd:	0f b6 db             	movzbl %bl,%ebx
  800d00:	29 d8                	sub    %ebx,%eax
  800d02:	eb 05                	jmp    800d09 <memcmp+0x35>
	}

	return 0;
  800d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d16:	89 c2                	mov    %eax,%edx
  800d18:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d1b:	39 d0                	cmp    %edx,%eax
  800d1d:	73 09                	jae    800d28 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d1f:	38 08                	cmp    %cl,(%eax)
  800d21:	74 05                	je     800d28 <memfind+0x1b>
	for (; s < ends; s++)
  800d23:	83 c0 01             	add    $0x1,%eax
  800d26:	eb f3                	jmp    800d1b <memfind+0xe>
			break;
	return (void *) s;
}
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d36:	eb 03                	jmp    800d3b <strtol+0x11>
		s++;
  800d38:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d3b:	0f b6 01             	movzbl (%ecx),%eax
  800d3e:	3c 20                	cmp    $0x20,%al
  800d40:	74 f6                	je     800d38 <strtol+0xe>
  800d42:	3c 09                	cmp    $0x9,%al
  800d44:	74 f2                	je     800d38 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d46:	3c 2b                	cmp    $0x2b,%al
  800d48:	74 2a                	je     800d74 <strtol+0x4a>
	int neg = 0;
  800d4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d4f:	3c 2d                	cmp    $0x2d,%al
  800d51:	74 2b                	je     800d7e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d53:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d59:	75 0f                	jne    800d6a <strtol+0x40>
  800d5b:	80 39 30             	cmpb   $0x30,(%ecx)
  800d5e:	74 28                	je     800d88 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d60:	85 db                	test   %ebx,%ebx
  800d62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d67:	0f 44 d8             	cmove  %eax,%ebx
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d72:	eb 50                	jmp    800dc4 <strtol+0x9a>
		s++;
  800d74:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d77:	bf 00 00 00 00       	mov    $0x0,%edi
  800d7c:	eb d5                	jmp    800d53 <strtol+0x29>
		s++, neg = 1;
  800d7e:	83 c1 01             	add    $0x1,%ecx
  800d81:	bf 01 00 00 00       	mov    $0x1,%edi
  800d86:	eb cb                	jmp    800d53 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d88:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d8c:	74 0e                	je     800d9c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	75 d8                	jne    800d6a <strtol+0x40>
		s++, base = 8;
  800d92:	83 c1 01             	add    $0x1,%ecx
  800d95:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d9a:	eb ce                	jmp    800d6a <strtol+0x40>
		s += 2, base = 16;
  800d9c:	83 c1 02             	add    $0x2,%ecx
  800d9f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800da4:	eb c4                	jmp    800d6a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800da6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800da9:	89 f3                	mov    %esi,%ebx
  800dab:	80 fb 19             	cmp    $0x19,%bl
  800dae:	77 29                	ja     800dd9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800db0:	0f be d2             	movsbl %dl,%edx
  800db3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800db6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800db9:	7d 30                	jge    800deb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dbb:	83 c1 01             	add    $0x1,%ecx
  800dbe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dc4:	0f b6 11             	movzbl (%ecx),%edx
  800dc7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dca:	89 f3                	mov    %esi,%ebx
  800dcc:	80 fb 09             	cmp    $0x9,%bl
  800dcf:	77 d5                	ja     800da6 <strtol+0x7c>
			dig = *s - '0';
  800dd1:	0f be d2             	movsbl %dl,%edx
  800dd4:	83 ea 30             	sub    $0x30,%edx
  800dd7:	eb dd                	jmp    800db6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dd9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ddc:	89 f3                	mov    %esi,%ebx
  800dde:	80 fb 19             	cmp    $0x19,%bl
  800de1:	77 08                	ja     800deb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800de3:	0f be d2             	movsbl %dl,%edx
  800de6:	83 ea 37             	sub    $0x37,%edx
  800de9:	eb cb                	jmp    800db6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800deb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800def:	74 05                	je     800df6 <strtol+0xcc>
		*endptr = (char *) s;
  800df1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800df6:	89 c2                	mov    %eax,%edx
  800df8:	f7 da                	neg    %edx
  800dfa:	85 ff                	test   %edi,%edi
  800dfc:	0f 45 c2             	cmovne %edx,%eax
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e15:	89 c3                	mov    %eax,%ebx
  800e17:	89 c7                	mov    %eax,%edi
  800e19:	89 c6                	mov    %eax,%esi
  800e1b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e28:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2d:	b8 01 00 00 00       	mov    $0x1,%eax
  800e32:	89 d1                	mov    %edx,%ecx
  800e34:	89 d3                	mov    %edx,%ebx
  800e36:	89 d7                	mov    %edx,%edi
  800e38:	89 d6                	mov    %edx,%esi
  800e3a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	b8 03 00 00 00       	mov    $0x3,%eax
  800e57:	89 cb                	mov    %ecx,%ebx
  800e59:	89 cf                	mov    %ecx,%edi
  800e5b:	89 ce                	mov    %ecx,%esi
  800e5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 03                	push   $0x3
  800e71:	68 c0 17 80 00       	push   $0x8017c0
  800e76:	6a 43                	push   $0x43
  800e78:	68 dd 17 80 00       	push   $0x8017dd
  800e7d:	e8 f7 f3 ff ff       	call   800279 <_panic>

00800e82 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e88:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8d:	b8 02 00 00 00       	mov    $0x2,%eax
  800e92:	89 d1                	mov    %edx,%ecx
  800e94:	89 d3                	mov    %edx,%ebx
  800e96:	89 d7                	mov    %edx,%edi
  800e98:	89 d6                	mov    %edx,%esi
  800e9a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_yield>:

void
sys_yield(void)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  800eac:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb1:	89 d1                	mov    %edx,%ecx
  800eb3:	89 d3                	mov    %edx,%ebx
  800eb5:	89 d7                	mov    %edx,%edi
  800eb7:	89 d6                	mov    %edx,%esi
  800eb9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec9:	be 00 00 00 00       	mov    $0x0,%esi
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edc:	89 f7                	mov    %esi,%edi
  800ede:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	7f 08                	jg     800eec <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	50                   	push   %eax
  800ef0:	6a 04                	push   $0x4
  800ef2:	68 c0 17 80 00       	push   $0x8017c0
  800ef7:	6a 43                	push   $0x43
  800ef9:	68 dd 17 80 00       	push   $0x8017dd
  800efe:	e8 76 f3 ff ff       	call   800279 <_panic>

00800f03 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	b8 05 00 00 00       	mov    $0x5,%eax
  800f17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1d:	8b 75 18             	mov    0x18(%ebp),%esi
  800f20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7f 08                	jg     800f2e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	50                   	push   %eax
  800f32:	6a 05                	push   $0x5
  800f34:	68 c0 17 80 00       	push   $0x8017c0
  800f39:	6a 43                	push   $0x43
  800f3b:	68 dd 17 80 00       	push   $0x8017dd
  800f40:	e8 34 f3 ff ff       	call   800279 <_panic>

00800f45 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f53:	8b 55 08             	mov    0x8(%ebp),%edx
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	b8 06 00 00 00       	mov    $0x6,%eax
  800f5e:	89 df                	mov    %ebx,%edi
  800f60:	89 de                	mov    %ebx,%esi
  800f62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7f 08                	jg     800f70 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	50                   	push   %eax
  800f74:	6a 06                	push   $0x6
  800f76:	68 c0 17 80 00       	push   $0x8017c0
  800f7b:	6a 43                	push   $0x43
  800f7d:	68 dd 17 80 00       	push   $0x8017dd
  800f82:	e8 f2 f2 ff ff       	call   800279 <_panic>

00800f87 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800fa0:	89 df                	mov    %ebx,%edi
  800fa2:	89 de                	mov    %ebx,%esi
  800fa4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	7f 08                	jg     800fb2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	50                   	push   %eax
  800fb6:	6a 08                	push   $0x8
  800fb8:	68 c0 17 80 00       	push   $0x8017c0
  800fbd:	6a 43                	push   $0x43
  800fbf:	68 dd 17 80 00       	push   $0x8017dd
  800fc4:	e8 b0 f2 ff ff       	call   800279 <_panic>

00800fc9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
  800fcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	b8 09 00 00 00       	mov    $0x9,%eax
  800fe2:	89 df                	mov    %ebx,%edi
  800fe4:	89 de                	mov    %ebx,%esi
  800fe6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	7f 08                	jg     800ff4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fef:	5b                   	pop    %ebx
  800ff0:	5e                   	pop    %esi
  800ff1:	5f                   	pop    %edi
  800ff2:	5d                   	pop    %ebp
  800ff3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	50                   	push   %eax
  800ff8:	6a 09                	push   $0x9
  800ffa:	68 c0 17 80 00       	push   $0x8017c0
  800fff:	6a 43                	push   $0x43
  801001:	68 dd 17 80 00       	push   $0x8017dd
  801006:	e8 6e f2 ff ff       	call   800279 <_panic>

0080100b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
  801011:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801024:	89 df                	mov    %ebx,%edi
  801026:	89 de                	mov    %ebx,%esi
  801028:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102a:	85 c0                	test   %eax,%eax
  80102c:	7f 08                	jg     801036 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80102e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801036:	83 ec 0c             	sub    $0xc,%esp
  801039:	50                   	push   %eax
  80103a:	6a 0a                	push   $0xa
  80103c:	68 c0 17 80 00       	push   $0x8017c0
  801041:	6a 43                	push   $0x43
  801043:	68 dd 17 80 00       	push   $0x8017dd
  801048:	e8 2c f2 ff ff       	call   800279 <_panic>

0080104d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
	asm volatile("int %1\n"
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801059:	b8 0c 00 00 00       	mov    $0xc,%eax
  80105e:	be 00 00 00 00       	mov    $0x0,%esi
  801063:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801066:	8b 7d 14             	mov    0x14(%ebp),%edi
  801069:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
  801076:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801079:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	b8 0d 00 00 00       	mov    $0xd,%eax
  801086:	89 cb                	mov    %ecx,%ebx
  801088:	89 cf                	mov    %ecx,%edi
  80108a:	89 ce                	mov    %ecx,%esi
  80108c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108e:	85 c0                	test   %eax,%eax
  801090:	7f 08                	jg     80109a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801092:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	50                   	push   %eax
  80109e:	6a 0d                	push   $0xd
  8010a0:	68 c0 17 80 00       	push   $0x8017c0
  8010a5:	6a 43                	push   $0x43
  8010a7:	68 dd 17 80 00       	push   $0x8017dd
  8010ac:	e8 c8 f1 ff ff       	call   800279 <_panic>

008010b1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	57                   	push   %edi
  8010b5:	56                   	push   %esi
  8010b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010c7:	89 df                	mov    %ebx,%edi
  8010c9:	89 de                	mov    %ebx,%esi
  8010cb:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e0:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010e5:	89 cb                	mov    %ecx,%ebx
  8010e7:	89 cf                	mov    %ecx,%edi
  8010e9:	89 ce                	mov    %ecx,%esi
  8010eb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010ed:	5b                   	pop    %ebx
  8010ee:	5e                   	pop    %esi
  8010ef:	5f                   	pop    %edi
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    
  8010f2:	66 90                	xchg   %ax,%ax
  8010f4:	66 90                	xchg   %ax,%ax
  8010f6:	66 90                	xchg   %ax,%ax
  8010f8:	66 90                	xchg   %ax,%ax
  8010fa:	66 90                	xchg   %ax,%ax
  8010fc:	66 90                	xchg   %ax,%ax
  8010fe:	66 90                	xchg   %ax,%ax

00801100 <__udivdi3>:
  801100:	55                   	push   %ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 1c             	sub    $0x1c,%esp
  801107:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80110b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80110f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801113:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801117:	85 d2                	test   %edx,%edx
  801119:	75 4d                	jne    801168 <__udivdi3+0x68>
  80111b:	39 f3                	cmp    %esi,%ebx
  80111d:	76 19                	jbe    801138 <__udivdi3+0x38>
  80111f:	31 ff                	xor    %edi,%edi
  801121:	89 e8                	mov    %ebp,%eax
  801123:	89 f2                	mov    %esi,%edx
  801125:	f7 f3                	div    %ebx
  801127:	89 fa                	mov    %edi,%edx
  801129:	83 c4 1c             	add    $0x1c,%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
  801131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801138:	89 d9                	mov    %ebx,%ecx
  80113a:	85 db                	test   %ebx,%ebx
  80113c:	75 0b                	jne    801149 <__udivdi3+0x49>
  80113e:	b8 01 00 00 00       	mov    $0x1,%eax
  801143:	31 d2                	xor    %edx,%edx
  801145:	f7 f3                	div    %ebx
  801147:	89 c1                	mov    %eax,%ecx
  801149:	31 d2                	xor    %edx,%edx
  80114b:	89 f0                	mov    %esi,%eax
  80114d:	f7 f1                	div    %ecx
  80114f:	89 c6                	mov    %eax,%esi
  801151:	89 e8                	mov    %ebp,%eax
  801153:	89 f7                	mov    %esi,%edi
  801155:	f7 f1                	div    %ecx
  801157:	89 fa                	mov    %edi,%edx
  801159:	83 c4 1c             	add    $0x1c,%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    
  801161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801168:	39 f2                	cmp    %esi,%edx
  80116a:	77 1c                	ja     801188 <__udivdi3+0x88>
  80116c:	0f bd fa             	bsr    %edx,%edi
  80116f:	83 f7 1f             	xor    $0x1f,%edi
  801172:	75 2c                	jne    8011a0 <__udivdi3+0xa0>
  801174:	39 f2                	cmp    %esi,%edx
  801176:	72 06                	jb     80117e <__udivdi3+0x7e>
  801178:	31 c0                	xor    %eax,%eax
  80117a:	39 eb                	cmp    %ebp,%ebx
  80117c:	77 a9                	ja     801127 <__udivdi3+0x27>
  80117e:	b8 01 00 00 00       	mov    $0x1,%eax
  801183:	eb a2                	jmp    801127 <__udivdi3+0x27>
  801185:	8d 76 00             	lea    0x0(%esi),%esi
  801188:	31 ff                	xor    %edi,%edi
  80118a:	31 c0                	xor    %eax,%eax
  80118c:	89 fa                	mov    %edi,%edx
  80118e:	83 c4 1c             	add    $0x1c,%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    
  801196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80119d:	8d 76 00             	lea    0x0(%esi),%esi
  8011a0:	89 f9                	mov    %edi,%ecx
  8011a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8011a7:	29 f8                	sub    %edi,%eax
  8011a9:	d3 e2                	shl    %cl,%edx
  8011ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8011af:	89 c1                	mov    %eax,%ecx
  8011b1:	89 da                	mov    %ebx,%edx
  8011b3:	d3 ea                	shr    %cl,%edx
  8011b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011b9:	09 d1                	or     %edx,%ecx
  8011bb:	89 f2                	mov    %esi,%edx
  8011bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011c1:	89 f9                	mov    %edi,%ecx
  8011c3:	d3 e3                	shl    %cl,%ebx
  8011c5:	89 c1                	mov    %eax,%ecx
  8011c7:	d3 ea                	shr    %cl,%edx
  8011c9:	89 f9                	mov    %edi,%ecx
  8011cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011cf:	89 eb                	mov    %ebp,%ebx
  8011d1:	d3 e6                	shl    %cl,%esi
  8011d3:	89 c1                	mov    %eax,%ecx
  8011d5:	d3 eb                	shr    %cl,%ebx
  8011d7:	09 de                	or     %ebx,%esi
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	f7 74 24 08          	divl   0x8(%esp)
  8011df:	89 d6                	mov    %edx,%esi
  8011e1:	89 c3                	mov    %eax,%ebx
  8011e3:	f7 64 24 0c          	mull   0xc(%esp)
  8011e7:	39 d6                	cmp    %edx,%esi
  8011e9:	72 15                	jb     801200 <__udivdi3+0x100>
  8011eb:	89 f9                	mov    %edi,%ecx
  8011ed:	d3 e5                	shl    %cl,%ebp
  8011ef:	39 c5                	cmp    %eax,%ebp
  8011f1:	73 04                	jae    8011f7 <__udivdi3+0xf7>
  8011f3:	39 d6                	cmp    %edx,%esi
  8011f5:	74 09                	je     801200 <__udivdi3+0x100>
  8011f7:	89 d8                	mov    %ebx,%eax
  8011f9:	31 ff                	xor    %edi,%edi
  8011fb:	e9 27 ff ff ff       	jmp    801127 <__udivdi3+0x27>
  801200:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801203:	31 ff                	xor    %edi,%edi
  801205:	e9 1d ff ff ff       	jmp    801127 <__udivdi3+0x27>
  80120a:	66 90                	xchg   %ax,%ax
  80120c:	66 90                	xchg   %ax,%ax
  80120e:	66 90                	xchg   %ax,%ax

00801210 <__umoddi3>:
  801210:	55                   	push   %ebp
  801211:	57                   	push   %edi
  801212:	56                   	push   %esi
  801213:	53                   	push   %ebx
  801214:	83 ec 1c             	sub    $0x1c,%esp
  801217:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80121b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80121f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801223:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801227:	89 da                	mov    %ebx,%edx
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 43                	jne    801270 <__umoddi3+0x60>
  80122d:	39 df                	cmp    %ebx,%edi
  80122f:	76 17                	jbe    801248 <__umoddi3+0x38>
  801231:	89 f0                	mov    %esi,%eax
  801233:	f7 f7                	div    %edi
  801235:	89 d0                	mov    %edx,%eax
  801237:	31 d2                	xor    %edx,%edx
  801239:	83 c4 1c             	add    $0x1c,%esp
  80123c:	5b                   	pop    %ebx
  80123d:	5e                   	pop    %esi
  80123e:	5f                   	pop    %edi
  80123f:	5d                   	pop    %ebp
  801240:	c3                   	ret    
  801241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801248:	89 fd                	mov    %edi,%ebp
  80124a:	85 ff                	test   %edi,%edi
  80124c:	75 0b                	jne    801259 <__umoddi3+0x49>
  80124e:	b8 01 00 00 00       	mov    $0x1,%eax
  801253:	31 d2                	xor    %edx,%edx
  801255:	f7 f7                	div    %edi
  801257:	89 c5                	mov    %eax,%ebp
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	31 d2                	xor    %edx,%edx
  80125d:	f7 f5                	div    %ebp
  80125f:	89 f0                	mov    %esi,%eax
  801261:	f7 f5                	div    %ebp
  801263:	89 d0                	mov    %edx,%eax
  801265:	eb d0                	jmp    801237 <__umoddi3+0x27>
  801267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80126e:	66 90                	xchg   %ax,%ax
  801270:	89 f1                	mov    %esi,%ecx
  801272:	39 d8                	cmp    %ebx,%eax
  801274:	76 0a                	jbe    801280 <__umoddi3+0x70>
  801276:	89 f0                	mov    %esi,%eax
  801278:	83 c4 1c             	add    $0x1c,%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    
  801280:	0f bd e8             	bsr    %eax,%ebp
  801283:	83 f5 1f             	xor    $0x1f,%ebp
  801286:	75 20                	jne    8012a8 <__umoddi3+0x98>
  801288:	39 d8                	cmp    %ebx,%eax
  80128a:	0f 82 b0 00 00 00    	jb     801340 <__umoddi3+0x130>
  801290:	39 f7                	cmp    %esi,%edi
  801292:	0f 86 a8 00 00 00    	jbe    801340 <__umoddi3+0x130>
  801298:	89 c8                	mov    %ecx,%eax
  80129a:	83 c4 1c             	add    $0x1c,%esp
  80129d:	5b                   	pop    %ebx
  80129e:	5e                   	pop    %esi
  80129f:	5f                   	pop    %edi
  8012a0:	5d                   	pop    %ebp
  8012a1:	c3                   	ret    
  8012a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012a8:	89 e9                	mov    %ebp,%ecx
  8012aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8012af:	29 ea                	sub    %ebp,%edx
  8012b1:	d3 e0                	shl    %cl,%eax
  8012b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b7:	89 d1                	mov    %edx,%ecx
  8012b9:	89 f8                	mov    %edi,%eax
  8012bb:	d3 e8                	shr    %cl,%eax
  8012bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8012c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8012c9:	09 c1                	or     %eax,%ecx
  8012cb:	89 d8                	mov    %ebx,%eax
  8012cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012d1:	89 e9                	mov    %ebp,%ecx
  8012d3:	d3 e7                	shl    %cl,%edi
  8012d5:	89 d1                	mov    %edx,%ecx
  8012d7:	d3 e8                	shr    %cl,%eax
  8012d9:	89 e9                	mov    %ebp,%ecx
  8012db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012df:	d3 e3                	shl    %cl,%ebx
  8012e1:	89 c7                	mov    %eax,%edi
  8012e3:	89 d1                	mov    %edx,%ecx
  8012e5:	89 f0                	mov    %esi,%eax
  8012e7:	d3 e8                	shr    %cl,%eax
  8012e9:	89 e9                	mov    %ebp,%ecx
  8012eb:	89 fa                	mov    %edi,%edx
  8012ed:	d3 e6                	shl    %cl,%esi
  8012ef:	09 d8                	or     %ebx,%eax
  8012f1:	f7 74 24 08          	divl   0x8(%esp)
  8012f5:	89 d1                	mov    %edx,%ecx
  8012f7:	89 f3                	mov    %esi,%ebx
  8012f9:	f7 64 24 0c          	mull   0xc(%esp)
  8012fd:	89 c6                	mov    %eax,%esi
  8012ff:	89 d7                	mov    %edx,%edi
  801301:	39 d1                	cmp    %edx,%ecx
  801303:	72 06                	jb     80130b <__umoddi3+0xfb>
  801305:	75 10                	jne    801317 <__umoddi3+0x107>
  801307:	39 c3                	cmp    %eax,%ebx
  801309:	73 0c                	jae    801317 <__umoddi3+0x107>
  80130b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80130f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801313:	89 d7                	mov    %edx,%edi
  801315:	89 c6                	mov    %eax,%esi
  801317:	89 ca                	mov    %ecx,%edx
  801319:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80131e:	29 f3                	sub    %esi,%ebx
  801320:	19 fa                	sbb    %edi,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	d3 e0                	shl    %cl,%eax
  801326:	89 e9                	mov    %ebp,%ecx
  801328:	d3 eb                	shr    %cl,%ebx
  80132a:	d3 ea                	shr    %cl,%edx
  80132c:	09 d8                	or     %ebx,%eax
  80132e:	83 c4 1c             	add    $0x1c,%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5f                   	pop    %edi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    
  801336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80133d:	8d 76 00             	lea    0x0(%esi),%esi
  801340:	89 da                	mov    %ebx,%edx
  801342:	29 fe                	sub    %edi,%esi
  801344:	19 c2                	sbb    %eax,%edx
  801346:	89 f1                	mov    %esi,%ecx
  801348:	89 c8                	mov    %ecx,%eax
  80134a:	e9 4b ff ff ff       	jmp    80129a <__umoddi3+0x8a>
