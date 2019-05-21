
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 81 01 00 00       	call   8001c8 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 bd 02 00 00       	call   800313 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	57                   	push   %edi
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80006e:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800075:	00 00 00 
	envid_t find = sys_getenvid();
  800078:	e8 0d 01 00 00       	call   80018a <sys_getenvid>
  80007d:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  800083:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800088:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80008d:	bf 01 00 00 00       	mov    $0x1,%edi
  800092:	eb 0b                	jmp    80009f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800094:	83 c2 01             	add    $0x1,%edx
  800097:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80009d:	74 21                	je     8000c0 <libmain+0x5b>
		if(envs[i].env_id == find)
  80009f:	89 d1                	mov    %edx,%ecx
  8000a1:	c1 e1 07             	shl    $0x7,%ecx
  8000a4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000aa:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000ad:	39 c1                	cmp    %eax,%ecx
  8000af:	75 e3                	jne    800094 <libmain+0x2f>
  8000b1:	89 d3                	mov    %edx,%ebx
  8000b3:	c1 e3 07             	shl    $0x7,%ebx
  8000b6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000bc:	89 fe                	mov    %edi,%esi
  8000be:	eb d4                	jmp    800094 <libmain+0x2f>
  8000c0:	89 f0                	mov    %esi,%eax
  8000c2:	84 c0                	test   %al,%al
  8000c4:	74 06                	je     8000cc <libmain+0x67>
  8000c6:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d0:	7e 0a                	jle    8000dc <libmain+0x77>
		binaryname = argv[0];
  8000d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d5:	8b 00                	mov    (%eax),%eax
  8000d7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000dc:	83 ec 08             	sub    $0x8,%esp
  8000df:	ff 75 0c             	pushl  0xc(%ebp)
  8000e2:	ff 75 08             	pushl  0x8(%ebp)
  8000e5:	e8 49 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ea:	e8 0b 00 00 00       	call   8000fa <exit>
}
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f5:	5b                   	pop    %ebx
  8000f6:	5e                   	pop    %esi
  8000f7:	5f                   	pop    %edi
  8000f8:	5d                   	pop    %ebp
  8000f9:	c3                   	ret    

008000fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800100:	6a 00                	push   $0x0
  800102:	e8 42 00 00 00       	call   800149 <sys_env_destroy>
}
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	c9                   	leave  
  80010b:	c3                   	ret    

0080010c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	57                   	push   %edi
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
	asm volatile("int %1\n"
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	8b 55 08             	mov    0x8(%ebp),%edx
  80011a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80011d:	89 c3                	mov    %eax,%ebx
  80011f:	89 c7                	mov    %eax,%edi
  800121:	89 c6                	mov    %eax,%esi
  800123:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5f                   	pop    %edi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <sys_cgetc>:

int
sys_cgetc(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 01 00 00 00       	mov    $0x1,%eax
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	89 d3                	mov    %edx,%ebx
  80013e:	89 d7                	mov    %edx,%edi
  800140:	89 d6                	mov    %edx,%esi
  800142:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
  80014f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800152:	b9 00 00 00 00       	mov    $0x0,%ecx
  800157:	8b 55 08             	mov    0x8(%ebp),%edx
  80015a:	b8 03 00 00 00       	mov    $0x3,%eax
  80015f:	89 cb                	mov    %ecx,%ebx
  800161:	89 cf                	mov    %ecx,%edi
  800163:	89 ce                	mov    %ecx,%esi
  800165:	cd 30                	int    $0x30
	if(check && ret > 0)
  800167:	85 c0                	test   %eax,%eax
  800169:	7f 08                	jg     800173 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80016b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016e:	5b                   	pop    %ebx
  80016f:	5e                   	pop    %esi
  800170:	5f                   	pop    %edi
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	50                   	push   %eax
  800177:	6a 03                	push   $0x3
  800179:	68 ea 11 80 00       	push   $0x8011ea
  80017e:	6a 43                	push   $0x43
  800180:	68 07 12 80 00       	push   $0x801207
  800185:	e8 70 02 00 00       	call   8003fa <_panic>

0080018a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	57                   	push   %edi
  80018e:	56                   	push   %esi
  80018f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800190:	ba 00 00 00 00       	mov    $0x0,%edx
  800195:	b8 02 00 00 00       	mov    $0x2,%eax
  80019a:	89 d1                	mov    %edx,%ecx
  80019c:	89 d3                	mov    %edx,%ebx
  80019e:	89 d7                	mov    %edx,%edi
  8001a0:	89 d6                	mov    %edx,%esi
  8001a2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001a4:	5b                   	pop    %ebx
  8001a5:	5e                   	pop    %esi
  8001a6:	5f                   	pop    %edi
  8001a7:	5d                   	pop    %ebp
  8001a8:	c3                   	ret    

008001a9 <sys_yield>:

void
sys_yield(void)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	57                   	push   %edi
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8001af:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b4:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001b9:	89 d1                	mov    %edx,%ecx
  8001bb:	89 d3                	mov    %edx,%ebx
  8001bd:	89 d7                	mov    %edx,%edi
  8001bf:	89 d6                	mov    %edx,%esi
  8001c1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5f                   	pop    %edi
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    

008001c8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	57                   	push   %edi
  8001cc:	56                   	push   %esi
  8001cd:	53                   	push   %ebx
  8001ce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d1:	be 00 00 00 00       	mov    $0x0,%esi
  8001d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8001e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e4:	89 f7                	mov    %esi,%edi
  8001e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	7f 08                	jg     8001f4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ef:	5b                   	pop    %ebx
  8001f0:	5e                   	pop    %esi
  8001f1:	5f                   	pop    %edi
  8001f2:	5d                   	pop    %ebp
  8001f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	6a 04                	push   $0x4
  8001fa:	68 ea 11 80 00       	push   $0x8011ea
  8001ff:	6a 43                	push   $0x43
  800201:	68 07 12 80 00       	push   $0x801207
  800206:	e8 ef 01 00 00       	call   8003fa <_panic>

0080020b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	57                   	push   %edi
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800214:	8b 55 08             	mov    0x8(%ebp),%edx
  800217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021a:	b8 05 00 00 00       	mov    $0x5,%eax
  80021f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800222:	8b 7d 14             	mov    0x14(%ebp),%edi
  800225:	8b 75 18             	mov    0x18(%ebp),%esi
  800228:	cd 30                	int    $0x30
	if(check && ret > 0)
  80022a:	85 c0                	test   %eax,%eax
  80022c:	7f 08                	jg     800236 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80022e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800231:	5b                   	pop    %ebx
  800232:	5e                   	pop    %esi
  800233:	5f                   	pop    %edi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	50                   	push   %eax
  80023a:	6a 05                	push   $0x5
  80023c:	68 ea 11 80 00       	push   $0x8011ea
  800241:	6a 43                	push   $0x43
  800243:	68 07 12 80 00       	push   $0x801207
  800248:	e8 ad 01 00 00       	call   8003fa <_panic>

0080024d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	57                   	push   %edi
  800251:	56                   	push   %esi
  800252:	53                   	push   %ebx
  800253:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800256:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025b:	8b 55 08             	mov    0x8(%ebp),%edx
  80025e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800261:	b8 06 00 00 00       	mov    $0x6,%eax
  800266:	89 df                	mov    %ebx,%edi
  800268:	89 de                	mov    %ebx,%esi
  80026a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80026c:	85 c0                	test   %eax,%eax
  80026e:	7f 08                	jg     800278 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	50                   	push   %eax
  80027c:	6a 06                	push   $0x6
  80027e:	68 ea 11 80 00       	push   $0x8011ea
  800283:	6a 43                	push   $0x43
  800285:	68 07 12 80 00       	push   $0x801207
  80028a:	e8 6b 01 00 00       	call   8003fa <_panic>

0080028f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	57                   	push   %edi
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029d:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8002a8:	89 df                	mov    %ebx,%edi
  8002aa:	89 de                	mov    %ebx,%esi
  8002ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	7f 08                	jg     8002ba <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	50                   	push   %eax
  8002be:	6a 08                	push   $0x8
  8002c0:	68 ea 11 80 00       	push   $0x8011ea
  8002c5:	6a 43                	push   $0x43
  8002c7:	68 07 12 80 00       	push   $0x801207
  8002cc:	e8 29 01 00 00       	call   8003fa <_panic>

008002d1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	57                   	push   %edi
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002df:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e5:	b8 09 00 00 00       	mov    $0x9,%eax
  8002ea:	89 df                	mov    %ebx,%edi
  8002ec:	89 de                	mov    %ebx,%esi
  8002ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	7f 08                	jg     8002fc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f7:	5b                   	pop    %ebx
  8002f8:	5e                   	pop    %esi
  8002f9:	5f                   	pop    %edi
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	50                   	push   %eax
  800300:	6a 09                	push   $0x9
  800302:	68 ea 11 80 00       	push   $0x8011ea
  800307:	6a 43                	push   $0x43
  800309:	68 07 12 80 00       	push   $0x801207
  80030e:	e8 e7 00 00 00       	call   8003fa <_panic>

00800313 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800327:	b8 0a 00 00 00       	mov    $0xa,%eax
  80032c:	89 df                	mov    %ebx,%edi
  80032e:	89 de                	mov    %ebx,%esi
  800330:	cd 30                	int    $0x30
	if(check && ret > 0)
  800332:	85 c0                	test   %eax,%eax
  800334:	7f 08                	jg     80033e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800336:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800339:	5b                   	pop    %ebx
  80033a:	5e                   	pop    %esi
  80033b:	5f                   	pop    %edi
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033e:	83 ec 0c             	sub    $0xc,%esp
  800341:	50                   	push   %eax
  800342:	6a 0a                	push   $0xa
  800344:	68 ea 11 80 00       	push   $0x8011ea
  800349:	6a 43                	push   $0x43
  80034b:	68 07 12 80 00       	push   $0x801207
  800350:	e8 a5 00 00 00       	call   8003fa <_panic>

00800355 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	57                   	push   %edi
  800359:	56                   	push   %esi
  80035a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035b:	8b 55 08             	mov    0x8(%ebp),%edx
  80035e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800361:	b8 0c 00 00 00       	mov    $0xc,%eax
  800366:	be 00 00 00 00       	mov    $0x0,%esi
  80036b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80036e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800371:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800373:	5b                   	pop    %ebx
  800374:	5e                   	pop    %esi
  800375:	5f                   	pop    %edi
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	57                   	push   %edi
  80037c:	56                   	push   %esi
  80037d:	53                   	push   %ebx
  80037e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800381:	b9 00 00 00 00       	mov    $0x0,%ecx
  800386:	8b 55 08             	mov    0x8(%ebp),%edx
  800389:	b8 0d 00 00 00       	mov    $0xd,%eax
  80038e:	89 cb                	mov    %ecx,%ebx
  800390:	89 cf                	mov    %ecx,%edi
  800392:	89 ce                	mov    %ecx,%esi
  800394:	cd 30                	int    $0x30
	if(check && ret > 0)
  800396:	85 c0                	test   %eax,%eax
  800398:	7f 08                	jg     8003a2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80039a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039d:	5b                   	pop    %ebx
  80039e:	5e                   	pop    %esi
  80039f:	5f                   	pop    %edi
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	50                   	push   %eax
  8003a6:	6a 0d                	push   $0xd
  8003a8:	68 ea 11 80 00       	push   $0x8011ea
  8003ad:	6a 43                	push   $0x43
  8003af:	68 07 12 80 00       	push   $0x801207
  8003b4:	e8 41 00 00 00       	call   8003fa <_panic>

008003b9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	57                   	push   %edi
  8003bd:	56                   	push   %esi
  8003be:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ca:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003cf:	89 df                	mov    %ebx,%edi
  8003d1:	89 de                	mov    %ebx,%esi
  8003d3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8003d5:	5b                   	pop    %ebx
  8003d6:	5e                   	pop    %esi
  8003d7:	5f                   	pop    %edi
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003ed:	89 cb                	mov    %ecx,%ebx
  8003ef:	89 cf                	mov    %ecx,%edi
  8003f1:	89 ce                	mov    %ecx,%esi
  8003f3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8003f5:	5b                   	pop    %ebx
  8003f6:	5e                   	pop    %esi
  8003f7:	5f                   	pop    %edi
  8003f8:	5d                   	pop    %ebp
  8003f9:	c3                   	ret    

008003fa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	56                   	push   %esi
  8003fe:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8003ff:	a1 04 20 80 00       	mov    0x802004,%eax
  800404:	8b 40 48             	mov    0x48(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	68 44 12 80 00       	push   $0x801244
  80040f:	50                   	push   %eax
  800410:	68 15 12 80 00       	push   $0x801215
  800415:	e8 d6 00 00 00       	call   8004f0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80041a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80041d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800423:	e8 62 fd ff ff       	call   80018a <sys_getenvid>
  800428:	83 c4 04             	add    $0x4,%esp
  80042b:	ff 75 0c             	pushl  0xc(%ebp)
  80042e:	ff 75 08             	pushl  0x8(%ebp)
  800431:	56                   	push   %esi
  800432:	50                   	push   %eax
  800433:	68 20 12 80 00       	push   $0x801220
  800438:	e8 b3 00 00 00       	call   8004f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80043d:	83 c4 18             	add    $0x18,%esp
  800440:	53                   	push   %ebx
  800441:	ff 75 10             	pushl  0x10(%ebp)
  800444:	e8 56 00 00 00       	call   80049f <vcprintf>
	cprintf("\n");
  800449:	c7 04 24 1e 12 80 00 	movl   $0x80121e,(%esp)
  800450:	e8 9b 00 00 00       	call   8004f0 <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800458:	cc                   	int3   
  800459:	eb fd                	jmp    800458 <_panic+0x5e>

0080045b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	53                   	push   %ebx
  80045f:	83 ec 04             	sub    $0x4,%esp
  800462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800465:	8b 13                	mov    (%ebx),%edx
  800467:	8d 42 01             	lea    0x1(%edx),%eax
  80046a:	89 03                	mov    %eax,(%ebx)
  80046c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80046f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800473:	3d ff 00 00 00       	cmp    $0xff,%eax
  800478:	74 09                	je     800483 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80047a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80047e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800481:	c9                   	leave  
  800482:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	68 ff 00 00 00       	push   $0xff
  80048b:	8d 43 08             	lea    0x8(%ebx),%eax
  80048e:	50                   	push   %eax
  80048f:	e8 78 fc ff ff       	call   80010c <sys_cputs>
		b->idx = 0;
  800494:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	eb db                	jmp    80047a <putch+0x1f>

0080049f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004af:	00 00 00 
	b.cnt = 0;
  8004b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004bc:	ff 75 0c             	pushl  0xc(%ebp)
  8004bf:	ff 75 08             	pushl  0x8(%ebp)
  8004c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004c8:	50                   	push   %eax
  8004c9:	68 5b 04 80 00       	push   $0x80045b
  8004ce:	e8 4a 01 00 00       	call   80061d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004d3:	83 c4 08             	add    $0x8,%esp
  8004d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004e2:	50                   	push   %eax
  8004e3:	e8 24 fc ff ff       	call   80010c <sys_cputs>

	return b.cnt;
}
  8004e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	e8 9d ff ff ff       	call   80049f <vcprintf>
	va_end(ap);

	return cnt;
}
  800502:	c9                   	leave  
  800503:	c3                   	ret    

00800504 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
  80050a:	83 ec 1c             	sub    $0x1c,%esp
  80050d:	89 c6                	mov    %eax,%esi
  80050f:	89 d7                	mov    %edx,%edi
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800523:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800527:	74 2c                	je     800555 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800529:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800533:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800536:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80053e:	73 43                	jae    800583 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800540:	83 eb 01             	sub    $0x1,%ebx
  800543:	85 db                	test   %ebx,%ebx
  800545:	7e 6c                	jle    8005b3 <printnum+0xaf>
				putch(padc, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	57                   	push   %edi
  80054b:	ff 75 18             	pushl  0x18(%ebp)
  80054e:	ff d6                	call   *%esi
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	eb eb                	jmp    800540 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800555:	83 ec 0c             	sub    $0xc,%esp
  800558:	6a 20                	push   $0x20
  80055a:	6a 00                	push   $0x0
  80055c:	50                   	push   %eax
  80055d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800560:	ff 75 e0             	pushl  -0x20(%ebp)
  800563:	89 fa                	mov    %edi,%edx
  800565:	89 f0                	mov    %esi,%eax
  800567:	e8 98 ff ff ff       	call   800504 <printnum>
		while (--width > 0)
  80056c:	83 c4 20             	add    $0x20,%esp
  80056f:	83 eb 01             	sub    $0x1,%ebx
  800572:	85 db                	test   %ebx,%ebx
  800574:	7e 65                	jle    8005db <printnum+0xd7>
			putch(padc, putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	57                   	push   %edi
  80057a:	6a 20                	push   $0x20
  80057c:	ff d6                	call   *%esi
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	eb ec                	jmp    80056f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800583:	83 ec 0c             	sub    $0xc,%esp
  800586:	ff 75 18             	pushl  0x18(%ebp)
  800589:	83 eb 01             	sub    $0x1,%ebx
  80058c:	53                   	push   %ebx
  80058d:	50                   	push   %eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 dc             	pushl  -0x24(%ebp)
  800594:	ff 75 d8             	pushl  -0x28(%ebp)
  800597:	ff 75 e4             	pushl  -0x1c(%ebp)
  80059a:	ff 75 e0             	pushl  -0x20(%ebp)
  80059d:	e8 ee 09 00 00       	call   800f90 <__udivdi3>
  8005a2:	83 c4 18             	add    $0x18,%esp
  8005a5:	52                   	push   %edx
  8005a6:	50                   	push   %eax
  8005a7:	89 fa                	mov    %edi,%edx
  8005a9:	89 f0                	mov    %esi,%eax
  8005ab:	e8 54 ff ff ff       	call   800504 <printnum>
  8005b0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	57                   	push   %edi
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8005bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c6:	e8 d5 0a 00 00       	call   8010a0 <__umoddi3>
  8005cb:	83 c4 14             	add    $0x14,%esp
  8005ce:	0f be 80 4b 12 80 00 	movsbl 0x80124b(%eax),%eax
  8005d5:	50                   	push   %eax
  8005d6:	ff d6                	call   *%esi
  8005d8:	83 c4 10             	add    $0x10,%esp
	}
}
  8005db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5e                   	pop    %esi
  8005e0:	5f                   	pop    %edi
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005e9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ed:	8b 10                	mov    (%eax),%edx
  8005ef:	3b 50 04             	cmp    0x4(%eax),%edx
  8005f2:	73 0a                	jae    8005fe <sprintputch+0x1b>
		*b->buf++ = ch;
  8005f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005f7:	89 08                	mov    %ecx,(%eax)
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	88 02                	mov    %al,(%edx)
}
  8005fe:	5d                   	pop    %ebp
  8005ff:	c3                   	ret    

00800600 <printfmt>:
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800606:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800609:	50                   	push   %eax
  80060a:	ff 75 10             	pushl  0x10(%ebp)
  80060d:	ff 75 0c             	pushl  0xc(%ebp)
  800610:	ff 75 08             	pushl  0x8(%ebp)
  800613:	e8 05 00 00 00       	call   80061d <vprintfmt>
}
  800618:	83 c4 10             	add    $0x10,%esp
  80061b:	c9                   	leave  
  80061c:	c3                   	ret    

0080061d <vprintfmt>:
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	57                   	push   %edi
  800621:	56                   	push   %esi
  800622:	53                   	push   %ebx
  800623:	83 ec 3c             	sub    $0x3c,%esp
  800626:	8b 75 08             	mov    0x8(%ebp),%esi
  800629:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80062c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80062f:	e9 32 04 00 00       	jmp    800a66 <vprintfmt+0x449>
		padc = ' ';
  800634:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800638:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80063f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800646:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80064d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800654:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80065b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800660:	8d 47 01             	lea    0x1(%edi),%eax
  800663:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800666:	0f b6 17             	movzbl (%edi),%edx
  800669:	8d 42 dd             	lea    -0x23(%edx),%eax
  80066c:	3c 55                	cmp    $0x55,%al
  80066e:	0f 87 12 05 00 00    	ja     800b86 <vprintfmt+0x569>
  800674:	0f b6 c0             	movzbl %al,%eax
  800677:	ff 24 85 20 14 80 00 	jmp    *0x801420(,%eax,4)
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800681:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800685:	eb d9                	jmp    800660 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80068a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80068e:	eb d0                	jmp    800660 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800690:	0f b6 d2             	movzbl %dl,%edx
  800693:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800696:	b8 00 00 00 00       	mov    $0x0,%eax
  80069b:	89 75 08             	mov    %esi,0x8(%ebp)
  80069e:	eb 03                	jmp    8006a3 <vprintfmt+0x86>
  8006a0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8006a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8006aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8006ad:	8d 72 d0             	lea    -0x30(%edx),%esi
  8006b0:	83 fe 09             	cmp    $0x9,%esi
  8006b3:	76 eb                	jbe    8006a0 <vprintfmt+0x83>
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8006bb:	eb 14                	jmp    8006d1 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 40 04             	lea    0x4(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d5:	79 89                	jns    800660 <vprintfmt+0x43>
				width = precision, precision = -1;
  8006d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006dd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006e4:	e9 77 ff ff ff       	jmp    800660 <vprintfmt+0x43>
  8006e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	0f 48 c1             	cmovs  %ecx,%eax
  8006f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006f7:	e9 64 ff ff ff       	jmp    800660 <vprintfmt+0x43>
  8006fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006ff:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800706:	e9 55 ff ff ff       	jmp    800660 <vprintfmt+0x43>
			lflag++;
  80070b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80070f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800712:	e9 49 ff ff ff       	jmp    800660 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 78 04             	lea    0x4(%eax),%edi
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	ff 30                	pushl  (%eax)
  800723:	ff d6                	call   *%esi
			break;
  800725:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800728:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80072b:	e9 33 03 00 00       	jmp    800a63 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 78 04             	lea    0x4(%eax),%edi
  800736:	8b 00                	mov    (%eax),%eax
  800738:	99                   	cltd   
  800739:	31 d0                	xor    %edx,%eax
  80073b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80073d:	83 f8 0f             	cmp    $0xf,%eax
  800740:	7f 23                	jg     800765 <vprintfmt+0x148>
  800742:	8b 14 85 80 15 80 00 	mov    0x801580(,%eax,4),%edx
  800749:	85 d2                	test   %edx,%edx
  80074b:	74 18                	je     800765 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80074d:	52                   	push   %edx
  80074e:	68 6c 12 80 00       	push   $0x80126c
  800753:	53                   	push   %ebx
  800754:	56                   	push   %esi
  800755:	e8 a6 fe ff ff       	call   800600 <printfmt>
  80075a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80075d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800760:	e9 fe 02 00 00       	jmp    800a63 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800765:	50                   	push   %eax
  800766:	68 63 12 80 00       	push   $0x801263
  80076b:	53                   	push   %ebx
  80076c:	56                   	push   %esi
  80076d:	e8 8e fe ff ff       	call   800600 <printfmt>
  800772:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800775:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800778:	e9 e6 02 00 00       	jmp    800a63 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	83 c0 04             	add    $0x4,%eax
  800783:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80078b:	85 c9                	test   %ecx,%ecx
  80078d:	b8 5c 12 80 00       	mov    $0x80125c,%eax
  800792:	0f 45 c1             	cmovne %ecx,%eax
  800795:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800798:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079c:	7e 06                	jle    8007a4 <vprintfmt+0x187>
  80079e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8007a2:	75 0d                	jne    8007b1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007a7:	89 c7                	mov    %eax,%edi
  8007a9:	03 45 e0             	add    -0x20(%ebp),%eax
  8007ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007af:	eb 53                	jmp    800804 <vprintfmt+0x1e7>
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	e8 71 04 00 00       	call   800c2e <strnlen>
  8007bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007c0:	29 c1                	sub    %eax,%ecx
  8007c2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8007ca:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8007ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d1:	eb 0f                	jmp    8007e2 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007dc:	83 ef 01             	sub    $0x1,%edi
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	85 ff                	test   %edi,%edi
  8007e4:	7f ed                	jg     8007d3 <vprintfmt+0x1b6>
  8007e6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8007e9:	85 c9                	test   %ecx,%ecx
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f0:	0f 49 c1             	cmovns %ecx,%eax
  8007f3:	29 c1                	sub    %eax,%ecx
  8007f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007f8:	eb aa                	jmp    8007a4 <vprintfmt+0x187>
					putch(ch, putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	53                   	push   %ebx
  8007fe:	52                   	push   %edx
  8007ff:	ff d6                	call   *%esi
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800807:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800809:	83 c7 01             	add    $0x1,%edi
  80080c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800810:	0f be d0             	movsbl %al,%edx
  800813:	85 d2                	test   %edx,%edx
  800815:	74 4b                	je     800862 <vprintfmt+0x245>
  800817:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80081b:	78 06                	js     800823 <vprintfmt+0x206>
  80081d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800821:	78 1e                	js     800841 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800823:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800827:	74 d1                	je     8007fa <vprintfmt+0x1dd>
  800829:	0f be c0             	movsbl %al,%eax
  80082c:	83 e8 20             	sub    $0x20,%eax
  80082f:	83 f8 5e             	cmp    $0x5e,%eax
  800832:	76 c6                	jbe    8007fa <vprintfmt+0x1dd>
					putch('?', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 3f                	push   $0x3f
  80083a:	ff d6                	call   *%esi
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	eb c3                	jmp    800804 <vprintfmt+0x1e7>
  800841:	89 cf                	mov    %ecx,%edi
  800843:	eb 0e                	jmp    800853 <vprintfmt+0x236>
				putch(' ', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 20                	push   $0x20
  80084b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80084d:	83 ef 01             	sub    $0x1,%edi
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	85 ff                	test   %edi,%edi
  800855:	7f ee                	jg     800845 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800857:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
  80085d:	e9 01 02 00 00       	jmp    800a63 <vprintfmt+0x446>
  800862:	89 cf                	mov    %ecx,%edi
  800864:	eb ed                	jmp    800853 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800869:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800870:	e9 eb fd ff ff       	jmp    800660 <vprintfmt+0x43>
	if (lflag >= 2)
  800875:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800879:	7f 21                	jg     80089c <vprintfmt+0x27f>
	else if (lflag)
  80087b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80087f:	74 68                	je     8008e9 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800889:	89 c1                	mov    %eax,%ecx
  80088b:	c1 f9 1f             	sar    $0x1f,%ecx
  80088e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 40 04             	lea    0x4(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	eb 17                	jmp    8008b3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 50 04             	mov    0x4(%eax),%edx
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 08             	lea    0x8(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8008b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8008bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008c3:	78 3f                	js     800904 <vprintfmt+0x2e7>
			base = 10;
  8008c5:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8008ca:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8008ce:	0f 84 71 01 00 00    	je     800a45 <vprintfmt+0x428>
				putch('+', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	6a 2b                	push   $0x2b
  8008da:	ff d6                	call   *%esi
  8008dc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e4:	e9 5c 01 00 00       	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008f1:	89 c1                	mov    %eax,%ecx
  8008f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8008f6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8d 40 04             	lea    0x4(%eax),%eax
  8008ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800902:	eb af                	jmp    8008b3 <vprintfmt+0x296>
				putch('-', putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	53                   	push   %ebx
  800908:	6a 2d                	push   $0x2d
  80090a:	ff d6                	call   *%esi
				num = -(long long) num;
  80090c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80090f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800912:	f7 d8                	neg    %eax
  800914:	83 d2 00             	adc    $0x0,%edx
  800917:	f7 da                	neg    %edx
  800919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800922:	b8 0a 00 00 00       	mov    $0xa,%eax
  800927:	e9 19 01 00 00       	jmp    800a45 <vprintfmt+0x428>
	if (lflag >= 2)
  80092c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800930:	7f 29                	jg     80095b <vprintfmt+0x33e>
	else if (lflag)
  800932:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800936:	74 44                	je     80097c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 04             	lea    0x4(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800951:	b8 0a 00 00 00       	mov    $0xa,%eax
  800956:	e9 ea 00 00 00       	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 50 04             	mov    0x4(%eax),%edx
  800961:	8b 00                	mov    (%eax),%eax
  800963:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800966:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8d 40 08             	lea    0x8(%eax),%eax
  80096f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800972:	b8 0a 00 00 00       	mov    $0xa,%eax
  800977:	e9 c9 00 00 00       	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	ba 00 00 00 00       	mov    $0x0,%edx
  800986:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800989:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	8d 40 04             	lea    0x4(%eax),%eax
  800992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800995:	b8 0a 00 00 00       	mov    $0xa,%eax
  80099a:	e9 a6 00 00 00       	jmp    800a45 <vprintfmt+0x428>
			putch('0', putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	53                   	push   %ebx
  8009a3:	6a 30                	push   $0x30
  8009a5:	ff d6                	call   *%esi
	if (lflag >= 2)
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8009ae:	7f 26                	jg     8009d6 <vprintfmt+0x3b9>
	else if (lflag)
  8009b0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8009b4:	74 3e                	je     8009f4 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	8d 40 04             	lea    0x4(%eax),%eax
  8009cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8009d4:	eb 6f                	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8009d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d9:	8b 50 04             	mov    0x4(%eax),%edx
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e7:	8d 40 08             	lea    0x8(%eax),%eax
  8009ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8009ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8009f2:	eb 51                	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a01:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8d 40 04             	lea    0x4(%eax),%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a0d:	b8 08 00 00 00       	mov    $0x8,%eax
  800a12:	eb 31                	jmp    800a45 <vprintfmt+0x428>
			putch('0', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	53                   	push   %ebx
  800a18:	6a 30                	push   $0x30
  800a1a:	ff d6                	call   *%esi
			putch('x', putdat);
  800a1c:	83 c4 08             	add    $0x8,%esp
  800a1f:	53                   	push   %ebx
  800a20:	6a 78                	push   $0x78
  800a22:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a31:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800a34:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	8d 40 04             	lea    0x4(%eax),%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a40:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a45:	83 ec 0c             	sub    $0xc,%esp
  800a48:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800a4c:	52                   	push   %edx
  800a4d:	ff 75 e0             	pushl  -0x20(%ebp)
  800a50:	50                   	push   %eax
  800a51:	ff 75 dc             	pushl  -0x24(%ebp)
  800a54:	ff 75 d8             	pushl  -0x28(%ebp)
  800a57:	89 da                	mov    %ebx,%edx
  800a59:	89 f0                	mov    %esi,%eax
  800a5b:	e8 a4 fa ff ff       	call   800504 <printnum>
			break;
  800a60:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a63:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a66:	83 c7 01             	add    $0x1,%edi
  800a69:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a6d:	83 f8 25             	cmp    $0x25,%eax
  800a70:	0f 84 be fb ff ff    	je     800634 <vprintfmt+0x17>
			if (ch == '\0')
  800a76:	85 c0                	test   %eax,%eax
  800a78:	0f 84 28 01 00 00    	je     800ba6 <vprintfmt+0x589>
			putch(ch, putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	53                   	push   %ebx
  800a82:	50                   	push   %eax
  800a83:	ff d6                	call   *%esi
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	eb dc                	jmp    800a66 <vprintfmt+0x449>
	if (lflag >= 2)
  800a8a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800a8e:	7f 26                	jg     800ab6 <vprintfmt+0x499>
	else if (lflag)
  800a90:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800a94:	74 41                	je     800ad7 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	8d 40 04             	lea    0x4(%eax),%eax
  800aac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aaf:	b8 10 00 00 00       	mov    $0x10,%eax
  800ab4:	eb 8f                	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab9:	8b 50 04             	mov    0x4(%eax),%edx
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8d 40 08             	lea    0x8(%eax),%eax
  800aca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800acd:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad2:	e9 6e ff ff ff       	jmp    800a45 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	8b 00                	mov    (%eax),%eax
  800adc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	8d 40 04             	lea    0x4(%eax),%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800af0:	b8 10 00 00 00       	mov    $0x10,%eax
  800af5:	e9 4b ff ff ff       	jmp    800a45 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	83 c0 04             	add    $0x4,%eax
  800b00:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b03:	8b 45 14             	mov    0x14(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	85 c0                	test   %eax,%eax
  800b0a:	74 14                	je     800b20 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800b0c:	8b 13                	mov    (%ebx),%edx
  800b0e:	83 fa 7f             	cmp    $0x7f,%edx
  800b11:	7f 37                	jg     800b4a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800b13:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800b15:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b18:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1b:	e9 43 ff ff ff       	jmp    800a63 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800b20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b25:	bf 85 13 80 00       	mov    $0x801385,%edi
							putch(ch, putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	53                   	push   %ebx
  800b2e:	50                   	push   %eax
  800b2f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b31:	83 c7 01             	add    $0x1,%edi
  800b34:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	85 c0                	test   %eax,%eax
  800b3d:	75 eb                	jne    800b2a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800b3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b42:	89 45 14             	mov    %eax,0x14(%ebp)
  800b45:	e9 19 ff ff ff       	jmp    800a63 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800b4a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800b4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b51:	bf bd 13 80 00       	mov    $0x8013bd,%edi
							putch(ch, putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	53                   	push   %ebx
  800b5a:	50                   	push   %eax
  800b5b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800b5d:	83 c7 01             	add    $0x1,%edi
  800b60:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	85 c0                	test   %eax,%eax
  800b69:	75 eb                	jne    800b56 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800b6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b71:	e9 ed fe ff ff       	jmp    800a63 <vprintfmt+0x446>
			putch(ch, putdat);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	53                   	push   %ebx
  800b7a:	6a 25                	push   $0x25
  800b7c:	ff d6                	call   *%esi
			break;
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	e9 dd fe ff ff       	jmp    800a63 <vprintfmt+0x446>
			putch('%', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	53                   	push   %ebx
  800b8a:	6a 25                	push   $0x25
  800b8c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	89 f8                	mov    %edi,%eax
  800b93:	eb 03                	jmp    800b98 <vprintfmt+0x57b>
  800b95:	83 e8 01             	sub    $0x1,%eax
  800b98:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b9c:	75 f7                	jne    800b95 <vprintfmt+0x578>
  800b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ba1:	e9 bd fe ff ff       	jmp    800a63 <vprintfmt+0x446>
}
  800ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 18             	sub    $0x18,%esp
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bbd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bc1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bcb:	85 c0                	test   %eax,%eax
  800bcd:	74 26                	je     800bf5 <vsnprintf+0x47>
  800bcf:	85 d2                	test   %edx,%edx
  800bd1:	7e 22                	jle    800bf5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd3:	ff 75 14             	pushl  0x14(%ebp)
  800bd6:	ff 75 10             	pushl  0x10(%ebp)
  800bd9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bdc:	50                   	push   %eax
  800bdd:	68 e3 05 80 00       	push   $0x8005e3
  800be2:	e8 36 fa ff ff       	call   80061d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf0:	83 c4 10             	add    $0x10,%esp
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    
		return -E_INVAL;
  800bf5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bfa:	eb f7                	jmp    800bf3 <vsnprintf+0x45>

00800bfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c02:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c05:	50                   	push   %eax
  800c06:	ff 75 10             	pushl  0x10(%ebp)
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 9a ff ff ff       	call   800bae <vsnprintf>
	va_end(ap);

	return rc;
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c25:	74 05                	je     800c2c <strlen+0x16>
		n++;
  800c27:	83 c0 01             	add    $0x1,%eax
  800c2a:	eb f5                	jmp    800c21 <strlen+0xb>
	return n;
}
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	39 c2                	cmp    %eax,%edx
  800c3e:	74 0d                	je     800c4d <strnlen+0x1f>
  800c40:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800c44:	74 05                	je     800c4b <strnlen+0x1d>
		n++;
  800c46:	83 c2 01             	add    $0x1,%edx
  800c49:	eb f1                	jmp    800c3c <strnlen+0xe>
  800c4b:	89 d0                	mov    %edx,%eax
	return n;
}
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	53                   	push   %ebx
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c59:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c62:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c65:	83 c2 01             	add    $0x1,%edx
  800c68:	84 c9                	test   %cl,%cl
  800c6a:	75 f2                	jne    800c5e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c6c:	5b                   	pop    %ebx
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	53                   	push   %ebx
  800c73:	83 ec 10             	sub    $0x10,%esp
  800c76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c79:	53                   	push   %ebx
  800c7a:	e8 97 ff ff ff       	call   800c16 <strlen>
  800c7f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	01 d8                	add    %ebx,%eax
  800c87:	50                   	push   %eax
  800c88:	e8 c2 ff ff ff       	call   800c4f <strcpy>
	return dst;
}
  800c8d:	89 d8                	mov    %ebx,%eax
  800c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	89 c6                	mov    %eax,%esi
  800ca1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca4:	89 c2                	mov    %eax,%edx
  800ca6:	39 f2                	cmp    %esi,%edx
  800ca8:	74 11                	je     800cbb <strncpy+0x27>
		*dst++ = *src;
  800caa:	83 c2 01             	add    $0x1,%edx
  800cad:	0f b6 19             	movzbl (%ecx),%ebx
  800cb0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cb3:	80 fb 01             	cmp    $0x1,%bl
  800cb6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800cb9:	eb eb                	jmp    800ca6 <strncpy+0x12>
	}
	return ret;
}
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	8b 75 08             	mov    0x8(%ebp),%esi
  800cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cca:	8b 55 10             	mov    0x10(%ebp),%edx
  800ccd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ccf:	85 d2                	test   %edx,%edx
  800cd1:	74 21                	je     800cf4 <strlcpy+0x35>
  800cd3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cd7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cd9:	39 c2                	cmp    %eax,%edx
  800cdb:	74 14                	je     800cf1 <strlcpy+0x32>
  800cdd:	0f b6 19             	movzbl (%ecx),%ebx
  800ce0:	84 db                	test   %bl,%bl
  800ce2:	74 0b                	je     800cef <strlcpy+0x30>
			*dst++ = *src++;
  800ce4:	83 c1 01             	add    $0x1,%ecx
  800ce7:	83 c2 01             	add    $0x1,%edx
  800cea:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ced:	eb ea                	jmp    800cd9 <strlcpy+0x1a>
  800cef:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cf1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf4:	29 f0                	sub    %esi,%eax
}
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d03:	0f b6 01             	movzbl (%ecx),%eax
  800d06:	84 c0                	test   %al,%al
  800d08:	74 0c                	je     800d16 <strcmp+0x1c>
  800d0a:	3a 02                	cmp    (%edx),%al
  800d0c:	75 08                	jne    800d16 <strcmp+0x1c>
		p++, q++;
  800d0e:	83 c1 01             	add    $0x1,%ecx
  800d11:	83 c2 01             	add    $0x1,%edx
  800d14:	eb ed                	jmp    800d03 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	0f b6 c0             	movzbl %al,%eax
  800d19:	0f b6 12             	movzbl (%edx),%edx
  800d1c:	29 d0                	sub    %edx,%eax
}
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	53                   	push   %ebx
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2a:	89 c3                	mov    %eax,%ebx
  800d2c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 06                	jmp    800d37 <strncmp+0x17>
		n--, p++, q++;
  800d31:	83 c0 01             	add    $0x1,%eax
  800d34:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d37:	39 d8                	cmp    %ebx,%eax
  800d39:	74 16                	je     800d51 <strncmp+0x31>
  800d3b:	0f b6 08             	movzbl (%eax),%ecx
  800d3e:	84 c9                	test   %cl,%cl
  800d40:	74 04                	je     800d46 <strncmp+0x26>
  800d42:	3a 0a                	cmp    (%edx),%cl
  800d44:	74 eb                	je     800d31 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d46:	0f b6 00             	movzbl (%eax),%eax
  800d49:	0f b6 12             	movzbl (%edx),%edx
  800d4c:	29 d0                	sub    %edx,%eax
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		return 0;
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	eb f6                	jmp    800d4e <strncmp+0x2e>

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d62:	0f b6 10             	movzbl (%eax),%edx
  800d65:	84 d2                	test   %dl,%dl
  800d67:	74 09                	je     800d72 <strchr+0x1a>
		if (*s == c)
  800d69:	38 ca                	cmp    %cl,%dl
  800d6b:	74 0a                	je     800d77 <strchr+0x1f>
	for (; *s; s++)
  800d6d:	83 c0 01             	add    $0x1,%eax
  800d70:	eb f0                	jmp    800d62 <strchr+0xa>
			return (char *) s;
	return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d83:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d86:	38 ca                	cmp    %cl,%dl
  800d88:	74 09                	je     800d93 <strfind+0x1a>
  800d8a:	84 d2                	test   %dl,%dl
  800d8c:	74 05                	je     800d93 <strfind+0x1a>
	for (; *s; s++)
  800d8e:	83 c0 01             	add    $0x1,%eax
  800d91:	eb f0                	jmp    800d83 <strfind+0xa>
			break;
	return (char *) s;
}
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    

00800d95 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800da1:	85 c9                	test   %ecx,%ecx
  800da3:	74 31                	je     800dd6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800da5:	89 f8                	mov    %edi,%eax
  800da7:	09 c8                	or     %ecx,%eax
  800da9:	a8 03                	test   $0x3,%al
  800dab:	75 23                	jne    800dd0 <memset+0x3b>
		c &= 0xFF;
  800dad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800db1:	89 d3                	mov    %edx,%ebx
  800db3:	c1 e3 08             	shl    $0x8,%ebx
  800db6:	89 d0                	mov    %edx,%eax
  800db8:	c1 e0 18             	shl    $0x18,%eax
  800dbb:	89 d6                	mov    %edx,%esi
  800dbd:	c1 e6 10             	shl    $0x10,%esi
  800dc0:	09 f0                	or     %esi,%eax
  800dc2:	09 c2                	or     %eax,%edx
  800dc4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dc6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800dc9:	89 d0                	mov    %edx,%eax
  800dcb:	fc                   	cld    
  800dcc:	f3 ab                	rep stos %eax,%es:(%edi)
  800dce:	eb 06                	jmp    800dd6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	fc                   	cld    
  800dd4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dd6:	89 f8                	mov    %edi,%eax
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800deb:	39 c6                	cmp    %eax,%esi
  800ded:	73 32                	jae    800e21 <memmove+0x44>
  800def:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800df2:	39 c2                	cmp    %eax,%edx
  800df4:	76 2b                	jbe    800e21 <memmove+0x44>
		s += n;
		d += n;
  800df6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df9:	89 fe                	mov    %edi,%esi
  800dfb:	09 ce                	or     %ecx,%esi
  800dfd:	09 d6                	or     %edx,%esi
  800dff:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e05:	75 0e                	jne    800e15 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e07:	83 ef 04             	sub    $0x4,%edi
  800e0a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e0d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800e10:	fd                   	std    
  800e11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e13:	eb 09                	jmp    800e1e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e15:	83 ef 01             	sub    $0x1,%edi
  800e18:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e1b:	fd                   	std    
  800e1c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e1e:	fc                   	cld    
  800e1f:	eb 1a                	jmp    800e3b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	09 ca                	or     %ecx,%edx
  800e25:	09 f2                	or     %esi,%edx
  800e27:	f6 c2 03             	test   $0x3,%dl
  800e2a:	75 0a                	jne    800e36 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e2c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e2f:	89 c7                	mov    %eax,%edi
  800e31:	fc                   	cld    
  800e32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e34:	eb 05                	jmp    800e3b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800e36:	89 c7                	mov    %eax,%edi
  800e38:	fc                   	cld    
  800e39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e45:	ff 75 10             	pushl  0x10(%ebp)
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	ff 75 08             	pushl  0x8(%ebp)
  800e4e:	e8 8a ff ff ff       	call   800ddd <memmove>
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e60:	89 c6                	mov    %eax,%esi
  800e62:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e65:	39 f0                	cmp    %esi,%eax
  800e67:	74 1c                	je     800e85 <memcmp+0x30>
		if (*s1 != *s2)
  800e69:	0f b6 08             	movzbl (%eax),%ecx
  800e6c:	0f b6 1a             	movzbl (%edx),%ebx
  800e6f:	38 d9                	cmp    %bl,%cl
  800e71:	75 08                	jne    800e7b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e73:	83 c0 01             	add    $0x1,%eax
  800e76:	83 c2 01             	add    $0x1,%edx
  800e79:	eb ea                	jmp    800e65 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e7b:	0f b6 c1             	movzbl %cl,%eax
  800e7e:	0f b6 db             	movzbl %bl,%ebx
  800e81:	29 d8                	sub    %ebx,%eax
  800e83:	eb 05                	jmp    800e8a <memcmp+0x35>
	}

	return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e97:	89 c2                	mov    %eax,%edx
  800e99:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e9c:	39 d0                	cmp    %edx,%eax
  800e9e:	73 09                	jae    800ea9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea0:	38 08                	cmp    %cl,(%eax)
  800ea2:	74 05                	je     800ea9 <memfind+0x1b>
	for (; s < ends; s++)
  800ea4:	83 c0 01             	add    $0x1,%eax
  800ea7:	eb f3                	jmp    800e9c <memfind+0xe>
			break;
	return (void *) s;
}
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb7:	eb 03                	jmp    800ebc <strtol+0x11>
		s++;
  800eb9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ebc:	0f b6 01             	movzbl (%ecx),%eax
  800ebf:	3c 20                	cmp    $0x20,%al
  800ec1:	74 f6                	je     800eb9 <strtol+0xe>
  800ec3:	3c 09                	cmp    $0x9,%al
  800ec5:	74 f2                	je     800eb9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ec7:	3c 2b                	cmp    $0x2b,%al
  800ec9:	74 2a                	je     800ef5 <strtol+0x4a>
	int neg = 0;
  800ecb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ed0:	3c 2d                	cmp    $0x2d,%al
  800ed2:	74 2b                	je     800eff <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eda:	75 0f                	jne    800eeb <strtol+0x40>
  800edc:	80 39 30             	cmpb   $0x30,(%ecx)
  800edf:	74 28                	je     800f09 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ee1:	85 db                	test   %ebx,%ebx
  800ee3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee8:	0f 44 d8             	cmove  %eax,%ebx
  800eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ef3:	eb 50                	jmp    800f45 <strtol+0x9a>
		s++;
  800ef5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ef8:	bf 00 00 00 00       	mov    $0x0,%edi
  800efd:	eb d5                	jmp    800ed4 <strtol+0x29>
		s++, neg = 1;
  800eff:	83 c1 01             	add    $0x1,%ecx
  800f02:	bf 01 00 00 00       	mov    $0x1,%edi
  800f07:	eb cb                	jmp    800ed4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f09:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f0d:	74 0e                	je     800f1d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800f0f:	85 db                	test   %ebx,%ebx
  800f11:	75 d8                	jne    800eeb <strtol+0x40>
		s++, base = 8;
  800f13:	83 c1 01             	add    $0x1,%ecx
  800f16:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f1b:	eb ce                	jmp    800eeb <strtol+0x40>
		s += 2, base = 16;
  800f1d:	83 c1 02             	add    $0x2,%ecx
  800f20:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f25:	eb c4                	jmp    800eeb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800f27:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f2a:	89 f3                	mov    %esi,%ebx
  800f2c:	80 fb 19             	cmp    $0x19,%bl
  800f2f:	77 29                	ja     800f5a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800f31:	0f be d2             	movsbl %dl,%edx
  800f34:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f37:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f3a:	7d 30                	jge    800f6c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800f3c:	83 c1 01             	add    $0x1,%ecx
  800f3f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f43:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f45:	0f b6 11             	movzbl (%ecx),%edx
  800f48:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f4b:	89 f3                	mov    %esi,%ebx
  800f4d:	80 fb 09             	cmp    $0x9,%bl
  800f50:	77 d5                	ja     800f27 <strtol+0x7c>
			dig = *s - '0';
  800f52:	0f be d2             	movsbl %dl,%edx
  800f55:	83 ea 30             	sub    $0x30,%edx
  800f58:	eb dd                	jmp    800f37 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800f5a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f5d:	89 f3                	mov    %esi,%ebx
  800f5f:	80 fb 19             	cmp    $0x19,%bl
  800f62:	77 08                	ja     800f6c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800f64:	0f be d2             	movsbl %dl,%edx
  800f67:	83 ea 37             	sub    $0x37,%edx
  800f6a:	eb cb                	jmp    800f37 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f70:	74 05                	je     800f77 <strtol+0xcc>
		*endptr = (char *) s;
  800f72:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f75:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f77:	89 c2                	mov    %eax,%edx
  800f79:	f7 da                	neg    %edx
  800f7b:	85 ff                	test   %edi,%edi
  800f7d:	0f 45 c2             	cmovne %edx,%eax
}
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
  800f85:	66 90                	xchg   %ax,%ax
  800f87:	66 90                	xchg   %ax,%ax
  800f89:	66 90                	xchg   %ax,%ax
  800f8b:	66 90                	xchg   %ax,%ax
  800f8d:	66 90                	xchg   %ax,%ax
  800f8f:	90                   	nop

00800f90 <__udivdi3>:
  800f90:	55                   	push   %ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 1c             	sub    $0x1c,%esp
  800f97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fa7:	85 d2                	test   %edx,%edx
  800fa9:	75 4d                	jne    800ff8 <__udivdi3+0x68>
  800fab:	39 f3                	cmp    %esi,%ebx
  800fad:	76 19                	jbe    800fc8 <__udivdi3+0x38>
  800faf:	31 ff                	xor    %edi,%edi
  800fb1:	89 e8                	mov    %ebp,%eax
  800fb3:	89 f2                	mov    %esi,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 fa                	mov    %edi,%edx
  800fb9:	83 c4 1c             	add    $0x1c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	89 d9                	mov    %ebx,%ecx
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	75 0b                	jne    800fd9 <__udivdi3+0x49>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f3                	div    %ebx
  800fd7:	89 c1                	mov    %eax,%ecx
  800fd9:	31 d2                	xor    %edx,%edx
  800fdb:	89 f0                	mov    %esi,%eax
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 c6                	mov    %eax,%esi
  800fe1:	89 e8                	mov    %ebp,%eax
  800fe3:	89 f7                	mov    %esi,%edi
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	83 c4 1c             	add    $0x1c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	39 f2                	cmp    %esi,%edx
  800ffa:	77 1c                	ja     801018 <__udivdi3+0x88>
  800ffc:	0f bd fa             	bsr    %edx,%edi
  800fff:	83 f7 1f             	xor    $0x1f,%edi
  801002:	75 2c                	jne    801030 <__udivdi3+0xa0>
  801004:	39 f2                	cmp    %esi,%edx
  801006:	72 06                	jb     80100e <__udivdi3+0x7e>
  801008:	31 c0                	xor    %eax,%eax
  80100a:	39 eb                	cmp    %ebp,%ebx
  80100c:	77 a9                	ja     800fb7 <__udivdi3+0x27>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	eb a2                	jmp    800fb7 <__udivdi3+0x27>
  801015:	8d 76 00             	lea    0x0(%esi),%esi
  801018:	31 ff                	xor    %edi,%edi
  80101a:	31 c0                	xor    %eax,%eax
  80101c:	89 fa                	mov    %edi,%edx
  80101e:	83 c4 1c             	add    $0x1c,%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
  801026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80102d:	8d 76 00             	lea    0x0(%esi),%esi
  801030:	89 f9                	mov    %edi,%ecx
  801032:	b8 20 00 00 00       	mov    $0x20,%eax
  801037:	29 f8                	sub    %edi,%eax
  801039:	d3 e2                	shl    %cl,%edx
  80103b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80103f:	89 c1                	mov    %eax,%ecx
  801041:	89 da                	mov    %ebx,%edx
  801043:	d3 ea                	shr    %cl,%edx
  801045:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801049:	09 d1                	or     %edx,%ecx
  80104b:	89 f2                	mov    %esi,%edx
  80104d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801051:	89 f9                	mov    %edi,%ecx
  801053:	d3 e3                	shl    %cl,%ebx
  801055:	89 c1                	mov    %eax,%ecx
  801057:	d3 ea                	shr    %cl,%edx
  801059:	89 f9                	mov    %edi,%ecx
  80105b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80105f:	89 eb                	mov    %ebp,%ebx
  801061:	d3 e6                	shl    %cl,%esi
  801063:	89 c1                	mov    %eax,%ecx
  801065:	d3 eb                	shr    %cl,%ebx
  801067:	09 de                	or     %ebx,%esi
  801069:	89 f0                	mov    %esi,%eax
  80106b:	f7 74 24 08          	divl   0x8(%esp)
  80106f:	89 d6                	mov    %edx,%esi
  801071:	89 c3                	mov    %eax,%ebx
  801073:	f7 64 24 0c          	mull   0xc(%esp)
  801077:	39 d6                	cmp    %edx,%esi
  801079:	72 15                	jb     801090 <__udivdi3+0x100>
  80107b:	89 f9                	mov    %edi,%ecx
  80107d:	d3 e5                	shl    %cl,%ebp
  80107f:	39 c5                	cmp    %eax,%ebp
  801081:	73 04                	jae    801087 <__udivdi3+0xf7>
  801083:	39 d6                	cmp    %edx,%esi
  801085:	74 09                	je     801090 <__udivdi3+0x100>
  801087:	89 d8                	mov    %ebx,%eax
  801089:	31 ff                	xor    %edi,%edi
  80108b:	e9 27 ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  801090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801093:	31 ff                	xor    %edi,%edi
  801095:	e9 1d ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  80109a:	66 90                	xchg   %ax,%ax
  80109c:	66 90                	xchg   %ax,%ax
  80109e:	66 90                	xchg   %ax,%ax

008010a0 <__umoddi3>:
  8010a0:	55                   	push   %ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 1c             	sub    $0x1c,%esp
  8010a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010b7:	89 da                	mov    %ebx,%edx
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 43                	jne    801100 <__umoddi3+0x60>
  8010bd:	39 df                	cmp    %ebx,%edi
  8010bf:	76 17                	jbe    8010d8 <__umoddi3+0x38>
  8010c1:	89 f0                	mov    %esi,%eax
  8010c3:	f7 f7                	div    %edi
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	31 d2                	xor    %edx,%edx
  8010c9:	83 c4 1c             	add    $0x1c,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	89 fd                	mov    %edi,%ebp
  8010da:	85 ff                	test   %edi,%edi
  8010dc:	75 0b                	jne    8010e9 <__umoddi3+0x49>
  8010de:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e3:	31 d2                	xor    %edx,%edx
  8010e5:	f7 f7                	div    %edi
  8010e7:	89 c5                	mov    %eax,%ebp
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	31 d2                	xor    %edx,%edx
  8010ed:	f7 f5                	div    %ebp
  8010ef:	89 f0                	mov    %esi,%eax
  8010f1:	f7 f5                	div    %ebp
  8010f3:	89 d0                	mov    %edx,%eax
  8010f5:	eb d0                	jmp    8010c7 <__umoddi3+0x27>
  8010f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010fe:	66 90                	xchg   %ax,%ax
  801100:	89 f1                	mov    %esi,%ecx
  801102:	39 d8                	cmp    %ebx,%eax
  801104:	76 0a                	jbe    801110 <__umoddi3+0x70>
  801106:	89 f0                	mov    %esi,%eax
  801108:	83 c4 1c             	add    $0x1c,%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    
  801110:	0f bd e8             	bsr    %eax,%ebp
  801113:	83 f5 1f             	xor    $0x1f,%ebp
  801116:	75 20                	jne    801138 <__umoddi3+0x98>
  801118:	39 d8                	cmp    %ebx,%eax
  80111a:	0f 82 b0 00 00 00    	jb     8011d0 <__umoddi3+0x130>
  801120:	39 f7                	cmp    %esi,%edi
  801122:	0f 86 a8 00 00 00    	jbe    8011d0 <__umoddi3+0x130>
  801128:	89 c8                	mov    %ecx,%eax
  80112a:	83 c4 1c             	add    $0x1c,%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    
  801132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801138:	89 e9                	mov    %ebp,%ecx
  80113a:	ba 20 00 00 00       	mov    $0x20,%edx
  80113f:	29 ea                	sub    %ebp,%edx
  801141:	d3 e0                	shl    %cl,%eax
  801143:	89 44 24 08          	mov    %eax,0x8(%esp)
  801147:	89 d1                	mov    %edx,%ecx
  801149:	89 f8                	mov    %edi,%eax
  80114b:	d3 e8                	shr    %cl,%eax
  80114d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801151:	89 54 24 04          	mov    %edx,0x4(%esp)
  801155:	8b 54 24 04          	mov    0x4(%esp),%edx
  801159:	09 c1                	or     %eax,%ecx
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801161:	89 e9                	mov    %ebp,%ecx
  801163:	d3 e7                	shl    %cl,%edi
  801165:	89 d1                	mov    %edx,%ecx
  801167:	d3 e8                	shr    %cl,%eax
  801169:	89 e9                	mov    %ebp,%ecx
  80116b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80116f:	d3 e3                	shl    %cl,%ebx
  801171:	89 c7                	mov    %eax,%edi
  801173:	89 d1                	mov    %edx,%ecx
  801175:	89 f0                	mov    %esi,%eax
  801177:	d3 e8                	shr    %cl,%eax
  801179:	89 e9                	mov    %ebp,%ecx
  80117b:	89 fa                	mov    %edi,%edx
  80117d:	d3 e6                	shl    %cl,%esi
  80117f:	09 d8                	or     %ebx,%eax
  801181:	f7 74 24 08          	divl   0x8(%esp)
  801185:	89 d1                	mov    %edx,%ecx
  801187:	89 f3                	mov    %esi,%ebx
  801189:	f7 64 24 0c          	mull   0xc(%esp)
  80118d:	89 c6                	mov    %eax,%esi
  80118f:	89 d7                	mov    %edx,%edi
  801191:	39 d1                	cmp    %edx,%ecx
  801193:	72 06                	jb     80119b <__umoddi3+0xfb>
  801195:	75 10                	jne    8011a7 <__umoddi3+0x107>
  801197:	39 c3                	cmp    %eax,%ebx
  801199:	73 0c                	jae    8011a7 <__umoddi3+0x107>
  80119b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80119f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011a3:	89 d7                	mov    %edx,%edi
  8011a5:	89 c6                	mov    %eax,%esi
  8011a7:	89 ca                	mov    %ecx,%edx
  8011a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011ae:	29 f3                	sub    %esi,%ebx
  8011b0:	19 fa                	sbb    %edi,%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	d3 e0                	shl    %cl,%eax
  8011b6:	89 e9                	mov    %ebp,%ecx
  8011b8:	d3 eb                	shr    %cl,%ebx
  8011ba:	d3 ea                	shr    %cl,%edx
  8011bc:	09 d8                	or     %ebx,%eax
  8011be:	83 c4 1c             	add    $0x1c,%esp
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
  8011c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011cd:	8d 76 00             	lea    0x0(%esi),%esi
  8011d0:	89 da                	mov    %ebx,%edx
  8011d2:	29 fe                	sub    %edi,%esi
  8011d4:	19 c2                	sbb    %eax,%edx
  8011d6:	89 f1                	mov    %esi,%ecx
  8011d8:	89 c8                	mov    %ecx,%eax
  8011da:	e9 4b ff ff ff       	jmp    80112a <__umoddi3+0x8a>
