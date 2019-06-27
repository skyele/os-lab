
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
  800045:	e8 e1 0e 00 00       	call   800f2b <sys_page_alloc>
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
  80005f:	e8 0a 0f 00 00       	call   800f6e <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 49 0c 00 00       	call   800cc7 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 23 0f 00 00       	call   800fb0 <sys_page_unmap>
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
  80009c:	68 20 27 80 00       	push   $0x802720
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 33 27 80 00       	push   $0x802733
  8000a8:	e8 37 02 00 00       	call   8002e4 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 43 27 80 00       	push   $0x802743
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 33 27 80 00       	push   $0x802733
  8000ba:	e8 25 02 00 00       	call   8002e4 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 54 27 80 00       	push   $0x802754
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 33 27 80 00       	push   $0x802733
  8000cc:	e8 13 02 00 00       	call   8002e4 <_panic>

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
  800113:	68 67 27 80 00       	push   $0x802767
  800118:	6a 37                	push   $0x37
  80011a:	68 33 27 80 00       	push   $0x802733
  80011f:	e8 c0 01 00 00       	call   8002e4 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 c4 0d 00 00       	call   800eed <sys_getenvid>
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
  800158:	e8 95 0e 00 00       	call   800ff2 <sys_env_set_status>
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
  80016e:	68 77 27 80 00       	push   $0x802777
  800173:	6a 4c                	push   $0x4c
  800175:	68 33 27 80 00       	push   $0x802733
  80017a:	e8 65 01 00 00       	call   8002e4 <_panic>

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
  800191:	be 8e 27 80 00       	mov    $0x80278e,%esi
  800196:	b8 95 27 80 00       	mov    $0x802795,%eax
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
  8001af:	68 9b 27 80 00       	push   $0x80279b
  8001b4:	e8 21 02 00 00       	call   8003da <cprintf>
		sys_yield();
  8001b9:	e8 4e 0d 00 00       	call   800f0c <sys_yield>
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
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001de:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8001e5:	00 00 00 
	envid_t find = sys_getenvid();
  8001e8:	e8 00 0d 00 00       	call   800eed <sys_getenvid>
  8001ed:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8001f3:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001f8:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001fd:	bf 01 00 00 00       	mov    $0x1,%edi
  800202:	eb 0b                	jmp    80020f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800204:	83 c2 01             	add    $0x1,%edx
  800207:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80020d:	74 23                	je     800232 <libmain+0x5d>
		if(envs[i].env_id == find)
  80020f:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800215:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80021b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80021e:	39 c1                	cmp    %eax,%ecx
  800220:	75 e2                	jne    800204 <libmain+0x2f>
  800222:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800228:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80022e:	89 fe                	mov    %edi,%esi
  800230:	eb d2                	jmp    800204 <libmain+0x2f>
  800232:	89 f0                	mov    %esi,%eax
  800234:	84 c0                	test   %al,%al
  800236:	74 06                	je     80023e <libmain+0x69>
  800238:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800242:	7e 0a                	jle    80024e <libmain+0x79>
		binaryname = argv[0];
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80024e:	a1 08 40 80 00       	mov    0x804008,%eax
  800253:	8b 40 48             	mov    0x48(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 ad 27 80 00       	push   $0x8027ad
  80025f:	e8 76 01 00 00       	call   8003da <cprintf>
	cprintf("before umain\n");
  800264:	c7 04 24 cb 27 80 00 	movl   $0x8027cb,(%esp)
  80026b:	e8 6a 01 00 00       	call   8003da <cprintf>
	// call user main routine
	umain(argc, argv);
  800270:	83 c4 08             	add    $0x8,%esp
  800273:	ff 75 0c             	pushl  0xc(%ebp)
  800276:	ff 75 08             	pushl  0x8(%ebp)
  800279:	e8 01 ff ff ff       	call   80017f <umain>
	cprintf("after umain\n");
  80027e:	c7 04 24 d9 27 80 00 	movl   $0x8027d9,(%esp)
  800285:	e8 50 01 00 00       	call   8003da <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80028a:	a1 08 40 80 00       	mov    0x804008,%eax
  80028f:	8b 40 48             	mov    0x48(%eax),%eax
  800292:	83 c4 08             	add    $0x8,%esp
  800295:	50                   	push   %eax
  800296:	68 e6 27 80 00       	push   $0x8027e6
  80029b:	e8 3a 01 00 00       	call   8003da <cprintf>
	// exit gracefully
	exit();
  8002a0:	e8 0b 00 00 00       	call   8002b0 <exit>
}
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ab:	5b                   	pop    %ebx
  8002ac:	5e                   	pop    %esi
  8002ad:	5f                   	pop    %edi
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8002bb:	8b 40 48             	mov    0x48(%eax),%eax
  8002be:	68 10 28 80 00       	push   $0x802810
  8002c3:	50                   	push   %eax
  8002c4:	68 05 28 80 00       	push   $0x802805
  8002c9:	e8 0c 01 00 00       	call   8003da <cprintf>
	close_all();
  8002ce:	e8 25 11 00 00       	call   8013f8 <close_all>
	sys_env_destroy(0);
  8002d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002da:	e8 cd 0b 00 00       	call   800eac <sys_env_destroy>
}
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8002ee:	8b 40 48             	mov    0x48(%eax),%eax
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	68 3c 28 80 00       	push   $0x80283c
  8002f9:	50                   	push   %eax
  8002fa:	68 05 28 80 00       	push   $0x802805
  8002ff:	e8 d6 00 00 00       	call   8003da <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800304:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800307:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80030d:	e8 db 0b 00 00       	call   800eed <sys_getenvid>
  800312:	83 c4 04             	add    $0x4,%esp
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	56                   	push   %esi
  80031c:	50                   	push   %eax
  80031d:	68 18 28 80 00       	push   $0x802818
  800322:	e8 b3 00 00 00       	call   8003da <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800327:	83 c4 18             	add    $0x18,%esp
  80032a:	53                   	push   %ebx
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	e8 56 00 00 00       	call   800389 <vcprintf>
	cprintf("\n");
  800333:	c7 04 24 c9 27 80 00 	movl   $0x8027c9,(%esp)
  80033a:	e8 9b 00 00 00       	call   8003da <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800342:	cc                   	int3   
  800343:	eb fd                	jmp    800342 <_panic+0x5e>

00800345 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	53                   	push   %ebx
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80034f:	8b 13                	mov    (%ebx),%edx
  800351:	8d 42 01             	lea    0x1(%edx),%eax
  800354:	89 03                	mov    %eax,(%ebx)
  800356:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800359:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80035d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800362:	74 09                	je     80036d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800364:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80036b:	c9                   	leave  
  80036c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80036d:	83 ec 08             	sub    $0x8,%esp
  800370:	68 ff 00 00 00       	push   $0xff
  800375:	8d 43 08             	lea    0x8(%ebx),%eax
  800378:	50                   	push   %eax
  800379:	e8 f1 0a 00 00       	call   800e6f <sys_cputs>
		b->idx = 0;
  80037e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800384:	83 c4 10             	add    $0x10,%esp
  800387:	eb db                	jmp    800364 <putch+0x1f>

00800389 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800392:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800399:	00 00 00 
	b.cnt = 0;
  80039c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003a3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003a6:	ff 75 0c             	pushl  0xc(%ebp)
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b2:	50                   	push   %eax
  8003b3:	68 45 03 80 00       	push   $0x800345
  8003b8:	e8 4a 01 00 00       	call   800507 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003bd:	83 c4 08             	add    $0x8,%esp
  8003c0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003c6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003cc:	50                   	push   %eax
  8003cd:	e8 9d 0a 00 00       	call   800e6f <sys_cputs>

	return b.cnt;
}
  8003d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003e0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003e3:	50                   	push   %eax
  8003e4:	ff 75 08             	pushl  0x8(%ebp)
  8003e7:	e8 9d ff ff ff       	call   800389 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	57                   	push   %edi
  8003f2:	56                   	push   %esi
  8003f3:	53                   	push   %ebx
  8003f4:	83 ec 1c             	sub    $0x1c,%esp
  8003f7:	89 c6                	mov    %eax,%esi
  8003f9:	89 d7                	mov    %edx,%edi
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800401:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800404:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800407:	8b 45 10             	mov    0x10(%ebp),%eax
  80040a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80040d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800411:	74 2c                	je     80043f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800413:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800416:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80041d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800420:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800423:	39 c2                	cmp    %eax,%edx
  800425:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800428:	73 43                	jae    80046d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80042a:	83 eb 01             	sub    $0x1,%ebx
  80042d:	85 db                	test   %ebx,%ebx
  80042f:	7e 6c                	jle    80049d <printnum+0xaf>
				putch(padc, putdat);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	57                   	push   %edi
  800435:	ff 75 18             	pushl  0x18(%ebp)
  800438:	ff d6                	call   *%esi
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	eb eb                	jmp    80042a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	6a 20                	push   $0x20
  800444:	6a 00                	push   $0x0
  800446:	50                   	push   %eax
  800447:	ff 75 e4             	pushl  -0x1c(%ebp)
  80044a:	ff 75 e0             	pushl  -0x20(%ebp)
  80044d:	89 fa                	mov    %edi,%edx
  80044f:	89 f0                	mov    %esi,%eax
  800451:	e8 98 ff ff ff       	call   8003ee <printnum>
		while (--width > 0)
  800456:	83 c4 20             	add    $0x20,%esp
  800459:	83 eb 01             	sub    $0x1,%ebx
  80045c:	85 db                	test   %ebx,%ebx
  80045e:	7e 65                	jle    8004c5 <printnum+0xd7>
			putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	57                   	push   %edi
  800464:	6a 20                	push   $0x20
  800466:	ff d6                	call   *%esi
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb ec                	jmp    800459 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	ff 75 18             	pushl  0x18(%ebp)
  800473:	83 eb 01             	sub    $0x1,%ebx
  800476:	53                   	push   %ebx
  800477:	50                   	push   %eax
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	ff 75 dc             	pushl  -0x24(%ebp)
  80047e:	ff 75 d8             	pushl  -0x28(%ebp)
  800481:	ff 75 e4             	pushl  -0x1c(%ebp)
  800484:	ff 75 e0             	pushl  -0x20(%ebp)
  800487:	e8 34 20 00 00       	call   8024c0 <__udivdi3>
  80048c:	83 c4 18             	add    $0x18,%esp
  80048f:	52                   	push   %edx
  800490:	50                   	push   %eax
  800491:	89 fa                	mov    %edi,%edx
  800493:	89 f0                	mov    %esi,%eax
  800495:	e8 54 ff ff ff       	call   8003ee <printnum>
  80049a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	57                   	push   %edi
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b0:	e8 1b 21 00 00       	call   8025d0 <__umoddi3>
  8004b5:	83 c4 14             	add    $0x14,%esp
  8004b8:	0f be 80 43 28 80 00 	movsbl 0x802843(%eax),%eax
  8004bf:	50                   	push   %eax
  8004c0:	ff d6                	call   *%esi
  8004c2:	83 c4 10             	add    $0x10,%esp
	}
}
  8004c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c8:	5b                   	pop    %ebx
  8004c9:	5e                   	pop    %esi
  8004ca:	5f                   	pop    %edi
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    

008004cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004d3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d7:	8b 10                	mov    (%eax),%edx
  8004d9:	3b 50 04             	cmp    0x4(%eax),%edx
  8004dc:	73 0a                	jae    8004e8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e1:	89 08                	mov    %ecx,(%eax)
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	88 02                	mov    %al,(%edx)
}
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    

008004ea <printfmt>:
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004f3:	50                   	push   %eax
  8004f4:	ff 75 10             	pushl  0x10(%ebp)
  8004f7:	ff 75 0c             	pushl  0xc(%ebp)
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	e8 05 00 00 00       	call   800507 <vprintfmt>
}
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	c9                   	leave  
  800506:	c3                   	ret    

00800507 <vprintfmt>:
{
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	57                   	push   %edi
  80050b:	56                   	push   %esi
  80050c:	53                   	push   %ebx
  80050d:	83 ec 3c             	sub    $0x3c,%esp
  800510:	8b 75 08             	mov    0x8(%ebp),%esi
  800513:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800516:	8b 7d 10             	mov    0x10(%ebp),%edi
  800519:	e9 32 04 00 00       	jmp    800950 <vprintfmt+0x449>
		padc = ' ';
  80051e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800522:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800529:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800530:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800537:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80053e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800545:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8d 47 01             	lea    0x1(%edi),%eax
  80054d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800550:	0f b6 17             	movzbl (%edi),%edx
  800553:	8d 42 dd             	lea    -0x23(%edx),%eax
  800556:	3c 55                	cmp    $0x55,%al
  800558:	0f 87 12 05 00 00    	ja     800a70 <vprintfmt+0x569>
  80055e:	0f b6 c0             	movzbl %al,%eax
  800561:	ff 24 85 20 2a 80 00 	jmp    *0x802a20(,%eax,4)
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80056b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80056f:	eb d9                	jmp    80054a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800574:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800578:	eb d0                	jmp    80054a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	0f b6 d2             	movzbl %dl,%edx
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	89 75 08             	mov    %esi,0x8(%ebp)
  800588:	eb 03                	jmp    80058d <vprintfmt+0x86>
  80058a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80058d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800590:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800594:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800597:	8d 72 d0             	lea    -0x30(%edx),%esi
  80059a:	83 fe 09             	cmp    $0x9,%esi
  80059d:	76 eb                	jbe    80058a <vprintfmt+0x83>
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a5:	eb 14                	jmp    8005bb <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 40 04             	lea    0x4(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bf:	79 89                	jns    80054a <vprintfmt+0x43>
				width = precision, precision = -1;
  8005c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005ce:	e9 77 ff ff ff       	jmp    80054a <vprintfmt+0x43>
  8005d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	0f 48 c1             	cmovs  %ecx,%eax
  8005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e1:	e9 64 ff ff ff       	jmp    80054a <vprintfmt+0x43>
  8005e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005e9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005f0:	e9 55 ff ff ff       	jmp    80054a <vprintfmt+0x43>
			lflag++;
  8005f5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005fc:	e9 49 ff ff ff       	jmp    80054a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 78 04             	lea    0x4(%eax),%edi
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	53                   	push   %ebx
  80060b:	ff 30                	pushl  (%eax)
  80060d:	ff d6                	call   *%esi
			break;
  80060f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800612:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800615:	e9 33 03 00 00       	jmp    80094d <vprintfmt+0x446>
			err = va_arg(ap, int);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 78 04             	lea    0x4(%eax),%edi
  800620:	8b 00                	mov    (%eax),%eax
  800622:	99                   	cltd   
  800623:	31 d0                	xor    %edx,%eax
  800625:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800627:	83 f8 11             	cmp    $0x11,%eax
  80062a:	7f 23                	jg     80064f <vprintfmt+0x148>
  80062c:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  800633:	85 d2                	test   %edx,%edx
  800635:	74 18                	je     80064f <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800637:	52                   	push   %edx
  800638:	68 a1 2c 80 00       	push   $0x802ca1
  80063d:	53                   	push   %ebx
  80063e:	56                   	push   %esi
  80063f:	e8 a6 fe ff ff       	call   8004ea <printfmt>
  800644:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800647:	89 7d 14             	mov    %edi,0x14(%ebp)
  80064a:	e9 fe 02 00 00       	jmp    80094d <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80064f:	50                   	push   %eax
  800650:	68 5b 28 80 00       	push   $0x80285b
  800655:	53                   	push   %ebx
  800656:	56                   	push   %esi
  800657:	e8 8e fe ff ff       	call   8004ea <printfmt>
  80065c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800662:	e9 e6 02 00 00       	jmp    80094d <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 c0 04             	add    $0x4,%eax
  80066d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800675:	85 c9                	test   %ecx,%ecx
  800677:	b8 54 28 80 00       	mov    $0x802854,%eax
  80067c:	0f 45 c1             	cmovne %ecx,%eax
  80067f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800682:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800686:	7e 06                	jle    80068e <vprintfmt+0x187>
  800688:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80068c:	75 0d                	jne    80069b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800691:	89 c7                	mov    %eax,%edi
  800693:	03 45 e0             	add    -0x20(%ebp),%eax
  800696:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800699:	eb 53                	jmp    8006ee <vprintfmt+0x1e7>
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a1:	50                   	push   %eax
  8006a2:	e8 71 04 00 00       	call   800b18 <strnlen>
  8006a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006aa:	29 c1                	sub    %eax,%ecx
  8006ac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006b4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bb:	eb 0f                	jmp    8006cc <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c6:	83 ef 01             	sub    $0x1,%edi
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	85 ff                	test   %edi,%edi
  8006ce:	7f ed                	jg     8006bd <vprintfmt+0x1b6>
  8006d0:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006d3:	85 c9                	test   %ecx,%ecx
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006da:	0f 49 c1             	cmovns %ecx,%eax
  8006dd:	29 c1                	sub    %eax,%ecx
  8006df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006e2:	eb aa                	jmp    80068e <vprintfmt+0x187>
					putch(ch, putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	52                   	push   %edx
  8006e9:	ff d6                	call   *%esi
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006f1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	83 c7 01             	add    $0x1,%edi
  8006f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006fa:	0f be d0             	movsbl %al,%edx
  8006fd:	85 d2                	test   %edx,%edx
  8006ff:	74 4b                	je     80074c <vprintfmt+0x245>
  800701:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800705:	78 06                	js     80070d <vprintfmt+0x206>
  800707:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80070b:	78 1e                	js     80072b <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80070d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800711:	74 d1                	je     8006e4 <vprintfmt+0x1dd>
  800713:	0f be c0             	movsbl %al,%eax
  800716:	83 e8 20             	sub    $0x20,%eax
  800719:	83 f8 5e             	cmp    $0x5e,%eax
  80071c:	76 c6                	jbe    8006e4 <vprintfmt+0x1dd>
					putch('?', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 3f                	push   $0x3f
  800724:	ff d6                	call   *%esi
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	eb c3                	jmp    8006ee <vprintfmt+0x1e7>
  80072b:	89 cf                	mov    %ecx,%edi
  80072d:	eb 0e                	jmp    80073d <vprintfmt+0x236>
				putch(' ', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 20                	push   $0x20
  800735:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800737:	83 ef 01             	sub    $0x1,%edi
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	85 ff                	test   %edi,%edi
  80073f:	7f ee                	jg     80072f <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800741:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
  800747:	e9 01 02 00 00       	jmp    80094d <vprintfmt+0x446>
  80074c:	89 cf                	mov    %ecx,%edi
  80074e:	eb ed                	jmp    80073d <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800750:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800753:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80075a:	e9 eb fd ff ff       	jmp    80054a <vprintfmt+0x43>
	if (lflag >= 2)
  80075f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800763:	7f 21                	jg     800786 <vprintfmt+0x27f>
	else if (lflag)
  800765:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800769:	74 68                	je     8007d3 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800773:	89 c1                	mov    %eax,%ecx
  800775:	c1 f9 1f             	sar    $0x1f,%ecx
  800778:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
  800784:	eb 17                	jmp    80079d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 50 04             	mov    0x4(%eax),%edx
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800791:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 08             	lea    0x8(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80079d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007ad:	78 3f                	js     8007ee <vprintfmt+0x2e7>
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007b4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007b8:	0f 84 71 01 00 00    	je     80092f <vprintfmt+0x428>
				putch('+', putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	6a 2b                	push   $0x2b
  8007c4:	ff d6                	call   *%esi
  8007c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ce:	e9 5c 01 00 00       	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007db:	89 c1                	mov    %eax,%ecx
  8007dd:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	eb af                	jmp    80079d <vprintfmt+0x296>
				putch('-', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	6a 2d                	push   $0x2d
  8007f4:	ff d6                	call   *%esi
				num = -(long long) num;
  8007f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007fc:	f7 d8                	neg    %eax
  8007fe:	83 d2 00             	adc    $0x0,%edx
  800801:	f7 da                	neg    %edx
  800803:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800806:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800809:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80080c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800811:	e9 19 01 00 00       	jmp    80092f <vprintfmt+0x428>
	if (lflag >= 2)
  800816:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80081a:	7f 29                	jg     800845 <vprintfmt+0x33e>
	else if (lflag)
  80081c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800820:	74 44                	je     800866 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800840:	e9 ea 00 00 00       	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8b 50 04             	mov    0x4(%eax),%edx
  80084b:	8b 00                	mov    (%eax),%eax
  80084d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800850:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8d 40 08             	lea    0x8(%eax),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800861:	e9 c9 00 00 00       	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800873:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 40 04             	lea    0x4(%eax),%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80087f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800884:	e9 a6 00 00 00       	jmp    80092f <vprintfmt+0x428>
			putch('0', putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	6a 30                	push   $0x30
  80088f:	ff d6                	call   *%esi
	if (lflag >= 2)
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800898:	7f 26                	jg     8008c0 <vprintfmt+0x3b9>
	else if (lflag)
  80089a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80089e:	74 3e                	je     8008de <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8d 40 04             	lea    0x4(%eax),%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8008be:	eb 6f                	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8b 50 04             	mov    0x4(%eax),%edx
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8d 40 08             	lea    0x8(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8008dc:	eb 51                	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	8d 40 04             	lea    0x4(%eax),%eax
  8008f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8008fc:	eb 31                	jmp    80092f <vprintfmt+0x428>
			putch('0', putdat);
  8008fe:	83 ec 08             	sub    $0x8,%esp
  800901:	53                   	push   %ebx
  800902:	6a 30                	push   $0x30
  800904:	ff d6                	call   *%esi
			putch('x', putdat);
  800906:	83 c4 08             	add    $0x8,%esp
  800909:	53                   	push   %ebx
  80090a:	6a 78                	push   $0x78
  80090c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
  800918:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80091e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8d 40 04             	lea    0x4(%eax),%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80092f:	83 ec 0c             	sub    $0xc,%esp
  800932:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800936:	52                   	push   %edx
  800937:	ff 75 e0             	pushl  -0x20(%ebp)
  80093a:	50                   	push   %eax
  80093b:	ff 75 dc             	pushl  -0x24(%ebp)
  80093e:	ff 75 d8             	pushl  -0x28(%ebp)
  800941:	89 da                	mov    %ebx,%edx
  800943:	89 f0                	mov    %esi,%eax
  800945:	e8 a4 fa ff ff       	call   8003ee <printnum>
			break;
  80094a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80094d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800950:	83 c7 01             	add    $0x1,%edi
  800953:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800957:	83 f8 25             	cmp    $0x25,%eax
  80095a:	0f 84 be fb ff ff    	je     80051e <vprintfmt+0x17>
			if (ch == '\0')
  800960:	85 c0                	test   %eax,%eax
  800962:	0f 84 28 01 00 00    	je     800a90 <vprintfmt+0x589>
			putch(ch, putdat);
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	53                   	push   %ebx
  80096c:	50                   	push   %eax
  80096d:	ff d6                	call   *%esi
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	eb dc                	jmp    800950 <vprintfmt+0x449>
	if (lflag >= 2)
  800974:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800978:	7f 26                	jg     8009a0 <vprintfmt+0x499>
	else if (lflag)
  80097a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80097e:	74 41                	je     8009c1 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
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
  80099e:	eb 8f                	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a3:	8b 50 04             	mov    0x4(%eax),%edx
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	8d 40 08             	lea    0x8(%eax),%eax
  8009b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b7:	b8 10 00 00 00       	mov    $0x10,%eax
  8009bc:	e9 6e ff ff ff       	jmp    80092f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	8d 40 04             	lea    0x4(%eax),%eax
  8009d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009da:	b8 10 00 00 00       	mov    $0x10,%eax
  8009df:	e9 4b ff ff ff       	jmp    80092f <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	83 c0 04             	add    $0x4,%eax
  8009ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	85 c0                	test   %eax,%eax
  8009f4:	74 14                	je     800a0a <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009f6:	8b 13                	mov    (%ebx),%edx
  8009f8:	83 fa 7f             	cmp    $0x7f,%edx
  8009fb:	7f 37                	jg     800a34 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009fd:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
  800a05:	e9 43 ff ff ff       	jmp    80094d <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a0a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a0f:	bf 79 29 80 00       	mov    $0x802979,%edi
							putch(ch, putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	53                   	push   %ebx
  800a18:	50                   	push   %eax
  800a19:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a1b:	83 c7 01             	add    $0x1,%edi
  800a1e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a22:	83 c4 10             	add    $0x10,%esp
  800a25:	85 c0                	test   %eax,%eax
  800a27:	75 eb                	jne    800a14 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2f:	e9 19 ff ff ff       	jmp    80094d <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a34:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a3b:	bf b1 29 80 00       	mov    $0x8029b1,%edi
							putch(ch, putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	53                   	push   %ebx
  800a44:	50                   	push   %eax
  800a45:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a47:	83 c7 01             	add    $0x1,%edi
  800a4a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	85 c0                	test   %eax,%eax
  800a53:	75 eb                	jne    800a40 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a55:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a58:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5b:	e9 ed fe ff ff       	jmp    80094d <vprintfmt+0x446>
			putch(ch, putdat);
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	53                   	push   %ebx
  800a64:	6a 25                	push   $0x25
  800a66:	ff d6                	call   *%esi
			break;
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	e9 dd fe ff ff       	jmp    80094d <vprintfmt+0x446>
			putch('%', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	53                   	push   %ebx
  800a74:	6a 25                	push   $0x25
  800a76:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a78:	83 c4 10             	add    $0x10,%esp
  800a7b:	89 f8                	mov    %edi,%eax
  800a7d:	eb 03                	jmp    800a82 <vprintfmt+0x57b>
  800a7f:	83 e8 01             	sub    $0x1,%eax
  800a82:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a86:	75 f7                	jne    800a7f <vprintfmt+0x578>
  800a88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8b:	e9 bd fe ff ff       	jmp    80094d <vprintfmt+0x446>
}
  800a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 18             	sub    $0x18,%esp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aa7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ab5:	85 c0                	test   %eax,%eax
  800ab7:	74 26                	je     800adf <vsnprintf+0x47>
  800ab9:	85 d2                	test   %edx,%edx
  800abb:	7e 22                	jle    800adf <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800abd:	ff 75 14             	pushl  0x14(%ebp)
  800ac0:	ff 75 10             	pushl  0x10(%ebp)
  800ac3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac6:	50                   	push   %eax
  800ac7:	68 cd 04 80 00       	push   $0x8004cd
  800acc:	e8 36 fa ff ff       	call   800507 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ada:	83 c4 10             	add    $0x10,%esp
}
  800add:	c9                   	leave  
  800ade:	c3                   	ret    
		return -E_INVAL;
  800adf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae4:	eb f7                	jmp    800add <vsnprintf+0x45>

00800ae6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aec:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aef:	50                   	push   %eax
  800af0:	ff 75 10             	pushl  0x10(%ebp)
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 9a ff ff ff       	call   800a98 <vsnprintf>
	va_end(ap);

	return rc;
}
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b06:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b0f:	74 05                	je     800b16 <strlen+0x16>
		n++;
  800b11:	83 c0 01             	add    $0x1,%eax
  800b14:	eb f5                	jmp    800b0b <strlen+0xb>
	return n;
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b21:	ba 00 00 00 00       	mov    $0x0,%edx
  800b26:	39 c2                	cmp    %eax,%edx
  800b28:	74 0d                	je     800b37 <strnlen+0x1f>
  800b2a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b2e:	74 05                	je     800b35 <strnlen+0x1d>
		n++;
  800b30:	83 c2 01             	add    $0x1,%edx
  800b33:	eb f1                	jmp    800b26 <strnlen+0xe>
  800b35:	89 d0                	mov    %edx,%eax
	return n;
}
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	53                   	push   %ebx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
  800b48:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b4c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b4f:	83 c2 01             	add    $0x1,%edx
  800b52:	84 c9                	test   %cl,%cl
  800b54:	75 f2                	jne    800b48 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b56:	5b                   	pop    %ebx
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    

00800b59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	53                   	push   %ebx
  800b5d:	83 ec 10             	sub    $0x10,%esp
  800b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b63:	53                   	push   %ebx
  800b64:	e8 97 ff ff ff       	call   800b00 <strlen>
  800b69:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	01 d8                	add    %ebx,%eax
  800b71:	50                   	push   %eax
  800b72:	e8 c2 ff ff ff       	call   800b39 <strcpy>
	return dst;
}
  800b77:	89 d8                	mov    %ebx,%eax
  800b79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b89:	89 c6                	mov    %eax,%esi
  800b8b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	39 f2                	cmp    %esi,%edx
  800b92:	74 11                	je     800ba5 <strncpy+0x27>
		*dst++ = *src;
  800b94:	83 c2 01             	add    $0x1,%edx
  800b97:	0f b6 19             	movzbl (%ecx),%ebx
  800b9a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b9d:	80 fb 01             	cmp    $0x1,%bl
  800ba0:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ba3:	eb eb                	jmp    800b90 <strncpy+0x12>
	}
	return ret;
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	56                   	push   %esi
  800bad:	53                   	push   %ebx
  800bae:	8b 75 08             	mov    0x8(%ebp),%esi
  800bb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb4:	8b 55 10             	mov    0x10(%ebp),%edx
  800bb7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bb9:	85 d2                	test   %edx,%edx
  800bbb:	74 21                	je     800bde <strlcpy+0x35>
  800bbd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bc1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bc3:	39 c2                	cmp    %eax,%edx
  800bc5:	74 14                	je     800bdb <strlcpy+0x32>
  800bc7:	0f b6 19             	movzbl (%ecx),%ebx
  800bca:	84 db                	test   %bl,%bl
  800bcc:	74 0b                	je     800bd9 <strlcpy+0x30>
			*dst++ = *src++;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	83 c2 01             	add    $0x1,%edx
  800bd4:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bd7:	eb ea                	jmp    800bc3 <strlcpy+0x1a>
  800bd9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bdb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bde:	29 f0                	sub    %esi,%eax
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bed:	0f b6 01             	movzbl (%ecx),%eax
  800bf0:	84 c0                	test   %al,%al
  800bf2:	74 0c                	je     800c00 <strcmp+0x1c>
  800bf4:	3a 02                	cmp    (%edx),%al
  800bf6:	75 08                	jne    800c00 <strcmp+0x1c>
		p++, q++;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	83 c2 01             	add    $0x1,%edx
  800bfe:	eb ed                	jmp    800bed <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c00:	0f b6 c0             	movzbl %al,%eax
  800c03:	0f b6 12             	movzbl (%edx),%edx
  800c06:	29 d0                	sub    %edx,%eax
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	53                   	push   %ebx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 c3                	mov    %eax,%ebx
  800c16:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c19:	eb 06                	jmp    800c21 <strncmp+0x17>
		n--, p++, q++;
  800c1b:	83 c0 01             	add    $0x1,%eax
  800c1e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c21:	39 d8                	cmp    %ebx,%eax
  800c23:	74 16                	je     800c3b <strncmp+0x31>
  800c25:	0f b6 08             	movzbl (%eax),%ecx
  800c28:	84 c9                	test   %cl,%cl
  800c2a:	74 04                	je     800c30 <strncmp+0x26>
  800c2c:	3a 0a                	cmp    (%edx),%cl
  800c2e:	74 eb                	je     800c1b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c30:	0f b6 00             	movzbl (%eax),%eax
  800c33:	0f b6 12             	movzbl (%edx),%edx
  800c36:	29 d0                	sub    %edx,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    
		return 0;
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c40:	eb f6                	jmp    800c38 <strncmp+0x2e>

00800c42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4c:	0f b6 10             	movzbl (%eax),%edx
  800c4f:	84 d2                	test   %dl,%dl
  800c51:	74 09                	je     800c5c <strchr+0x1a>
		if (*s == c)
  800c53:	38 ca                	cmp    %cl,%dl
  800c55:	74 0a                	je     800c61 <strchr+0x1f>
	for (; *s; s++)
  800c57:	83 c0 01             	add    $0x1,%eax
  800c5a:	eb f0                	jmp    800c4c <strchr+0xa>
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c6d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c70:	38 ca                	cmp    %cl,%dl
  800c72:	74 09                	je     800c7d <strfind+0x1a>
  800c74:	84 d2                	test   %dl,%dl
  800c76:	74 05                	je     800c7d <strfind+0x1a>
	for (; *s; s++)
  800c78:	83 c0 01             	add    $0x1,%eax
  800c7b:	eb f0                	jmp    800c6d <strfind+0xa>
			break;
	return (char *) s;
}
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c88:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c8b:	85 c9                	test   %ecx,%ecx
  800c8d:	74 31                	je     800cc0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c8f:	89 f8                	mov    %edi,%eax
  800c91:	09 c8                	or     %ecx,%eax
  800c93:	a8 03                	test   $0x3,%al
  800c95:	75 23                	jne    800cba <memset+0x3b>
		c &= 0xFF;
  800c97:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c9b:	89 d3                	mov    %edx,%ebx
  800c9d:	c1 e3 08             	shl    $0x8,%ebx
  800ca0:	89 d0                	mov    %edx,%eax
  800ca2:	c1 e0 18             	shl    $0x18,%eax
  800ca5:	89 d6                	mov    %edx,%esi
  800ca7:	c1 e6 10             	shl    $0x10,%esi
  800caa:	09 f0                	or     %esi,%eax
  800cac:	09 c2                	or     %eax,%edx
  800cae:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cb0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cb3:	89 d0                	mov    %edx,%eax
  800cb5:	fc                   	cld    
  800cb6:	f3 ab                	rep stos %eax,%es:(%edi)
  800cb8:	eb 06                	jmp    800cc0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	fc                   	cld    
  800cbe:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cc0:	89 f8                	mov    %edi,%eax
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cd5:	39 c6                	cmp    %eax,%esi
  800cd7:	73 32                	jae    800d0b <memmove+0x44>
  800cd9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cdc:	39 c2                	cmp    %eax,%edx
  800cde:	76 2b                	jbe    800d0b <memmove+0x44>
		s += n;
		d += n;
  800ce0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ce3:	89 fe                	mov    %edi,%esi
  800ce5:	09 ce                	or     %ecx,%esi
  800ce7:	09 d6                	or     %edx,%esi
  800ce9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cef:	75 0e                	jne    800cff <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cf1:	83 ef 04             	sub    $0x4,%edi
  800cf4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cf7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cfa:	fd                   	std    
  800cfb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cfd:	eb 09                	jmp    800d08 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cff:	83 ef 01             	sub    $0x1,%edi
  800d02:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d05:	fd                   	std    
  800d06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d08:	fc                   	cld    
  800d09:	eb 1a                	jmp    800d25 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d0b:	89 c2                	mov    %eax,%edx
  800d0d:	09 ca                	or     %ecx,%edx
  800d0f:	09 f2                	or     %esi,%edx
  800d11:	f6 c2 03             	test   $0x3,%dl
  800d14:	75 0a                	jne    800d20 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d19:	89 c7                	mov    %eax,%edi
  800d1b:	fc                   	cld    
  800d1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d1e:	eb 05                	jmp    800d25 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d20:	89 c7                	mov    %eax,%edi
  800d22:	fc                   	cld    
  800d23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d2f:	ff 75 10             	pushl  0x10(%ebp)
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	e8 8a ff ff ff       	call   800cc7 <memmove>
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4a:	89 c6                	mov    %eax,%esi
  800d4c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d4f:	39 f0                	cmp    %esi,%eax
  800d51:	74 1c                	je     800d6f <memcmp+0x30>
		if (*s1 != *s2)
  800d53:	0f b6 08             	movzbl (%eax),%ecx
  800d56:	0f b6 1a             	movzbl (%edx),%ebx
  800d59:	38 d9                	cmp    %bl,%cl
  800d5b:	75 08                	jne    800d65 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d5d:	83 c0 01             	add    $0x1,%eax
  800d60:	83 c2 01             	add    $0x1,%edx
  800d63:	eb ea                	jmp    800d4f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d65:	0f b6 c1             	movzbl %cl,%eax
  800d68:	0f b6 db             	movzbl %bl,%ebx
  800d6b:	29 d8                	sub    %ebx,%eax
  800d6d:	eb 05                	jmp    800d74 <memcmp+0x35>
	}

	return 0;
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d81:	89 c2                	mov    %eax,%edx
  800d83:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d86:	39 d0                	cmp    %edx,%eax
  800d88:	73 09                	jae    800d93 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d8a:	38 08                	cmp    %cl,(%eax)
  800d8c:	74 05                	je     800d93 <memfind+0x1b>
	for (; s < ends; s++)
  800d8e:	83 c0 01             	add    $0x1,%eax
  800d91:	eb f3                	jmp    800d86 <memfind+0xe>
			break;
	return (void *) s;
}
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da1:	eb 03                	jmp    800da6 <strtol+0x11>
		s++;
  800da3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800da6:	0f b6 01             	movzbl (%ecx),%eax
  800da9:	3c 20                	cmp    $0x20,%al
  800dab:	74 f6                	je     800da3 <strtol+0xe>
  800dad:	3c 09                	cmp    $0x9,%al
  800daf:	74 f2                	je     800da3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800db1:	3c 2b                	cmp    $0x2b,%al
  800db3:	74 2a                	je     800ddf <strtol+0x4a>
	int neg = 0;
  800db5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dba:	3c 2d                	cmp    $0x2d,%al
  800dbc:	74 2b                	je     800de9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dbe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dc4:	75 0f                	jne    800dd5 <strtol+0x40>
  800dc6:	80 39 30             	cmpb   $0x30,(%ecx)
  800dc9:	74 28                	je     800df3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dcb:	85 db                	test   %ebx,%ebx
  800dcd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd2:	0f 44 d8             	cmove  %eax,%ebx
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dda:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ddd:	eb 50                	jmp    800e2f <strtol+0x9a>
		s++;
  800ddf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800de2:	bf 00 00 00 00       	mov    $0x0,%edi
  800de7:	eb d5                	jmp    800dbe <strtol+0x29>
		s++, neg = 1;
  800de9:	83 c1 01             	add    $0x1,%ecx
  800dec:	bf 01 00 00 00       	mov    $0x1,%edi
  800df1:	eb cb                	jmp    800dbe <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800df3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800df7:	74 0e                	je     800e07 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800df9:	85 db                	test   %ebx,%ebx
  800dfb:	75 d8                	jne    800dd5 <strtol+0x40>
		s++, base = 8;
  800dfd:	83 c1 01             	add    $0x1,%ecx
  800e00:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e05:	eb ce                	jmp    800dd5 <strtol+0x40>
		s += 2, base = 16;
  800e07:	83 c1 02             	add    $0x2,%ecx
  800e0a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e0f:	eb c4                	jmp    800dd5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e11:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e14:	89 f3                	mov    %esi,%ebx
  800e16:	80 fb 19             	cmp    $0x19,%bl
  800e19:	77 29                	ja     800e44 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e1b:	0f be d2             	movsbl %dl,%edx
  800e1e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e24:	7d 30                	jge    800e56 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e26:	83 c1 01             	add    $0x1,%ecx
  800e29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e2f:	0f b6 11             	movzbl (%ecx),%edx
  800e32:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e35:	89 f3                	mov    %esi,%ebx
  800e37:	80 fb 09             	cmp    $0x9,%bl
  800e3a:	77 d5                	ja     800e11 <strtol+0x7c>
			dig = *s - '0';
  800e3c:	0f be d2             	movsbl %dl,%edx
  800e3f:	83 ea 30             	sub    $0x30,%edx
  800e42:	eb dd                	jmp    800e21 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e44:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e47:	89 f3                	mov    %esi,%ebx
  800e49:	80 fb 19             	cmp    $0x19,%bl
  800e4c:	77 08                	ja     800e56 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e4e:	0f be d2             	movsbl %dl,%edx
  800e51:	83 ea 37             	sub    $0x37,%edx
  800e54:	eb cb                	jmp    800e21 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5a:	74 05                	je     800e61 <strtol+0xcc>
		*endptr = (char *) s;
  800e5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e5f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e61:	89 c2                	mov    %eax,%edx
  800e63:	f7 da                	neg    %edx
  800e65:	85 ff                	test   %edi,%edi
  800e67:	0f 45 c2             	cmovne %edx,%eax
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e75:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	89 c3                	mov    %eax,%ebx
  800e82:	89 c7                	mov    %eax,%edi
  800e84:	89 c6                	mov    %eax,%esi
  800e86:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e88:	5b                   	pop    %ebx
  800e89:	5e                   	pop    %esi
  800e8a:	5f                   	pop    %edi
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <sys_cgetc>:

int
sys_cgetc(void)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e93:	ba 00 00 00 00       	mov    $0x0,%edx
  800e98:	b8 01 00 00 00       	mov    $0x1,%eax
  800e9d:	89 d1                	mov    %edx,%ecx
  800e9f:	89 d3                	mov    %edx,%ebx
  800ea1:	89 d7                	mov    %edx,%edi
  800ea3:	89 d6                	mov    %edx,%esi
  800ea5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ec2:	89 cb                	mov    %ecx,%ebx
  800ec4:	89 cf                	mov    %ecx,%edi
  800ec6:	89 ce                	mov    %ecx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 03                	push   $0x3
  800edc:	68 c8 2b 80 00       	push   $0x802bc8
  800ee1:	6a 43                	push   $0x43
  800ee3:	68 e5 2b 80 00       	push   $0x802be5
  800ee8:	e8 f7 f3 ff ff       	call   8002e4 <_panic>

00800eed <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef8:	b8 02 00 00 00       	mov    $0x2,%eax
  800efd:	89 d1                	mov    %edx,%ecx
  800eff:	89 d3                	mov    %edx,%ebx
  800f01:	89 d7                	mov    %edx,%edi
  800f03:	89 d6                	mov    %edx,%esi
  800f05:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <sys_yield>:

void
sys_yield(void)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f12:	ba 00 00 00 00       	mov    $0x0,%edx
  800f17:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f1c:	89 d1                	mov    %edx,%ecx
  800f1e:	89 d3                	mov    %edx,%ebx
  800f20:	89 d7                	mov    %edx,%edi
  800f22:	89 d6                	mov    %edx,%esi
  800f24:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
  800f31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f34:	be 00 00 00 00       	mov    $0x0,%esi
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	b8 04 00 00 00       	mov    $0x4,%eax
  800f44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f47:	89 f7                	mov    %esi,%edi
  800f49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4b:	85 c0                	test   %eax,%eax
  800f4d:	7f 08                	jg     800f57 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f57:	83 ec 0c             	sub    $0xc,%esp
  800f5a:	50                   	push   %eax
  800f5b:	6a 04                	push   $0x4
  800f5d:	68 c8 2b 80 00       	push   $0x802bc8
  800f62:	6a 43                	push   $0x43
  800f64:	68 e5 2b 80 00       	push   $0x802be5
  800f69:	e8 76 f3 ff ff       	call   8002e4 <_panic>

00800f6e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	b8 05 00 00 00       	mov    $0x5,%eax
  800f82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f85:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f88:	8b 75 18             	mov    0x18(%ebp),%esi
  800f8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	7f 08                	jg     800f99 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f94:	5b                   	pop    %ebx
  800f95:	5e                   	pop    %esi
  800f96:	5f                   	pop    %edi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f99:	83 ec 0c             	sub    $0xc,%esp
  800f9c:	50                   	push   %eax
  800f9d:	6a 05                	push   $0x5
  800f9f:	68 c8 2b 80 00       	push   $0x802bc8
  800fa4:	6a 43                	push   $0x43
  800fa6:	68 e5 2b 80 00       	push   $0x802be5
  800fab:	e8 34 f3 ff ff       	call   8002e4 <_panic>

00800fb0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc4:	b8 06 00 00 00       	mov    $0x6,%eax
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	7f 08                	jg     800fdb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	50                   	push   %eax
  800fdf:	6a 06                	push   $0x6
  800fe1:	68 c8 2b 80 00       	push   $0x802bc8
  800fe6:	6a 43                	push   $0x43
  800fe8:	68 e5 2b 80 00       	push   $0x802be5
  800fed:	e8 f2 f2 ff ff       	call   8002e4 <_panic>

00800ff2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
  800ff8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801006:	b8 08 00 00 00       	mov    $0x8,%eax
  80100b:	89 df                	mov    %ebx,%edi
  80100d:	89 de                	mov    %ebx,%esi
  80100f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801011:	85 c0                	test   %eax,%eax
  801013:	7f 08                	jg     80101d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801015:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	50                   	push   %eax
  801021:	6a 08                	push   $0x8
  801023:	68 c8 2b 80 00       	push   $0x802bc8
  801028:	6a 43                	push   $0x43
  80102a:	68 e5 2b 80 00       	push   $0x802be5
  80102f:	e8 b0 f2 ff ff       	call   8002e4 <_panic>

00801034 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
  80103a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801042:	8b 55 08             	mov    0x8(%ebp),%edx
  801045:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801048:	b8 09 00 00 00       	mov    $0x9,%eax
  80104d:	89 df                	mov    %ebx,%edi
  80104f:	89 de                	mov    %ebx,%esi
  801051:	cd 30                	int    $0x30
	if(check && ret > 0)
  801053:	85 c0                	test   %eax,%eax
  801055:	7f 08                	jg     80105f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801057:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105f:	83 ec 0c             	sub    $0xc,%esp
  801062:	50                   	push   %eax
  801063:	6a 09                	push   $0x9
  801065:	68 c8 2b 80 00       	push   $0x802bc8
  80106a:	6a 43                	push   $0x43
  80106c:	68 e5 2b 80 00       	push   $0x802be5
  801071:	e8 6e f2 ff ff       	call   8002e4 <_panic>

00801076 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80107f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80108f:	89 df                	mov    %ebx,%edi
  801091:	89 de                	mov    %ebx,%esi
  801093:	cd 30                	int    $0x30
	if(check && ret > 0)
  801095:	85 c0                	test   %eax,%eax
  801097:	7f 08                	jg     8010a1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801099:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	50                   	push   %eax
  8010a5:	6a 0a                	push   $0xa
  8010a7:	68 c8 2b 80 00       	push   $0x802bc8
  8010ac:	6a 43                	push   $0x43
  8010ae:	68 e5 2b 80 00       	push   $0x802be5
  8010b3:	e8 2c f2 ff ff       	call   8002e4 <_panic>

008010b8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010be:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c9:	be 00 00 00 00       	mov    $0x0,%esi
  8010ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010d1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d6:	5b                   	pop    %ebx
  8010d7:	5e                   	pop    %esi
  8010d8:	5f                   	pop    %edi
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
  8010e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010f1:	89 cb                	mov    %ecx,%ebx
  8010f3:	89 cf                	mov    %ecx,%edi
  8010f5:	89 ce                	mov    %ecx,%esi
  8010f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	7f 08                	jg     801105 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	50                   	push   %eax
  801109:	6a 0d                	push   $0xd
  80110b:	68 c8 2b 80 00       	push   $0x802bc8
  801110:	6a 43                	push   $0x43
  801112:	68 e5 2b 80 00       	push   $0x802be5
  801117:	e8 c8 f1 ff ff       	call   8002e4 <_panic>

0080111c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
	asm volatile("int %1\n"
  801122:	bb 00 00 00 00       	mov    $0x0,%ebx
  801127:	8b 55 08             	mov    0x8(%ebp),%edx
  80112a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801132:	89 df                	mov    %ebx,%edi
  801134:	89 de                	mov    %ebx,%esi
  801136:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	5f                   	pop    %edi
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	57                   	push   %edi
  801141:	56                   	push   %esi
  801142:	53                   	push   %ebx
	asm volatile("int %1\n"
  801143:	b9 00 00 00 00       	mov    $0x0,%ecx
  801148:	8b 55 08             	mov    0x8(%ebp),%edx
  80114b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801150:	89 cb                	mov    %ecx,%ebx
  801152:	89 cf                	mov    %ecx,%edi
  801154:	89 ce                	mov    %ecx,%esi
  801156:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5f                   	pop    %edi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
	asm volatile("int %1\n"
  801163:	ba 00 00 00 00       	mov    $0x0,%edx
  801168:	b8 10 00 00 00       	mov    $0x10,%eax
  80116d:	89 d1                	mov    %edx,%ecx
  80116f:	89 d3                	mov    %edx,%ebx
  801171:	89 d7                	mov    %edx,%edi
  801173:	89 d6                	mov    %edx,%esi
  801175:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	57                   	push   %edi
  801180:	56                   	push   %esi
  801181:	53                   	push   %ebx
	asm volatile("int %1\n"
  801182:	bb 00 00 00 00       	mov    $0x0,%ebx
  801187:	8b 55 08             	mov    0x8(%ebp),%edx
  80118a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118d:	b8 11 00 00 00       	mov    $0x11,%eax
  801192:	89 df                	mov    %ebx,%edi
  801194:	89 de                	mov    %ebx,%esi
  801196:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5f                   	pop    %edi
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    

0080119d <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	57                   	push   %edi
  8011a1:	56                   	push   %esi
  8011a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ae:	b8 12 00 00 00       	mov    $0x12,%eax
  8011b3:	89 df                	mov    %ebx,%edi
  8011b5:	89 de                	mov    %ebx,%esi
  8011b7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011b9:	5b                   	pop    %ebx
  8011ba:	5e                   	pop    %esi
  8011bb:	5f                   	pop    %edi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	57                   	push   %edi
  8011c2:	56                   	push   %esi
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d2:	b8 13 00 00 00       	mov    $0x13,%eax
  8011d7:	89 df                	mov    %ebx,%edi
  8011d9:	89 de                	mov    %ebx,%esi
  8011db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	7f 08                	jg     8011e9 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e4:	5b                   	pop    %ebx
  8011e5:	5e                   	pop    %esi
  8011e6:	5f                   	pop    %edi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	50                   	push   %eax
  8011ed:	6a 13                	push   $0x13
  8011ef:	68 c8 2b 80 00       	push   $0x802bc8
  8011f4:	6a 43                	push   $0x43
  8011f6:	68 e5 2b 80 00       	push   $0x802be5
  8011fb:	e8 e4 f0 ff ff       	call   8002e4 <_panic>

00801200 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
	asm volatile("int %1\n"
  801206:	b9 00 00 00 00       	mov    $0x0,%ecx
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	b8 14 00 00 00       	mov    $0x14,%eax
  801213:	89 cb                	mov    %ecx,%ebx
  801215:	89 cf                	mov    %ecx,%edi
  801217:	89 ce                	mov    %ecx,%esi
  801219:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	05 00 00 00 30       	add    $0x30000000,%eax
  80122b:	c1 e8 0c             	shr    $0xc,%eax
}
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80123b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801240:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80124f:	89 c2                	mov    %eax,%edx
  801251:	c1 ea 16             	shr    $0x16,%edx
  801254:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80125b:	f6 c2 01             	test   $0x1,%dl
  80125e:	74 2d                	je     80128d <fd_alloc+0x46>
  801260:	89 c2                	mov    %eax,%edx
  801262:	c1 ea 0c             	shr    $0xc,%edx
  801265:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126c:	f6 c2 01             	test   $0x1,%dl
  80126f:	74 1c                	je     80128d <fd_alloc+0x46>
  801271:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801276:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80127b:	75 d2                	jne    80124f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801286:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80128b:	eb 0a                	jmp    801297 <fd_alloc+0x50>
			*fd_store = fd;
  80128d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801290:	89 01                	mov    %eax,(%ecx)
			return 0;
  801292:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80129f:	83 f8 1f             	cmp    $0x1f,%eax
  8012a2:	77 30                	ja     8012d4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012a4:	c1 e0 0c             	shl    $0xc,%eax
  8012a7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012ac:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012b2:	f6 c2 01             	test   $0x1,%dl
  8012b5:	74 24                	je     8012db <fd_lookup+0x42>
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	c1 ea 0c             	shr    $0xc,%edx
  8012bc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c3:	f6 c2 01             	test   $0x1,%dl
  8012c6:	74 1a                	je     8012e2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cb:	89 02                	mov    %eax,(%edx)
	return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    
		return -E_INVAL;
  8012d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d9:	eb f7                	jmp    8012d2 <fd_lookup+0x39>
		return -E_INVAL;
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e0:	eb f0                	jmp    8012d2 <fd_lookup+0x39>
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	eb e9                	jmp    8012d2 <fd_lookup+0x39>

008012e9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012fc:	39 08                	cmp    %ecx,(%eax)
  8012fe:	74 38                	je     801338 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801300:	83 c2 01             	add    $0x1,%edx
  801303:	8b 04 95 74 2c 80 00 	mov    0x802c74(,%edx,4),%eax
  80130a:	85 c0                	test   %eax,%eax
  80130c:	75 ee                	jne    8012fc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80130e:	a1 08 40 80 00       	mov    0x804008,%eax
  801313:	8b 40 48             	mov    0x48(%eax),%eax
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	51                   	push   %ecx
  80131a:	50                   	push   %eax
  80131b:	68 f4 2b 80 00       	push   $0x802bf4
  801320:	e8 b5 f0 ff ff       	call   8003da <cprintf>
	*dev = 0;
  801325:	8b 45 0c             	mov    0xc(%ebp),%eax
  801328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    
			*dev = devtab[i];
  801338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb f2                	jmp    801336 <dev_lookup+0x4d>

00801344 <fd_close>:
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	57                   	push   %edi
  801348:	56                   	push   %esi
  801349:	53                   	push   %ebx
  80134a:	83 ec 24             	sub    $0x24,%esp
  80134d:	8b 75 08             	mov    0x8(%ebp),%esi
  801350:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801353:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801356:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801357:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80135d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801360:	50                   	push   %eax
  801361:	e8 33 ff ff ff       	call   801299 <fd_lookup>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 05                	js     801374 <fd_close+0x30>
	    || fd != fd2)
  80136f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801372:	74 16                	je     80138a <fd_close+0x46>
		return (must_exist ? r : 0);
  801374:	89 f8                	mov    %edi,%eax
  801376:	84 c0                	test   %al,%al
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
  80137d:	0f 44 d8             	cmove  %eax,%ebx
}
  801380:	89 d8                	mov    %ebx,%eax
  801382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801390:	50                   	push   %eax
  801391:	ff 36                	pushl  (%esi)
  801393:	e8 51 ff ff ff       	call   8012e9 <dev_lookup>
  801398:	89 c3                	mov    %eax,%ebx
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 1a                	js     8013bb <fd_close+0x77>
		if (dev->dev_close)
  8013a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	74 0b                	je     8013bb <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013b0:	83 ec 0c             	sub    $0xc,%esp
  8013b3:	56                   	push   %esi
  8013b4:	ff d0                	call   *%eax
  8013b6:	89 c3                	mov    %eax,%ebx
  8013b8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	56                   	push   %esi
  8013bf:	6a 00                	push   $0x0
  8013c1:	e8 ea fb ff ff       	call   800fb0 <sys_page_unmap>
	return r;
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	eb b5                	jmp    801380 <fd_close+0x3c>

008013cb <close>:

int
close(int fdnum)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 08             	pushl  0x8(%ebp)
  8013d8:	e8 bc fe ff ff       	call   801299 <fd_lookup>
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	79 02                	jns    8013e6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    
		return fd_close(fd, 1);
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	6a 01                	push   $0x1
  8013eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ee:	e8 51 ff ff ff       	call   801344 <fd_close>
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	eb ec                	jmp    8013e4 <close+0x19>

008013f8 <close_all>:

void
close_all(void)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	53                   	push   %ebx
  8013fc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801404:	83 ec 0c             	sub    $0xc,%esp
  801407:	53                   	push   %ebx
  801408:	e8 be ff ff ff       	call   8013cb <close>
	for (i = 0; i < MAXFD; i++)
  80140d:	83 c3 01             	add    $0x1,%ebx
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	83 fb 20             	cmp    $0x20,%ebx
  801416:	75 ec                	jne    801404 <close_all+0xc>
}
  801418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801426:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	ff 75 08             	pushl  0x8(%ebp)
  80142d:	e8 67 fe ff ff       	call   801299 <fd_lookup>
  801432:	89 c3                	mov    %eax,%ebx
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	0f 88 81 00 00 00    	js     8014c0 <dup+0xa3>
		return r;
	close(newfdnum);
  80143f:	83 ec 0c             	sub    $0xc,%esp
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	e8 81 ff ff ff       	call   8013cb <close>

	newfd = INDEX2FD(newfdnum);
  80144a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80144d:	c1 e6 0c             	shl    $0xc,%esi
  801450:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801456:	83 c4 04             	add    $0x4,%esp
  801459:	ff 75 e4             	pushl  -0x1c(%ebp)
  80145c:	e8 cf fd ff ff       	call   801230 <fd2data>
  801461:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801463:	89 34 24             	mov    %esi,(%esp)
  801466:	e8 c5 fd ff ff       	call   801230 <fd2data>
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801470:	89 d8                	mov    %ebx,%eax
  801472:	c1 e8 16             	shr    $0x16,%eax
  801475:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80147c:	a8 01                	test   $0x1,%al
  80147e:	74 11                	je     801491 <dup+0x74>
  801480:	89 d8                	mov    %ebx,%eax
  801482:	c1 e8 0c             	shr    $0xc,%eax
  801485:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80148c:	f6 c2 01             	test   $0x1,%dl
  80148f:	75 39                	jne    8014ca <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801491:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801494:	89 d0                	mov    %edx,%eax
  801496:	c1 e8 0c             	shr    $0xc,%eax
  801499:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a8:	50                   	push   %eax
  8014a9:	56                   	push   %esi
  8014aa:	6a 00                	push   $0x0
  8014ac:	52                   	push   %edx
  8014ad:	6a 00                	push   $0x0
  8014af:	e8 ba fa ff ff       	call   800f6e <sys_page_map>
  8014b4:	89 c3                	mov    %eax,%ebx
  8014b6:	83 c4 20             	add    $0x20,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 31                	js     8014ee <dup+0xd1>
		goto err;

	return newfdnum;
  8014bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014c0:	89 d8                	mov    %ebx,%eax
  8014c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014d1:	83 ec 0c             	sub    $0xc,%esp
  8014d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d9:	50                   	push   %eax
  8014da:	57                   	push   %edi
  8014db:	6a 00                	push   $0x0
  8014dd:	53                   	push   %ebx
  8014de:	6a 00                	push   $0x0
  8014e0:	e8 89 fa ff ff       	call   800f6e <sys_page_map>
  8014e5:	89 c3                	mov    %eax,%ebx
  8014e7:	83 c4 20             	add    $0x20,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	79 a3                	jns    801491 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	56                   	push   %esi
  8014f2:	6a 00                	push   $0x0
  8014f4:	e8 b7 fa ff ff       	call   800fb0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014f9:	83 c4 08             	add    $0x8,%esp
  8014fc:	57                   	push   %edi
  8014fd:	6a 00                	push   $0x0
  8014ff:	e8 ac fa ff ff       	call   800fb0 <sys_page_unmap>
	return r;
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	eb b7                	jmp    8014c0 <dup+0xa3>

00801509 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	53                   	push   %ebx
  80150d:	83 ec 1c             	sub    $0x1c,%esp
  801510:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801513:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801516:	50                   	push   %eax
  801517:	53                   	push   %ebx
  801518:	e8 7c fd ff ff       	call   801299 <fd_lookup>
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 3f                	js     801563 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152e:	ff 30                	pushl  (%eax)
  801530:	e8 b4 fd ff ff       	call   8012e9 <dev_lookup>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 27                	js     801563 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80153c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153f:	8b 42 08             	mov    0x8(%edx),%eax
  801542:	83 e0 03             	and    $0x3,%eax
  801545:	83 f8 01             	cmp    $0x1,%eax
  801548:	74 1e                	je     801568 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154d:	8b 40 08             	mov    0x8(%eax),%eax
  801550:	85 c0                	test   %eax,%eax
  801552:	74 35                	je     801589 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	ff 75 10             	pushl  0x10(%ebp)
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	52                   	push   %edx
  80155e:	ff d0                	call   *%eax
  801560:	83 c4 10             	add    $0x10,%esp
}
  801563:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801566:	c9                   	leave  
  801567:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801568:	a1 08 40 80 00       	mov    0x804008,%eax
  80156d:	8b 40 48             	mov    0x48(%eax),%eax
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	53                   	push   %ebx
  801574:	50                   	push   %eax
  801575:	68 38 2c 80 00       	push   $0x802c38
  80157a:	e8 5b ee ff ff       	call   8003da <cprintf>
		return -E_INVAL;
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801587:	eb da                	jmp    801563 <read+0x5a>
		return -E_NOT_SUPP;
  801589:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158e:	eb d3                	jmp    801563 <read+0x5a>

00801590 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	57                   	push   %edi
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	8b 7d 08             	mov    0x8(%ebp),%edi
  80159c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80159f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a4:	39 f3                	cmp    %esi,%ebx
  8015a6:	73 23                	jae    8015cb <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	89 f0                	mov    %esi,%eax
  8015ad:	29 d8                	sub    %ebx,%eax
  8015af:	50                   	push   %eax
  8015b0:	89 d8                	mov    %ebx,%eax
  8015b2:	03 45 0c             	add    0xc(%ebp),%eax
  8015b5:	50                   	push   %eax
  8015b6:	57                   	push   %edi
  8015b7:	e8 4d ff ff ff       	call   801509 <read>
		if (m < 0)
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 06                	js     8015c9 <readn+0x39>
			return m;
		if (m == 0)
  8015c3:	74 06                	je     8015cb <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015c5:	01 c3                	add    %eax,%ebx
  8015c7:	eb db                	jmp    8015a4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015cb:	89 d8                	mov    %ebx,%eax
  8015cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d0:	5b                   	pop    %ebx
  8015d1:	5e                   	pop    %esi
  8015d2:	5f                   	pop    %edi
  8015d3:	5d                   	pop    %ebp
  8015d4:	c3                   	ret    

008015d5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 1c             	sub    $0x1c,%esp
  8015dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e2:	50                   	push   %eax
  8015e3:	53                   	push   %ebx
  8015e4:	e8 b0 fc ff ff       	call   801299 <fd_lookup>
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 3a                	js     80162a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fa:	ff 30                	pushl  (%eax)
  8015fc:	e8 e8 fc ff ff       	call   8012e9 <dev_lookup>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	85 c0                	test   %eax,%eax
  801606:	78 22                	js     80162a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160f:	74 1e                	je     80162f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801614:	8b 52 0c             	mov    0xc(%edx),%edx
  801617:	85 d2                	test   %edx,%edx
  801619:	74 35                	je     801650 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	ff 75 10             	pushl  0x10(%ebp)
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	50                   	push   %eax
  801625:	ff d2                	call   *%edx
  801627:	83 c4 10             	add    $0x10,%esp
}
  80162a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80162f:	a1 08 40 80 00       	mov    0x804008,%eax
  801634:	8b 40 48             	mov    0x48(%eax),%eax
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	53                   	push   %ebx
  80163b:	50                   	push   %eax
  80163c:	68 54 2c 80 00       	push   $0x802c54
  801641:	e8 94 ed ff ff       	call   8003da <cprintf>
		return -E_INVAL;
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164e:	eb da                	jmp    80162a <write+0x55>
		return -E_NOT_SUPP;
  801650:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801655:	eb d3                	jmp    80162a <write+0x55>

00801657 <seek>:

int
seek(int fdnum, off_t offset)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80165d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801660:	50                   	push   %eax
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	e8 30 fc ff ff       	call   801299 <fd_lookup>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 0e                	js     80167e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801676:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801679:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	53                   	push   %ebx
  801684:	83 ec 1c             	sub    $0x1c,%esp
  801687:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	53                   	push   %ebx
  80168f:	e8 05 fc ff ff       	call   801299 <fd_lookup>
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	78 37                	js     8016d2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a1:	50                   	push   %eax
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	ff 30                	pushl  (%eax)
  8016a7:	e8 3d fc ff ff       	call   8012e9 <dev_lookup>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 1f                	js     8016d2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ba:	74 1b                	je     8016d7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bf:	8b 52 18             	mov    0x18(%edx),%edx
  8016c2:	85 d2                	test   %edx,%edx
  8016c4:	74 32                	je     8016f8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	50                   	push   %eax
  8016cd:	ff d2                	call   *%edx
  8016cf:	83 c4 10             	add    $0x10,%esp
}
  8016d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016d7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016dc:	8b 40 48             	mov    0x48(%eax),%eax
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	53                   	push   %ebx
  8016e3:	50                   	push   %eax
  8016e4:	68 14 2c 80 00       	push   $0x802c14
  8016e9:	e8 ec ec ff ff       	call   8003da <cprintf>
		return -E_INVAL;
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f6:	eb da                	jmp    8016d2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fd:	eb d3                	jmp    8016d2 <ftruncate+0x52>

008016ff <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	53                   	push   %ebx
  801703:	83 ec 1c             	sub    $0x1c,%esp
  801706:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801709:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170c:	50                   	push   %eax
  80170d:	ff 75 08             	pushl  0x8(%ebp)
  801710:	e8 84 fb ff ff       	call   801299 <fd_lookup>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 4b                	js     801767 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801722:	50                   	push   %eax
  801723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801726:	ff 30                	pushl  (%eax)
  801728:	e8 bc fb ff ff       	call   8012e9 <dev_lookup>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	78 33                	js     801767 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80173b:	74 2f                	je     80176c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80173d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801740:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801747:	00 00 00 
	stat->st_isdir = 0;
  80174a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801751:	00 00 00 
	stat->st_dev = dev;
  801754:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80175a:	83 ec 08             	sub    $0x8,%esp
  80175d:	53                   	push   %ebx
  80175e:	ff 75 f0             	pushl  -0x10(%ebp)
  801761:	ff 50 14             	call   *0x14(%eax)
  801764:	83 c4 10             	add    $0x10,%esp
}
  801767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    
		return -E_NOT_SUPP;
  80176c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801771:	eb f4                	jmp    801767 <fstat+0x68>

00801773 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	56                   	push   %esi
  801777:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	6a 00                	push   $0x0
  80177d:	ff 75 08             	pushl  0x8(%ebp)
  801780:	e8 22 02 00 00       	call   8019a7 <open>
  801785:	89 c3                	mov    %eax,%ebx
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 1b                	js     8017a9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	50                   	push   %eax
  801795:	e8 65 ff ff ff       	call   8016ff <fstat>
  80179a:	89 c6                	mov    %eax,%esi
	close(fd);
  80179c:	89 1c 24             	mov    %ebx,(%esp)
  80179f:	e8 27 fc ff ff       	call   8013cb <close>
	return r;
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	89 f3                	mov    %esi,%ebx
}
  8017a9:	89 d8                	mov    %ebx,%eax
  8017ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    

008017b2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	56                   	push   %esi
  8017b6:	53                   	push   %ebx
  8017b7:	89 c6                	mov    %eax,%esi
  8017b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017bb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017c2:	74 27                	je     8017eb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017c4:	6a 07                	push   $0x7
  8017c6:	68 00 50 80 00       	push   $0x805000
  8017cb:	56                   	push   %esi
  8017cc:	ff 35 00 40 80 00    	pushl  0x804000
  8017d2:	e8 08 0c 00 00       	call   8023df <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017d7:	83 c4 0c             	add    $0xc,%esp
  8017da:	6a 00                	push   $0x0
  8017dc:	53                   	push   %ebx
  8017dd:	6a 00                	push   $0x0
  8017df:	e8 92 0b 00 00       	call   802376 <ipc_recv>
}
  8017e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e7:	5b                   	pop    %ebx
  8017e8:	5e                   	pop    %esi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	6a 01                	push   $0x1
  8017f0:	e8 42 0c 00 00       	call   802437 <ipc_find_env>
  8017f5:	a3 00 40 80 00       	mov    %eax,0x804000
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	eb c5                	jmp    8017c4 <fsipc+0x12>

008017ff <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8b 40 0c             	mov    0xc(%eax),%eax
  80180b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801818:	ba 00 00 00 00       	mov    $0x0,%edx
  80181d:	b8 02 00 00 00       	mov    $0x2,%eax
  801822:	e8 8b ff ff ff       	call   8017b2 <fsipc>
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <devfile_flush>:
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8b 40 0c             	mov    0xc(%eax),%eax
  801835:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80183a:	ba 00 00 00 00       	mov    $0x0,%edx
  80183f:	b8 06 00 00 00       	mov    $0x6,%eax
  801844:	e8 69 ff ff ff       	call   8017b2 <fsipc>
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <devfile_stat>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	53                   	push   %ebx
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	8b 40 0c             	mov    0xc(%eax),%eax
  80185b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801860:	ba 00 00 00 00       	mov    $0x0,%edx
  801865:	b8 05 00 00 00       	mov    $0x5,%eax
  80186a:	e8 43 ff ff ff       	call   8017b2 <fsipc>
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 2c                	js     80189f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	68 00 50 80 00       	push   $0x805000
  80187b:	53                   	push   %ebx
  80187c:	e8 b8 f2 ff ff       	call   800b39 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801881:	a1 80 50 80 00       	mov    0x805080,%eax
  801886:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80188c:	a1 84 50 80 00       	mov    0x805084,%eax
  801891:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <devfile_write>:
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018b9:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018bf:	53                   	push   %ebx
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	68 08 50 80 00       	push   $0x805008
  8018c8:	e8 5c f4 ff ff       	call   800d29 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d2:	b8 04 00 00 00       	mov    $0x4,%eax
  8018d7:	e8 d6 fe ff ff       	call   8017b2 <fsipc>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 0b                	js     8018ee <devfile_write+0x4a>
	assert(r <= n);
  8018e3:	39 d8                	cmp    %ebx,%eax
  8018e5:	77 0c                	ja     8018f3 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018e7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ec:	7f 1e                	jg     80190c <devfile_write+0x68>
}
  8018ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    
	assert(r <= n);
  8018f3:	68 88 2c 80 00       	push   $0x802c88
  8018f8:	68 8f 2c 80 00       	push   $0x802c8f
  8018fd:	68 98 00 00 00       	push   $0x98
  801902:	68 a4 2c 80 00       	push   $0x802ca4
  801907:	e8 d8 e9 ff ff       	call   8002e4 <_panic>
	assert(r <= PGSIZE);
  80190c:	68 af 2c 80 00       	push   $0x802caf
  801911:	68 8f 2c 80 00       	push   $0x802c8f
  801916:	68 99 00 00 00       	push   $0x99
  80191b:	68 a4 2c 80 00       	push   $0x802ca4
  801920:	e8 bf e9 ff ff       	call   8002e4 <_panic>

00801925 <devfile_read>:
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	56                   	push   %esi
  801929:	53                   	push   %ebx
  80192a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	8b 40 0c             	mov    0xc(%eax),%eax
  801933:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801938:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	b8 03 00 00 00       	mov    $0x3,%eax
  801948:	e8 65 fe ff ff       	call   8017b2 <fsipc>
  80194d:	89 c3                	mov    %eax,%ebx
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 1f                	js     801972 <devfile_read+0x4d>
	assert(r <= n);
  801953:	39 f0                	cmp    %esi,%eax
  801955:	77 24                	ja     80197b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801957:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80195c:	7f 33                	jg     801991 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	50                   	push   %eax
  801962:	68 00 50 80 00       	push   $0x805000
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	e8 58 f3 ff ff       	call   800cc7 <memmove>
	return r;
  80196f:	83 c4 10             	add    $0x10,%esp
}
  801972:	89 d8                	mov    %ebx,%eax
  801974:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    
	assert(r <= n);
  80197b:	68 88 2c 80 00       	push   $0x802c88
  801980:	68 8f 2c 80 00       	push   $0x802c8f
  801985:	6a 7c                	push   $0x7c
  801987:	68 a4 2c 80 00       	push   $0x802ca4
  80198c:	e8 53 e9 ff ff       	call   8002e4 <_panic>
	assert(r <= PGSIZE);
  801991:	68 af 2c 80 00       	push   $0x802caf
  801996:	68 8f 2c 80 00       	push   $0x802c8f
  80199b:	6a 7d                	push   $0x7d
  80199d:	68 a4 2c 80 00       	push   $0x802ca4
  8019a2:	e8 3d e9 ff ff       	call   8002e4 <_panic>

008019a7 <open>:
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
  8019ac:	83 ec 1c             	sub    $0x1c,%esp
  8019af:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019b2:	56                   	push   %esi
  8019b3:	e8 48 f1 ff ff       	call   800b00 <strlen>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019c0:	7f 6c                	jg     801a2e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019c2:	83 ec 0c             	sub    $0xc,%esp
  8019c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c8:	50                   	push   %eax
  8019c9:	e8 79 f8 ff ff       	call   801247 <fd_alloc>
  8019ce:	89 c3                	mov    %eax,%ebx
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	78 3c                	js     801a13 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019d7:	83 ec 08             	sub    $0x8,%esp
  8019da:	56                   	push   %esi
  8019db:	68 00 50 80 00       	push   $0x805000
  8019e0:	e8 54 f1 ff ff       	call   800b39 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f5:	e8 b8 fd ff ff       	call   8017b2 <fsipc>
  8019fa:	89 c3                	mov    %eax,%ebx
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 19                	js     801a1c <open+0x75>
	return fd2num(fd);
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	ff 75 f4             	pushl  -0xc(%ebp)
  801a09:	e8 12 f8 ff ff       	call   801220 <fd2num>
  801a0e:	89 c3                	mov    %eax,%ebx
  801a10:	83 c4 10             	add    $0x10,%esp
}
  801a13:	89 d8                	mov    %ebx,%eax
  801a15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a18:	5b                   	pop    %ebx
  801a19:	5e                   	pop    %esi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
		fd_close(fd, 0);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 f4             	pushl  -0xc(%ebp)
  801a24:	e8 1b f9 ff ff       	call   801344 <fd_close>
		return r;
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	eb e5                	jmp    801a13 <open+0x6c>
		return -E_BAD_PATH;
  801a2e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a33:	eb de                	jmp    801a13 <open+0x6c>

00801a35 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a40:	b8 08 00 00 00       	mov    $0x8,%eax
  801a45:	e8 68 fd ff ff       	call   8017b2 <fsipc>
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a52:	68 bb 2c 80 00       	push   $0x802cbb
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	e8 da f0 ff ff       	call   800b39 <strcpy>
	return 0;
}
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <devsock_close>:
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 10             	sub    $0x10,%esp
  801a6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a70:	53                   	push   %ebx
  801a71:	e8 00 0a 00 00       	call   802476 <pageref>
  801a76:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a79:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a7e:	83 f8 01             	cmp    $0x1,%eax
  801a81:	74 07                	je     801a8a <devsock_close+0x24>
}
  801a83:	89 d0                	mov    %edx,%eax
  801a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	ff 73 0c             	pushl  0xc(%ebx)
  801a90:	e8 b9 02 00 00       	call   801d4e <nsipc_close>
  801a95:	89 c2                	mov    %eax,%edx
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	eb e7                	jmp    801a83 <devsock_close+0x1d>

00801a9c <devsock_write>:
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	ff 75 10             	pushl  0x10(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	ff 70 0c             	pushl  0xc(%eax)
  801ab0:	e8 76 03 00 00       	call   801e2b <nsipc_send>
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <devsock_read>:
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	ff 75 10             	pushl  0x10(%ebp)
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff 70 0c             	pushl  0xc(%eax)
  801acb:	e8 ef 02 00 00       	call   801dbf <nsipc_recv>
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <fd2sockid>:
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ad8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	e8 b7 f7 ff ff       	call   801299 <fd_lookup>
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	78 10                	js     801af9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801af2:	39 08                	cmp    %ecx,(%eax)
  801af4:	75 05                	jne    801afb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801af6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    
		return -E_NOT_SUPP;
  801afb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b00:	eb f7                	jmp    801af9 <fd2sockid+0x27>

00801b02 <alloc_sockfd>:
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	56                   	push   %esi
  801b06:	53                   	push   %ebx
  801b07:	83 ec 1c             	sub    $0x1c,%esp
  801b0a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0f:	50                   	push   %eax
  801b10:	e8 32 f7 ff ff       	call   801247 <fd_alloc>
  801b15:	89 c3                	mov    %eax,%ebx
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 43                	js     801b61 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b1e:	83 ec 04             	sub    $0x4,%esp
  801b21:	68 07 04 00 00       	push   $0x407
  801b26:	ff 75 f4             	pushl  -0xc(%ebp)
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 fb f3 ff ff       	call   800f2b <sys_page_alloc>
  801b30:	89 c3                	mov    %eax,%ebx
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 28                	js     801b61 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b42:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b4e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b51:	83 ec 0c             	sub    $0xc,%esp
  801b54:	50                   	push   %eax
  801b55:	e8 c6 f6 ff ff       	call   801220 <fd2num>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	eb 0c                	jmp    801b6d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	56                   	push   %esi
  801b65:	e8 e4 01 00 00       	call   801d4e <nsipc_close>
		return r;
  801b6a:	83 c4 10             	add    $0x10,%esp
}
  801b6d:	89 d8                	mov    %ebx,%eax
  801b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5d                   	pop    %ebp
  801b75:	c3                   	ret    

00801b76 <accept>:
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	e8 4e ff ff ff       	call   801ad2 <fd2sockid>
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 1b                	js     801ba3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	ff 75 10             	pushl  0x10(%ebp)
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	50                   	push   %eax
  801b92:	e8 0e 01 00 00       	call   801ca5 <nsipc_accept>
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 05                	js     801ba3 <accept+0x2d>
	return alloc_sockfd(r);
  801b9e:	e8 5f ff ff ff       	call   801b02 <alloc_sockfd>
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <bind>:
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	e8 1f ff ff ff       	call   801ad2 <fd2sockid>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 12                	js     801bc9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	e8 31 01 00 00       	call   801cf7 <nsipc_bind>
  801bc6:	83 c4 10             	add    $0x10,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <shutdown>:
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	e8 f9 fe ff ff       	call   801ad2 <fd2sockid>
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 0f                	js     801bec <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	50                   	push   %eax
  801be4:	e8 43 01 00 00       	call   801d2c <nsipc_shutdown>
  801be9:	83 c4 10             	add    $0x10,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <connect>:
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	e8 d6 fe ff ff       	call   801ad2 <fd2sockid>
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 12                	js     801c12 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	ff 75 10             	pushl  0x10(%ebp)
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	50                   	push   %eax
  801c0a:	e8 59 01 00 00       	call   801d68 <nsipc_connect>
  801c0f:	83 c4 10             	add    $0x10,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <listen>:
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	e8 b0 fe ff ff       	call   801ad2 <fd2sockid>
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 0f                	js     801c35 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c26:	83 ec 08             	sub    $0x8,%esp
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	50                   	push   %eax
  801c2d:	e8 6b 01 00 00       	call   801d9d <nsipc_listen>
  801c32:	83 c4 10             	add    $0x10,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c3d:	ff 75 10             	pushl  0x10(%ebp)
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	e8 3e 02 00 00       	call   801e89 <nsipc_socket>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 05                	js     801c57 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c52:	e8 ab fe ff ff       	call   801b02 <alloc_sockfd>
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c62:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c69:	74 26                	je     801c91 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c6b:	6a 07                	push   $0x7
  801c6d:	68 00 60 80 00       	push   $0x806000
  801c72:	53                   	push   %ebx
  801c73:	ff 35 04 40 80 00    	pushl  0x804004
  801c79:	e8 61 07 00 00       	call   8023df <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c7e:	83 c4 0c             	add    $0xc,%esp
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	e8 ea 06 00 00       	call   802376 <ipc_recv>
}
  801c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	6a 02                	push   $0x2
  801c96:	e8 9c 07 00 00       	call   802437 <ipc_find_env>
  801c9b:	a3 04 40 80 00       	mov    %eax,0x804004
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	eb c6                	jmp    801c6b <nsipc+0x12>

00801ca5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	56                   	push   %esi
  801ca9:	53                   	push   %ebx
  801caa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cb5:	8b 06                	mov    (%esi),%eax
  801cb7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cbc:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc1:	e8 93 ff ff ff       	call   801c59 <nsipc>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	79 09                	jns    801cd5 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ccc:	89 d8                	mov    %ebx,%eax
  801cce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd1:	5b                   	pop    %ebx
  801cd2:	5e                   	pop    %esi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	ff 35 10 60 80 00    	pushl  0x806010
  801cde:	68 00 60 80 00       	push   $0x806000
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	e8 dc ef ff ff       	call   800cc7 <memmove>
		*addrlen = ret->ret_addrlen;
  801ceb:	a1 10 60 80 00       	mov    0x806010,%eax
  801cf0:	89 06                	mov    %eax,(%esi)
  801cf2:	83 c4 10             	add    $0x10,%esp
	return r;
  801cf5:	eb d5                	jmp    801ccc <nsipc_accept+0x27>

00801cf7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d09:	53                   	push   %ebx
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	68 04 60 80 00       	push   $0x806004
  801d12:	e8 b0 ef ff ff       	call   800cc7 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d17:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d1d:	b8 02 00 00 00       	mov    $0x2,%eax
  801d22:	e8 32 ff ff ff       	call   801c59 <nsipc>
}
  801d27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d42:	b8 03 00 00 00       	mov    $0x3,%eax
  801d47:	e8 0d ff ff ff       	call   801c59 <nsipc>
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <nsipc_close>:

int
nsipc_close(int s)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d5c:	b8 04 00 00 00       	mov    $0x4,%eax
  801d61:	e8 f3 fe ff ff       	call   801c59 <nsipc>
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d7a:	53                   	push   %ebx
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	68 04 60 80 00       	push   $0x806004
  801d83:	e8 3f ef ff ff       	call   800cc7 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d88:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d8e:	b8 05 00 00 00       	mov    $0x5,%eax
  801d93:	e8 c1 fe ff ff       	call   801c59 <nsipc>
}
  801d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dae:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801db3:	b8 06 00 00 00       	mov    $0x6,%eax
  801db8:	e8 9c fe ff ff       	call   801c59 <nsipc>
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dcf:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd8:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ddd:	b8 07 00 00 00       	mov    $0x7,%eax
  801de2:	e8 72 fe ff ff       	call   801c59 <nsipc>
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	85 c0                	test   %eax,%eax
  801deb:	78 1f                	js     801e0c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ded:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801df2:	7f 21                	jg     801e15 <nsipc_recv+0x56>
  801df4:	39 c6                	cmp    %eax,%esi
  801df6:	7c 1d                	jl     801e15 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801df8:	83 ec 04             	sub    $0x4,%esp
  801dfb:	50                   	push   %eax
  801dfc:	68 00 60 80 00       	push   $0x806000
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	e8 be ee ff ff       	call   800cc7 <memmove>
  801e09:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e0c:	89 d8                	mov    %ebx,%eax
  801e0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e11:	5b                   	pop    %ebx
  801e12:	5e                   	pop    %esi
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e15:	68 c7 2c 80 00       	push   $0x802cc7
  801e1a:	68 8f 2c 80 00       	push   $0x802c8f
  801e1f:	6a 62                	push   $0x62
  801e21:	68 dc 2c 80 00       	push   $0x802cdc
  801e26:	e8 b9 e4 ff ff       	call   8002e4 <_panic>

00801e2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e3d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e43:	7f 2e                	jg     801e73 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	53                   	push   %ebx
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	68 0c 60 80 00       	push   $0x80600c
  801e51:	e8 71 ee ff ff       	call   800cc7 <memmove>
	nsipcbuf.send.req_size = size;
  801e56:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e64:	b8 08 00 00 00       	mov    $0x8,%eax
  801e69:	e8 eb fd ff ff       	call   801c59 <nsipc>
}
  801e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    
	assert(size < 1600);
  801e73:	68 e8 2c 80 00       	push   $0x802ce8
  801e78:	68 8f 2c 80 00       	push   $0x802c8f
  801e7d:	6a 6d                	push   $0x6d
  801e7f:	68 dc 2c 80 00       	push   $0x802cdc
  801e84:	e8 5b e4 ff ff       	call   8002e4 <_panic>

00801e89 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ea7:	b8 09 00 00 00       	mov    $0x9,%eax
  801eac:	e8 a8 fd ff ff       	call   801c59 <nsipc>
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	ff 75 08             	pushl  0x8(%ebp)
  801ec1:	e8 6a f3 ff ff       	call   801230 <fd2data>
  801ec6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ec8:	83 c4 08             	add    $0x8,%esp
  801ecb:	68 f4 2c 80 00       	push   $0x802cf4
  801ed0:	53                   	push   %ebx
  801ed1:	e8 63 ec ff ff       	call   800b39 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ed6:	8b 46 04             	mov    0x4(%esi),%eax
  801ed9:	2b 06                	sub    (%esi),%eax
  801edb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ee1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ee8:	00 00 00 
	stat->st_dev = &devpipe;
  801eeb:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ef2:	30 80 00 
	return 0;
}
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	53                   	push   %ebx
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f0b:	53                   	push   %ebx
  801f0c:	6a 00                	push   $0x0
  801f0e:	e8 9d f0 ff ff       	call   800fb0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f13:	89 1c 24             	mov    %ebx,(%esp)
  801f16:	e8 15 f3 ff ff       	call   801230 <fd2data>
  801f1b:	83 c4 08             	add    $0x8,%esp
  801f1e:	50                   	push   %eax
  801f1f:	6a 00                	push   $0x0
  801f21:	e8 8a f0 ff ff       	call   800fb0 <sys_page_unmap>
}
  801f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <_pipeisclosed>:
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	57                   	push   %edi
  801f2f:	56                   	push   %esi
  801f30:	53                   	push   %ebx
  801f31:	83 ec 1c             	sub    $0x1c,%esp
  801f34:	89 c7                	mov    %eax,%edi
  801f36:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f38:	a1 08 40 80 00       	mov    0x804008,%eax
  801f3d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	57                   	push   %edi
  801f44:	e8 2d 05 00 00       	call   802476 <pageref>
  801f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f4c:	89 34 24             	mov    %esi,(%esp)
  801f4f:	e8 22 05 00 00       	call   802476 <pageref>
		nn = thisenv->env_runs;
  801f54:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f5a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	39 cb                	cmp    %ecx,%ebx
  801f62:	74 1b                	je     801f7f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f64:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f67:	75 cf                	jne    801f38 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f69:	8b 42 58             	mov    0x58(%edx),%eax
  801f6c:	6a 01                	push   $0x1
  801f6e:	50                   	push   %eax
  801f6f:	53                   	push   %ebx
  801f70:	68 fb 2c 80 00       	push   $0x802cfb
  801f75:	e8 60 e4 ff ff       	call   8003da <cprintf>
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	eb b9                	jmp    801f38 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f7f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f82:	0f 94 c0             	sete   %al
  801f85:	0f b6 c0             	movzbl %al,%eax
}
  801f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    

00801f90 <devpipe_write>:
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	57                   	push   %edi
  801f94:	56                   	push   %esi
  801f95:	53                   	push   %ebx
  801f96:	83 ec 28             	sub    $0x28,%esp
  801f99:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f9c:	56                   	push   %esi
  801f9d:	e8 8e f2 ff ff       	call   801230 <fd2data>
  801fa2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801faf:	74 4f                	je     802000 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fb1:	8b 43 04             	mov    0x4(%ebx),%eax
  801fb4:	8b 0b                	mov    (%ebx),%ecx
  801fb6:	8d 51 20             	lea    0x20(%ecx),%edx
  801fb9:	39 d0                	cmp    %edx,%eax
  801fbb:	72 14                	jb     801fd1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801fbd:	89 da                	mov    %ebx,%edx
  801fbf:	89 f0                	mov    %esi,%eax
  801fc1:	e8 65 ff ff ff       	call   801f2b <_pipeisclosed>
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	75 3b                	jne    802005 <devpipe_write+0x75>
			sys_yield();
  801fca:	e8 3d ef ff ff       	call   800f0c <sys_yield>
  801fcf:	eb e0                	jmp    801fb1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fd4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fd8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fdb:	89 c2                	mov    %eax,%edx
  801fdd:	c1 fa 1f             	sar    $0x1f,%edx
  801fe0:	89 d1                	mov    %edx,%ecx
  801fe2:	c1 e9 1b             	shr    $0x1b,%ecx
  801fe5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fe8:	83 e2 1f             	and    $0x1f,%edx
  801feb:	29 ca                	sub    %ecx,%edx
  801fed:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ff1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ff5:	83 c0 01             	add    $0x1,%eax
  801ff8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ffb:	83 c7 01             	add    $0x1,%edi
  801ffe:	eb ac                	jmp    801fac <devpipe_write+0x1c>
	return i;
  802000:	8b 45 10             	mov    0x10(%ebp),%eax
  802003:	eb 05                	jmp    80200a <devpipe_write+0x7a>
				return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200d:	5b                   	pop    %ebx
  80200e:	5e                   	pop    %esi
  80200f:	5f                   	pop    %edi
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    

00802012 <devpipe_read>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 18             	sub    $0x18,%esp
  80201b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80201e:	57                   	push   %edi
  80201f:	e8 0c f2 ff ff       	call   801230 <fd2data>
  802024:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	be 00 00 00 00       	mov    $0x0,%esi
  80202e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802031:	75 14                	jne    802047 <devpipe_read+0x35>
	return i;
  802033:	8b 45 10             	mov    0x10(%ebp),%eax
  802036:	eb 02                	jmp    80203a <devpipe_read+0x28>
				return i;
  802038:	89 f0                	mov    %esi,%eax
}
  80203a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5f                   	pop    %edi
  802040:	5d                   	pop    %ebp
  802041:	c3                   	ret    
			sys_yield();
  802042:	e8 c5 ee ff ff       	call   800f0c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802047:	8b 03                	mov    (%ebx),%eax
  802049:	3b 43 04             	cmp    0x4(%ebx),%eax
  80204c:	75 18                	jne    802066 <devpipe_read+0x54>
			if (i > 0)
  80204e:	85 f6                	test   %esi,%esi
  802050:	75 e6                	jne    802038 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802052:	89 da                	mov    %ebx,%edx
  802054:	89 f8                	mov    %edi,%eax
  802056:	e8 d0 fe ff ff       	call   801f2b <_pipeisclosed>
  80205b:	85 c0                	test   %eax,%eax
  80205d:	74 e3                	je     802042 <devpipe_read+0x30>
				return 0;
  80205f:	b8 00 00 00 00       	mov    $0x0,%eax
  802064:	eb d4                	jmp    80203a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802066:	99                   	cltd   
  802067:	c1 ea 1b             	shr    $0x1b,%edx
  80206a:	01 d0                	add    %edx,%eax
  80206c:	83 e0 1f             	and    $0x1f,%eax
  80206f:	29 d0                	sub    %edx,%eax
  802071:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802076:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802079:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80207c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80207f:	83 c6 01             	add    $0x1,%esi
  802082:	eb aa                	jmp    80202e <devpipe_read+0x1c>

00802084 <pipe>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
  802089:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80208c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208f:	50                   	push   %eax
  802090:	e8 b2 f1 ff ff       	call   801247 <fd_alloc>
  802095:	89 c3                	mov    %eax,%ebx
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	0f 88 23 01 00 00    	js     8021c5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	68 07 04 00 00       	push   $0x407
  8020aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ad:	6a 00                	push   $0x0
  8020af:	e8 77 ee ff ff       	call   800f2b <sys_page_alloc>
  8020b4:	89 c3                	mov    %eax,%ebx
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	0f 88 04 01 00 00    	js     8021c5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c7:	50                   	push   %eax
  8020c8:	e8 7a f1 ff ff       	call   801247 <fd_alloc>
  8020cd:	89 c3                	mov    %eax,%ebx
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	0f 88 db 00 00 00    	js     8021b5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	68 07 04 00 00       	push   $0x407
  8020e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e5:	6a 00                	push   $0x0
  8020e7:	e8 3f ee ff ff       	call   800f2b <sys_page_alloc>
  8020ec:	89 c3                	mov    %eax,%ebx
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	0f 88 bc 00 00 00    	js     8021b5 <pipe+0x131>
	va = fd2data(fd0);
  8020f9:	83 ec 0c             	sub    $0xc,%esp
  8020fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ff:	e8 2c f1 ff ff       	call   801230 <fd2data>
  802104:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802106:	83 c4 0c             	add    $0xc,%esp
  802109:	68 07 04 00 00       	push   $0x407
  80210e:	50                   	push   %eax
  80210f:	6a 00                	push   $0x0
  802111:	e8 15 ee ff ff       	call   800f2b <sys_page_alloc>
  802116:	89 c3                	mov    %eax,%ebx
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 88 82 00 00 00    	js     8021a5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	ff 75 f0             	pushl  -0x10(%ebp)
  802129:	e8 02 f1 ff ff       	call   801230 <fd2data>
  80212e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802135:	50                   	push   %eax
  802136:	6a 00                	push   $0x0
  802138:	56                   	push   %esi
  802139:	6a 00                	push   $0x0
  80213b:	e8 2e ee ff ff       	call   800f6e <sys_page_map>
  802140:	89 c3                	mov    %eax,%ebx
  802142:	83 c4 20             	add    $0x20,%esp
  802145:	85 c0                	test   %eax,%eax
  802147:	78 4e                	js     802197 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802149:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80214e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802151:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802156:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80215d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802160:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	ff 75 f4             	pushl  -0xc(%ebp)
  802172:	e8 a9 f0 ff ff       	call   801220 <fd2num>
  802177:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80217a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80217c:	83 c4 04             	add    $0x4,%esp
  80217f:	ff 75 f0             	pushl  -0x10(%ebp)
  802182:	e8 99 f0 ff ff       	call   801220 <fd2num>
  802187:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80218a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	bb 00 00 00 00       	mov    $0x0,%ebx
  802195:	eb 2e                	jmp    8021c5 <pipe+0x141>
	sys_page_unmap(0, va);
  802197:	83 ec 08             	sub    $0x8,%esp
  80219a:	56                   	push   %esi
  80219b:	6a 00                	push   $0x0
  80219d:	e8 0e ee ff ff       	call   800fb0 <sys_page_unmap>
  8021a2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021a5:	83 ec 08             	sub    $0x8,%esp
  8021a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ab:	6a 00                	push   $0x0
  8021ad:	e8 fe ed ff ff       	call   800fb0 <sys_page_unmap>
  8021b2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bb:	6a 00                	push   $0x0
  8021bd:	e8 ee ed ff ff       	call   800fb0 <sys_page_unmap>
  8021c2:	83 c4 10             	add    $0x10,%esp
}
  8021c5:	89 d8                	mov    %ebx,%eax
  8021c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ca:	5b                   	pop    %ebx
  8021cb:	5e                   	pop    %esi
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <pipeisclosed>:
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d7:	50                   	push   %eax
  8021d8:	ff 75 08             	pushl  0x8(%ebp)
  8021db:	e8 b9 f0 ff ff       	call   801299 <fd_lookup>
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 18                	js     8021ff <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ed:	e8 3e f0 ff ff       	call   801230 <fd2data>
	return _pipeisclosed(fd, p);
  8021f2:	89 c2                	mov    %eax,%edx
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	e8 2f fd ff ff       	call   801f2b <_pipeisclosed>
  8021fc:	83 c4 10             	add    $0x10,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
  802206:	c3                   	ret    

00802207 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80220d:	68 13 2d 80 00       	push   $0x802d13
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	e8 1f e9 ff ff       	call   800b39 <strcpy>
	return 0;
}
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <devcons_write>:
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	57                   	push   %edi
  802225:	56                   	push   %esi
  802226:	53                   	push   %ebx
  802227:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80222d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802232:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802238:	3b 75 10             	cmp    0x10(%ebp),%esi
  80223b:	73 31                	jae    80226e <devcons_write+0x4d>
		m = n - tot;
  80223d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802240:	29 f3                	sub    %esi,%ebx
  802242:	83 fb 7f             	cmp    $0x7f,%ebx
  802245:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80224a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	53                   	push   %ebx
  802251:	89 f0                	mov    %esi,%eax
  802253:	03 45 0c             	add    0xc(%ebp),%eax
  802256:	50                   	push   %eax
  802257:	57                   	push   %edi
  802258:	e8 6a ea ff ff       	call   800cc7 <memmove>
		sys_cputs(buf, m);
  80225d:	83 c4 08             	add    $0x8,%esp
  802260:	53                   	push   %ebx
  802261:	57                   	push   %edi
  802262:	e8 08 ec ff ff       	call   800e6f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802267:	01 de                	add    %ebx,%esi
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	eb ca                	jmp    802238 <devcons_write+0x17>
}
  80226e:	89 f0                	mov    %esi,%eax
  802270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5f                   	pop    %edi
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    

00802278 <devcons_read>:
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 08             	sub    $0x8,%esp
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802283:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802287:	74 21                	je     8022aa <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802289:	e8 ff eb ff ff       	call   800e8d <sys_cgetc>
  80228e:	85 c0                	test   %eax,%eax
  802290:	75 07                	jne    802299 <devcons_read+0x21>
		sys_yield();
  802292:	e8 75 ec ff ff       	call   800f0c <sys_yield>
  802297:	eb f0                	jmp    802289 <devcons_read+0x11>
	if (c < 0)
  802299:	78 0f                	js     8022aa <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80229b:	83 f8 04             	cmp    $0x4,%eax
  80229e:	74 0c                	je     8022ac <devcons_read+0x34>
	*(char*)vbuf = c;
  8022a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a3:	88 02                	mov    %al,(%edx)
	return 1;
  8022a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    
		return 0;
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b1:	eb f7                	jmp    8022aa <devcons_read+0x32>

008022b3 <cputchar>:
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022bf:	6a 01                	push   $0x1
  8022c1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022c4:	50                   	push   %eax
  8022c5:	e8 a5 eb ff ff       	call   800e6f <sys_cputs>
}
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <getchar>:
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022d5:	6a 01                	push   $0x1
  8022d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022da:	50                   	push   %eax
  8022db:	6a 00                	push   $0x0
  8022dd:	e8 27 f2 ff ff       	call   801509 <read>
	if (r < 0)
  8022e2:	83 c4 10             	add    $0x10,%esp
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	78 06                	js     8022ef <getchar+0x20>
	if (r < 1)
  8022e9:	74 06                	je     8022f1 <getchar+0x22>
	return c;
  8022eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    
		return -E_EOF;
  8022f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022f6:	eb f7                	jmp    8022ef <getchar+0x20>

008022f8 <iscons>:
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802301:	50                   	push   %eax
  802302:	ff 75 08             	pushl  0x8(%ebp)
  802305:	e8 8f ef ff ff       	call   801299 <fd_lookup>
  80230a:	83 c4 10             	add    $0x10,%esp
  80230d:	85 c0                	test   %eax,%eax
  80230f:	78 11                	js     802322 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80231a:	39 10                	cmp    %edx,(%eax)
  80231c:	0f 94 c0             	sete   %al
  80231f:	0f b6 c0             	movzbl %al,%eax
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <opencons>:
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80232a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232d:	50                   	push   %eax
  80232e:	e8 14 ef ff ff       	call   801247 <fd_alloc>
  802333:	83 c4 10             	add    $0x10,%esp
  802336:	85 c0                	test   %eax,%eax
  802338:	78 3a                	js     802374 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 07 04 00 00       	push   $0x407
  802342:	ff 75 f4             	pushl  -0xc(%ebp)
  802345:	6a 00                	push   $0x0
  802347:	e8 df eb ff ff       	call   800f2b <sys_page_alloc>
  80234c:	83 c4 10             	add    $0x10,%esp
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 21                	js     802374 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80235c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	50                   	push   %eax
  80236c:	e8 af ee ff ff       	call   801220 <fd2num>
  802371:	83 c4 10             	add    $0x10,%esp
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	56                   	push   %esi
  80237a:	53                   	push   %ebx
  80237b:	8b 75 08             	mov    0x8(%ebp),%esi
  80237e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802381:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802384:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802386:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80238b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80238e:	83 ec 0c             	sub    $0xc,%esp
  802391:	50                   	push   %eax
  802392:	e8 44 ed ff ff       	call   8010db <sys_ipc_recv>
	if(ret < 0){
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	85 c0                	test   %eax,%eax
  80239c:	78 2b                	js     8023c9 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80239e:	85 f6                	test   %esi,%esi
  8023a0:	74 0a                	je     8023ac <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8023a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8023a7:	8b 40 78             	mov    0x78(%eax),%eax
  8023aa:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8023ac:	85 db                	test   %ebx,%ebx
  8023ae:	74 0a                	je     8023ba <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8023b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8023b5:	8b 40 7c             	mov    0x7c(%eax),%eax
  8023b8:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8023ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8023bf:	8b 40 74             	mov    0x74(%eax),%eax
}
  8023c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c5:	5b                   	pop    %ebx
  8023c6:	5e                   	pop    %esi
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    
		if(from_env_store)
  8023c9:	85 f6                	test   %esi,%esi
  8023cb:	74 06                	je     8023d3 <ipc_recv+0x5d>
			*from_env_store = 0;
  8023cd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023d3:	85 db                	test   %ebx,%ebx
  8023d5:	74 eb                	je     8023c2 <ipc_recv+0x4c>
			*perm_store = 0;
  8023d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023dd:	eb e3                	jmp    8023c2 <ipc_recv+0x4c>

008023df <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	57                   	push   %edi
  8023e3:	56                   	push   %esi
  8023e4:	53                   	push   %ebx
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023f1:	85 db                	test   %ebx,%ebx
  8023f3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023f8:	0f 44 d8             	cmove  %eax,%ebx
  8023fb:	eb 05                	jmp    802402 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023fd:	e8 0a eb ff ff       	call   800f0c <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802402:	ff 75 14             	pushl  0x14(%ebp)
  802405:	53                   	push   %ebx
  802406:	56                   	push   %esi
  802407:	57                   	push   %edi
  802408:	e8 ab ec ff ff       	call   8010b8 <sys_ipc_try_send>
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	85 c0                	test   %eax,%eax
  802412:	74 1b                	je     80242f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802414:	79 e7                	jns    8023fd <ipc_send+0x1e>
  802416:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802419:	74 e2                	je     8023fd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 1f 2d 80 00       	push   $0x802d1f
  802423:	6a 46                	push   $0x46
  802425:	68 34 2d 80 00       	push   $0x802d34
  80242a:	e8 b5 de ff ff       	call   8002e4 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80242f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802432:	5b                   	pop    %ebx
  802433:	5e                   	pop    %esi
  802434:	5f                   	pop    %edi
  802435:	5d                   	pop    %ebp
  802436:	c3                   	ret    

00802437 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
  80243a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802442:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802448:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80244e:	8b 52 50             	mov    0x50(%edx),%edx
  802451:	39 ca                	cmp    %ecx,%edx
  802453:	74 11                	je     802466 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802455:	83 c0 01             	add    $0x1,%eax
  802458:	3d 00 04 00 00       	cmp    $0x400,%eax
  80245d:	75 e3                	jne    802442 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	eb 0e                	jmp    802474 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802466:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80246c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802471:	8b 40 48             	mov    0x48(%eax),%eax
}
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    

00802476 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
  802479:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80247c:	89 d0                	mov    %edx,%eax
  80247e:	c1 e8 16             	shr    $0x16,%eax
  802481:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80248d:	f6 c1 01             	test   $0x1,%cl
  802490:	74 1d                	je     8024af <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802492:	c1 ea 0c             	shr    $0xc,%edx
  802495:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80249c:	f6 c2 01             	test   $0x1,%dl
  80249f:	74 0e                	je     8024af <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024a1:	c1 ea 0c             	shr    $0xc,%edx
  8024a4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024ab:	ef 
  8024ac:	0f b7 c0             	movzwl %ax,%eax
}
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	66 90                	xchg   %ax,%ax
  8024b3:	66 90                	xchg   %ax,%ax
  8024b5:	66 90                	xchg   %ax,%ax
  8024b7:	66 90                	xchg   %ax,%ax
  8024b9:	66 90                	xchg   %ax,%ax
  8024bb:	66 90                	xchg   %ax,%ax
  8024bd:	66 90                	xchg   %ax,%ax
  8024bf:	90                   	nop

008024c0 <__udivdi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024d7:	85 d2                	test   %edx,%edx
  8024d9:	75 4d                	jne    802528 <__udivdi3+0x68>
  8024db:	39 f3                	cmp    %esi,%ebx
  8024dd:	76 19                	jbe    8024f8 <__udivdi3+0x38>
  8024df:	31 ff                	xor    %edi,%edi
  8024e1:	89 e8                	mov    %ebp,%eax
  8024e3:	89 f2                	mov    %esi,%edx
  8024e5:	f7 f3                	div    %ebx
  8024e7:	89 fa                	mov    %edi,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 d9                	mov    %ebx,%ecx
  8024fa:	85 db                	test   %ebx,%ebx
  8024fc:	75 0b                	jne    802509 <__udivdi3+0x49>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	31 d2                	xor    %edx,%edx
  802505:	f7 f3                	div    %ebx
  802507:	89 c1                	mov    %eax,%ecx
  802509:	31 d2                	xor    %edx,%edx
  80250b:	89 f0                	mov    %esi,%eax
  80250d:	f7 f1                	div    %ecx
  80250f:	89 c6                	mov    %eax,%esi
  802511:	89 e8                	mov    %ebp,%eax
  802513:	89 f7                	mov    %esi,%edi
  802515:	f7 f1                	div    %ecx
  802517:	89 fa                	mov    %edi,%edx
  802519:	83 c4 1c             	add    $0x1c,%esp
  80251c:	5b                   	pop    %ebx
  80251d:	5e                   	pop    %esi
  80251e:	5f                   	pop    %edi
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
  802521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802528:	39 f2                	cmp    %esi,%edx
  80252a:	77 1c                	ja     802548 <__udivdi3+0x88>
  80252c:	0f bd fa             	bsr    %edx,%edi
  80252f:	83 f7 1f             	xor    $0x1f,%edi
  802532:	75 2c                	jne    802560 <__udivdi3+0xa0>
  802534:	39 f2                	cmp    %esi,%edx
  802536:	72 06                	jb     80253e <__udivdi3+0x7e>
  802538:	31 c0                	xor    %eax,%eax
  80253a:	39 eb                	cmp    %ebp,%ebx
  80253c:	77 a9                	ja     8024e7 <__udivdi3+0x27>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	eb a2                	jmp    8024e7 <__udivdi3+0x27>
  802545:	8d 76 00             	lea    0x0(%esi),%esi
  802548:	31 ff                	xor    %edi,%edi
  80254a:	31 c0                	xor    %eax,%eax
  80254c:	89 fa                	mov    %edi,%edx
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	89 f9                	mov    %edi,%ecx
  802562:	b8 20 00 00 00       	mov    $0x20,%eax
  802567:	29 f8                	sub    %edi,%eax
  802569:	d3 e2                	shl    %cl,%edx
  80256b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80256f:	89 c1                	mov    %eax,%ecx
  802571:	89 da                	mov    %ebx,%edx
  802573:	d3 ea                	shr    %cl,%edx
  802575:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802579:	09 d1                	or     %edx,%ecx
  80257b:	89 f2                	mov    %esi,%edx
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 f9                	mov    %edi,%ecx
  802583:	d3 e3                	shl    %cl,%ebx
  802585:	89 c1                	mov    %eax,%ecx
  802587:	d3 ea                	shr    %cl,%edx
  802589:	89 f9                	mov    %edi,%ecx
  80258b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80258f:	89 eb                	mov    %ebp,%ebx
  802591:	d3 e6                	shl    %cl,%esi
  802593:	89 c1                	mov    %eax,%ecx
  802595:	d3 eb                	shr    %cl,%ebx
  802597:	09 de                	or     %ebx,%esi
  802599:	89 f0                	mov    %esi,%eax
  80259b:	f7 74 24 08          	divl   0x8(%esp)
  80259f:	89 d6                	mov    %edx,%esi
  8025a1:	89 c3                	mov    %eax,%ebx
  8025a3:	f7 64 24 0c          	mull   0xc(%esp)
  8025a7:	39 d6                	cmp    %edx,%esi
  8025a9:	72 15                	jb     8025c0 <__udivdi3+0x100>
  8025ab:	89 f9                	mov    %edi,%ecx
  8025ad:	d3 e5                	shl    %cl,%ebp
  8025af:	39 c5                	cmp    %eax,%ebp
  8025b1:	73 04                	jae    8025b7 <__udivdi3+0xf7>
  8025b3:	39 d6                	cmp    %edx,%esi
  8025b5:	74 09                	je     8025c0 <__udivdi3+0x100>
  8025b7:	89 d8                	mov    %ebx,%eax
  8025b9:	31 ff                	xor    %edi,%edi
  8025bb:	e9 27 ff ff ff       	jmp    8024e7 <__udivdi3+0x27>
  8025c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025c3:	31 ff                	xor    %edi,%edi
  8025c5:	e9 1d ff ff ff       	jmp    8024e7 <__udivdi3+0x27>
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <__umoddi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 1c             	sub    $0x1c,%esp
  8025d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025e7:	89 da                	mov    %ebx,%edx
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	75 43                	jne    802630 <__umoddi3+0x60>
  8025ed:	39 df                	cmp    %ebx,%edi
  8025ef:	76 17                	jbe    802608 <__umoddi3+0x38>
  8025f1:	89 f0                	mov    %esi,%eax
  8025f3:	f7 f7                	div    %edi
  8025f5:	89 d0                	mov    %edx,%eax
  8025f7:	31 d2                	xor    %edx,%edx
  8025f9:	83 c4 1c             	add    $0x1c,%esp
  8025fc:	5b                   	pop    %ebx
  8025fd:	5e                   	pop    %esi
  8025fe:	5f                   	pop    %edi
  8025ff:	5d                   	pop    %ebp
  802600:	c3                   	ret    
  802601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802608:	89 fd                	mov    %edi,%ebp
  80260a:	85 ff                	test   %edi,%edi
  80260c:	75 0b                	jne    802619 <__umoddi3+0x49>
  80260e:	b8 01 00 00 00       	mov    $0x1,%eax
  802613:	31 d2                	xor    %edx,%edx
  802615:	f7 f7                	div    %edi
  802617:	89 c5                	mov    %eax,%ebp
  802619:	89 d8                	mov    %ebx,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	f7 f5                	div    %ebp
  80261f:	89 f0                	mov    %esi,%eax
  802621:	f7 f5                	div    %ebp
  802623:	89 d0                	mov    %edx,%eax
  802625:	eb d0                	jmp    8025f7 <__umoddi3+0x27>
  802627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80262e:	66 90                	xchg   %ax,%ax
  802630:	89 f1                	mov    %esi,%ecx
  802632:	39 d8                	cmp    %ebx,%eax
  802634:	76 0a                	jbe    802640 <__umoddi3+0x70>
  802636:	89 f0                	mov    %esi,%eax
  802638:	83 c4 1c             	add    $0x1c,%esp
  80263b:	5b                   	pop    %ebx
  80263c:	5e                   	pop    %esi
  80263d:	5f                   	pop    %edi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
  802640:	0f bd e8             	bsr    %eax,%ebp
  802643:	83 f5 1f             	xor    $0x1f,%ebp
  802646:	75 20                	jne    802668 <__umoddi3+0x98>
  802648:	39 d8                	cmp    %ebx,%eax
  80264a:	0f 82 b0 00 00 00    	jb     802700 <__umoddi3+0x130>
  802650:	39 f7                	cmp    %esi,%edi
  802652:	0f 86 a8 00 00 00    	jbe    802700 <__umoddi3+0x130>
  802658:	89 c8                	mov    %ecx,%eax
  80265a:	83 c4 1c             	add    $0x1c,%esp
  80265d:	5b                   	pop    %ebx
  80265e:	5e                   	pop    %esi
  80265f:	5f                   	pop    %edi
  802660:	5d                   	pop    %ebp
  802661:	c3                   	ret    
  802662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802668:	89 e9                	mov    %ebp,%ecx
  80266a:	ba 20 00 00 00       	mov    $0x20,%edx
  80266f:	29 ea                	sub    %ebp,%edx
  802671:	d3 e0                	shl    %cl,%eax
  802673:	89 44 24 08          	mov    %eax,0x8(%esp)
  802677:	89 d1                	mov    %edx,%ecx
  802679:	89 f8                	mov    %edi,%eax
  80267b:	d3 e8                	shr    %cl,%eax
  80267d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802681:	89 54 24 04          	mov    %edx,0x4(%esp)
  802685:	8b 54 24 04          	mov    0x4(%esp),%edx
  802689:	09 c1                	or     %eax,%ecx
  80268b:	89 d8                	mov    %ebx,%eax
  80268d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802691:	89 e9                	mov    %ebp,%ecx
  802693:	d3 e7                	shl    %cl,%edi
  802695:	89 d1                	mov    %edx,%ecx
  802697:	d3 e8                	shr    %cl,%eax
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80269f:	d3 e3                	shl    %cl,%ebx
  8026a1:	89 c7                	mov    %eax,%edi
  8026a3:	89 d1                	mov    %edx,%ecx
  8026a5:	89 f0                	mov    %esi,%eax
  8026a7:	d3 e8                	shr    %cl,%eax
  8026a9:	89 e9                	mov    %ebp,%ecx
  8026ab:	89 fa                	mov    %edi,%edx
  8026ad:	d3 e6                	shl    %cl,%esi
  8026af:	09 d8                	or     %ebx,%eax
  8026b1:	f7 74 24 08          	divl   0x8(%esp)
  8026b5:	89 d1                	mov    %edx,%ecx
  8026b7:	89 f3                	mov    %esi,%ebx
  8026b9:	f7 64 24 0c          	mull   0xc(%esp)
  8026bd:	89 c6                	mov    %eax,%esi
  8026bf:	89 d7                	mov    %edx,%edi
  8026c1:	39 d1                	cmp    %edx,%ecx
  8026c3:	72 06                	jb     8026cb <__umoddi3+0xfb>
  8026c5:	75 10                	jne    8026d7 <__umoddi3+0x107>
  8026c7:	39 c3                	cmp    %eax,%ebx
  8026c9:	73 0c                	jae    8026d7 <__umoddi3+0x107>
  8026cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026d3:	89 d7                	mov    %edx,%edi
  8026d5:	89 c6                	mov    %eax,%esi
  8026d7:	89 ca                	mov    %ecx,%edx
  8026d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026de:	29 f3                	sub    %esi,%ebx
  8026e0:	19 fa                	sbb    %edi,%edx
  8026e2:	89 d0                	mov    %edx,%eax
  8026e4:	d3 e0                	shl    %cl,%eax
  8026e6:	89 e9                	mov    %ebp,%ecx
  8026e8:	d3 eb                	shr    %cl,%ebx
  8026ea:	d3 ea                	shr    %cl,%edx
  8026ec:	09 d8                	or     %ebx,%eax
  8026ee:	83 c4 1c             	add    $0x1c,%esp
  8026f1:	5b                   	pop    %ebx
  8026f2:	5e                   	pop    %esi
  8026f3:	5f                   	pop    %edi
  8026f4:	5d                   	pop    %ebp
  8026f5:	c3                   	ret    
  8026f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026fd:	8d 76 00             	lea    0x0(%esi),%esi
  802700:	89 da                	mov    %ebx,%edx
  802702:	29 fe                	sub    %edi,%esi
  802704:	19 c2                	sbb    %eax,%edx
  802706:	89 f1                	mov    %esi,%ecx
  802708:	89 c8                	mov    %ecx,%eax
  80270a:	e9 4b ff ff ff       	jmp    80265a <__umoddi3+0x8a>
